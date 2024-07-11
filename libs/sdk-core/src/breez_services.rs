use std::fs::OpenOptions;
use std::io::Write;
use std::str::FromStr;
use std::sync::Arc;
use std::time::{Duration, Instant, SystemTime, UNIX_EPOCH};

use anyhow::{anyhow, Result};
use bip39::*;
use bitcoin::hashes::hex::ToHex;
use bitcoin::hashes::{sha256, Hash};
use bitcoin::util::bip32::ChildNumber;
use chrono::Local;
use futures::TryFutureExt;
use gl_client::bitcoin::secp256k1::Secp256k1;
use log::{LevelFilter, Metadata, Record};
use reqwest::{header::CONTENT_TYPE, Body, Url};
use sdk_common::grpc;
use sdk_common::prelude::*;
use serde::Serialize;
use serde_json::json;
use strum_macros::EnumString;
use tokio::sync::{mpsc, watch, Mutex};
use tokio::time::{sleep, MissedTickBehavior};

use crate::backup::{BackupRequest, BackupTransport, BackupWatcher};
use crate::buy::{BuyBitcoinApi, BuyBitcoinService};
use crate::chain::{
    ChainService, Outspend, RecommendedFees, RedundantChainService, RedundantChainServiceTrait,
    DEFAULT_MEMPOOL_SPACE_URL,
};
use crate::error::{
    ConnectError, ReceiveOnchainError, ReceiveOnchainResult, ReceivePaymentError,
    RedeemOnchainResult, SdkError, SdkResult, SendOnchainError, SendPaymentError,
};
use crate::greenlight::{GLBackupTransport, Greenlight};
use crate::lnurl::pay::*;
use crate::lsp::LspInformation;
use crate::models::{
    parse_short_channel_id, ChannelState, ClosedChannelPaymentDetails, Config, EnvironmentType,
    LspAPI, NodeState, Payment, PaymentDetails, PaymentType, ReverseSwapPairInfo,
    ReverseSwapServiceAPI, SwapInfo, SwapperAPI, INVOICE_PAYMENT_FEE_EXPIRY_SECONDS,
};
use crate::node_api::{CreateInvoiceRequest, NodeAPI};
use crate::persist::db::SqliteStorage;
use crate::swap_in::swap::BTCReceiveSwap;
use crate::swap_out::boltzswap::BoltzApi;
use crate::swap_out::reverseswap::{BTCSendSwap, CreateReverseSwapArg};
use crate::*;

pub type BreezServicesResult<T, E = ConnectError> = Result<T, E>;

/// Trait that can be used to react to various [BreezEvent]s emitted by the SDK.
pub trait EventListener: Send + Sync {
    fn on_event(&self, e: BreezEvent);
}

/// Event emitted by the SDK. To listen for and react to these events, use an [EventListener] when
/// initializing the [BreezServices].
#[derive(Clone, Debug, PartialEq)]
#[allow(clippy::large_enum_variant)]
pub enum BreezEvent {
    /// Indicates that a new block has just been found
    NewBlock { block: u32 },
    /// Indicates that a new invoice has just been paid
    InvoicePaid { details: InvoicePaidDetails },
    /// Indicates that the local SDK state has just been sync-ed with the remote components
    Synced,
    /// Indicates that an outgoing payment has been completed successfully
    PaymentSucceed { details: Payment },
    /// Indicates that an outgoing payment has been failed to complete
    PaymentFailed { details: PaymentFailedData },
    /// Indicates that the backup process has just started
    BackupStarted,
    /// Indicates that the backup process has just finished successfully
    BackupSucceeded,
    /// Indicates that the backup process has just failed
    BackupFailed { details: BackupFailedData },
    /// Indicates that a reverse swap has been updated which may also
    /// include a status change
    ReverseSwapUpdated { details: ReverseSwapInfo },
    /// Indicates that a swap has been updated which may also
    /// include a status change
    SwapUpdated { details: SwapInfo },
}

#[derive(Clone, Debug, PartialEq)]
pub struct BackupFailedData {
    pub error: String,
}

#[derive(Clone, Debug, PartialEq)]
pub struct PaymentFailedData {
    pub error: String,
    pub node_id: String,
    pub invoice: Option<LNInvoice>,
    pub label: Option<String>,
}

/// Details of an invoice that has been paid, included as payload in an emitted [BreezEvent]
#[derive(Clone, Debug, PartialEq)]
pub struct InvoicePaidDetails {
    pub payment_hash: String,
    pub bolt11: String,
    pub payment: Option<Payment>,
}

pub trait LogStream: Send + Sync {
    fn log(&self, l: LogEntry);
}

/// Request to sign a message with the node's private key.
#[derive(Clone, Debug, PartialEq)]
pub struct SignMessageRequest {
    /// The message to be signed by the node's private key.
    pub message: String,
}

/// Response to a [SignMessageRequest].
#[derive(Clone, Debug, PartialEq)]
pub struct SignMessageResponse {
    /// The signature that covers the message of SignMessageRequest. Zbase
    /// encoded.
    pub signature: String,
}

/// Request to check a message was signed by a specific node id.
#[derive(Clone, Debug, PartialEq)]
pub struct CheckMessageRequest {
    /// The message that was signed.
    pub message: String,
    /// The public key of the node that signed the message.
    pub pubkey: String,
    /// The zbase encoded signature to verify.
    pub signature: String,
}

/// Response to a [CheckMessageRequest]
#[derive(Clone, Debug, PartialEq)]
pub struct CheckMessageResponse {
    /// Boolean value indicating whether the signature covers the message and
    /// was signed by the given pubkey.
    pub is_valid: bool,
}

#[derive(Clone, PartialEq, EnumString, Serialize)]
enum DevCommand {
    /// Generates diagnostic data report.
    #[strum(serialize = "generatediagnosticdata")]
    GenerateDiagnosticData,
}

/// BreezServices is a facade and the single entry point for the SDK.
pub struct BreezServices {
    config: Config,
    started: Mutex<bool>,
    node_api: Arc<dyn NodeAPI>,
    lsp_api: Arc<dyn LspAPI>,
    fiat_api: Arc<dyn FiatAPI>,
    buy_bitcoin_api: Arc<dyn BuyBitcoinApi>,
    support_api: Arc<dyn SupportAPI>,
    chain_service: Arc<dyn ChainService>,
    persister: Arc<SqliteStorage>,
    payment_receiver: Arc<PaymentReceiver>,
    btc_receive_swapper: Arc<BTCReceiveSwap>,
    btc_send_swapper: Arc<BTCSendSwap>,
    event_listener: Option<Box<dyn EventListener>>,
    backup_watcher: Arc<BackupWatcher>,
    shutdown_sender: watch::Sender<()>,
    shutdown_receiver: watch::Receiver<()>,
}

impl BreezServices {
    /// `connect` initializes the SDK services, schedules the node to run in the cloud and
    /// runs the signer. This must be called in order to start communicating with the node.
    ///
    /// # Arguments
    ///
    /// * `req` - The connect request containing the `config` SDK configuration and `seed` node
    ///   private key, typically derived from the mnemonic. When using a new `invite_code`,
    ///   the seed should be derived from a new random mnemonic. When re-using an `invite_code`,
    ///   the same mnemonic should be used as when the `invite_code` was first used.
    /// * `event_listener` - Listener to SDK events
    ///
    pub async fn connect(
        req: ConnectRequest,
        event_listener: Box<dyn EventListener>,
    ) -> BreezServicesResult<Arc<BreezServices>> {
        let sdk_version = option_env!("CARGO_PKG_VERSION").unwrap_or_default();
        let sdk_git_hash = option_env!("SDK_GIT_HASH").unwrap_or_default();
        info!("SDK v{sdk_version} ({sdk_git_hash})");
        let start = Instant::now();
        let services = BreezServicesBuilder::new(req.config)
            .seed(req.seed)
            .build(req.restore_only, Some(event_listener))
            .await?;
        services.start().await?;
        let connect_duration = start.elapsed();
        info!("SDK connected in: {connect_duration:?}");
        Ok(services)
    }

    /// Internal utility method that starts the BreezServices background tasks for this instance.
    ///
    /// It should be called once right after creating [BreezServices], since it is essential for the
    /// communicating with the node.
    ///
    /// It should be called only once when the app is started, regardless whether the app is sent to
    /// background and back.
    async fn start(self: &Arc<BreezServices>) -> BreezServicesResult<()> {
        let mut started = self.started.lock().await;
        ensure_sdk!(
            !*started,
            ConnectError::Generic {
                err: "BreezServices already started".into()
            }
        );

        let start = Instant::now();
        self.start_background_tasks().await?;
        let start_duration = start.elapsed();
        info!("SDK initialized in: {start_duration:?}");
        *started = true;
        Ok(())
    }

    /// Trigger the stopping of BreezServices background threads for this instance.
    pub async fn disconnect(&self) -> SdkResult<()> {
        let mut started = self.started.lock().await;
        ensure_sdk!(
            *started,
            SdkError::Generic {
                err: "BreezServices is not running".into(),
            }
        );
        self.shutdown_sender
            .send(())
            .map_err(|e| SdkError::Generic {
                err: format!("Shutdown failed: {e}"),
            })?;
        *started = false;
        Ok(())
    }

    /// Configure the node
    ///
    /// This calls [NodeAPI::configure_node] to make changes to the active node's configuration.
    /// Configuring the [ConfigureNodeRequest::close_to_address] only needs to be done one time
    /// when registering the node or when the close to address need to be changed. Otherwise it is
    /// stored by the node and used when neccessary.
    pub async fn configure_node(&self, req: ConfigureNodeRequest) -> SdkResult<()> {
        Ok(self.node_api.configure_node(req.close_to_address).await?)
    }

    /// Pay a bolt11 invoice
    ///
    /// Calling `send_payment` ensures that the payment is not already completed, if so it will result in an error.
    /// If the invoice doesn't specify an amount, the amount is taken from the `amount_msat` arg.
    pub async fn send_payment(
        &self,
        req: SendPaymentRequest,
    ) -> Result<SendPaymentResponse, SendPaymentError> {
        self.start_node().await?;
        let parsed_invoice = parse_invoice(req.bolt11.as_str())?;
        let invoice_expiration = parsed_invoice.timestamp + parsed_invoice.expiry;
        let current_time = SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs();
        if invoice_expiration < current_time {
            return Err(SendPaymentError::InvoiceExpired {
                err: format!("Invoice expired at {}", invoice_expiration),
            });
        }
        let invoice_amount_msat = parsed_invoice.amount_msat.unwrap_or_default();
        let provided_amount_msat = req.amount_msat.unwrap_or_default();

        // Valid the invoice network against the config network
        validate_network(parsed_invoice.clone(), self.config.network)?;

        let amount_msat = match (provided_amount_msat, invoice_amount_msat) {
            (0, 0) => {
                return Err(SendPaymentError::InvalidAmount {
                    err: "Amount must be provided when paying a zero invoice".into(),
                })
            }
            (0, amount_msat) => amount_msat,
            (amount_msat, 0) => amount_msat,
            (_amount_1, _amount_2) => {
                return Err(SendPaymentError::InvalidAmount {
                    err: "Amount should not be provided when paying a non zero invoice".into(),
                })
            }
        };

        if self
            .persister
            .get_completed_payment_by_hash(&parsed_invoice.payment_hash)?
            .is_some()
        {
            return Err(SendPaymentError::AlreadyPaid);
        }

        // If there is an lsp and the invoice route hint does not contain the
        // lsp in the hint, attempt a trampoline payment.
        let maybe_trampoline_id = match self.lsp_info().await {
            Ok(lsp_info) => {
                let lsp_pubkey = hex::encode(&lsp_info.lsp_pubkey);
                match parsed_invoice.routing_hints.iter().any(|hint| {
                    hint.hops
                        .last()
                        .map(|hop| hop.src_node_id == lsp_pubkey)
                        .unwrap_or(false)
                }) {
                    true => None,
                    false => Some(lsp_info.lsp_pubkey),
                }
            }
            Err(_) => None,
        };

        self.persist_pending_payment(&parsed_invoice, amount_msat, req.label.clone())?;

        // If trampoline is an option, try trampoline first.
        let trampoline_result = if let Some(trampoline_id) = maybe_trampoline_id {
            match self
                .node_api
                .send_trampoline_payment(
                    parsed_invoice.bolt11.clone(),
                    amount_msat,
                    req.label.clone(),
                    trampoline_id,
                )
                .await
            {
                Ok(res) => Some(res),
                Err(e) => {
                    warn!("trampoline payment failed: {:?}", e);
                    None
                }
            }
        } else {
            None
        };

        // If trampoline failed or didn't happen, fall back to regular payment.
        let payment_res = match trampoline_result {
            Some(res) => Ok(res),
            None => {
                self.node_api
                    .send_payment(
                        parsed_invoice.bolt11.clone(),
                        req.amount_msat,
                        req.label.clone(),
                    )
                    .map_err(Into::into)
                    .await
            }
        };

        let payment = self
            .on_payment_completed(
                parsed_invoice.payee_pubkey.clone(),
                Some(parsed_invoice),
                req.label,
                payment_res,
            )
            .await?;
        Ok(SendPaymentResponse { payment })
    }

    /// Pay directly to a node id using keysend
    pub async fn send_spontaneous_payment(
        &self,
        req: SendSpontaneousPaymentRequest,
    ) -> Result<SendPaymentResponse, SendPaymentError> {
        self.start_node().await?;
        let payment_res = self
            .node_api
            .send_spontaneous_payment(
                req.node_id.clone(),
                req.amount_msat,
                req.extra_tlvs,
                req.label.clone(),
            )
            .map_err(Into::into)
            .await;
        let payment = self
            .on_payment_completed(req.node_id, None, req.label, payment_res)
            .await?;
        Ok(SendPaymentResponse { payment })
    }

