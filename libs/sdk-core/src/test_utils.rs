use std::collections::{HashMap, HashSet};
use std::pin::Pin;
use std::time::{Duration, SystemTime};
use std::{mem, vec};

use anyhow::{Error, Result};
use chrono::{SecondsFormat, Utc};
use gl_client::signer::model::greenlight::amount::Unit;
use gl_client::signer::model::greenlight::Amount;
use gl_client::signer::model::greenlight::PayStatus;
use rand::distributions::uniform::{SampleRange, SampleUniform};
use rand::distributions::{Alphanumeric, DistString, Standard};
use rand::rngs::OsRng;
use rand::{random, Rng};
use sdk_common::grpc;
use sdk_common::prelude::{FiatAPI, FiatCurrency, Rate};
use tokio::sync::{mpsc, watch, Mutex};
use tokio::time::sleep;
use tokio_stream::Stream;
use tokio_stream::StreamExt;
use tonic::Streaming;

use crate::backup::{BackupState, BackupTransport};
use crate::bitcoin::hashes::hex::ToHex;
use crate::bitcoin::hashes::{sha256, Hash};
use crate::bitcoin::secp256k1::ecdsa::RecoverableSignature;
use crate::bitcoin::secp256k1::{KeyPair, Message, PublicKey, Secp256k1, SecretKey};
use crate::bitcoin::util::bip32::{ChildNumber, ExtendedPrivKey};
use crate::bitcoin::Network;
use crate::breez_services::{OpenChannelParams, Receiver};
use crate::buy::BuyBitcoinApi;
use crate::chain::{ChainService, OnchainTx, Outspend, RecommendedFees, TxStatus};
use crate::error::{ReceivePaymentError, SdkError, SdkResult};
use crate::invoice::{InvoiceError, InvoiceResult};
use crate::lightning::ln::PaymentSecret;
use crate::lightning_invoice::{Currency, InvoiceBuilder, RawBolt11Invoice};
use crate::lsp::LspInformation;
use crate::models::{
    LspAPI, NodeState, Payment, ReverseSwapServiceAPI, Swap, SwapperAPI, SyncResponse, TlvEntry,
};
use crate::node_api::{CreateInvoiceRequest, FetchBolt11Result, NodeAPI, NodeError, NodeResult};
use crate::swap_in::error::SwapResult;
use crate::swap_in::swap::create_submarine_swap_script;
use crate::swap_out::boltzswap::{BoltzApiCreateReverseSwapResponse, BoltzApiReverseSwapStatus};
use crate::swap_out::error::{ReverseSwapError, ReverseSwapResult};
use crate::{
    parse_invoice, BuyBitcoinProvider, Config, CustomMessage, LNInvoice, MaxChannelAmount,
    NodeCredentials, OpeningFeeParamsMenu, PaymentResponse, PrepareRedeemOnchainFundsRequest,
    PrepareRedeemOnchainFundsResponse, ReceivePaymentRequest, ReverseSwapPairInfo, RouteHint,
    RouteHintHop, SwapInfo,
};

pub const MOCK_REVERSE_SWAP_MIN: u64 = 50_000;
pub const MOCK_REVERSE_SWAP_MAX: u64 = 1_000_000;

pub struct MockBackupTransport {
    pub num_pushed: std::sync::Mutex<u32>,
    pub num_pulled: std::sync::Mutex<u32>,
    pub remote_version: std::sync::Mutex<Option<u64>>,
    pub state: std::sync::Mutex<Option<BackupState>>,
}

impl MockBackupTransport {
    pub fn new() -> Self {
        MockBackupTransport {
            num_pushed: std::sync::Mutex::new(0),
            num_pulled: std::sync::Mutex::new(0),
            remote_version: std::sync::Mutex::new(None),
            state: std::sync::Mutex::new(None),
        }
    }
    pub fn pushed(&self) -> u32 {
        *self.num_pushed.lock().unwrap()
    }
    pub fn pulled(&self) -> u32 {
        *self.num_pulled.lock().unwrap()
    }
}

#[tonic::async_trait]
impl BackupTransport for MockBackupTransport {
    async fn pull(&self) -> SdkResult<Option<BackupState>> {
        sleep(Duration::from_millis(10)).await;
        *self.num_pulled.lock().unwrap() += 1;
        let current_state = self.state.lock().unwrap();

        match current_state.clone() {
            Some(state) => Ok(Some(state)),
            None => Ok(None),
        }
    }
    async fn push(&self, version: Option<u64>, data: Vec<u8>) -> SdkResult<u64> {
        sleep(Duration::from_millis(10)).await;
        let mut remote_version = self.remote_version.lock().unwrap();
        let mut numpushed = self.num_pushed.lock().unwrap();
        *numpushed += 1;

        if !remote_version.is_none() && *remote_version != version {
            return Err(SdkError::Generic {
                err: "version mismatch".into(),
            });
        }
        let next_version = match version {
            Some(v) => v + 1,
            None => 1,
        };
        *remote_version = Some(next_version);
        *self.state.lock().unwrap() = Some(BackupState {
            generation: next_version,
            data,
        });
        Ok(next_version)
    }
}

