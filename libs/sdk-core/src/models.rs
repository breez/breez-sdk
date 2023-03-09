use anyhow::{anyhow, Result};
use gl_client::pb::Peer;
use gl_client::pb::WithdrawResponse;
use gl_client::pb::{CloseChannelResponse, Invoice};
use lightning_invoice::RawInvoice;
use serde::{Deserialize, Serialize};
use strum_macros::Display;
use strum_macros::EnumString;
use tokio::sync::mpsc;
use tonic::Streaming;

use crate::fiat::{FiatCurrency, Rate};
use crate::grpc::{PaymentInformation, RegisterPaymentReply};
use crate::lnurl::pay::model::SuccessActionProcessed;
use crate::lsp::LspInformation;
use crate::models::Network::*;
use crate::reverseswap::CreateReverseSwapResponse;

/// Different types of supported payments
#[derive(Clone, PartialEq, Eq, Debug, EnumString, Display, Deserialize, Serialize)]
pub enum PaymentType {
    Sent,
    Received,
    ClosedChannel,
}

/// Trait covering functions affecting the LN node
#[tonic::async_trait]
pub trait NodeAPI: Send + Sync {
    async fn create_invoice(
        &self,
        amount_sats: u64,
        description: String,
        preimage: Option<Vec<u8>>,
    ) -> Result<Invoice>;
    async fn pull_changed(&self, since_timestamp: i64) -> Result<SyncResponse>;
    /// As per the `pb::PayRequest` docs, `amount_sats` is only needed when the invoice doesn't specify an amount
    async fn send_payment(
        &self,
        bolt11: String,
        amount_sats: Option<u64>,
    ) -> Result<crate::models::Payment>;
    async fn send_spontaneous_payment(
        &self,
        node_id: String,
        amount_sats: u64,
    ) -> Result<crate::models::Payment>;
    async fn start(&self) -> Result<()>;
    async fn sweep(
        &self,
        to_address: String,
        fee_rate_sats_per_byte: u64,
    ) -> Result<WithdrawResponse>;
    async fn start_signer(&self, shutdown: mpsc::Receiver<()>);
    async fn list_peers(&self) -> Result<Vec<Peer>>;
    async fn connect_peer(&self, node_id: String, addr: String) -> Result<()>;
    fn sign_invoice(&self, invoice: RawInvoice) -> Result<String>;
    async fn close_peer_channels(&self, node_id: String) -> Result<CloseChannelResponse>;
    async fn stream_incoming_payments(&self) -> Result<Streaming<gl_client::pb::IncomingPayment>>;
    async fn stream_log_messages(&self) -> Result<Streaming<gl_client::pb::LogEntry>>;
    async fn execute_command(&self, command: String) -> Result<String>;
}

/// Trait covering LSP-related functionality
#[tonic::async_trait]
pub trait LspAPI: Send + Sync {
    async fn list_lsps(&self, node_pubkey: String) -> Result<Vec<LspInformation>>;
    async fn register_payment(
        &self,
        lsp_id: String,
        lsp_pubkey: Vec<u8>,
        payment_info: PaymentInformation,
    ) -> Result<RegisterPaymentReply>;
}

/// Trait covering fiat-related functionality
#[tonic::async_trait]
pub trait FiatAPI: Send + Sync {
    /// List all supported fiat currencies for which there is a known exchange rate.
    async fn list_fiat_currencies(&self) -> Result<Vec<FiatCurrency>>;

    /// Get the live rates from the server.
    async fn fetch_fiat_rates(&self) -> Result<Vec<Rate>>;
}

/// Summary of an ongoing swap
pub struct Swap {
    pub bitcoin_address: String,
    pub swapper_pubkey: Vec<u8>,
    pub lock_height: i64,
    pub max_allowed_deposit: i64,
    pub error_message: String,
    pub required_reserve: i64,
    pub min_allowed_deposit: i64,
}