    /// Second step of LNURL-pay. The first step is `parse()`, which also validates the LNURL destination
    /// and generates the `LnUrlPayRequest` payload needed here.
    ///
    /// This call will validate the `amount_msat` and `comment` parameters of `req` against the parameters
    /// of the LNURL endpoint (`req_data`). If they match the endpoint requirements, the LNURL payment
    /// is made.
    ///
    /// This method will return an [anyhow::Error] when any validation check fails.
    pub async fn lnurl_pay(&self, req: LnUrlPayRequest) -> Result<LnUrlPayResult, LnUrlPayError> {
        match validate_lnurl_pay(
            req.amount_msat,
            &req.comment,
            &req.data,
            self.config.network,
            req.validate_success_action_url,
        )
        .await?
        {
            ValidatedCallbackResponse::EndpointError { data: e } => {
                Ok(LnUrlPayResult::EndpointError { data: e })
            }
            ValidatedCallbackResponse::EndpointSuccess { data: cb } => {
                let pay_req = SendPaymentRequest {
                    bolt11: cb.pr.clone(),
                    amount_msat: None,
                    label: req.payment_label,
                };
                let invoice = parse_invoice(cb.pr.as_str())?;

                let payment = match self.send_payment(pay_req).await {
                    Ok(p) => Ok(p),
                    e @ Err(
                        SendPaymentError::InvalidInvoice { .. }
                        | SendPaymentError::ServiceConnectivity { .. },
                    ) => e,
                    Err(e) => {
                        return Ok(LnUrlPayResult::PayError {
                            data: LnUrlPayErrorData {
                                payment_hash: invoice.payment_hash,
                                reason: e.to_string(),
                            },
                        })
                    }
                }?
                .payment;
                let details = match &payment.details {
                    PaymentDetails::ClosedChannel { .. } => {
                        return Err(LnUrlPayError::Generic {
                            err: "Payment lookup found unexpected payment type".into(),
                        });
                    }
                    PaymentDetails::Ln { data } => data,
                };

                let maybe_sa_processed: Option<SuccessActionProcessed> = match cb.success_action {
                    Some(sa) => {
                        let processed_sa = match sa {
                            // For AES, we decrypt the contents on the fly
                            SuccessAction::Aes(data) => {
                                let preimage = sha256::Hash::from_str(&details.payment_preimage)?;
                                let preimage_arr: [u8; 32] = preimage.into_inner();
                                let result = match (data, &preimage_arr).try_into() {
                                    Ok(data) => AesSuccessActionDataResult::Decrypted { data },
                                    Err(e) => AesSuccessActionDataResult::ErrorStatus {
                                        reason: e.to_string(),
                                    },
                                };
                                SuccessActionProcessed::Aes { result }
                            }
                            SuccessAction::Message(data) => {
                                SuccessActionProcessed::Message { data }
                            }
                            SuccessAction::Url(data) => SuccessActionProcessed::Url { data },
                        };
                        Some(processed_sa)
                    }
                    None => None,
                };

                let lnurl_pay_domain = match req.data.ln_address {
                    Some(_) => None,
                    None => Some(req.data.domain),
                };
                // Store SA (if available) + LN Address in separate table, associated to payment_hash
                self.persister.insert_payment_external_info(
                    &details.payment_hash,
                    PaymentExternalInfo {
                        lnurl_pay_success_action: maybe_sa_processed.clone(),
                        lnurl_pay_domain,
                        lnurl_pay_comment: req.comment,
                        lnurl_metadata: Some(req.data.metadata_str),
                        ln_address: req.data.ln_address,
                        lnurl_withdraw_endpoint: None,
                        attempted_amount_msat: invoice.amount_msat,
                        attempted_error: None,
                    },
                )?;

                Ok(LnUrlPayResult::EndpointSuccess {
                    data: lnurl::pay::LnUrlPaySuccessData {
                        payment,
                        success_action: maybe_sa_processed,
                    },
                })
            }
        }
    }

    /// Second step of LNURL-withdraw. The first step is `parse()`, which also validates the LNURL destination
    /// and generates the `LnUrlWithdrawRequest` payload needed here.
    ///
    /// This call will validate the given `amount_msat` against the parameters
    /// of the LNURL endpoint (`data`). If they match the endpoint requirements, the LNURL withdraw
    /// request is made. A successful result here means the endpoint started the payment.
    pub async fn lnurl_withdraw(
        &self,
        req: LnUrlWithdrawRequest,
    ) -> Result<LnUrlWithdrawResult, LnUrlWithdrawError> {
        let invoice = self
            .receive_payment(ReceivePaymentRequest {
                amount_msat: req.amount_msat,
                description: req.description.unwrap_or_default(),
                use_description_hash: Some(false),
                ..Default::default()
            })
            .await?
            .ln_invoice;

        let lnurl_w_endpoint = req.data.callback.clone();
        let res = validate_lnurl_withdraw(req.data, invoice).await?;

        if let LnUrlWithdrawResult::Ok { ref data } = res {
            // If endpoint was successfully called, store the LNURL-withdraw endpoint URL as metadata linked to the invoice
            self.persister.insert_payment_external_info(
                &data.invoice.payment_hash,
                PaymentExternalInfo {
                    lnurl_pay_success_action: None,
                    lnurl_pay_domain: None,
                    lnurl_pay_comment: None,
                    lnurl_metadata: None,
                    ln_address: None,
                    lnurl_withdraw_endpoint: Some(lnurl_w_endpoint),
                    attempted_amount_msat: None,
                    attempted_error: None,
                },
            )?;
        }

        Ok(res)
    }

    /// Third and last step of LNURL-auth. The first step is `parse()`, which also validates the LNURL destination
    /// and generates the `LnUrlAuthRequestData` payload needed here. The second step is user approval of auth action.
    ///
    /// This call will sign `k1` of the LNURL endpoint (`req_data`) on `secp256k1` using `linkingPrivKey` and DER-encodes the signature.
    /// If they match the endpoint requirements, the LNURL auth request is made. A successful result here means the client signature is verified.
    pub async fn lnurl_auth(
        &self,
        req_data: LnUrlAuthRequestData,
    ) -> Result<LnUrlCallbackStatus, LnUrlAuthError> {
        // m/138'/0
        let hashing_key = self.node_api.derive_bip32_key(vec![
            ChildNumber::from_hardened_idx(138).map_err(Into::<LnUrlError>::into)?,
            ChildNumber::from(0),
        ])?;

        let url =
            Url::from_str(&req_data.url).map_err(|e| LnUrlError::InvalidUri(e.to_string()))?;

        let derivation_path = get_derivation_path(hashing_key, url)?;
        let linking_key = self.node_api.derive_bip32_key(derivation_path)?;
        let linking_keys = linking_key.to_keypair(&Secp256k1::new());

        Ok(perform_lnurl_auth(linking_keys, req_data).await?)
    }

    /// Creates an bolt11 payment request.
    /// This also works when the node doesn't have any channels and need inbound liquidity.
    /// In such case when the invoice is paid a new zero-conf channel will be open by the LSP,
    /// providing inbound liquidity and the payment will be routed via this new channel.
    pub async fn receive_payment(
        &self,
        req: ReceivePaymentRequest,
    ) -> Result<ReceivePaymentResponse, ReceivePaymentError> {
        self.payment_receiver.receive_payment(req).await
    }

    /// Report an issue.
    ///
    /// Calling `report_issue` with a [ReportIssueRequest] enum param sends an issue report using the Support API.
    /// - [ReportIssueRequest::PaymentFailure] sends a payment failure report to the Support API
    ///   using the provided `payment_hash` to lookup the failed payment and the current [NodeState].
    pub async fn report_issue(&self, req: ReportIssueRequest) -> SdkResult<()> {
        match self.persister.get_node_state()? {
            Some(node_state) => match req {
                ReportIssueRequest::PaymentFailure { data } => {
                    let payment = self
                        .persister
                        .get_payment_by_hash(&data.payment_hash)?
                        .ok_or(SdkError::Generic {
                            err: "Payment not found".into(),
                        })?;
                    let lsp_id = self.persister.get_lsp_id()?;

                    self.support_api
                        .report_payment_failure(node_state, payment, lsp_id, data.comment)
                        .await
                }
            },
            None => Err(SdkError::Generic {
                err: "Node state not found".into(),
            }),
        }
    }

    /// Retrieve the decrypted credentials from the node.
    pub fn node_credentials(&self) -> SdkResult<Option<NodeCredentials>> {
        Ok(self.node_api.node_credentials()?)
    }

    /// Retrieve the node state from the persistent storage.
    ///
    /// Fail if it could not be retrieved or if `None` was found.
    pub fn node_info(&self) -> SdkResult<NodeState> {
        self.persister.get_node_state()?.ok_or(SdkError::Generic {
            err: "Node info not found".into(),
        })
    }

    /// Sign given message with the private key of the node id. Returns a zbase
    /// encoded signature.
    pub async fn sign_message(&self, req: SignMessageRequest) -> SdkResult<SignMessageResponse> {
        let signature = self.node_api.sign_message(&req.message).await?;
        Ok(SignMessageResponse { signature })
    }

    /// Check whether given message was signed by the private key or the given
    /// pubkey and the signature (zbase encoded) is valid.
    pub async fn check_message(&self, req: CheckMessageRequest) -> SdkResult<CheckMessageResponse> {
        let is_valid = self
            .node_api
            .check_message(&req.message, &req.pubkey, &req.signature)
            .await?;
        Ok(CheckMessageResponse { is_valid })
    }

    /// Retrieve the node up to date BackupStatus
    pub fn backup_status(&self) -> SdkResult<BackupStatus> {
        let backup_time = self.persister.get_last_backup_time()?;
        let sync_request = self.persister.get_last_sync_request()?;
        Ok(BackupStatus {
            last_backup_time: backup_time,
            backed_up: sync_request.is_none(),
        })
    }

    /// Force running backup
    pub async fn backup(&self) -> SdkResult<()> {
        let (on_complete, mut on_complete_receiver) = mpsc::channel::<Result<()>>(1);
        let req = BackupRequest::with(on_complete, true);
        self.backup_watcher.request_backup(req).await?;

        match on_complete_receiver.recv().await {
            Some(res) => res.map_err(|e| SdkError::Generic {
                err: format!("Backup failed: {e}"),
            }),
            None => Err(SdkError::Generic {
                err: "Backup process failed to complete".into(),
            }),
        }
    }

    /// List payments matching the given filters, as retrieved from persistent storage
    pub async fn list_payments(&self, req: ListPaymentsRequest) -> SdkResult<Vec<Payment>> {
        Ok(self.persister.list_payments(req)?)
    }

    /// Fetch a specific payment by its hash.
    pub async fn payment_by_hash(&self, hash: String) -> SdkResult<Option<Payment>> {
        Ok(self.persister.get_payment_by_hash(&hash)?)
    }

    /// Set the external metadata of a payment as a valid JSON string
    pub async fn set_payment_metadata(&self, hash: String, metadata: String) -> SdkResult<()> {
        Ok(self
            .persister
            .set_payment_external_metadata(hash, metadata)?)
    }

    /// Redeem on-chain funds from closed channels to the specified on-chain address, with the given feerate
    pub async fn redeem_onchain_funds(
        &self,
        req: RedeemOnchainFundsRequest,
    ) -> RedeemOnchainResult<RedeemOnchainFundsResponse> {
        self.start_node().await?;
        let txid = self
            .node_api
            .redeem_onchain_funds(req.to_address, req.sat_per_vbyte)
            .await?;
        self.sync().await?;
        Ok(RedeemOnchainFundsResponse { txid })
    }

    pub async fn prepare_redeem_onchain_funds(
        &self,
        req: PrepareRedeemOnchainFundsRequest,
    ) -> RedeemOnchainResult<PrepareRedeemOnchainFundsResponse> {
        self.start_node().await?;
        let response = self.node_api.prepare_redeem_onchain_funds(req).await?;
        Ok(response)
    }

    /// Fetch live rates of fiat currencies, sorted by name
    pub async fn fetch_fiat_rates(&self) -> SdkResult<Vec<Rate>> {
        self.fiat_api.fetch_fiat_rates().await.map_err(Into::into)
    }

    /// List all supported fiat currencies for which there is a known exchange rate.
    /// List is sorted by the canonical name of the currency
    pub async fn list_fiat_currencies(&self) -> SdkResult<Vec<FiatCurrency>> {
        self.fiat_api
            .list_fiat_currencies()
            .await
            .map_err(Into::into)
    }

    /// List available LSPs that can be selected by the user
    pub async fn list_lsps(&self) -> SdkResult<Vec<LspInformation>> {
        self.lsp_api.list_lsps(self.node_info()?.id).await
    }

    /// Select the LSP to be used and provide inbound liquidity
    pub async fn connect_lsp(&self, lsp_id: String) -> SdkResult<()> {
        match self.list_lsps().await?.iter().any(|lsp| lsp.id == lsp_id) {
            true => {
                self.persister.set_lsp_id(lsp_id)?;
                self.sync().await?;
                if let Some(webhook_url) = self.persister.get_webhook_url()? {
                    self.register_payment_notifications(webhook_url).await?
                }
                Ok(())
            }
            false => Err(SdkError::Generic {
                err: format!("Unknown LSP: {lsp_id}"),
            }),
        }
    }

    /// Get the current LSP's ID
    pub async fn lsp_id(&self) -> SdkResult<Option<String>> {
        Ok(self.persister.get_lsp_id()?)
    }

    /// Convenience method to look up [LspInformation] for a given LSP ID
    pub async fn fetch_lsp_info(&self, id: String) -> SdkResult<Option<LspInformation>> {
        get_lsp_by_id(self.persister.clone(), self.lsp_api.clone(), id.as_str()).await
    }

    /// Gets the fees required to open a channel for a given amount.
    /// If no channel is needed, returns 0. If a channel is needed, returns the required opening fees.
    pub async fn open_channel_fee(
        &self,
        req: OpenChannelFeeRequest,
    ) -> SdkResult<OpenChannelFeeResponse> {
        let lsp_info = self.lsp_info().await?;
        let fee_params = lsp_info
            .cheapest_open_channel_fee(req.expiry.unwrap_or(INVOICE_PAYMENT_FEE_EXPIRY_SECONDS))?
            .clone();

        let node_state = self.node_info()?;
        let fee_msat = req.amount_msat.map(|req_amount_msat| {
            match node_state.max_receivable_single_payment_amount_msat >= req_amount_msat {
                // In case we have enough inbound liquidity we return zero fee.
                true => 0,
                // Otherwise we need to calculate the fee for opening a new channel.
                false => fee_params.get_channel_fees_msat_for(req_amount_msat),
            }
        });

        Ok(OpenChannelFeeResponse {
            fee_msat,
            fee_params,
        })
    }

    /// Close all channels with the current LSP.
    ///
    /// Should be called  when the user wants to close all the channels.
    pub async fn close_lsp_channels(&self) -> SdkResult<Vec<String>> {
        self.start_node().await?;
        let lsp = self.lsp_info().await?;
        let tx_ids = self.node_api.close_peer_channels(lsp.pubkey).await?;
        self.sync().await?;
        Ok(tx_ids)
    }

