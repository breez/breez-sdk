use anyhow::Result;
use bitcoin::util::bip32;
use thiserror::Error;

use crate::{
    invoice::InvoiceError, lnurl::error::LnUrlError, node_api::NodeError,
    persist::error::PersistError, swap_in::error::SwapError, swap_out::error::ReverseSwapError,
};

pub type SdkResult<T, E = SdkError> = Result<T, E>;

/// Error returned by [BreezServices::lnurl_auth]
#[derive(Debug, Error)]
pub enum LnUrlAuthError {
    #[error("Generic: {err}")]
    Generic { err: String },

    #[error("Invalid uri: {err}")]
    InvalidUri { err: String },

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

/// Error returned by [BreezServices::lnurl_pay]
#[derive(Debug, Error)]
pub enum LnUrlPayError {
    #[error("Aes decryption failed: {err}")]
    AesDecryptionFailed { err: String },

    #[error("Invoice already paid")]
    AlreadyPaid,

    #[error("Generic: {err}")]
    Generic { err: String },

    #[error("Invalid amount: {err}")]
    InvalidAmount { err: String },

    #[error("Invalid invoice: {err}")]
    InvalidInvoice { err: String },

    #[error("Invalid uri: {err}")]
    InvalidUri { err: String },

    #[error("Invoice expired: {err}")]
    InvoiceExpired { err: String },

    #[error("Payment failed: {err}")]
    PaymentFailed { err: String },

    #[error("Payment timeout: {err}")]
    PaymentTimeout { err: String },

    #[error("Route not found: {err}")]
    RouteNotFound { err: String },

    #[error("Route too expensive: {err}")]
    RouteTooExpensive { err: String },

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

impl From<bitcoin::hashes::hex::Error> for LnUrlPayError {
    fn from(err: bitcoin::hashes::hex::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<LnUrlError> for LnUrlPayError {
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

/// Error returned by [BreezServices::lnurl_withdraw]
#[derive(Debug, Error)]
pub enum LnUrlWithdrawError {
    #[error("Generic: {err}")]
    Generic { err: String },

    #[error("Invalid amount: {err}")]
    InvalidAmount { err: String },

    #[error("Invalid invoice: {err}")]
    InvalidInvoice { err: String },

    #[error("Invalid uri: {err}")]
    InvalidUri { err: String },

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

/// Error returned by [BreezServices::receive_onchain] and [BreezServices::buy_bitcoin]
#[derive(Debug, Error)]
pub enum ReceiveOnchainError {
    #[error("Generic: {err}")]
    Generic { err: String },

    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },

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

/// Error returned by [BreezServices::receive_payment]
#[derive(Debug, Error)]
pub enum ReceivePaymentError {
    #[error("Generic: {err}")]
    Generic { err: String },

    #[error("Invalid amount: {err}")]
    InvalidAmount { err: String },

    #[error("Invalid invoice: {err}")]
    InvalidInvoice { err: String },

    #[error("Invoice expired: {err}")]
    InvoiceExpired { err: String },

    #[error("Invoice no description: {err}")]
    InvoiceNoDescription { err: String },

    #[error("Invoice preimage already exists: {err}")]
    InvoicePreimageAlreadyExists { err: String },

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
    #[error("Generic: {err}")]
    Generic { err: String },

    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },
}

impl From<anyhow::Error> for SdkError {
    fn from(err: anyhow::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<bitcoin::hashes::hex::Error> for SdkError {
    fn from(err: bitcoin::hashes::hex::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<bip32::Error> for SdkError {
    fn from(err: bip32::Error) -> Self {
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

/// Error returned by [BreezServices::send_onchain]
#[derive(Debug, Error)]
pub enum SendOnchainError {
    #[error("Generic: {err}")]
    Generic { err: String },

    #[error("Invalid destination address: {err}")]
    InvalidDestinationAddress { err: String },

    #[error("Payment failed: {err}")]
    PaymentFailed { err: String },

    #[error("Payment timeout: {err}")]
    PaymentTimeout { err: String },

    #[error("Reverse swap in progress: {err}")]
    ReverseSwapInProgress { err: String },

    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },
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

/// Error returned by [BreezServices::send_payment] and [BreezServices::send_spontaneous_payment]
#[derive(Debug, Error)]
pub enum SendPaymentError {
    #[error("Invoice already paid")]
    AlreadyPaid,

    #[error("Generic: {err}")]
    Generic { err: String },

    #[error("Invalid amount: {err}")]
    InvalidAmount { err: String },

    #[error("Invalid invoice: {err}")]
    InvalidInvoice { err: String },

    #[error("Invoice expired: {err}")]
    InvoiceExpired { err: String },

    #[error("Payment failed: {err}")]
    PaymentFailed { err: String },

    #[error("Payment timeout: {err}")]
    PaymentTimeout { err: String },

    #[error("Route not found: {err}")]
    RouteNotFound { err: String },

    #[error("Route too expensive: {err}")]
    RouteTooExpensive { err: String },

    #[error("Service connectivity: {err}")]
    ServiceConnectivity { err: String },

    #[error("Amount has changed: {new_amount}")]
    OfferAmountChanged { new_amount: u64 },
}

impl From<anyhow::Error> for SendPaymentError {
    fn from(err: anyhow::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<InvoiceError> for SendPaymentError {
    fn from(err: InvoiceError) -> Self {
        Self::InvalidInvoice {
            err: err.to_string(),
        }
    }
}

impl From<InvoiceError> for LnUrlPayError {
    fn from(err: InvoiceError) -> Self {
        Self::InvalidInvoice {
            err: err.to_string(),
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

#[macro_export]
macro_rules! ensure_sdk {
    ($cond:expr, $err:expr) => {
        if !$cond {
            return Err($err);
        }
    };
}
