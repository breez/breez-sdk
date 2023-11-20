use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_connect(port_: i64, config: *mut wire_Config, seed: *mut wire_uint_8_list) {
    wire_connect_impl(port_, config, seed)
}

#[no_mangle]
pub extern "C" fn wire_is_initialized(port_: i64) {
    wire_is_initialized_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_sync(port_: i64) {
    wire_sync_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_node_info(port_: i64) {
    wire_node_info_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_disconnect(port_: i64) {
    wire_disconnect_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_sign_message(port_: i64, req: *mut wire_SignMessageRequest) {
    wire_sign_message_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_check_message(port_: i64, req: *mut wire_CheckMessageRequest) {
    wire_check_message_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_mnemonic_to_seed(port_: i64, phrase: *mut wire_uint_8_list) {
    wire_mnemonic_to_seed_impl(port_, phrase)
}

#[no_mangle]
pub extern "C" fn wire_default_config(
    port_: i64,
    env_type: i32,
    api_key: *mut wire_uint_8_list,
    node_config: *mut wire_NodeConfig,
) {
    wire_default_config_impl(port_, env_type, api_key, node_config)
}

#[no_mangle]
pub extern "C" fn wire_static_backup(port_: i64, req: *mut wire_StaticBackupRequest) {
    wire_static_backup_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_breez_events_stream(port_: i64) {
    wire_breez_events_stream_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_breez_log_stream(port_: i64) {
    wire_breez_log_stream_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_list_lsps(port_: i64) {
    wire_list_lsps_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_connect_lsp(port_: i64, lsp_id: *mut wire_uint_8_list) {
    wire_connect_lsp_impl(port_, lsp_id)
}

#[no_mangle]
pub extern "C" fn wire_lsp_id(port_: i64) {
    wire_lsp_id_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_fetch_lsp_info(port_: i64, id: *mut wire_uint_8_list) {
    wire_fetch_lsp_info_impl(port_, id)
}

#[no_mangle]
pub extern "C" fn wire_lsp_info(port_: i64) {
    wire_lsp_info_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_close_lsp_channels(port_: i64) {
    wire_close_lsp_channels_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_backup(port_: i64) {
    wire_backup_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_backup_status(port_: i64) {
    wire_backup_status_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_parse_invoice(port_: i64, invoice: *mut wire_uint_8_list) {
    wire_parse_invoice_impl(port_, invoice)
}

#[no_mangle]
pub extern "C" fn wire_parse_input(port_: i64, input: *mut wire_uint_8_list) {
    wire_parse_input_impl(port_, input)
}

#[no_mangle]
pub extern "C" fn wire_list_payments(port_: i64, req: *mut wire_ListPaymentsRequest) {
    wire_list_payments_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_payment_by_hash(port_: i64, hash: *mut wire_uint_8_list) {
    wire_payment_by_hash_impl(port_, hash)
}

#[no_mangle]
pub extern "C" fn wire_send_payment(port_: i64, req: *mut wire_SendPaymentRequest) {
    wire_send_payment_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_send_spontaneous_payment(
    port_: i64,
    req: *mut wire_SendSpontaneousPaymentRequest,
) {
    wire_send_spontaneous_payment_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_receive_payment(port_: i64, req: *mut wire_ReceivePaymentRequest) {
    wire_receive_payment_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_lnurl_pay(port_: i64, req: *mut wire_LnUrlPayRequest) {
    wire_lnurl_pay_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_lnurl_withdraw(port_: i64, req: *mut wire_LnUrlWithdrawRequest) {
    wire_lnurl_withdraw_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_lnurl_auth(port_: i64, req_data: *mut wire_LnUrlAuthRequestData) {
    wire_lnurl_auth_impl(port_, req_data)
}

#[no_mangle]
pub extern "C" fn wire_fetch_fiat_rates(port_: i64) {
    wire_fetch_fiat_rates_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_list_fiat_currencies(port_: i64) {
    wire_list_fiat_currencies_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_send_onchain(port_: i64, req: *mut wire_SendOnchainRequest) {
    wire_send_onchain_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_receive_onchain(port_: i64, req: *mut wire_ReceiveOnchainRequest) {
    wire_receive_onchain_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_buy_bitcoin(port_: i64, req: *mut wire_BuyBitcoinRequest) {
    wire_buy_bitcoin_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_sweep(port_: i64, req: *mut wire_SweepRequest) {
    wire_sweep_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_prepare_sweep(port_: i64, req: *mut wire_PrepareSweepRequest) {
    wire_prepare_sweep_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_list_refundables(port_: i64) {
    wire_list_refundables_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_prepare_refund(port_: i64, req: *mut wire_PrepareRefundRequest) {
    wire_prepare_refund_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_refund(port_: i64, req: *mut wire_RefundRequest) {
    wire_refund_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_in_progress_swap(port_: i64) {
    wire_in_progress_swap_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_in_progress_reverse_swaps(port_: i64) {
    wire_in_progress_reverse_swaps_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_open_channel_fee(port_: i64, req: *mut wire_OpenChannelFeeRequest) {
    wire_open_channel_fee_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_fetch_reverse_swap_fees(port_: i64, req: *mut wire_ReverseSwapFeesRequest) {
    wire_fetch_reverse_swap_fees_impl(port_, req)
}

#[no_mangle]
pub extern "C" fn wire_recommended_fees(port_: i64) {
    wire_recommended_fees_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_execute_command(port_: i64, command: *mut wire_uint_8_list) {
    wire_execute_command_impl(port_, command)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_bool_0(value: bool) -> *mut bool {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_buy_bitcoin_request_0() -> *mut wire_BuyBitcoinRequest {
    support::new_leak_box_ptr(wire_BuyBitcoinRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_check_message_request_0() -> *mut wire_CheckMessageRequest {
    support::new_leak_box_ptr(wire_CheckMessageRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_config_0() -> *mut wire_Config {
    support::new_leak_box_ptr(wire_Config::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_greenlight_credentials_0() -> *mut wire_GreenlightCredentials {
    support::new_leak_box_ptr(wire_GreenlightCredentials::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_greenlight_node_config_0() -> *mut wire_GreenlightNodeConfig {
    support::new_leak_box_ptr(wire_GreenlightNodeConfig::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_i64_0(value: i64) -> *mut i64 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_list_payments_request_0() -> *mut wire_ListPaymentsRequest {
    support::new_leak_box_ptr(wire_ListPaymentsRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_ln_url_auth_request_data_0() -> *mut wire_LnUrlAuthRequestData {
    support::new_leak_box_ptr(wire_LnUrlAuthRequestData::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_ln_url_pay_request_0() -> *mut wire_LnUrlPayRequest {
    support::new_leak_box_ptr(wire_LnUrlPayRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_ln_url_withdraw_request_0() -> *mut wire_LnUrlWithdrawRequest {
    support::new_leak_box_ptr(wire_LnUrlWithdrawRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_node_config_0() -> *mut wire_NodeConfig {
    support::new_leak_box_ptr(wire_NodeConfig::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_open_channel_fee_request_0() -> *mut wire_OpenChannelFeeRequest {
    support::new_leak_box_ptr(wire_OpenChannelFeeRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_opening_fee_params_0() -> *mut wire_OpeningFeeParams {
    support::new_leak_box_ptr(wire_OpeningFeeParams::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_prepare_refund_request_0() -> *mut wire_PrepareRefundRequest {
    support::new_leak_box_ptr(wire_PrepareRefundRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_prepare_sweep_request_0() -> *mut wire_PrepareSweepRequest {
    support::new_leak_box_ptr(wire_PrepareSweepRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_receive_onchain_request_0() -> *mut wire_ReceiveOnchainRequest {
    support::new_leak_box_ptr(wire_ReceiveOnchainRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_receive_payment_request_0() -> *mut wire_ReceivePaymentRequest {
    support::new_leak_box_ptr(wire_ReceivePaymentRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_refund_request_0() -> *mut wire_RefundRequest {
    support::new_leak_box_ptr(wire_RefundRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_reverse_swap_fees_request_0() -> *mut wire_ReverseSwapFeesRequest
{
    support::new_leak_box_ptr(wire_ReverseSwapFeesRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_send_onchain_request_0() -> *mut wire_SendOnchainRequest {
    support::new_leak_box_ptr(wire_SendOnchainRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_send_payment_request_0() -> *mut wire_SendPaymentRequest {
    support::new_leak_box_ptr(wire_SendPaymentRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_send_spontaneous_payment_request_0(
) -> *mut wire_SendSpontaneousPaymentRequest {
    support::new_leak_box_ptr(wire_SendSpontaneousPaymentRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_sign_message_request_0() -> *mut wire_SignMessageRequest {
    support::new_leak_box_ptr(wire_SignMessageRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_static_backup_request_0() -> *mut wire_StaticBackupRequest {
    support::new_leak_box_ptr(wire_StaticBackupRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_sweep_request_0() -> *mut wire_SweepRequest {
    support::new_leak_box_ptr(wire_SweepRequest::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_u32_0(value: u32) -> *mut u32 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_u64_0(value: u64) -> *mut u64 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_list_payment_type_filter_0(len: i32) -> *mut wire_list_payment_type_filter {
    let wrap = wire_list_payment_type_filter {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}

impl Wire2Api<bool> for *mut bool {
    fn wire2api(self) -> bool {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<BuyBitcoinRequest> for *mut wire_BuyBitcoinRequest {
    fn wire2api(self) -> BuyBitcoinRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<BuyBitcoinRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<CheckMessageRequest> for *mut wire_CheckMessageRequest {
    fn wire2api(self) -> CheckMessageRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<CheckMessageRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Config> for *mut wire_Config {
    fn wire2api(self) -> Config {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Config>::wire2api(*wrap).into()
    }
}
impl Wire2Api<GreenlightCredentials> for *mut wire_GreenlightCredentials {
    fn wire2api(self) -> GreenlightCredentials {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<GreenlightCredentials>::wire2api(*wrap).into()
    }
}
impl Wire2Api<GreenlightNodeConfig> for *mut wire_GreenlightNodeConfig {
    fn wire2api(self) -> GreenlightNodeConfig {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<GreenlightNodeConfig>::wire2api(*wrap).into()
    }
}
impl Wire2Api<i64> for *mut i64 {
    fn wire2api(self) -> i64 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<ListPaymentsRequest> for *mut wire_ListPaymentsRequest {
    fn wire2api(self) -> ListPaymentsRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ListPaymentsRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<LnUrlAuthRequestData> for *mut wire_LnUrlAuthRequestData {
    fn wire2api(self) -> LnUrlAuthRequestData {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<LnUrlAuthRequestData>::wire2api(*wrap).into()
    }
}
impl Wire2Api<LnUrlPayRequest> for *mut wire_LnUrlPayRequest {
    fn wire2api(self) -> LnUrlPayRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<LnUrlPayRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<LnUrlWithdrawRequest> for *mut wire_LnUrlWithdrawRequest {
    fn wire2api(self) -> LnUrlWithdrawRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<LnUrlWithdrawRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<NodeConfig> for *mut wire_NodeConfig {
    fn wire2api(self) -> NodeConfig {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<NodeConfig>::wire2api(*wrap).into()
    }
}
impl Wire2Api<OpenChannelFeeRequest> for *mut wire_OpenChannelFeeRequest {
    fn wire2api(self) -> OpenChannelFeeRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<OpenChannelFeeRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<OpeningFeeParams> for *mut wire_OpeningFeeParams {
    fn wire2api(self) -> OpeningFeeParams {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<OpeningFeeParams>::wire2api(*wrap).into()
    }
}
impl Wire2Api<PrepareRefundRequest> for *mut wire_PrepareRefundRequest {
    fn wire2api(self) -> PrepareRefundRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<PrepareRefundRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<PrepareSweepRequest> for *mut wire_PrepareSweepRequest {
    fn wire2api(self) -> PrepareSweepRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<PrepareSweepRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<ReceiveOnchainRequest> for *mut wire_ReceiveOnchainRequest {
    fn wire2api(self) -> ReceiveOnchainRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ReceiveOnchainRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<ReceivePaymentRequest> for *mut wire_ReceivePaymentRequest {
    fn wire2api(self) -> ReceivePaymentRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ReceivePaymentRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<RefundRequest> for *mut wire_RefundRequest {
    fn wire2api(self) -> RefundRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<RefundRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<ReverseSwapFeesRequest> for *mut wire_ReverseSwapFeesRequest {
    fn wire2api(self) -> ReverseSwapFeesRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ReverseSwapFeesRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SendOnchainRequest> for *mut wire_SendOnchainRequest {
    fn wire2api(self) -> SendOnchainRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SendOnchainRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SendPaymentRequest> for *mut wire_SendPaymentRequest {
    fn wire2api(self) -> SendPaymentRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SendPaymentRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SendSpontaneousPaymentRequest> for *mut wire_SendSpontaneousPaymentRequest {
    fn wire2api(self) -> SendSpontaneousPaymentRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SendSpontaneousPaymentRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SignMessageRequest> for *mut wire_SignMessageRequest {
    fn wire2api(self) -> SignMessageRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SignMessageRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<StaticBackupRequest> for *mut wire_StaticBackupRequest {
    fn wire2api(self) -> StaticBackupRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<StaticBackupRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SweepRequest> for *mut wire_SweepRequest {
    fn wire2api(self) -> SweepRequest {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SweepRequest>::wire2api(*wrap).into()
    }
}
impl Wire2Api<u32> for *mut u32 {
    fn wire2api(self) -> u32 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<u64> for *mut u64 {
    fn wire2api(self) -> u64 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}

impl Wire2Api<BuyBitcoinRequest> for wire_BuyBitcoinRequest {
    fn wire2api(self) -> BuyBitcoinRequest {
        BuyBitcoinRequest {
            provider: self.provider.wire2api(),
            opening_fee_params: self.opening_fee_params.wire2api(),
        }
    }
}
impl Wire2Api<CheckMessageRequest> for wire_CheckMessageRequest {
    fn wire2api(self) -> CheckMessageRequest {
        CheckMessageRequest {
            message: self.message.wire2api(),
            pubkey: self.pubkey.wire2api(),
            signature: self.signature.wire2api(),
        }
    }
}
impl Wire2Api<Config> for wire_Config {
    fn wire2api(self) -> Config {
        Config {
            breezserver: self.breezserver.wire2api(),
            mempoolspace_url: self.mempoolspace_url.wire2api(),
            working_dir: self.working_dir.wire2api(),
            network: self.network.wire2api(),
            payment_timeout_sec: self.payment_timeout_sec.wire2api(),
            default_lsp_id: self.default_lsp_id.wire2api(),
            api_key: self.api_key.wire2api(),
            maxfee_percent: self.maxfee_percent.wire2api(),
            exemptfee_msat: self.exemptfee_msat.wire2api(),
            node_config: self.node_config.wire2api(),
        }
    }
}

impl Wire2Api<GreenlightCredentials> for wire_GreenlightCredentials {
    fn wire2api(self) -> GreenlightCredentials {
        GreenlightCredentials {
            device_key: self.device_key.wire2api(),
            device_cert: self.device_cert.wire2api(),
        }
    }
}
impl Wire2Api<GreenlightNodeConfig> for wire_GreenlightNodeConfig {
    fn wire2api(self) -> GreenlightNodeConfig {
        GreenlightNodeConfig {
            partner_credentials: self.partner_credentials.wire2api(),
            invite_code: self.invite_code.wire2api(),
        }
    }
}

impl Wire2Api<Vec<PaymentTypeFilter>> for *mut wire_list_payment_type_filter {
    fn wire2api(self) -> Vec<PaymentTypeFilter> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}
impl Wire2Api<ListPaymentsRequest> for wire_ListPaymentsRequest {
    fn wire2api(self) -> ListPaymentsRequest {
        ListPaymentsRequest {
            filters: self.filters.wire2api(),
            from_timestamp: self.from_timestamp.wire2api(),
            to_timestamp: self.to_timestamp.wire2api(),
            include_failures: self.include_failures.wire2api(),
            offset: self.offset.wire2api(),
            limit: self.limit.wire2api(),
        }
    }
}
impl Wire2Api<LnUrlAuthRequestData> for wire_LnUrlAuthRequestData {
    fn wire2api(self) -> LnUrlAuthRequestData {
        LnUrlAuthRequestData {
            k1: self.k1.wire2api(),
            action: self.action.wire2api(),
            domain: self.domain.wire2api(),
            url: self.url.wire2api(),
        }
    }
}
impl Wire2Api<LnUrlPayRequest> for wire_LnUrlPayRequest {
    fn wire2api(self) -> LnUrlPayRequest {
        LnUrlPayRequest {
            data: self.data.wire2api(),
            amount_msat: self.amount_msat.wire2api(),
            comment: self.comment.wire2api(),
        }
    }
}
impl Wire2Api<LnUrlPayRequestData> for wire_LnUrlPayRequestData {
    fn wire2api(self) -> LnUrlPayRequestData {
        LnUrlPayRequestData {
            callback: self.callback.wire2api(),
            min_sendable: self.min_sendable.wire2api(),
            max_sendable: self.max_sendable.wire2api(),
            metadata_str: self.metadata_str.wire2api(),
            comment_allowed: self.comment_allowed.wire2api(),
            domain: self.domain.wire2api(),
            ln_address: self.ln_address.wire2api(),
        }
    }
}
impl Wire2Api<LnUrlWithdrawRequest> for wire_LnUrlWithdrawRequest {
    fn wire2api(self) -> LnUrlWithdrawRequest {
        LnUrlWithdrawRequest {
            data: self.data.wire2api(),
            amount_msat: self.amount_msat.wire2api(),
            description: self.description.wire2api(),
        }
    }
}
impl Wire2Api<LnUrlWithdrawRequestData> for wire_LnUrlWithdrawRequestData {
    fn wire2api(self) -> LnUrlWithdrawRequestData {
        LnUrlWithdrawRequestData {
            callback: self.callback.wire2api(),
            k1: self.k1.wire2api(),
            default_description: self.default_description.wire2api(),
            min_withdrawable: self.min_withdrawable.wire2api(),
            max_withdrawable: self.max_withdrawable.wire2api(),
        }
    }
}

impl Wire2Api<NodeConfig> for wire_NodeConfig {
    fn wire2api(self) -> NodeConfig {
        match self.tag {
            0 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Greenlight);
                NodeConfig::Greenlight {
                    config: ans.config.wire2api(),
                }
            },
            _ => unreachable!(),
        }
    }
}
impl Wire2Api<OpenChannelFeeRequest> for wire_OpenChannelFeeRequest {
    fn wire2api(self) -> OpenChannelFeeRequest {
        OpenChannelFeeRequest {
            amount_msat: self.amount_msat.wire2api(),
            expiry: self.expiry.wire2api(),
        }
    }
}
impl Wire2Api<OpeningFeeParams> for wire_OpeningFeeParams {
    fn wire2api(self) -> OpeningFeeParams {
        OpeningFeeParams {
            min_msat: self.min_msat.wire2api(),
            proportional: self.proportional.wire2api(),
            valid_until: self.valid_until.wire2api(),
            max_idle_time: self.max_idle_time.wire2api(),
            max_client_to_self_delay: self.max_client_to_self_delay.wire2api(),
            promise: self.promise.wire2api(),
        }
    }
}

impl Wire2Api<PrepareRefundRequest> for wire_PrepareRefundRequest {
    fn wire2api(self) -> PrepareRefundRequest {
        PrepareRefundRequest {
            swap_address: self.swap_address.wire2api(),
            to_address: self.to_address.wire2api(),
            sat_per_vbyte: self.sat_per_vbyte.wire2api(),
        }
    }
}
impl Wire2Api<PrepareSweepRequest> for wire_PrepareSweepRequest {
    fn wire2api(self) -> PrepareSweepRequest {
        PrepareSweepRequest {
            to_address: self.to_address.wire2api(),
            sats_per_vbyte: self.sats_per_vbyte.wire2api(),
        }
    }
}
impl Wire2Api<ReceiveOnchainRequest> for wire_ReceiveOnchainRequest {
    fn wire2api(self) -> ReceiveOnchainRequest {
        ReceiveOnchainRequest {
            opening_fee_params: self.opening_fee_params.wire2api(),
        }
    }
}
impl Wire2Api<ReceivePaymentRequest> for wire_ReceivePaymentRequest {
    fn wire2api(self) -> ReceivePaymentRequest {
        ReceivePaymentRequest {
            amount_msat: self.amount_msat.wire2api(),
            description: self.description.wire2api(),
            preimage: self.preimage.wire2api(),
            opening_fee_params: self.opening_fee_params.wire2api(),
            use_description_hash: self.use_description_hash.wire2api(),
            expiry: self.expiry.wire2api(),
            cltv: self.cltv.wire2api(),
        }
    }
}
impl Wire2Api<RefundRequest> for wire_RefundRequest {
    fn wire2api(self) -> RefundRequest {
        RefundRequest {
            swap_address: self.swap_address.wire2api(),
            to_address: self.to_address.wire2api(),
            sat_per_vbyte: self.sat_per_vbyte.wire2api(),
        }
    }
}
impl Wire2Api<ReverseSwapFeesRequest> for wire_ReverseSwapFeesRequest {
    fn wire2api(self) -> ReverseSwapFeesRequest {
        ReverseSwapFeesRequest {
            send_amount_sat: self.send_amount_sat.wire2api(),
        }
    }
}
impl Wire2Api<SendOnchainRequest> for wire_SendOnchainRequest {
    fn wire2api(self) -> SendOnchainRequest {
        SendOnchainRequest {
            amount_sat: self.amount_sat.wire2api(),
            onchain_recipient_address: self.onchain_recipient_address.wire2api(),
            pair_hash: self.pair_hash.wire2api(),
            sat_per_vbyte: self.sat_per_vbyte.wire2api(),
        }
    }
}
impl Wire2Api<SendPaymentRequest> for wire_SendPaymentRequest {
    fn wire2api(self) -> SendPaymentRequest {
        SendPaymentRequest {
            invoice: self.invoice.wire2api(),
            amount_msat: self.amount_msat.wire2api(),
        }
    }
}
impl Wire2Api<SendSpontaneousPaymentRequest> for wire_SendSpontaneousPaymentRequest {
    fn wire2api(self) -> SendSpontaneousPaymentRequest {
        SendSpontaneousPaymentRequest {
            node_id: self.node_id.wire2api(),
            amount_msat: self.amount_msat.wire2api(),
        }
    }
}
impl Wire2Api<SignMessageRequest> for wire_SignMessageRequest {
    fn wire2api(self) -> SignMessageRequest {
        SignMessageRequest {
            message: self.message.wire2api(),
        }
    }
}
impl Wire2Api<StaticBackupRequest> for wire_StaticBackupRequest {
    fn wire2api(self) -> StaticBackupRequest {
        StaticBackupRequest {
            working_dir: self.working_dir.wire2api(),
        }
    }
}
impl Wire2Api<SweepRequest> for wire_SweepRequest {
    fn wire2api(self) -> SweepRequest {
        SweepRequest {
            to_address: self.to_address.wire2api(),
            fee_rate_sats_per_vbyte: self.fee_rate_sats_per_vbyte.wire2api(),
        }
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_BuyBitcoinRequest {
    provider: i32,
    opening_fee_params: *mut wire_OpeningFeeParams,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_CheckMessageRequest {
    message: *mut wire_uint_8_list,
    pubkey: *mut wire_uint_8_list,
    signature: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Config {
    breezserver: *mut wire_uint_8_list,
    mempoolspace_url: *mut wire_uint_8_list,
    working_dir: *mut wire_uint_8_list,
    network: i32,
    payment_timeout_sec: u32,
    default_lsp_id: *mut wire_uint_8_list,
    api_key: *mut wire_uint_8_list,
    maxfee_percent: f64,
    exemptfee_msat: u64,
    node_config: wire_NodeConfig,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_GreenlightCredentials {
    device_key: *mut wire_uint_8_list,
    device_cert: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_GreenlightNodeConfig {
    partner_credentials: *mut wire_GreenlightCredentials,
    invite_code: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_payment_type_filter {
    ptr: *mut i32,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ListPaymentsRequest {
    filters: *mut wire_list_payment_type_filter,
    from_timestamp: *mut i64,
    to_timestamp: *mut i64,
    include_failures: *mut bool,
    offset: *mut u32,
    limit: *mut u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_LnUrlAuthRequestData {
    k1: *mut wire_uint_8_list,
    action: *mut wire_uint_8_list,
    domain: *mut wire_uint_8_list,
    url: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_LnUrlPayRequest {
    data: wire_LnUrlPayRequestData,
    amount_msat: u64,
    comment: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_LnUrlPayRequestData {
    callback: *mut wire_uint_8_list,
    min_sendable: u64,
    max_sendable: u64,
    metadata_str: *mut wire_uint_8_list,
    comment_allowed: u16,
    domain: *mut wire_uint_8_list,
    ln_address: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_LnUrlWithdrawRequest {
    data: wire_LnUrlWithdrawRequestData,
    amount_msat: u64,
    description: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_LnUrlWithdrawRequestData {
    callback: *mut wire_uint_8_list,
    k1: *mut wire_uint_8_list,
    default_description: *mut wire_uint_8_list,
    min_withdrawable: u64,
    max_withdrawable: u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_OpenChannelFeeRequest {
    amount_msat: u64,
    expiry: *mut u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_OpeningFeeParams {
    min_msat: u64,
    proportional: u32,
    valid_until: *mut wire_uint_8_list,
    max_idle_time: u32,
    max_client_to_self_delay: u32,
    promise: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_PrepareRefundRequest {
    swap_address: *mut wire_uint_8_list,
    to_address: *mut wire_uint_8_list,
    sat_per_vbyte: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_PrepareSweepRequest {
    to_address: *mut wire_uint_8_list,
    sats_per_vbyte: u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ReceiveOnchainRequest {
    opening_fee_params: *mut wire_OpeningFeeParams,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ReceivePaymentRequest {
    amount_msat: u64,
    description: *mut wire_uint_8_list,
    preimage: *mut wire_uint_8_list,
    opening_fee_params: *mut wire_OpeningFeeParams,
    use_description_hash: *mut bool,
    expiry: *mut u32,
    cltv: *mut u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RefundRequest {
    swap_address: *mut wire_uint_8_list,
    to_address: *mut wire_uint_8_list,
    sat_per_vbyte: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ReverseSwapFeesRequest {
    send_amount_sat: *mut u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SendOnchainRequest {
    amount_sat: u64,
    onchain_recipient_address: *mut wire_uint_8_list,
    pair_hash: *mut wire_uint_8_list,
    sat_per_vbyte: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SendPaymentRequest {
    invoice: *mut wire_uint_8_list,
    amount_msat: *mut u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SendSpontaneousPaymentRequest {
    node_id: *mut wire_uint_8_list,
    amount_msat: u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SignMessageRequest {
    message: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_StaticBackupRequest {
    working_dir: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SweepRequest {
    to_address: *mut wire_uint_8_list,
    fee_rate_sats_per_vbyte: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_NodeConfig {
    tag: i32,
    kind: *mut NodeConfigKind,
}

#[repr(C)]
pub union NodeConfigKind {
    Greenlight: *mut wire_NodeConfig_Greenlight,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_NodeConfig_Greenlight {
    config: *mut wire_GreenlightNodeConfig,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_BuyBitcoinRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            provider: Default::default(),
            opening_fee_params: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_BuyBitcoinRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_CheckMessageRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            message: core::ptr::null_mut(),
            pubkey: core::ptr::null_mut(),
            signature: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_CheckMessageRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_Config {
    fn new_with_null_ptr() -> Self {
        Self {
            breezserver: core::ptr::null_mut(),
            mempoolspace_url: core::ptr::null_mut(),
            working_dir: core::ptr::null_mut(),
            network: Default::default(),
            payment_timeout_sec: Default::default(),
            default_lsp_id: core::ptr::null_mut(),
            api_key: core::ptr::null_mut(),
            maxfee_percent: Default::default(),
            exemptfee_msat: Default::default(),
            node_config: Default::default(),
        }
    }
}

impl Default for wire_Config {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_GreenlightCredentials {
    fn new_with_null_ptr() -> Self {
        Self {
            device_key: core::ptr::null_mut(),
            device_cert: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_GreenlightCredentials {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_GreenlightNodeConfig {
    fn new_with_null_ptr() -> Self {
        Self {
            partner_credentials: core::ptr::null_mut(),
            invite_code: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_GreenlightNodeConfig {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ListPaymentsRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            filters: core::ptr::null_mut(),
            from_timestamp: core::ptr::null_mut(),
            to_timestamp: core::ptr::null_mut(),
            include_failures: core::ptr::null_mut(),
            offset: core::ptr::null_mut(),
            limit: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_ListPaymentsRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_LnUrlAuthRequestData {
    fn new_with_null_ptr() -> Self {
        Self {
            k1: core::ptr::null_mut(),
            action: core::ptr::null_mut(),
            domain: core::ptr::null_mut(),
            url: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_LnUrlAuthRequestData {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_LnUrlPayRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            data: Default::default(),
            amount_msat: Default::default(),
            comment: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_LnUrlPayRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_LnUrlPayRequestData {
    fn new_with_null_ptr() -> Self {
        Self {
            callback: core::ptr::null_mut(),
            min_sendable: Default::default(),
            max_sendable: Default::default(),
            metadata_str: core::ptr::null_mut(),
            comment_allowed: Default::default(),
            domain: core::ptr::null_mut(),
            ln_address: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_LnUrlPayRequestData {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_LnUrlWithdrawRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            data: Default::default(),
            amount_msat: Default::default(),
            description: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_LnUrlWithdrawRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_LnUrlWithdrawRequestData {
    fn new_with_null_ptr() -> Self {
        Self {
            callback: core::ptr::null_mut(),
            k1: core::ptr::null_mut(),
            default_description: core::ptr::null_mut(),
            min_withdrawable: Default::default(),
            max_withdrawable: Default::default(),
        }
    }
}

impl Default for wire_LnUrlWithdrawRequestData {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl Default for wire_NodeConfig {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_NodeConfig {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_NodeConfig_Greenlight() -> *mut NodeConfigKind {
    support::new_leak_box_ptr(NodeConfigKind {
        Greenlight: support::new_leak_box_ptr(wire_NodeConfig_Greenlight {
            config: core::ptr::null_mut(),
        }),
    })
}

impl NewWithNullPtr for wire_OpenChannelFeeRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            amount_msat: Default::default(),
            expiry: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_OpenChannelFeeRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_OpeningFeeParams {
    fn new_with_null_ptr() -> Self {
        Self {
            min_msat: Default::default(),
            proportional: Default::default(),
            valid_until: core::ptr::null_mut(),
            max_idle_time: Default::default(),
            max_client_to_self_delay: Default::default(),
            promise: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_OpeningFeeParams {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_PrepareRefundRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            swap_address: core::ptr::null_mut(),
            to_address: core::ptr::null_mut(),
            sat_per_vbyte: Default::default(),
        }
    }
}

impl Default for wire_PrepareRefundRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_PrepareSweepRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            to_address: core::ptr::null_mut(),
            sats_per_vbyte: Default::default(),
        }
    }
}

impl Default for wire_PrepareSweepRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ReceiveOnchainRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            opening_fee_params: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_ReceiveOnchainRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ReceivePaymentRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            amount_msat: Default::default(),
            description: core::ptr::null_mut(),
            preimage: core::ptr::null_mut(),
            opening_fee_params: core::ptr::null_mut(),
            use_description_hash: core::ptr::null_mut(),
            expiry: core::ptr::null_mut(),
            cltv: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_ReceivePaymentRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_RefundRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            swap_address: core::ptr::null_mut(),
            to_address: core::ptr::null_mut(),
            sat_per_vbyte: Default::default(),
        }
    }
}

impl Default for wire_RefundRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ReverseSwapFeesRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            send_amount_sat: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_ReverseSwapFeesRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SendOnchainRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            amount_sat: Default::default(),
            onchain_recipient_address: core::ptr::null_mut(),
            pair_hash: core::ptr::null_mut(),
            sat_per_vbyte: Default::default(),
        }
    }
}

impl Default for wire_SendOnchainRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SendPaymentRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            invoice: core::ptr::null_mut(),
            amount_msat: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_SendPaymentRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SendSpontaneousPaymentRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            node_id: core::ptr::null_mut(),
            amount_msat: Default::default(),
        }
    }
}

impl Default for wire_SendSpontaneousPaymentRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SignMessageRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            message: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_SignMessageRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_StaticBackupRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            working_dir: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_StaticBackupRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SweepRequest {
    fn new_with_null_ptr() -> Self {
        Self {
            to_address: core::ptr::null_mut(),
            fee_rate_sats_per_vbyte: Default::default(),
        }
    }
}

impl Default for wire_SweepRequest {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
