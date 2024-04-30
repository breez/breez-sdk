use std::cmp::max;
use std::ops::Add;
use std::str::FromStr;

use anyhow::{anyhow, ensure, Result};
use chrono::{DateTime, Duration, Utc};
use ripemd::Digest;
use ripemd::Ripemd160;
use rusqlite::types::{FromSql, FromSqlError, FromSqlResult, ToSqlOutput, ValueRef};
use rusqlite::ToSql;
use serde::{Deserialize, Serialize};
use strum_macros::{Display, EnumString};

use crate::bitcoin::blockdata::opcodes;
use crate::bitcoin::blockdata::script::Builder;
use crate::bitcoin::hashes::hex::{FromHex, ToHex};
use crate::bitcoin::hashes::{sha256, Hash};
use crate::bitcoin::secp256k1::{PublicKey, Secp256k1, SecretKey};
use crate::bitcoin::{Address, Script};
use crate::breez_services::BreezServer;
use crate::error::SdkResult;
use crate::fiat::{FiatCurrency, Rate};
use crate::grpc::{
    self, GetReverseRoutingNodeRequest, PaymentInformation, RegisterPaymentNotificationResponse,
    RegisterPaymentReply,
};
use crate::lnurl::pay::model::SuccessActionProcessed;
use crate::lsp::LspInformation;
use crate::models::Network::*;
use crate::persist::swap::SwapChainInfo;
use crate::swap_in::error::{SwapError, SwapResult};
use crate::swap_out::boltzswap::{BoltzApiCreateReverseSwapResponse, BoltzApiReverseSwapStatus};
use crate::swap_out::error::{ReverseSwapError, ReverseSwapResult};
use crate::{
    ensure_sdk, LNInvoice, LnUrlErrorData, LnUrlPayRequestData, LnUrlWithdrawRequestData, RouteHint,
};

pub const SWAP_PAYMENT_FEE_EXPIRY_SECONDS: u32 = 60 * 60 * 24 * 2; // 2 days
pub const INVOICE_PAYMENT_FEE_EXPIRY_SECONDS: u32 = 60 * 60; // 60 minutes

/// Different types of supported payments
#[derive(Clone, PartialEq, Eq, Debug, EnumString, Display, Deserialize, Serialize, Hash)]
pub enum PaymentType {
    Sent,
    Received,
    ClosedChannel,
}

#[derive(Debug)]
pub struct CustomMessage {
    pub peer_id: Vec<u8>,
    pub message_type: u16,
    pub payload: Vec<u8>,
}

#[derive(Debug)]
pub struct Peer {
    pub id: Vec<u8>,
    pub channels: Vec<Channel>,
}

/// Trait covering LSP-related functionality
#[tonic::async_trait]
pub trait LspAPI: Send + Sync {
    async fn list_lsps(&self, node_pubkey: String) -> SdkResult<Vec<LspInformation>>;
    /// Register for webhook callbacks at the given `webhook_url` whenever a new payment is received
    async fn register_payment_notifications(
        &self,
        lsp_id: String,
        lsp_pubkey: Vec<u8>,
        webhook_url: String,
        webhook_url_signature: String,
    ) -> SdkResult<RegisterPaymentNotificationResponse>;
    async fn register_payment(
        &self,
        lsp_id: String,
        lsp_pubkey: Vec<u8>,
        payment_info: PaymentInformation,
    ) -> SdkResult<RegisterPaymentReply>;
}

/// Trait covering fiat-related functionality
#[tonic::async_trait]
pub trait FiatAPI: Send + Sync {
    /// List all supported fiat currencies for which there is a known exchange rate.
    async fn list_fiat_currencies(&self) -> SdkResult<Vec<FiatCurrency>>;

    /// Get the live rates from the server.
    async fn fetch_fiat_rates(&self) -> SdkResult<Vec<Rate>>;
}

/// Summary of an ongoing swap
pub struct Swap {
    pub bitcoin_address: String,
    pub swapper_pubkey: Vec<u8>,
    pub lock_height: i64,
    pub error_message: String,
    pub required_reserve: i64,
    /// Absolute minimum amount, in sats, allowed by the swapper for a successful swap
    pub swapper_min_payable: i64,
    /// Absolute maximum amount, in sats, allowed by the swapper for a successful swap
    pub swapper_max_payable: i64,
}

/// Trait covering functionality involving swaps
#[tonic::async_trait]
pub trait SwapperAPI: Send + Sync {
    async fn create_swap(
        &self,
        hash: Vec<u8>,
        payer_pubkey: Vec<u8>,
        node_pubkey: String,
    ) -> SwapResult<Swap>;

    async fn complete_swap(&self, bolt11: String) -> Result<()>;
}

/// Details about the reverse swap fees and parameters, at this point in time
#[derive(Clone, PartialEq, Debug, Serialize)]
pub struct ReverseSwapPairInfo {
    /// Minimum amount of sats a reverse swap is allowed to have given the current feerate conditions
    pub min: u64,
    /// Maximum amount of sats a reverse swap is allowed to have given the current feerate conditions
    pub max: u64,
    /// Hash of the pair info JSON
    pub fees_hash: String,
    /// Percentage fee for the reverse swap service
    pub fees_percentage: f64,
    /// Miner fees in sats for locking up funds
    pub fees_lockup: u64,
    /// Miner fees in sats for claiming funds. Estimate or exact value, depending on the request args.
    pub fees_claim: u64,
    /// Total fees for the reverse swap, in sats, based on the given send amount.
    ///
    /// The field is set only when the [ReverseSwapFeesRequest] `send_amount_sat` is known.
    ///
    /// If the [ReverseSwapFeesRequest] has the `claim_tx_feerate` empty, this is an estimate. If
    /// the `claim_tx_feerate` is set, this is the exact value of the total reverse swap fees.
    pub total_fees: Option<u64>,
}

/// Details of past or ongoing reverse swaps, as stored in the Breez local DB
#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
pub struct FullReverseSwapInfo {
    /// The reverse swap ID, as reported by the Boltz API in case of a successful creation
    pub id: String,

    /// The blockheight at the moment the reverse swap was created
    pub created_at_block_height: u32,

    /// Locally generated preimage, revealed in the last step of the reverse swap
    pub preimage: Vec<u8>,

    /// Locally generated private key, used to sign the claim tx
    pub private_key: Vec<u8>,

    /// On-chain destination address, to which the reverse swap will finally send funds to
    pub claim_pubkey: String,

    pub timeout_block_height: u32,

    /// The HODL invoice
    pub invoice: String,
    pub redeem_script: String,

    /// Amount of sats that will be locked.
    ///
    /// The final amount sent will be this value minus the claim tx fees.
    pub onchain_amount_sat: u64,

    /// User-specified feerate for the claim tx.
    ///
    /// Used for backward-compatibility with older rev swaps. Superseded by `receive_amount_sat`.
    pub sat_per_vbyte: Option<u32>,

    /// Amount that will be received onchain in the destination address, at the end of the reverse swap.
    pub receive_amount_sat: Option<u64>,

    pub cache: ReverseSwapInfoCached,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
pub struct ReverseSwapInfoCached {
    pub status: ReverseSwapStatus,
    pub lockup_txid: Option<String>,
    pub claim_txid: Option<String>,
}

impl FullReverseSwapInfo {
    /// Builds the expected redeem script
    fn build_expected_reverse_swap_script(
        preimage_hash: Vec<u8>,
        compressed_pub_key: Vec<u8>,
        sig: Vec<u8>,
        lock_height: u32,
    ) -> ReverseSwapResult<Script> {
        let mut ripemd160_hasher = Ripemd160::new();
        ripemd160_hasher.update(preimage_hash);
        let ripemd160_hash = ripemd160_hasher.finalize();

        // Remove empty non-significant bytes
        let timeout_height_le_hex = lock_height.to_le_bytes().to_hex();
        let timeout_height_le_hex_trimmed = timeout_height_le_hex.trim_end_matches("00");
        let timeout_height_le_bytes = hex::decode(timeout_height_le_hex_trimmed)?;

        Ok(Builder::new()
            .push_opcode(opcodes::all::OP_SIZE)
            .push_slice(&[0x20])
            .push_opcode(opcodes::all::OP_EQUAL)
            .push_opcode(opcodes::all::OP_IF)
            .push_opcode(opcodes::all::OP_HASH160)
            .push_slice(&ripemd160_hash[..])
            .push_opcode(opcodes::all::OP_EQUALVERIFY)
            .push_slice(&compressed_pub_key[..])
            .push_opcode(opcodes::all::OP_ELSE)
            .push_opcode(opcodes::all::OP_DROP)
            .push_slice(&timeout_height_le_bytes)
            .push_opcode(opcodes::all::OP_CLTV)
            .push_opcode(opcodes::all::OP_DROP)
            .push_slice(&sig[..])
            .push_opcode(opcodes::all::OP_ENDIF)
            .push_opcode(opcodes::all::OP_CHECKSIG)
            .into_script())
    }

