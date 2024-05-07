#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
// EXTRA BEGIN
typedef struct DartCObject *WireSyncRust2DartDco;
typedef struct WireSyncRust2DartSse {
  uint8_t *ptr;
  int32_t len;
} WireSyncRust2DartSse;

typedef int64_t DartPort;
typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);
void store_dart_post_cobject(DartPostCObjectFnType ptr);
// EXTRA END
typedef struct _Dart_Handle* Dart_Handle;

#define SWAP_PAYMENT_FEE_EXPIRY_SECONDS (((60 * 60) * 24) * 2)

#define INVOICE_PAYMENT_FEE_EXPIRY_SECONDS (60 * 60)

#define ESTIMATED_CLAIM_TX_VSIZE 138

#define ESTIMATED_LOCKUP_TX_VSIZE 153

typedef struct wire_cst_list_prim_u_8_strict {
  uint8_t *ptr;
  int32_t len;
} wire_cst_list_prim_u_8_strict;

typedef struct wire_cst_opening_fee_params {
  uint64_t min_msat;
  uint32_t proportional;
  struct wire_cst_list_prim_u_8_strict *valid_until;
  uint32_t max_idle_time;
  uint32_t max_client_to_self_delay;
  struct wire_cst_list_prim_u_8_strict *promise;
} wire_cst_opening_fee_params;

typedef struct wire_cst_buy_bitcoin_request {
  int32_t provider;
  struct wire_cst_opening_fee_params *opening_fee_params;
} wire_cst_buy_bitcoin_request;

typedef struct wire_cst_check_message_request {
  struct wire_cst_list_prim_u_8_strict *message;
  struct wire_cst_list_prim_u_8_strict *pubkey;
  struct wire_cst_list_prim_u_8_strict *signature;
} wire_cst_check_message_request;

typedef struct wire_cst_configure_node_request {
  struct wire_cst_list_prim_u_8_strict *close_to_address;
} wire_cst_configure_node_request;

typedef struct wire_cst_greenlight_credentials {
  struct wire_cst_list_prim_u_8_strict *device_key;
  struct wire_cst_list_prim_u_8_strict *device_cert;
} wire_cst_greenlight_credentials;

typedef struct wire_cst_greenlight_node_config {
  struct wire_cst_greenlight_credentials *partner_credentials;
  struct wire_cst_list_prim_u_8_strict *invite_code;
} wire_cst_greenlight_node_config;

typedef struct wire_cst_NodeConfig_Greenlight {
  struct wire_cst_greenlight_node_config *config;
} wire_cst_NodeConfig_Greenlight;

typedef union NodeConfigKind {
  struct wire_cst_NodeConfig_Greenlight Greenlight;
} NodeConfigKind;

typedef struct wire_cst_node_config {
  int32_t tag;
  union NodeConfigKind kind;
} wire_cst_node_config;

typedef struct wire_cst_config {
  struct wire_cst_list_prim_u_8_strict *breezserver;
  struct wire_cst_list_prim_u_8_strict *chainnotifier_url;
  struct wire_cst_list_prim_u_8_strict *mempoolspace_url;
  struct wire_cst_list_prim_u_8_strict *working_dir;
  int32_t network;
  uint32_t payment_timeout_sec;
  struct wire_cst_list_prim_u_8_strict *default_lsp_id;
  struct wire_cst_list_prim_u_8_strict *api_key;
  double maxfee_percent;
  uint64_t exemptfee_msat;
  struct wire_cst_node_config node_config;
} wire_cst_config;

typedef struct wire_cst_connect_request {
  struct wire_cst_config config;
  struct wire_cst_list_prim_u_8_strict *seed;
  bool *restore_only;
} wire_cst_connect_request;

typedef struct wire_cst_reverse_swap_fees_request {
  uint64_t *send_amount_sat;
  uint32_t *claim_tx_feerate;
} wire_cst_reverse_swap_fees_request;

typedef struct wire_cst_list_payment_type_filter {
  int32_t *ptr;
  int32_t len;
} wire_cst_list_payment_type_filter;

typedef struct wire_cst_metadata_filter {
  struct wire_cst_list_prim_u_8_strict *json_path;
  struct wire_cst_list_prim_u_8_strict *json_value;
} wire_cst_metadata_filter;

typedef struct wire_cst_list_metadata_filter {
  struct wire_cst_metadata_filter *ptr;
  int32_t len;
} wire_cst_list_metadata_filter;

typedef struct wire_cst_list_payments_request {
  struct wire_cst_list_payment_type_filter *filters;
  struct wire_cst_list_metadata_filter *metadata_filters;
  int64_t *from_timestamp;
  int64_t *to_timestamp;
  bool *include_failures;
  uint32_t *offset;
  uint32_t *limit;
} wire_cst_list_payments_request;

typedef struct wire_cst_ln_url_auth_request_data {
  struct wire_cst_list_prim_u_8_strict *k1;
  struct wire_cst_list_prim_u_8_strict *action;
  struct wire_cst_list_prim_u_8_strict *domain;
  struct wire_cst_list_prim_u_8_strict *url;
} wire_cst_ln_url_auth_request_data;

typedef struct wire_cst_ln_url_pay_request_data {
  struct wire_cst_list_prim_u_8_strict *callback;
  uint64_t min_sendable;
  uint64_t max_sendable;
  struct wire_cst_list_prim_u_8_strict *metadata_str;
  uint16_t comment_allowed;
  struct wire_cst_list_prim_u_8_strict *domain;
  bool allows_nostr;
  struct wire_cst_list_prim_u_8_strict *nostr_pubkey;
  struct wire_cst_list_prim_u_8_strict *ln_address;
} wire_cst_ln_url_pay_request_data;

typedef struct wire_cst_ln_url_pay_request {
  struct wire_cst_ln_url_pay_request_data data;
  uint64_t amount_msat;
  struct wire_cst_list_prim_u_8_strict *comment;
  struct wire_cst_list_prim_u_8_strict *payment_label;
} wire_cst_ln_url_pay_request;

typedef struct wire_cst_ln_url_withdraw_request_data {
  struct wire_cst_list_prim_u_8_strict *callback;
  struct wire_cst_list_prim_u_8_strict *k1;
  struct wire_cst_list_prim_u_8_strict *default_description;
  uint64_t min_withdrawable;
  uint64_t max_withdrawable;
} wire_cst_ln_url_withdraw_request_data;

typedef struct wire_cst_ln_url_withdraw_request {
  struct wire_cst_ln_url_withdraw_request_data data;
  uint64_t amount_msat;
  struct wire_cst_list_prim_u_8_strict *description;
} wire_cst_ln_url_withdraw_request;

typedef struct wire_cst_open_channel_fee_request {
  uint64_t *amount_msat;
  uint32_t *expiry;
} wire_cst_open_channel_fee_request;

typedef struct wire_cst_prepare_onchain_payment_response {
  struct wire_cst_list_prim_u_8_strict *fees_hash;
  double fees_percentage;
  uint64_t fees_lockup;
  uint64_t fees_claim;
  uint64_t sender_amount_sat;
  uint64_t recipient_amount_sat;
  uint64_t total_fees;
} wire_cst_prepare_onchain_payment_response;