    /// Onchain receive swap API
    ///
    /// Create and start a new swap. A user-selected [OpeningFeeParams] can be optionally set in the argument.
    /// If set, and the operation requires a new channel, the SDK will try to use the given fee params.
    ///
    /// Since we only allow one in-progress swap this method will return error if there is currently
    /// a swap waiting for confirmation to be redeemed and by that complete the swap.
    /// In such case the [BreezServices::in_progress_swap] can be used to query the live swap status.
    ///
    /// The returned [SwapInfo] contains the created swap details. The channel opening fees are
    /// available at [SwapInfo::channel_opening_fees].
    pub async fn receive_onchain(
        &self,
        req: ReceiveOnchainRequest,
    ) -> ReceiveOnchainResult<SwapInfo> {
        if let Some(in_progress) = self.in_progress_swap().await? {
            return Err(ReceiveOnchainError::SwapInProgress{ err:format!(
                    "A swap was detected for address {}. Use in_progress_swap method to get the current swap state",
                    in_progress.bitcoin_address
                )});
        }
        let channel_opening_fees = req.opening_fee_params.unwrap_or(
            self.lsp_info()
                .await?
                .cheapest_open_channel_fee(SWAP_PAYMENT_FEE_EXPIRY_SECONDS)?
                .clone(),
        );

        let swap_info = self
            .btc_receive_swapper
            .create_swap_address(channel_opening_fees)
            .await?;
        if let Some(webhook_url) = self.persister.get_webhook_url()? {
            let address = &swap_info.bitcoin_address;
            info!("Registering for onchain tx notification for address {address}");
            self.register_onchain_tx_notification(address, &webhook_url)
                .await?;
        }
        Ok(swap_info)
    }

    /// Returns an optional in-progress [SwapInfo].
    /// A [SwapInfo] is in-progress if it is waiting for confirmation to be redeemed and complete the swap.
    pub async fn in_progress_swap(&self) -> SdkResult<Option<SwapInfo>> {
        let tip = self.chain_service.current_tip().await?;
        self.btc_receive_swapper.rescan_monitored_swaps(tip).await?;
        let in_progress = self.btc_receive_swapper.list_in_progress()?;
        if !in_progress.is_empty() {
            return Ok(Some(in_progress[0].clone()));
        }
        Ok(None)
    }

    /// Iterate all historical swap addresses and fetch their current status from the blockchain.
    /// The status is then updated in the persistent storage.
    pub async fn rescan_swaps(&self) -> SdkResult<()> {
        let tip = self.chain_service.current_tip().await?;
        self.btc_receive_swapper.rescan_swaps(tip).await?;
        Ok(())
    }

    /// Redeems an individual swap.
    ///
    /// To be used only in the context of mobile notifications, where the notification triggers
    /// an individual redeem.
    ///
    /// This is taken care of automatically in the context of typical SDK usage.
    pub async fn redeem_swap(&self, swap_address: String) -> SdkResult<()> {
        let tip = self.chain_service.current_tip().await?;
        self.btc_receive_swapper
            .refresh_swap_on_chain_status(swap_address.clone(), tip)
            .await?;
        self.btc_receive_swapper.redeem_swap(swap_address).await?;
        Ok(())
    }

    /// Claims an individual reverse swap.
    ///
    /// To be used only in the context of mobile notifications, where the notification triggers
    /// an individual reverse swap to be claimed.
    ///
    /// This is taken care of automatically in the context of typical SDK usage.
    pub async fn claim_reverse_swap(&self, lockup_address: String) -> SdkResult<()> {
        Ok(self
            .btc_send_swapper
            .claim_reverse_swap(lockup_address)
            .await?)
    }

    /// Lookup the reverse swap fees (see [ReverseSwapServiceAPI::fetch_reverse_swap_fees]).
    ///
    /// If the request has the `send_amount_sat` set, the returned [ReverseSwapPairInfo] will have
    /// the total estimated fees for the reverse swap in its `total_estimated_fees`.
    ///
    /// If, in addition to that, the request has the `claim_tx_feerate` set as well, then
    /// - `fees_claim` will have the actual claim transaction fees, instead of an estimate, and
    /// - `total_estimated_fees` will have the actual total fees for the given parameters
    ///
    /// ### Errors
    ///
    /// If a `send_amount_sat` is specified in the `req`, but is outside the `min` and `max`,
    /// this will result in an error. If you are not sure what are the `min` and `max`, please call
    /// this with `send_amount_sat` as `None` first, then repeat the call with the desired amount.
    pub async fn fetch_reverse_swap_fees(
        &self,
        req: ReverseSwapFeesRequest,
    ) -> SdkResult<ReverseSwapPairInfo> {
        let mut res = self.btc_send_swapper.fetch_reverse_swap_fees().await?;

        if let Some(amt) = req.send_amount_sat {
            ensure_sdk!(amt <= res.max, SdkError::generic("Send amount is too high"));
            ensure_sdk!(amt >= res.min, SdkError::generic("Send amount is too low"));

            if let Some(claim_tx_feerate) = req.claim_tx_feerate {
                res.fees_claim = BTCSendSwap::calculate_claim_tx_fee(claim_tx_feerate)?;
            }

            let service_fee_sat = swap_out::get_service_fee_sat(amt, res.fees_percentage);
            res.total_fees = Some(service_fee_sat + res.fees_lockup + res.fees_claim);
        }

        Ok(res)
    }

    /// Returns the max amount that can be sent on-chain using the send_onchain method.
    /// The returned amount is the sum of the max amount that can be sent on each channel
    /// minus the expected fees.
    /// This is possible since the route to the swapper node is known in advance and is expected
    /// to consist of maximum 3 hops.
    #[deprecated(note = "use onchain_payment_limits instead")]
    pub async fn max_reverse_swap_amount(&self) -> SdkResult<MaxReverseSwapAmountResponse> {
        // fetch the last hop hints from the swapper
        let last_hop = self.btc_send_swapper.last_hop_for_payment().await?;
        info!("max_reverse_swap_amount last_hop={:?}", last_hop);
        // calculate the largest payment we can send over this route using maximum 3 hops
        // as follows:
        // User Node -> LSP Node -> Routing Node -> Swapper Node
        let max_to_pay = self
            .node_api
            .max_sendable_amount(
                Some(
                    hex::decode(&last_hop.src_node_id).map_err(|e| SdkError::Generic {
                        err: format!("Failed to decode hex node_id: {e}"),
                    })?,
                ),
                swap_out::reverseswap::MAX_PAYMENT_PATH_HOPS,
                Some(&last_hop),
            )
            .await?;

        // Sum the max amount per channel and return the result
        let total_msat: u64 = max_to_pay.into_iter().map(|m| m.amount_msat).sum();
        let total_sat = total_msat / 1000;
        Ok(MaxReverseSwapAmountResponse { total_sat })
    }

    /// Creates a reverse swap and attempts to pay the HODL invoice
    #[deprecated(note = "use pay_onchain instead")]
    pub async fn send_onchain(
        &self,
        req: SendOnchainRequest,
    ) -> Result<SendOnchainResponse, SendOnchainError> {
        let reverse_swap_info = self
            .pay_onchain_common(CreateReverseSwapArg::V1(req))
            .await?;
        Ok(SendOnchainResponse { reverse_swap_info })
    }

    /// Returns the blocking [ReverseSwapInfo]s that are in progress
    #[deprecated(note = "use in_progress_onchain_payments instead")]
    pub async fn in_progress_reverse_swaps(&self) -> SdkResult<Vec<ReverseSwapInfo>> {
        let full_rsis = self.btc_send_swapper.list_blocking().await?;

        let mut rsis = vec![];
        for full_rsi in full_rsis {
            let rsi = self
                .btc_send_swapper
                .convert_reverse_swap_info(full_rsi)
                .await?;
            rsis.push(rsi);
        }

        Ok(rsis)
    }

    /// list non-completed expired swaps that should be refunded by calling [BreezServices::refund]
    pub async fn list_refundables(&self) -> SdkResult<Vec<SwapInfo>> {
        Ok(self.btc_receive_swapper.list_refundables()?)
    }

    /// Prepares a refund transaction for a failed/expired swap.
    ///
    /// Can optionally be used before [BreezServices::refund] to know how much fees will be paid
    /// to perform the refund.
    pub async fn prepare_refund(
        &self,
        req: PrepareRefundRequest,
    ) -> SdkResult<PrepareRefundResponse> {
        Ok(self.btc_receive_swapper.prepare_refund_swap(req).await?)
    }

    /// Construct and broadcast a refund transaction for a failed/expired swap
    ///
    /// Returns the txid of the refund transaction.
    pub async fn refund(&self, req: RefundRequest) -> SdkResult<RefundResponse> {
        Ok(self.btc_receive_swapper.refund_swap(req).await?)
    }

    pub async fn onchain_payment_limits(&self) -> SdkResult<OnchainPaymentLimitsResponse> {
        let fee_info = self.btc_send_swapper.fetch_reverse_swap_fees().await?;
        debug!("Reverse swap pair info: {fee_info:?}");
        #[allow(deprecated)]
        let max_amt_current_channels = self.max_reverse_swap_amount().await?;
        debug!("Max send amount possible with current channels: {max_amt_current_channels:?}");

        Ok(OnchainPaymentLimitsResponse {
            min_sat: fee_info.min,
            max_sat: fee_info.max,
            max_payable_sat: max_amt_current_channels.total_sat,
        })
    }

    /// Supersedes [BreezServices::fetch_reverse_swap_fees]
    ///
    /// ### Errors
    ///
    /// - `OutOfRange`: This indicates the send amount is outside the range of minimum and maximum
    ///   values returned by [BreezServices::onchain_payment_limits]. When you get this error, please first call
    ///   [BreezServices::onchain_payment_limits] to get the new limits, before calling this method again.
    pub async fn prepare_onchain_payment(
        &self,
        req: PrepareOnchainPaymentRequest,
    ) -> Result<PrepareOnchainPaymentResponse, SendOnchainError> {
        let fees_claim = BTCSendSwap::calculate_claim_tx_fee(req.claim_tx_feerate)?;
        BTCSendSwap::validate_claim_tx_fee(fees_claim)?;

        let fee_info = self.btc_send_swapper.fetch_reverse_swap_fees().await?;

        // Calculate (send_amt, recv_amt) from the inputs and fees
        let fees_lockup = fee_info.fees_lockup;
        let p = fee_info.fees_percentage;
        let fees_claim = BTCSendSwap::calculate_claim_tx_fee(req.claim_tx_feerate)?;
        let (send_amt, recv_amt) = match req.amount_type {
            SwapAmountType::Send => {
                let temp_send_amt = req.amount_sat;
                let service_fees = swap_out::get_service_fee_sat(temp_send_amt, p);
                let total_fees = service_fees + fees_lockup + fees_claim;
                ensure_sdk!(
                    temp_send_amt > total_fees,
                    SendOnchainError::generic(
                        "Send amount is not high enough to account for all fees"
                    )
                );

                (temp_send_amt, temp_send_amt - total_fees)
            }
            SwapAmountType::Receive => {
                let temp_recv_amt = req.amount_sat;
                let send_amt_minus_service_fee = temp_recv_amt + fees_lockup + fees_claim;
                let temp_send_amt = swap_out::get_invoice_amount_sat(send_amt_minus_service_fee, p);

                (temp_send_amt, temp_recv_amt)
            }
        };

        let is_send_in_range = send_amt >= fee_info.min && send_amt <= fee_info.max;
        ensure_sdk!(is_send_in_range, SendOnchainError::OutOfRange);

        Ok(PrepareOnchainPaymentResponse {
            fees_hash: fee_info.fees_hash.clone(),
            fees_percentage: p,
            fees_lockup,
            fees_claim,
            sender_amount_sat: send_amt,
            recipient_amount_sat: recv_amt,
            total_fees: send_amt - recv_amt,
        })
    }

    /// Creates a reverse swap and attempts to pay the HODL invoice
    ///
    /// Supersedes [BreezServices::send_onchain]
    pub async fn pay_onchain(
        &self,
        req: PayOnchainRequest,
    ) -> Result<PayOnchainResponse, SendOnchainError> {
        ensure_sdk!(
            req.prepare_res.sender_amount_sat > req.prepare_res.recipient_amount_sat,
            SendOnchainError::generic("Send amount must be bigger than receive amount")
        );

        let reverse_swap_info = self
            .pay_onchain_common(CreateReverseSwapArg::V2(req))
            .await?;
        Ok(PayOnchainResponse { reverse_swap_info })
    }

    async fn pay_onchain_common(&self, req: CreateReverseSwapArg) -> SdkResult<ReverseSwapInfo> {
        ensure_sdk!(self.in_progress_onchain_payments().await?.is_empty(), SdkError::Generic { err:
            "You can only start a new one after after the ongoing ones finish. \
            Use the in_progress_reverse_swaps method to get an overview of currently ongoing reverse swaps".into(),
        });

        let full_rsi = self.btc_send_swapper.create_reverse_swap(req).await?;
        let reverse_swap_info = self
            .btc_send_swapper
            .convert_reverse_swap_info(full_rsi.clone())
            .await?;
        self.do_sync(false).await?;

        if let Some(webhook_url) = self.persister.get_webhook_url()? {
            let address = &full_rsi
                .get_lockup_address(self.config.network)?
                .to_string();
            info!("Registering for onchain tx notification for address {address}");
            self.register_onchain_tx_notification(address, &webhook_url)
                .await?;
        }
        Ok(reverse_swap_info)
    }

    /// Returns the blocking [ReverseSwapInfo]s that are in progress.
    ///
    /// Supersedes [BreezServices::in_progress_reverse_swaps]
    pub async fn in_progress_onchain_payments(&self) -> SdkResult<Vec<ReverseSwapInfo>> {
        #[allow(deprecated)]
        self.in_progress_reverse_swaps().await
    }

    /// Execute a command directly on the NodeAPI interface.
    /// Mainly used to debugging.
    pub async fn execute_dev_command(&self, command: String) -> SdkResult<String> {
        let dev_cmd_res = DevCommand::from_str(&command);

        match dev_cmd_res {
            Ok(dev_cmd) => match dev_cmd {
                DevCommand::GenerateDiagnosticData => self.generate_diagnostic_data().await,
            },
            Err(_) => Ok(self.node_api.execute_command(command).await?),
        }
    }

    // Collects various user data from the node and the sdk storage.
    // This is used for debugging and support purposes only.
    pub async fn generate_diagnostic_data(&self) -> SdkResult<String> {
        let now_sec = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .map(|d| d.as_secs())
            .unwrap_or_default();
        let node_data = self
            .node_api
            .generate_diagnostic_data()
            .await
            .unwrap_or_else(|e| e.to_string());
        let sdk_data = self
            .generate_sdk_diagnostic_data()
            .await
            .unwrap_or_else(|e| e.to_string());
        Ok(format!(
            "Diagnostic Timestamp: {now_sec}\nNode Data\n{node_data}\n\nSDK Data\n{sdk_data}"
        ))
    }

    /// This method sync the local state with the remote node state.
    /// The synced items are as follows:
    /// * node state - General information about the node and its liquidity status
    /// * channels - The list of channels and their status
    /// * payments - The incoming/outgoing payments
    pub async fn sync(&self) -> SdkResult<()> {
        Ok(self.do_sync(false).await?)
    }

