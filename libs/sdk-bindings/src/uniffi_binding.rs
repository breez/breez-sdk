use anyhow::Result;
use breez_sdk_core::{
    error::*, mnemonic_to_seed as sdk_mnemonic_to_seed, parse as sdk_parse_input,
    parse_invoice as sdk_parse_invoice, AesSuccessActionDataDecrypted, BackupFailedData,
    BackupStatus, BitcoinAddressData, BreezEvent, BreezServices, BuyBitcoinProvider,
    BuyBitcoinRequest, BuyBitcoinResponse, ChannelState, CheckMessageRequest, CheckMessageResponse,
    ClosedChannelPaymentDetails, Config, CurrencyInfo, EnvironmentType, EventListener,
    FeeratePreset, FiatCurrency, GreenlightCredentials, GreenlightNodeConfig, InputType,
    InvoicePaidDetails, LNInvoice, ListPaymentsRequest, LnPaymentDetails, LnUrlAuthRequestData,
    LnUrlCallbackStatus, LnUrlErrorData, LnUrlPayErrorData, LnUrlPayRequest, LnUrlPayRequestData,
    LnUrlPayResult, LnUrlPaySuccessData, LnUrlWithdrawRequest, LnUrlWithdrawRequestData,
    LnUrlWithdrawResult, LnUrlWithdrawSuccessData, LocaleOverrides, LocalizedName, LogEntry,
    LogStream, LspInformation, MessageSuccessActionData, MetadataItem, Network, NodeConfig,
    NodeState, OpenChannelFeeRequest, OpenChannelFeeResponse, OpeningFeeParams,
    OpeningFeeParamsMenu, Payment, PaymentDetails, PaymentFailedData, PaymentStatus, PaymentType,
    PaymentTypeFilter, PrepareRefundRequest, PrepareRefundResponse, PrepareSweepRequest,
    PrepareSweepResponse, Rate, ReceiveOnchainRequest, ReceivePaymentRequest,
    ReceivePaymentResponse, RecommendedFees, RefundRequest, RefundResponse, ReverseSwapFeesRequest,
    ReverseSwapInfo, ReverseSwapPairInfo, ReverseSwapStatus, RouteHint, RouteHintHop,
    SendOnchainRequest, SendOnchainResponse, SendPaymentRequest, SendPaymentResponse,
    SendSpontaneousPaymentRequest, SignMessageRequest, SignMessageResponse, StaticBackupRequest,
    StaticBackupResponse, SuccessActionProcessed, SwapInfo, SwapStatus, SweepRequest,
    SweepResponse, Symbol, UnspentTransactionOutput, UrlSuccessActionData, Amount, Quantity, LNOffer
};
use log::{Level, LevelFilter, Metadata, Record};
use once_cell::sync::{Lazy, OnceCell};
use std::sync::Arc;

static RT: Lazy<tokio::runtime::Runtime> = Lazy::new(|| tokio::runtime::Runtime::new().unwrap());
static LOG_INIT: OnceCell<bool> = OnceCell::new();

struct BindingLogger {
    log_stream: Box<dyn LogStream>,
}

impl BindingLogger {
    fn init(log_stream: Box<dyn LogStream>) {
        let binding_logger = BindingLogger { log_stream };
        log::set_boxed_logger(Box::new(binding_logger)).unwrap();
        log::set_max_level(LevelFilter::Trace);
    }
}

impl log::Log for BindingLogger {
    fn enabled(&self, m: &Metadata) -> bool {
        // ignore the internal uniffi log to prevent infinite loop.
        return m.level() <= Level::Trace && *m.target() != *"breez_sdk_bindings::uniffi_binding";
    }

    fn log(&self, record: &Record) {
        self.log_stream.log(LogEntry {
            line: record.args().to_string(),
            level: record.level().as_str().to_string(),
        });
    }
    fn flush(&self) {}
}

/// Create a new SDK config with default values
pub fn default_config(
    env_type: EnvironmentType,
    api_key: String,
    node_config: NodeConfig,
) -> Config {
    BreezServices::default_config(env_type, api_key, node_config)
}

/// Get the static backup data from the peristent storage.
/// This data enables the user to recover the node in an external core ligntning node.
/// See here for instructions on how to recover using this data: https://docs.corelightning.org/docs/backup-and-recovery#backing-up-using-static-channel-backup
pub fn static_backup(req: StaticBackupRequest) -> SdkResult<StaticBackupResponse> {
    BreezServices::static_backup(req)
}