pub struct MockSwapperAPI {}

#[tonic::async_trait]
impl SwapperAPI for MockSwapperAPI {
    async fn create_swap(
        &self,
        hash: Vec<u8>,
        payer_pubkey: Vec<u8>,
        _node_pubkey: String,
    ) -> SwapResult<Swap> {
        let mut swapper_priv_key_raw = [2; 32];
        rand::thread_rng().fill(&mut swapper_priv_key_raw);

        let secp = Secp256k1::new();
        // swapper keys
        let swapper_private_key = SecretKey::from_slice(&swapper_priv_key_raw).unwrap();
        let swapper_pub_key = PublicKey::from_secret_key(&secp, &swapper_private_key)
            .serialize()
            .to_vec();

        let script =
            create_submarine_swap_script(hash, swapper_pub_key.clone(), payer_pubkey, 144).unwrap();
        let address = crate::bitcoin::Address::p2wsh(&script, crate::bitcoin::Network::Bitcoin);

        Ok(Swap {
            bitcoin_address: address.to_string(),
            swapper_pubkey: swapper_pub_key,
            lock_height: 144,
            swapper_max_payable: 4_000_000,
            error_message: "".to_string(),
            required_reserve: 0,
            swapper_min_payable: 3_000,
        })
    }

    async fn complete_swap(&self, _bolt11: String) -> Result<()> {
        Ok(())
    }
}

pub struct MockReverseSwapperAPI {}

#[tonic::async_trait]
impl ReverseSwapServiceAPI for MockReverseSwapperAPI {
    async fn fetch_reverse_swap_fees(&self) -> ReverseSwapResult<ReverseSwapPairInfo> {
        Ok(ReverseSwapPairInfo {
            min: MOCK_REVERSE_SWAP_MIN,
            max: MOCK_REVERSE_SWAP_MAX,
            fees_hash: rand_string(5),
            fees_percentage: 0.5,
            fees_lockup: 3_000 + rand_int_in_range(1..1_000),
            fees_claim: 3_000 + rand_int_in_range(1..1_000),
            total_fees: None,
        })
    }

    async fn create_reverse_swap_on_remote(
        &self,
        _amount_sat: u64,
        _preimage_hash_hex: String,
        _claim_pubkey: String,
        _pair_hash: String,
        _routing_node: String,
    ) -> ReverseSwapResult<BoltzApiCreateReverseSwapResponse> {
        Err(ReverseSwapError::generic("Not implemented"))
    }

    async fn get_boltz_status(&self, _id: String) -> ReverseSwapResult<BoltzApiReverseSwapStatus> {
        Err(ReverseSwapError::generic("Not implemented"))
    }

    async fn get_route_hints(&self, _routing_node_id: String) -> ReverseSwapResult<Vec<RouteHint>> {
        Err(ReverseSwapError::generic("Not implemented"))
    }
}

#[derive(Clone)]
pub struct MockChainService {
    pub tip: u32,
    pub recommended_fees: RecommendedFees,
    pub address_to_transactions: HashMap<String, Vec<OnchainTx>>,
}

impl Default for MockChainService {
    fn default() -> Self {
        let recommended_fees: RecommendedFees = serde_json::from_str(
            r#"{
               "fastestFee": 1,
               "halfHourFee": 1,
               "hourFee": 1,
               "economyFee": 1,
               "minimumFee": 1
             }"#,
        )
        .unwrap();