    async fn do_sync(&self, match_local_balance: bool) -> Result<()> {
        let start = Instant::now();
        let node_pubkey = self.node_api.start().await?;
        self.connect_lsp_peer(node_pubkey).await?;

        // First query the changes since last sync time.
        let since_timestamp = self.persister.get_last_sync_time()?.unwrap_or(0);
        let new_data = &self
            .node_api
            .pull_changed(since_timestamp, match_local_balance)
            .await?;

        debug!(
            "pull changed time={:?} {:?}",
            since_timestamp, new_data.payments
        );

        // update node state and channels state
        self.persister.set_node_state(&new_data.node_state)?;

        let channels_before_update = self.persister.list_channels()?;
        self.persister.update_channels(&new_data.channels)?;
        let channels_after_update = self.persister.list_channels()?;

        // Fetch the static backup if needed and persist it
        if channels_before_update.len() != channels_after_update.len() {
            info!("fetching static backup file from node");
            let backup = self.node_api.static_backup().await?;
            self.persister.set_static_backup(backup)?;
        }

        //fetch closed_channel and convert them to Payment items.
        let mut closed_channel_payments: Vec<Payment> = vec![];
        for closed_channel in
            self.persister.list_channels()?.into_iter().filter(|c| {
                c.state == ChannelState::Closed || c.state == ChannelState::PendingClose
            })
        {
            let closed_channel_tx = self.closed_channel_to_transaction(closed_channel).await?;
            closed_channel_payments.push(closed_channel_tx);
        }

        // update both closed channels and lightning transaction payments
        let mut payments = closed_channel_payments;
        payments.extend(new_data.payments.clone());
        self.persister.insert_or_update_payments(&payments, true)?;
        let duration = start.elapsed();
        info!("Sync duration: {:?}", duration);

        // update the cached last sync time
        if let Ok(last_payment_timestamp) = self.persister.last_payment_timestamp() {
            self.persister.set_last_sync_time(last_payment_timestamp)?;
        }

        self.notify_event_listeners(BreezEvent::Synced).await?;
        Ok(())
    }

    /// Connects to the selected LSP peer.
    /// This validates if the selected LSP is still in [`list_lsps`].
    /// If not or no LSP is selected, it selects the first LSP in [`list_lsps`].
    async fn connect_lsp_peer(&self, node_pubkey: String) -> SdkResult<()> {
        let lsps = self.lsp_api.list_lsps(node_pubkey).await?;
        if let Some(lsp) = self
            .persister
            .get_lsp_id()?
            .and_then(|lsp_id| lsps.clone().into_iter().find(|lsp| lsp.id == lsp_id))
            .or_else(|| lsps.first().cloned())
        {
            self.persister.set_lsp_id(lsp.id)?;
            if let Ok(node_state) = self.node_info() {
                let node_id = lsp.pubkey;
                let address = lsp.host;
                let lsp_connected = node_state
                    .connected_peers
                    .iter()
                    .any(|e| e == node_id.as_str());
                if !lsp_connected {
                    debug!("connecting to lsp {}@{}", node_id.clone(), address.clone());
                    self.node_api
                        .connect_peer(node_id.clone(), address.clone())
                        .await
                        .map_err(|e| SdkError::ServiceConnectivity {
                            err: format!("(LSP: {node_id}) Failed to connect: {e}"),
                        })?;
                }
                debug!("connected to lsp {node_id}@{address}");
            }
        }
        Ok(())
    }

    fn persist_pending_payment(
        &self,
        invoice: &LNInvoice,
        amount_msat: u64,
        label: Option<String>,
    ) -> Result<(), SendPaymentError> {
        self.persister.insert_or_update_payments(
            &[Payment {
                id: invoice.payment_hash.clone(),
                payment_type: PaymentType::Sent,
                payment_time: SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs() as i64,
                amount_msat,
                fee_msat: 0,
                status: PaymentStatus::Pending,
                error: None,
                description: invoice.description.clone(),
                details: PaymentDetails::Ln {
                    data: LnPaymentDetails {
                        payment_hash: invoice.payment_hash.clone(),
                        label: label.unwrap_or_default(),
                        destination_pubkey: invoice.payee_pubkey.clone(),
                        payment_preimage: String::new(),
                        keysend: false,
                        bolt11: invoice.bolt11.clone(),
                        lnurl_success_action: None,
                        lnurl_pay_domain: None,
                        lnurl_pay_comment: None,
                        ln_address: None,
                        lnurl_metadata: None,
                        lnurl_withdraw_endpoint: None,
                        swap_info: None,
                        reverse_swap_info: None,
                        pending_expiration_block: None,
                        open_channel_bolt11: None,
                    },
                },
                metadata: None,
            }],
            false,
        )?;

        self.persister.insert_payment_external_info(
            &invoice.payment_hash,
            PaymentExternalInfo {
                lnurl_pay_success_action: None,
                lnurl_pay_domain: None,
                lnurl_pay_comment: None,
                lnurl_metadata: None,
                ln_address: None,
                lnurl_withdraw_endpoint: None,
                attempted_amount_msat: invoice.amount_msat.map_or(Some(amount_msat), |_| None),
                attempted_error: None,
            },
        )?;
        Ok(())
    }

    async fn on_payment_completed(
        &self,
        node_id: String,
        invoice: Option<LNInvoice>,
        label: Option<String>,
        payment_res: Result<Payment, SendPaymentError>,
    ) -> Result<Payment, SendPaymentError> {
        self.do_sync(false).await?;
        match payment_res {
            Ok(payment) => {
                self.notify_event_listeners(BreezEvent::PaymentSucceed {
                    details: payment.clone(),
                })
                .await?;
                Ok(payment)
            }
            Err(e) => {
                if let Some(invoice) = invoice.clone() {
                    self.persister.update_payment_attempted_error(
                        &invoice.payment_hash,
                        Some(e.to_string()),
                    )?;
                }
                self.notify_event_listeners(BreezEvent::PaymentFailed {
                    details: PaymentFailedData {
                        error: e.to_string(),
                        node_id,
                        invoice,
                        label,
                    },
                })
                .await?;
                Err(e)
            }
        }
    }

    async fn on_event(&self, e: BreezEvent) -> Result<()> {
        debug!("breez services got event {:?}", e);
        self.notify_event_listeners(e.clone()).await
    }

    async fn notify_event_listeners(&self, e: BreezEvent) -> Result<()> {
        if let Err(err) = self.btc_receive_swapper.on_event(e.clone()).await {
            debug!(
                "btc_receive_swapper failed to process event {:?}: {:?}",
                e, err
            )
        };
        if let Err(err) = self.btc_send_swapper.on_event(e.clone()).await {
            debug!(
                "btc_send_swapper failed to process event {:?}: {:?}",
                e, err
            )
        };

        if self.event_listener.is_some() {
            self.event_listener.as_ref().unwrap().on_event(e.clone())
        }
        Ok(())
    }

    /// Convenience method to look up LSP info based on current LSP ID
    pub async fn lsp_info(&self) -> SdkResult<LspInformation> {
        get_lsp(self.persister.clone(), self.lsp_api.clone()).await
    }

    pub(crate) async fn start_node(&self) -> Result<()> {
        self.node_api.start().await?;
        Ok(())
    }

    /// Get the recommended fees for onchain transactions
    pub async fn recommended_fees(&self) -> SdkResult<RecommendedFees> {
        self.chain_service.recommended_fees().await
    }

    /// Get the full default config for a specific environment type
    pub fn default_config(
        env_type: EnvironmentType,
        api_key: String,
        node_config: NodeConfig,
    ) -> Config {
        match env_type {
            EnvironmentType::Production => Config::production(api_key, node_config),
            EnvironmentType::Staging => Config::staging(api_key, node_config),
        }
    }

    /// Get the static backup data from the persistent storage.
    /// This data enables the user to recover the node in an external core ligntning node.
    /// See here for instructions on how to recover using this data: <https://docs.corelightning.org/docs/backup-and-recovery#backing-up-using-static-channel-backup>
    pub fn static_backup(req: StaticBackupRequest) -> SdkResult<StaticBackupResponse> {
        let storage = SqliteStorage::new(req.working_dir);
        Ok(StaticBackupResponse {
            backup: storage.get_static_backup()?,
        })
    }

    /// Fetches the service health check from the support API.
    pub async fn service_health_check(api_key: String) -> SdkResult<ServiceHealthCheckResponse> {
        let support_api: Arc<dyn SupportAPI> = Arc::new(BreezServer::new(
            PRODUCTION_BREEZSERVER_URL.to_string(),
            Some(api_key),
        )?);

        support_api.service_health_check().await
    }

    /// Generates an url that can be used by a third part provider to buy Bitcoin with fiat currency.
    ///
    /// A user-selected [OpeningFeeParams] can be optionally set in the argument. If set, and the
    /// operation requires a new channel, the SDK will try to use the given fee params.
    pub async fn buy_bitcoin(
        &self,
        req: BuyBitcoinRequest,
    ) -> Result<BuyBitcoinResponse, ReceiveOnchainError> {
        let swap_info = self
            .receive_onchain(ReceiveOnchainRequest {
                opening_fee_params: req.opening_fee_params,
            })
            .await?;
        let url = self
            .buy_bitcoin_api
            .buy_bitcoin(req.provider, &swap_info, req.redirect_url)
            .await?;

        Ok(BuyBitcoinResponse {
            url,
            opening_fee_params: swap_info.channel_opening_fees,
        })
    }

    /// Starts the BreezServices background threads.
    ///
    /// Internal method. Should only be used as part of [BreezServices::start]
    async fn start_background_tasks(self: &Arc<BreezServices>) -> SdkResult<()> {
        // start the signer
        let (shutdown_signer_sender, signer_signer_receiver) = mpsc::channel(1);
        self.start_signer(signer_signer_receiver).await;
        self.start_node_keep_alive(self.shutdown_receiver.clone())
            .await;

        // Sync node state
        match self.persister.get_node_state()? {
            Some(node) => {
                info!("Starting existing node {}", node.id);
                self.connect_lsp_peer(node.id).await?;
            }
            None => {
                // In case it is a first run we sync in foreground to get the node state.
                info!("First run, syncing in foreground");
                self.sync().await?;
                info!("First run, finished running syncing in foreground");
            }
        }

        // start backup watcher
        self.start_backup_watcher().await?;

        //track backup events
        self.track_backup_events().await;

        //track swap events
        self.track_swap_events().await;

        // track paid invoices
        self.track_invoices().await;

        // track new blocks
        self.track_new_blocks().await;

        // track logs
        self.track_logs().await;

        // Stop signer on shutdown
        let mut shutdown_receiver = self.shutdown_receiver.clone();
        tokio::spawn(async move {
            // start the backup watcher
            _ = shutdown_receiver.changed().await;
            _ = shutdown_signer_sender.send(()).await;
            debug!("Received the signal to exit event polling loop");
        });

        self.init_chainservice_urls().await?;

        Ok(())
    }

    async fn start_signer(self: &Arc<BreezServices>, shutdown_receiver: mpsc::Receiver<()>) {
        let signer_api = self.clone();
        tokio::spawn(async move {
            tokio::time::sleep(std::time::Duration::from_secs(2)).await;
            signer_api.node_api.start_signer(shutdown_receiver).await;
        });
    }

    async fn start_node_keep_alive(
        self: &Arc<BreezServices>,
        shutdown_receiver: watch::Receiver<()>,
    ) {
        let cloned = self.clone();
        tokio::spawn(async move {
            cloned.node_api.start_keep_alive(shutdown_receiver).await;
        });
    }

    async fn start_backup_watcher(self: &Arc<BreezServices>) -> Result<()> {
        self.backup_watcher
            .start(self.shutdown_receiver.clone())
            .await
            .map_err(|e| anyhow!("Failed to start backup watcher: {e}"))?;

        // Restore backup state and request backup on start if needed
        let force_backup = self
            .persister
            .get_last_sync_version()
            .map_err(|e| anyhow!("Failed to read last sync version: {e}"))?
            .is_none();
        self.backup_watcher
            .request_backup(BackupRequest::new(force_backup))
            .await
            .map_err(|e| anyhow!("Failed to request backup: {e}"))
    }

    async fn track_backup_events(self: &Arc<BreezServices>) {
        let cloned = self.clone();
        tokio::spawn(async move {
            let mut events_stream = cloned.backup_watcher.subscribe_events();
            let mut shutdown_receiver = cloned.shutdown_receiver.clone();
            loop {
                tokio::select! {
                  backup_event = events_stream.recv() => {
                   if let Ok(e) = backup_event {
                    if let Err(err) = cloned.notify_event_listeners(e).await {
                        error!("error handling backup event: {:?}", err);
                    }
                   }
                   let backup_status = cloned.backup_status();
                   info!("backup status: {:?}", backup_status);
                  },
                  _ = shutdown_receiver.changed() => {
                   debug!("Backup watcher task completed");
                   break;
                 }
                }
            }
        });
    }

    async fn track_swap_events(self: &Arc<BreezServices>) {
        let cloned = self.clone();
        tokio::spawn(async move {
            let mut swap_events_stream = cloned.btc_receive_swapper.subscribe_status_changes();
            let mut rev_swap_events_stream = cloned.btc_send_swapper.subscribe_status_changes();
            let mut shutdown_receiver = cloned.shutdown_receiver.clone();
            loop {
                tokio::select! {
                    swap_event = swap_events_stream.recv() => {
                        if let Ok(e) = swap_event {
                            if let Err(err) = cloned.notify_event_listeners(e).await {
                                error!("error handling swap event: {:?}", err);
                            }
                        }
                    },
                    rev_swap_event = rev_swap_events_stream.recv() => {
                        if let Ok(e) = rev_swap_event {
                            if let Err(err) = cloned.notify_event_listeners(e).await {
                                error!("error handling reverse swap event: {:?}", err);
                            }
                        }
                    },
                    _ = shutdown_receiver.changed() => {
                        debug!("Swap events handling task completed");
                        break;
                    }
                }
            }
        });
    }

    async fn track_invoices(self: &Arc<BreezServices>) {
        let cloned = self.clone();
        tokio::spawn(async move {
            let mut shutdown_receiver = cloned.shutdown_receiver.clone();
            loop {
                if shutdown_receiver.has_changed().unwrap_or(true) {
                    return;
                }
                let invoice_stream_res = cloned.node_api.stream_incoming_payments().await;
                if let Ok(mut invoice_stream) = invoice_stream_res {
                    loop {
                        tokio::select! {
                                paid_invoice_res = invoice_stream.message() => {
                                      match paid_invoice_res {
                                          Ok(Some(i)) => {
                                              debug!("invoice stream got new invoice");
                                              if let Some(gl_client::signer::model::greenlight::incoming_payment::Details::Offchain(p)) = i.details {
                                                  let mut payment: Option<crate::models::Payment> = p.clone().try_into().ok();
                                                  if let Some(ref p) = payment {
                                                      let res = cloned
                                                          .persister
                                                          .insert_or_update_payments(&vec![p.clone()], false);
                                                      debug!("paid invoice was added to payments list {res:?}");
                                                      if let Ok(Some(mut node_info)) = cloned.persister.get_node_state() {
                                                          node_info.channels_balance_msat += p.amount_msat;
                                                          let res = cloned.persister.set_node_state(&node_info);
                                                          debug!("channel balance was updated {res:?}");
                                                      }
                                                      payment = cloned.persister.get_payment_by_hash(&p.id).unwrap_or(payment);
                                                  }
                                                  _ = cloned.on_event(BreezEvent::InvoicePaid {
                                                      details: InvoicePaidDetails {
                                                          payment_hash: hex::encode(p.payment_hash),
                                                          bolt11: p.bolt11,
                                                          payment,
                                                      },
                                                  }).await;
                                                  if let Err(e) = cloned.do_sync(true).await {
                                                      error!("failed to sync after paid invoice: {:?}", e);
                                                  }
                                              }
                                          }
                                          Ok(None) => {
                                              debug!("invoice stream got None");
                                              break;
                                          }
                                          Err(err) => {
                                              debug!("invoice stream got error: {:?}", err);
                                              break;
                                          }
                                      }
                             }

                             _ = shutdown_receiver.changed() => {
                              debug!("Invoice tracking task has completed");
                              return;
                             }
                        }
                    }
                }
                sleep(Duration::from_secs(1)).await;
            }
        });
    }