typedef struct wire_cst_pay_onchain_request {
  struct wire_cst_list_prim_u_8_strict *recipient_address;
  struct wire_cst_prepare_onchain_payment_response prepare_res;
} wire_cst_pay_onchain_request;

typedef struct wire_cst_prepare_onchain_payment_request {
  uint64_t amount_sat;
  int32_t amount_type;
  uint32_t claim_tx_feerate;
} wire_cst_prepare_onchain_payment_request;

typedef struct wire_cst_prepare_redeem_onchain_funds_request {
  struct wire_cst_list_prim_u_8_strict *to_address;
  uint32_t sat_per_vbyte;
} wire_cst_prepare_redeem_onchain_funds_request;

typedef struct wire_cst_prepare_refund_request {
  struct wire_cst_list_prim_u_8_strict *swap_address;
  struct wire_cst_list_prim_u_8_strict *to_address;
  uint32_t sat_per_vbyte;
} wire_cst_prepare_refund_request;

typedef struct wire_cst_receive_onchain_request {
  struct wire_cst_opening_fee_params *opening_fee_params;
} wire_cst_receive_onchain_request;

typedef struct wire_cst_receive_payment_request {
  uint64_t amount_msat;
  struct wire_cst_list_prim_u_8_strict *description;
  struct wire_cst_list_prim_u_8_strict *preimage;
  struct wire_cst_opening_fee_params *opening_fee_params;
  bool *use_description_hash;
  uint32_t *expiry;
  uint32_t *cltv;
} wire_cst_receive_payment_request;

typedef struct wire_cst_redeem_onchain_funds_request {
  struct wire_cst_list_prim_u_8_strict *to_address;
  uint32_t sat_per_vbyte;
} wire_cst_redeem_onchain_funds_request;

typedef struct wire_cst_refund_request {
  struct wire_cst_list_prim_u_8_strict *swap_address;
  struct wire_cst_list_prim_u_8_strict *to_address;
  uint32_t sat_per_vbyte;
} wire_cst_refund_request;

typedef struct wire_cst_report_payment_failure_details {
  struct wire_cst_list_prim_u_8_strict *payment_hash;
  struct wire_cst_list_prim_u_8_strict *comment;
} wire_cst_report_payment_failure_details;

typedef struct wire_cst_ReportIssueRequest_PaymentFailure {
  struct wire_cst_report_payment_failure_details *data;
} wire_cst_ReportIssueRequest_PaymentFailure;

typedef union ReportIssueRequestKind {
  struct wire_cst_ReportIssueRequest_PaymentFailure PaymentFailure;
} ReportIssueRequestKind;

typedef struct wire_cst_report_issue_request {
  int32_t tag;
  union ReportIssueRequestKind kind;
} wire_cst_report_issue_request;

typedef struct wire_cst_send_onchain_request {
  uint64_t amount_sat;
  struct wire_cst_list_prim_u_8_strict *onchain_recipient_address;
  struct wire_cst_list_prim_u_8_strict *pair_hash;
  uint32_t sat_per_vbyte;
} wire_cst_send_onchain_request;

typedef struct wire_cst_send_payment_request {
  struct wire_cst_list_prim_u_8_strict *bolt11;
  uint64_t *amount_msat;
  struct wire_cst_list_prim_u_8_strict *label;
} wire_cst_send_payment_request;

typedef struct wire_cst_tlv_entry {
  uint64_t field_number;
  struct wire_cst_list_prim_u_8_strict *value;
} wire_cst_tlv_entry;

typedef struct wire_cst_list_tlv_entry {
  struct wire_cst_tlv_entry *ptr;
  int32_t len;
} wire_cst_list_tlv_entry;

typedef struct wire_cst_send_spontaneous_payment_request {
  struct wire_cst_list_prim_u_8_strict *node_id;
  uint64_t amount_msat;
  struct wire_cst_list_tlv_entry *extra_tlvs;
  struct wire_cst_list_prim_u_8_strict *label;
} wire_cst_send_spontaneous_payment_request;

typedef struct wire_cst_sign_message_request {
  struct wire_cst_list_prim_u_8_strict *message;
} wire_cst_sign_message_request;

typedef struct wire_cst_static_backup_request {
  struct wire_cst_list_prim_u_8_strict *working_dir;
} wire_cst_static_backup_request;

typedef struct wire_cst_aes_success_action_data_decrypted {
  struct wire_cst_list_prim_u_8_strict *description;
  struct wire_cst_list_prim_u_8_strict *plaintext;
} wire_cst_aes_success_action_data_decrypted;

typedef struct wire_cst_AesSuccessActionDataResult_Decrypted {
  struct wire_cst_aes_success_action_data_decrypted *data;
} wire_cst_AesSuccessActionDataResult_Decrypted;

typedef struct wire_cst_AesSuccessActionDataResult_ErrorStatus {
  struct wire_cst_list_prim_u_8_strict *reason;
} wire_cst_AesSuccessActionDataResult_ErrorStatus;

typedef union AesSuccessActionDataResultKind {
  struct wire_cst_AesSuccessActionDataResult_Decrypted Decrypted;
  struct wire_cst_AesSuccessActionDataResult_ErrorStatus ErrorStatus;
} AesSuccessActionDataResultKind;

typedef struct wire_cst_aes_success_action_data_result {
  int32_t tag;
  union AesSuccessActionDataResultKind kind;
} wire_cst_aes_success_action_data_result;

typedef struct wire_cst_backup_failed_data {
  struct wire_cst_list_prim_u_8_strict *error;
} wire_cst_backup_failed_data;

typedef struct wire_cst_bitcoin_address_data {
  struct wire_cst_list_prim_u_8_strict *address;
  int32_t network;
  uint64_t *amount_sat;
  struct wire_cst_list_prim_u_8_strict *label;
  struct wire_cst_list_prim_u_8_strict *message;
} wire_cst_bitcoin_address_data;

typedef struct wire_cst_closed_channel_payment_details {
  int32_t state;
  struct wire_cst_list_prim_u_8_strict *funding_txid;
  struct wire_cst_list_prim_u_8_strict *short_channel_id;
  struct wire_cst_list_prim_u_8_strict *closing_txid;
} wire_cst_closed_channel_payment_details;

typedef struct wire_cst_SuccessActionProcessed_Aes {
  struct wire_cst_aes_success_action_data_result *result;
} wire_cst_SuccessActionProcessed_Aes;

typedef struct wire_cst_message_success_action_data {
  struct wire_cst_list_prim_u_8_strict *message;
} wire_cst_message_success_action_data;

typedef struct wire_cst_SuccessActionProcessed_Message {
  struct wire_cst_message_success_action_data *data;
} wire_cst_SuccessActionProcessed_Message;

typedef struct wire_cst_url_success_action_data {
  struct wire_cst_list_prim_u_8_strict *description;
  struct wire_cst_list_prim_u_8_strict *url;
} wire_cst_url_success_action_data;

