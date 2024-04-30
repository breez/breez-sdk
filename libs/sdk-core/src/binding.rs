//! Bindings for the Dart integration
//!
//! ### Error handling
//!
//! Since the integration requires the methods to return `anyhow::Result`, but the SDK service methods
//! are being converted to return `SdkResult`, we have two ways to handle errors:
//! - by using `Into::into`, which converts the `SdkError` enum to a generic `anyhow::Error`
//! - by wrapping the `SdkError` in an `anyhow::Error`
//!
//! The first option loses the `SdkError` type. The second option keeps the type, which we can retrieve
//! with `anyhow::Error::downcast_ref` (or equivalent Dart method). We therefore use the second approach.

use std::future::Future;
use std::sync::Arc;

use anyhow::{anyhow, Result};
use flutter_rust_bridge::StreamSink;
use log::{Level, LevelFilter, Metadata, Record};
use once_cell::sync::{Lazy, OnceCell};
use tokio::sync::Mutex;

use crate::breez_services::{self, BreezEvent, BreezServices, EventListener};
use crate::chain::RecommendedFees;
use crate::error::{
    ConnectError, LnUrlAuthError, LnUrlPayError, LnUrlWithdrawError, ReceiveOnchainError,
    ReceivePaymentError, SdkError, SendOnchainError, SendPaymentError,
};
use crate::fiat::{FiatCurrency, Rate};
use crate::input_parser::{self, InputType, LnUrlAuthRequestData};
use crate::invoice::{self, LNInvoice};
use crate::lnurl::pay::model::LnUrlPayResult;
use crate::lsp::LspInformation;
use crate::models::{Config, LogEntry, NodeState, Payment, SwapInfo};
use crate::{
    BackupStatus, BuyBitcoinRequest, BuyBitcoinResponse, CheckMessageRequest, CheckMessageResponse,
    ConfigureNodeRequest, ConnectRequest, EnvironmentType, ListPaymentsRequest,
    LnUrlCallbackStatus, LnUrlPayRequest, LnUrlWithdrawRequest, LnUrlWithdrawResult,
    MaxReverseSwapAmountResponse, NodeConfig, NodeCredentials, OnchainPaymentLimitsResponse,
    OpenChannelFeeRequest, OpenChannelFeeResponse, PayOnchainRequest, PayOnchainResponse,
    PrepareOnchainPaymentRequest, PrepareOnchainPaymentResponse, PrepareRedeemOnchainFundsRequest,
    PrepareRedeemOnchainFundsResponse, PrepareRefundRequest, PrepareRefundResponse,
    ReceiveOnchainRequest, ReceivePaymentRequest, ReceivePaymentResponse,
    RedeemOnchainFundsRequest, RedeemOnchainFundsResponse, RefundRequest, RefundResponse,
    ReportIssueRequest, ReverseSwapFeesRequest, ReverseSwapInfo, ReverseSwapPairInfo,
    SendOnchainRequest, SendOnchainResponse, SendPaymentRequest, SendPaymentResponse,
    SendSpontaneousPaymentRequest, ServiceHealthCheckResponse, SignMessageRequest,
    SignMessageResponse, StaticBackupRequest, StaticBackupResponse,
};

/*
The format Lazy<Mutex<Option<...>>> for the following variables allows them to be instance-global,
meaning they can be set only once per instance, but calling disconnect() will unset them.
 */
static BREEZ_SERVICES_INSTANCE: Lazy<Mutex<Option<Arc<BreezServices>>>> =
    Lazy::new(|| Mutex::new(None));
static NOTIFICATION_STREAM: OnceCell<StreamSink<BreezEvent>> = OnceCell::new();
static RT: Lazy<tokio::runtime::Runtime> = Lazy::new(|| tokio::runtime::Runtime::new().unwrap());
static LOG_INIT: OnceCell<bool> = OnceCell::new();

/*  Breez Services API's */