/// connect initializes the SDK services, schedule the node to run in the cloud and
/// run the signer. This must be called in order to start communicating with the node.
///
/// In addition, it also initializes SDK logging. If the log stream was already set using [`set_log_stream`]
/// when this is called, log statements are sent to the log stream.
///
/// # Arguments
///
/// * `config` - The sdk configuration
/// * `seed` - The node private key
/// * `event_listener` - Listener to SDK events
///
pub fn connect(
    config: Config,
    seed: Vec<u8>,
    event_listener: Box<dyn EventListener>,
) -> SdkResult<Arc<BlockingBreezServices>> {
    rt().block_on(async move {
        let breez_services = BreezServices::connect(config, seed, event_listener).await?;

        Ok(Arc::new(BlockingBreezServices { breez_services }))
    })
}

/// If used, this must be called before `connect`
pub fn set_log_stream(log_stream: Box<dyn LogStream>) -> SdkResult<()> {
    LOG_INIT.set(true).map_err(|_| SdkError::Generic {
        err: "Log stream already created".into(),
    })?;
    BindingLogger::init(log_stream);
    Ok(())
}

pub struct BlockingBreezServices {
    breez_services: Arc<BreezServices>,
}

impl BlockingBreezServices {
    pub fn disconnect(&self) -> SdkResult<()> {
        rt().block_on(self.breez_services.disconnect())
    }

    pub fn send_payment(
        &self,
        req: SendPaymentRequest,
    ) -> Result<SendPaymentResponse, SendPaymentError> {
        rt().block_on(self.breez_services.send_payment(req))
    }

    pub fn send_spontaneous_payment(
        &self,
        req: SendSpontaneousPaymentRequest,
    ) -> Result<SendPaymentResponse, SendPaymentError> {
        rt().block_on(self.breez_services.send_spontaneous_payment(req))
    }

    pub fn receive_payment(
        &self,
        req: ReceivePaymentRequest,
    ) -> Result<ReceivePaymentResponse, ReceivePaymentError> {
        rt().block_on(self.breez_services.receive_payment(req))
    }

    pub fn node_info(&self) -> SdkResult<NodeState> {
        self.breez_services.node_info()
    }

    pub fn sign_message(&self, req: SignMessageRequest) -> SdkResult<SignMessageResponse> {
        rt().block_on(self.breez_services.sign_message(req))
    }

    pub fn check_message(&self, req: CheckMessageRequest) -> SdkResult<CheckMessageResponse> {
        rt().block_on(self.breez_services.check_message(req))
    }

    pub fn backup_status(&self) -> SdkResult<BackupStatus> {
        self.breez_services.backup_status()
    }

    pub fn backup(&self) -> SdkResult<()> {
        rt().block_on(self.breez_services.backup())
    }

    pub fn list_payments(&self, req: ListPaymentsRequest) -> SdkResult<Vec<Payment>> {
        rt().block_on(self.breez_services.list_payments(req))
    }

    pub fn payment_by_hash(&self, hash: String) -> SdkResult<Option<Payment>> {
        rt().block_on(self.breez_services.payment_by_hash(hash))
    }

    pub fn pay_lnurl(&self, req: LnUrlPayRequest) -> Result<LnUrlPayResult, LnUrlPayError> {
        rt().block_on(self.breez_services.lnurl_pay(req))
    }

    pub fn withdraw_lnurl(
        &self,
        req: LnUrlWithdrawRequest,
    ) -> Result<LnUrlWithdrawResult, LnUrlWithdrawError> {
        rt().block_on(self.breez_services.lnurl_withdraw(req))
    }

    pub fn lnurl_auth(
        &self,
        req_data: LnUrlAuthRequestData,
    ) -> Result<LnUrlCallbackStatus, LnUrlAuthError> {
        rt().block_on(self.breez_services.lnurl_auth(req_data))
    }

    pub fn sweep(&self, req: SweepRequest) -> SdkResult<SweepResponse> {
        rt().block_on(self.breez_services.sweep(req))
    }

    pub fn fetch_fiat_rates(&self) -> SdkResult<Vec<Rate>> {
        rt().block_on(self.breez_services.fetch_fiat_rates())
    }

    pub fn list_fiat_currencies(&self) -> SdkResult<Vec<FiatCurrency>> {
        rt().block_on(self.breez_services.list_fiat_currencies())
    }

    pub fn list_lsps(&self) -> SdkResult<Vec<LspInformation>> {
        rt().block_on(self.breez_services.list_lsps())
    }

