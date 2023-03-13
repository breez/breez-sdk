use std::collections::HashMap;
use std::time::{Duration, SystemTime};

use crate::breez_services::Receiver;
use crate::chain::{ChainService, OnchainTx, RecommendedFees};
use crate::fiat::{FiatCurrency, Rate};
use crate::swap::create_submarine_swap_script;
use crate::{parse_invoice, Config, LNInvoice, RouteHint};
use anyhow::{anyhow, Result};
use bitcoin::secp256k1::ecdsa::RecoverableSignature;
use bitcoin::secp256k1::{KeyPair, Message};
use bitcoin::secp256k1::{PublicKey, Secp256k1, SecretKey};
use bitcoin::util::bip32::{ChildNumber, ExtendedPrivKey};
use bitcoin_hashes::hex::ToHex;
use bitcoin_hashes::{sha256, Hash};
use gl_client::pb::amount::Unit;
use gl_client::pb::{
    Amount, CloseChannelResponse, CloseChannelType, Invoice, Peer, WithdrawResponse,
};
use lightning::ln::PaymentSecret;
use lightning_invoice::{Currency, InvoiceBuilder, RawInvoice};
use rand::distributions::{Alphanumeric, DistString, Standard};
use rand::rngs::OsRng;
use rand::{random, Rng};
use tonic::Streaming;

use crate::grpc::{PaymentInformation, RegisterPaymentReply};
use crate::lsp::LspInformation;
use crate::models::{FiatAPI, LspAPI, NodeAPI, NodeState, Payment, Swap, SwapperAPI, SyncResponse};
use tokio::sync::{mpsc, Mutex};

//use bitcoin::secp256k1::{ecdsa::{SigningKey, Signature, signature::Signer, VerifyingKey, signature::Verifier}};
//use rand_core::OsRng;

pub struct MockSwapperAPI {}

#[tonic::async_trait]
impl SwapperAPI for MockSwapperAPI {
    async fn create_swap(
        &self,
        hash: Vec<u8>,
        payer_pubkey: Vec<u8>,
        _node_pubkey: String,
    ) -> Result<Swap> {
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
        let address = bitcoin::Address::p2wsh(&script, bitcoin::Network::Bitcoin);

        Ok(Swap {
            bitcoin_address: address.to_string(),
            swapper_pubkey: swapper_pub_key,
            lock_height: 144,
            max_allowed_deposit: 4000000,
            error_message: "".to_string(),
            required_reserve: 0,
            min_allowed_deposit: 3000,
        })
    }

    async fn complete_swap(&self, _bolt11: String) -> Result<()> {
        Ok(())
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
    async fn recommended_fees(&self) -> Result<RecommendedFees> {
        Ok(self.recommended_fees.clone())
    }

    async fn address_transactions(&self, address: String) -> Result<Vec<OnchainTx>> {
        Ok(self
            .address_to_transactions
            .get(&address)
            .unwrap_or(&Vec::<OnchainTx>::new())
            .clone())
    }

    async fn current_tip(&self) -> Result<u32> {
        Ok(self.tip)
    }
    async fn broadcast_transaction(&self, _tx: Vec<u8>) -> Result<String> {
        let mut array = [0; 32];
        rand::thread_rng().fill(&mut array);
        Ok(hex::encode(array))
    }
}

pub struct MockReceiver {
    pub bolt11: String,
}

impl Default for MockReceiver {
    fn default() -> Self {
        MockReceiver{bolt11: "lnbc500u1p3eerl2dq8w3jhxaqpp5w3w4z63erts5usxtkvpwdy356l29xfd43mnzlq6x2d69kqhjtepsxqyjw5qsp5an4vlkhp8cgahvamrdkn2uzmmcd5neq7yq3j6a8v0sc0q9rlde5s9qrsgqcqpxrzjqwk7573qcyfskzw33jnvs0shq9tzy28sd86naqlgkdga9p8z74fsyzancsqqvpsqqqqqqqlgqqqqqzsqygrzjqwk7573qcyfskzw33jnvs0shq9tzy28sd86naqlgkdga9p8z74fsyqqqqyqqqqqqqqqqqqlgqqqqqzsqjqacpq7rd5rf7ssza0lps93ehylrwtjhdlk44g0llwp039f8uqxsck52ccr69djxs59mmwqkvvglylpg0cdzaqusg9m9cyju92t7kjpfsqma2lmf".to_string()}
    }
}

#[tonic::async_trait]
impl Receiver for MockReceiver {
    async fn receive_payment(
        &self,
        _amount_sats: u64,
        _description: String,
        _preimage: Option<Vec<u8>>,
    ) -> Result<crate::LNInvoice> {
        Ok(parse_invoice(&self.bolt11)?)
    }
}

pub struct MockNodeAPI {
    /// Simulated repository of confirmed new outgoing payments.
    ///
    /// Each call to [MockNodeAPI::add_dummy_payment_for] will add the new payment here such that
    /// [NodeAPI::pull_changed], which is called in [BreezServices::sync], always retrieves the newly
    /// added test payments
    cloud_payments: Mutex<Vec<gl_client::pb::Payment>>,
    node_state: NodeState,
}

#[tonic::async_trait]
impl NodeAPI for MockNodeAPI {
    async fn create_invoice(
        &self,
        amount_sats: u64,
        description: String,
        preimage: Option<Vec<u8>>,
    ) -> Result<Invoice> {
        let invoice = create_invoice(description.clone(), amount_sats * 1000, vec![], preimage);
        Ok(Invoice {
            label: "".to_string(),
            description,
            amount: Some(Amount {
                unit: Some(Unit::Satoshi(amount_sats)),
            }),
            received: None,
            status: 0,
            payment_time: 0,
            expiry_time: invoice.expiry as u32,
            bolt11: invoice.bolt11,
            payment_hash: hex::decode(invoice.payment_hash).unwrap(),
            payment_preimage: vec![],
        })
    }