    /// Validates the redeem script and the lockup address
    ///
    /// ### Arguments
    ///
    /// * `received_lockup_address` - The lockup address, as received from Boltz in the create rev swap API response
    /// * `network` - The network type which is one of (Bitcoin, Testnet, Signet, Regtest)
    pub(crate) fn validate_redeem_script(
        &self,
        received_lockup_address: String,
        network: Network,
    ) -> ReverseSwapResult<()> {
        let redeem_script_received = Script::from_hex(&self.redeem_script)?;
        let asm = redeem_script_received.asm();
        debug!("received asm = {asm:?}");

        let sk = SecretKey::from_slice(&self.private_key)?;
        let pk = PublicKey::from_secret_key(&Secp256k1::new(), &sk);

        // The 18th asm element is the refund address, provided by the Boltz service
        let asm_elements: Vec<&str> = asm.split(' ').collect();
        let refund_address = asm_elements.get(18).unwrap_or(&"").to_string();
        let refund_address_bytes = hex::decode(refund_address)?;

        let redeem_script_expected = Self::build_expected_reverse_swap_script(
            self.get_preimage_hash().to_vec(), // Preimage hash
            pk.serialize().to_vec(),           // Compressed pubkey
            refund_address_bytes,
            self.timeout_block_height,
        )?;
        debug!("expected asm = {:?}", redeem_script_expected.asm());

        match redeem_script_received.eq(&redeem_script_expected) {
            true => {
                let lockup_addr_expected = &received_lockup_address;
                let lockup_addr_from_script =
                    &Address::p2wsh(&redeem_script_received, network.into()).to_string();

                match lockup_addr_from_script == lockup_addr_expected {
                    true => Ok(()),
                    false => Err(ReverseSwapError::UnexpectedLockupAddress),
                }
            }
            false => Err(ReverseSwapError::UnexpectedRedeemScript),
        }
    }

    pub(crate) fn validate_invoice_amount(
        &self,
        expected_amount_msat: u64,
    ) -> ReverseSwapResult<()> {
        let inv: crate::lightning_invoice::Bolt11Invoice = self.invoice.parse()?;

        // Validate if received invoice has the same amount as requested by the user
        let amount_from_invoice_msat = inv.amount_milli_satoshis().unwrap_or_default();
        match amount_from_invoice_msat == expected_amount_msat {
            false => Err(ReverseSwapError::UnexpectedInvoiceAmount(anyhow!(
                "Does not match the request"
            ))),
            true => Ok(()),
        }
    }

    /// Validates the received HODL invoice:
    ///
    /// - checks if amount matches the amount requested by the user
    /// - checks if the payment hash is the same preimage hash (derived from local secret bytes)
    /// included in the create request
    pub(crate) fn validate_invoice(&self, expected_amount_msat: u64) -> ReverseSwapResult<()> {
        self.validate_invoice_amount(expected_amount_msat)?;

        // Validate if received invoice has the same payment hash as the preimage hash in the request
        let inv: crate::lightning_invoice::Bolt11Invoice = self.invoice.parse()?;
        let preimage_hash_from_invoice = inv.payment_hash();
        let preimage_hash_from_req = &self.get_preimage_hash();
        match preimage_hash_from_invoice == preimage_hash_from_req {
            false => Err(ReverseSwapError::UnexpectedPaymentHash(anyhow!(
                "Does not match the request"
            ))),
            true => Ok(()),
        }
    }

    /// Derives the lockup address from the redeem script
    pub(crate) fn get_lockup_address(&self, network: Network) -> ReverseSwapResult<Address> {
        let redeem_script = Script::from_hex(&self.redeem_script)?;
        Ok(Address::p2wsh(&redeem_script, network.into()))
    }

    /// Get the preimage hash sent in the create request
    pub(crate) fn get_preimage_hash(&self) -> sha256::Hash {
        sha256::Hash::hash(&self.preimage)
    }

    /// Get the user-facing info struct using cached values
    pub(crate) fn get_reverse_swap_info_using_cached_values(&self) -> ReverseSwapInfo {
        ReverseSwapInfo {
            id: self.id.clone(),
            claim_pubkey: self.claim_pubkey.clone(),
            lockup_txid: self.cache.clone().lockup_txid,
            claim_txid: self.cache.claim_txid.clone(),
            onchain_amount_sat: self.onchain_amount_sat,
            status: self.cache.status,
        }
    }
}

/// Simplified version of [FullReverseSwapInfo], containing only the user-relevant fields
#[derive(Deserialize, Serialize, PartialEq, Eq, Debug, Clone)]
pub struct ReverseSwapInfo {
    pub id: String,
    pub claim_pubkey: String,
    /// The lockup tx id, available from the moment the lockup tx is seen in the mempool by the SDK
    pub lockup_txid: Option<String>,
    /// The claim tx id, available from the moment the claim tx is broadcast by the SDK
    pub claim_txid: Option<String>,
    pub onchain_amount_sat: u64,
    pub status: ReverseSwapStatus,
}

/// The possible statuses of a reverse swap, from the Breez SDK perspective.
///
/// See [BoltzApiReverseSwapStatus] for the reverse swap status from the Breez endpoint point of view.
#[derive(Clone, Copy, PartialEq, Eq, Debug, Serialize, Deserialize)]
pub enum ReverseSwapStatus {
    /// HODL invoice payment is not completed yet
    ///
    /// This is also the temporary status of a reverse swap when restoring a node, until `sync` finishes.
    Initial = 0,

    /// HODL invoice payment was successfully triggered and confirmed by Boltz, but the reverse swap
    /// is not yet complete
    InProgress = 1,

    /// An explicit error occurs (validation error, failure reported by Boltz, expiration, etc) and
    /// the initial invoice funds are returned to the sender (invoice is cancelled or payment failed)
    Cancelled = 2,

    /// Successfully completed (claim tx has been seen in the mempool)
    CompletedSeen = 3,

    /// Successfully completed (claim tx has at least one confirmation)
    CompletedConfirmed = 4,
}

impl ReverseSwapStatus {
    pub(crate) fn is_monitored_state(&self) -> bool {
        matches!(
            self,
            ReverseSwapStatus::Initial
                | ReverseSwapStatus::InProgress
                | ReverseSwapStatus::CompletedSeen
        )
    }

    pub(crate) fn is_blocking_state(&self) -> bool {
        matches!(
            self,
            ReverseSwapStatus::Initial | ReverseSwapStatus::InProgress
        )
    }
}

impl TryFrom<i32> for ReverseSwapStatus {
    type Error = anyhow::Error;

    fn try_from(value: i32) -> Result<Self, Self::Error> {
        match value {
            0 => Ok(ReverseSwapStatus::Initial),
            1 => Ok(ReverseSwapStatus::InProgress),
            2 => Ok(ReverseSwapStatus::Cancelled),
            3 => Ok(ReverseSwapStatus::CompletedSeen),
            4 => Ok(ReverseSwapStatus::CompletedConfirmed),
            _ => Err(anyhow!("illegal value")),
        }
    }
}

/// Trait covering Breez Server reverse swap functionality
#[tonic::async_trait]
pub(crate) trait ReverseSwapperRoutingAPI: Send + Sync {
    async fn fetch_reverse_routing_node(&self) -> ReverseSwapResult<Vec<u8>>;
}

#[tonic::async_trait]
impl ReverseSwapperRoutingAPI for BreezServer {
    async fn fetch_reverse_routing_node(&self) -> ReverseSwapResult<Vec<u8>> {
        Ok(self
            .get_swapper_client()
            .await?
            .get_reverse_routing_node(GetReverseRoutingNodeRequest::default())
            .await
            .map(|reply| reply.into_inner().node_id)?)
    }
}

/// Trait covering reverse swap functionality on the external service
#[tonic::async_trait]
pub(crate) trait ReverseSwapServiceAPI: Send + Sync {
    /// Lookup the most recent reverse swap pair info using the Boltz API. The fees are only valid
    /// for a set amount of time.
    async fn fetch_reverse_swap_fees(&self) -> ReverseSwapResult<ReverseSwapPairInfo>;