    pub fn connect_lsp(&self, lsp_id: String) -> SdkResult<()> {
        rt().block_on(self.breez_services.connect_lsp(lsp_id))
    }

    pub fn fetch_lsp_info(&self, lsp_id: String) -> SdkResult<Option<LspInformation>> {
        rt().block_on(self.breez_services.fetch_lsp_info(lsp_id))
    }

    pub fn lsp_id(&self) -> SdkResult<Option<String>> {
        rt().block_on(self.breez_services.lsp_id())
    }

    pub fn lsp_info(&self) -> SdkResult<LspInformation> {
        rt().block_on(self.breez_services.lsp_info())
    }

    pub fn open_channel_fee(
        &self,
        req: OpenChannelFeeRequest,
    ) -> SdkResult<OpenChannelFeeResponse> {
        rt().block_on(self.breez_services.open_channel_fee(req))
    }

    pub fn close_lsp_channels(&self) -> SdkResult<()> {
        rt().block_on(async {
            _ = self.breez_services.close_lsp_channels().await?;
            Ok(())
        })
    }

    /// Onchain receive swap API
    pub fn receive_onchain(
        &self,
        req: ReceiveOnchainRequest,
    ) -> Result<SwapInfo, ReceiveOnchainError> {
        rt().block_on(self.breez_services.receive_onchain(req))
    }

    /// Onchain receive swap API
    pub fn in_progress_swap(&self) -> SdkResult<Option<SwapInfo>> {
        rt().block_on(self.breez_services.in_progress_swap())
    }

    /// list non-completed expired swaps that should be refunded by calling [BreezServices::refund]
    pub fn list_refundables(&self) -> SdkResult<Vec<SwapInfo>> {
        rt().block_on(self.breez_services.list_refundables())
    }

    // prepare a refund transaction for a failed/expired swap
    // optionally used to know fees before calling `refund()`
    pub fn prepare_refund(&self, req: PrepareRefundRequest) -> SdkResult<PrepareRefundResponse> {
        rt().block_on(self.breez_services.prepare_refund(req))
    }

    // construct and broadcast a refund transaction for a faile/expired swap
    pub fn refund(&self, req: RefundRequest) -> SdkResult<RefundResponse> {
        rt().block_on(self.breez_services.refund(req))
    }

    pub fn fetch_reverse_swap_fees(
        &self,
        req: ReverseSwapFeesRequest,
    ) -> SdkResult<ReverseSwapPairInfo> {
        rt().block_on(self.breez_services.fetch_reverse_swap_fees(req))
    }

    pub fn in_progress_reverse_swaps(&self) -> SdkResult<Vec<ReverseSwapInfo>> {
        rt().block_on(self.breez_services.in_progress_reverse_swaps())
    }

    pub fn send_onchain(
        &self,
        req: SendOnchainRequest,
    ) -> Result<SendOnchainResponse, SendOnchainError> {
        rt().block_on(self.breez_services.send_onchain(req))
    }

    pub fn execute_dev_command(&self, command: String) -> SdkResult<String> {
        rt().block_on(self.breez_services.execute_dev_command(command))
    }

    pub fn sync(&self) -> SdkResult<()> {
        rt().block_on(self.breez_services.sync())
    }

    pub fn recommended_fees(&self) -> SdkResult<RecommendedFees> {
        rt().block_on(self.breez_services.recommended_fees())
    }

    pub fn buy_bitcoin(
        &self,
        req: BuyBitcoinRequest,
    ) -> Result<BuyBitcoinResponse, ReceiveOnchainError> {
        rt().block_on(self.breez_services.buy_bitcoin(req))
    }

    pub fn prepare_sweep(&self, req: PrepareSweepRequest) -> SdkResult<PrepareSweepResponse> {
        rt().block_on(self.breez_services.prepare_sweep(req))
    }
}

pub fn parse_invoice(invoice: String) -> SdkResult<LNInvoice> {
    Ok(sdk_parse_invoice(&invoice)?)
}

pub fn parse_input(s: String) -> SdkResult<InputType> {
    rt().block_on(async move { Ok(sdk_parse_input(&s).await?) })
}

pub fn mnemonic_to_seed(phrase: String) -> SdkResult<Vec<u8>> {
    Ok(sdk_mnemonic_to_seed(phrase)?)
}

fn rt() -> &'static tokio::runtime::Runtime {
    &RT
}

uniffi_macros::include_scaffolding!("breez_sdk");