typedef struct wire_cst_SuccessActionProcessed_Url {
  struct wire_cst_url_success_action_data *data;
} wire_cst_SuccessActionProcessed_Url;

typedef union SuccessActionProcessedKind {
  struct wire_cst_SuccessActionProcessed_Aes Aes;
  struct wire_cst_SuccessActionProcessed_Message Message;
  struct wire_cst_SuccessActionProcessed_Url Url;
} SuccessActionProcessedKind;

typedef struct wire_cst_success_action_processed {
  int32_t tag;
  union SuccessActionProcessedKind kind;
} wire_cst_success_action_processed;

typedef struct wire_cst_list_String {
  struct wire_cst_list_prim_u_8_strict **ptr;
  int32_t len;
} wire_cst_list_String;

typedef struct wire_cst_swap_info {
  struct wire_cst_list_prim_u_8_strict *bitcoin_address;
  int64_t created_at;
  int64_t lock_height;
  struct wire_cst_list_prim_u_8_strict *payment_hash;
  struct wire_cst_list_prim_u_8_strict *preimage;
  struct wire_cst_list_prim_u_8_strict *private_key;
  struct wire_cst_list_prim_u_8_strict *public_key;
  struct wire_cst_list_prim_u_8_strict *swapper_public_key;
  struct wire_cst_list_prim_u_8_strict *script;
  struct wire_cst_list_prim_u_8_strict *bolt11;
  uint64_t paid_msat;
  uint64_t total_incoming_txs;
  uint64_t confirmed_sats;
  uint64_t unconfirmed_sats;
  int32_t status;
  struct wire_cst_list_String *refund_tx_ids;
  struct wire_cst_list_String *unconfirmed_tx_ids;
  struct wire_cst_list_String *confirmed_tx_ids;
  int64_t min_allowed_deposit;
  int64_t max_allowed_deposit;
  int64_t max_swapper_payable;
  struct wire_cst_list_prim_u_8_strict *last_redeem_error;
  struct wire_cst_opening_fee_params *channel_opening_fees;
  uint32_t *confirmed_at;
} wire_cst_swap_info;

typedef struct wire_cst_reverse_swap_info {
  struct wire_cst_list_prim_u_8_strict *id;
  struct wire_cst_list_prim_u_8_strict *claim_pubkey;
  struct wire_cst_list_prim_u_8_strict *lockup_txid;
  struct wire_cst_list_prim_u_8_strict *claim_txid;
  uint64_t onchain_amount_sat;
  int32_t status;
} wire_cst_reverse_swap_info;

typedef struct wire_cst_ln_payment_details {
  struct wire_cst_list_prim_u_8_strict *payment_hash;
  struct wire_cst_list_prim_u_8_strict *label;
  struct wire_cst_list_prim_u_8_strict *destination_pubkey;
  struct wire_cst_list_prim_u_8_strict *payment_preimage;
  bool keysend;
  struct wire_cst_list_prim_u_8_strict *bolt11;
  struct wire_cst_list_prim_u_8_strict *open_channel_bolt11;
  struct wire_cst_success_action_processed *lnurl_success_action;
  struct wire_cst_list_prim_u_8_strict *lnurl_pay_domain;
  struct wire_cst_list_prim_u_8_strict *lnurl_pay_comment;
  struct wire_cst_list_prim_u_8_strict *ln_address;
  struct wire_cst_list_prim_u_8_strict *lnurl_metadata;
  struct wire_cst_list_prim_u_8_strict *lnurl_withdraw_endpoint;
  struct wire_cst_swap_info *swap_info;
  struct wire_cst_reverse_swap_info *reverse_swap_info;
  uint32_t *pending_expiration_block;
} wire_cst_ln_payment_details;

typedef struct wire_cst_PaymentDetails_Ln {
  struct wire_cst_ln_payment_details *data;
} wire_cst_PaymentDetails_Ln;

typedef struct wire_cst_PaymentDetails_ClosedChannel {
  struct wire_cst_closed_channel_payment_details *data;
} wire_cst_PaymentDetails_ClosedChannel;

typedef union PaymentDetailsKind {
  struct wire_cst_PaymentDetails_Ln Ln;
  struct wire_cst_PaymentDetails_ClosedChannel ClosedChannel;
} PaymentDetailsKind;

typedef struct wire_cst_payment_details {
  int32_t tag;
  union PaymentDetailsKind kind;
} wire_cst_payment_details;

typedef struct wire_cst_payment {
  struct wire_cst_list_prim_u_8_strict *id;
  int32_t payment_type;
  int64_t payment_time;
  uint64_t amount_msat;
  uint64_t fee_msat;
  int32_t status;
  struct wire_cst_list_prim_u_8_strict *error;
  struct wire_cst_list_prim_u_8_strict *description;
  struct wire_cst_payment_details details;
  struct wire_cst_list_prim_u_8_strict *metadata;
} wire_cst_payment;

typedef struct wire_cst_invoice_paid_details {
  struct wire_cst_list_prim_u_8_strict *payment_hash;
  struct wire_cst_list_prim_u_8_strict *bolt11;
  struct wire_cst_payment *payment;
} wire_cst_invoice_paid_details;

typedef struct wire_cst_route_hint_hop {
  struct wire_cst_list_prim_u_8_strict *src_node_id;
  uint64_t short_channel_id;
  uint32_t fees_base_msat;
  uint32_t fees_proportional_millionths;
  uint64_t cltv_expiry_delta;
  uint64_t *htlc_minimum_msat;
  uint64_t *htlc_maximum_msat;
} wire_cst_route_hint_hop;

typedef struct wire_cst_list_route_hint_hop {
  struct wire_cst_route_hint_hop *ptr;
  int32_t len;
} wire_cst_list_route_hint_hop;

typedef struct wire_cst_route_hint {
  struct wire_cst_list_route_hint_hop *hops;
} wire_cst_route_hint;

typedef struct wire_cst_list_route_hint {
  struct wire_cst_route_hint *ptr;
  int32_t len;
} wire_cst_list_route_hint;

typedef struct wire_cst_ln_invoice {
  struct wire_cst_list_prim_u_8_strict *bolt11;
  int32_t network;
  struct wire_cst_list_prim_u_8_strict *payee_pubkey;
  struct wire_cst_list_prim_u_8_strict *payment_hash;
  struct wire_cst_list_prim_u_8_strict *description;
  struct wire_cst_list_prim_u_8_strict *description_hash;
  uint64_t *amount_msat;
  uint64_t timestamp;
  uint64_t expiry;
  struct wire_cst_list_route_hint *routing_hints;
  struct wire_cst_list_prim_u_8_strict *payment_secret;
  uint64_t min_final_cltv_expiry_delta;
} wire_cst_ln_invoice;

typedef struct wire_cst_ln_url_error_data {
  struct wire_cst_list_prim_u_8_strict *reason;
} wire_cst_ln_url_error_data;

typedef struct wire_cst_ln_url_pay_error_data {
  struct wire_cst_list_prim_u_8_strict *payment_hash;
  struct wire_cst_list_prim_u_8_strict *reason;
} wire_cst_ln_url_pay_error_data;

