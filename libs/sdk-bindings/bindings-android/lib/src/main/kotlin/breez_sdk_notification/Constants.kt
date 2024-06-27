package breez_sdk_notification

object Constants {
    const val SERVICE_TIMEOUT_MS = 3 * 60 * 1000L
    const val SHUTDOWN_DELAY_MS = 60 * 1000L

    // Notification Channels
    const val NOTIFICATION_CHANNEL_ADDRESS_TXS_CONFIRMED = "ADDRESS_TXS_CONFIRMED"
    const val NOTIFICATION_CHANNEL_FOREGROUND_SERVICE = "FOREGROUND_SERVICE"
    const val NOTIFICATION_CHANNEL_LNURL_PAY = "LNURL_PAY"
    const val NOTIFICATION_CHANNEL_PAYMENT_RECEIVED = "PAYMENT_RECEIVED"

    // Notification Ids
    const val NOTIFICATION_ID_FOREGROUND_SERVICE = 100

    // Intent Extras
    const val EXTRA_REMOTE_MESSAGE = "remote_message"

    // Message Data
    @Suppress("unused")
    const val MESSAGE_DATA_TYPE = "notification_type"
    @Suppress("unused")
    const val MESSAGE_DATA_PAYLOAD = "notification_payload"

    const val MESSAGE_TYPE_ADDRESS_TXS_CONFIRMED = "address_txs_confirmed"
    const val MESSAGE_TYPE_LNURL_PAY_INFO = "lnurlpay_info"
    const val MESSAGE_TYPE_LNURL_PAY_INVOICE = "lnurlpay_invoice"
    const val MESSAGE_TYPE_PAYMENT_RECEIVED = "payment_received"

    // Resource Identifiers
    const val ADDRESS_TXS_CONFIRMED_NOTIFICATION_CHANNEL_DESCRIPTION =
        "address_txs_confirmed_notification_channel_description"
    const val ADDRESS_TXS_CONFIRMED_NOTIFICATION_CHANNEL_NAME =
        "address_txs_confirmed_notification_channel_name"
    const val ADDRESS_TXS_CONFIRMED_WORKGROUP_ID = "txs_confirmed"
    const val ADDRESS_TXS_CONFIRMED_WORKGROUP_DESCRIPTION =
        "address_txs_confirmed_work_group_description"
    const val ADDRESS_TXS_CONFIRMED_WORKGROUP_NAME = "address_txs_confirmed_work_group_name"
    const val FOREGROUND_SERVICE_NOTIFICATION_CHANNEL_DESCRIPTION =
        "foreground_service_notification_channel_description"
    const val FOREGROUND_SERVICE_NOTIFICATION_CHANNEL_NAME =
        "foreground_service_notification_channel_name"
    const val FOREGROUND_SERVICE_NOTIFICATION_TITLE =
        "foreground_service_notification_title"
    const val LNURL_PAY_INFO_NOTIFICATION_TITLE =
        "lnurl_pay_info_notification_title"
    const val LNURL_PAY_INVOICE_NOTIFICATION_TITLE =
        "lnurl_pay_invoice_notification_title"
    const val LNURL_PAY_METADATA_PLAIN_TEXT =
        "lnurl_pay_metadata_plain_text"
    const val LNURL_PAY_NOTIFICATION_CHANNEL_DESCRIPTION =
        "lnurl_pay_notification_channel_description"
    const val LNURL_PAY_NOTIFICATION_CHANNEL_NAME =
        "lnurl_pay_notification_channel_name"
    const val LNURL_PAY_NOTIFICATION_FAILURE_TITLE =
        "lnurl_pay_notification_failure_title"
    const val LNURL_PAY_NOTIFICATION_LIQUIDITY_FAILURE_TITLE =
        "lnurl_pay_notification_liquidity_failure_title"
    const val LNURL_PAY_WORKGROUP_ID = "lnurl_pay"
    const val LNURL_PAY_WORKGROUP_DESCRIPTION = "lnurl_pay_work_group_description"
    const val LNURL_PAY_WORKGROUP_NAME = "lnurl_pay_work_group_name"
    const val PAYMENT_RECEIVED_NOTIFICATION_CHANNEL_DESCRIPTION =
        "payment_received_notification_channel_description"
    const val PAYMENT_RECEIVED_NOTIFICATION_CHANNEL_NAME =
        "payment_received_notification_channel_name"
    const val PAYMENT_RECEIVED_NOTIFICATION_TEXT =
        "payment_received_notification_text"
    const val PAYMENT_RECEIVED_NOTIFICATION_TITLE =
        "payment_received_notification_title"
    const val NOTIFICATION_COLOR = "default_notification_color"
    const val NOTIFICATION_ICON = "ic_stat_ic_notification"
    const val OFFLINE_PAYMENTS_WORKGROUP_ID = "offline_payments"
    const val OFFLINE_PAYMENTS_WORKGROUP_DESCRIPTION =
        "offline_payments_work_group_description"
    const val OFFLINE_PAYMENTS_WORKGROUP_NAME = "offline_payments_work_group_name"
    const val SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TEXT =
        "swap_tx_confirmed_notification_failure_text"
    const val SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TITLE =
        "swap_tx_confirmed_notification_failure_title"
    const val SWAP_TX_CONFIRMED_NOTIFICATION_TITLE =
        "swap_tx_confirmed_notification_title"