    async fn track_logs(self: &Arc<BreezServices>) {
        let cloned = self.clone();
        tokio::spawn(async move {
            let mut shutdown_receiver = cloned.shutdown_receiver.clone();
            loop {
                if shutdown_receiver.has_changed().unwrap_or(true) {
                    return;
                }
                let log_stream_res = cloned.node_api.stream_log_messages().await;
                if let Ok(mut log_stream) = log_stream_res {
                    loop {
                        tokio::select! {
                         log_message_res = log_stream.message() => {
                          match log_message_res {
                           Ok(Some(l)) => {
                            info!("node-logs: {}", l.line);
                           },
                           // stream is closed, renew it
                           Ok(None) => {
                            break;
                           }
                           Err(err) => {
                            debug!("failed to process log entry {:?}", err);
                            break;
                           }
                          };
                         }

                         _ = shutdown_receiver.changed() => {
                          debug!("Track logs task has completed");
                          return;
                         }
                        }
                    }
                }
                sleep(Duration::from_secs(1)).await;
            }
        });
    }

    async fn track_new_blocks(self: &Arc<BreezServices>) {
        let cloned = self.clone();
        tokio::spawn(async move {
            let mut current_block: u32 = 0;
            let mut shutdown_receiver = cloned.shutdown_receiver.clone();
            let mut interval = tokio::time::interval(Duration::from_secs(30));
            interval.set_missed_tick_behavior(MissedTickBehavior::Skip);
            loop {
                tokio::select! {
                    _ = interval.tick() => {
                        let tip_res = cloned.chain_service.current_tip().await;
                        match tip_res {
                            Ok(next_block) => {
                                debug!("got tip {:?}", next_block);
                                if next_block > current_block {
                                    _ = cloned.sync().await;
                                    _ = cloned.on_event(BreezEvent::NewBlock{block: next_block}).await;
                                }
                                current_block = next_block
                            },
                            Err(e) => {
                                error!("failed to fetch next block {}", e)
                            }
                        };
                    }

                    _ = shutdown_receiver.changed() => {
                        debug!("New blocks task has completed");
                        return;
                    }
                }
            }
        });
    }

    async fn init_chainservice_urls(&self) -> Result<()> {
        let breez_server = Arc::new(BreezServer::new(
            PRODUCTION_BREEZSERVER_URL.to_string(),
            None,
        )?);
        let persister = &self.persister;

        let cloned_breez_server = breez_server.clone();
        let cloned_persister = persister.clone();
        tokio::spawn(async move {
            match cloned_breez_server.fetch_mempoolspace_urls().await {
                Ok(fresh_urls) => {
                    if let Err(e) = cloned_persister.set_mempoolspace_base_urls(fresh_urls) {
                        error!("Failed to cache mempool.space URLs: {e}");
                    }
                }
                Err(e) => error!("Failed to fetch mempool.space URLs: {e}"),
            }
        });

        Ok(())
    }

    /// Configures a global SDK logger that will log to file and will forward log events to
    /// an optional application-specific logger.
    ///
    /// If called, it should be called before any SDK methods (for example, before `connect`).
    ///
    /// It must be called only once in the application lifecycle. Alternatively, If the application
    /// already uses a globally-registered logger, this method shouldn't be called at all.
    ///
    /// ### Arguments
    ///
    /// - `log_dir`: Location where the the SDK log file will be created. The directory must already exist.
    ///
    /// - `app_logger`: Optional application logger.
    ///
    /// If the application is to use it's own logger, but would also like the SDK to log SDK-specific
    /// log output to a file in the configured `log_dir`, then do not register the
    /// app-specific logger as a global logger and instead call this method with the app logger as an arg.
    ///
    /// ### Logging Configuration
    ///
    /// Setting `breez_sdk_core::input_parser=debug` will include in the logs the raw payloads received
    /// when interacting with JSON endpoints, for example those used during all LNURL workflows.
    ///
    /// ### Errors
    ///
    /// An error is thrown if the log file cannot be created in the working directory.
    ///
    /// An error is thrown if a global logger is already configured.
    pub fn init_logging(log_dir: &str, app_logger: Option<Box<dyn log::Log>>) -> Result<()> {
        let target_log_file = Box::new(
            OpenOptions::new()
                .create(true)
                .append(true)
                .open(format!("{log_dir}/sdk.log"))
                .map_err(|e| anyhow!("Can't create log file: {e}"))?,
        );
        let logger = env_logger::Builder::new()
            .target(env_logger::Target::Pipe(target_log_file))
            .parse_filters(
                r#"
                debug,
                breez_sdk_core::input_parser=warn,
                breez_sdk_core::backup=info,
                breez_sdk_core::persist::reverseswap=info,
                breez_sdk_core::reverseswap=info,
                gl_client=debug,
                h2=warn,
                hyper=warn,
                lightning_signer=warn,
                reqwest=warn,
                rustls=warn,
                rustyline=warn,
                vls_protocol_signer=warn
            "#,
            )
            .format(|buf, record| {
                writeln!(
                    buf,
                    "[{} {} {}:{}] {}",
                    Local::now().format("%Y-%m-%d %H:%M:%S%.3f"),
                    record.level(),
                    record.module_path().unwrap_or("unknown"),
                    record.line().unwrap_or(0),
                    record.args()
                )
            })
            .build();

        let global_logger = GlobalSdkLogger {
            logger,
            log_listener: app_logger,
        };

        log::set_boxed_logger(Box::new(global_logger))
            .map_err(|e| anyhow!("Failed to set global logger: {e}"))?;
        log::set_max_level(LevelFilter::Trace);

        Ok(())
    }

    async fn lookup_chain_service_closing_outspend(
        &self,
        channel: crate::models::Channel,
    ) -> Result<Option<Outspend>> {
        match channel.funding_outnum {
            None => Ok(None),
            Some(outnum) => {
                // Find the output tx that was used to fund the channel
                let outspends = self
                    .chain_service
                    .transaction_outspends(channel.funding_txid.clone())
                    .await?;

                Ok(outspends.get(outnum as usize).cloned())
            }
        }
    }

    /// Chain service lookup of relevant channel closing fields (closed_at, closing_txid).
    ///
    /// Should be used sparingly because it involves a network lookup.
    async fn lookup_channel_closing_data(
        &self,
        channel: &crate::models::Channel,
    ) -> Result<(Option<u64>, Option<String>)> {
        let maybe_outspend_res = self
            .lookup_chain_service_closing_outspend(channel.clone())
            .await;
        let maybe_outspend: Option<Outspend> = match maybe_outspend_res {
            Ok(s) => s,
            Err(e) => {
                error!("Failed to lookup channel closing data: {:?}", e);
                None
            }
        };

        let maybe_closed_at = maybe_outspend
            .clone()
            .and_then(|outspend| outspend.status)
            .and_then(|s| s.block_time);
        let maybe_closing_txid = maybe_outspend.and_then(|outspend| outspend.txid);

        Ok((maybe_closed_at, maybe_closing_txid))
    }

    async fn closed_channel_to_transaction(
        &self,
        channel: crate::models::Channel,
    ) -> Result<Payment> {
        let (payment_time, closing_txid) = match (channel.closed_at, channel.closing_txid.clone()) {
            (Some(closed_at), Some(closing_txid)) => (closed_at as i64, Some(closing_txid)),
            (_, _) => {
                // If any of the two closing-related fields are empty, we look them up and persist them
                let (maybe_closed_at, maybe_closing_txid) =
                    self.lookup_channel_closing_data(&channel).await?;

                let processed_closed_at = match maybe_closed_at {
                    None => {
                        warn!("Blocktime could not be determined for from closing outspend, defaulting closed_at to epoch time");
                        SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs()
                    }
                    Some(block_time) => block_time,
                };

                let mut updated_channel = channel.clone();
                updated_channel.closed_at = Some(processed_closed_at);
                // If no closing txid found, we persist it as None, so it will be looked-up next time
                updated_channel.closing_txid.clone_from(&maybe_closing_txid);
                self.persister.insert_or_update_channel(updated_channel)?;

                (processed_closed_at as i64, maybe_closing_txid)
            }
        };

        Ok(Payment {
            id: channel.funding_txid.clone(),
            payment_type: PaymentType::ClosedChannel,
            payment_time,
            amount_msat: channel.local_balance_msat,
            fee_msat: 0,
            status: match channel.state {
                ChannelState::PendingClose => PaymentStatus::Pending,
                _ => PaymentStatus::Complete,
            },
            description: Some("Closed Channel".to_string()),
            details: PaymentDetails::ClosedChannel {
                data: ClosedChannelPaymentDetails {
                    short_channel_id: channel.short_channel_id,
                    state: channel.state,
                    funding_txid: channel.funding_txid,
                    closing_txid,
                },
            },
            error: None,
            metadata: None,
        })
    }

    /// Register for webhook callbacks at the given `webhook_url`.
    ///
    /// More specifically, it registers for the following types of callbacks:
    /// - a payment is received
    /// - a swap tx is confirmed
    ///
    /// This method should be called every time the application is started and when the `webhook_url` changes.
    /// For example, if the `webhook_url` contains a push notification token and the token changes after
    /// the application was started, then this method should be called to register for callbacks at
    /// the new correct `webhook_url`. To unregister a webhook call [BreezServices::unregister_webhook].
    pub async fn register_webhook(&self, webhook_url: String) -> SdkResult<()> {
        info!("Registering for webhook notifications");
        let is_new_webhook_url = match self.persister.get_webhook_url()? {
            None => true,
            Some(cached_webhook_url) => cached_webhook_url != webhook_url,
        };
        match is_new_webhook_url {
            false => debug!("Webhook URL not changed, no need to (re-)register for monitored swap tx notifications"),
            true => {
                for swap in self
                    .btc_receive_swapper
                    .list_monitored()?
                    .iter()
                    .filter(|swap| !swap.refundable())
                {
                    let swap_address = &swap.bitcoin_address;
                    info!("Found non-refundable monitored swap with address {swap_address}, registering for onchain tx notifications");
                    self.register_onchain_tx_notification(swap_address, &webhook_url)
                        .await?;
                }

                for rev_swap in self
                    .btc_send_swapper
                    .list_monitored()
                    .await?
                    .iter()
                {
                    let lockup_address = &rev_swap.get_lockup_address(self.config.network)?.to_string();
                    info!("Found monitored reverse swap with address {lockup_address}, registering for onchain tx notifications");
                    self.register_onchain_tx_notification(lockup_address, &webhook_url)
                        .await?;
                }
            }
        }

        // Register for LN payment notifications on every call, since these webhook registrations
        // timeout after 14 days of not being used
        self.register_payment_notifications(webhook_url.clone())
            .await?;

        // Only cache the webhook URL if callbacks were successfully registered for it.
        // If any step above failed, not caching it allows the caller to re-trigger the registrations
        // by calling the method again
        self.persister.set_webhook_url(webhook_url)?;
        Ok(())
    }

    /// Unregister webhook callbacks for the given `webhook_url`.
    ///
    /// When called, it unregisters for the following types of callbacks:
    /// - a payment is received
    /// - a swap tx is confirmed
    ///
    /// This can be called when callbacks are no longer needed or the `webhook_url`
    /// has changed such that it needs unregistering. For example, the token is valid but the locale changes.
    /// To register a webhook call [BreezServices::register_webhook].
    pub async fn unregister_webhook(&self, webhook_url: String) -> SdkResult<()> {
        info!("Unregistering for webhook notifications");
        self.unregister_onchain_tx_notifications(&webhook_url)
            .await?;
        self.unregister_payment_notifications(webhook_url).await?;
        self.persister.remove_webhook_url()?;
        Ok(())
    }

    /// Registers for lightning payment notifications. When a payment is intercepted by the LSP
    /// to this node, a callback will be triggered to the `webhook_url`.
    ///
    /// Note: these notifications are registered for all LSPs (active and historical) with whom
    /// we have a channel.
    async fn register_payment_notifications(&self, webhook_url: String) -> SdkResult<()> {
        let message = webhook_url.clone();
        let sign_request = SignMessageRequest { message };
        let sign_response = self.sign_message(sign_request).await?;

        // Attempt register call for all relevant LSPs
        let mut error_found = false;
        for lsp_info in get_notification_lsps(
            self.persister.clone(),
            self.lsp_api.clone(),
            self.node_api.clone(),
        )
        .await?
        {
            let lsp_id = lsp_info.id;
            let res = self
                .lsp_api
                .register_payment_notifications(
                    lsp_id.clone(),
                    lsp_info.lsp_pubkey,
                    webhook_url.clone(),
                    sign_response.signature.clone(),
                )
                .await;
            if res.is_err() {
                error_found = true;
                warn!("Failed to register notifications for LSP {lsp_id}: {res:?}");
            }
        }

        match error_found {
            true => Err(SdkError::generic(
                "Failed to register notifications for at least one LSP, see logs for details",
            )),
            false => Ok(()),
        }
    }

    /// Unregisters lightning payment notifications with the current LSP for the `webhook_url`.
    ///
    /// Note: these notifications are unregistered for all LSPs (active and historical) with whom
    /// we have a channel.
    async fn unregister_payment_notifications(&self, webhook_url: String) -> SdkResult<()> {
        let message = webhook_url.clone();
        let sign_request = SignMessageRequest { message };
        let sign_response = self.sign_message(sign_request).await?;

        // Attempt register call for all relevant LSPs
        let mut error_found = false;
        for lsp_info in get_notification_lsps(
            self.persister.clone(),
            self.lsp_api.clone(),
            self.node_api.clone(),
        )
        .await?
        {
            let lsp_id = lsp_info.id;
            let res = self
                .lsp_api
                .unregister_payment_notifications(
                    lsp_id.clone(),
                    lsp_info.lsp_pubkey,
                    webhook_url.clone(),
                    sign_response.signature.clone(),
                )
                .await;
            if res.is_err() {
                error_found = true;
                warn!("Failed to un-register notifications for LSP {lsp_id}: {res:?}");
            }
        }

        match error_found {
            true => Err(SdkError::generic(
                "Failed to un-register notifications for at least one LSP, see logs for details",
            )),
            false => Ok(()),
        }
    }