    /// Creates a reverse submarine swap on the remote service (Boltz).
    ///
    /// # Arguments
    ///
    /// * `send_amount_sat` - Amount that is to be swapped
    /// * `preimage_hash_hex` - Hex of preimage hash
    /// * `claim_pubkey` - Pubkey of a keypair that can allow the SDK to claim the locked funds
    /// * `pair_hash` - The hash of the exchange rate, looked-up before this call
    /// * `routing_node` - Pubkey of a LN node used as routing hint
    async fn create_reverse_swap_on_remote(
        &self,
        send_amount_sat: u64,
        preimage_hash_hex: String,
        claim_pubkey: String,
        pair_hash: String,
        routing_node: String,
    ) -> ReverseSwapResult<BoltzApiCreateReverseSwapResponse>;

    /// Performs a live lookup of the reverse swap's status on the Boltz API
    async fn get_boltz_status(&self, id: String) -> ReverseSwapResult<BoltzApiReverseSwapStatus>;

    /// Fetch the private route hints for the reverse swap node.
    async fn get_route_hints(&self, routing_node_id: String) -> ReverseSwapResult<Vec<RouteHint>>;
}

/// Internal SDK log entry
#[derive(Clone, Debug)]
pub struct LogEntry {
    pub line: String,
    pub level: String,
}

/// Configuration for the Breez Services
///
/// Use [Config::production] or [Config::staging] for default configs of the different supported
/// environments.
#[derive(Clone)]
pub struct Config {
    pub breezserver: String,
    pub chainnotifier_url: String,
    /// If set, this is the mempool.space URL that will be used.
    ///
    /// If not set, a list of mempool.space URLs will be used to provide fault-tolerance. If calls
    /// to the first URL fail, then the call will be repeated to the next URL, and so on.
    ///
    /// Note that, if specified, the URL has to be in the format: `https://mempool.space/api`
    pub mempoolspace_url: Option<String>,
    /// Directory in which all SDK files (DB, log) are stored. Defaults to ".", otherwise if it's customized,
    /// the folder should exist before starting the SDK.
    pub working_dir: String,
    pub network: Network,
    pub payment_timeout_sec: u32,
    pub default_lsp_id: Option<String>,
    pub api_key: Option<String>,
    /// Maps to the CLN `maxfeepercent` config when paying invoices (`lightning-pay`)
    pub maxfee_percent: f64,
    /// Maps to the CLN `exemptfee` config when paying invoices (`lightning-pay`)
    pub exemptfee_msat: u64,
    pub node_config: NodeConfig,
}

pub(crate) static PRODUCTION_BREEZSERVER_URL: &str = "https://bs1.breez.technology:443";
pub(crate) static STAGING_BREEZSERVER_URL: &str = "https://bs1-st.breez.technology:443";

impl Config {
    pub fn production(api_key: String, node_config: NodeConfig) -> Self {
        Config {
            breezserver: PRODUCTION_BREEZSERVER_URL.to_string(),
            chainnotifier_url: "https://chainnotifier.breez.technology".to_string(),
            mempoolspace_url: None,
            working_dir: ".".to_string(),
            network: Bitcoin,
            payment_timeout_sec: 60,
            default_lsp_id: None,
            api_key: Some(api_key),
            maxfee_percent: 1.0,
            exemptfee_msat: 20000,
            node_config,
        }
    }

    pub fn staging(api_key: String, node_config: NodeConfig) -> Self {
        Config {
            breezserver: STAGING_BREEZSERVER_URL.to_string(),
            chainnotifier_url: "https://chainnotifier.breez.technology".to_string(),
            mempoolspace_url: None,
            working_dir: ".".to_string(),
            network: Bitcoin,
            payment_timeout_sec: 60,
            default_lsp_id: None,
            api_key: Some(api_key),
            maxfee_percent: 0.5,
            exemptfee_msat: 20000,
            node_config,
        }
    }
}

#[derive(Clone)]
pub enum NodeConfig {
    Greenlight { config: GreenlightNodeConfig },
}

#[derive(Clone, Serialize)]
pub enum NodeCredentials {
    Greenlight { credentials: GreenlightCredentials },
}

#[derive(Clone)]
pub struct GreenlightNodeConfig {
    pub partner_credentials: Option<GreenlightCredentials>,
    pub invite_code: Option<String>,
}

/// Indicates the different kinds of supported environments for [crate::BreezServices].
#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize, EnumString)]
pub enum EnvironmentType {
    #[strum(serialize = "production")]
    Production,
    #[strum(serialize = "staging")]
    Staging,
}

/// Client-specific credentials to connect to and manage a Greenlight node in the cloud
#[derive(Clone, Serialize, Deserialize)]
pub struct GreenlightCredentials {
    pub device_key: Vec<u8>,
    pub device_cert: Vec<u8>,
}

/// The different supported bitcoin networks
#[derive(Clone, Copy, Debug, Display, Eq, PartialEq, Serialize, Deserialize)]
pub enum Network {
    /// Mainnet
    Bitcoin,
    Testnet,
    Signet,
    Regtest,
}

impl From<crate::bitcoin::network::constants::Network> for Network {
    fn from(network: crate::bitcoin::network::constants::Network) -> Self {
        match network {
            crate::bitcoin::network::constants::Network::Bitcoin => Bitcoin,
            crate::bitcoin::network::constants::Network::Testnet => Testnet,
            crate::bitcoin::network::constants::Network::Signet => Signet,
            crate::bitcoin::network::constants::Network::Regtest => Regtest,
        }
    }
}

impl From<Network> for crate::bitcoin::network::constants::Network {
    fn from(network: Network) -> Self {
        match network {
            Bitcoin => crate::bitcoin::network::constants::Network::Bitcoin,
            Testnet => crate::bitcoin::network::constants::Network::Testnet,
            Signet => crate::bitcoin::network::constants::Network::Signet,
            Regtest => crate::bitcoin::network::constants::Network::Regtest,
        }
    }
}

/// Represents a configure node request.
#[derive(Default)]
pub struct ConfigureNodeRequest {
    pub close_to_address: Option<String>,
}

/// Represents a connect request.
pub struct ConnectRequest {
    pub config: Config,
    pub seed: Vec<u8>,
    /// If true, only restores an existing node and otherwise result in an error
    pub restore_only: Option<bool>,
}

/// Different types of supported filters which can be applied when retrieving the transaction list
#[derive(PartialEq)]
pub enum PaymentTypeFilter {
    Sent,
    Received,
    ClosedChannel,
}

/// A metadata filter which can be applied when retrieving the transaction list
pub struct MetadataFilter {
    /// Specifies which field to apply the filter on, using the JSON path format
    pub json_path: String,
    /// Specifies which JSON value to filter for.
    /// As such, strings must be wrapped with quotes ("") in order to be properly filtered
    pub json_value: String,
}

/// Different types of supported feerates
pub enum FeeratePreset {
    Regular,
    Economy,
    Priority,
}

impl TryFrom<i32> for FeeratePreset {
    type Error = anyhow::Error;

    fn try_from(value: i32) -> std::result::Result<Self, Self::Error> {
        match value {
            0 => Ok(FeeratePreset::Regular),
            1 => Ok(FeeratePreset::Economy),
            2 => Ok(FeeratePreset::Priority),
            _ => Err(anyhow!("Unexpected feerate enum value")),
        }
    }
}

#[derive(Serialize, Deserialize, Clone, PartialEq, Eq, Debug)]
pub struct BackupStatus {
    pub backed_up: bool,
    /// Epoch time, in seconds
    pub last_backup_time: Option<u64>,
}

/// The node state of a Greenlight LN node running in the cloud.
///
/// Note: The implementation attempts to provide the most up-to-date values,
/// which may result in some short-lived inconsistencies
/// (e.g., `channels_balance_msat` may be updated before `inbound_liquidity_msats`).
#[derive(Serialize, Deserialize, Clone, PartialEq, Eq, Debug)]
pub struct NodeState {
    pub id: String,
    pub block_height: u32,
    pub channels_balance_msat: u64,
    pub onchain_balance_msat: u64,
    #[serde(default)]
    pub pending_onchain_balance_msat: u64,

