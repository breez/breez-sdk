#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

#define SWAP_PAYMENT_FEE_EXPIRY_SECONDS (((60 * 60) * 24) * 2)

#define INVOICE_PAYMENT_FEE_EXPIRY_SECONDS (60 * 60)

#define ESTIMATED_CLAIM_TX_VSIZE 138

#define ESTIMATED_LOCKUP_TX_VSIZE 153

#define MOCK_REVERSE_SWAP_MIN 50000

#define MOCK_REVERSE_SWAP_MAX 1000000

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_GreenlightCredentials {
  struct wire_uint_8_list *developer_key;
  struct wire_uint_8_list *developer_cert;
} wire_GreenlightCredentials;

typedef struct wire_GreenlightNodeConfig {
  struct wire_GreenlightCredentials *partner_credentials;
  struct wire_uint_8_list *invite_code;
} wire_GreenlightNodeConfig;

typedef struct wire_NodeConfig_Greenlight {
  struct wire_GreenlightNodeConfig *config;
} wire_NodeConfig_Greenlight;

typedef union NodeConfigKind {
  struct wire_NodeConfig_Greenlight *Greenlight;
} NodeConfigKind;

typedef struct wire_NodeConfig {
  int32_t tag;
  union NodeConfigKind *kind;
} wire_NodeConfig;

typedef struct wire_Config {
  struct wire_uint_8_list *breezserver;
  struct wire_uint_8_list *chainnotifier_url;
  struct wire_uint_8_list *mempoolspace_url;
  struct wire_uint_8_list *working_dir;
  int32_t network;
  uint32_t payment_timeout_sec;
  struct wire_uint_8_list *default_lsp_id;
  struct wire_uint_8_list *api_key;
  double maxfee_percent;
  uint64_t exemptfee_msat;
  struct wire_NodeConfig node_config;
} wire_Config;

typedef struct wire_ConnectRequest {
  struct wire_Config config;
  struct wire_uint_8_list *seed;
  bool *restore_only;
} wire_ConnectRequest;

typedef struct wire_ConfigureNodeRequest {
  struct wire_uint_8_list *close_to_address;
} wire_ConfigureNodeRequest;

typedef struct wire_SignMessageRequest {
  struct wire_uint_8_list *message;
} wire_SignMessageRequest;

typedef struct wire_CheckMessageRequest {
  struct wire_uint_8_list *message;
  struct wire_uint_8_list *pubkey;
  struct wire_uint_8_list *signature;
} wire_CheckMessageRequest;

typedef struct wire_StaticBackupRequest {
  struct wire_uint_8_list *working_dir;
} wire_StaticBackupRequest;

typedef struct wire_list_payment_type_filter {
  int32_t *ptr;
  int32_t len;
} wire_list_payment_type_filter;

typedef struct wire_MetadataFilter {
  struct wire_uint_8_list *json_path;
  struct wire_uint_8_list *json_value;
} wire_MetadataFilter;

typedef struct wire_list_metadata_filter {
  struct wire_MetadataFilter *ptr;
  int32_t len;
} wire_list_metadata_filter;

typedef struct wire_ListPaymentsRequest {
  struct wire_list_payment_type_filter *filters;
  struct wire_list_metadata_filter *metadata_filters;
  int64_t *from_timestamp;
  int64_t *to_timestamp;
  bool *include_failures;
  uint32_t *offset;
  uint32_t *limit;
} wire_ListPaymentsRequest;

typedef struct wire_SendPaymentRequest {
  struct wire_uint_8_list *bolt11;
  uint64_t *amount_msat;
  struct wire_uint_8_list *label;
  uint64_t *pending_timeout_sec;
} wire_SendPaymentRequest;

typedef struct wire_TlvEntry {
  uint64_t field_number;
  struct wire_uint_8_list *value;
} wire_TlvEntry;

typedef struct wire_list_tlv_entry {
  struct wire_TlvEntry *ptr;
  int32_t len;
} wire_list_tlv_entry;

