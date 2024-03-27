use anyhow::Result;
use breez_sdk_core::logger::init_uniffi_logger;
use breez_sdk_core::{
    error::*, mnemonic_to_seed as sdk_mnemonic_to_seed, parse as sdk_parse_input,
    parse_invoice as sdk_parse_invoice, AesSuccessActionDataDecrypted, AesSuccessActionDataResult,
    BackupFailedData, BackupStatus, BitcoinAddressData, BreezEvent, BreezServices,
    BuyBitcoinProvider, BuyBitcoinRequest, BuyBitcoinResponse, ChannelState, CheckMessageRequest,
    CheckMessageResponse, ClosedChannelPaymentDetails, Config, ConfigureNodeRequest,
    ConnectRequest, CurrencyInfo, EnvironmentType, EventListener, FeeratePreset, FiatCurrency,
    GreenlightCredentials, GreenlightNodeConfig, HealthCheckStatus, InputType, InvoicePaidDetails,
    LNInvoice, LevelFilter, ListPaymentsRequest, LnPaymentDetails, LnUrlAuthRequestData,
    LnUrlCallbackStatus, LnUrlErrorData, LnUrlPayErrorData, LnUrlPayRequest, LnUrlPayRequestData,
    LnUrlPayResult, LnUrlPaySuccessData, LnUrlWithdrawRequest, LnUrlWithdrawRequestData,
    LnUrlWithdrawResult, LnUrlWithdrawSuccessData, LocaleOverrides, LocalizedName, LogEntry,
    LogStream, LspInformation, MaxReverseSwapAmountResponse, MessageSuccessActionData,
    MetadataFilter, MetadataItem, Network, NodeConfig, NodeCredentials, NodeState,
    OnchainPaymentLimitsResponse, OpenChannelFeeRequest, OpenChannelFeeResponse, OpeningFeeParams,
    OpeningFeeParamsMenu, PayOnchainRequest, PayOnchainResponse, Payment, PaymentDetails,
    PaymentFailedData, PaymentStatus, PaymentType, PaymentTypeFilter, PrepareOnchainPaymentRequest,
    PrepareOnchainPaymentResponse, PrepareRedeemOnchainFundsRequest,
    PrepareRedeemOnchainFundsResponse, PrepareRefundRequest, PrepareRefundResponse, Rate,
    ReceiveOnchainRequest, ReceivePaymentRequest, ReceivePaymentResponse, RecommendedFees,
    RedeemOnchainFundsRequest, RedeemOnchainFundsResponse, RefundRequest, RefundResponse,
    ReportIssueRequest, ReportPaymentFailureDetails, ReverseSwapFeesRequest, ReverseSwapInfo,
    ReverseSwapPairInfo, ReverseSwapStatus, RouteHint, RouteHintHop, SendOnchainRequest,
    SendOnchainResponse, SendPaymentRequest, SendPaymentResponse, SendSpontaneousPaymentRequest,
    ServiceHealthCheckResponse, SignMessageRequest, SignMessageResponse, StaticBackupRequest,
    StaticBackupResponse, SuccessActionProcessed, SwapAmountType, SwapInfo, SwapStatus, Symbol,
    TlvEntry, UnspentTransactionOutput, UrlSuccessActionData,
};
use once_cell::sync::Lazy;
use std::sync::Arc;

static RT: Lazy<tokio::runtime::Runtime> = Lazy::new(|| tokio::runtime::Runtime::new().unwrap());

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

/// Fetches the service health check from the support API.
pub fn service_health_check(api_key: String) -> SdkResult<ServiceHealthCheckResponse> {
    rt().block_on(BreezServices::service_health_check(api_key))
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
    req: ConnectRequest,
    event_listener: Box<dyn EventListener>,
) -> Result<Arc<BlockingBreezServices>, ConnectError> {
    rt().block_on(async move {
        let breez_services = BreezServices::connect(req, event_listener).await?;

        Ok(Arc::new(BlockingBreezServices { breez_services }))
    })
}

/// If used, this must be called before `connect`
pub fn set_log_stream(
    log_stream: Box<dyn LogStream>,
    filter_level: Option<LevelFilter>,
) -> SdkResult<()> {
    init_uniffi_logger(log_stream, filter_level);
    Ok(())
}

pub struct BlockingBreezServices {
    breez_services: Arc<BreezServices>,
}

impl BlockingBreezServices {
    pub fn disconnect(&self) -> SdkResult<()> {
        rt().block_on(self.breez_services.disconnect())
    }

    pub fn configure_node(&self, req: ConfigureNodeRequest) -> SdkResult<()> {
        rt().block_on(self.breez_services.configure_node(req))
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

    pub fn node_credentials(&self) -> SdkResult<Option<NodeCredentials>> {
        self.breez_services.node_credentials()
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

    pub fn set_payment_metadata(&self, hash: String, metadata: String) -> SdkResult<()> {
        rt().block_on(self.breez_services.set_payment_metadata(hash, metadata))
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

    pub fn report_issue(&self, req: ReportIssueRequest) -> SdkResult<()> {
        rt().block_on(self.breez_services.report_issue(req))
    }

    pub fn redeem_onchain_funds(
        &self,
        req: RedeemOnchainFundsRequest,
    ) -> SdkResult<RedeemOnchainFundsResponse> {
        rt().block_on(self.breez_services.redeem_onchain_funds(req))
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

    pub fn register_webhook(&self, webhook_url: String) -> SdkResult<()> {
        rt().block_on(async { self.breez_services.register_webhook(webhook_url).await })
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

    /// Onchain rescan_swaps API
    pub fn rescan_swaps(&self) -> SdkResult<()> {
        rt().block_on(self.breez_services.rescan_swaps())
    }

    /// Redeem an individual swap
    pub fn redeem_swap(&self, swap_address: String) -> SdkResult<()> {
        rt().block_on(self.breez_services.redeem_swap(swap_address))
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

    pub fn onchain_payment_limits(&self) -> SdkResult<OnchainPaymentLimitsResponse> {
        rt().block_on(self.breez_services.onchain_payment_limits())
    }

    pub fn prepare_onchain_payment(
        &self,
        req: PrepareOnchainPaymentRequest,
    ) -> Result<PrepareOnchainPaymentResponse, SendOnchainError> {
        rt().block_on(self.breez_services.prepare_onchain_payment(req))
    }

    pub fn in_progress_onchain_payments(&self) -> SdkResult<Vec<ReverseSwapInfo>> {
        rt().block_on(self.breez_services.in_progress_onchain_payments())
    }

    pub fn in_progress_reverse_swaps(&self) -> SdkResult<Vec<ReverseSwapInfo>> {
        rt().block_on(self.breez_services.in_progress_reverse_swaps())
    }

    pub fn max_reverse_swap_amount(&self) -> SdkResult<MaxReverseSwapAmountResponse> {
        rt().block_on(self.breez_services.max_reverse_swap_amount())
    }

    pub fn send_onchain(
        &self,
        req: SendOnchainRequest,
    ) -> Result<SendOnchainResponse, SendOnchainError> {
        rt().block_on(self.breez_services.send_onchain(req))
    }

    pub fn pay_onchain(
        &self,
        req: PayOnchainRequest,
    ) -> Result<PayOnchainResponse, SendOnchainError> {
        rt().block_on(self.breez_services.pay_onchain(req))
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

    pub fn prepare_redeem_onchain_funds(
        &self,
        req: PrepareRedeemOnchainFundsRequest,
    ) -> SdkResult<PrepareRedeemOnchainFundsResponse> {
        rt().block_on(self.breez_services.prepare_redeem_onchain_funds(req))
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