    #[serde(default)]
    pub utxos: Vec<UnspentTransactionOutput>,
    pub max_payable_msat: u64,
    pub max_receivable_msat: u64,
    pub max_single_payment_amount_msat: u64,
    pub max_chan_reserve_msats: u64,
    pub connected_peers: Vec<String>,
    pub inbound_liquidity_msats: u64,
}

/// Internal response to a [crate::node_api::NodeAPI::pull_changed] call
pub struct SyncResponse {
    pub node_state: NodeState,
    pub payments: Vec<crate::models::Payment>,
    pub channels: Vec<crate::models::Channel>,
}

/// The status of a payment
#[derive(Clone, Copy, PartialEq, Eq, Debug, Serialize, Deserialize)]
pub enum PaymentStatus {
    Pending = 0,
    Complete = 1,
    Failed = 2,
}

/// Represents a payment, including its [PaymentType] and [PaymentDetails]
#[derive(PartialEq, Eq, Debug, Clone, Serialize, Deserialize)]
pub struct Payment {
    pub id: String,
    pub payment_type: PaymentType,
    /// Epoch time, in seconds
    pub payment_time: i64,
    pub amount_msat: u64,
    pub fee_msat: u64,
    pub status: PaymentStatus,
    pub error: Option<String>,
    pub description: Option<String>,
    pub details: PaymentDetails,
    pub metadata: Option<String>,
}

/// Represents a payments external information.
#[derive(Default)]
pub struct PaymentExternalInfo {
    pub lnurl_pay_success_action: Option<SuccessActionProcessed>,
    pub lnurl_pay_domain: Option<String>,
    pub lnurl_metadata: Option<String>,
    pub ln_address: Option<String>,
    pub lnurl_withdraw_endpoint: Option<String>,
    pub attempted_amount_msat: Option<u64>,
    pub attempted_error: Option<String>,
}

/// Represents a list payments request.
#[derive(Default)]
pub struct ListPaymentsRequest {
    pub filters: Option<Vec<PaymentTypeFilter>>,
    pub metadata_filters: Option<Vec<MetadataFilter>>,
    /// Epoch time, in seconds
    pub from_timestamp: Option<i64>,
    /// Epoch time, in seconds
    pub to_timestamp: Option<i64>,
    pub include_failures: Option<bool>,
    pub offset: Option<u32>,
    pub limit: Option<u32>,
}

/// Represents a payment response.
#[derive(PartialEq, Eq, Debug, Clone, Serialize, Deserialize)]
pub struct PaymentResponse {
    /// Epoch time, in seconds
    pub payment_time: i64,
    pub amount_msat: u64,
    pub fee_msat: u64,
    pub payment_hash: String,
    pub payment_preimage: String,
}

/// Wrapper for the different types of payments
#[allow(clippy::large_enum_variant)]
#[derive(PartialEq, Eq, Debug, Clone, Deserialize, Serialize)]
#[serde(untagged)]
pub enum PaymentDetails {
    Ln {
        #[serde(flatten)]
        data: LnPaymentDetails,
    },
    ClosedChannel {
        #[serde(flatten)]
        data: ClosedChannelPaymentDetails,
    },
}

impl PaymentDetails {
    pub fn add_pending_expiration_block(&mut self, htlc: Htlc) {
        if let PaymentDetails::Ln { data } = self {
            data.pending_expiration_block = Some(htlc.expiry)
        }
    }
}

/// Details of a LN payment, as included in a [Payment]
#[derive(PartialEq, Eq, Debug, Clone, Deserialize, Serialize)]
pub struct LnPaymentDetails {
    pub payment_hash: String,
    pub label: String,
    pub destination_pubkey: String,
    pub payment_preimage: String,
    pub keysend: bool,
    pub bolt11: String,

    /// Only set for [PaymentType::Received], payments which require to open a channel.
    /// Represents the actual invoice paid by the sender
    pub open_channel_bolt11: Option<String>,

    /// Only set for [PaymentType::Sent] payments that are part of a LNURL-pay workflow where
    /// the endpoint returns a success action
    pub lnurl_success_action: Option<SuccessActionProcessed>,

    /// Only set for [PaymentType::Sent] payments if it is not a payment to a Lightning Address
    pub lnurl_pay_domain: Option<String>,

    /// Only set for [PaymentType::Sent] payments that are sent to a Lightning Address
    pub ln_address: Option<String>,

    /// Only set for [PaymentType::Sent] payments where the receiver endpoint returned LNURL metadata
    pub lnurl_metadata: Option<String>,

    /// Only set for [PaymentType::Received] payments that were received as part of LNURL-withdraw
    pub lnurl_withdraw_endpoint: Option<String>,

    /// Only set for [PaymentType::Received] payments that were received in the context of a swap
    pub swap_info: Option<SwapInfo>,

    /// Only set for [PaymentType::Sent] payments that were sent in the context of a reverse swap
    pub reverse_swap_info: Option<ReverseSwapInfo>,

    /// Only set for [PaymentStatus::Pending] payments that are inflight.
    pub pending_expiration_block: Option<u32>,
}

/// Represents the funds that were on the user side of the channel at the time it was closed.
#[derive(PartialEq, Eq, Debug, Clone, Deserialize, Serialize)]
pub struct ClosedChannelPaymentDetails {
    pub state: ChannelState,
    pub funding_txid: String,
    pub short_channel_id: Option<String>,
    /// Can be empty for older closed channels.
    pub closing_txid: Option<String>,
}

#[derive(Clone, Debug, Default, Serialize, Deserialize)]
pub struct ReverseSwapFeesRequest {
    /// Amount to be sent
    pub send_amount_sat: Option<u64>,
    /// Feerate (sat / vByte) for the claim transaction
    pub claim_tx_feerate: Option<u32>,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct MaxReverseSwapAmountResponse {
    /// The total sats that can be sent onchain.
    pub total_sat: u64,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct MaxChannelAmount {
    /// The channel id.
    pub channel_id: String,
    /// The max amount can be sent from this channel.
    pub amount_msat: u64,
    /// The payment path to be used for the maximum amount.
    pub path: PaymentPath,
}

/// Represents a receive payment request.
#[derive(Clone, Debug, Default, Serialize, Deserialize)]
pub struct ReceivePaymentRequest {
    /// The amount in satoshis for this payment request
    pub amount_msat: u64,
    /// The description for this payment request.
    pub description: String,
    /// Optional preimage for this payment request.
    /// If specified, it will be used instead of generating a new one.
    pub preimage: Option<Vec<u8>>,
    /// If set and valid, these fess options are used when a new channels is needed.
    /// Otherwise the default fee options will be used.
    pub opening_fee_params: Option<OpeningFeeParams>,
    /// If set to true, then the bolt11 invoice returned includes the description hash.
    pub use_description_hash: Option<bool>,
    /// if specified, set the time the invoice is valid for, in seconds.
    pub expiry: Option<u32>,
    /// if specified, sets the min_final_cltv_expiry for the invoice
    pub cltv: Option<u32>,
}

/// Represents a receive payment response.
///
/// Breez SDK may have to open a new channel to receive this payment. In that case, the channel will
/// be opened automatically when the invoice is paid, and the fees will be described in the
/// `opening_fee_params` and `opening_fee_msat` fields.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ReceivePaymentResponse {
    /// The generated invoice, including any necessary routing hints
    pub ln_invoice: LNInvoice,
    /// If set, these are the [OpeningFeeParams] used to calculate the channel opening fees.
    pub opening_fee_params: Option<OpeningFeeParams>,
    /// If set, this is the channel opening fee that will be deduced from the invoice amount.
    pub opening_fee_msat: Option<u64>,
}

/// Represents a send payment request.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct SendPaymentRequest {
    /// The bolt11 invoice
    pub bolt11: String,
    /// The amount to pay in millisatoshis. Should only be set when `bolt11` is a zero-amount invoice.
    pub amount_msat: Option<u64>,
    /// The external label or identifier of the [Payment]
    pub label: Option<String>,
}

/// Represents a TLV entry for a keysend payment.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct TlvEntry {
    /// The type field for the TLV
    pub field_number: u64,
    /// The value bytes for the TLV
    pub value: Vec<u8>,
}

