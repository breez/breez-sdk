use crate::{
    invoice::InvoiceError, persist::error::PersistError, CustomMessage, MaxChannelAmount,
    NodeCredentials, PaymentResponse, Peer, PrepareRedeemOnchainFundsRequest, PrepareRedeemOnchainFundsResponse,
    RouteHintHop, SyncResponse, TlvEntry, PendingPayment,
};
use anyhow::Result;
use bitcoin::util::bip32::{ChildNumber, ExtendedPrivKey};
use lightning_invoice::RawBolt11Invoice;
use std::pin::Pin;
use tokio::sync::mpsc;
use tokio_stream::Stream;
use tonic::Streaming;

pub type NodeResult<T, E = NodeError> = Result<T, E>;

#[derive(Debug, thiserror::Error)]
pub enum NodeError {
    #[error("Generic: {0}")]
    Generic(anyhow::Error),

    #[error(transparent)]
    InvalidInvoice(InvoiceError),

    #[error("Invoice expired: {0}")]
    InvoiceExpired(anyhow::Error),

    #[error("Invoice no description: {0}")]
    InvoiceNoDescription(anyhow::Error),

    #[error("Invoice preimage already exists: {0}")]
    InvoicePreimageAlreadyExists(anyhow::Error),

    #[error("Payment failed: {0}")]
    PaymentFailed(anyhow::Error),

    #[error("Payment timeout: {0}")]
    PaymentTimeout(anyhow::Error),

    #[error(transparent)]
    Persistance(PersistError),

    #[error("Route too expensive: {0}")]
    RouteTooExpensive(anyhow::Error),

    #[error("Route not found: {0}")]
    RouteNotFound(anyhow::Error),

    #[error("Service connectivity: {0}")]
    ServiceConnectivity(anyhow::Error),
}

/// Trait covering functions affecting the LN node
#[tonic::async_trait]
pub trait NodeAPI: Send + Sync {
    fn node_credentials(&self) -> NodeResult<Option<NodeCredentials>>;
    async fn create_invoice(
        &self,
        amount_msat: u64,
        description: String,
        preimage: Option<Vec<u8>>,
        use_description_hash: Option<bool>,
        expiry: Option<u32>,
        cltv: Option<u32>,
    ) -> NodeResult<String>;
    async fn pull_changed(
        &self,
        since_timestamp: u64,
        balance_changed: bool,
    ) -> NodeResult<SyncResponse>;
    /// As per the `pb::PayRequest` docs, `amount_msat` is only needed when the invoice doesn't specify an amount
    async fn send_payment(&self, bolt11: String, amount_msat: Option<u64>) -> NodeResult<PendingPayment>;
    async fn send_spontaneous_payment(
        &self,
        node_id: String,
        amount_msat: u64,
        extra_tlvs: Option<Vec<TlvEntry>>,
    ) -> NodeResult<PendingPayment>;
    async fn start(&self) -> NodeResult<String>;

    /// Attempts to find a payment path "manually" and send the htlcs in a way that will drain
    /// Large channels first.
    /// This is useful function to send the largest amount possible to a node.
    async fn send_pay(&self, bolt11: String, max_hops: u32) -> NodeResult<PaymentResponse>;

    /// Calculates the maximum amount that can be sent to a node.
    async fn max_sendable_amount(
        &self,
        payee_node_id: Option<Vec<u8>>,
        max_hops: u32,
        last_hop: Option<&RouteHintHop>,
    ) -> NodeResult<Vec<MaxChannelAmount>>;
    async fn redeem_onchain_funds(&self, to_address: String, sat_per_vbyte: u32) -> NodeResult<Vec<u8>>;
    async fn prepare_redeem_onchain_funds(&self, req: PrepareRedeemOnchainFundsRequest) -> NodeResult<PrepareRedeemOnchainFundsResponse>;
    async fn start_signer(&self, shutdown: mpsc::Receiver<()>);
    async fn list_peers(&self) -> NodeResult<Vec<Peer>>;
    async fn connect_peer(&self, node_id: String, addr: String) -> NodeResult<()>;
    fn sign_invoice(&self, invoice: RawBolt11Invoice) -> NodeResult<String>;
    async fn close_peer_channels(&self, node_id: String) -> NodeResult<Vec<String>>;
    async fn stream_incoming_payments(
        &self,
    ) -> NodeResult<Streaming<gl_client::signer::model::greenlight::IncomingPayment>>;
    async fn stream_log_messages(
        &self,
    ) -> NodeResult<Streaming<gl_client::signer::model::greenlight::LogEntry>>;
    async fn static_backup(&self) -> NodeResult<Vec<String>>;
    async fn execute_command(&self, command: String) -> NodeResult<String>;
    async fn sign_message(&self, message: &str) -> NodeResult<String>;
    async fn check_message(&self, message: &str, pubkey: &str, signature: &str)
        -> NodeResult<bool>;
    async fn send_custom_message(&self, message: CustomMessage) -> NodeResult<()>;
    async fn stream_custom_messages(
        &self,
    ) -> NodeResult<Pin<Box<dyn Stream<Item = Result<CustomMessage>> + Send>>>;

    /// Gets the private key at the path specified
    fn derive_bip32_key(&self, path: Vec<ChildNumber>) -> NodeResult<ExtendedPrivKey>;
    fn legacy_derive_bip32_key(&self, path: Vec<ChildNumber>) -> NodeResult<ExtendedPrivKey>;
}
