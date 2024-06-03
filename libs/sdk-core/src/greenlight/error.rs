use std::{num::TryFromIntError, time::SystemTimeError};

use anyhow::{anyhow, Result};
use regex::Regex;
use strum_macros::FromRepr;

use crate::{bitcoin::secp256k1, node_api::NodeError};

#[derive(FromRepr, Debug, PartialEq)]
#[repr(i16)]
pub(crate) enum JsonRpcErrCode {
    /* Errors from `pay`, `sendpay`, or `waitsendpay` commands */
    PayInProgress = 200,
    PayRhashAlreadyUsed = 201,
    PayUnparseableOnion = 202,
    PayDestinationPermFail = 203,
    PayTryOtherRoute = 204,
    PayRouteNotFound = 205,
    PayRouteTooExpensive = 206,
    PayInvoiceExpired = 207,
    PayNoSuchPayment = 208,
    PayUnspecifiedError = 209,
    PayStoppedRetrying = 210,
    PayStatusUnexpected = 211,
    PayInvoiceRequestInvalid = 212,
    PayInvoicePreapprovalDeclined = 213,
    PayKeysendPreapprovalDeclined = 214,

    /* `fundchannel` or `withdraw` errors */
    FundMaxExceeded = 300,
    FundCannotAfford = 301,
    FundOutputIsDust = 302,
    FundingBroadcastFail = 303,
    FundingStillSyncingBitcoin = 304,
    FundingPeerNotConnected = 305,
    FundingUnknownPeer = 306,
    FundingNothingToCancel = 307,
    FundingCancelNotSafe = 308,
    FundingPsbtInvalid = 309,
    FundingV2NotSupported = 310,
    FundingUnknownChannel = 311,
    FundingStateInvalid = 312,
    FundCannotAffordWithEmergency = 313,

    /* Splice errors */
    SpliceBroadcastFail = 350,
    SpliceWrongOwner = 351,
    SpliceUnknownChannel = 352,
    SpliceInvalidChannelState = 353,
    SpliceNotSupported = 354,
    SpliceBusyError = 355,
    SpliceInputError = 356,
    SpliceFundingLow = 357,
    SpliceStateError = 358,
    SpliceLowFee = 359,
    SpliceHighFee = 360,

    /* `connect` errors */
    ConnectNoKnownAddress = 400,
    ConnectAllAddressesFailed = 401,
    ConnectDisconnectedDuring = 402,

    /* bitcoin-cli plugin errors */
    BcliError = 500,
    BcliNoFeeEstimates = 501,

    /* Errors from `invoice` or `delinvoice` commands */
    InvoiceLabelAlreadyExists = 900,
    InvoicePreimageAlreadyExists = 901,
    InvoiceHintsGaveNoRoutes = 902,
    InvoiceExpiredDuringWait = 903,
    InvoiceWaitTimedOut = 904,
    InvoiceNotFound = 905,
    InvoiceStatusUnexpected = 906,
    InvoiceOfferInactive = 907,
    InvoiceNoDescription = 908,

    /* Errors from HSM crypto operations. */
    HsmEcdhFailed = 800,

    /* Errors from `offer` commands */
    OfferAlreadyExists = 1000,
    OfferAlreadyDisabled = 1001,
    OfferExpired = 1002,
    OfferRouteNotFound = 1003,
    OfferBadInvreqReply = 1004,
    OfferTimeout = 1005,

    /* Errors from datastore command */
    DatastoreDelDoesNotExist = 1200,
    DatastoreDelWrongGeneration = 1201,
    DatastoreUpdateAlreadyExists = 1202,
    DatastoreUpdateDoesNotExist = 1203,
    DatastoreUpdateWrongGeneration = 1204,
    DatastoreUpdateHasChildren = 1205,
    DatastoreUpdateNoChildren = 1206,

    /* Errors from signmessage command */
    SignmessagePubkeyNotFound = 1301,

    /* Errors from delforward command */
    DelforwardNotFound = 1401,

    /* Errors from runes */
    RuneNotAuthorized = 1501,
    RuneNotPermitted = 1502,
    RuneBlacklisted = 1503,

    /* Errors from wait* commands */
    WaitTimeout = 2000,
}

impl From<anyhow::Error> for NodeError {
    fn from(err: anyhow::Error) -> Self {
        Self::Generic(err.to_string())
    }
}

impl From<crate::bitcoin::util::address::Error> for NodeError {
    fn from(err: crate::bitcoin::util::address::Error) -> Self {
        Self::Generic(err.to_string())
    }
}

impl From<crate::bitcoin::util::bip32::Error> for NodeError {
    fn from(err: crate::bitcoin::util::bip32::Error) -> Self {
        Self::Generic(err.to_string())
    }
}

impl From<hex::FromHexError> for NodeError {
    fn from(err: hex::FromHexError) -> Self {
        Self::Generic(err.to_string())
    }
}

impl From<secp256k1::Error> for NodeError {
    fn from(err: secp256k1::Error) -> Self {
        Self::Generic(err.to_string())
    }
}

impl From<serde_json::Error> for NodeError {
    fn from(err: serde_json::Error) -> Self {
        Self::Generic(err.to_string())
    }
}

impl From<SystemTimeError> for NodeError {
    fn from(err: SystemTimeError) -> Self {
        Self::Generic(err.to_string())
    }
}