    /// Registers for a onchain tx notification. When a new transaction to the specified `address`
    /// is confirmed, a callback will be triggered to the `webhook_url`.
    async fn register_onchain_tx_notification(
        &self,
        address: &str,
        webhook_url: &str,
    ) -> SdkResult<()> {
        get_reqwest_client()?
            .post(format!("{}/api/v1/register", self.config.chainnotifier_url))
            .header(CONTENT_TYPE, "application/json")
            .body(Body::from(
                json!({
                    "address": address,
                    "webhook": webhook_url
                })
                .to_string(),
            ))
            .send()
            .await
            .map(|_| ())
            .map_err(|e| SdkError::ServiceConnectivity {
                err: format!("Failed to register for tx confirmation notifications: {e}"),
            })
    }

    /// Unregisters all onchain tx notifications for the `webhook_url`.
    async fn unregister_onchain_tx_notifications(&self, webhook_url: &str) -> SdkResult<()> {
        get_reqwest_client()?
            .post(format!(
                "{}/api/v1/unregister",
                self.config.chainnotifier_url
            ))
            .header(CONTENT_TYPE, "application/json")
            .body(Body::from(
                json!({
                    "webhook": webhook_url
                })
                .to_string(),
            ))
            .send()
            .await
            .map(|_| ())
            .map_err(|e| SdkError::ServiceConnectivity {
                err: format!("Failed to unregister for tx confirmation notifications: {e}"),
            })
    }

    async fn generate_sdk_diagnostic_data(&self) -> SdkResult<String> {
        let state: String = serde_json::to_string_pretty(&self.persister.get_node_state()?)?;
        let payments = serde_json::to_string_pretty(
            &self
                .persister
                .list_payments(ListPaymentsRequest::default())?,
        )?;
        let channels = serde_json::to_string_pretty(&self.persister.list_channels()?)?;
        let settings = serde_json::to_string_pretty(&self.persister.list_settings()?)?;
        let reverse_swaps = serde_json::to_string_pretty(&self.persister.list_reverse_swaps()?)?;
        let swaps = serde_json::to_string_pretty(&self.persister.list_swaps()?)?;
        let lsp_id = serde_json::to_string_pretty(&self.persister.get_lsp_id()?)?;

        let res = format!(
            "\
          ***Node State***\n{state}\n\n \
          ***Payments***\n{payments}\n\n \
          ***Channels***\n{channels}\n\n \
          ***Settings***\n{settings}\n\n \
          ***Reverse Swaps***\n{reverse_swaps}\n\n \
          ***LSP ID***\n{lsp_id}\n\n \
          ***Swaps***\n{swaps}\n\n"
        );
        Ok(res)
    }
}

struct GlobalSdkLogger {
    /// SDK internal logger, which logs to file
    logger: env_logger::Logger,
    /// Optional external log listener, that can receive a stream of log statements
    log_listener: Option<Box<dyn log::Log>>,
}
impl log::Log for GlobalSdkLogger {
    fn enabled(&self, metadata: &Metadata) -> bool {
        metadata.level() <= log::Level::Trace
    }

    fn log(&self, record: &Record) {
        if self.enabled(record.metadata()) {
            self.logger.log(record);

            if let Some(s) = &self.log_listener.as_ref() {
                if s.enabled(record.metadata()) {
                    s.log(record);
                }
            }
        }
    }

    fn flush(&self) {}
}

/// A helper struct to configure and build BreezServices
struct BreezServicesBuilder {
    config: Config,
    node_api: Option<Arc<dyn NodeAPI>>,
    backup_transport: Option<Arc<dyn BackupTransport>>,
    seed: Option<Vec<u8>>,
    lsp_api: Option<Arc<dyn LspAPI>>,
    fiat_api: Option<Arc<dyn FiatAPI>>,
    persister: Option<Arc<SqliteStorage>>,
    support_api: Option<Arc<dyn SupportAPI>>,
    swapper_api: Option<Arc<dyn SwapperAPI>>,
    /// Reverse swap functionality on the Breez Server
    reverse_swapper_api: Option<Arc<dyn ReverseSwapperRoutingAPI>>,
    /// Reverse swap functionality on the 3rd party reverse swap service
    reverse_swap_service_api: Option<Arc<dyn ReverseSwapServiceAPI>>,
    buy_bitcoin_api: Option<Arc<dyn BuyBitcoinApi>>,
}

#[allow(dead_code)]
impl BreezServicesBuilder {
    pub fn new(config: Config) -> BreezServicesBuilder {
        BreezServicesBuilder {
            config,
            node_api: None,
            seed: None,
            lsp_api: None,
            fiat_api: None,
            persister: None,
            support_api: None,
            swapper_api: None,
            reverse_swapper_api: None,
            reverse_swap_service_api: None,
            buy_bitcoin_api: None,
            backup_transport: None,
        }
    }

    pub fn node_api(&mut self, node_api: Arc<dyn NodeAPI>) -> &mut Self {
        self.node_api = Some(node_api);
        self
    }

    pub fn lsp_api(&mut self, lsp_api: Arc<dyn LspAPI>) -> &mut Self {
        self.lsp_api = Some(lsp_api.clone());
        self
    }

    pub fn fiat_api(&mut self, fiat_api: Arc<dyn FiatAPI>) -> &mut Self {
        self.fiat_api = Some(fiat_api.clone());
        self
    }

    pub fn buy_bitcoin_api(&mut self, buy_bitcoin_api: Arc<dyn BuyBitcoinApi>) -> &mut Self {
        self.buy_bitcoin_api = Some(buy_bitcoin_api.clone());
        self
    }

    pub fn persister(&mut self, persister: Arc<SqliteStorage>) -> &mut Self {
        self.persister = Some(persister);
        self
    }

    pub fn support_api(&mut self, support_api: Arc<dyn SupportAPI>) -> &mut Self {
        self.support_api = Some(support_api.clone());
        self
    }

    pub fn swapper_api(&mut self, swapper_api: Arc<dyn SwapperAPI>) -> &mut Self {
        self.swapper_api = Some(swapper_api.clone());
        self
    }

    pub fn reverse_swapper_api(
        &mut self,
        reverse_swapper_api: Arc<dyn ReverseSwapperRoutingAPI>,
    ) -> &mut Self {
        self.reverse_swapper_api = Some(reverse_swapper_api.clone());
        self
    }

    pub fn reverse_swap_service_api(
        &mut self,
        reverse_swap_service_api: Arc<dyn ReverseSwapServiceAPI>,
    ) -> &mut Self {
        self.reverse_swap_service_api = Some(reverse_swap_service_api.clone());
        self
    }

    pub fn backup_transport(&mut self, backup_transport: Arc<dyn BackupTransport>) -> &mut Self {
        self.backup_transport = Some(backup_transport.clone());
        self
    }

    pub fn seed(&mut self, seed: Vec<u8>) -> &mut Self {
        self.seed = Some(seed);
        self
    }

    pub async fn build(
        &self,
        restore_only: Option<bool>,
        event_listener: Option<Box<dyn EventListener>>,
    ) -> BreezServicesResult<Arc<BreezServices>> {
        if self.node_api.is_none() && self.seed.is_none() {
            return Err(ConnectError::Generic {
                err: "Either node_api or both credentials and seed should be provided".into(),
            });
        }

        // The storage is implemented via sqlite.
        let persister = self
            .persister
            .clone()
            .unwrap_or_else(|| Arc::new(SqliteStorage::new(self.config.working_dir.clone())));
        persister.init()?;

        let mut node_api = self.node_api.clone();
        let mut backup_transport = self.backup_transport.clone();
        if node_api.is_none() {
            let greenlight = Greenlight::connect(
                self.config.clone(),
                self.seed.clone().unwrap(),
                restore_only,
                persister.clone(),
            )
            .await?;
            let gl_arc = Arc::new(greenlight);
            node_api = Some(gl_arc.clone());
            if backup_transport.is_none() {
                backup_transport = Some(Arc::new(GLBackupTransport { inner: gl_arc }));
            }
        }

        if backup_transport.is_none() {
            return Err(ConnectError::Generic {
                err: "State synchronizer should be provided".into(),
            });
        }

        let unwrapped_node_api = node_api.unwrap();
        let unwrapped_backup_transport = backup_transport.unwrap();

        // create the backup encryption key and then the backup watcher
        let backup_encryption_key = unwrapped_node_api.derive_bip32_key(vec![
            ChildNumber::from_hardened_idx(139)?,
            ChildNumber::from(0),
        ])?;

        // We calculate the legacy key as a fallback for the case where the backup is still
        // encrypted with the old key.
        let legacy_backup_encryption_key = unwrapped_node_api.legacy_derive_bip32_key(vec![
            ChildNumber::from_hardened_idx(139)?,
            ChildNumber::from(0),
        ])?;
        let backup_watcher = BackupWatcher::new(
            self.config.clone(),
            unwrapped_backup_transport.clone(),
            persister.clone(),
            backup_encryption_key.to_priv().to_bytes(),
            legacy_backup_encryption_key.to_priv().to_bytes(),
        );

        // breez_server provides both FiatAPI & LspAPI implementations
        let breez_server = Arc::new(
            BreezServer::new(self.config.breezserver.clone(), self.config.api_key.clone())
                .map_err(|e| ConnectError::ServiceConnectivity {
                    err: format!("Failed to create BreezServer: {e}"),
                })?,
        );

        // Ensure breez server connection is established in the background
        let cloned_breez_server = breez_server.clone();
        tokio::spawn(async move {
            if let Err(e) = cloned_breez_server.ping().await {
                error!("Failed to ping breez server: {e}");
            }
        });

        let current_lsp_id = persister.get_lsp_id()?;
        if current_lsp_id.is_none() && self.config.default_lsp_id.is_some() {
            persister.set_lsp_id(self.config.default_lsp_id.clone().unwrap())?;
        }

        let payment_receiver = Arc::new(PaymentReceiver {
            config: self.config.clone(),
            node_api: unwrapped_node_api.clone(),
            lsp: breez_server.clone(),
            persister: persister.clone(),
        });

        // mempool space is used to monitor the chain
        let mempoolspace_urls = match self.config.mempoolspace_url.clone() {
            None => {
                let cached = persister.get_mempoolspace_base_urls()?;
                match cached.len() {
                    // If we have no cached values, or we cached an empty list, fetch new ones
                    0 => {
                        let fresh_urls = breez_server
                            .fetch_mempoolspace_urls()
                            .await
                            .unwrap_or(vec![DEFAULT_MEMPOOL_SPACE_URL.into()]);
                        persister.set_mempoolspace_base_urls(fresh_urls.clone())?;
                        fresh_urls
                    }
                    // If we already have cached values, return those
                    _ => cached,
                }
            }
            Some(mempoolspace_url_from_config) => vec![mempoolspace_url_from_config],
        };
        let chain_service = Arc::new(RedundantChainService::from_base_urls(mempoolspace_urls));

        let btc_receive_swapper = Arc::new(BTCReceiveSwap::new(
            self.config.network.into(),
            unwrapped_node_api.clone(),
            self.swapper_api
                .clone()
                .unwrap_or_else(|| breez_server.clone()),
            persister.clone(),
            chain_service.clone(),
            payment_receiver.clone(),
        ));

        let btc_send_swapper = Arc::new(BTCSendSwap::new(
            self.config.clone(),
            self.reverse_swapper_api
                .clone()
                .unwrap_or_else(|| breez_server.clone()),
            self.reverse_swap_service_api
                .clone()
                .unwrap_or_else(|| Arc::new(BoltzApi {})),
            persister.clone(),
            chain_service.clone(),
            unwrapped_node_api.clone(),
        ));

        // create a shutdown channel (sender and receiver)
        let (shutdown_sender, shutdown_receiver) = watch::channel::<()>(());

        let buy_bitcoin_api = self
            .buy_bitcoin_api
            .clone()
            .unwrap_or_else(|| Arc::new(BuyBitcoinService::new(breez_server.clone())));

        // Create the node services and it them statically
        let breez_services = Arc::new(BreezServices {
            config: self.config.clone(),
            started: Mutex::new(false),
            node_api: unwrapped_node_api.clone(),
            lsp_api: self.lsp_api.clone().unwrap_or_else(|| breez_server.clone()),
            fiat_api: self
                .fiat_api
                .clone()
                .unwrap_or_else(|| breez_server.clone()),
            support_api: self
                .support_api
                .clone()
                .unwrap_or_else(|| breez_server.clone()),
            buy_bitcoin_api,
            chain_service,
            persister: persister.clone(),
            btc_receive_swapper,
            btc_send_swapper,
            payment_receiver,
            event_listener,
            backup_watcher: Arc::new(backup_watcher),
            shutdown_sender,
            shutdown_receiver,
        });

        Ok(breez_services)
    }
}

/// Attempts to convert the phrase to a mnemonic, then to a seed.
///
/// If the phrase is not a valid mnemonic, an error is returned.
pub fn mnemonic_to_seed(phrase: String) -> Result<Vec<u8>> {
    let mnemonic = Mnemonic::from_phrase(&phrase, Language::English)?;
    let seed = Seed::new(&mnemonic, "");
    Ok(seed.as_bytes().to_vec())
}

pub struct OpenChannelParams {
    pub payer_amount_msat: u64,
    pub opening_fee_params: models::OpeningFeeParams,
}

#[tonic::async_trait]
pub trait Receiver: Send + Sync {
    async fn receive_payment(
        &self,
        req: ReceivePaymentRequest,
    ) -> Result<ReceivePaymentResponse, ReceivePaymentError>;
    async fn wrap_node_invoice(
        &self,
        invoice: &str,
        params: Option<OpenChannelParams>,
        lsp_info: Option<LspInformation>,
    ) -> Result<String, ReceivePaymentError>;
}

pub(crate) struct PaymentReceiver {
    config: Config,
    node_api: Arc<dyn NodeAPI>,
    lsp: Arc<dyn LspAPI>,
    persister: Arc<SqliteStorage>,
}