/// Represents a send spontaneous payment request.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct SendSpontaneousPaymentRequest {
    /// The node id to send this payment is
    pub node_id: String,
    /// The amount in millisatoshis for this payment
    pub amount_msat: u64,
    // Optional extra TLVs
    pub extra_tlvs: Option<Vec<TlvEntry>>,
    /// The external label or identifier of the [Payment]
    pub label: Option<String>,
}

/// Represents a send payment response.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct SendPaymentResponse {
    pub payment: Payment,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ReportPaymentFailureDetails {
    /// The payment hash of the payment failure
    pub payment_hash: String,
    /// The comment or error text
    pub comment: Option<String>,
}

/// Represents a report issue request.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub enum ReportIssueRequest {
    PaymentFailure { data: ReportPaymentFailureDetails },
}

/// Indicates the different service health check statuses.
#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
pub enum HealthCheckStatus {
    Operational,
    Maintenance,
    ServiceDisruption,
}

/// Represents a service health check response.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ServiceHealthCheckResponse {
    pub status: HealthCheckStatus,
}

/// Trait covering support-related functionality
#[tonic::async_trait]
pub trait SupportAPI: Send + Sync {
    async fn service_health_check(&self) -> SdkResult<ServiceHealthCheckResponse>;

    async fn report_payment_failure(
        &self,
        node_state: NodeState,
        payment: Payment,
        lsp_id: Option<String>,
        comment: Option<String>,
    ) -> SdkResult<()>;
}