        let txs: Vec<OnchainTx> = serde_json::from_str(
                r#"[{"txid":"a418e856bb22b6345868dc0b1ac1dd7a6b7fae1d231b275b74172f9584fa0bdf","version":1,"locktime":0,"vin":[{"txid":"ec901bcab07df7d475d98fff2933dcb56d57bbdaa029c4142aed93462b6928fe","vout":0,"prevout":{"scriptpubkey":"0014b34b7da80e662d1db3fcfbe34b7f4cacc4fac34d","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 b34b7da80e662d1db3fcfbe34b7f4cacc4fac34d","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qkd9hm2qwvck3mvlul035kl6v4nz04s6dmryeq5","value":197497253},"scriptsig":"","scriptsig_asm":"","witness":["304502210089933e46614114e060d3d681c54af71e3d47f8be8131d9310ef8fe231c060f3302204103910a6790e3a678964df6f0f9ae2107666a91e777bd87f9172a28653e374701","0356f385879fefb8c52758126f6e7b9ac57374c2f73f2ee9047b4c61df0ba390b9"],"is_coinbase":false,"sequence":4294967293},{"txid":"fda3ce37f5fb849502e2027958d51efebd1841cb43bbfdd5f3d354c93a551ef9","vout":0,"prevout":{"scriptpubkey":"00145c7f3b6ceb79d03d5a5397df83f2334394ebdd2c","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 5c7f3b6ceb79d03d5a5397df83f2334394ebdd2c","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qt3lnkm8t08gr6kjnjl0c8u3ngw2whhfvzwsxrg","value":786885},"scriptsig":"","scriptsig_asm":"","witness":["304402200ae5465efe824609f7faf1094cce0195763df52e5409dd9ae0526568bf3bcaa20220103749041a87e082cf95bf1e12c5174881e5e4c55e75ab2db29a68538dbabbad01","03dfd8cc1f72f46d259dc0afc6d756bce551fce2fbf58a9ad36409a1b82a17e64f"],"is_coinbase":false,"sequence":4294967293}],"vout":[{"scriptpubkey":"a9141df45814863edfd6d87457e8f8bd79607a116a8f87","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 1df45814863edfd6d87457e8f8bd79607a116a8f OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"34RQERthXaruAXtW6q1bvrGTeUbqi2Sm1i","value":26087585},{"scriptpubkey":"001479001aa5f4b981a0b654c3f834d0573595b0ed53","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 79001aa5f4b981a0b654c3f834d0573595b0ed53","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1q0yqp4f05hxq6pdj5c0urf5zhxk2mpm2ndx85za","value":171937413}],"size":372,"weight":837,"fee":259140,"status":{"confirmed":true,"block_height":767637,"block_hash":"000000000000000000077769f3b2e6a28b9ed688f0d773f9ff2d73c622a2cfac","block_time":1671174562}},{"txid":"ec901bcab07df7d475d98fff2933dcb56d57bbdaa029c4142aed93462b6928fe","version":1,"locktime":767636,"vin":[{"txid":"d4344fc9e7f66b3a1a50d1d76836a157629ba0c6ede093e94f1c809d334c9146","vout":0,"prevout":{"scriptpubkey":"0014cab22290b7adc75f861de820baa97d319c1110a6","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 cab22290b7adc75f861de820baa97d319c1110a6","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qe2ez9y9h4hr4lpsaaqst42taxxwpzy9xlzqt8k","value":209639471},"scriptsig":"","scriptsig_asm":"","witness":["304402202e914c35b75da798f0898c7cfe6ead207aaee41219afd77124fd56971f05d9030220123ce5d124f4635171b7622995dae35e00373a5fbf8117bfdca5e5080ad6554101","02122fa6d20413bb5da5c7e3fb42228be5436b1bd84e29b294bfc200db5eac460e"],"is_coinbase":false,"sequence":4294967293}],"vout":[{"scriptpubkey":"0014b34b7da80e662d1db3fcfbe34b7f4cacc4fac34d","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 b34b7da80e662d1db3fcfbe34b7f4cacc4fac34d","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qkd9hm2qwvck3mvlul035kl6v4nz04s6dmryeq5","value":197497253},{"scriptpubkey":"0014f0e2a057d0e60411ac3d7218e29bf9489a59df18","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 f0e2a057d0e60411ac3d7218e29bf9489a59df18","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1q7r32q47suczprtpawgvw9xlefzd9nhccyatxvu","value":12140465}],"size":222,"weight":561,"fee":1753,"status":{"confirmed":true,"block_height":767637,"block_hash":"000000000000000000077769f3b2e6a28b9ed688f0d773f9ff2d73c622a2cfac","block_time":1671174562}}]"#,
            ).unwrap();
        Self {
            tip: 767640,
            recommended_fees,
            address_to_transactions: HashMap::from([(
                "bc1qkd9hm2qwvck3mvlul035kl6v4nz04s6dmryeq5".to_string(),
                txs,
            )]),
        }
    }
}

#[tonic::async_trait]
impl ChainService for MockChainService {
    async fn recommended_fees(&self) -> SdkResult<RecommendedFees> {
        Ok(self.recommended_fees.clone())
    }

    async fn address_transactions(&self, address: String) -> SdkResult<Vec<OnchainTx>> {
        Ok(self
            .address_to_transactions
            .get(&address)
            .unwrap_or(&Vec::<OnchainTx>::new())
            .clone())
    }

    async fn current_tip(&self) -> SdkResult<u32> {
        Ok(self.tip)
    }