typedef struct wire_SendSpontaneousPaymentRequest {
  struct wire_uint_8_list *node_id;
  uint64_t amount_msat;
  struct wire_list_tlv_entry *extra_tlvs;
  struct wire_uint_8_list *label;
} wire_SendSpontaneousPaymentRequest;

typedef struct wire_OpeningFeeParams {
  uint64_t min_msat;
  uint32_t proportional;
  struct wire_uint_8_list *valid_until;
  uint32_t max_idle_time;
  uint32_t max_client_to_self_delay;
  struct wire_uint_8_list *promise;
} wire_OpeningFeeParams;

typedef struct wire_ReceivePaymentRequest {
  uint64_t amount_msat;
  struct wire_uint_8_list *description;
  struct wire_uint_8_list *preimage;
  struct wire_OpeningFeeParams *opening_fee_params;
  bool *use_description_hash;
  uint32_t *expiry;
  uint32_t *cltv;
} wire_ReceivePaymentRequest;

typedef struct wire_LnUrlPayRequestData {
  struct wire_uint_8_list *callback;
  uint64_t min_sendable;
  uint64_t max_sendable;
  struct wire_uint_8_list *metadata_str;
  uint16_t comment_allowed;
  struct wire_uint_8_list *domain;
  bool allows_nostr;
  struct wire_uint_8_list *nostr_pubkey;
  struct wire_uint_8_list *ln_address;
} wire_LnUrlPayRequestData;

typedef struct wire_LnUrlPayRequest {
  struct wire_LnUrlPayRequestData data;
  uint64_t amount_msat;
  struct wire_uint_8_list *comment;
  struct wire_uint_8_list *payment_label;
} wire_LnUrlPayRequest;

typedef struct wire_LnUrlWithdrawRequestData {
  struct wire_uint_8_list *callback;
  struct wire_uint_8_list *k1;
  struct wire_uint_8_list *default_description;
  uint64_t min_withdrawable;
  uint64_t max_withdrawable;
} wire_LnUrlWithdrawRequestData;

typedef struct wire_LnUrlWithdrawRequest {
  struct wire_LnUrlWithdrawRequestData data;
  uint64_t amount_msat;
  struct wire_uint_8_list *description;
} wire_LnUrlWithdrawRequest;

typedef struct wire_LnUrlAuthRequestData {
  struct wire_uint_8_list *k1;
  struct wire_uint_8_list *action;
  struct wire_uint_8_list *domain;
  struct wire_uint_8_list *url;
} wire_LnUrlAuthRequestData;

typedef struct wire_ReportPaymentFailureDetails {
  struct wire_uint_8_list *payment_hash;
  struct wire_uint_8_list *comment;
} wire_ReportPaymentFailureDetails;

typedef struct wire_ReportIssueRequest_PaymentFailure {
  struct wire_ReportPaymentFailureDetails *data;
} wire_ReportIssueRequest_PaymentFailure;

typedef union ReportIssueRequestKind {
  struct wire_ReportIssueRequest_PaymentFailure *PaymentFailure;
} ReportIssueRequestKind;

typedef struct wire_ReportIssueRequest {
  int32_t tag;
  union ReportIssueRequestKind *kind;
} wire_ReportIssueRequest;

typedef struct wire_SendOnchainRequest {
  uint64_t amount_sat;
  struct wire_uint_8_list *onchain_recipient_address;
  struct wire_uint_8_list *pair_hash;
  uint32_t sat_per_vbyte;
} wire_SendOnchainRequest;

typedef struct wire_PrepareOnchainPaymentResponse {
  struct wire_uint_8_list *fees_hash;
  double fees_percentage;
  uint64_t fees_lockup;
  uint64_t fees_claim;
  uint64_t sender_amount_sat;
  uint64_t recipient_amount_sat;
  uint64_t total_fees;
} wire_PrepareOnchainPaymentResponse;

typedef struct wire_PayOnchainRequest {
  struct wire_uint_8_list *recipient_address;
  struct wire_PrepareOnchainPaymentResponse prepare_res;
} wire_PayOnchainRequest;