/// Wrapper around [BreezServices::connect] which also initializes SDK logging
pub fn connect(req: ConnectRequest) -> Result<()> {
    block_on(async move {
        let mut locked = BREEZ_SERVICES_INSTANCE.lock().await;
        match *locked {
            None => {
                let breez_services =
                    BreezServices::connect(req, Box::new(BindingEventListener {})).await?;

                *locked = Some(breez_services);
                Ok(())
            }
            Some(_) => Err(ConnectError::Generic {
                err: "Static node services already set, please call disconnect() first".into(),
            }),
        }
    })
    .map_err(anyhow::Error::new::<ConnectError>)
}

/// Check whether node service is initialized or not
pub fn is_initialized() -> bool {
    block_on(async { get_breez_services().await.is_ok() })
}

/// See [BreezServices::sync]
pub fn sync() -> Result<()> {
    block_on(async { get_breez_services().await?.sync().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::node_credentials]
pub fn node_credentials() -> Result<Option<NodeCredentials>> {
    block_on(async {
        get_breez_services()
            .await?
            .node_credentials()
            .map_err(anyhow::Error::new::<SdkError>)
    })
}

/// See [BreezServices::node_info]
pub fn node_info() -> Result<NodeState> {
    block_on(async {
        get_breez_services()
            .await?
            .node_info()
            .map_err(anyhow::Error::new::<SdkError>)
    })
}

/// See [BreezServices::configure_node]
pub fn configure_node(req: ConfigureNodeRequest) -> Result<()> {
    block_on(async { get_breez_services().await?.configure_node(req).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// Cleanup node resources and stop the signer.
pub fn disconnect() -> Result<()> {
    block_on(async {
        // To avoid deadlock: first disconnect SDK, then acquire lock and unset global instance
        get_breez_services().await?.disconnect().await?;
        let mut locked_sdk_instance = BREEZ_SERVICES_INSTANCE.lock().await;
        *locked_sdk_instance = None;

        Ok(())
    })
    .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::sign_message]
pub fn sign_message(req: SignMessageRequest) -> Result<SignMessageResponse> {
    block_on(async { get_breez_services().await?.sign_message(req).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::check_message]
pub fn check_message(req: CheckMessageRequest) -> Result<CheckMessageResponse> {
    block_on(async { get_breez_services().await?.check_message(req).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/*  Breez Services Helper API's */

/// See [breez_services::mnemonic_to_seed]
pub fn mnemonic_to_seed(phrase: String) -> Result<Vec<u8>> {
    breez_services::mnemonic_to_seed(phrase)
}

/// See [BreezServices::default_config]
pub fn default_config(
    env_type: EnvironmentType,
    api_key: String,
    node_config: NodeConfig,
) -> Config {
    BreezServices::default_config(env_type, api_key, node_config)
}

/// See [BreezServices::static_backup]
pub fn static_backup(req: StaticBackupRequest) -> Result<StaticBackupResponse> {
    BreezServices::static_backup(req).map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::service_health_check]
pub fn service_health_check(api_key: String) -> Result<ServiceHealthCheckResponse> {
    block_on(async { BreezServices::service_health_check(api_key).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/*  Stream API's */

/// If used, this must be called before `connect`. It can only be called once.
pub fn breez_events_stream(s: StreamSink<BreezEvent>) -> Result<()> {
    NOTIFICATION_STREAM
        .set(s)
        .map_err(|_| anyhow!("Events stream already created"))?;
    Ok(())
}

/// If used, this must be called before `connect`. It can only be called once.
pub fn breez_log_stream(s: StreamSink<LogEntry>) -> Result<()> {
    LOG_INIT
        .set(true)
        .map_err(|_| anyhow!("Log stream already created"))?;
    BindingLogger::init(s);
    Ok(())
}

/*  LSP API's */

/// See [BreezServices::list_lsps]
pub fn list_lsps() -> Result<Vec<LspInformation>> {
    block_on(async { get_breez_services().await?.list_lsps().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::connect_lsp]
pub fn connect_lsp(lsp_id: String) -> Result<()> {
    block_on(async { get_breez_services().await?.connect_lsp(lsp_id).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::lsp_id]
pub fn lsp_id() -> Result<Option<String>> {
    block_on(async { get_breez_services().await?.lsp_id().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::fetch_lsp_info]
pub fn fetch_lsp_info(id: String) -> Result<Option<LspInformation>> {
    block_on(async { get_breez_services().await?.fetch_lsp_info(id).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::lsp_info]
pub fn lsp_info() -> Result<LspInformation> {
    block_on(async { get_breez_services().await?.lsp_info(false).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::close_lsp_channels]
pub fn close_lsp_channels() -> Result<()> {
    block_on(async {
        _ = get_breez_services().await?.close_lsp_channels().await?;
        Ok(())
    })
}

pub fn register_webhook(webhook_url: String) -> Result<()> {
    block_on(async {
        get_breez_services()
            .await?
            .register_webhook(webhook_url)
            .await
    })
    .map_err(anyhow::Error::new::<SdkError>)
}

/*  Backup API's */

/// See [BreezServices::backup]
pub fn backup() -> Result<()> {
    block_on(async { get_breez_services().await?.backup().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::backup_status]
pub fn backup_status() -> Result<BackupStatus> {
    block_on(async { get_breez_services().await?.backup_status() })
        .map_err(anyhow::Error::new::<SdkError>)
}

/*  Parse API's */

pub fn parse_invoice(invoice: String) -> Result<LNInvoice> {
    invoice::parse_invoice(&invoice).map_err(|e| anyhow::Error::new::<SdkError>(e.into()))
}

pub fn parse_input(input: String) -> Result<InputType> {
    block_on(async { input_parser::parse(&input).await })
}

/*  Payment API's */

/// See [BreezServices::list_payments]
pub fn list_payments(req: ListPaymentsRequest) -> Result<Vec<Payment>> {
    block_on(async { get_breez_services().await?.list_payments(req).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::list_payments]
pub fn payment_by_hash(hash: String) -> Result<Option<Payment>> {
    block_on(async { get_breez_services().await?.payment_by_hash(hash).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::set_payment_metadata]
pub fn set_payment_metadata(hash: String, metadata: String) -> Result<()> {
    block_on(async {
        get_breez_services()
            .await?
            .set_payment_metadata(hash, metadata)
            .await
    })
    .map_err(anyhow::Error::new::<SdkError>)
}

/*  Lightning Payment API's */

/// See [BreezServices::send_payment]
pub fn send_payment(req: SendPaymentRequest) -> Result<SendPaymentResponse> {
    block_on(async { get_breez_services().await?.send_payment(req).await })
        .map_err(anyhow::Error::new::<SendPaymentError>)
}

/// See [BreezServices::send_spontaneous_payment]
pub fn send_spontaneous_payment(req: SendSpontaneousPaymentRequest) -> Result<SendPaymentResponse> {
    block_on(async {
        get_breez_services()
            .await?
            .send_spontaneous_payment(req)
            .await
    })
    .map_err(anyhow::Error::new::<SendPaymentError>)
}

/// See [BreezServices::receive_payment]
pub fn receive_payment(req: ReceivePaymentRequest) -> Result<ReceivePaymentResponse> {
    block_on(async { get_breez_services().await?.receive_payment(req).await })
        .map_err(anyhow::Error::new::<ReceivePaymentError>)
}

/*  LNURL API's */

/// See [BreezServices::lnurl_pay]
pub fn lnurl_pay(req: LnUrlPayRequest) -> Result<LnUrlPayResult> {
    block_on(async { get_breez_services().await?.lnurl_pay(req).await })
        .map_err(anyhow::Error::new::<LnUrlPayError>)
}

/// See [BreezServices::lnurl_withdraw]
pub fn lnurl_withdraw(req: LnUrlWithdrawRequest) -> Result<LnUrlWithdrawResult> {
    block_on(async { get_breez_services().await?.lnurl_withdraw(req).await })
        .map_err(anyhow::Error::new::<LnUrlWithdrawError>)
}

/// See [BreezServices::lnurl_auth]
pub fn lnurl_auth(req_data: LnUrlAuthRequestData) -> Result<LnUrlCallbackStatus> {
    block_on(async { get_breez_services().await?.lnurl_auth(req_data).await })
        .map_err(anyhow::Error::new::<LnUrlAuthError>)
}

/*  Support API */

/// See [BreezServices::report_issue]
pub fn report_issue(req: ReportIssueRequest) -> Result<()> {
    block_on(async { get_breez_services().await?.report_issue(req).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/*  Fiat Currency API's */

/// See [BreezServices::fetch_fiat_rates]
pub fn fetch_fiat_rates() -> Result<Vec<Rate>> {
    block_on(async { get_breez_services().await?.fetch_fiat_rates().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::list_fiat_currencies]
pub fn list_fiat_currencies() -> Result<Vec<FiatCurrency>> {
    block_on(async { get_breez_services().await?.list_fiat_currencies().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/*  On-Chain Swap API's */

/// See [BreezServices::max_reverse_swap_amount]
pub fn max_reverse_swap_amount() -> Result<MaxReverseSwapAmountResponse> {
    block_on(async { get_breez_services().await?.max_reverse_swap_amount().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::send_onchain]
pub fn send_onchain(req: SendOnchainRequest) -> Result<SendOnchainResponse> {
    block_on(async { get_breez_services().await?.send_onchain(req).await })
        .map_err(anyhow::Error::new::<SendOnchainError>)
}

/// See [BreezServices::pay_onchain]
pub fn pay_onchain(req: PayOnchainRequest) -> Result<PayOnchainResponse> {
    block_on(async { get_breez_services().await?.pay_onchain(req).await })
        .map_err(anyhow::Error::new::<SendOnchainError>)
}

/// See [BreezServices::receive_onchain]
pub fn receive_onchain(req: ReceiveOnchainRequest) -> Result<SwapInfo> {
    block_on(async { get_breez_services().await?.receive_onchain(req).await })
        .map_err(anyhow::Error::new::<ReceiveOnchainError>)
}

/// See [BreezServices::buy_bitcoin]
pub fn buy_bitcoin(req: BuyBitcoinRequest) -> Result<BuyBitcoinResponse> {
    block_on(async { get_breez_services().await?.buy_bitcoin(req).await })
        .map_err(anyhow::Error::new::<ReceiveOnchainError>)
}

/// See [BreezServices::redeem_onchain_funds]
pub fn redeem_onchain_funds(req: RedeemOnchainFundsRequest) -> Result<RedeemOnchainFundsResponse> {
    block_on(async { get_breez_services().await?.redeem_onchain_funds(req).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::prepare_redeem_onchain_funds]
pub fn prepare_redeem_onchain_funds(
    req: PrepareRedeemOnchainFundsRequest,
) -> Result<PrepareRedeemOnchainFundsResponse> {
    block_on(async {
        get_breez_services()
            .await?
            .prepare_redeem_onchain_funds(req)
            .await
    })
    .map_err(anyhow::Error::new::<SdkError>)
}

/*  Refundables API's */

/// See [BreezServices::list_refundables]
pub fn list_refundables() -> Result<Vec<SwapInfo>> {
    block_on(async { get_breez_services().await?.list_refundables().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::prepare_refund]
pub fn prepare_refund(req: PrepareRefundRequest) -> Result<PrepareRefundResponse> {
    block_on(async { get_breez_services().await?.prepare_refund(req).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::refund]
pub fn refund(req: RefundRequest) -> Result<RefundResponse> {
    block_on(async { get_breez_services().await?.refund(req).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::rescan_swaps]
pub fn rescan_swaps() -> Result<()> {
    block_on(async { get_breez_services().await?.rescan_swaps().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::redeem_swap]
pub fn redeem_swap(swap_address: String) -> Result<()> {
    block_on(async { get_breez_services().await?.redeem_swap(swap_address).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/*  In Progress Swap API's */

/// See [BreezServices::in_progress_swap]
pub fn in_progress_swap() -> Result<Option<SwapInfo>> {
    block_on(async { get_breez_services().await?.in_progress_swap().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::in_progress_reverse_swaps]
pub fn in_progress_reverse_swaps() -> Result<Vec<ReverseSwapInfo>> {
    block_on(async {
        get_breez_services()
            .await?
            .in_progress_reverse_swaps()
            .await
    })
    .map_err(anyhow::Error::new::<SdkError>)
}

/*  Swap Fee API's */

/// See [BreezServices::open_channel_fee]
pub fn open_channel_fee(req: OpenChannelFeeRequest) -> Result<OpenChannelFeeResponse> {
    block_on(async { get_breez_services().await?.open_channel_fee(req).await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::fetch_reverse_swap_fees]
pub fn fetch_reverse_swap_fees(req: ReverseSwapFeesRequest) -> Result<ReverseSwapPairInfo> {
    block_on(async {
        get_breez_services()
            .await?
            .fetch_reverse_swap_fees(req)
            .await
    })
    .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::onchain_payment_limits]
pub fn onchain_payment_limits() -> Result<OnchainPaymentLimitsResponse> {
    block_on(async { get_breez_services().await?.onchain_payment_limits().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::prepare_onchain_payment]
pub fn prepare_onchain_payment(
    req: PrepareOnchainPaymentRequest,
) -> Result<PrepareOnchainPaymentResponse> {
    block_on(async {
        get_breez_services()
            .await?
            .prepare_onchain_payment(req)
            .await
            .map_err(anyhow::Error::new::<SendOnchainError>)
    })
}

/// See [BreezServices::in_progress_onchain_payments]
pub fn in_progress_onchain_payments() -> Result<Vec<ReverseSwapInfo>> {
    block_on(async {
        get_breez_services()
            .await?
            .in_progress_onchain_payments()
            .await
    })
    .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::recommended_fees]
pub fn recommended_fees() -> Result<RecommendedFees> {
    block_on(async { get_breez_services().await?.recommended_fees().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/*  CLI API's */

/// See [BreezServices::execute_dev_command]
pub fn execute_command(command: String) -> Result<String> {
    block_on(async {
        get_breez_services()
            .await?
            .execute_dev_command(command)
            .await
    })
    .map_err(anyhow::Error::new::<SdkError>)
}

/// See [BreezServices::generate_diagnostic_data]
pub fn generate_diagnostic_data() -> Result<String> {
    block_on(async { get_breez_services().await?.generate_diagnostic_data().await })
        .map_err(anyhow::Error::new::<SdkError>)
}

/*  Binding Related Logic */

struct BindingEventListener;

impl EventListener for BindingEventListener {
    fn on_event(&self, e: BreezEvent) {
        if let Some(stream) = NOTIFICATION_STREAM.get() {
            stream.add(e);
        }
    }
}

struct BindingLogger {
    log_stream: StreamSink<LogEntry>,
}

impl BindingLogger {
    fn init(log_stream: StreamSink<LogEntry>) {
        let binding_logger = BindingLogger { log_stream };
        log::set_boxed_logger(Box::new(binding_logger)).unwrap();
        log::set_max_level(LevelFilter::Trace);
    }
}

impl log::Log for BindingLogger {
    fn enabled(&self, m: &Metadata) -> bool {
        m.level() <= Level::Trace
    }

    fn log(&self, record: &Record) {
        if self.enabled(record.metadata()) {
            self.log_stream.add(LogEntry {
                line: record.args().to_string(),
                level: record.level().as_str().to_string(),
            });
        }
    }
    fn flush(&self) {}
}

async fn get_breez_services() -> Result<Arc<BreezServices>, SdkError> {
    match BREEZ_SERVICES_INSTANCE.lock().await.as_ref() {
        None => Err(SdkError::Generic {
            err: "Node service was not initialized".into(),
        }),
        Some(sdk) => Ok(sdk.clone()),
    }
}

fn block_on<F: Future>(future: F) -> F::Output {
    rt().block_on(future)
}

pub(crate) fn rt() -> &'static tokio::runtime::Runtime {
    &RT
}