    async fn transaction_outspends(&self, _txid: String) -> SdkResult<Vec<Outspend>> {
        Ok(vec![Outspend {
            spent: true,
            txid: Some("test-tx-id".into()),
            vin: Some(0),
            status: Some(TxStatus {
                confirmed: true,
                block_height: Some(123),
                block_hash: Some("test-hash".into()),
                block_time: Some(123),
            }),
        }])
    }

    async fn broadcast_transaction(&self, _tx: Vec<u8>) -> SdkResult<String> {
        let mut array = [0; 32];
        rand::thread_rng().fill(&mut array);
        Ok(hex::encode(array))
    }
}

impl TryFrom<Payment> for crate::models::PaymentResponse {
    type Error = anyhow::Error;

    fn try_from(payment: Payment) -> std::result::Result<Self, Self::Error> {
        let payment_hash: String = match payment.details.clone() {
            crate::models::PaymentDetails::Ln { data } => data.payment_hash,
            _ => "".into(),
        };
        let payment_preimage: String = match payment.details.clone() {
            crate::models::PaymentDetails::Ln { data } => data.payment_preimage,
            _ => "".into(),
        };
        Ok(crate::models::PaymentResponse {
            payment_time: payment.payment_time,
            amount_msat: payment.amount_msat,
            fee_msat: payment.fee_msat,
            payment_hash,
            payment_preimage,
        })
    }
}

pub struct MockReceiver {
    pub bolt11: String,
}

impl Default for MockReceiver {
    fn default() -> Self {
        MockReceiver { bolt11: "lnbc500u1p3eerl2dq8w3jhxaqpp5w3w4z63erts5usxtkvpwdy356l29xfd43mnzlq6x2d69kqhjtepsxqyjw5qsp5an4vlkhp8cgahvamrdkn2uzmmcd5neq7yq3j6a8v0sc0q9rlde5s9qrsgqcqpxrzjqwk7573qcyfskzw33jnvs0shq9tzy28sd86naqlgkdga9p8z74fsyzancsqqvpsqqqqqqqlgqqqqqzsqygrzjqwk7573qcyfskzw33jnvs0shq9tzy28sd86naqlgkdga9p8z74fsyqqqqyqqqqqqqqqqqqlgqqqqqzsqjqacpq7rd5rf7ssza0lps93ehylrwtjhdlk44g0llwp039f8uqxsck52ccr69djxs59mmwqkvvglylpg0cdzaqusg9m9cyju92t7kjpfsqma2lmf".to_string() }
    }
}

#[tonic::async_trait]
impl Receiver for MockReceiver {
    async fn receive_payment(
        &self,
        _request: ReceivePaymentRequest,
    ) -> Result<crate::ReceivePaymentResponse, ReceivePaymentError> {
        Ok(crate::ReceivePaymentResponse {
            ln_invoice: parse_invoice(&self.bolt11)?,
            opening_fee_params: _request.opening_fee_params,
            opening_fee_msat: None,
        })
    }
    async fn wrap_node_invoice(
        &self,
        invoice: &str,
        _params: Option<OpenChannelParams>,
        _lsp_info: Option<LspInformation>,
    ) -> Result<String, ReceivePaymentError> {
        Ok(String::from(invoice))
    }
}

pub struct MockNodeAPI {
    /// Simulated repository of confirmed new outgoing payments.
    ///
    /// Each call to [MockNodeAPI::add_dummy_payment_for] will add the new payment here such that
    /// [NodeAPI::pull_changed], which is called in [BreezServices::sync], always retrieves the newly
    /// added test payments
    cloud_payments: Mutex<Vec<gl_client::signer::model::greenlight::Payment>>,
    node_state: NodeState,
    on_send_custom_message: Box<dyn Fn(CustomMessage) -> NodeResult<()> + Sync + Send>,
    on_stream_custom_messages: Mutex<mpsc::Receiver<CustomMessage>>,
}

#[tonic::async_trait]
impl NodeAPI for MockNodeAPI {
    fn node_credentials(&self) -> NodeResult<Option<NodeCredentials>> {
        Err(NodeError::Generic("Not implemented".to_string()))
    }

    async fn configure_node(&self, _close_to_address: Option<String>) -> NodeResult<()> {
        Ok(())
    }

    async fn create_invoice(&self, request: CreateInvoiceRequest) -> NodeResult<String> {
        let invoice = create_invoice(
            request.description,
            request.amount_msat,
            vec![],
            request.preimage,
        );
        Ok(invoice.bolt11)
    }

    async fn pull_changed(
        &self,
        _since_timestamp: u64,
        _balance_changed: bool,
    ) -> NodeResult<SyncResponse> {
        Ok(SyncResponse {
            node_state: self.node_state.clone(),
            payments: self
                .cloud_payments
                .lock()
                .await
                .iter()
                .cloned()
                .flat_map(TryInto::try_into)
                .collect(),
            channels: Vec::new(),
        })
    }