#[derive(Clone)]
pub struct StaticBackupRequest {
    pub working_dir: String,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct StaticBackupResponse {
    pub backup: Option<Vec<String>>,
}

#[derive(Default)]
pub struct OpenChannelFeeRequest {
    pub amount_msat: Option<u64>,
    pub expiry: Option<u32>,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct OpenChannelFeeResponse {
    /// Opening fee for receiving the amount set in the [OpenChannelFeeRequest], in case it was set.
    /// It may be zero if no new channel needs to be opened.
    pub fee_msat: Option<u64>,
    /// The fee params for receiving more than the current inbound liquidity.
    pub fee_params: OpeningFeeParams,
}

#[derive(Clone, Debug, Default, Serialize, Deserialize)]
pub struct ReceiveOnchainRequest {
    pub opening_fee_params: Option<OpeningFeeParams>,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct BuyBitcoinRequest {
    pub provider: BuyBitcoinProvider,
    pub opening_fee_params: Option<OpeningFeeParams>,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct BuyBitcoinResponse {
    pub url: String,
    pub opening_fee_params: Option<OpeningFeeParams>,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct RedeemOnchainFundsRequest {
    pub to_address: String,
    pub sat_per_vbyte: u32,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct RedeemOnchainFundsResponse {
    pub txid: Vec<u8>,
}

#[derive(Clone)]
pub struct SendOnchainRequest {
    pub amount_sat: u64,
    pub onchain_recipient_address: String,
    pub pair_hash: String,
    pub sat_per_vbyte: u32,
}

pub struct SendOnchainResponse {
    pub reverse_swap_info: ReverseSwapInfo,
}

pub enum SwapAmountType {
    Send,
    Receive,
}

/// See [ReverseSwapFeesRequest]
pub struct PrepareOnchainPaymentRequest {
    /// Depending on `amount_type`, this may be the desired send amount or the desired receive amount.
    pub amount_sat: u64,
    pub amount_type: SwapAmountType,

    /// Feerate (sat / vByte) for the claim transaction
    pub claim_tx_feerate: u32,
}

#[derive(Serialize)]
pub struct OnchainPaymentLimitsResponse {
    /// Minimum amount that can be sent. This value is influenced by
    /// - what can be sent given the available channels and balance
    /// - the lower limit of what the reverse swap service accepts as a send amount
    pub min_sat: u64,
    /// Maximum amount that can be sent. This value is influenced by
    /// - what can be sent given the available channels and balance
    /// - the upper limit of what the reverse swap service accepts as a send amount
    pub max_sat: u64,
}

/// Contains fields describing the reverse swap parameters (see [ReverseSwapPairInfo]), as well as
/// the resulting send and receive amounts.
#[derive(Clone, Debug, Serialize)]
pub struct PrepareOnchainPaymentResponse {
    pub fees_hash: String,
    pub fees_percentage: f64,
    pub fees_lockup: u64,
    pub fees_claim: u64,

    pub sender_amount_sat: u64,
    pub recipient_amount_sat: u64,
    pub total_fees: u64,
}

#[derive(Clone, Debug)]
pub struct PayOnchainRequest {
    pub recipient_address: String,
    pub prepare_res: PrepareOnchainPaymentResponse,
}

#[derive(Serialize)]
pub struct PayOnchainResponse {
    pub reverse_swap_info: ReverseSwapInfo,
}

pub struct PrepareRefundRequest {
    pub swap_address: String,
    pub to_address: String,
    pub sat_per_vbyte: u32,
}

pub struct RefundRequest {
    pub swap_address: String,
    pub to_address: String,
    pub sat_per_vbyte: u32,
}

pub struct PrepareRefundResponse {
    pub refund_tx_weight: u32,
    pub refund_tx_fee_sat: u64,
}

pub struct RefundResponse {
    pub refund_tx_id: String,
}

/// Dynamic fee parameters offered by the LSP for opening a new channel.
///
/// After they are received, the client shouldn't change them when calling LSP methods,
/// otherwise the LSP may reject the call.
#[derive(Clone, Debug, Serialize, Deserialize, Eq, PartialEq)]
pub struct OpeningFeeParams {
    /// The minimum value in millisatoshi we will require for incoming HTLCs on the channel
    pub min_msat: u64,
    /// The fee in ppm charged over liquidity when buying a channel
    pub proportional: u32,
    /// The date and time this opening fee params promise expires, in RFC 3339 / ISO 8601 format
    pub valid_until: String,
    /// The channel can be closed if not used within this duration in blocks
    pub max_idle_time: u32,
    pub max_client_to_self_delay: u32,
    pub promise: String,
}

impl OpeningFeeParams {
    pub(crate) fn valid_until_date(&self) -> Result<DateTime<Utc>> {
        Ok(DateTime::parse_from_rfc3339(&self.valid_until).map(|d| d.with_timezone(&Utc))?)
    }

    pub(crate) fn valid_for(&self, expiry: u32) -> Result<bool> {
        Ok(self.valid_until_date()? > Utc::now().add(Duration::seconds(expiry as i64)))
    }

    pub(crate) fn get_channel_fees_msat_for(&self, amount_msats: u64) -> u64 {
        let lsp_fee_msat = amount_msats * self.proportional as u64 / 1_000_000;
        let lsp_fee_msat_rounded_to_sat = lsp_fee_msat / 1000 * 1000;

        max(lsp_fee_msat_rounded_to_sat, self.min_msat)
    }
}

impl From<OpeningFeeParams> for grpc::OpeningFeeParams {
    fn from(ofp: OpeningFeeParams) -> Self {
        Self {
            min_msat: ofp.min_msat,
            proportional: ofp.proportional,
            valid_until: ofp.valid_until,
            max_idle_time: ofp.max_idle_time,
            max_client_to_self_delay: ofp.max_client_to_self_delay,
            promise: ofp.promise,
        }
    }
}

impl From<grpc::OpeningFeeParams> for OpeningFeeParams {
    fn from(gofp: grpc::OpeningFeeParams) -> Self {
        Self {
            min_msat: gofp.min_msat,
            proportional: gofp.proportional,
            valid_until: gofp.valid_until,
            max_idle_time: gofp.max_idle_time,
            max_client_to_self_delay: gofp.max_client_to_self_delay,
            promise: gofp.promise,
        }
    }
}

impl FromSql for OpeningFeeParams {
    fn column_result(value: ValueRef<'_>) -> FromSqlResult<Self> {
        serde_json::from_str(value.as_str()?).map_err(|_| FromSqlError::InvalidType)
    }
}

impl ToSql for OpeningFeeParams {
    fn to_sql(&self) -> rusqlite::Result<ToSqlOutput<'_>> {
        Ok(ToSqlOutput::from(
            serde_json::to_string(&self).map_err(|_| FromSqlError::InvalidType)?,
        ))
    }
}

pub enum DynamicFeeType {
    Cheapest,
    Longest,
}

/// See [OpeningFeeParamsMenu::try_from]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OpeningFeeParamsMenu {
    pub values: Vec<OpeningFeeParams>,
}

impl OpeningFeeParamsMenu {
    /// Initializes and validates itself.
    ///
    /// This struct should not be persisted as such, because validation happens dynamically based on
    /// the current time. At a later point in time, any previously-validated [OpeningFeeParamsMenu]
    /// could be invalid. Therefore, the [OpeningFeeParamsMenu] should always be initialized on-the-fly.
    pub fn try_from(values: Vec<grpc::OpeningFeeParams>) -> Result<Self> {
        let temp = Self {
            values: values
                .into_iter()
                .map(|ofp| ofp.into())
                .collect::<Vec<OpeningFeeParams>>(),
        };
        temp.validate().map(|_| temp)
    }

    fn validate(&self) -> Result<()> {
        // values must be in ascending order
        let is_ordered = self.values.windows(2).all(|ofp| {
            let larger_min_msat_fee = ofp[0].min_msat < ofp[1].min_msat;
            let equal_min_msat_fee = ofp[0].min_msat == ofp[1].min_msat;

            let larger_proportional = ofp[0].proportional < ofp[1].proportional;
            let equal_proportional = ofp[0].proportional == ofp[1].proportional;

            (larger_min_msat_fee && equal_proportional)
                || (equal_min_msat_fee && larger_proportional)
                || (larger_min_msat_fee && larger_proportional)
        });
        ensure!(is_ordered, "Validation failed: fee params are not ordered");

        // Menu must not contain any item with `valid_until` in the past
        let is_expired = self.values.iter().any(|ofp| match ofp.valid_until_date() {
            Ok(valid_until) => Utc::now() > valid_until,
            Err(_) => {
                warn!("Failed to parse valid_until for OpeningFeeParams: {ofp:?}");
                false
            }
        });
        ensure!(!is_expired, "Validation failed: expired fee params found");

        Ok(())
    }

    pub fn is_valid(&self) -> bool {
        self.validate().is_ok()
    }

    pub fn get_cheapest_opening_fee_params(&self) -> Result<OpeningFeeParams> {
        self.values.first().cloned().ok_or_else(|| {
            anyhow!("The LSP doesn't support opening new channels: Dynamic fees menu contains no values")
        })
    }

    pub fn get_48h_opening_fee_params(&self) -> Result<OpeningFeeParams> {
        // Find the fee params that are valid for at least 48h
        let now = Utc::now();
        let duration_48h = chrono::Duration::hours(48);
        let valid_min_48h: Vec<OpeningFeeParams> = self
            .values
            .iter()
            .filter(|ofp| match ofp.valid_until_date() {
                Ok(valid_until) => valid_until - now > duration_48h,
                Err(_) => {
                    warn!("Failed to parse valid_until for OpeningFeeParams: {ofp:?}");
                    false
                }
            })
            .cloned()
            .collect();

        // Of those, return the first, which is the cheapest
        // (sorting order of fee params list was checked when the menu was initialized)
        valid_min_48h.first().cloned().ok_or_else(|| {
            anyhow!("The LSP doesn't support opening fees that are valid for at least 48 hours")
        })
    }
}

/// Lightning channel
#[derive(Clone, PartialEq, Eq, Debug, Serialize)]
pub struct Channel {
    pub funding_txid: String,
    pub short_channel_id: Option<String>,
    pub state: ChannelState,
    pub spendable_msat: u64,
    pub receivable_msat: u64,
    pub closed_at: Option<u64>,
    /// The output number of the funding tx which opened the channel
    pub funding_outnum: Option<u32>,
    pub alias_local: Option<String>,
    pub alias_remote: Option<String>,
    /// Only set for closed channels.
    ///
    /// This may be empty for older closed channels, if it was not possible to retrieve the closing txid.
    pub closing_txid: Option<String>,

    pub htlcs: Vec<Htlc>,
}

#[derive(Clone, PartialEq, Eq, Debug, Serialize)]
pub struct Htlc {
    pub expiry: u32,
    pub payment_hash: Vec<u8>,
}

impl Htlc {
    pub fn from(expiry: u32, payment_hash: Vec<u8>) -> Self {
        Htlc {
            expiry,
            payment_hash,
        }
    }
}

/// State of a Lightning channel
#[derive(Clone, PartialEq, Eq, Debug, EnumString, Display, Deserialize, Serialize)]
pub enum ChannelState {
    PendingOpen,
    Opened,
    PendingClose,
    Closed,
}

/// The status of a swap
#[derive(Clone, PartialEq, Eq, Debug, Serialize, Deserialize)]
pub enum SwapStatus {
    /// The swap address has been created and either there aren't any confirmed transactions associated with it
    /// or there are confirmed transactions that are bellow the lock timeout which means the funds are still
    /// eligible to be redeemed normally.
    Initial = 0,

    WaitingConfirmation = 1,

    Redeemable = 2,

    Redeemed = 3,

    /// The swap address has confirmed transactions associated with it and the lock timeout has passed since
    /// the earliest confirmed transaction. This means the only way to spend the funds from this address is by
    /// broadcasting a refund transaction.
    Refundable = 4,

    Completed = 5,
}

impl TryFrom<i32> for SwapStatus {
    type Error = anyhow::Error;

    fn try_from(value: i32) -> Result<Self, Self::Error> {
        match value {
            0 => Ok(SwapStatus::Initial),
            1 => Ok(SwapStatus::WaitingConfirmation),
            2 => Ok(SwapStatus::Redeemable),
            3 => Ok(SwapStatus::Redeemed),
            4 => Ok(SwapStatus::Refundable),
            5 => Ok(SwapStatus::Completed),
            _ => Err(anyhow!("illegal value")),
        }
    }
}

/// Represents the details of an on-going swap.
///
/// Once this SwapInfo is created it will be monitored on-chain and its state is
/// saved to the persistent storage.
///
/// The SwapInfo has a status which changes accordingly, documented in [SwapStatus].
///

#[derive(Clone, PartialEq, Eq, Debug, Serialize, Deserialize)]
pub struct SwapInfo {
    /// Bitcoin address for this swap. Sats sent to this address will be swapped.
    pub bitcoin_address: String,
    /// Relative time lock start, received from [SwapperAPI::create_swap].
    pub created_at: i64,
    /// Relative time lock for the timeout for the script to be redeemed before swap fails.
    pub lock_height: i64,
    /// sha256 hash of preimage to used in the claim sript.
    pub payment_hash: Vec<u8>,
    /// Secret to claim the swap.
    pub preimage: Vec<u8>,
    /// Secret claim key for the bitcoin address.
    pub private_key: Vec<u8>,
    /// Public key in binary format of the private claim private key.
    pub public_key: Vec<u8>,
    /// The public key in binary format from the swapping service. Received from [SwapperAPI::create_swap].
    pub swapper_public_key: Vec<u8>,
    /// The locking script for the generated bitcoin address. Received from [SwapperAPI::create_swap].
    pub script: Vec<u8>,

    /// bolt11 invoice to claim the sent funds.
    pub bolt11: Option<String>,
    /// Amount of millisatoshis claimed from sent funds and paid for via bolt11 invoice.
    pub paid_msat: u64,
    /// Total amount of transactions sent to the swap address.
    pub total_incoming_txs: u64,
    /// Confirmed onchain sats to be claim with an bolt11 invoice or refunded if swap fails.
    pub confirmed_sats: u64,
    /// Unconfirmed sats waiting to be confirmed onchain.
    pub unconfirmed_sats: u64,
    /// Shows the current status of the swap, either `Initial` or `Expired`.
    pub status: SwapStatus,
    /// Transaction IDs for failed swap attempts.
    pub refund_tx_ids: Vec<String>,
    /// Refund transaction IDs for ongoing swap awaiting confirmation.
    pub unconfirmed_tx_ids: Vec<String>,
    /// Transaction IDs that have been confirmed on-chain.
    pub confirmed_tx_ids: Vec<String>,
    /// The minimum amount of sats one can send in order for the swap to succeed. Received from [SwapperAPI::create_swap].
    pub min_allowed_deposit: i64,
    /// The maximum amount of sats one can send in order for the swap to succeed. This is determined based on `max_swapper_payable` and the node's local balance.
    pub max_allowed_deposit: i64,
    /// The absolute maximum value payable by the swapper. Received from [SwapperAPI::create_swap].
    pub max_swapper_payable: i64,
    /// Error reason for when swap fails.
    pub last_redeem_error: Option<String>,
    /// The dynamic fees which is set if a channel opening is needed.
    ///
    /// This is an optional field for backward compatibility with swaps created before dynamic fees.
    ///
    /// Swaps created after dynamic fees were introduced always have this field set.
    pub channel_opening_fees: Option<OpeningFeeParams>,
    /// The block height when the swap was confirmed.
    pub confirmed_at: Option<u32>,
}

impl SwapInfo {
    pub(crate) fn with_chain_info(&self, onchain_info: SwapChainInfo, tip: u32) -> Self {
        let new_info = Self {
            confirmed_sats: onchain_info.confirmed_sats,
            unconfirmed_sats: onchain_info.unconfirmed_sats,
            confirmed_tx_ids: onchain_info.confirmed_tx_ids,
            unconfirmed_tx_ids: onchain_info.unconfirmed_tx_ids,
            confirmed_at: onchain_info.confirmed_at,
            ..self.clone()
        };

        Self {
            status: new_info.calculate_status(tip),
            ..new_info
        }
    }

    pub(crate) fn with_paid_amount(&self, paid_msat: u64, tip: u32) -> Self {
        let new_info = Self {
            paid_msat,
            ..self.clone()
        };

        Self {
            status: new_info.calculate_status(tip),
            ..new_info
        }
    }

    pub(crate) fn unused(&self) -> bool {
        self.status == SwapStatus::Initial
    }

    pub(crate) fn in_progress(&self) -> bool {
        [SwapStatus::Redeemable, SwapStatus::WaitingConfirmation].contains(&self.status)
    }

    pub(crate) fn redeemable(&self) -> bool {
        self.status == SwapStatus::Redeemable
    }

    pub(crate) fn refundable(&self) -> bool {
        self.status == SwapStatus::Refundable
    }

    pub(crate) fn monitored(&self) -> bool {
        self.status != SwapStatus::Completed
    }

    fn calculate_status(&self, tip: u32) -> SwapStatus {
        let mut passed_timelock = false;
        if let Some(confirmed_at) = self.confirmed_at {
            passed_timelock = (tip - confirmed_at) as i64 > self.lock_height;
        }

        // In case timelock has passed we can only be in the Refundable or Completed state.
        if passed_timelock {
            return match self.confirmed_sats {
                0 => SwapStatus::Completed,
                // This is to make sure we don't consider refundable in case we only have one transaction which was already
                // paid by the swapper.
                _ => match (self.paid_msat, self.total_incoming_txs) {
                    (paid, 1) if paid > 0 => SwapStatus::Completed,
                    _ => SwapStatus::Refundable,
                },
            };
        }

        match (
            self.confirmed_at,
            self.unconfirmed_sats,
            self.confirmed_sats,
            self.paid_msat,
        ) {
            // We have confirmation and both uconfirmed and confirmed balance are zero then we are done
            (Some(_), 0, 0, _) => SwapStatus::Completed,
            // We got lightning payment so we are in redeemed state.
            (_, _, _, paid) if paid > 0 => SwapStatus::Redeemed,
            // We have positive confirmed balance then we should redeem the funds.
            (_, _, confirmed, _) if confirmed > 0 => SwapStatus::Redeemable,
            // We have positive unconfirmed balance then we are waiting for confirmation.
            (_, unconfirmed, _, _) if unconfirmed > 0 => SwapStatus::WaitingConfirmation,
            _ => SwapStatus::Initial,
        }
    }

    pub(crate) fn validate_swap_limits(&self) -> SwapResult<()> {
        ensure_sdk!(
            self.max_allowed_deposit >= self.min_allowed_deposit,
            SwapError::unsupported_swap_limits("No allowed deposit amounts")
        );
        Ok(())
    }
}

pub(crate) fn parse_short_channel_id(id_str: &str) -> Result<u64> {
    let parts: Vec<&str> = id_str.split('x').collect();
    if parts.len() != 3 {
        return Ok(0);
    }
    let block_num = parts[0].parse::<u64>()?;
    let tx_num = parts[1].parse::<u64>()?;
    let tx_out = parts[2].parse::<u64>()?;

    Ok((block_num & 0xFFFFFF) << 40 | (tx_num & 0xFFFFFF) << 16 | (tx_out & 0xFFFF))
}

pub(crate) fn format_short_channel_id(id: u64) -> String {
    let block_num = (id >> 40) as u32;
    let tx_num = ((id >> 16) & 0xFFFFFF) as u32;
    let tx_out = (id & 0xFFFF) as u16;
    format!("{block_num}x{tx_num}x{tx_out}")
}

/// UTXO known to the LN node
#[derive(Serialize, Deserialize, Clone, PartialEq, Eq, Debug)]
pub struct UnspentTransactionOutput {
    pub txid: Vec<u8>,
    pub outnum: u32,
    pub amount_millisatoshi: u64,
    pub address: String,
    #[serde(default)]
    pub reserved: bool,
}

/// Contains the result of the entire LNURL interaction, as reported by the LNURL endpoint.
///
/// * `Ok` indicates the interaction with the endpoint was valid, and the endpoint
///  - started to pay the invoice asynchronously in the case of LNURL-withdraw,
///  - verified the client signature in the case of LNURL-auth,////// * `Error` indicates a generic issue the LNURL endpoint encountered, including a freetext
/// description of the reason.
///
/// Both cases are described in LUD-03 <https://github.com/lnurl/luds/blob/luds/03.md> & LUD-04: <https://github.com/lnurl/luds/blob/luds/04.md>
#[derive(Deserialize, Debug, Serialize)]
#[serde(rename_all = "UPPERCASE")]
#[serde(tag = "status")]
pub enum LnUrlCallbackStatus {
    /// On-wire format is: `{"status": "OK"}`
    Ok,
    /// On-wire format is: `{"status": "ERROR", "reason": "error details..."}`
    #[serde(rename = "ERROR")]
    ErrorStatus {
        #[serde(flatten)]
        data: LnUrlErrorData,
    },
}

#[derive(Debug, Serialize, Deserialize)]
pub struct LnUrlWithdrawRequest {
    /// Request data containing information on how to call the lnurl withdraw
    /// endpoint. Typically retrieved by calling `parse()` on a lnurl withdraw
    /// input.
    pub data: LnUrlWithdrawRequestData,

    /// The amount to withdraw from the lnurl withdraw endpoint. Must be between
    /// `min_withdrawable` and `max_withdrawable`.
    pub amount_msat: u64,

    /// Optional description that will be put in the payment request for the
    /// lnurl withdraw endpoint.
    pub description: Option<String>,
}

/// Represents a LNURL-pay request.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct LnUrlPayRequest {
    /// The [LnUrlPayRequestData] returned by [crate::input_parser::parse]
    pub data: LnUrlPayRequestData,
    /// The amount in millisatoshis for this payment
    pub amount_msat: u64,
    /// An optional comment for this payment
    pub comment: Option<String>,
    /// The external label or identifier of the [Payment]
    pub payment_label: Option<String>,
}

/// [LnUrlCallbackStatus] specific to LNURL-withdraw, where the success case contains the invoice.
#[derive(Serialize)]
pub enum LnUrlWithdrawResult {
    Ok { data: LnUrlWithdrawSuccessData },
    ErrorStatus { data: LnUrlErrorData },
}

#[derive(Deserialize, Debug, Serialize)]
pub struct LnUrlWithdrawSuccessData {
    pub invoice: LNInvoice,
}

/// Different providers will demand different behaviours when the user is trying to buy bitcoin.
#[derive(PartialEq, Eq, Debug, Clone, Deserialize, Serialize)]
#[serde(tag = "buy_bitcoin_provider")]
pub enum BuyBitcoinProvider {
    Moonpay,
}

/// We need to prepare a redeem_onchain_funds transaction to know what fee will be charged in satoshis.
/// This model holds the request data which consists of the address to redeem on-chain funds to and the fee rate in.
/// satoshis per vbyte which will be converted to absolute satoshis.
#[derive(PartialEq, Eq, Debug, Clone, Deserialize, Serialize)]
pub struct PrepareRedeemOnchainFundsRequest {
    pub to_address: String,
    pub sat_per_vbyte: u32,
}

/// We need to prepare a redeem_onchain_funds transaction to know what a fee it will be charged in satoshis
/// this model holds the response data, which consists of the weight and the absolute fee in sats
#[derive(PartialEq, Eq, Debug, Clone, Deserialize, Serialize)]
pub struct PrepareRedeemOnchainFundsResponse {
    pub tx_weight: u64,
    pub tx_fee_sat: u64,
}

impl FromStr for BuyBitcoinProvider {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "moonpay" => Ok(BuyBitcoinProvider::Moonpay),
            _ => Err(anyhow!("unknown buy bitcoin provider")),
        }
    }
}

#[derive(Clone, PartialEq, Eq, Debug, Serialize, Deserialize)]
pub struct PaymentPath {
    pub edges: Vec<PaymentPathEdge>,
}

impl PaymentPath {
    pub fn final_hop_amount(&self, first_hop_amount_msat: u64) -> u64 {
        let mut max_to_send = first_hop_amount_msat;
        for h in self.edges.iter().skip(1) {
            max_to_send = h.amount_to_forward(max_to_send);
        }
        max_to_send
    }