typedef struct wire_ReceiveOnchainRequest {
  struct wire_OpeningFeeParams *opening_fee_params;
} wire_ReceiveOnchainRequest;

typedef struct wire_BuyBitcoinRequest {
  int32_t provider;
  struct wire_OpeningFeeParams *opening_fee_params;
} wire_BuyBitcoinRequest;

typedef struct wire_RedeemOnchainFundsRequest {
  struct wire_uint_8_list *to_address;
  uint32_t sat_per_vbyte;
} wire_RedeemOnchainFundsRequest;

typedef struct wire_PrepareRedeemOnchainFundsRequest {
  struct wire_uint_8_list *to_address;
  uint32_t sat_per_vbyte;
} wire_PrepareRedeemOnchainFundsRequest;

typedef struct wire_PrepareRefundRequest {
  struct wire_uint_8_list *swap_address;
  struct wire_uint_8_list *to_address;
  uint32_t sat_per_vbyte;
} wire_PrepareRefundRequest;

typedef struct wire_RefundRequest {
  struct wire_uint_8_list *swap_address;
  struct wire_uint_8_list *to_address;
  uint32_t sat_per_vbyte;
} wire_RefundRequest;

typedef struct wire_OpenChannelFeeRequest {
  uint64_t *amount_msat;
  uint32_t *expiry;
} wire_OpenChannelFeeRequest;

typedef struct wire_ReverseSwapFeesRequest {
  uint64_t *send_amount_sat;
  uint32_t *claim_tx_feerate;
} wire_ReverseSwapFeesRequest;

typedef struct wire_PrepareOnchainPaymentRequest {
  uint64_t amount_sat;
  int32_t amount_type;
  uint32_t claim_tx_feerate;
} wire_PrepareOnchainPaymentRequest;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_connect(int64_t port_, struct wire_ConnectRequest *req);

void wire_is_initialized(int64_t port_);

void wire_sync(int64_t port_);

void wire_node_credentials(int64_t port_);

void wire_node_info(int64_t port_);

void wire_configure_node(int64_t port_, struct wire_ConfigureNodeRequest *req);

void wire_disconnect(int64_t port_);

void wire_sign_message(int64_t port_, struct wire_SignMessageRequest *req);

void wire_check_message(int64_t port_, struct wire_CheckMessageRequest *req);

void wire_mnemonic_to_seed(int64_t port_, struct wire_uint_8_list *phrase);

void wire_default_config(int64_t port_,
                         int32_t env_type,
                         struct wire_uint_8_list *api_key,
                         struct wire_NodeConfig *node_config);

void wire_static_backup(int64_t port_, struct wire_StaticBackupRequest *req);

void wire_service_health_check(int64_t port_, struct wire_uint_8_list *api_key);

void wire_breez_events_stream(int64_t port_);

void wire_breez_log_stream(int64_t port_);

void wire_list_lsps(int64_t port_);

void wire_connect_lsp(int64_t port_, struct wire_uint_8_list *lsp_id);

void wire_lsp_id(int64_t port_);

void wire_fetch_lsp_info(int64_t port_, struct wire_uint_8_list *id);

void wire_lsp_info(int64_t port_);

void wire_close_lsp_channels(int64_t port_);

void wire_register_webhook(int64_t port_, struct wire_uint_8_list *webhook_url);

void wire_unregister_webhook(int64_t port_, struct wire_uint_8_list *webhook_url);

void wire_backup(int64_t port_);

void wire_backup_status(int64_t port_);

void wire_parse_invoice(int64_t port_, struct wire_uint_8_list *invoice);

void wire_parse_input(int64_t port_, struct wire_uint_8_list *input);

void wire_list_payments(int64_t port_, struct wire_ListPaymentsRequest *req);

void wire_payment_by_hash(int64_t port_, struct wire_uint_8_list *hash);

void wire_set_payment_metadata(int64_t port_,
                               struct wire_uint_8_list *hash,
                               struct wire_uint_8_list *metadata);

void wire_send_payment(int64_t port_, struct wire_SendPaymentRequest *req);