    async fn send_pay(&self, _bolt11: String, _max_hops: u32) -> NodeResult<PaymentResponse> {
        Err(NodeError::Generic("Not implemented".to_string()))
    }

    async fn send_payment(
        &self,
        bolt11: String,
        _amount_msat: Option<u64>,
        _label: Option<String>,
    ) -> NodeResult<Payment> {
        let payment = self.add_dummy_payment_for(bolt11, None, None).await?;
        Ok(payment)
    }

    async fn send_trampoline_payment(
        &self,
        bolt11: String,
        _amount_msat: u64,
        _label: Option<String>,
        _trampoline_id: Vec<u8>,
    ) -> NodeResult<Payment> {
        let payment = self.add_dummy_payment_for(bolt11, None, None).await?;
        Ok(payment)
    }

    async fn send_spontaneous_payment(
        &self,
        _node_id: String,
        _amount_msat: u64,
        _extra_tlvs: Option<Vec<TlvEntry>>,
        _label: Option<String>,
    ) -> NodeResult<Payment> {
        let payment = self.add_dummy_payment_rand().await?;
        Ok(payment)
    }

    async fn start(&self) -> NodeResult<String> {
        Ok("".to_string())
    }

    async fn redeem_onchain_funds(
        &self,
        _to_address: String,
        _sat_per_vbyte: u32,
    ) -> NodeResult<Vec<u8>> {
        Ok(rand_vec_u8(32))
    }

    async fn prepare_redeem_onchain_funds(
        &self,
        _req: PrepareRedeemOnchainFundsRequest,
    ) -> NodeResult<PrepareRedeemOnchainFundsResponse> {
        Err(NodeError::Generic("Not implemented".to_string()))
    }

    async fn start_signer(&self, _shutdown: mpsc::Receiver<()>) {}

    async fn start_keep_alive(&self, _shutdown: watch::Receiver<()>) {}

    async fn connect_peer(&self, _node_id: String, _addr: String) -> NodeResult<()> {
        Ok(())
    }

    async fn sign_message(&self, _message: &str) -> NodeResult<String> {
        Ok("".to_string())
    }

    async fn check_message(
        &self,
        _message: &str,
        _pubkey: &str,
        _signature: &str,
    ) -> NodeResult<bool> {
        Ok(true)
    }

    fn sign_invoice(&self, invoice: RawBolt11Invoice) -> NodeResult<String> {
        Ok(sign_invoice(invoice))
    }

    async fn close_peer_channels(&self, _node_id: String) -> NodeResult<Vec<String>> {
        Ok(vec![])
    }
    async fn stream_incoming_payments(
        &self,
    ) -> NodeResult<Streaming<gl_client::signer::model::greenlight::IncomingPayment>> {
        Err(NodeError::Generic("Not implemented".to_string()))
    }

    async fn stream_log_messages(
        &self,
    ) -> NodeResult<Streaming<gl_client::signer::model::greenlight::LogEntry>> {
        Err(NodeError::Generic("Not implemented".to_string()))
    }

    async fn static_backup(&self) -> NodeResult<Vec<String>> {
        Ok(Vec::new())
    }

    async fn execute_command(&self, _command: String) -> NodeResult<String> {
        Err(NodeError::Generic("Not implemented".to_string()))
    }

    async fn generate_diagnostic_data(&self) -> NodeResult<String> {
        Ok("".to_string())
    }

    async fn max_sendable_amount(
        &self,
        _payee_node_id: Option<Vec<u8>>,
        _max_hops: u32,
        _last_hop: Option<&RouteHintHop>,
    ) -> NodeResult<Vec<MaxChannelAmount>> {
        Err(NodeError::Generic("Not implemented".to_string()))
    }

    fn derive_bip32_key(&self, _path: Vec<ChildNumber>) -> NodeResult<ExtendedPrivKey> {
        Ok(ExtendedPrivKey::new_master(Network::Bitcoin, &[])?)
    }

    fn legacy_derive_bip32_key(&self, _path: Vec<ChildNumber>) -> NodeResult<ExtendedPrivKey> {
        Ok(ExtendedPrivKey::new_master(Network::Bitcoin, &[])?)
    }

    async fn send_custom_message(&self, message: CustomMessage) -> NodeResult<()> {
        (self.on_send_custom_message)(message)
    }

    async fn stream_custom_messages(
        &self,
    ) -> NodeResult<Pin<Box<dyn Stream<Item = core::result::Result<CustomMessage, Error>> + Send>>>
    {
        let (_, next_rx) = mpsc::channel(1);
        let mut guard = self.on_stream_custom_messages.lock().await;
        let rx = mem::replace(&mut *guard, next_rx);
        Ok(Box::pin(
            tokio_stream::wrappers::ReceiverStream::new(rx).map(Ok),
        ))
    }

