#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_Config {
  struct wire_uint_8_list *breezserver;
  struct wire_uint_8_list *mempoolspace_url;
  struct wire_uint_8_list *working_dir;
  int32_t network;
  uint32_t payment_timeout_sec;
  struct wire_uint_8_list *default_lsp_id;
  struct wire_uint_8_list *api_key;
  uint64_t *maxfee_sat;
  double maxfeepercent;
} wire_Config;

typedef struct wire_GreenlightCredentials {
  struct wire_uint_8_list *device_key;
  struct wire_uint_8_list *device_cert;
} wire_GreenlightCredentials;

typedef struct wire_LnUrlPayRequestData {
  struct wire_uint_8_list *callback;
  uint64_t min_sendable;
  uint64_t max_sendable;
  struct wire_uint_8_list *metadata_str;
  uint16_t comment_allowed;
  struct wire_uint_8_list *domain;
  struct wire_uint_8_list *ln_address;
} wire_LnUrlPayRequestData;

typedef struct wire_LnUrlWithdrawRequestData {
  struct wire_uint_8_list *callback;
  struct wire_uint_8_list *k1;
  struct wire_uint_8_list *default_description;
  uint64_t min_withdrawable;
  uint64_t max_withdrawable;
} wire_LnUrlWithdrawRequestData;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_register_node(int64_t port_,
                        int32_t network,
                        struct wire_uint_8_list *seed,
                        struct wire_Config *config);

void wire_recover_node(int64_t port_,
                       int32_t network,
                       struct wire_uint_8_list *seed,
                       struct wire_Config *config);

void wire_init_services(int64_t port_,
                        struct wire_Config *config,
                        struct wire_uint_8_list *seed,
                        struct wire_GreenlightCredentials *creds);

void wire_start_node(int64_t port_);

void wire_breez_events_stream(int64_t port_);

void wire_breez_log_stream(int64_t port_);

void wire_stop_node(int64_t port_);

void wire_send_payment(int64_t port_, struct wire_uint_8_list *bolt11, uint64_t *amount_sats);

void wire_send_spontaneous_payment(int64_t port_,
                                   struct wire_uint_8_list *node_id,
                                   uint64_t amount_sats);

void wire_receive_payment(int64_t port_,
                          uint64_t amount_sats,
                          struct wire_uint_8_list *description);

void wire_node_info(int64_t port_);

void wire_list_payments(int64_t port_,
                        int32_t filter,
                        int64_t *from_timestamp,
                        int64_t *to_timestamp);

void wire_list_lsps(int64_t port_);

void wire_connect_lsp(int64_t port_, struct wire_uint_8_list *lsp_id);

void wire_fetch_lsp_info(int64_t port_, struct wire_uint_8_list *id);

void wire_lsp_id(int64_t port_);

void wire_fetch_fiat_rates(int64_t port_);

void wire_list_fiat_currencies(int64_t port_);

void wire_close_lsp_channels(int64_t port_);

void wire_sweep(int64_t port_,
                struct wire_uint_8_list *to_address,
                uint64_t fee_rate_sats_per_byte);

void wire_receive_onchain(int64_t port_);

void wire_in_progress_swap(int64_t port_);

void wire_list_refundables(int64_t port_);

void wire_refund(int64_t port_,
                 struct wire_uint_8_list *swap_address,
                 struct wire_uint_8_list *to_address,
                 uint32_t sat_per_vbyte);

void wire_execute_command(int64_t port_, struct wire_uint_8_list *command);

void wire_sync_node(int64_t port_);

void wire_parse_invoice(int64_t port_, struct wire_uint_8_list *invoice);

void wire_parse(int64_t port_, struct wire_uint_8_list *s);

void wire_lnurl_pay(int64_t port_,
                    uint64_t user_amount_sat,
                    struct wire_uint_8_list *comment,
                    struct wire_LnUrlPayRequestData *req_data);

void wire_lnurl_withdraw(int64_t port_,
                         struct wire_LnUrlWithdrawRequestData *req_data,
                         uint64_t amount_sats,
                         struct wire_uint_8_list *description);

void wire_mnemonic_to_seed(int64_t port_, struct wire_uint_8_list *phrase);

void wire_recommended_fees(int64_t port_);

void wire_default_config(int64_t port_, int32_t config_type);

struct wire_Config *new_box_autoadd_config_0(void);

struct wire_GreenlightCredentials *new_box_autoadd_greenlight_credentials_0(void);

int64_t *new_box_autoadd_i64_0(int64_t value);

struct wire_LnUrlPayRequestData *new_box_autoadd_ln_url_pay_request_data_0(void);

struct wire_LnUrlWithdrawRequestData *new_box_autoadd_ln_url_withdraw_request_data_0(void);

uint64_t *new_box_autoadd_u64_0(uint64_t value);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_register_node);
    dummy_var ^= ((int64_t) (void*) wire_recover_node);
    dummy_var ^= ((int64_t) (void*) wire_init_services);
    dummy_var ^= ((int64_t) (void*) wire_start_node);
    dummy_var ^= ((int64_t) (void*) wire_breez_events_stream);
    dummy_var ^= ((int64_t) (void*) wire_breez_log_stream);
    dummy_var ^= ((int64_t) (void*) wire_stop_node);
    dummy_var ^= ((int64_t) (void*) wire_send_payment);
    dummy_var ^= ((int64_t) (void*) wire_send_spontaneous_payment);
    dummy_var ^= ((int64_t) (void*) wire_receive_payment);
    dummy_var ^= ((int64_t) (void*) wire_node_info);
    dummy_var ^= ((int64_t) (void*) wire_list_payments);
    dummy_var ^= ((int64_t) (void*) wire_list_lsps);
    dummy_var ^= ((int64_t) (void*) wire_connect_lsp);
    dummy_var ^= ((int64_t) (void*) wire_fetch_lsp_info);
    dummy_var ^= ((int64_t) (void*) wire_lsp_id);
    dummy_var ^= ((int64_t) (void*) wire_fetch_fiat_rates);
    dummy_var ^= ((int64_t) (void*) wire_list_fiat_currencies);
    dummy_var ^= ((int64_t) (void*) wire_close_lsp_channels);
    dummy_var ^= ((int64_t) (void*) wire_sweep);
    dummy_var ^= ((int64_t) (void*) wire_receive_onchain);
    dummy_var ^= ((int64_t) (void*) wire_in_progress_swap);
    dummy_var ^= ((int64_t) (void*) wire_list_refundables);
    dummy_var ^= ((int64_t) (void*) wire_refund);
    dummy_var ^= ((int64_t) (void*) wire_execute_command);
    dummy_var ^= ((int64_t) (void*) wire_sync_node);
    dummy_var ^= ((int64_t) (void*) wire_parse_invoice);
    dummy_var ^= ((int64_t) (void*) wire_parse);
    dummy_var ^= ((int64_t) (void*) wire_lnurl_pay);
    dummy_var ^= ((int64_t) (void*) wire_lnurl_withdraw);
    dummy_var ^= ((int64_t) (void*) wire_mnemonic_to_seed);
    dummy_var ^= ((int64_t) (void*) wire_recommended_fees);
    dummy_var ^= ((int64_t) (void*) wire_default_config);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_config_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_greenlight_credentials_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_i64_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ln_url_pay_request_data_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_ln_url_withdraw_request_data_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u64_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