typedef struct wire_cst_ln_url_pay_success_data {
  struct wire_cst_payment payment;
  struct wire_cst_success_action_processed *success_action;
} wire_cst_ln_url_pay_success_data;

typedef struct wire_cst_ln_url_withdraw_success_data {
  struct wire_cst_ln_invoice invoice;
} wire_cst_ln_url_withdraw_success_data;

typedef struct wire_cst_list_opening_fee_params {
  struct wire_cst_opening_fee_params *ptr;
  int32_t len;
} wire_cst_list_opening_fee_params;

typedef struct wire_cst_opening_fee_params_menu {
  struct wire_cst_list_opening_fee_params *values;
} wire_cst_opening_fee_params_menu;

typedef struct wire_cst_lsp_information {
  struct wire_cst_list_prim_u_8_strict *id;
  struct wire_cst_list_prim_u_8_strict *name;
  struct wire_cst_list_prim_u_8_strict *widget_url;
  struct wire_cst_list_prim_u_8_strict *pubkey;
  struct wire_cst_list_prim_u_8_strict *host;
  int64_t base_fee_msat;
  double fee_rate;
  uint32_t time_lock_delta;
  int64_t min_htlc_msat;
  struct wire_cst_list_prim_u_8_strict *lsp_pubkey;
  struct wire_cst_opening_fee_params_menu opening_fee_params_list;
} wire_cst_lsp_information;

typedef struct wire_cst_NodeCredentials_Greenlight {
  struct wire_cst_greenlight_credentials *credentials;
} wire_cst_NodeCredentials_Greenlight;

typedef union NodeCredentialsKind {
  struct wire_cst_NodeCredentials_Greenlight Greenlight;
} NodeCredentialsKind;

typedef struct wire_cst_node_credentials {
  int32_t tag;
  union NodeCredentialsKind kind;
} wire_cst_node_credentials;

typedef struct wire_cst_payment_failed_data {
  struct wire_cst_list_prim_u_8_strict *error;
  struct wire_cst_list_prim_u_8_strict *node_id;
  struct wire_cst_ln_invoice *invoice;
  struct wire_cst_list_prim_u_8_strict *label;
} wire_cst_payment_failed_data;

typedef struct wire_cst_symbol {
  struct wire_cst_list_prim_u_8_strict *grapheme;
  struct wire_cst_list_prim_u_8_strict *template_;
  bool *rtl;
  uint32_t *position;
} wire_cst_symbol;

typedef struct wire_cst_localized_name {
  struct wire_cst_list_prim_u_8_strict *locale;
  struct wire_cst_list_prim_u_8_strict *name;
} wire_cst_localized_name;

typedef struct wire_cst_list_localized_name {
  struct wire_cst_localized_name *ptr;
  int32_t len;
} wire_cst_list_localized_name;

typedef struct wire_cst_locale_overrides {
  struct wire_cst_list_prim_u_8_strict *locale;
  uint32_t *spacing;
  struct wire_cst_symbol symbol;
} wire_cst_locale_overrides;

typedef struct wire_cst_list_locale_overrides {
  struct wire_cst_locale_overrides *ptr;
  int32_t len;
} wire_cst_list_locale_overrides;

typedef struct wire_cst_currency_info {
  struct wire_cst_list_prim_u_8_strict *name;
  uint32_t fraction_size;
  uint32_t *spacing;
  struct wire_cst_symbol *symbol;
  struct wire_cst_symbol *uniq_symbol;
  struct wire_cst_list_localized_name *localized_name;
  struct wire_cst_list_locale_overrides *locale_overrides;
} wire_cst_currency_info;

typedef struct wire_cst_fiat_currency {
  struct wire_cst_list_prim_u_8_strict *id;
  struct wire_cst_currency_info info;
} wire_cst_fiat_currency;

typedef struct wire_cst_list_fiat_currency {
  struct wire_cst_fiat_currency *ptr;
  int32_t len;
} wire_cst_list_fiat_currency;

typedef struct wire_cst_list_lsp_information {
  struct wire_cst_lsp_information *ptr;
  int32_t len;
} wire_cst_list_lsp_information;

typedef struct wire_cst_list_payment {
  struct wire_cst_payment *ptr;
  int32_t len;
} wire_cst_list_payment;

typedef struct wire_cst_rate {
  struct wire_cst_list_prim_u_8_strict *coin;
  double value;
} wire_cst_rate;

typedef struct wire_cst_list_rate {
  struct wire_cst_rate *ptr;
  int32_t len;
} wire_cst_list_rate;

typedef struct wire_cst_list_reverse_swap_info {
  struct wire_cst_reverse_swap_info *ptr;
  int32_t len;
} wire_cst_list_reverse_swap_info;

typedef struct wire_cst_list_swap_info {
  struct wire_cst_swap_info *ptr;
  int32_t len;
} wire_cst_list_swap_info;

typedef struct wire_cst_unspent_transaction_output {
  struct wire_cst_list_prim_u_8_strict *txid;
  uint32_t outnum;
  uint64_t amount_millisatoshi;
  struct wire_cst_list_prim_u_8_strict *address;
  bool reserved;
} wire_cst_unspent_transaction_output;

typedef struct wire_cst_list_unspent_transaction_output {
  struct wire_cst_unspent_transaction_output *ptr;
  int32_t len;
} wire_cst_list_unspent_transaction_output;

typedef struct wire_cst_backup_status {
  bool backed_up;
  uint64_t *last_backup_time;
} wire_cst_backup_status;

typedef struct wire_cst_BreezEvent_NewBlock {
  uint32_t block;
} wire_cst_BreezEvent_NewBlock;

typedef struct wire_cst_BreezEvent_InvoicePaid {
  struct wire_cst_invoice_paid_details *details;
} wire_cst_BreezEvent_InvoicePaid;

typedef struct wire_cst_BreezEvent_PaymentSucceed {
  struct wire_cst_payment *details;
} wire_cst_BreezEvent_PaymentSucceed;

typedef struct wire_cst_BreezEvent_PaymentFailed {
  struct wire_cst_payment_failed_data *details;
} wire_cst_BreezEvent_PaymentFailed;

typedef struct wire_cst_BreezEvent_BackupFailed {
  struct wire_cst_backup_failed_data *details;
} wire_cst_BreezEvent_BackupFailed;

typedef struct wire_cst_BreezEvent_SwapUpdated {
  struct wire_cst_swap_info *details;
} wire_cst_BreezEvent_SwapUpdated;

typedef union BreezEventKind {
  struct wire_cst_BreezEvent_NewBlock NewBlock;
  struct wire_cst_BreezEvent_InvoicePaid InvoicePaid;
  struct wire_cst_BreezEvent_PaymentSucceed PaymentSucceed;
  struct wire_cst_BreezEvent_PaymentFailed PaymentFailed;
  struct wire_cst_BreezEvent_BackupFailed BackupFailed;
  struct wire_cst_BreezEvent_SwapUpdated SwapUpdated;
} BreezEventKind;

typedef struct wire_cst_breez_event {
  int32_t tag;
  union BreezEventKind kind;
} wire_cst_breez_event;

