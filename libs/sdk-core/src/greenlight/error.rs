use std::{num::TryFromIntError, time::SystemTimeError};

use anyhow::{anyhow, Result};
use bitcoin::secp256k1;
use regex::Regex;
use strum_macros::FromRepr;

use crate::{invoice::InvoiceError, node_api::NodeError, persist::error::PersistError};

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
        Self::Generic(err)
    }
}

impl From<bitcoin::util::address::Error> for NodeError {
    fn from(err: bitcoin::util::address::Error) -> Self {
        Self::Generic(anyhow::Error::new(err))
    }
}

impl From<bitcoin::util::bip32::Error> for NodeError {
    fn from(err: bitcoin::util::bip32::Error) -> Self {
        Self::Generic(anyhow::Error::new(err))
    }
}

impl From<hex::FromHexError> for NodeError {
    fn from(err: hex::FromHexError) -> Self {
        Self::Generic(anyhow::Error::new(err))
    }
}

impl From<InvoiceError> for NodeError {
    fn from(err: InvoiceError) -> Self {
        Self::InvalidInvoice(err)
    }
}

impl From<PersistError> for NodeError {
    fn from(err: PersistError) -> Self {
        Self::Persistance(err)
    }
}

impl From<secp256k1::Error> for NodeError {
    fn from(err: secp256k1::Error) -> Self {
        Self::Generic(anyhow::Error::new(err))
    }
}

impl From<SystemTimeError> for NodeError {
    fn from(err: SystemTimeError) -> Self {
        Self::Generic(anyhow::Error::new(err))
    }
}

impl From<tonic::Status> for NodeError {
    fn from(status: tonic::Status) -> Self {
        match parse_cln_error(status.clone()) {
            Ok(code) => match code {
                // Pay errors
                JsonRpcErrCode::PayInvoiceExpired => Self::InvoiceExpired(status.into()),
                JsonRpcErrCode::PayTryOtherRoute | JsonRpcErrCode::PayRouteNotFound => {
                    Self::RouteNotFound(status.into())
                }
                JsonRpcErrCode::PayRouteTooExpensive => Self::RouteTooExpensive(status.into()),
                JsonRpcErrCode::PayStoppedRetrying => Self::PaymentTimeout(status.into()),
                JsonRpcErrCode::PayRhashAlreadyUsed
                | JsonRpcErrCode::PayUnparseableOnion
                | JsonRpcErrCode::PayDestinationPermFail
                | JsonRpcErrCode::PayNoSuchPayment
                | JsonRpcErrCode::PayUnspecifiedError
                | JsonRpcErrCode::PayStatusUnexpected
                | JsonRpcErrCode::PayInvoiceRequestInvalid
                | JsonRpcErrCode::PayInvoicePreapprovalDeclined
                | JsonRpcErrCode::PayKeysendPreapprovalDeclined => {
                    Self::PaymentFailed(status.into())
                }
                // Invoice errors
                JsonRpcErrCode::InvoiceExpiredDuringWait => Self::InvoiceExpired(status.into()),
                JsonRpcErrCode::InvoiceNoDescription => Self::InvoiceNoDescription(status.into()),
                JsonRpcErrCode::InvoicePreimageAlreadyExists => {
                    Self::InvoicePreimageAlreadyExists(status.into())
                }
                JsonRpcErrCode::OfferExpired => Self::OfferExpired(status.into()),
                JsonRpcErrCode::OfferBadInvreqReply => Self::OfferReplyError(status.into()),
                JsonRpcErrCode::OfferRouteNotFound => Self::RouteNotFound(status.into()),
                JsonRpcErrCode::OfferTimeout => Self::OfferTimeout(status.into()),
                _ => Self::Generic(status.into()),
            },
            _ => Self::Generic(status.into()),
        }
    }
}

impl From<TryFromIntError> for NodeError {
    fn from(err: TryFromIntError) -> Self {
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
}