/// Trait covering functionality involving swaps
#[tonic::async_trait]
pub trait SwapperAPI: Send + Sync {
    async fn create_swap(
        &self,
        hash: Vec<u8>,
        payer_pubkey: Vec<u8>,
        node_pubkey: String,
    ) -> Result<Swap>;

    async fn complete_swap(&self, bolt11: String) -> Result<()>;
}

/// Details about the BTC/BTC reverse swap pair, at this point in time
///
/// Maps the result of https://docs.boltz.exchange/en/latest/api/#getting-pairs for the BTC/BTC pair
#[derive(Clone, PartialEq, Debug)]
pub struct ReverseSwapPairInfo {
    /// Minimum amount of sats a reverse swap is allowed to have on this endpoint
    pub min: u64,
    /// Maximum amount of sats a reverse swap is allowed to have on this endpoint
    pub max: u64,
    /// Hash of the pair info JSON
    pub fees_hash: String,
    /// Percentage fee for the Boltz service
    pub fees_percentage: f64,
    /// Estimated miner fees in sats for locking up funds
    pub fees_lockup: u64,
    /// Estimated miner fees in sats for claiming funds
    pub fees_claim: u64,
}

/// Details of past or ongoing reverse swaps, as stored in the Breez local DB
#[derive(Clone, Debug)]
pub struct ReverseSwapInfo {
    // static immutable data
    pub claim_address: String,
    pub lockup_address: String,

    // dynamic data
    pub status: ReverseSwapStatus,
}

/// The status of a reverse swap
#[derive(Clone, PartialEq, Eq, Debug)]
pub enum ReverseSwapStatus {
    /// The reverse swap has been created. The HODL invoice is not yet paid.
    Initial = 0,

    /// The HODL invoice has been paid.
    InvoicePaid = 1,

    /// The lock transaction has 1 confirmation.
    LockTxConfirmed = 2,

    /// The claim transaction has 1 confirmation.
    ClaimTxConfirmed = 3,

    /// The blockchain reached [CreateReverseSwapResponse::timeout_block_height] before the reverse
    /// swap completed
    Cancelled = 4,
}

/// Information about a reverse swap that was just started with Boltz
#[derive(Debug)]
pub struct ReverseSwap {
    pub error_message: Option<String>,
    pub response: CreateReverseSwapResponse,
}

/// Trait covering functionality involving swaps
#[tonic::async_trait]
pub trait ReverseSwapperAPI: Send + Sync {
    async fn reverse_swap_info(&self) -> Result<ReverseSwapPairInfo>;

    /// Creates a reverse submarine swap
    ///
    /// # Arguments
    ///
    /// * `amount_sat` - Amount that is to be swapped
    /// * `onchain_claim_address` - BTC address at which the reverse swap will be claimed, in compressed format
    /// * `pair_hash` - The hash of the exchange rate, looked-up before this call
    /// * `routing_node` - Pubkey of a LN node used as routing hint
    async fn create_reverse_swap(
        &self,
        amount_sat: u64,
        onchain_claim_address: String,
        pair_hash: String,
        routing_node: String,
    ) -> Result<ReverseSwap>;
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
    pub mempoolspace_url: String,
    pub working_dir: String,
    pub network: Network,
    pub payment_timeout_sec: u32,
    pub default_lsp_id: Option<String>,
    pub api_key: Option<String>,
    pub maxfee_sat: Option<u64>,
    pub maxfeepercent: f64,
}

impl Config {
    pub fn production() -> Self {
        Config {
            breezserver: "https://bs1.breez.technology:443".to_string(),
            mempoolspace_url: "https://mempool.space".to_string(),
            working_dir: ".".to_string(),
            network: Bitcoin,
            payment_timeout_sec: 60,
            default_lsp_id: Some(String::from("03cea51f-b654-4fb0-8e82-eca137f236a0")),
            api_key: None,
            maxfee_sat: None,
            maxfeepercent: 0.5,
        }
    }