    async fn get_routing_hints(
        &self,
        _lsp_info: &LspInformation,
    ) -> NodeResult<(Vec<RouteHint>, bool)> {
        Ok((vec![], false))
    }

    async fn fetch_bolt11(&self, _payment_hash: Vec<u8>) -> NodeResult<Option<FetchBolt11Result>> {
        Ok(None)
    }

    async fn get_open_peers(&self) -> NodeResult<HashSet<Vec<u8>>> {
        Ok(HashSet::new())
    }
}

impl MockNodeAPI {
    pub fn new(node_state: NodeState) -> Self {
        Self {
            cloud_payments: Mutex::new(vec![]),
            node_state,
            on_send_custom_message: Box::new(|_| Ok(())),
            on_stream_custom_messages: {
                let (_, rx) = mpsc::channel(1);
                Mutex::new(rx)
            },
        }
    }
    /// Creates a (simulated) payment for the specified BOLT11 and adds it to a test-specific
    /// global state.
    ///
    /// This payment and its details are retrieved and stored within [crate::BreezServices::sync]
    /// by a combination of [NodeAPI::pull_changed] and [crate::persist::db::SqliteStorage::insert_or_update_payments].
    pub(crate) async fn add_dummy_payment_for(
        &self,
        bolt11: String,
        preimage: Option<sha256::Hash>,
        status: Option<PayStatus>,
    ) -> NodeResult<Payment> {
        let inv = bolt11
            .parse::<crate::lightning_invoice::Bolt11Invoice>()
            .map_err(|e| NodeError::Generic(e.to_string()))?;

        self.add_dummy_payment(inv, preimage, status).await
    }

    /// Adds a dummy payment with random attributes.
    pub(crate) async fn add_dummy_payment_rand(&self) -> NodeResult<Payment> {
        let preimage = sha256::Hash::hash(&rand_vec_u8(10));
        let inv = rand_invoice_with_description_hash_and_preimage("test".into(), preimage)?;

        self.add_dummy_payment(inv, Some(preimage), None).await
    }

    /// Adds a dummy payment.
    pub(crate) async fn add_dummy_payment(
        &self,
        inv: crate::lightning_invoice::Bolt11Invoice,
        preimage: Option<sha256::Hash>,
        status: Option<PayStatus>,
    ) -> NodeResult<Payment> {
        let gl_payment = gl_client::signer::model::greenlight::Payment {
            payment_hash: hex::decode(inv.payment_hash().to_hex())?,
            bolt11: inv.to_string(),
            amount: inv
                .amount_milli_satoshis()
                .map(Unit::Millisatoshi)
                .map(Some)
                .map(|amt| Amount { unit: amt }),
            amount_sent: inv
                .amount_milli_satoshis()
                .map(Unit::Millisatoshi)
                .map(Some)
                .map(|amt| Amount { unit: amt }),
            payment_preimage: match preimage {
                Some(preimage) => hex::decode(preimage.to_hex())?,
                None => rand_vec_u8(32),
            },
            status: status.unwrap_or(PayStatus::Complete).into(),
            created_at: random(),
            destination: rand_vec_u8(32),
            completed_at: random(),
        };

        self.save_payment_for_future_sync_updates(gl_payment.clone())
            .await
    }

    /// Include payment in the result of [MockNodeAPI::pull_changed].
    async fn save_payment_for_future_sync_updates(
        &self,
        gl_payment: gl_client::signer::model::greenlight::Payment,
    ) -> NodeResult<Payment> {
        let mut cloud_payments = self.cloud_payments.lock().await;

        // Only store it if a payment with the same ID doesn't already exist
        // This allows us to initialize a MockBreezServer with a list of known payments using
        // breez_services::tests::breez_services_with(vec), but not replace them when
        // send_payment is called in tests for those payments.
        let gl_payment = match cloud_payments
            .iter()
            .find(|p| p.payment_hash == gl_payment.payment_hash)
        {
            None => {
                // If payment is not already known, add it to the list and return it
                cloud_payments.push(gl_payment.clone());
                gl_payment
            }
            Some(p) => {
                // If a payment already exists (by ID), then do not replace it and return it
                // The existing version is returned, because that's initialized with the preimage
                // on mock breez service init
                p.clone()
            }
        };

        gl_payment.try_into()
    }

    pub fn set_on_send_custom_message(
        &mut self,
        f: Box<dyn Fn(CustomMessage) -> NodeResult<()> + Sync + Send>,
    ) {
        self.on_send_custom_message = f;
    }

    pub async fn set_on_stream_custom_messages(&mut self, f: mpsc::Receiver<CustomMessage>) {
        *self.on_stream_custom_messages.lock().await = f;
    }
}

pub struct MockBreezServer {}