    async fn pull_changed(&self, _since_timestamp: i64) -> Result<SyncResponse> {
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

    async fn send_payment(&self, bolt11: String, _amount_sats: Option<u64>) -> Result<Payment> {
        self.add_dummy_payment_for(bolt11, None).await
    }

    async fn send_spontaneous_payment(
        &self,
        _node_id: String,
        _amount_sats: u64,
    ) -> Result<Payment> {
        self.add_dummy_payment_rand().await
    }

    async fn start(&self) -> Result<()> {
        Ok(())
    }

    async fn sweep(
        &self,
        _to_address: String,
        _fee_rate_sats_per_byte: u64,
    ) -> Result<WithdrawResponse> {
        Ok(WithdrawResponse {
            tx: rand_vec_u8(32),
            txid: rand_vec_u8(32),
        })
    }

    async fn start_signer(&self, _shutdown: mpsc::Receiver<()>) {}

    async fn list_peers(&self) -> Result<Vec<Peer>> {
        Ok(vec![])
    }

    async fn connect_peer(&self, _node_id: String, _addr: String) -> Result<()> {
        Ok(())
    }

    fn sign_invoice(&self, invoice: RawInvoice) -> Result<String> {
        Ok(sign_invoice(invoice))
    }

    async fn close_peer_channels(&self, _node_id: String) -> Result<CloseChannelResponse> {
        Ok(CloseChannelResponse {
            txid: Vec::new(),
            tx: Vec::new(),
            close_type: CloseChannelType::Mutual.into(),
        })
    }
    async fn stream_incoming_payments(&self) -> Result<Streaming<gl_client::pb::IncomingPayment>> {
        Err(anyhow!("Not implemented"))
    }

    async fn stream_log_messages(&self) -> Result<Streaming<gl_client::pb::LogEntry>> {
        Err(anyhow!("Not implemented"))
    }

    async fn execute_command(&self, _command: String) -> Result<String> {
        Err(anyhow!("Not implemented"))
    }

    fn derive_bip32_key(&self, _path: Vec<ChildNumber>) -> Result<ExtendedPrivKey> {
        Err(anyhow!("Not implemented"))
    }
}

impl MockNodeAPI {
    pub fn new(node_state: NodeState) -> Self {
        Self {
            cloud_payments: Mutex::new(vec![]),
            node_state,
        }
    }
    /// Creates a (simulated) payment for the specified BOLT11 and adds it to a test-specific
    /// global state.
    ///
    /// This payment and its details are retrieved and stored within [crate::BreezServices::sync]
    /// by a combination of [NodeAPI::pull_changed] and [crate::persist::db::SqliteStorage::insert_payments].
    pub(crate) async fn add_dummy_payment_for(
        &self,
        bolt11: String,
        preimage: Option<sha256::Hash>,
    ) -> Result<Payment> {
        let inv = bolt11.parse::<lightning_invoice::Invoice>()?;

        let gl_payment = gl_client::pb::Payment {
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
            status: 1,
            created_at: random(),
            destination: rand_vec_u8(32),
            completed_at: random(),
        };

        self.save_payment_for_future_sync_updates(gl_payment.clone())
            .await
    }