typedef struct wire_cst_buy_bitcoin_response {
  struct wire_cst_list_prim_u_8_strict *url;
  struct wire_cst_opening_fee_params *opening_fee_params;
} wire_cst_buy_bitcoin_response;

typedef struct wire_cst_check_message_response {
  bool is_valid;
} wire_cst_check_message_response;

typedef struct wire_cst_InputType_BitcoinAddress {
  struct wire_cst_bitcoin_address_data *address;
} wire_cst_InputType_BitcoinAddress;

typedef struct wire_cst_InputType_Bolt11 {
  struct wire_cst_ln_invoice *invoice;
} wire_cst_InputType_Bolt11;

typedef struct wire_cst_InputType_NodeId {
  struct wire_cst_list_prim_u_8_strict *node_id;
} wire_cst_InputType_NodeId;

typedef struct wire_cst_InputType_Url {
  struct wire_cst_list_prim_u_8_strict *url;
} wire_cst_InputType_Url;

typedef struct wire_cst_InputType_LnUrlPay {
  struct wire_cst_ln_url_pay_request_data *data;
} wire_cst_InputType_LnUrlPay;

typedef struct wire_cst_InputType_LnUrlWithdraw {
  struct wire_cst_ln_url_withdraw_request_data *data;
} wire_cst_InputType_LnUrlWithdraw;

typedef struct wire_cst_InputType_LnUrlAuth {
  struct wire_cst_ln_url_auth_request_data *data;
} wire_cst_InputType_LnUrlAuth;

typedef struct wire_cst_InputType_LnUrlError {
  struct wire_cst_ln_url_error_data *data;
} wire_cst_InputType_LnUrlError;

typedef union InputTypeKind {
  struct wire_cst_InputType_BitcoinAddress BitcoinAddress;
  struct wire_cst_InputType_Bolt11 Bolt11;
  struct wire_cst_InputType_NodeId NodeId;
  struct wire_cst_InputType_Url Url;
  struct wire_cst_InputType_LnUrlPay LnUrlPay;
  struct wire_cst_InputType_LnUrlWithdraw LnUrlWithdraw;
  struct wire_cst_InputType_LnUrlAuth LnUrlAuth;
  struct wire_cst_InputType_LnUrlError LnUrlError;
} InputTypeKind;

typedef struct wire_cst_input_type {
  int32_t tag;
  union InputTypeKind kind;
} wire_cst_input_type;

typedef struct wire_cst_LnUrlCallbackStatus_ErrorStatus {
  struct wire_cst_ln_url_error_data *data;
} wire_cst_LnUrlCallbackStatus_ErrorStatus;

typedef union LnUrlCallbackStatusKind {
  struct wire_cst_LnUrlCallbackStatus_ErrorStatus ErrorStatus;
} LnUrlCallbackStatusKind;

typedef struct wire_cst_ln_url_callback_status {
  int32_t tag;
  union LnUrlCallbackStatusKind kind;
} wire_cst_ln_url_callback_status;

typedef struct wire_cst_LnUrlPayResult_EndpointSuccess {
  struct wire_cst_ln_url_pay_success_data *data;
} wire_cst_LnUrlPayResult_EndpointSuccess;

typedef struct wire_cst_LnUrlPayResult_EndpointError {
  struct wire_cst_ln_url_error_data *data;
} wire_cst_LnUrlPayResult_EndpointError;

typedef struct wire_cst_LnUrlPayResult_PayError {
  struct wire_cst_ln_url_pay_error_data *data;
} wire_cst_LnUrlPayResult_PayError;

typedef union LnUrlPayResultKind {
  struct wire_cst_LnUrlPayResult_EndpointSuccess EndpointSuccess;
  struct wire_cst_LnUrlPayResult_EndpointError EndpointError;
  struct wire_cst_LnUrlPayResult_PayError PayError;
} LnUrlPayResultKind;

typedef struct wire_cst_ln_url_pay_result {
  int32_t tag;
  union LnUrlPayResultKind kind;
} wire_cst_ln_url_pay_result;

typedef struct wire_cst_LnUrlWithdrawResult_Ok {
  struct wire_cst_ln_url_withdraw_success_data *data;
} wire_cst_LnUrlWithdrawResult_Ok;

typedef struct wire_cst_LnUrlWithdrawResult_ErrorStatus {
  struct wire_cst_ln_url_error_data *data;
} wire_cst_LnUrlWithdrawResult_ErrorStatus;

typedef union LnUrlWithdrawResultKind {
  struct wire_cst_LnUrlWithdrawResult_Ok Ok;
  struct wire_cst_LnUrlWithdrawResult_ErrorStatus ErrorStatus;
} LnUrlWithdrawResultKind;

typedef struct wire_cst_ln_url_withdraw_result {
  int32_t tag;
  union LnUrlWithdrawResultKind kind;
} wire_cst_ln_url_withdraw_result;

typedef struct wire_cst_log_entry {
  struct wire_cst_list_prim_u_8_strict *line;
  struct wire_cst_list_prim_u_8_strict *level;
} wire_cst_log_entry;

typedef struct wire_cst_max_reverse_swap_amount_response {
  uint64_t total_sat;
} wire_cst_max_reverse_swap_amount_response;

typedef struct wire_cst_node_state {
  struct wire_cst_list_prim_u_8_strict *id;
  uint32_t block_height;
  uint64_t channels_balance_msat;
  uint64_t onchain_balance_msat;
  uint64_t pending_onchain_balance_msat;
  struct wire_cst_list_unspent_transaction_output *utxos;
  uint64_t max_payable_msat;
  uint64_t max_receivable_msat;
  uint64_t max_single_payment_amount_msat;
  uint64_t max_chan_reserve_msats;
  struct wire_cst_list_String *connected_peers;
  uint64_t inbound_liquidity_msats;
} wire_cst_node_state;

typedef struct wire_cst_onchain_payment_limits_response {
  uint64_t min_sat;
  uint64_t max_sat;
} wire_cst_onchain_payment_limits_response;

typedef struct wire_cst_open_channel_fee_response {
  uint64_t *fee_msat;
  struct wire_cst_opening_fee_params fee_params;
} wire_cst_open_channel_fee_response;

typedef struct wire_cst_pay_onchain_response {
  struct wire_cst_reverse_swap_info reverse_swap_info;
} wire_cst_pay_onchain_response;

typedef struct wire_cst_prepare_redeem_onchain_funds_response {
  uint64_t tx_weight;
  uint64_t tx_fee_sat;
} wire_cst_prepare_redeem_onchain_funds_response;

typedef struct wire_cst_prepare_refund_response {
  uint32_t refund_tx_weight;
  uint64_t refund_tx_fee_sat;
} wire_cst_prepare_refund_response;

typedef struct wire_cst_receive_payment_response {
  struct wire_cst_ln_invoice ln_invoice;
  struct wire_cst_opening_fee_params *opening_fee_params;
  uint64_t *opening_fee_msat;
} wire_cst_receive_payment_response;