    pub fn staging() -> Self {
        // TODO Update with staging values
        Config {
            breezserver: "https://bs1-st.breez.technology:443".to_string(),
            mempoolspace_url: "https://mempool.space".to_string(),
            working_dir: ".".to_string(),
            network: Bitcoin,
            payment_timeout_sec: 60,
            default_lsp_id: Some(String::from("ea51d025-042d-456c-8325-63e430797481")),
            api_key: None,
            maxfee_sat: None,
            maxfeepercent: 0.5,
        }
    }
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
#[derive(Clone, Debug, Eq, PartialEq)]
pub enum Network {
    /// Mainnet
    Bitcoin,
    Testnet,
    Signet,
    Regtest,
}

impl From<bitcoin::network::constants::Network> for Network {
    fn from(network: bitcoin::network::constants::Network) -> Self {
        match network {
            bitcoin::network::constants::Network::Bitcoin => Bitcoin,
            bitcoin::network::constants::Network::Testnet => Testnet,
            bitcoin::network::constants::Network::Signet => Signet,
            bitcoin::network::constants::Network::Regtest => Regtest,
        }
    }
}

impl From<Network> for bitcoin::network::constants::Network {
    fn from(network: Network) -> Self {
        match network {
            Bitcoin => bitcoin::network::constants::Network::Bitcoin,
            Testnet => bitcoin::network::constants::Network::Testnet,
            Signet => bitcoin::network::constants::Network::Signet,
            Regtest => bitcoin::network::constants::Network::Regtest,
        }
    }
}

/// Different types of supported filters which can be applied when retrieving the transaction list
pub enum PaymentTypeFilter {
    Sent,
    Received,
    All,
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

/// The node state of a Greenlight LN node running in the cloud
#[derive(Serialize, Deserialize, Clone, PartialEq, Eq, Debug)]
pub struct NodeState {
    pub id: String,
    pub block_height: u32,
    pub channels_balance_msat: u64,
    pub onchain_balance_msat: u64,

    #[serde(default)]
    pub utxos: Vec<UnspentTransactionOutput>,
    pub max_payable_msat: u64,
    pub max_receivable_msat: u64,
    pub max_single_payment_amount_msat: u64,
    pub max_chan_reserve_msats: u64,
    pub connected_peers: Vec<String>,
    pub inbound_liquidity_msats: u64,
}

/// Internal response to a [NodeAPI::pull_changed] call
pub struct SyncResponse {
    pub node_state: NodeState,
    pub payments: Vec<crate::models::Payment>,
    pub channels: Vec<crate::models::Channel>,
}

/// Represents a payment, including its [PaymentType] and [PaymentDetails].
#[derive(PartialEq, Eq, Debug, Clone)]
pub struct Payment {
    pub id: String,
    pub payment_type: PaymentType,
    pub payment_time: i64,
    pub amount_msat: u64,
    pub fee_msat: u64,
    pub pending: bool,
    pub description: Option<String>,
    pub details: PaymentDetails,
}

/// Wrapper for the different types of payments
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

/// Details of a LN payment, as included in a [Payment]
#[derive(PartialEq, Eq, Debug, Clone, Deserialize, Serialize)]
pub struct LnPaymentDetails {
    pub payment_hash: String,
    pub label: String,
    pub destination_pubkey: String,
    pub payment_preimage: String,
    pub keysend: bool,
    pub bolt11: String,

    /// Only set for [PaymentType::Sent] payments that are part of a LNURL-pay workflow where
    /// the endpoint returns a success action
    pub lnurl_success_action: Option<SuccessActionProcessed>,
}

/// Represents the funds that were on the user side of the channel at the time it was closed.
#[derive(PartialEq, Eq, Debug, Clone, Deserialize, Serialize)]
pub struct ClosedChannelPaymentDetails {
    pub short_channel_id: String,
    pub state: ChannelState,
    pub funding_txid: String,
}

/// Lightning channel
#[derive(Clone, PartialEq, Eq, Debug)]
pub struct Channel {
    pub funding_txid: String,
    pub short_channel_id: String,
    pub state: ChannelState,
    pub spendable_msat: u64,
    pub receivable_msat: u64,
    pub closed_at: Option<u64>,
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
#[derive(Clone, PartialEq, Eq, Debug)]
pub enum SwapStatus {
    /// The swap address has been created and either there aren't any confirmed transactions associated with it
    /// or there are confirmed transactions that are bellow the lock timeout which means the funds are still
    /// eligible to be redeemed normally.
    Initial = 0,