    pub fn first_hop_amount(&self, final_hop_amount_msat: u64) -> u64 {
        let mut first_hop_amount = final_hop_amount_msat;
        for h in self.edges.iter().skip(1).rev() {
            first_hop_amount = h.amount_from_forward(first_hop_amount);
        }
        first_hop_amount
    }
}

#[derive(Clone, PartialEq, Eq, Debug, Serialize, Deserialize)]
pub struct PaymentPathEdge {
    pub node_id: Vec<u8>,
    pub short_channel_id: String,
    pub channel_delay: u64,
    pub base_fee_msat: u64,
    pub fee_per_millionth: u64,
}

impl PaymentPathEdge {
    pub(crate) fn amount_to_forward(&self, in_amount_msat: u64) -> u64 {
        let amount_to_forward = Self::divide_ceil(
            1_000_000 * (in_amount_msat - self.base_fee_msat),
            1_000_000 + self.fee_per_millionth,
        );

        info!("amount_to_forward: in_amount_msat = {in_amount_msat},base_fee_msat={}, fee_per_millionth={}  amount_to_forward: {}", self.base_fee_msat, self.fee_per_millionth, amount_to_forward);
        amount_to_forward
    }

    pub(crate) fn amount_from_forward(&self, forward_amount_msat: u64) -> u64 {
        let in_amount_msat = self.base_fee_msat
            + forward_amount_msat * (1_000_000 + self.fee_per_millionth) / 1_000_000;

        print!("amount_from_forward: in_amount_msat = {in_amount_msat},base_fee_msat={}, fee_per_millionth={}  amount_to_forward: {}", self.base_fee_msat, self.fee_per_millionth, forward_amount_msat);
        in_amount_msat
    }