typedef struct wire_cst_recommended_fees {
  uint64_t fastest_fee;
  uint64_t half_hour_fee;
  uint64_t hour_fee;
  uint64_t economy_fee;
  uint64_t minimum_fee;
} wire_cst_recommended_fees;

typedef struct wire_cst_redeem_onchain_funds_response {
  struct wire_cst_list_prim_u_8_strict *txid;
} wire_cst_redeem_onchain_funds_response;

typedef struct wire_cst_refund_response {
  struct wire_cst_list_prim_u_8_strict *refund_tx_id;
} wire_cst_refund_response;

typedef struct wire_cst_reverse_swap_pair_info {
  uint64_t min;
  uint64_t max;
  struct wire_cst_list_prim_u_8_strict *fees_hash;
  double fees_percentage;
  uint64_t fees_lockup;
  uint64_t fees_claim;
  uint64_t *total_fees;
} wire_cst_reverse_swap_pair_info;

typedef struct wire_cst_send_onchain_response {
  struct wire_cst_reverse_swap_info reverse_swap_info;
} wire_cst_send_onchain_response;

typedef struct wire_cst_send_payment_response {
  struct wire_cst_payment payment;
} wire_cst_send_payment_response;

typedef struct wire_cst_service_health_check_response {
  int32_t status;
} wire_cst_service_health_check_response;

typedef struct wire_cst_sign_message_response {
  struct wire_cst_list_prim_u_8_strict *signature;
} wire_cst_sign_message_response;

typedef struct wire_cst_static_backup_response {
  struct wire_cst_list_String *backup;
} wire_cst_static_backup_response;

void frbgen_breez_sdk_wire_backup(int64_t port_);

void frbgen_breez_sdk_wire_backup_status(int64_t port_);

void frbgen_breez_sdk_wire_breez_events_stream(int64_t port_,
                                               struct wire_cst_list_prim_u_8_strict *s);

void frbgen_breez_sdk_wire_breez_log_stream(int64_t port_, struct wire_cst_list_prim_u_8_strict *s);

void frbgen_breez_sdk_wire_buy_bitcoin(int64_t port_, struct wire_cst_buy_bitcoin_request *req);

void frbgen_breez_sdk_wire_check_message(int64_t port_, struct wire_cst_check_message_request *req);

void frbgen_breez_sdk_wire_close_lsp_channels(int64_t port_);

void frbgen_breez_sdk_wire_configure_node(int64_t port_,
                                          struct wire_cst_configure_node_request *req);

void frbgen_breez_sdk_wire_connect(int64_t port_, struct wire_cst_connect_request *req);

void frbgen_breez_sdk_wire_connect_lsp(int64_t port_, struct wire_cst_list_prim_u_8_strict *lsp_id);

void frbgen_breez_sdk_wire_default_config(int64_t port_,
                                          int32_t env_type,
                                          struct wire_cst_list_prim_u_8_strict *api_key,
                                          struct wire_cst_node_config *node_config);

void frbgen_breez_sdk_wire_disconnect(int64_t port_);

void frbgen_breez_sdk_wire_execute_command(int64_t port_,
                                           struct wire_cst_list_prim_u_8_strict *command);

void frbgen_breez_sdk_wire_fetch_fiat_rates(int64_t port_);

void frbgen_breez_sdk_wire_fetch_lsp_info(int64_t port_, struct wire_cst_list_prim_u_8_strict *id);

void frbgen_breez_sdk_wire_fetch_reverse_swap_fees(int64_t port_,
                                                   struct wire_cst_reverse_swap_fees_request *req);

void frbgen_breez_sdk_wire_generate_diagnostic_data(int64_t port_);

void frbgen_breez_sdk_wire_in_progress_onchain_payments(int64_t port_);

void frbgen_breez_sdk_wire_in_progress_reverse_swaps(int64_t port_);

void frbgen_breez_sdk_wire_in_progress_swap(int64_t port_);

void frbgen_breez_sdk_wire_is_initialized(int64_t port_);

void frbgen_breez_sdk_wire_list_fiat_currencies(int64_t port_);

void frbgen_breez_sdk_wire_list_lsps(int64_t port_);

void frbgen_breez_sdk_wire_list_payments(int64_t port_, struct wire_cst_list_payments_request *req);

void frbgen_breez_sdk_wire_list_refundables(int64_t port_);

void frbgen_breez_sdk_wire_lnurl_auth(int64_t port_,
                                      struct wire_cst_ln_url_auth_request_data *req_data);

void frbgen_breez_sdk_wire_lnurl_pay(int64_t port_, struct wire_cst_ln_url_pay_request *req);

void frbgen_breez_sdk_wire_lnurl_withdraw(int64_t port_,
                                          struct wire_cst_ln_url_withdraw_request *req);

void frbgen_breez_sdk_wire_lsp_id(int64_t port_);

void frbgen_breez_sdk_wire_lsp_info(int64_t port_);

void frbgen_breez_sdk_wire_max_reverse_swap_amount(int64_t port_);

void frbgen_breez_sdk_wire_mnemonic_to_seed(int64_t port_,
                                            struct wire_cst_list_prim_u_8_strict *phrase);

void frbgen_breez_sdk_wire_node_credentials(int64_t port_);

void frbgen_breez_sdk_wire_node_info(int64_t port_);

void frbgen_breez_sdk_wire_onchain_payment_limits(int64_t port_);

void frbgen_breez_sdk_wire_open_channel_fee(int64_t port_,
                                            struct wire_cst_open_channel_fee_request *req);

void frbgen_breez_sdk_wire_parse_input(int64_t port_, struct wire_cst_list_prim_u_8_strict *input);

void frbgen_breez_sdk_wire_parse_invoice(int64_t port_,
                                         struct wire_cst_list_prim_u_8_strict *invoice);

void frbgen_breez_sdk_wire_pay_onchain(int64_t port_, struct wire_cst_pay_onchain_request *req);

void frbgen_breez_sdk_wire_payment_by_hash(int64_t port_,
                                           struct wire_cst_list_prim_u_8_strict *hash);

void frbgen_breez_sdk_wire_prepare_onchain_payment(int64_t port_,
                                                   struct wire_cst_prepare_onchain_payment_request *req);

void frbgen_breez_sdk_wire_prepare_redeem_onchain_funds(int64_t port_,
                                                        struct wire_cst_prepare_redeem_onchain_funds_request *req);

void frbgen_breez_sdk_wire_prepare_refund(int64_t port_,
                                          struct wire_cst_prepare_refund_request *req);

void frbgen_breez_sdk_wire_receive_onchain(int64_t port_,
                                           struct wire_cst_receive_onchain_request *req);

void frbgen_breez_sdk_wire_receive_payment(int64_t port_,
                                           struct wire_cst_receive_payment_request *req);

void frbgen_breez_sdk_wire_recommended_fees(int64_t port_);

void frbgen_breez_sdk_wire_redeem_onchain_funds(int64_t port_,
                                                struct wire_cst_redeem_onchain_funds_request *req);

void frbgen_breez_sdk_wire_redeem_swap(int64_t port_,
                                       struct wire_cst_list_prim_u_8_strict *swap_address);