impl MockBreezServer {
    pub(crate) fn lsp_pub_key(&self) -> String {
        "02d4e7e420d9dcf6f0206c27ecc69c400cc269b1f5f5ec856d8c9d1fc7e6d910d6".to_string()
    }
    pub(crate) fn lsp_id(&self) -> String {
        "1".to_string()
    }
}

#[tonic::async_trait]
impl LspAPI for MockBreezServer {
    async fn list_lsps(&self, _node_pubkey: String) -> SdkResult<Vec<LspInformation>> {
        Ok(vec![LspInformation {
            id: self.lsp_id(),
            name: "test lsp".to_string(),
            widget_url: "".to_string(),
            pubkey: self.lsp_pub_key(),
            host: "localhost".to_string(),
            base_fee_msat: 1,
            fee_rate: 1.0,
            time_lock_delta: 32,
            min_htlc_msat: 1000,
            lsp_pubkey: hex::decode(self.lsp_pub_key()).unwrap(),
            // Initialize menu with one Fee Param that is valid for >48h
            // This way, it can be used in both kinds of tests (those that need the cheapest fee,
            // as well as those with the longest valid fee)
            opening_fee_params_list: OpeningFeeParamsMenu::try_from(vec![get_test_ofp_48h(
                10, 12,
            )])?,
        }])
    }

    async fn list_used_lsps(&self, _node_pubkey: String) -> SdkResult<Vec<LspInformation>> {
        Ok(vec![])
    }

    async fn register_payment_notifications(
        &self,
        _lsp_id: String,
        _lsp_pubkey: Vec<u8>,
        _webhook_url: String,
        _webhook_url_signature: String,
    ) -> SdkResult<grpc::RegisterPaymentNotificationResponse> {
        Ok(grpc::RegisterPaymentNotificationResponse {})
    }

    async fn unregister_payment_notifications(
        &self,
        _lsp_id: String,
        _lsp_pubkey: Vec<u8>,
        _webhook_url: String,
        _webhook_url_signature: String,
    ) -> SdkResult<grpc::RemovePaymentNotificationResponse> {
        Ok(grpc::RemovePaymentNotificationResponse {})
    }

    async fn register_payment(
        &self,
        _lsp_id: String,
        _lsp_pubkey: Vec<u8>,
        _payment_info: grpc::PaymentInformation,
    ) -> SdkResult<grpc::RegisterPaymentReply> {
        Ok(grpc::RegisterPaymentReply {})
    }
}

#[tonic::async_trait]
impl FiatAPI for MockBreezServer {
    async fn list_fiat_currencies(&self) -> Result<Vec<FiatCurrency>> {
        Ok(vec![])
    }

    async fn fetch_fiat_rates(&self) -> Result<Vec<Rate>> {
        Ok(vec![Rate {
            coin: "USD".to_string(),
            value: 20_000.00,
        }])
    }
}

pub struct MockBuyBitcoinService {}

#[tonic::async_trait]
impl BuyBitcoinApi for MockBuyBitcoinService {
    async fn buy_bitcoin(
        &self,
        _provider: BuyBitcoinProvider,
        swap_info: &SwapInfo,
        _redirect_url: Option<String>,
    ) -> Result<String> {
        Ok(format!(
            "https://mock.moonpay?wa={}&ma={}",
            swap_info.bitcoin_address.as_str(),
            format!("{:.8}", swap_info.max_allowed_deposit as f64 / 100000000.0).as_str(),
        ))
    }
}

pub(crate) fn rand_invoice_with_description_hash(
    expected_desc: String,
) -> InvoiceResult<crate::lightning_invoice::Bolt11Invoice> {
    let preimage = sha256::Hash::hash(&rand_vec_u8(10));

    rand_invoice_with_description_hash_and_preimage(expected_desc, preimage)
}

pub(crate) fn rand_invoice_with_description_hash_and_preimage(
    expected_desc: String,
    preimage: sha256::Hash,
) -> InvoiceResult<crate::lightning_invoice::Bolt11Invoice> {
    let expected_desc_hash = Hash::hash(expected_desc.as_bytes());

    let hashed_preimage = Message::from_hashed_data::<sha256::Hash>(&preimage[..]);
    let payment_hash = hashed_preimage.as_ref();

    let payment_secret = PaymentSecret([42u8; 32]);

    let secp = Secp256k1::new();
    let key_pair = KeyPair::new(&secp, &mut rand::thread_rng());
    let private_key = key_pair.secret_key();

    Ok(InvoiceBuilder::new(Currency::Bitcoin)
        .description_hash(expected_desc_hash)
        .amount_milli_satoshis(50 * 1000)
        .payment_hash(
            Hash::from_slice(payment_hash).map_err(|e| InvoiceError::Generic(e.to_string()))?,
        )
        .payment_secret(payment_secret)
        .current_timestamp()
        .min_final_cltv_expiry_delta(144)
        .build_signed(|hash| Secp256k1::new().sign_ecdsa_recoverable(hash, &private_key))?)
}