#[tonic::async_trait]
impl Receiver for PaymentReceiver {
    async fn receive_payment(
        &self,
        req: ReceivePaymentRequest,
    ) -> Result<ReceivePaymentResponse, ReceivePaymentError> {
        self.node_api.start().await?;
        let lsp_info = get_lsp(self.persister.clone(), self.lsp.clone()).await?;
        let node_state = self
            .persister
            .get_node_state()?
            .ok_or(ReceivePaymentError::Generic {
                err: "Node info not found".into(),
            })?;
        let expiry = req.expiry.unwrap_or(INVOICE_PAYMENT_FEE_EXPIRY_SECONDS);

        ensure_sdk!(
            req.amount_msat > 0,
            ReceivePaymentError::InvalidAmount {
                err: "Receive amount must be more than 0".into()
            }
        );

        let mut destination_invoice_amount_msat = req.amount_msat;
        let mut channel_opening_fee_params = None;
        let mut channel_fees_msat = None;

        // check if we need to open channel
        let open_channel_needed =
            node_state.max_receivable_single_payment_amount_msat < req.amount_msat;
        if open_channel_needed {
            info!("We need to open a channel");

            // we need to open channel so we are calculating the fees for the LSP (coming either from the user, or from the LSP)
            let ofp = match req.opening_fee_params {
                Some(fee_params) => fee_params,
                None => lsp_info.cheapest_open_channel_fee(expiry)?.clone(),
            };

            channel_opening_fee_params = Some(ofp.clone());
            channel_fees_msat = Some(ofp.get_channel_fees_msat_for(req.amount_msat));
            if let Some(channel_fees_msat) = channel_fees_msat {
                info!("zero-conf fee calculation option: lsp fee rate (proportional): {}:  (minimum {}), total fees for channel: {}",
                    ofp.proportional, ofp.min_msat, channel_fees_msat);

                if req.amount_msat < channel_fees_msat + 1000 {
                    return Err(
                        ReceivePaymentError::InvalidAmount{err: format!(
                           "Amount should be more than the minimum fees {channel_fees_msat} msat, but is {} msat",
                            req.amount_msat
                        )}
                    );
                }
                // remove the fees from the amount to get the small amount on the current node invoice.
                destination_invoice_amount_msat = req.amount_msat - channel_fees_msat;
            }
        }

        info!("Creating invoice on NodeAPI");
        let invoice = self
            .node_api
            .create_invoice(CreateInvoiceRequest {
                amount_msat: destination_invoice_amount_msat,
                description: req.description,
                payer_amount_msat: match open_channel_needed {
                    true => Some(req.amount_msat),
                    false => None,
                },
                preimage: req.preimage,
                use_description_hash: req.use_description_hash,
                expiry: Some(expiry),
                cltv: Some(req.cltv.unwrap_or(144)),
            })
            .await?;
        info!("Invoice created {}", invoice);

        let open_channel_params = match open_channel_needed {
            true => Some(OpenChannelParams {
                payer_amount_msat: req.amount_msat,
                opening_fee_params: channel_opening_fee_params.clone().ok_or(
                    ReceivePaymentError::Generic {
                        err: "We need to open a channel, but no channel opening fee params found"
                            .into(),
                    },
                )?,
            }),
            false => None,
        };

        let invoice = self
            .wrap_node_invoice(&invoice, open_channel_params, Some(lsp_info))
            .await?;
        let parsed_invoice = parse_invoice(&invoice)?;

        // return the signed, converted invoice with hints
        Ok(ReceivePaymentResponse {
            ln_invoice: parsed_invoice,
            opening_fee_params: channel_opening_fee_params,
            opening_fee_msat: channel_fees_msat,
        })
    }

    async fn wrap_node_invoice(
        &self,
        invoice: &str,
        params: Option<OpenChannelParams>,
        lsp_info: Option<LspInformation>,
    ) -> Result<String, ReceivePaymentError> {
        let lsp_info = match lsp_info {
            Some(lsp_info) => lsp_info,
            None => get_lsp(self.persister.clone(), self.lsp.clone()).await?,
        };

        match params {
            Some(params) => {
                self.wrap_open_channel_invoice(invoice, params, &lsp_info)
                    .await
            }
            None => self.ensure_hint(invoice, &lsp_info).await,
        }
    }
}

impl PaymentReceiver {
    async fn ensure_hint(
        &self,
        invoice: &str,
        lsp_info: &LspInformation,
    ) -> Result<String, ReceivePaymentError> {
        info!("Getting routing hints from node");
        let (mut hints, has_public_channel) = self.node_api.get_routing_hints(lsp_info).await?;
        if !has_public_channel && hints.is_empty() {
            return Err(ReceivePaymentError::InvoiceNoRoutingHints {
                err: "Must have at least one active channel".into(),
            });
        }

        let parsed_invoice = parse_invoice(invoice)?;

        // check if the lsp hint already exists
        info!("Existing routing hints {:?}", parsed_invoice.routing_hints);

        // limit the hints to max 3 and extract the lsp one.
        if let Some(lsp_hint) = Self::limit_and_extract_lsp_hint(&mut hints, lsp_info) {
            if parsed_invoice.contains_hint_for_node(lsp_info.pubkey.as_str()) {
                return Ok(String::from(invoice));
            }

            info!("Adding lsp hint: {:?}", lsp_hint);
            let modified =
                add_routing_hints(invoice, true, &vec![lsp_hint], parsed_invoice.amount_msat)?;

            let invoice = self.node_api.sign_invoice(modified)?;
            info!("Signed invoice with hint = {}", invoice);
            return Ok(invoice);
        }

        if parsed_invoice.routing_hints.is_empty() {
            info!("Adding custom hints: {:?}", hints);
            let modified = add_routing_hints(invoice, false, &hints, parsed_invoice.amount_msat)?;
            let invoice = self.node_api.sign_invoice(modified)?;
            info!("Signed invoice with hints = {}", invoice);
            return Ok(invoice);
        }

        Ok(String::from(invoice))
    }

    async fn wrap_open_channel_invoice(
        &self,
        invoice: &str,
        params: OpenChannelParams,
        lsp_info: &LspInformation,
    ) -> Result<String, ReceivePaymentError> {
        let parsed_invoice = parse_invoice(invoice)?;
        let open_channel_hint = RouteHint {
            hops: vec![RouteHintHop {
                src_node_id: lsp_info.pubkey.clone(),
                short_channel_id: parse_short_channel_id("1x0x0")?,
                fees_base_msat: lsp_info.base_fee_msat as u32,
                fees_proportional_millionths: (lsp_info.fee_rate * 1000000.0) as u32,
                cltv_expiry_delta: lsp_info.time_lock_delta as u64,
                htlc_minimum_msat: Some(lsp_info.min_htlc_msat as u64),
                htlc_maximum_msat: None,
            }],
        };
        info!("Adding open channel hint: {:?}", open_channel_hint);
        let invoice_with_hint = add_routing_hints(
            invoice,
            false,
            &vec![open_channel_hint],
            Some(params.payer_amount_msat),
        )?;
        let signed_invoice = self.node_api.sign_invoice(invoice_with_hint)?;

        info!("Registering payment with LSP");
        let api_key = self.config.api_key.clone().unwrap_or_default();
        let api_key_hash = sha256::Hash::hash(api_key.as_bytes()).to_hex();

        self.lsp
            .register_payment(
                lsp_info.id.clone(),
                lsp_info.lsp_pubkey.clone(),
                grpc::PaymentInformation {
                    payment_hash: hex::decode(parsed_invoice.payment_hash.clone())
                        .map_err(|e| anyhow!("Failed to decode hex payment hash: {e}"))?,
                    payment_secret: parsed_invoice.payment_secret.clone(),
                    destination: hex::decode(parsed_invoice.payee_pubkey.clone())
                        .map_err(|e| anyhow!("Failed to decode hex payee pubkey: {e}"))?,
                    incoming_amount_msat: params.payer_amount_msat as i64,
                    outgoing_amount_msat: parsed_invoice
                        .amount_msat
                        .ok_or(anyhow!("Open channel invoice must have an amount"))?
                        as i64,
                    tag: json!({ "apiKeyHash": api_key_hash }).to_string(),
                    opening_fee_params: Some(params.opening_fee_params.into()),
                },
            )
            .await?;
        // Make sure we save the large amount so we can deduce the fees later.
        self.persister.insert_open_channel_payment_info(
            &parsed_invoice.payment_hash,
            params.payer_amount_msat,
            invoice,
        )?;

        Ok(signed_invoice)
    }

    fn limit_and_extract_lsp_hint(
        routing_hints: &mut Vec<RouteHint>,
        lsp_info: &LspInformation,
    ) -> Option<RouteHint> {
        let mut lsp_hint: Option<RouteHint> = None;
        if let Some(lsp_index) = routing_hints.iter().position(|r| {
            r.hops
                .iter()
                .any(|h| h.src_node_id == lsp_info.pubkey.clone())
        }) {
            lsp_hint = Some(routing_hints.remove(lsp_index));
        }
        if routing_hints.len() > 3 {
            routing_hints.drain(3..);
        }
        lsp_hint
    }
}

/// Convenience method to look up LSP info based on current LSP ID
async fn get_lsp(
    persister: Arc<SqliteStorage>,
    lsp_api: Arc<dyn LspAPI>,
) -> SdkResult<LspInformation> {
    let lsp_id = persister
        .get_lsp_id()?
        .ok_or(SdkError::generic("No LSP ID found"))?;

    get_lsp_by_id(persister, lsp_api, lsp_id.as_str())
        .await?
        .ok_or_else(|| SdkError::Generic {
            err: format!("No LSP found for id {lsp_id}"),
        })
}

async fn get_lsp_by_id(
    persister: Arc<SqliteStorage>,
    lsp_api: Arc<dyn LspAPI>,
    lsp_id: &str,
) -> SdkResult<Option<LspInformation>> {
    let node_pubkey = persister
        .get_node_state()?
        .ok_or(SdkError::generic("Node info not found"))?
        .id;

    Ok(lsp_api
        .list_lsps(node_pubkey)
        .await?
        .iter()
        .find(|&lsp| lsp.id.as_str() == lsp_id)
        .cloned())
}

/// Convenience method to get all LSPs (active and historical) relevant for registering or
/// unregistering webhook notifications
async fn get_notification_lsps(
    persister: Arc<SqliteStorage>,
    lsp_api: Arc<dyn LspAPI>,
    node_api: Arc<dyn NodeAPI>,
) -> SdkResult<Vec<LspInformation>> {
    let node_pubkey = persister
        .get_node_state()?
        .ok_or(SdkError::generic("Node info not found"))?
        .id;
    let open_peers = node_api.get_open_peers().await?;

    let mut notification_lsps = vec![];
    for lsp in lsp_api.list_used_lsps(node_pubkey).await? {
        match !lsp.opening_fee_params_list.values.is_empty() {
            true => {
                // Non-empty fee params list = this is the active LSP
                // Always consider the active LSP for notifications
                notification_lsps.push(lsp);
            }
            false => {
                // Consider only historical LSPs with whom we have an active channel
                let lsp_pubkey = hex::decode(&lsp.pubkey)
                    .map_err(|e| anyhow!("Failed decode lsp pubkey: {e}"))?;
                let has_active_channel_to_lsp = open_peers.contains(&lsp_pubkey);
                if has_active_channel_to_lsp {
                    notification_lsps.push(lsp);
                }
            }
        }
    }
    Ok(notification_lsps)
}

#[cfg(test)]
pub(crate) mod tests {
    use std::collections::HashMap;
    use std::sync::Arc;

    use anyhow::{anyhow, Result};
    use regex::Regex;
    use reqwest::Url;
    use sdk_common::prelude::Rate;

    use crate::breez_services::{BreezServices, BreezServicesBuilder};
    use crate::models::{LnPaymentDetails, NodeState, Payment, PaymentDetails, PaymentTypeFilter};
    use crate::node_api::NodeAPI;
    use crate::test_utils::*;
    use crate::*;

    use super::{PaymentReceiver, Receiver};