void wire_send_spontaneous_payment(int64_t port_, struct wire_SendSpontaneousPaymentRequest *req);

void wire_receive_payment(int64_t port_, struct wire_ReceivePaymentRequest *req);

void wire_lnurl_pay(int64_t port_, struct wire_LnUrlPayRequest *req);

void wire_lnurl_withdraw(int64_t port_, struct wire_LnUrlWithdrawRequest *req);

void wire_lnurl_auth(int64_t port_, struct wire_LnUrlAuthRequestData *req_data);

void wire_report_issue(int64_t port_, struct wire_ReportIssueRequest *req);

void wire_fetch_fiat_rates(int64_t port_);

void wire_list_fiat_currencies(int64_t port_);

void wire_max_reverse_swap_amount(int64_t port_);

void wire_send_onchain(int64_t port_, struct wire_SendOnchainRequest *req);

void wire_pay_onchain(int64_t port_, struct wire_PayOnchainRequest *req);

void wire_receive_onchain(int64_t port_, struct wire_ReceiveOnchainRequest *req);

void wire_buy_bitcoin(int64_t port_, struct wire_BuyBitcoinRequest *req);

void wire_redeem_onchain_funds(int64_t port_, struct wire_RedeemOnchainFundsRequest *req);

void wire_prepare_redeem_onchain_funds(int64_t port_,
                                       struct wire_PrepareRedeemOnchainFundsRequest *req);

void wire_list_refundables(int64_t port_);

void wire_prepare_refund(int64_t port_, struct wire_PrepareRefundRequest *req);

void wire_refund(int64_t port_, struct wire_RefundRequest *req);

void wire_rescan_swaps(int64_t port_);

void wire_redeem_swap(int64_t port_, struct wire_uint_8_list *swap_address);

void wire_in_progress_swap(int64_t port_);

void wire_in_progress_reverse_swaps(int64_t port_);

void wire_open_channel_fee(int64_t port_, struct wire_OpenChannelFeeRequest *req);

void wire_fetch_reverse_swap_fees(int64_t port_, struct wire_ReverseSwapFeesRequest *req);

void wire_onchain_payment_limits(int64_t port_);

void wire_prepare_onchain_payment(int64_t port_, struct wire_PrepareOnchainPaymentRequest *req);

void wire_in_progress_onchain_payments(int64_t port_);

void wire_recommended_fees(int64_t port_);

void wire_execute_command(int64_t port_, struct wire_uint_8_list *command);

void wire_generate_diagnostic_data(int64_t port_);

bool *new_box_autoadd_bool_0(bool value);

struct wire_BuyBitcoinRequest *new_box_autoadd_buy_bitcoin_request_0(void);

struct wire_CheckMessageRequest *new_box_autoadd_check_message_request_0(void);

struct wire_ConfigureNodeRequest *new_box_autoadd_configure_node_request_0(void);

struct wire_ConnectRequest *new_box_autoadd_connect_request_0(void);

struct wire_GreenlightCredentials *new_box_autoadd_greenlight_credentials_0(void);

struct wire_GreenlightNodeConfig *new_box_autoadd_greenlight_node_config_0(void);

int64_t *new_box_autoadd_i64_0(int64_t value);

struct wire_ListPaymentsRequest *new_box_autoadd_list_payments_request_0(void);

struct wire_LnUrlAuthRequestData *new_box_autoadd_ln_url_auth_request_data_0(void);

struct wire_LnUrlPayRequest *new_box_autoadd_ln_url_pay_request_0(void);

struct wire_LnUrlWithdrawRequest *new_box_autoadd_ln_url_withdraw_request_0(void);

struct wire_NodeConfig *new_box_autoadd_node_config_0(void);

struct wire_OpenChannelFeeRequest *new_box_autoadd_open_channel_fee_request_0(void);

struct wire_OpeningFeeParams *new_box_autoadd_opening_fee_params_0(void);

struct wire_PayOnchainRequest *new_box_autoadd_pay_onchain_request_0(void);