impl From<tonic::Status> for NodeError {
    fn from(status: tonic::Status) -> Self {
        let wrapped_status = crate::tonic_wrap::Status(status.clone());
        match parse_cln_error(status) {
            Ok(code) => match code {
                // Pay errors
                JsonRpcErrCode::PayInvoiceExpired => {
                    Self::InvoiceExpired(wrapped_status.to_string())
                }
                JsonRpcErrCode::PayTryOtherRoute | JsonRpcErrCode::PayRouteNotFound => {
                    Self::RouteNotFound(wrapped_status.to_string())
                }
                JsonRpcErrCode::PayRouteTooExpensive => {
                    Self::RouteTooExpensive(wrapped_status.to_string())
                }
                JsonRpcErrCode::PayStoppedRetrying => {
                    Self::PaymentTimeout(wrapped_status.to_string())
                }
                JsonRpcErrCode::PayRhashAlreadyUsed
                | JsonRpcErrCode::PayUnparseableOnion
                | JsonRpcErrCode::PayDestinationPermFail
                | JsonRpcErrCode::PayNoSuchPayment
                | JsonRpcErrCode::PayUnspecifiedError
                | JsonRpcErrCode::PayStatusUnexpected
                | JsonRpcErrCode::PayInvoiceRequestInvalid
                | JsonRpcErrCode::PayInvoicePreapprovalDeclined
                | JsonRpcErrCode::PayKeysendPreapprovalDeclined => {
                    Self::PaymentFailed(wrapped_status.to_string())
                }
                // Invoice errors
                JsonRpcErrCode::InvoiceExpiredDuringWait => {
                    Self::InvoiceExpired(wrapped_status.to_string())
                }
                JsonRpcErrCode::InvoiceNoDescription => {
                    Self::InvoiceNoDescription(wrapped_status.to_string())
                }
                JsonRpcErrCode::InvoicePreimageAlreadyExists => {
                    Self::InvoicePreimageAlreadyExists(wrapped_status.to_string())
                }
                _ => Self::Generic(wrapped_status.to_string()),
            },
            _ => Self::Generic(wrapped_status.to_string()),
        }
    }
}

impl From<TryFromIntError> for NodeError {
    fn from(err: TryFromIntError) -> Self {
        Self::Generic(err.to_string())
    }
}

impl From<clap::Error> for NodeError {
    fn from(err: clap::Error) -> Self {
        Self::Generic(anyhow::Error::new(err))
    }
}

#[allow(clippy::invalid_regex)]
pub(crate) fn parse_cln_error(status: tonic::Status) -> Result<JsonRpcErrCode> {
    let re: Regex = Regex::new(r"Some\((?<code>-?\d+)\)")?;
    re.captures(status.message())
        .and_then(|caps| {
            caps["code"]
                .parse::<i16>()
                .map_or(None, JsonRpcErrCode::from_repr)
        })
        .ok_or(anyhow!("No code found"))
        .or(parse_cln_error_wrapped(status))
}

/// Try to parse and extract the status code from nested tonic statuses.
///
/// ```ignore
/// Example: Generic: Generic: status: Internal, message: \"converting invoice response to grpc:
/// error calling RPC: RPC error response: RpcError { code: 901, message: \\\"preimage already used\\\",
/// data: None }\", details: [], metadata: MetadataMap { headers: {\"content-type\": \"application/grpc\",
/// \"date\": \"Thu, 08 Feb 2024 20:57:17 GMT\", \"content-length\": \"0\"} }
/// ```
///
/// The [tonic::Status] is nested into an [tonic::Code::Internal] one here:
/// <https://github.com/Blockstream/greenlight/blob/e87f60e473edf9395631086c48ba6234c0c052ff/libs/gl-plugin/src/node/wrapper.rs#L90-L93>
pub(crate) fn parse_cln_error_wrapped(status: tonic::Status) -> Result<JsonRpcErrCode> {
    let re: Regex = Regex::new(r"code: (?<code>-?\d+)")?;
    re.captures(status.message())
        .and_then(|caps| {
            caps["code"]
                .parse::<i16>()
                .map_or(None, JsonRpcErrCode::from_repr)
        })
        .ok_or(anyhow!("No code found"))
}

#[cfg(test)]
mod tests {
    use anyhow::Result;
    use tonic::Code;

    use crate::greenlight::error::{parse_cln_error, parse_cln_error_wrapped, JsonRpcErrCode};

    #[test]
    fn test_parse_cln_error() -> Result<()> {
        assert!(parse_cln_error(tonic::Status::new(Code::Internal, "...")).is_err());

        assert!(matches!(
            parse_cln_error(tonic::Status::new(Code::Internal, "... Some(208) ...")),
            Ok(JsonRpcErrCode::PayNoSuchPayment)
        ));

        assert!(matches!(
            parse_cln_error(tonic::Status::new(Code::Internal, "... Some(901) ...")),
            Ok(JsonRpcErrCode::InvoicePreimageAlreadyExists)
        ));

        // Test if it falls back to parsing the nested status
        assert!(matches!(
            parse_cln_error(tonic::Status::new(
                Code::Internal,
                "... RpcError { code: 901, message ... } ..."
            )),
            Ok(JsonRpcErrCode::InvoicePreimageAlreadyExists)
        ));

        Ok(())
    }

    #[test]
    fn test_parse_cln_error_wrapped() -> Result<()> {
        assert!(parse_cln_error_wrapped(tonic::Status::new(Code::Internal, "...")).is_err());

        assert!(matches!(
            parse_cln_error_wrapped(tonic::Status::new(
                Code::Internal,
                "... RpcError { code: 208, message ... } ..."
            )),
            Ok(JsonRpcErrCode::PayNoSuchPayment)
        ));

        assert!(matches!(
            parse_cln_error_wrapped(tonic::Status::new(
                Code::Internal,
                "... RpcError { code: 901, message ... } ..."
            )),
            Ok(JsonRpcErrCode::InvoicePreimageAlreadyExists)
        ));

        Ok(())
    }
}