    #[tokio::test]
    async fn test_node_state() -> Result<()> {
        // let storage_path = format!("{}/storage.sql", get_test_working_dir());
        // std::fs::remove_file(storage_path).ok();

        let dummy_node_state = get_dummy_node_state();

        let lnurl_metadata = "{'key': 'sample-metadata-val'}";
        let test_ln_address = "test@ln-address.com";
        let test_lnurl_withdraw_endpoint = "https://test.endpoint.lnurl-w";
        let sa = SuccessActionProcessed::Message {
            data: MessageSuccessActionData {
                message: "test message".into(),
            },
        };

        let payment_hash_lnurl_withdraw = "2222";
        let payment_hash_with_lnurl_success_action = "3333";
        let payment_hash_swap: Vec<u8> = vec![1, 2, 3, 4, 5, 6, 7, 8];
        let swap_info = SwapInfo {
            bitcoin_address: "123".to_string(),
            created_at: 12345678,
            lock_height: 654321,
            payment_hash: payment_hash_swap.clone(),
            preimage: vec![],
            private_key: vec![],
            public_key: vec![],
            swapper_public_key: vec![],
            script: vec![],
            bolt11: Some("312".into()),
            paid_msat: 1000,
            confirmed_sats: 1,
            unconfirmed_sats: 0,
            total_incoming_txs: 1,
            status: SwapStatus::Refundable,
            refund_tx_ids: vec![],
            unconfirmed_tx_ids: vec![],
            confirmed_tx_ids: vec![],
            min_allowed_deposit: 5_000,
            max_allowed_deposit: 1_000_000,
            max_swapper_payable: 2_000_000,
            last_redeem_error: None,
            channel_opening_fees: Some(OpeningFeeParams {
                min_msat: 5_000_000,
                proportional: 50,
                valid_until: "date".to_string(),
                max_idle_time: 12345,
                max_client_to_self_delay: 234,
                promise: "promise".to_string(),
            }),
            confirmed_at: Some(555),
        };
        let payment_hash_rev_swap: Vec<u8> = vec![8, 7, 6, 5, 4, 3, 2, 1];
        let preimage_rev_swap: Vec<u8> = vec![6, 6, 6, 6];
        let full_ref_swap_info = FullReverseSwapInfo {
            id: "rev_swap_id".to_string(),
            created_at_block_height: 0,
            preimage: preimage_rev_swap.clone(),
            private_key: vec![],
            claim_pubkey: "claim_pubkey".to_string(),
            timeout_block_height: 600_000,
            invoice: "645".to_string(),
            redeem_script: "redeem_script".to_string(),
            onchain_amount_sat: 250,
            sat_per_vbyte: Some(50),
            receive_amount_sat: None,
            cache: ReverseSwapInfoCached {
                status: ReverseSwapStatus::CompletedConfirmed,
                lockup_txid: Some("lockup_txid".to_string()),
                claim_txid: Some("claim_txid".to_string()),
            },
        };
        let rev_swap_info = ReverseSwapInfo {
            id: "rev_swap_id".to_string(),
            claim_pubkey: "claim_pubkey".to_string(),
            lockup_txid: Some("lockup_txid".to_string()),
            claim_txid: Some("claim_txid".to_string()),
            onchain_amount_sat: 250,
            status: ReverseSwapStatus::CompletedConfirmed,
        };
        let dummy_transactions = vec![
            Payment {
                id: "1111".to_string(),
                payment_type: PaymentType::Received,
                payment_time: 100000,
                amount_msat: 10,
                fee_msat: 0,
                status: PaymentStatus::Complete,
                error: None,
                description: Some("test receive".to_string()),
                details: PaymentDetails::Ln {
                    data: LnPaymentDetails {
                        payment_hash: "1111".to_string(),
                        label: "".to_string(),
                        destination_pubkey: "1111".to_string(),
                        payment_preimage: "2222".to_string(),
                        keysend: false,
                        bolt11: "1111".to_string(),
                        lnurl_success_action: None,
                        lnurl_pay_domain: None,
                        lnurl_pay_comment: None,
                        lnurl_metadata: None,
                        ln_address: None,
                        lnurl_withdraw_endpoint: None,
                        swap_info: None,
                        reverse_swap_info: None,
                        pending_expiration_block: None,
                        open_channel_bolt11: None,
                    },
                },
                metadata: None,
            },
            Payment {
                id: payment_hash_lnurl_withdraw.to_string(),
                payment_type: PaymentType::Received,
                payment_time: 150000,
                amount_msat: 10,
                fee_msat: 0,
                status: PaymentStatus::Complete,
                error: None,
                description: Some("test lnurl-withdraw receive".to_string()),
                details: PaymentDetails::Ln {
                    data: LnPaymentDetails {
                        payment_hash: payment_hash_lnurl_withdraw.to_string(),
                        label: "".to_string(),
                        destination_pubkey: "1111".to_string(),
                        payment_preimage: "3333".to_string(),
                        keysend: false,
                        bolt11: "1111".to_string(),
                        lnurl_success_action: None,
                        lnurl_pay_domain: None,
                        lnurl_pay_comment: None,
                        lnurl_metadata: None,
                        ln_address: None,
                        lnurl_withdraw_endpoint: Some(test_lnurl_withdraw_endpoint.to_string()),
                        swap_info: None,
                        reverse_swap_info: None,
                        pending_expiration_block: None,
                        open_channel_bolt11: None,
                    },
                },
                metadata: None,
            },
            Payment {
                id: payment_hash_with_lnurl_success_action.to_string(),
                payment_type: PaymentType::Sent,
                payment_time: 200000,
                amount_msat: 8,
                fee_msat: 2,
                status: PaymentStatus::Complete,
                error: None,
                description: Some("test payment".to_string()),
                details: PaymentDetails::Ln {
                    data: LnPaymentDetails {
                        payment_hash: payment_hash_with_lnurl_success_action.to_string(),
                        label: "".to_string(),
                        destination_pubkey: "123".to_string(),
                        payment_preimage: "4444".to_string(),
                        keysend: false,
                        bolt11: "123".to_string(),
                        lnurl_success_action: Some(sa.clone()),
                        lnurl_pay_domain: None,
                        lnurl_pay_comment: None,
                        lnurl_metadata: Some(lnurl_metadata.to_string()),
                        ln_address: Some(test_ln_address.to_string()),
                        lnurl_withdraw_endpoint: None,
                        swap_info: None,
                        reverse_swap_info: None,
                        pending_expiration_block: None,
                        open_channel_bolt11: None,
                    },
                },
                metadata: None,
            },
            Payment {
                id: hex::encode(payment_hash_swap.clone()),
                payment_type: PaymentType::Received,
                payment_time: 250000,
                amount_msat: 1_000,
                fee_msat: 0,
                status: PaymentStatus::Complete,
                error: None,
                description: Some("test receive".to_string()),
                details: PaymentDetails::Ln {
                    data: LnPaymentDetails {
                        payment_hash: hex::encode(payment_hash_swap),
                        label: "".to_string(),
                        destination_pubkey: "321".to_string(),
                        payment_preimage: "5555".to_string(),
                        keysend: false,
                        bolt11: "312".to_string(),
                        lnurl_success_action: None,
                        lnurl_pay_domain: None,
                        lnurl_pay_comment: None,
                        lnurl_metadata: None,
                        ln_address: None,
                        lnurl_withdraw_endpoint: None,
                        swap_info: Some(swap_info.clone()),
                        reverse_swap_info: None,
                        pending_expiration_block: None,
                        open_channel_bolt11: None,
                    },
                },
                metadata: None,
            },
            Payment {
                id: hex::encode(payment_hash_rev_swap.clone()),
                payment_type: PaymentType::Sent,
                payment_time: 300000,
                amount_msat: 50_000_000,
                fee_msat: 2_000,
                status: PaymentStatus::Complete,
                error: None,
                description: Some("test send onchain".to_string()),
                details: PaymentDetails::Ln {
                    data: LnPaymentDetails {
                        payment_hash: hex::encode(payment_hash_rev_swap),
                        label: "".to_string(),
                        destination_pubkey: "321".to_string(),
                        payment_preimage: hex::encode(preimage_rev_swap),
                        keysend: false,
                        bolt11: "312".to_string(),
                        lnurl_success_action: None,
                        lnurl_metadata: None,
                        lnurl_pay_domain: None,
                        lnurl_pay_comment: None,
                        ln_address: None,
                        lnurl_withdraw_endpoint: None,
                        swap_info: None,
                        reverse_swap_info: Some(rev_swap_info.clone()),
                        pending_expiration_block: None,
                        open_channel_bolt11: None,
                    },
                },
                metadata: None,
            },
        ];
        let node_api = Arc::new(MockNodeAPI::new(dummy_node_state.clone()));

        let test_config = create_test_config();
        let persister = Arc::new(create_test_persister(test_config.clone()));
        persister.init()?;
        persister.insert_or_update_payments(&dummy_transactions, false)?;
        persister.insert_payment_external_info(
            payment_hash_with_lnurl_success_action,
            PaymentExternalInfo {
                lnurl_pay_success_action: Some(sa.clone()),
                lnurl_pay_domain: None,
                lnurl_pay_comment: None,
                lnurl_metadata: Some(lnurl_metadata.to_string()),
                ln_address: Some(test_ln_address.to_string()),
                lnurl_withdraw_endpoint: None,
                attempted_amount_msat: None,
                attempted_error: None,
            },
        )?;
        persister.insert_payment_external_info(
            payment_hash_lnurl_withdraw,
            PaymentExternalInfo {
                lnurl_pay_success_action: None,
                lnurl_pay_domain: None,
                lnurl_pay_comment: None,
                lnurl_metadata: None,
                ln_address: None,
                lnurl_withdraw_endpoint: Some(test_lnurl_withdraw_endpoint.to_string()),
                attempted_amount_msat: None,
                attempted_error: None,
            },
        )?;
        persister.insert_swap(swap_info.clone())?;
        persister.update_swap_bolt11(
            swap_info.bitcoin_address.clone(),
            swap_info.bolt11.clone().unwrap(),
        )?;
        persister.insert_reverse_swap(&full_ref_swap_info)?;
        persister
            .update_reverse_swap_status("rev_swap_id", &ReverseSwapStatus::CompletedConfirmed)?;
        persister
            .update_reverse_swap_lockup_txid("rev_swap_id", Some("lockup_txid".to_string()))?;
        persister.update_reverse_swap_claim_txid("rev_swap_id", Some("claim_txid".to_string()))?;

        let mut builder = BreezServicesBuilder::new(test_config.clone());
        let breez_services = builder
            .lsp_api(Arc::new(MockBreezServer {}))
            .fiat_api(Arc::new(MockBreezServer {}))
            .node_api(node_api)
            .persister(persister)
            .backup_transport(Arc::new(MockBackupTransport::new()))
            .build(None, None)
            .await?;

        breez_services.sync().await?;
        let fetched_state = breez_services.node_info()?;
        assert_eq!(fetched_state, dummy_node_state);

        let all = breez_services
            .list_payments(ListPaymentsRequest::default())
            .await?;
        let mut cloned = all.clone();

        // test the right order
        cloned.reverse();
        assert_eq!(dummy_transactions, cloned);

        let received = breez_services
            .list_payments(ListPaymentsRequest {
                filters: Some(vec![PaymentTypeFilter::Received]),
                ..Default::default()
            })
            .await?;
        assert_eq!(
            received,
            vec![cloned[3].clone(), cloned[1].clone(), cloned[0].clone()]
        );

        let sent = breez_services
            .list_payments(ListPaymentsRequest {
                filters: Some(vec![
                    PaymentTypeFilter::Sent,
                    PaymentTypeFilter::ClosedChannel,
                ]),
                ..Default::default()
            })
            .await?;
        assert_eq!(sent, vec![cloned[4].clone(), cloned[2].clone()]);
        assert!(matches!(
                &sent[1].details,
                PaymentDetails::Ln {data: LnPaymentDetails {lnurl_success_action, ..}}
                if lnurl_success_action == &Some(sa)));
        assert!(matches!(
                &sent[1].details,
                PaymentDetails::Ln {data: LnPaymentDetails {lnurl_pay_domain, ln_address, ..}}
                if lnurl_pay_domain.is_none() && ln_address == &Some(test_ln_address.to_string())));
        assert!(matches!(
                &received[1].details,
                PaymentDetails::Ln {data: LnPaymentDetails {lnurl_withdraw_endpoint, ..}}
                if lnurl_withdraw_endpoint == &Some(test_lnurl_withdraw_endpoint.to_string())));
        assert!(matches!(
                &received[0].details,
                PaymentDetails::Ln {data: LnPaymentDetails {swap_info: swap, ..}}
                if swap == &Some(swap_info)));
        assert!(matches!(
                &sent[0].details,
                PaymentDetails::Ln {data: LnPaymentDetails {reverse_swap_info: rev_swap, ..}}
                if rev_swap == &Some(rev_swap_info)));

        Ok(())
    }

    #[tokio::test]
    async fn test_receive_with_open_channel() -> Result<()> {
        let config = create_test_config();
        let persister = Arc::new(create_test_persister(config.clone()));
        persister.init().unwrap();

        let dummy_node_state = get_dummy_node_state();

        let node_api = Arc::new(MockNodeAPI::new(dummy_node_state.clone()));

        let breez_server = Arc::new(MockBreezServer {});
        persister.set_lsp_id(breez_server.lsp_id()).unwrap();
        persister.set_node_state(&dummy_node_state).unwrap();

        let receiver: Arc<dyn Receiver> = Arc::new(PaymentReceiver {
            config,
            node_api,
            persister,
            lsp: breez_server.clone(),
        });
        let ln_invoice = receiver
            .receive_payment(ReceivePaymentRequest {
                amount_msat: 3_000_000,
                description: "should populate lsp hints".to_string(),
                use_description_hash: Some(false),
                ..Default::default()
            })
            .await?
            .ln_invoice;
        assert_eq!(ln_invoice.routing_hints[0].hops.len(), 1);
        let lsp_hop = &ln_invoice.routing_hints[0].hops[0];
        assert_eq!(lsp_hop.src_node_id, breez_server.clone().lsp_pub_key());
        assert_eq!(
            lsp_hop.short_channel_id,
            parse_short_channel_id("1x0x0").unwrap()
        );
        Ok(())
    }

    #[tokio::test]
    async fn test_list_lsps() -> Result<()> {
        let storage_path = format!("{}/storage.sql", get_test_working_dir());
        std::fs::remove_file(storage_path).ok();

        let breez_services = breez_services()
            .await
            .map_err(|e| anyhow!("Failed to get the BreezServices: {e}"))?;
        breez_services.sync().await?;

        let node_pubkey = breez_services.node_info()?.id;
        let lsps = breez_services.lsp_api.list_lsps(node_pubkey).await?;
        assert_eq!(lsps.len(), 1);

        Ok(())
    }

    #[tokio::test]
    async fn test_fetch_rates() -> Result<(), Box<dyn std::error::Error>> {
        let breez_services = breez_services().await?;
        breez_services.sync().await?;

        let rates = breez_services.fiat_api.fetch_fiat_rates().await?;
        assert_eq!(rates.len(), 1);
        assert_eq!(
            rates[0],
            Rate {
                coin: "USD".to_string(),
                value: 20_000.00,
            }
        );

        Ok(())
    }

    #[tokio::test]
    async fn test_buy_bitcoin_with_moonpay() -> Result<(), Box<dyn std::error::Error>> {
        let breez_services = breez_services().await?;
        breez_services.sync().await?;
        let moonpay_url = breez_services
            .buy_bitcoin(BuyBitcoinRequest {
                provider: BuyBitcoinProvider::Moonpay,
                opening_fee_params: None,
                redirect_url: None,
            })
            .await?
            .url;
        let parsed = Url::parse(&moonpay_url)?;
        let query_pairs = parsed.query_pairs().into_owned().collect::<HashMap<_, _>>();

        assert_eq!(parsed.host_str(), Some("mock.moonpay"));
        assert_eq!(parsed.path(), "/");

        let wallet_address = parse(query_pairs.get("wa").unwrap()).await?;
        assert!(matches!(wallet_address, InputType::BitcoinAddress { .. }));

        let max_amount = query_pairs.get("ma").unwrap();
        assert!(Regex::new(r"^\d+\.\d{8}$").unwrap().is_match(max_amount));

        Ok(())
    }

    /// Build node service for tests
    pub(crate) async fn breez_services() -> Result<Arc<BreezServices>> {
        breez_services_with(None, vec![]).await
    }

    /// Build node service for tests with a list of known payments
    pub(crate) async fn breez_services_with(
        node_api: Option<Arc<dyn NodeAPI>>,
        known_payments: Vec<Payment>,
    ) -> Result<Arc<BreezServices>> {
        let node_api =
            node_api.unwrap_or_else(|| Arc::new(MockNodeAPI::new(get_dummy_node_state())));

        let test_config = create_test_config();
        let persister = Arc::new(create_test_persister(test_config.clone()));
        persister.init()?;
        persister.insert_or_update_payments(&known_payments, false)?;
        persister.set_lsp_id(MockBreezServer {}.lsp_id())?;

        let mut builder = BreezServicesBuilder::new(test_config.clone());
        let breez_services = builder
            .lsp_api(Arc::new(MockBreezServer {}))
            .fiat_api(Arc::new(MockBreezServer {}))
            .reverse_swap_service_api(Arc::new(MockReverseSwapperAPI {}))
            .buy_bitcoin_api(Arc::new(MockBuyBitcoinService {}))
            .persister(persister)
            .node_api(node_api)
            .backup_transport(Arc::new(MockBackupTransport::new()))
            .build(None, None)
            .await?;

        Ok(breez_services)
    }

    /// Build dummy NodeState for tests
    pub(crate) fn get_dummy_node_state() -> NodeState {
        NodeState {
            id: "tx1".to_string(),
            block_height: 1,
            channels_balance_msat: 100,
            onchain_balance_msat: 1_000,
            pending_onchain_balance_msat: 100,
            utxos: vec![],
            max_payable_msat: 95,
            max_receivable_msat: 4_000_000_000,
            max_single_payment_amount_msat: 1_000,
            max_chan_reserve_msats: 0,
            connected_peers: vec!["1111".to_string()],
            max_receivable_single_payment_amount_msat: 2_000,
            total_inbound_liquidity_msats: 10_000,
        }
    }
}
