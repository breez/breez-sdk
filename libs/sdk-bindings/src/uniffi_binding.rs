use anyhow::{anyhow, Result};
use breez_sdk_core::{
    error::*, mnemonic_to_seed as sdk_mnemonic_to_seed, parse as sdk_parse_input,
    parse_invoice as sdk_parse_invoice, AesSuccessActionDataDecrypted, BackupFailedData,
    BackupStatus, BitcoinAddressData, BreezEvent, BreezServices, BuyBitcoinProvider,
    BuyBitcoinRequest, BuyBitcoinResponse, ChannelState, CheckMessageRequest, CheckMessageResponse,
    ClosedChannelPaymentDetails, Config, CurrencyInfo, EnvironmentType, EventListener,
    FeeratePreset, FiatCurrency, GreenlightCredentials, GreenlightNodeConfig, InputType,
    InvoicePaidDetails, LNInvoice, ListPaymentsRequest, LnPaymentDetails, LnUrlAuthRequestData,
    LnUrlCallbackStatus, LnUrlErrorData, LnUrlPayRequest, LnUrlPayRequestData, LnUrlPayResult,
    LnUrlWithdrawRequest, LnUrlWithdrawRequestData, LnUrlWithdrawResult, LnUrlWithdrawSuccessData,
    LocaleOverrides, LocalizedName, LogEntry, LogStream, LspInformation, MessageSuccessActionData,
    MetadataItem, Network, NodeConfig, NodeState, OpenChannelFeeRequest, OpenChannelFeeResponse,
    OpeningFeeParams, OpeningFeeParamsMenu, Payment, PaymentDetails, PaymentFailedData,
    PaymentStatus, PaymentType, PaymentTypeFilter, PrepareSweepRequest, PrepareSweepResponse, Rate,
    ReceiveOnchainRequest, ReceivePaymentRequest, ReceivePaymentResponse, RecommendedFees,
    RefundRequest, RefundResponse, ReverseSwapFeesRequest, ReverseSwapInfo, ReverseSwapPairInfo,
    ReverseSwapStatus, RouteHint, RouteHintHop, SendOnchainRequest, SendOnchainResponse,
    SendPaymentRequest, SendPaymentResponse, SendSpontaneousPaymentRequest, SignMessageRequest,
    SignMessageResponse, StaticBackupRequest, StaticBackupResponse, SuccessActionProcessed,
    SwapInfo, SwapStatus, SweepRequest, SweepResponse, Symbol, UnspentTransactionOutput,
    UrlSuccessActionData,
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
pub fn set_log_stream(log_stream: Box<dyn LogStream>) -> Result<()> {
    LOG_INIT
        .set(true)
        .map_err(|_| anyhow!("log stream already created"))?;
    BindingLogger::init(log_stream);
    Ok(())
}

pub struct BlockingBreezServices {
    breez_services: Arc<BreezServices>,
}

impl BlockingBreezServices {
    pub fn disconnect(&self) -> Result<()> {
        rt().block_on(self.breez_services.disconnect())
    }

    pub fn send_payment(&self, req: SendPaymentRequest) -> SdkResult<SendPaymentResponse> {
        rt().block_on(self.breez_services.send_payment(req))
    }

    pub fn send_spontaneous_payment(
        &self,
        req: SendSpontaneousPaymentRequest,
    ) -> SdkResult<SendPaymentResponse> {
        rt().block_on(self.breez_services.send_spontaneous_payment(req))
    }

    pub fn receive_payment(&self, req: ReceivePaymentRequest) -> SdkResult<ReceivePaymentResponse> {
        rt().block_on(self.breez_services.receive_payment(req))
    }

    pub fn node_info(&self) -> SdkResult<NodeState> {
        self.breez_services.node_info()
    }

    pub fn sign_message(&self, req: SignMessageRequest) -> SdkResult<SignMessageResponse> {
        rt().block_on(self.breez_services.sign_message(req))
            .map_err(|e| e.into())
    }

    pub fn check_message(&self, req: CheckMessageRequest) -> SdkResult<CheckMessageResponse> {
        rt().block_on(self.breez_services.check_message(req))
            .map_err(|e| e.into())
    }

    pub fn backup_status(&self) -> SdkResult<BackupStatus> {
        self.breez_services.backup_status().map_err(|e| e.into())
    }

    pub fn backup(&self) -> SdkResult<()> {
        rt().block_on(self.breez_services.backup())
            .map_err(|e| e.into())
    }

    pub fn list_payments(&self, req: ListPaymentsRequest) -> SdkResult<Vec<Payment>> {
        rt().block_on(self.breez_services.list_payments(req))
    }

    pub fn payment_by_hash(&self, hash: String) -> SdkResult<Option<Payment>> {
        rt().block_on(self.breez_services.payment_by_hash(hash))
            .map_err(|e| e.into())
    }

    pub fn pay_lnurl(&self, req: LnUrlPayRequest) -> SdkResult<LnUrlPayResult> {
        rt().block_on(self.breez_services.lnurl_pay(req))
            .map_err(|e| e.into())
    }

    pub fn withdraw_lnurl(&self, req: LnUrlWithdrawRequest) -> SdkResult<LnUrlWithdrawResult> {
        rt().block_on(self.breez_services.lnurl_withdraw(req))
            .map_err(|e| e.into())
    }

    pub fn lnurl_auth(&self, req_data: LnUrlAuthRequestData) -> SdkResult<LnUrlCallbackStatus> {
        rt().block_on(self.breez_services.lnurl_auth(req_data))
            .map_err(|e| e.into())
    }

    pub fn sweep(&self, req: SweepRequest) -> SdkResult<SweepResponse> {
        rt().block_on(self.breez_services.sweep(req))
            .map_err(|e| e.into())
    }

    pub fn fetch_fiat_rates(&self) -> SdkResult<Vec<Rate>> {
        rt().block_on(self.breez_services.fetch_fiat_rates())
            .map_err(|e| e.into())
    }

    pub fn list_fiat_currencies(&self) -> SdkResult<Vec<FiatCurrency>> {
        rt().block_on(self.breez_services.list_fiat_currencies())
            .map_err(|e| e.into())
    }

    pub fn list_lsps(&self) -> SdkResult<Vec<LspInformation>> {
        rt().block_on(self.breez_services.list_lsps())
    }

    pub fn connect_lsp(&self, lsp_id: String) -> SdkResult<()> {
        rt().block_on(self.breez_services.connect_lsp(lsp_id))
    }

    pub fn fetch_lsp_info(&self, lsp_id: String) -> SdkResult<Option<LspInformation>> {
        rt().block_on(self.breez_services.fetch_lsp_info(lsp_id))
            .map_err(|e| e.into())
    }

    pub fn lsp_id(&self) -> SdkResult<Option<String>> {
        rt().block_on(self.breez_services.lsp_id())
    }

    pub fn lsp_info(&self) -> SdkResult<LspInformation> {
        rt().block_on(self.breez_services.lsp_info())
            .map_err(|e: anyhow::Error| e.into())
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
        .map_err(|e: anyhow::Error| e.into())
    }

    /// Onchain receive swap API
    pub fn receive_onchain(&self, req: ReceiveOnchainRequest) -> SdkResult<SwapInfo> {
        rt().block_on(self.breez_services.receive_onchain(req))
            .map_err(|e| e.into())
    }

    /// Onchain receive swap API
    pub fn in_progress_swap(&self) -> SdkResult<Option<SwapInfo>> {
        rt().block_on(self.breez_services.in_progress_swap())
            .map_err(|e| e.into())
    }

    /// list non-completed expired swaps that should be refunded by calling [BreezServices::refund]
    pub fn list_refundables(&self) -> SdkResult<Vec<SwapInfo>> {
        rt().block_on(self.breez_services.list_refundables())
            .map_err(|e| e.into())
    }

    // construct and broadcast a refund transaction for a faile/expired swap
    pub fn refund(&self, req: RefundRequest) -> SdkResult<RefundResponse> {
        rt().block_on(self.breez_services.refund(req))
            .map_err(|e| e.into())
    }

    pub fn fetch_reverse_swap_fees(
        &self,
        req: ReverseSwapFeesRequest,
    ) -> SdkResult<ReverseSwapPairInfo> {
        rt().block_on(self.breez_services.fetch_reverse_swap_fees(req))
            .map_err(|e| e.into())
    }

    pub fn in_progress_reverse_swaps(&self) -> SdkResult<Vec<ReverseSwapInfo>> {
        rt().block_on(self.breez_services.in_progress_reverse_swaps())
            .map_err(|e| e.into())
    }

    pub fn send_onchain(&self, req: SendOnchainRequest) -> SdkResult<SendOnchainResponse> {
        rt().block_on(self.breez_services.send_onchain(req))
            .map_err(|e| e.into())
    }

    pub fn execute_dev_command(&self, command: String) -> Result<String> {
        rt().block_on(self.breez_services.execute_dev_command(command))
    }

    pub fn sync(&self) -> SdkResult<()> {
        rt().block_on(self.breez_services.sync())
            .map_err(|e| e.into())
    }

    pub fn recommended_fees(&self) -> SdkResult<RecommendedFees> {
        rt().block_on(self.breez_services.recommended_fees())
            .map_err(|e| e.into())
    }

    pub fn buy_bitcoin(&self, req: BuyBitcoinRequest) -> SdkResult<BuyBitcoinResponse> {
        rt().block_on(self.breez_services.buy_bitcoin(req))
    }

    pub fn prepare_sweep(
        &self,
        req: PrepareSweepRequest,
    ) -> Result<PrepareSweepResponse, SdkError> {
        rt().block_on(self.breez_services.prepare_sweep(req))
            .map_err(|e| e.into())
    }
}

pub fn parse_invoice(invoice: String) -> SdkResult<LNInvoice> {
    sdk_parse_invoice(&invoice).map_err(|e| e.into())
}

pub fn parse_input(s: String) -> SdkResult<InputType> {
    rt().block_on(sdk_parse_input(&s)).map_err(|e| e.into())
}

pub fn mnemonic_to_seed(phrase: String) -> SdkResult<Vec<u8>> {
    sdk_mnemonic_to_seed(phrase).map_err(|e| e.into())
}

fn rt() -> &'static tokio::runtime::Runtime {
    &RT
}

uniffi_macros::include_scaffolding!("breez_sdk");