    fn divide_ceil(dividend: u64, factor: u64) -> u64 {
        (dividend + factor - 1) / factor
    }
}

#[cfg(test)]
mod tests {
    use anyhow::Result;
    use prost::Message;
    use rand::random;

    use crate::grpc::PaymentInformation;
    use crate::test_utils::{get_test_ofp, rand_vec_u8};
    use crate::{OpeningFeeParams, PaymentPath, PaymentPathEdge};

    #[test]
    fn test_route_fees() -> Result<()> {
        let route = PaymentPath {
            edges: vec![
                PaymentPathEdge {
                    node_id: vec![1],
                    short_channel_id: "807189x2048x0".into(),
                    channel_delay: 34,
                    base_fee_msat: 1000,
                    fee_per_millionth: 10,
                },
                PaymentPathEdge {
                    node_id: vec![2],
                    short_channel_id: "811871x2726x1".into(),
                    channel_delay: 34,
                    base_fee_msat: 0,
                    fee_per_millionth: 0,
                },
                PaymentPathEdge {
                    node_id: vec![3],
                    short_channel_id: "16000000x0x18087".into(),
                    channel_delay: 40,
                    base_fee_msat: 1000,
                    fee_per_millionth: 1,
                },
            ],
        };
        assert_eq!(route.final_hop_amount(1141000), 1139999);
        assert_eq!(route.first_hop_amount(1139999), 1141000);

        let route = PaymentPath {
            edges: vec![
                PaymentPathEdge {
                    node_id: vec![1],
                    short_channel_id: "807189x2048x0".into(),
                    channel_delay: 34,
                    base_fee_msat: 1000,
                    fee_per_millionth: 10,
                },
                PaymentPathEdge {
                    node_id: vec![2],
                    short_channel_id: "811871x2726x1".into(),
                    channel_delay: 34,
                    base_fee_msat: 0,
                    fee_per_millionth: 0,
                },
                PaymentPathEdge {
                    node_id: vec![3],
                    short_channel_id: "16000000x0x18087".into(),
                    channel_delay: 40,
                    base_fee_msat: 0,
                    fee_per_millionth: 2000,
                },
            ],
        };
        assert_eq!(route.final_hop_amount(1141314), 1139036);
        assert_eq!(route.first_hop_amount(1139036), 1141314);

        Ok(())
    }

    use super::OpeningFeeParamsMenu;

    #[test]
    fn test_ofp_menu_validation() -> Result<()> {
        // Menu with one entry is valid
        OpeningFeeParamsMenu::try_from(vec![get_test_ofp(10, 12, true)])?;

        // Menu with identical entries (same min_msat, same proportional) is invalid
        assert!(OpeningFeeParamsMenu::try_from(vec![
            get_test_ofp(10, 12, true),
            get_test_ofp(10, 12, true),
        ])
        .is_err());

        // Menu where 2nd item has larger min_fee_msat, same proportional is valid
        OpeningFeeParamsMenu::try_from(vec![
            get_test_ofp(10, 12, true),
            get_test_ofp(12, 12, true),
        ])?;

        // Menu where 2nd item has same min_fee_msat, larger proportional is valid
        OpeningFeeParamsMenu::try_from(vec![
            get_test_ofp(10, 12, true),
            get_test_ofp(10, 14, true),
        ])?;

        // Menu where 2nd item has larger min_fee_msat, larger proportional is valid
        OpeningFeeParamsMenu::try_from(vec![
            get_test_ofp(10, 12, true),
            get_test_ofp(12, 14, true),
        ])?;

        // All other combinations of min_fee_msat / proportional are invalid
        // same min_msat, same proportional
        assert!(OpeningFeeParamsMenu::try_from(vec![
            get_test_ofp(10, 12, true),
            get_test_ofp(10, 12, true),
        ])
        .is_err());
        // same min_msat, reverse-sorted proportional
        assert!(OpeningFeeParamsMenu::try_from(vec![
            get_test_ofp(10, 12, true),
            get_test_ofp(10, 10, true),
        ])
        .is_err());
        // reverse-sorted min_msat, same proportional
        assert!(OpeningFeeParamsMenu::try_from(vec![
            get_test_ofp(12, 10, true),
            get_test_ofp(10, 10, true),
        ])
        .is_err());

        // Sorted, but with one expired entry, is invalid
        assert!(OpeningFeeParamsMenu::try_from(vec![
            get_test_ofp(10, 10, true),
            get_test_ofp(12, 12, false),
        ])
        .is_err());

        // Sorted, but with all expired entries, is invalid (because it results in an empty list)
        assert!(OpeningFeeParamsMenu::try_from(vec![
            get_test_ofp(10, 10, false),
            get_test_ofp(12, 12, false),
        ])
        .is_err());

        Ok(())
    }

    #[test]
    fn test_payment_information_ser_de() -> Result<()> {
        let dummy_payment_info = PaymentInformation {
            payment_hash: rand_vec_u8(10),
            payment_secret: rand_vec_u8(10),
            destination: rand_vec_u8(10),
            incoming_amount_msat: random(),
            outgoing_amount_msat: random(),
            tag: "".to_string(),
            opening_fee_params: None,
        };

        let mut buf = Vec::with_capacity(dummy_payment_info.encoded_len());
        dummy_payment_info.encode(&mut buf)?;

        let decoded_payment_info: PaymentInformation = PaymentInformation::decode(&*buf)?;

        assert_eq!(dummy_payment_info, decoded_payment_info);

        Ok(())
    }

    #[test]
    fn test_dynamic_fee_valid_until_format() -> Result<()> {
        let mut ofp: OpeningFeeParams = get_test_ofp(1, 1, true).into();
        ofp.valid_until = "2023-08-03T00:30:35.117Z".to_string();
        ofp.valid_until_date().map(|_| ())
    }
}
