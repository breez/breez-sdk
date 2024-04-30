use std::time::SystemTimeError;

use anyhow::Result;
use thiserror::Error;

use crate::{
    bitcoin::util::bip32, invoice::InvoiceError, lnurl::error::LnUrlError, node_api::NodeError,
    persist::error::PersistError, swap_in::error::SwapError, swap_out::error::ReverseSwapError,
};

pub type SdkResult<T, E = SdkError> = Result<T, E>;

/// Error returned by [crate::breez_services::BreezServices::connect]
#[derive(Debug, Error)]
pub enum ConnectError {
    /// This error is raised when a general error occurs not specific to other error variants
    /// in this enum.
    #[error("Generic: {err}")]
    Generic { err: String },

    /// This error is raised when [crate::models::ConnectRequest::restore_only] is set to true
    /// and no node exists for [crate::models::ConnectRequest::seed].
    #[error("Restore only: {err}")]
    RestoreOnly { err: String },

    /// This error is raised when a connection to an external service fails.
    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },
}

impl From<bip32::Error> for ConnectError {
    fn from(err: bip32::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<NodeError> for ConnectError {
    fn from(value: NodeError) -> Self {
        match value {
            NodeError::RestoreOnly(err) => Self::RestoreOnly {
                err: err.to_string(),
            },
            NodeError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<PersistError> for ConnectError {
    fn from(err: PersistError) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<SdkError> for ConnectError {
    fn from(value: SdkError) -> Self {
        match value {
            SdkError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

/// Error returned by [crate::breez_services::BreezServices::lnurl_auth]
#[derive(Debug, Error)]
pub enum LnUrlAuthError {
    /// This error is raised when a general error occurs not specific to other error variants
    /// in this enum.
    #[error("Generic: {err}")]
    Generic { err: String },

    /// This error is raised when the decoded LNURL URI is not compliant to the specification.
    #[error("Invalid uri: {err}")]
    InvalidUri { err: String },

    /// This error is raised when a connection to an external service fails.
    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },
}

impl From<LnUrlError> for LnUrlAuthError {
    fn from(value: LnUrlError) -> Self {
        match value {
            LnUrlError::InvalidUri(err) => Self::InvalidUri {
                err: err.to_string(),
            },
            LnUrlError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<SdkError> for LnUrlAuthError {
    fn from(value: SdkError) -> Self {
        match value {
            SdkError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

/// Error returned by [crate::breez_services::BreezServices::lnurl_pay]
#[derive(Debug, Error)]
pub enum LnUrlPayError {
    /// This error is raised when attempting to pay an invoice that has already being paid.
    #[error("Invoice already paid")]
    AlreadyPaid,

    /// This error is raised when a general error occurs not specific to other error variants
    /// in this enum.
    #[error("Generic: {err}")]
    Generic { err: String },

    /// This error is raised when the amount from the parsed invoice is not set.
    #[error("Invalid amount: {err}")]
    InvalidAmount { err: String },

    /// This error is raised when the lightning invoice cannot be parsed.
    #[error("Invalid invoice: {err}")]
    InvalidInvoice { err: String },

    /// This error is raised when the lightning invoice is for a different Bitcoin network.
    #[error("Invalid network: {err}")]
    InvalidNetwork { err: String },

    /// This error is raised when the decoded LNURL URI is not compliant to the specification.
    #[error("Invalid uri: {err}")]
    InvalidUri { err: String },

    /// This error is raised when the lightning invoice has passed it's expiry time.
    #[error("Invoice expired: {err}")]
    InvoiceExpired { err: String },

    /// This error is raised when attempting to make a payment by the node fails.
    #[error("Payment failed: {err}")]
    PaymentFailed { err: String },

    /// This error is raised when attempting to make a payment takes too long.
    #[error("Payment timeout: {err}")]
    PaymentTimeout { err: String },

    /// This error is raised when no route can be found when attempting to make a
    /// payment by the node.
    #[error("Route not found: {err}")]
    RouteNotFound { err: String },

    /// This error is raised when the route is considered too expensive when
    /// attempting to make a payment by the node.
    #[error("Route too expensive: {err}")]
    RouteTooExpensive { err: String },

    /// This error is raised when a connection to an external service fails.
    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },
}

impl From<anyhow::Error> for LnUrlPayError {
    fn from(err: anyhow::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<crate::bitcoin::hashes::hex::Error> for LnUrlPayError {
    fn from(err: crate::bitcoin::hashes::hex::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<InvoiceError> for LnUrlPayError {
    fn from(value: InvoiceError) -> Self {
        match value {
            InvoiceError::InvalidNetwork(err) => Self::InvalidNetwork {
                err: err.to_string(),
            },
            _ => Self::InvalidInvoice {
                err: value.to_string(),
            },
        }
    }
}

impl From<LnUrlError> for LnUrlPayError {
    fn from(value: LnUrlError) -> Self {
        match value {
            LnUrlError::InvalidUri(err) => Self::InvalidUri {
                err: err.to_string(),
            },
            LnUrlError::InvalidInvoice(err) => err.into(),
            LnUrlError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<PersistError> for LnUrlPayError {
    fn from(err: PersistError) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<SdkError> for LnUrlPayError {
    fn from(value: SdkError) -> Self {
        match value {
            SdkError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<SendPaymentError> for LnUrlPayError {
    fn from(value: SendPaymentError) -> Self {
        match value {
            SendPaymentError::AlreadyPaid => Self::AlreadyPaid,
            SendPaymentError::InvalidAmount { err } => Self::InvalidAmount { err },
            SendPaymentError::InvalidInvoice { err } => Self::InvalidInvoice { err },
            SendPaymentError::InvalidNetwork { err } => Self::InvalidNetwork { err },
            SendPaymentError::InvoiceExpired { err } => Self::InvoiceExpired { err },
            SendPaymentError::PaymentFailed { err } => Self::PaymentFailed { err },
            SendPaymentError::PaymentTimeout { err } => Self::PaymentTimeout { err },
            SendPaymentError::RouteNotFound { err } => Self::RouteNotFound { err },
            SendPaymentError::RouteTooExpensive { err } => Self::RouteTooExpensive { err },
            SendPaymentError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

/// Error returned by [crate::breez_services::BreezServices::lnurl_withdraw]
#[derive(Debug, Error)]
pub enum LnUrlWithdrawError {
    /// This error is raised when a general error occurs not specific to other error variants
    /// in this enum.
    #[error("Generic: {err}")]
    Generic { err: String },

    /// This error is raised when the amount is zero or the amount does not cover
    /// the cost to open a new channel.
    #[error("Invalid amount: {err}")]
    InvalidAmount { err: String },

    /// This error is raised when the lightning invoice cannot be parsed.
    #[error("Invalid invoice: {err}")]
    InvalidInvoice { err: String },

    /// This error is raised when the decoded LNURL URI is not compliant to the specification.
    #[error("Invalid uri: {err}")]
    InvalidUri { err: String },

    /// This error is raised when no routing hints were able to be added to the invoice
    /// while trying to receive a payment.
    #[error("No routing hints: {err}")]
    InvoiceNoRoutingHints { err: String },

    /// This error is raised when a connection to an external service fails.
    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },
}

impl From<LnUrlError> for LnUrlWithdrawError {
    fn from(value: LnUrlError) -> Self {
        match value {
            LnUrlError::InvalidUri(err) => Self::InvalidUri {
                err: err.to_string(),
            },
            LnUrlError::InvalidInvoice(err) => Self::InvalidInvoice {
                err: err.to_string(),
            },
            LnUrlError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<PersistError> for LnUrlWithdrawError {
    fn from(err: PersistError) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<ReceivePaymentError> for LnUrlWithdrawError {
    fn from(value: ReceivePaymentError) -> Self {
        match value {
            ReceivePaymentError::InvalidAmount { err } => Self::InvalidAmount { err },
            ReceivePaymentError::InvalidInvoice { err } => Self::InvalidInvoice { err },
            ReceivePaymentError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            ReceivePaymentError::InvoiceNoRoutingHints { err } => {
                Self::InvoiceNoRoutingHints { err }
            }
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<SdkError> for LnUrlWithdrawError {
    fn from(value: SdkError) -> Self {
        match value {
            SdkError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

pub type ReceiveOnchainResult<T, E = ReceiveOnchainError> = Result<T, E>;

/// Error returned by [crate::breez_services::BreezServices::receive_onchain] and
/// [crate::breez_services::BreezServices::buy_bitcoin]
#[derive(Debug, Error)]
pub enum ReceiveOnchainError {
    /// This error is raised when a general error occurs not specific to other error variants
    /// in this enum.
    #[error("Generic: {err}")]
    Generic { err: String },

    /// This error is raised when a connection to an external service fails.
    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },

    /// This error is raised when there is already an in progress swap when trying to
    /// receive an onchain payment.
    #[error("Swap in progress: {err}")]
    SwapInProgress { err: String },
}

impl From<anyhow::Error> for ReceiveOnchainError {
    fn from(err: anyhow::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<SdkError> for ReceiveOnchainError {
    fn from(value: SdkError) -> Self {
        match value {
            SdkError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<SwapError> for ReceiveOnchainError {
    fn from(value: SwapError) -> Self {
        match value {
            SwapError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<PersistError> for ReceiveOnchainError {
    fn from(err: PersistError) -> Self {
        Self::Generic {
            err: format!("Error when accessing local DB: {err}"),
        }
    }
}

/// Error returned by [crate::breez_services::BreezServices::receive_payment]
#[derive(Debug, Error)]
pub enum ReceivePaymentError {
    /// This error is raised when a general error occurs not specific to other error variants
    /// in this enum.
    #[error("Generic: {err}")]
    Generic { err: String },

    /// This error is raised when the amount is zero or the amount does not cover
    /// the cost to open a new channel.
    #[error("Invalid amount: {err}")]
    InvalidAmount { err: String },

    /// This error is raised when the lightning invoice cannot be parsed.
    #[error("Invalid invoice: {err}")]
    InvalidInvoice { err: String },

    /// This error is raised when the lightning invoice has passed it's expiry time.
    #[error("Invoice expired: {err}")]
    InvoiceExpired { err: String },

    /// This error is raised by the node when no description has been set for the invoice.
    #[error("Invoice no description: {err}")]
    InvoiceNoDescription { err: String },

    /// This error is raised when no routing hints were able to be added to the invoice
    /// while trying to receive a payment.
    #[error("No routing hints: {err}")]
    InvoiceNoRoutingHints { err: String },

    /// This error is raised by the node when an invoice is has already being created
    /// using the same preimage.
    #[error("Invoice preimage already exists: {err}")]
    InvoicePreimageAlreadyExists { err: String },

    /// This error is raised when a connection to an external service fails.
    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },
}

impl From<anyhow::Error> for ReceivePaymentError {
    fn from(err: anyhow::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<InvoiceError> for ReceivePaymentError {
    fn from(err: InvoiceError) -> Self {
        Self::InvalidInvoice {
            err: err.to_string(),
        }
    }
}

impl From<NodeError> for ReceivePaymentError {
    fn from(value: NodeError) -> Self {
        match value {
            NodeError::InvoiceExpired(err) => Self::InvoiceExpired {
                err: err.to_string(),
            },
            NodeError::InvoiceNoDescription(err) => Self::InvoiceNoDescription {
                err: err.to_string(),
            },
            NodeError::InvoicePreimageAlreadyExists(err) => Self::InvoicePreimageAlreadyExists {
                err: err.to_string(),
            },
            NodeError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<PersistError> for ReceivePaymentError {
    fn from(err: PersistError) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<SdkError> for ReceivePaymentError {
    fn from(value: SdkError) -> Self {
        match value {
            SdkError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

/// General error returned by the SDK
#[derive(Debug, Error)]
pub enum SdkError {
    /// This error is raised when a general error occurs not specific to other error variants
    /// in this enum.
    #[error("Generic: {err}")]
    Generic { err: String },

    /// This error is raised when a connection to an external service fails.
    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },
}

impl SdkError {
    pub(crate) fn generic(err: &str) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<anyhow::Error> for SdkError {
    fn from(err: anyhow::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<crate::bitcoin::hashes::hex::Error> for SdkError {
    fn from(err: crate::bitcoin::hashes::hex::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<InvoiceError> for SdkError {
    fn from(err: InvoiceError) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<LnUrlError> for SdkError {
    fn from(err: LnUrlError) -> Self {
        SdkError::Generic {
            err: err.to_string(),
        }
    }
}

impl From<NodeError> for SdkError {
    fn from(value: NodeError) -> Self {
        match value {
            NodeError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<PersistError> for SdkError {
    fn from(err: PersistError) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<ReverseSwapError> for SdkError {
    fn from(value: ReverseSwapError) -> Self {
        match value {
            ReverseSwapError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<serde_json::Error> for SdkError {
    fn from(err: serde_json::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<tonic::transport::Error> for SdkError {
    fn from(err: tonic::transport::Error) -> Self {
        Self::ServiceConnectivity {
            err: err.to_string(),
        }
    }
}

impl From<tonic::Status> for SdkError {
    fn from(err: tonic::Status) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<SendPaymentError> for SdkError {
    fn from(value: SendPaymentError) -> Self {
        match value {
            SendPaymentError::Generic { err } => Self::Generic { err },
            SendPaymentError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

/// Error returned by [crate::breez_services::BreezServices::send_onchain]
#[derive(Debug, Error)]
pub enum SendOnchainError {
    /// This error is raised when a general error occurs not specific to other error variants
    /// in this enum.
    #[error("Generic: {err}")]
    Generic { err: String },

    /// This error is raised when the [crate::models::SendOnchainRequest::onchain_recipient_address]
    /// is invalid.
    #[error("Invalid destination address: {err}")]
    InvalidDestinationAddress { err: String },

    /// This error is raised when a reverse swap is attempted with a send amount that is not
    /// in the [crate::BreezServices::onchain_payment_limits] range.
    #[error("Send amount is out of range")]
    OutOfRange,

    /// This error is raised when attempting to make a pay the HODL invoice by the node fails.
    #[error("Payment failed: {err}")]
    PaymentFailed { err: String },

    /// This error is raised when attempting to pay the HODL invoice takes too long.
    #[error("Payment timeout: {err}")]
    PaymentTimeout { err: String },

    /// This error is raised when a connection to an external service fails.
    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },
}
impl SendOnchainError {
    pub(crate) fn generic(err: &str) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<anyhow::Error> for SendOnchainError {
    fn from(err: anyhow::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<NodeError> for SendOnchainError {
    fn from(value: NodeError) -> Self {
        match value {
            NodeError::PaymentFailed(err) => Self::PaymentFailed {
                err: err.to_string(),
            },
            NodeError::PaymentTimeout(err) => Self::PaymentTimeout {
                err: err.to_string(),
            },
            NodeError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<SdkError> for SendOnchainError {
    fn from(value: SdkError) -> Self {
        match value {
            SdkError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<ReverseSwapError> for SendOnchainError {
    fn from(value: ReverseSwapError) -> Self {
        match value {
            ReverseSwapError::InvalidDestinationAddress(err) => Self::InvalidDestinationAddress {
                err: err.to_string(),
            },
            ReverseSwapError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            ReverseSwapError::Node(err) => err.into(),
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

/// Error returned by [crate::breez_services::BreezServices::send_payment] and [crate::breez_services::BreezServices::send_spontaneous_payment]
#[derive(Clone, Debug, Error)]
pub enum SendPaymentError {
    /// This error is raised when attempting to pay an invoice that has already being paid.
    #[error("Invoice already paid")]
    AlreadyPaid,

    /// This error is raised when a general error occurs not specific to other error variants
    /// in this enum.
    #[error("Generic: {err}")]
    Generic { err: String },

    /// This error is raised when the amount from the parsed invoice is not set and there is
    /// no provided amount in [crate::models::SendPaymentRequest::amount_msat].
    #[error("Invalid amount: {err}")]
    InvalidAmount { err: String },

    /// This error is raised when the lightning invoice cannot be parsed.
    #[error("Invalid invoice: {err}")]
    InvalidInvoice { err: String },

    /// This error is raised when the lightning invoice is for a different Bitcoin network.
    #[error("Invalid network: {err}")]
    InvalidNetwork { err: String },

    /// This error is raised when the lightning invoice has passed it's expiry time.
    #[error("Invoice expired: {err}")]
    InvoiceExpired { err: String },

    /// This error is raised when attempting to make a payment by the node fails.
    #[error("Payment failed: {err}")]
    PaymentFailed { err: String },

    /// This error is raised when attempting to make a payment takes too long.
    #[error("Payment timeout: {err}")]
    PaymentTimeout { err: String },

    /// This error is raised when no route can be found when attempting to make a
    /// payment by the node.
    #[error("Route not found: {err}")]
    RouteNotFound { err: String },

    /// This error is raised when the route is considered too expensive when
    /// attempting to make a payment by the node.
    #[error("Route too expensive: {err}")]
    RouteTooExpensive { err: String },

    /// This error is raised when a connection to an external service fails.
    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },
}
impl SendPaymentError {
    pub(crate) fn payment_failed(err: &str) -> Self {
        Self::PaymentFailed {
            err: err.to_string(),
        }
    }
}

impl From<anyhow::Error> for SendPaymentError {
    fn from(err: anyhow::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<InvoiceError> for SendPaymentError {
    fn from(value: InvoiceError) -> Self {
        match value {
            InvoiceError::InvalidNetwork(err) => Self::InvalidNetwork {
                err: err.to_string(),
            },
            _ => Self::InvalidInvoice {
                err: value.to_string(),
            },
        }
    }
}

impl From<NodeError> for SendPaymentError {
    fn from(value: NodeError) -> Self {
        match value {
            NodeError::InvoiceExpired(err) => Self::InvoiceExpired {
                err: err.to_string(),
            },
            NodeError::PaymentFailed(err) => Self::PaymentFailed {
                err: err.to_string(),
            },
            NodeError::PaymentTimeout(err) => Self::PaymentTimeout {
                err: err.to_string(),
            },
            NodeError::RouteNotFound(err) => Self::RouteNotFound {
                err: err.to_string(),
            },
            NodeError::RouteTooExpensive(err) => Self::RouteTooExpensive {
                err: err.to_string(),
            },
            NodeError::ServiceConnectivity(err) => Self::ServiceConnectivity {
                err: err.to_string(),
            },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<PersistError> for SendPaymentError {
    fn from(err: PersistError) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<SdkError> for SendPaymentError {
    fn from(value: SdkError) -> Self {
        match value {
            SdkError::ServiceConnectivity { err } => Self::ServiceConnectivity { err },
            _ => Self::Generic {
                err: value.to_string(),
            },
        }
    }
}

impl From<SystemTimeError> for SendPaymentError {
    fn from(err: SystemTimeError) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

#[macro_export]
macro_rules! ensure_sdk {
    ($cond:expr, $err:expr) => {
        if !$cond {
            return Err($err);
        }
    };
}