    /// The swap address has confirmed transactions associated with it and the lock timeout has passed since
    /// the earliest confirmed transaction. This means the only way to spend the funds from this address is by
    /// broadcasting a refund transaction.
    Expired = 1,
}

impl TryFrom<i32> for SwapStatus {
    type Error = anyhow::Error;

    fn try_from(value: i32) -> Result<Self, Self::Error> {
        match value {
            0 => Ok(SwapStatus::Initial),
            1 => Ok(SwapStatus::Expired),
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
#[derive(Clone, PartialEq, Eq, Debug)]
pub struct SwapInfo {
    //static immutable data
    pub bitcoin_address: String,
    pub created_at: i64,
    pub lock_height: i64,
    pub payment_hash: Vec<u8>,
    pub preimage: Vec<u8>,
    pub private_key: Vec<u8>,
    pub public_key: Vec<u8>,
    pub swapper_public_key: Vec<u8>,
    pub script: Vec<u8>,

    // dynamic data
    pub bolt11: Option<String>,
    pub paid_sats: u32,
    pub confirmed_sats: u32,
    pub unconfirmed_sats: u32,
    pub status: SwapStatus,
    pub refund_tx_ids: Vec<String>,
    pub unconfirmed_tx_ids: Vec<String>,
    pub confirmed_tx_ids: Vec<String>,
    pub min_allowed_deposit: i64,
    pub max_allowed_deposit: i64,
    pub last_redeem_error: Option<String>,
}

impl SwapInfo {
    pub(crate) fn unused(&self) -> bool {
        self.confirmed_sats == 0
            && self.unconfirmed_sats == 0
            && self.paid_sats == 0
            && self.status != SwapStatus::Expired
    }

    pub(crate) fn in_progress(&self) -> bool {
        (self.confirmed_sats > 0 || self.unconfirmed_sats > 0)
            && self.paid_sats == 0
            && self.status != SwapStatus::Expired
    }

    pub(crate) fn redeemable(&self) -> bool {
        self.unconfirmed_sats == 0
            && self.confirmed_sats > 0
            && self.paid_sats == 0
            && self.status != SwapStatus::Expired
    }

    pub(crate) fn refundable(&self) -> bool {
        self.confirmed_sats > self.paid_sats && self.status == SwapStatus::Expired
    }

    pub(crate) fn monitored(&self) -> bool {
        self.unused() || self.in_progress() || self.refundable()
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

/// UTXO known to the LN node
#[derive(Serialize, Deserialize, Clone, PartialEq, Eq, Debug)]
pub struct UnspentTransactionOutput {
    pub txid: Vec<u8>,
    pub outnum: u32,
    pub amount_millisatoshi: u64,
    pub address: String,
    #[serde(default)]
    pub reserved: bool,
    #[serde(default)]
    pub reserved_to_block: u32,
}

#[cfg(test)]
mod tests {
    use prost::Message;
    use rand::random;

    use crate::grpc::PaymentInformation;
    use crate::test_utils::rand_vec_u8;

    #[test]
    fn test_payment_information_ser_de() -> Result<(), Box<dyn std::error::Error>> {
        let dummy_payment_info = PaymentInformation {
            payment_hash: rand_vec_u8(10),
            payment_secret: rand_vec_u8(10),
            destination: rand_vec_u8(10),
            incoming_amount_msat: random(),
            outgoing_amount_msat: random(),
        };

        let mut buf = Vec::new();
        buf.reserve(dummy_payment_info.encoded_len());
        dummy_payment_info.encode(&mut buf)?;

        let decoded_payment_info: PaymentInformation = PaymentInformation::decode(&*buf)?;

        assert_eq!(dummy_payment_info, decoded_payment_info);

        Ok(())
    }
}