struct wire_PrepareOnchainPaymentRequest *new_box_autoadd_prepare_onchain_payment_request_0(void);

struct wire_PrepareRedeemOnchainFundsRequest *new_box_autoadd_prepare_redeem_onchain_funds_request_0(void);

struct wire_PrepareRefundRequest *new_box_autoadd_prepare_refund_request_0(void);

struct wire_ReceiveOnchainRequest *new_box_autoadd_receive_onchain_request_0(void);

struct wire_ReceivePaymentRequest *new_box_autoadd_receive_payment_request_0(void);

struct wire_RedeemOnchainFundsRequest *new_box_autoadd_redeem_onchain_funds_request_0(void);

struct wire_RefundRequest *new_box_autoadd_refund_request_0(void);

struct wire_ReportIssueRequest *new_box_autoadd_report_issue_request_0(void);

struct wire_ReportPaymentFailureDetails *new_box_autoadd_report_payment_failure_details_0(void);

struct wire_ReverseSwapFeesRequest *new_box_autoadd_reverse_swap_fees_request_0(void);

struct wire_SendOnchainRequest *new_box_autoadd_send_onchain_request_0(void);

struct wire_SendPaymentRequest *new_box_autoadd_send_payment_request_0(void);

struct wire_SendSpontaneousPaymentRequest *new_box_autoadd_send_spontaneous_payment_request_0(void);

struct wire_SignMessageRequest *new_box_autoadd_sign_message_request_0(void);

struct wire_StaticBackupRequest *new_box_autoadd_static_backup_request_0(void);

uint32_t *new_box_autoadd_u32_0(uint32_t value);

uint64_t *new_box_autoadd_u64_0(uint64_t value);

struct wire_list_metadata_filter *new_list_metadata_filter_0(int32_t len);

struct wire_list_payment_type_filter *new_list_payment_type_filter_0(int32_t len);

struct wire_list_tlv_entry *new_list_tlv_entry_0(int32_t len);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

union NodeConfigKind *inflate_NodeConfig_Greenlight(void);

