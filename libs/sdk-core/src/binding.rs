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

use std::sync::Arc;

use crate::frb_generated::StreamSink;
use anyhow::{anyhow, Result};
use log::{Level, LevelFilter, Metadata, Record};
use once_cell::sync::OnceCell;

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

static NOTIFICATION_STREAM: OnceCell<StreamSink<BreezEvent>> = OnceCell::new();
static LOG_INIT: OnceCell<bool> = OnceCell::new();

/// Wrapper around [BreezServices::connect] which also initializes SDK logging
pub async fn connect(req: ConnectRequest) -> Result<BindingBreezServices, ConnectError> {
    let breez_services = BreezServices::connect(req, Box::new(BindingEventListener {})).await?;
    Ok(BindingBreezServices { breez_services })
}

pub struct BindingBreezServices {
    breez_services: Arc<BreezServices>,
}

/*  Breez Services API's */

impl BindingBreezServices {
    /// See [BreezServices::sync]
    pub async fn sync(&self) -> Result<()> {
        self.breez_services
            .sync()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::node_credentials]
    pub fn node_credentials(&self) -> Result<Option<NodeCredentials>> {
        self.breez_services
            .node_credentials()
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::node_info]
    pub fn node_info(&self) -> Result<NodeState> {
        self.breez_services
            .node_info()
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::configure_node]
    pub async fn configure_node(&self, req: ConfigureNodeRequest) -> Result<()> {
        self.breez_services
            .configure_node(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// Cleanup node resources and stop the signer.
    pub async fn disconnect(&self) -> Result<()> {
        self.breez_services
            .disconnect()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::sign_message]
    pub async fn sign_message(&self, req: SignMessageRequest) -> Result<SignMessageResponse> {
        self.breez_services
            .sign_message(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::check_message]
    pub async fn check_message(&self, req: CheckMessageRequest) -> Result<CheckMessageResponse> {
        self.breez_services
            .check_message(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /*  LSP API's */

    /// See [BreezServices::list_lsps]
    pub async fn list_lsps(&self) -> Result<Vec<LspInformation>> {
        self.breez_services
            .list_lsps()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::connect_lsp]
    pub async fn connect_lsp(&self, lsp_id: String) -> Result<()> {
        self.breez_services
            .connect_lsp(lsp_id)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::lsp_id]
    pub async fn lsp_id(&self) -> Result<Option<String>> {
        self.breez_services
            .lsp_id()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::fetch_lsp_info]
    pub async fn fetch_lsp_info(&self, id: String) -> Result<Option<LspInformation>> {
        self.breez_services
            .fetch_lsp_info(id)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::lsp_info]
    pub async fn lsp_info(&self) -> Result<LspInformation> {
        self.breez_services
            .lsp_info()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::close_lsp_channels]
    pub async fn close_lsp_channels(&self) -> Result<()> {
        self.breez_services.close_lsp_channels().await?;
        Ok(())
    }

    pub async fn register_webhook(&self, webhook_url: String) -> Result<()> {
        self.breez_services
            .register_webhook(webhook_url)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    pub async fn unregister_webhook(&self, webhook_url: String) -> Result<()> {
        self.breez_services
            .unregister_webhook(webhook_url)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /*  Backup API's */

    /// See [BreezServices::backup]
    pub async fn backup(&self) -> Result<()> {
        self.breez_services
            .backup()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::backup_status]
    pub fn backup_status(&self) -> Result<BackupStatus> {
        self.breez_services
            .backup_status()
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /*  Payment API's */

    /// See [BreezServices::list_payments]
    pub async fn list_payments(&self, req: ListPaymentsRequest) -> Result<Vec<Payment>> {
        self.breez_services
            .list_payments(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::list_payments]
    pub async fn payment_by_hash(&self, hash: String) -> Result<Option<Payment>> {
        self.breez_services
            .payment_by_hash(hash)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::set_payment_metadata]
    pub async fn set_payment_metadata(&self, hash: String, metadata: String) -> Result<()> {
        self.breez_services
            .set_payment_metadata(hash, metadata)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /*  Lightning Payment API's */

    /// See [BreezServices::send_payment]
    pub async fn send_payment(&self, req: SendPaymentRequest) -> Result<SendPaymentResponse> {
        self.breez_services
            .send_payment(req)
            .await
            .map_err(anyhow::Error::new::<SendPaymentError>)
    }

    /// See [BreezServices::send_spontaneous_payment]
    pub async fn send_spontaneous_payment(
        &self,
        req: SendSpontaneousPaymentRequest,
    ) -> Result<SendPaymentResponse> {
        self.breez_services
            .send_spontaneous_payment(req)
            .await
            .map_err(anyhow::Error::new::<SendPaymentError>)
    }

    /// See [BreezServices::receive_payment]
    pub async fn receive_payment(
        &self,
        req: ReceivePaymentRequest,
    ) -> Result<ReceivePaymentResponse> {
        self.breez_services
            .receive_payment(req)
            .await
            .map_err(anyhow::Error::new::<ReceivePaymentError>)
    }

    /*  LNURL API's */

    /// See [BreezServices::lnurl_pay]
    pub async fn lnurl_pay(&self, req: LnUrlPayRequest) -> Result<LnUrlPayResult> {
        self.breez_services
            .lnurl_pay(req)
            .await
            .map_err(anyhow::Error::new::<LnUrlPayError>)
    }

    /// See [BreezServices::lnurl_withdraw]
    pub async fn lnurl_withdraw(&self, req: LnUrlWithdrawRequest) -> Result<LnUrlWithdrawResult> {
        self.breez_services
            .lnurl_withdraw(req)
            .await
            .map_err(anyhow::Error::new::<LnUrlWithdrawError>)
    }

    /// See [BreezServices::lnurl_auth]
    pub async fn lnurl_auth(&self, req_data: LnUrlAuthRequestData) -> Result<LnUrlCallbackStatus> {
        self.breez_services
            .lnurl_auth(req_data)
            .await
            .map_err(anyhow::Error::new::<LnUrlAuthError>)
    }

    /*  Support API */

    /// See [BreezServices::report_issue]
    pub async fn report_issue(&self, req: ReportIssueRequest) -> Result<()> {
        self.breez_services
            .report_issue(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /*  Fiat Currency API's */

    /// See [BreezServices::fetch_fiat_rates]
    pub async fn fetch_fiat_rates(&self) -> Result<Vec<Rate>> {
        self.breez_services
            .fetch_fiat_rates()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::list_fiat_currencies]
    pub async fn list_fiat_currencies(&self) -> Result<Vec<FiatCurrency>> {
        self.breez_services
            .list_fiat_currencies()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /*  On-Chain Swap API's */

    /// See [BreezServices::max_reverse_swap_amount]
    pub async fn max_reverse_swap_amount(&self) -> Result<MaxReverseSwapAmountResponse> {
        #[allow(deprecated)]
        self.breez_services
            .max_reverse_swap_amount()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::send_onchain]
    pub async fn send_onchain(&self, req: SendOnchainRequest) -> Result<SendOnchainResponse> {
        #[allow(deprecated)]
        self.breez_services
            .send_onchain(req)
            .await
            .map_err(anyhow::Error::new::<SendOnchainError>)
    }

    /// See [BreezServices::pay_onchain]
    pub async fn pay_onchain(&self, req: PayOnchainRequest) -> Result<PayOnchainResponse> {
        self.breez_services
            .pay_onchain(req)
            .await
            .map_err(anyhow::Error::new::<SendOnchainError>)
    }

    /// See [BreezServices::receive_onchain]
    pub async fn receive_onchain(&self, req: ReceiveOnchainRequest) -> Result<SwapInfo> {
        self.breez_services
            .receive_onchain(req)
            .await
            .map_err(anyhow::Error::new::<ReceiveOnchainError>)
    }

    /// See [BreezServices::buy_bitcoin]
    pub async fn buy_bitcoin(&self, req: BuyBitcoinRequest) -> Result<BuyBitcoinResponse> {
        self.breez_services
            .buy_bitcoin(req)
            .await
            .map_err(anyhow::Error::new::<ReceiveOnchainError>)
    }

    /// See [BreezServices::redeem_onchain_funds]
    pub async fn redeem_onchain_funds(
        &self,
        req: RedeemOnchainFundsRequest,
    ) -> Result<RedeemOnchainFundsResponse> {
        self.breez_services
            .redeem_onchain_funds(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::prepare_redeem_onchain_funds]
    pub async fn prepare_redeem_onchain_funds(
        &self,
        req: PrepareRedeemOnchainFundsRequest,
    ) -> Result<PrepareRedeemOnchainFundsResponse> {
        self.breez_services
            .prepare_redeem_onchain_funds(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /*  Refundables API's */

    /// See [BreezServices::list_refundables]
    pub async fn list_refundables(&self) -> Result<Vec<SwapInfo>> {
        self.breez_services
            .list_refundables()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::prepare_refund]
    pub async fn prepare_refund(&self, req: PrepareRefundRequest) -> Result<PrepareRefundResponse> {
        self.breez_services
            .prepare_refund(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::refund]
    pub async fn refund(&self, req: RefundRequest) -> Result<RefundResponse> {
        self.breez_services
            .refund(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::rescan_swaps]
    pub async fn rescan_swaps(&self) -> Result<()> {
        self.breez_services
            .rescan_swaps()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::redeem_swap]
    pub async fn redeem_swap(&self, swap_address: String) -> Result<()> {
        self.breez_services
            .redeem_swap(swap_address)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /*  In Progress Swap API's */

    /// See [BreezServices::in_progress_swap]
    pub async fn in_progress_swap(&self) -> Result<Option<SwapInfo>> {
        self.breez_services
            .in_progress_swap()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::in_progress_reverse_swaps]
    pub async fn in_progress_reverse_swaps(&self) -> Result<Vec<ReverseSwapInfo>> {
        #[allow(deprecated)]
        self.breez_services
            .in_progress_reverse_swaps()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /*  Swap Fee API's */

    /// See [BreezServices::open_channel_fee]
    pub async fn open_channel_fee(
        &self,
        req: OpenChannelFeeRequest,
    ) -> Result<OpenChannelFeeResponse> {
        self.breez_services
            .open_channel_fee(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::fetch_reverse_swap_fees]
    pub async fn fetch_reverse_swap_fees(
        &self,
        req: ReverseSwapFeesRequest,
    ) -> Result<ReverseSwapPairInfo> {
        self.breez_services
            .fetch_reverse_swap_fees(req)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::onchain_payment_limits]
    pub async fn onchain_payment_limits(&self) -> Result<OnchainPaymentLimitsResponse> {
        self.breez_services
            .onchain_payment_limits()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::prepare_onchain_payment]
    pub async fn prepare_onchain_payment(
        &self,
        req: PrepareOnchainPaymentRequest,
    ) -> Result<PrepareOnchainPaymentResponse> {
        self.breez_services
            .prepare_onchain_payment(req)
            .await
            .map_err(anyhow::Error::new::<SendOnchainError>)
    }

    /// See [BreezServices::in_progress_onchain_payments]
    pub async fn in_progress_onchain_payments(&self) -> Result<Vec<ReverseSwapInfo>> {
        self.breez_services
            .in_progress_onchain_payments()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::recommended_fees]
    pub async fn recommended_fees(&self) -> Result<RecommendedFees> {
        self.breez_services
            .recommended_fees()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /*  CLI API's */

    /// See [BreezServices::execute_dev_command]
    pub async fn execute_command(&self, command: String) -> Result<String> {
        self.breez_services
            .execute_dev_command(command)
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }

    /// See [BreezServices::generate_diagnostic_data]
    pub async fn generate_diagnostic_data(&self) -> Result<String> {
        self.breez_services
            .generate_diagnostic_data()
            .await
            .map_err(anyhow::Error::new::<SdkError>)
    }
}
/*  Binding Related Logic */

struct BindingEventListener;

impl EventListener for BindingEventListener {
    fn on_event(&self, e: BreezEvent) {
        if let Some(stream) = NOTIFICATION_STREAM.get() {
            let _ = stream.add(e);
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
            let _ = self.log_stream.add(LogEntry {
                line: record.args().to_string(),
                level: record.level().as_str().to_string(),
            });
        }
    }
    fn flush(&self) {}
}

/*  Parse API's */

pub fn parse_invoice(invoice: String) -> Result<LNInvoice> {
    invoice::parse_invoice(&invoice).map_err(|e| anyhow::Error::new::<SdkError>(e.into()))
}

pub async fn parse_input(input: String) -> Result<InputType> {
    input_parser::parse(&input).await
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
pub async fn service_health_check(api_key: String) -> Result<ServiceHealthCheckResponse> {
    BreezServices::service_health_check(api_key)
        .await
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
