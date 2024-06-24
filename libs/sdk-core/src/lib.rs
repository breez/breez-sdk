//! # Breez SDK
//!
//! The Breez SDK enables mobile developers to integrate Lightning and bitcoin payments into their
//! apps with a very shallow learning curve. The use cases are endless – from social apps that want
//! to integrate tipping between users to content-creation apps interested in adding bitcoin monetization.
//! Crucially, this SDK is an end-to-end, non-custodial, drop-in solution powered by Greenlight,
//! a built-in LSP, on-chain interoperability, third-party fiat on-ramps, and other services users
//! and operators need.
//!
//! The Breez SDK provides the following services:
//! * Sending payments (via various protocols such as: bolt11, keysend, lnurl-pay, lightning address, etc.)
//! * Receiving payments (via various protocols such as: bolt11, lnurl-withdraw, etc.)
//! * Fetching node status (e.g. balance, max allow to pay, max allow to receive, on-chain balance, etc.)
//! * Connecting to a new or existing node.
//!
//! ## Getting Started
//!
//! First, make sure you have your API Key and Invite Code ready (see [API Key and Invite Code](#api-key-and-invite-code) section below).
//!
//! The following code initialize the SDK and make it ready to be used:
//!
//! ```ignore
//! let mnemonic = Mnemonic::generate_in(Language::English, 12)?;
//! let seed = mnemonic.to_seed("");
//! let invite_code = Some("...".into());
//!
//! let mut config = BreezServices::default_config(
//!     EnvironmentType::Production,
//!     "your API key".into(),
//!     breez_sdk_core::NodeConfig::Greenlight {
//!         config: GreenlightNodeConfig { partner_credentials: None, invite_code },
//!     },
//! );
//!
//! // Customize the config object according to your needs
//! config.working_dir = "path to an existing directory".into();
//!
//! // Connect to the Breez SDK make it ready for use
//! let sdk = BreezServices::connect(
//!    config,
//!    seed.to_vec(),        
//!    Box::new(AppEventListener {}),
//! )
//! .await?;
//!
//! ```
//!
//! We can now receive payments
//!
//! ```ignore
//! let invoice = sdk.receive_payment(3000, "Invoice for 3000 sats".into()).await?;
//! ```
//!
//! or make payments
//! ```ignore
//! let bolt11 = "...";
//! sdk.send_payment(bolt11.into(), Some(3000)).await?;
//! ```
//!
//! At any point we can fetch our balance from the Greenlight node
//! ```ignore
//! if let Some(node_state) = sdk.node_info()? {
//!     let balance_ln = node_state.channels_balance_msat;
//!     let balance_onchain = node_state.onchain_balance_msat;
//! }
//! ```
//!
//! or fetch other useful infos, like the current mempool [RecommendedFees]
//! ```ignore
//! let fees: RecommendedFees = sdk.recommended_fees().await?;
//! ```
//!
//! These different types of operations are described below in more detail.
//!
//! ### A. Initializing the SDK
//!
//! There are two simple steps necessary to initialize the SDK:
//!
//! 1. [BreezServices::default_config] to construct the sdk configuration
//! 2. [BreezServices::connect] to connect to your node and start all required Breez SDK services
//!
//! The first step takes the [EnvironmentType] and [NodeConfig] as arguments. Although you can create
//! your own config from scratch it is recommended to use the [BreezServices::default_config] method and
//! customize it according to your needs.
//! Once the [NodeConfig] is created it is passed to the [BreezServices::connect] method along with the seed and and implementation of [EventListener] which is used to
//! notify the caller of SDK events.
//!
//! Now your SDK is ready to be used.
//!
//! ### B. Sending and receiving Lightning payments
//!
//! Supported BOLT11 operations are
//!
//! * [BreezServices::receive_payment] to create an invoice
//! * [BreezServices::send_payment] to pay an invoice
//! * [BreezServices::send_spontaneous_payment] for keysend payments
//!
//! ### C. Receiving an on-chain transaction (swap-in)
//!
//! * [BreezServices::receive_onchain] accepting an optional user-selected [OpeningFeeParams] for
//! the case when the operation requires a new channel with the LSP
//! * [BreezServices::in_progress_swap]
//! * [BreezServices::list_refundables] to get a list of swaps
//! * [BreezServices::refund] to broadcast a transaction for failed or expired swaps
//!
//! ### D. Sending to an on-chain address (swap-out)
//!
//! * [BreezServices::fetch_reverse_swap_fees] to get the current swap-out fees
//! * [BreezServices::send_onchain] to start the swap-out
//! * [BreezServices::in_progress_reverse_swaps] to see any in-progress swaps
//!
//! ### E. Using LNURL
//!
//! 1. [parse] the LNURL endpoint URL to get the workflow parameters.
//! 2. After getting the user input or confirmation, complete the workflow with [BreezServices::lnurl_pay] or
//! [BreezServices::lnurl_withdraw].
//!
//! ### F. Supporting fiat currencies
//!
//! * [BreezServices::list_fiat_currencies] to get the supported fiat currencies
//! * [BreezServices::fetch_fiat_rates] to get the current exchange rates
//! * [BreezServices::recommended_fees] for the recommended mempool fees
//!
//! ### G. Connecting to an LSP
//!
//! * [BreezServices::list_lsps] to get a list of available LSPs
//! * [BreezServices::connect_lsp] to connect to a chosen LSP
//! * [BreezServices::lsp_info] to get [LspInformation] on the currently selected LSP
//!
//! ### H. Utilities
//!
//! Use [parse] to parse generic input. The input can come from the user, from a clicked link or from a QR code.
//! The resulting [InputType] will tell you what the input is and how to treat it, as well as present relevant payload data
//! in a structured form.
//!
//!
//! ## Bindings
//!
//! * C#
//! * Dart
//! * Go
//! * Kotlin
//! * Python
//! * React-Native
//! * Swift
//!
//!
//! ## API Key and Invite Code
//!
//! You will need an API Key to use the SDK, as well as an Invite Code when you create a new node.
//!
//! To get both of them, please contact Breez via email at <contact@breez.technology> or at <https://breez.technology/#contact-us-form>
//!
//! ## Support
//!
//! Join this [telegram group](https://t.me/breezsdk).

#[allow(clippy::all)]
mod frb_generated; /* AUTO INJECTED BY flutter_rust_bridge. This line may not be accurate, and you can change it according to your needs. */

#[macro_use]
extern crate log;

mod backup;
pub mod binding;
mod breez_services;
mod chain;
mod crypt;
pub mod error;
#[rustfmt::skip]
mod node_api; // flutter_rust_bridge_codegen: has to be defined before greenlight; greenlight::node_api
mod greenlight;
#[rustfmt::skip]
pub mod lnurl;
mod lsp;
mod lsps0;
/// flutter_rust_bridge:ignore
mod lsps2;
mod models;
mod moonpay;
mod persist;
mod support;
mod swap_in;
mod swap_out;
#[allow(clippy::all)]
#[allow(unused_mut)]
#[allow(dead_code)]
mod test_utils;
mod tonic_wrap;

pub use breez_services::{
    mnemonic_to_seed, BackupFailedData, BreezEvent, BreezServices, CheckMessageRequest,
    CheckMessageResponse, EventListener, InvoicePaidDetails, LogStream, PaymentFailedData,
    SignMessageRequest, SignMessageResponse,
};
pub use chain::RecommendedFees;
pub use lsp::LspInformation;
pub use models::*;
pub use sdk_common::prelude::*;
pub use swap_out::reverseswap::{ESTIMATED_CLAIM_TX_VSIZE, ESTIMATED_LOCKUP_TX_VSIZE};