void frbgen_breez_sdk_wire_refund(int64_t port_, struct wire_cst_refund_request *req);

void frbgen_breez_sdk_wire_register_webhook(int64_t port_,
                                            struct wire_cst_list_prim_u_8_strict *webhook_url);

void frbgen_breez_sdk_wire_report_issue(int64_t port_, struct wire_cst_report_issue_request *req);

void frbgen_breez_sdk_wire_rescan_swaps(int64_t port_);

void frbgen_breez_sdk_wire_send_onchain(int64_t port_, struct wire_cst_send_onchain_request *req);

void frbgen_breez_sdk_wire_send_payment(int64_t port_, struct wire_cst_send_payment_request *req);

void frbgen_breez_sdk_wire_send_spontaneous_payment(int64_t port_,
                                                    struct wire_cst_send_spontaneous_payment_request *req);

void frbgen_breez_sdk_wire_service_health_check(int64_t port_,
                                                struct wire_cst_list_prim_u_8_strict *api_key);

void frbgen_breez_sdk_wire_set_payment_metadata(int64_t port_,
                                                struct wire_cst_list_prim_u_8_strict *hash,
                                                struct wire_cst_list_prim_u_8_strict *metadata);

void frbgen_breez_sdk_wire_sign_message(int64_t port_, struct wire_cst_sign_message_request *req);

void frbgen_breez_sdk_wire_static_backup(int64_t port_, struct wire_cst_static_backup_request *req);

void frbgen_breez_sdk_wire_sync(int64_t port_);

struct wire_cst_aes_success_action_data_decrypted *frbgen_breez_sdk_cst_new_box_autoadd_aes_success_action_data_decrypted(void);

struct wire_cst_aes_success_action_data_result *frbgen_breez_sdk_cst_new_box_autoadd_aes_success_action_data_result(void);

struct wire_cst_backup_failed_data *frbgen_breez_sdk_cst_new_box_autoadd_backup_failed_data(void);

struct wire_cst_bitcoin_address_data *frbgen_breez_sdk_cst_new_box_autoadd_bitcoin_address_data(void);

bool *frbgen_breez_sdk_cst_new_box_autoadd_bool(bool value);

struct wire_cst_buy_bitcoin_request *frbgen_breez_sdk_cst_new_box_autoadd_buy_bitcoin_request(void);

struct wire_cst_check_message_request *frbgen_breez_sdk_cst_new_box_autoadd_check_message_request(void);

struct wire_cst_closed_channel_payment_details *frbgen_breez_sdk_cst_new_box_autoadd_closed_channel_payment_details(void);

struct wire_cst_configure_node_request *frbgen_breez_sdk_cst_new_box_autoadd_configure_node_request(void);

struct wire_cst_connect_request *frbgen_breez_sdk_cst_new_box_autoadd_connect_request(void);

struct wire_cst_greenlight_credentials *frbgen_breez_sdk_cst_new_box_autoadd_greenlight_credentials(void);

struct wire_cst_greenlight_node_config *frbgen_breez_sdk_cst_new_box_autoadd_greenlight_node_config(void);

int64_t *frbgen_breez_sdk_cst_new_box_autoadd_i_64(int64_t value);

struct wire_cst_invoice_paid_details *frbgen_breez_sdk_cst_new_box_autoadd_invoice_paid_details(void);

struct wire_cst_list_payments_request *frbgen_breez_sdk_cst_new_box_autoadd_list_payments_request(void);

struct wire_cst_ln_invoice *frbgen_breez_sdk_cst_new_box_autoadd_ln_invoice(void);

struct wire_cst_ln_payment_details *frbgen_breez_sdk_cst_new_box_autoadd_ln_payment_details(void);

struct wire_cst_ln_url_auth_request_data *frbgen_breez_sdk_cst_new_box_autoadd_ln_url_auth_request_data(void);

struct wire_cst_ln_url_error_data *frbgen_breez_sdk_cst_new_box_autoadd_ln_url_error_data(void);

struct wire_cst_ln_url_pay_error_data *frbgen_breez_sdk_cst_new_box_autoadd_ln_url_pay_error_data(void);

struct wire_cst_ln_url_pay_request *frbgen_breez_sdk_cst_new_box_autoadd_ln_url_pay_request(void);

struct wire_cst_ln_url_pay_request_data *frbgen_breez_sdk_cst_new_box_autoadd_ln_url_pay_request_data(void);

struct wire_cst_ln_url_pay_success_data *frbgen_breez_sdk_cst_new_box_autoadd_ln_url_pay_success_data(void);

struct wire_cst_ln_url_withdraw_request *frbgen_breez_sdk_cst_new_box_autoadd_ln_url_withdraw_request(void);

struct wire_cst_ln_url_withdraw_request_data *frbgen_breez_sdk_cst_new_box_autoadd_ln_url_withdraw_request_data(void);

struct wire_cst_ln_url_withdraw_success_data *frbgen_breez_sdk_cst_new_box_autoadd_ln_url_withdraw_success_data(void);

struct wire_cst_lsp_information *frbgen_breez_sdk_cst_new_box_autoadd_lsp_information(void);

struct wire_cst_message_success_action_data *frbgen_breez_sdk_cst_new_box_autoadd_message_success_action_data(void);

struct wire_cst_node_config *frbgen_breez_sdk_cst_new_box_autoadd_node_config(void);

struct wire_cst_node_credentials *frbgen_breez_sdk_cst_new_box_autoadd_node_credentials(void);

struct wire_cst_open_channel_fee_request *frbgen_breez_sdk_cst_new_box_autoadd_open_channel_fee_request(void);

struct wire_cst_opening_fee_params *frbgen_breez_sdk_cst_new_box_autoadd_opening_fee_params(void);

struct wire_cst_pay_onchain_request *frbgen_breez_sdk_cst_new_box_autoadd_pay_onchain_request(void);

struct wire_cst_payment *frbgen_breez_sdk_cst_new_box_autoadd_payment(void);

struct wire_cst_payment_failed_data *frbgen_breez_sdk_cst_new_box_autoadd_payment_failed_data(void);

struct wire_cst_prepare_onchain_payment_request *frbgen_breez_sdk_cst_new_box_autoadd_prepare_onchain_payment_request(void);

struct wire_cst_prepare_redeem_onchain_funds_request *frbgen_breez_sdk_cst_new_box_autoadd_prepare_redeem_onchain_funds_request(void);

struct wire_cst_prepare_refund_request *frbgen_breez_sdk_cst_new_box_autoadd_prepare_refund_request(void);

struct wire_cst_receive_onchain_request *frbgen_breez_sdk_cst_new_box_autoadd_receive_onchain_request(void);

struct wire_cst_receive_payment_request *frbgen_breez_sdk_cst_new_box_autoadd_receive_payment_request(void);

struct wire_cst_redeem_onchain_funds_request *frbgen_breez_sdk_cst_new_box_autoadd_redeem_onchain_funds_request(void);

struct wire_cst_refund_request *frbgen_breez_sdk_cst_new_box_autoadd_refund_request(void);