    // Resource Identifier Defaults
    const val DEFAULT_ADDRESS_TXS_CONFIRMED_NOTIFICATION_CHANNEL_DESCRIPTION =
        "Notifications for confirmed transactions when the application is in the background"
    const val DEFAULT_ADDRESS_TXS_CONFIRMED_NOTIFICATION_CHANNEL_NAME =
        "Confirmed Transactions"
    const val DEFAULT_ADDRESS_TXS_CONFIRMED_WORKGROUP_DESCRIPTION =
        "Required to handle confirmed transactions when the application is in the background"
    const val DEFAULT_ADDRESS_TXS_CONFIRMED_WORKGROUP_NAME = "Confirmed Transactions"
    const val DEFAULT_FOREGROUND_SERVICE_NOTIFICATION_CHANNEL_DESCRIPTION =
        "Shown when the application is in the background"
    const val DEFAULT_FOREGROUND_SERVICE_NOTIFICATION_CHANNEL_NAME =
        "Foreground Service"
    const val DEFAULT_FOREGROUND_SERVICE_NOTIFICATION_TITLE =
        "Running in the background"
    const val DEFAULT_LNURL_PAY_INFO_NOTIFICATION_TITLE =
        "Retrieving Payment Information"
    const val DEFAULT_LNURL_PAY_INVOICE_NOTIFICATION_TITLE =
        "Fetching Invoice"
    const val DEFAULT_LNURL_PAY_METADATA_PLAIN_TEXT =
        "Pay with LNURL"
    const val DEFAULT_LNURL_PAY_NOTIFICATION_CHANNEL_DESCRIPTION =
        "Notifications for receiving payments when the application is in the background"
    const val DEFAULT_LNURL_PAY_NOTIFICATION_CHANNEL_NAME = "Receiving Payments"
    const val DEFAULT_LNURL_PAY_NOTIFICATION_FAILURE_TITLE =
        "Receive Payment Failed"
    const val DEFAULT_LNURL_PAY_NOTIFICATION_LIQUIDITY_FAILURE_TITLE =
        "Fee Limit Too Low"
    const val DEFAULT_LNURL_PAY_WORKGROUP_DESCRIPTION =
        "Required to handle LNURL pay requests when the application is in the background"
    const val DEFAULT_LNURL_PAY_WORKGROUP_NAME = "LNURL Payments"
    const val DEFAULT_PAYMENT_RECEIVED_NOTIFICATION_CHANNEL_NAME = "Received Payments"
    const val DEFAULT_PAYMENT_RECEIVED_NOTIFICATION_CHANNEL_DESCRIPTION =
        "Notifications for received payments when the application is in the background"
    const val DEFAULT_PAYMENT_RECEIVED_NOTIFICATION_TEXT =
        "Received %d sats"
    const val DEFAULT_PAYMENT_RECEIVED_NOTIFICATION_TITLE =
        "Payment Received"
    const val DEFAULT_NOTIFICATION_COLOR = "#0089F9"
    const val DEFAULT_OFFLINE_PAYMENTS_WORKGROUP_DESCRIPTION =
        "Required to receive payments when the application is in the background"
    const val DEFAULT_OFFLINE_PAYMENTS_WORKGROUP_NAME = "Offline Payments"
    const val DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TEXT =
        "Tap to complete swap"
    const val DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TITLE =
        "Swap Ongoing"
    const val DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_TITLE =
        "Swap Confirmed"
}