union ReportIssueRequestKind *inflate_ReportIssueRequest_PaymentFailure(void);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_connect);
    dummy_var ^= ((int64_t) (void*) wire_is_initialized);
    dummy_var ^= ((int64_t) (void*) wire_sync);
    dummy_var ^= ((int64_t) (void*) wire_node_credentials);
    dummy_var ^= ((int64_t) (void*) wire_node_info);
    dummy_var ^= ((int64_t) (void*) wire_configure_node);
    dummy_var ^= ((int64_t) (void*) wire_disconnect);
    dummy_var ^= ((int64_t) (void*) wire_sign_message);
    dummy_var ^= ((int64_t) (void*) wire_check_message);
    dummy_var ^= ((int64_t) (void*) wire_mnemonic_to_seed);
    dummy_var ^= ((int64_t) (void*) wire_default_config);
    dummy_var ^= ((int64_t) (void*) wire_static_backup);
    dummy_var ^= ((int64_t) (void*) wire_service_health_check);
    dummy_var ^= ((int64_t) (void*) wire_breez_events_stream);
    dummy_var ^= ((int64_t) (void*) wire_breez_log_stream);
    dummy_var ^= ((int64_t) (void*) wire_list_lsps);
    dummy_var ^= ((int64_t) (void*) wire_connect_lsp);
    dummy_var ^= ((int64_t) (void*) wire_lsp_id);
    dummy_var ^= ((int64_t) (void*) wire_fetch_lsp_info);
    dummy_var ^= ((int64_t) (void*) wire_lsp_info);
    dummy_var ^= ((int64_t) (void*) wire_close_lsp_channels);
    dummy_var ^= ((int64_t) (void*) wire_register_webhook);
    dummy_var ^= ((int64_t) (void*) wire_unregister_webhook);
    dummy_var ^= ((int64_t) (void*) wire_backup);
    dummy_var ^= ((int64_t) (void*) wire_backup_status);
    dummy_var ^= ((int64_t) (void*) wire_parse_invoice);
    dummy_var ^= ((int64_t) (void*) wire_parse_input);
    dummy_var ^= ((int64_t) (void*) wire_list_payments);
    dummy_var ^= ((int64_t) (void*) wire_payment_by_hash);
    dummy_var ^= ((int64_t) (void*) wire_set_payment_metadata);
    dummy_var ^= ((int64_t) (void*) wire_send_payment);
    dummy_var ^= ((int64_t) (void*) wire_send_spontaneous_payment);
    dummy_var ^= ((int64_t) (void*) wire_receive_payment);
    dummy_var ^= ((int64_t) (void*) wire_lnurl_pay);
    dummy_var ^= ((int64_t) (void*) wire_lnurl_withdraw);
    dummy_var ^= ((int64_t) (void*) wire_lnurl_auth);
    dummy_var ^= ((int64_t) (void*) wire_report_issue);
    dummy_var ^= ((int64_t) (void*) wire_fetch_fiat_rates);
    dummy_var ^= ((int64_t) (void*) wire_list_fiat_currencies);
    dummy_var ^= ((int64_t) (void*) wire_max_reverse_swap_amount);
    dummy_var ^= ((int64_t) (void*) wire_send_onchain);
    dummy_var ^= ((int64_t) (void*) wire_pay_onchain);
    dummy_var ^= ((int64_t) (void*) wire_receive_onchain);
    dummy_var ^= ((int64_t) (void*) wire_buy_bitcoin);
    dummy_var ^= ((int64_t) (void*) wire_redeem_onchain_funds);
    dummy_var ^= ((int64_t) (void*) wire_prepare_redeem_onchain_funds);
    dummy_var ^= ((int64_t) (void*) wire_list_refundables);
    dummy_var ^= ((int64_t) (void*) wire_prepare_refund);
    dummy_var ^= ((int64_t) (void*) wire_refund);
    dummy_var ^= ((int64_t) (void*) wire_rescan_swaps);
    dummy_var ^= ((int64_t) (void*) wire_redeem_swap);
    dummy_var ^= ((int64_t) (void*) wire_in_progress_swap);
    dummy_var ^= ((int64_t) (void*) wire_in_progress_reverse_swaps);
    dummy_var ^= ((int64_t) (void*) wire_open_channel_fee);
    dummy_var ^= ((int64_t) (void*) wire_fetch_reverse_swap_fees);
    dummy_var ^= ((int64_t) (void*) wire_onchain_payment_limits);
    dummy_var ^= ((int64_t) (void*) wire_prepare_onchain_payment);
    dummy_var ^= ((int64_t) (void*) wire_in_progress_onchain_payments);
    dummy_var ^= ((int64_t) (void*) wire_recommended_fees);
    dummy_var ^= ((int64_t) (void*) wire_execute_command);
    dummy_var ^= ((int64_t) (void*) wire_generate_diagnostic_data);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_bool_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_buy_bitcoin_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_check_message_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_configure_node_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_connect_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_greenlight_credentials_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_greenlight_node_config_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_i64_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_list_payments_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ln_url_auth_request_data_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ln_url_pay_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ln_url_withdraw_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_node_config_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_open_channel_fee_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_opening_fee_params_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_pay_onchain_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_prepare_onchain_payment_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_prepare_redeem_onchain_funds_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_prepare_refund_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_receive_onchain_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_receive_payment_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_redeem_onchain_funds_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_refund_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_report_issue_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_report_payment_failure_details_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_reverse_swap_fees_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_send_onchain_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_send_payment_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_send_spontaneous_payment_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_sign_message_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_static_backup_request_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u32_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u64_0);
    dummy_var ^= ((int64_t) (void*) new_list_metadata_filter_0);
    dummy_var ^= ((int64_t) (void*) new_list_payment_type_filter_0);
    dummy_var ^= ((int64_t) (void*) new_list_tlv_entry_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) inflate_NodeConfig_Greenlight);
    dummy_var ^= ((int64_t) (void*) inflate_ReportIssueRequest_PaymentFailure);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