struct wire_cst_report_issue_request *frbgen_breez_sdk_cst_new_box_autoadd_report_issue_request(void);

struct wire_cst_report_payment_failure_details *frbgen_breez_sdk_cst_new_box_autoadd_report_payment_failure_details(void);

struct wire_cst_reverse_swap_fees_request *frbgen_breez_sdk_cst_new_box_autoadd_reverse_swap_fees_request(void);

struct wire_cst_reverse_swap_info *frbgen_breez_sdk_cst_new_box_autoadd_reverse_swap_info(void);

struct wire_cst_send_onchain_request *frbgen_breez_sdk_cst_new_box_autoadd_send_onchain_request(void);

struct wire_cst_send_payment_request *frbgen_breez_sdk_cst_new_box_autoadd_send_payment_request(void);

struct wire_cst_send_spontaneous_payment_request *frbgen_breez_sdk_cst_new_box_autoadd_send_spontaneous_payment_request(void);

struct wire_cst_sign_message_request *frbgen_breez_sdk_cst_new_box_autoadd_sign_message_request(void);

struct wire_cst_static_backup_request *frbgen_breez_sdk_cst_new_box_autoadd_static_backup_request(void);

struct wire_cst_success_action_processed *frbgen_breez_sdk_cst_new_box_autoadd_success_action_processed(void);

struct wire_cst_swap_info *frbgen_breez_sdk_cst_new_box_autoadd_swap_info(void);

struct wire_cst_symbol *frbgen_breez_sdk_cst_new_box_autoadd_symbol(void);

uint32_t *frbgen_breez_sdk_cst_new_box_autoadd_u_32(uint32_t value);

uint64_t *frbgen_breez_sdk_cst_new_box_autoadd_u_64(uint64_t value);

struct wire_cst_url_success_action_data *frbgen_breez_sdk_cst_new_box_autoadd_url_success_action_data(void);

struct wire_cst_list_String *frbgen_breez_sdk_cst_new_list_String(int32_t len);

struct wire_cst_list_fiat_currency *frbgen_breez_sdk_cst_new_list_fiat_currency(int32_t len);

struct wire_cst_list_locale_overrides *frbgen_breez_sdk_cst_new_list_locale_overrides(int32_t len);

struct wire_cst_list_localized_name *frbgen_breez_sdk_cst_new_list_localized_name(int32_t len);

struct wire_cst_list_lsp_information *frbgen_breez_sdk_cst_new_list_lsp_information(int32_t len);

struct wire_cst_list_metadata_filter *frbgen_breez_sdk_cst_new_list_metadata_filter(int32_t len);

struct wire_cst_list_opening_fee_params *frbgen_breez_sdk_cst_new_list_opening_fee_params(int32_t len);

struct wire_cst_list_payment *frbgen_breez_sdk_cst_new_list_payment(int32_t len);

struct wire_cst_list_payment_type_filter *frbgen_breez_sdk_cst_new_list_payment_type_filter(int32_t len);

struct wire_cst_list_prim_u_8_strict *frbgen_breez_sdk_cst_new_list_prim_u_8_strict(int32_t len);

struct wire_cst_list_rate *frbgen_breez_sdk_cst_new_list_rate(int32_t len);

struct wire_cst_list_reverse_swap_info *frbgen_breez_sdk_cst_new_list_reverse_swap_info(int32_t len);

struct wire_cst_list_route_hint *frbgen_breez_sdk_cst_new_list_route_hint(int32_t len);

struct wire_cst_list_route_hint_hop *frbgen_breez_sdk_cst_new_list_route_hint_hop(int32_t len);

struct wire_cst_list_swap_info *frbgen_breez_sdk_cst_new_list_swap_info(int32_t len);

struct wire_cst_list_tlv_entry *frbgen_breez_sdk_cst_new_list_tlv_entry(int32_t len);

struct wire_cst_list_unspent_transaction_output *frbgen_breez_sdk_cst_new_list_unspent_transaction_output(int32_t len);
static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_aes_success_action_data_decrypted);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_aes_success_action_data_result);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_backup_failed_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_bitcoin_address_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_bool);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_buy_bitcoin_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_check_message_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_closed_channel_payment_details);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_configure_node_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_connect_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_greenlight_credentials);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_greenlight_node_config);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_i_64);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_invoice_paid_details);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_list_payments_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_invoice);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_payment_details);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_url_auth_request_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_url_error_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_url_pay_error_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_url_pay_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_url_pay_request_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_url_pay_success_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_url_withdraw_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_url_withdraw_request_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_ln_url_withdraw_success_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_lsp_information);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_message_success_action_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_node_config);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_node_credentials);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_open_channel_fee_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_opening_fee_params);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_pay_onchain_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_payment);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_payment_failed_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_prepare_onchain_payment_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_prepare_redeem_onchain_funds_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_prepare_refund_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_receive_onchain_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_receive_payment_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_redeem_onchain_funds_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_refund_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_report_issue_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_report_payment_failure_details);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_reverse_swap_fees_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_reverse_swap_info);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_send_onchain_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_send_payment_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_send_spontaneous_payment_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_sign_message_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_static_backup_request);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_success_action_processed);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_swap_info);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_symbol);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_u_32);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_u_64);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_box_autoadd_url_success_action_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_String);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_fiat_currency);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_locale_overrides);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_localized_name);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_lsp_information);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_metadata_filter);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_opening_fee_params);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_payment);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_payment_type_filter);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_prim_u_8_strict);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_rate);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_reverse_swap_info);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_route_hint);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_route_hint_hop);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_swap_info);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_tlv_entry);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_cst_new_list_unspent_transaction_output);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_backup);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_backup_status);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_breez_events_stream);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_breez_log_stream);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_buy_bitcoin);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_check_message);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_close_lsp_channels);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_configure_node);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_connect);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_connect_lsp);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_default_config);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_disconnect);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_execute_command);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_fetch_fiat_rates);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_fetch_lsp_info);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_fetch_reverse_swap_fees);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_generate_diagnostic_data);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_in_progress_onchain_payments);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_in_progress_reverse_swaps);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_in_progress_swap);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_is_initialized);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_list_fiat_currencies);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_list_lsps);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_list_payments);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_list_refundables);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_lnurl_auth);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_lnurl_pay);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_lnurl_withdraw);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_lsp_id);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_lsp_info);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_max_reverse_swap_amount);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_mnemonic_to_seed);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_node_credentials);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_node_info);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_onchain_payment_limits);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_open_channel_fee);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_parse_input);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_parse_invoice);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_pay_onchain);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_payment_by_hash);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_prepare_onchain_payment);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_prepare_redeem_onchain_funds);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_prepare_refund);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_receive_onchain);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_receive_payment);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_recommended_fees);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_redeem_onchain_funds);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_redeem_swap);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_refund);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_register_webhook);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_report_issue);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_rescan_swaps);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_send_onchain);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_send_payment);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_send_spontaneous_payment);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_service_health_check);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_set_payment_metadata);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_sign_message);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_static_backup);
    dummy_var ^= ((int64_t) (void*) frbgen_breez_sdk_wire_sync);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}