    /// Adds a dummy payment with random attributes.
    pub(crate) async fn add_dummy_payment_rand(&self) -> Result<Payment> {
        let preimage = sha256::Hash::hash(&rand_vec_u8(10));
        let inv = rand_invoice_with_description_hash_and_preimage("test".into(), preimage)?;

        let gl_payment = gl_client::pb::Payment {
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
            payment_preimage: preimage.to_hex().into_bytes(),
            status: 1,
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
        gl_payment: gl_client::pb::Payment,
    ) -> Result<Payment> {
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
    async fn list_lsps(&self, _node_pubkey: String) -> Result<Vec<LspInformation>> {
        Ok(vec![LspInformation {
            id: "1".to_string(),
            name: "test lsp".to_string(),
            widget_url: "".to_string(),
            pubkey: self.lsp_pub_key(),
            host: "localhost".to_string(),
            channel_capacity: 1000000,
            target_conf: 1,
            base_fee_msat: 1,
            fee_rate: 1.0,
            time_lock_delta: 32,
            min_htlc_msat: 1000,
            channel_fee_permyriad: 1000,
            lsp_pubkey: hex::decode(self.lsp_pub_key()).unwrap(),
            max_inactive_duration: 3600,
            channel_minimum_fee_msat: 1,
        }])
    }

    async fn register_payment(
        &self,
        _lsp_id: String,
        _lsp_pubkey: Vec<u8>,
        _payment_info: PaymentInformation,
    ) -> Result<RegisterPaymentReply> {
        Ok(RegisterPaymentReply {})
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

pub(crate) fn rand_invoice_with_description_hash(
    expected_desc: String,
) -> Result<lightning_invoice::Invoice> {
    let preimage = sha256::Hash::hash(&rand_vec_u8(10));

    rand_invoice_with_description_hash_and_preimage(expected_desc, preimage)
}

pub(crate) fn rand_invoice_with_description_hash_and_preimage(
    expected_desc: String,
    preimage: sha256::Hash,
) -> Result<lightning_invoice::Invoice> {
    let expected_desc_hash = Hash::hash(expected_desc.as_bytes());

    let hashed_preimage = Message::from_hashed_data::<sha256::Hash>(&preimage[..]);
    let payment_hash = hashed_preimage.as_ref();

    let payment_secret = PaymentSecret([42u8; 32]);

    let secp = Secp256k1::new();
    let key_pair = KeyPair::new(&secp, &mut rand::thread_rng());
    let private_key = key_pair.secret_key();

    InvoiceBuilder::new(Currency::Bitcoin)
        .description_hash(expected_desc_hash)
        .amount_milli_satoshis(50 * 1000)
        .payment_hash(Hash::from_slice(payment_hash)?)
        .payment_secret(payment_secret)
        .current_timestamp()
        .min_final_cltv_expiry_delta(144)
        .build_signed(|hash| Secp256k1::new().sign_ecdsa_recoverable(hash, &private_key))
        .map_err(|err| anyhow!(err))
}

pub fn rand_string(len: usize) -> String {
    Alphanumeric.sample_string(&mut rand::thread_rng(), len)
}

pub fn rand_vec_u8(len: usize) -> Vec<u8> {
    rand::thread_rng().sample_iter(Standard).take(len).collect()
}

pub fn create_test_config() -> crate::models::Config {
    let mut conf = Config {
        ..Config::staging()
    };
    conf.working_dir = get_test_working_dir();
    conf
}

pub fn create_test_persister(config: crate::models::Config) -> crate::persist::db::SqliteStorage {
    let storage_path = format!("{}/storage.sql", config.working_dir);
    crate::persist::db::SqliteStorage::from_file(storage_path)
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
    let preimage = invoice_preimage.map_or(rand::thread_rng().gen::<[u8; 32]>().to_vec(), |p| p);
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

fn sign_invoice(invoice: RawInvoice) -> String {
    let secp = Secp256k1::new();
    let (secret_key, _) = secp.generate_keypair(&mut OsRng);
    invoice
        .sign(|m| -> Result<RecoverableSignature, anyhow::Error> {
            Ok(secp.sign_ecdsa_recoverable(m, &secret_key))
        })
        .unwrap()
        .to_string()
}