pub fn rand_string(len: usize) -> String {
    Alphanumeric.sample_string(&mut rand::thread_rng(), len)
}

pub fn rand_vec_u8(len: usize) -> Vec<u8> {
    rand::thread_rng().sample_iter(Standard).take(len).collect()
}

pub fn rand_int_in_range<T, R>(range: R) -> T
where
    T: SampleUniform,
    R: SampleRange<T>,
{
    rand::thread_rng().gen_range(range)
}

pub fn create_test_config() -> crate::models::Config {
    let mut conf = Config {
        default_lsp_id: Some(String::from("03cea51f-b654-4fb0-8e82-eca137f236a0")),
        chainnotifier_url: "http://test-chainnotifier.local".to_string(),
        ..Config::production(
            "".into(),
            crate::NodeConfig::Greenlight {
                config: crate::GreenlightNodeConfig {
                    partner_credentials: None,
                    invite_code: None,
                },
            },
        )
    };
    conf.working_dir = get_test_working_dir();
    conf
}

pub(crate) fn create_test_persister(
    config: crate::models::Config,
) -> crate::persist::db::SqliteStorage {
    println!("create_test_persister {}", config.working_dir);
    crate::persist::db::SqliteStorage::new(config.working_dir)
}

pub fn get_test_working_dir() -> String {
    let mut rng = rand::thread_rng();
    let s = std::env::temp_dir().to_str().unwrap().to_string();
    let dir = format!("{}/{}", s, rng.gen::<u32>());
    std::fs::create_dir_all(dir.clone()).unwrap();
    dir
}

pub fn create_invoice(
    description: String,
    amount_msat: u64,
    hints: Vec<RouteHint>,
    invoice_preimage: Option<Vec<u8>>,
) -> LNInvoice {
    let preimage = invoice_preimage.unwrap_or(rand::thread_rng().gen::<[u8; 32]>().to_vec());
    let hashed = Message::from_hashed_data::<sha256::Hash>(&preimage[..]);
    let hash = hashed.as_ref();

    let mut invoice_builder = InvoiceBuilder::new(Currency::Bitcoin)
        .description(description)
        .payment_hash(sha256::Hash::hash(hash))
        .timestamp(SystemTime::now())
        .amount_milli_satoshis(amount_msat)
        .expiry_time(Duration::new(3600, 0))
        .payment_secret(PaymentSecret(rand::thread_rng().gen::<[u8; 32]>()))
        .min_final_cltv_expiry_delta(32);

    for hint in hints {
        invoice_builder = invoice_builder.private_route(hint.to_ldk_hint().unwrap());
    }

    let raw_invoice = invoice_builder.build_raw().unwrap();
    parse_invoice(&sign_invoice(raw_invoice)).unwrap()
}

fn sign_invoice(invoice: RawBolt11Invoice) -> String {
    let secp = Secp256k1::new();
    let (secret_key, _) = secp.generate_keypair(&mut OsRng);
    invoice
        .sign(|m| -> Result<RecoverableSignature, anyhow::Error> {
            Ok(secp.sign_ecdsa_recoverable(m, &secret_key))
        })
        .unwrap()
        .to_string()
}

/// [OpeningFeeParams] that are valid for more than 48h
pub(crate) fn get_test_ofp_48h(min_msat: u64, proportional: u32) -> grpc::OpeningFeeParams {
    get_test_ofp_generic(min_msat, proportional, true, chrono::Duration::days(10))
}

/// [OpeningFeeParams] with 1 minute in the future or the past
pub(crate) fn get_test_ofp(
    min_msat: u64,
    proportional: u32,
    future_or_past: bool,
) -> grpc::OpeningFeeParams {
    get_test_ofp_generic(
        min_msat,
        proportional,
        future_or_past,
        chrono::Duration::seconds(60),
    )
}

pub(crate) fn get_test_ofp_generic(
    min_msat: u64,
    proportional: u32,
    future_or_past: bool,
    duration: chrono::Duration,
) -> grpc::OpeningFeeParams {
    let now = Utc::now();
    let date_time = match future_or_past {
        true => now.checked_add_signed(duration).unwrap(),
        false => now.checked_sub_signed(duration).unwrap(),
    };
    let formatted = date_time.to_rfc3339_opts(SecondsFormat::Millis, true);

    grpc::OpeningFeeParams {
        min_msat,
        proportional,
        valid_until: formatted,
        max_idle_time: 0,
        max_client_to_self_delay: 0,
        promise: "".to_string(),
    }
    .into()
}
