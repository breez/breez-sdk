use breez_sdk_core::{BuyBitcoinProvider, EnvironmentType};
use clap::Parser;

#[derive(Parser, Debug)]
pub(crate) struct SdkCli {
    /// Optional data dir, default to current directory
    #[clap(name = "data_dir", short = 'd', long = "data_dir")]
    pub(crate) data_dir: Option<String>,
}

#[derive(Parser, Debug, Clone, PartialEq)]
#[clap(rename_all = "snake")]
pub(crate) enum Commands {
    /// [config] Set the API key
    SetAPIKey {
        /// The API key to use        
        key: String,
    },
    /// [config] Set the Environment type
    SetEnv {
        /// The environment to use (staging|production)        
        env: EnvironmentType,
    },
    /// [init] Connect to the sdk services, make it operational
    Connect {
        /// The optional file location containing the greenlight partner certificate
        #[clap(name = "partner_cert", short = 'c', long = "partner_cert")]
        partner_cert: Option<std::path::PathBuf>,

        /// The optional file location containing the greenlight partner key
        #[clap(name = "partner_key", short = 'k', long = "partner_key")]
        partner_key: Option<std::path::PathBuf>,

        /// The optional greenlight invite code
        #[clap(name = "invite_code", short = 'i', long = "invite_code")]
        invite_code: Option<String>,

        /// Only restore existing nodes
        #[clap(short = 'r', long = "restore_only")]
        restore_only: bool,
    },

    /// [pay] Send a lightning payment
    SendPayment {
        bolt11: String,

        #[clap(name = "amount_msat", short = 'a', long = "amt")]
        amount_msat: Option<u64>,

        /// The external label or identifier of the payment
        #[clap(name = "label", short = 'l', long = "label")]
        label: Option<String>,

        /// The option timeout in which a pending payment is returned if not already finished.
        #[clap(name = "seconds", short = 't', long = "pending_timeout")]
        pending_timeout_sec: Option<u64>,
    },

    /// [pay] Send a spontaneous (keysend) payment
    SendSpontaneousPayment {
        node_id: String,
        amount_msat: u64,

        /// The external label or identifier of the payment
        #[clap(name = "label", short = 'l', long = "label")]
        label: Option<String>,
    },

    /// [pay] Generate a bolt11 invoice
    ReceivePayment {
        amount_msat: u64,
        description: String,
        #[clap(name = "use_description_hash", short = 's', long = "desc_hash")]
        use_description_hash: Option<bool>,
        #[clap(name = "expiry", short = 'e', long = "expiry")]
        expiry: Option<u32>,
        #[clap(name = "cltv", short = 'c', long = "cltv")]
        cltv: Option<u32>,
    },

    /// [pay] List recommended fees based on the mempool
    RecommendedFees {},

    /// [pay] Find the current fees for opening a new channel
    OpenChannelFee {
        /// The received amount
        amount_msat: Option<u64>,

        /// The expiration of the fee returned
        expiry: Option<u32>,
    },

    /// [lnurl] Pay using lnurl pay
    LnurlPay {
        lnurl: String,

        /// The external label or identifier of the payment
        #[clap(name = "label", short = 'l', long = "label")]
        label: Option<String>,
    },

    /// [lnurl] Withdraw using lnurl withdraw
    LnurlWithdraw { lnurl: String },

    /// [lnurl] Authenticate using lnurl auth
    LnurlAuth { lnurl: String },

    /// [swap-in] Generate address to receive onchain
    ReceiveOnchain {},

    /// [swap-in] Get the current in-progress swap if exists
    InProgressSwap {},

    /// [swap-in] List refundable swap addresses
    ListRefundables {},

    /// [swap-in] Rescan all swaps
    RescanSwaps {},

    /// [swap-in] Prepare a refund transaction for an incomplete swap
    PrepareRefund {
        swap_address: String,
        to_address: String,
        sat_per_vbyte: u32,
    },

    /// [swap-in] Broadcast a refund transaction for an incomplete swap
    Refund {
        swap_address: String,
        to_address: String,
        sat_per_vbyte: u32,
    },

    /// [swap-out] Send on-chain using a reverse swap
    SendOnchain {
        amount_sat: u64,
        onchain_recipient_address: String,
        /// The fee rate for the claim transaction
        sat_per_vbyte: u32,
    },

    /// [swap-out] The maximum amount that can be sent onchain with a reverse swap
    MaxReverseSwapAmount {},

    /// [swap-out] Get the current fees for a potential new reverse swap
    FetchOnchainFees {
        #[clap(name = "amount", short = 'a', long = "amt")]
        send_amount_sat: Option<u64>,

        #[clap(name = "claim_feerate", short = 'f', long = "feerate")]
        claim_tx_feerate: Option<u32>,
    },

    /// [swap-out] Get the current blocking in-progress reverse swaps, if any exist
    InProgressReverseSwaps {},

    /// [swap-out-v2] The min-max range supported by Boltz at the moment
    OnchainPaymentLimits {},

    /// [swap-out-v2] Prepares, but does not initiate, a reverse swap payment
    PrepareOnchainPayment {
        /// Depending on `is_send`, this may be the desired send amount or the desired receive amount.
        #[clap(name = "amount_sat", short = 'a', long = "amt")]
        amount_sat: u64,

        /// If set, the amount is the desired send amount. Otherwise, it is the desired receive amount.
        #[clap(name = "is-send", short = 's', long = "is-send")]
        is_send: bool,

        /// The claim tx feerate
        #[clap(name = "claim_tx_feerate", short = 'f', long = "feerate")]
        claim_tx_feerate: u32,
    },

    /// [swap-out-v2] Prepares and initiates a reverse swap payment
    PayOnchain {
        /// Depending on `is_send`, this may be the desired send amount or the desired receive amount.
        #[clap(name = "amount_sat", short = 'a', long = "amt")]
        amount_sat: u64,

        /// If set, the amount is the desired send amount. Otherwise, it is the desired receive amount.
        #[clap(name = "is-send", short = 's', long = "is-send")]
        is_send: bool,

        /// The claim tx feerate
        #[clap(name = "claim_tx_feerate", short = 'f', long = "feerate")]
        claim_tx_feerate: u32,

        recipient_address: String,
    },

    /// [sign] Sign a message with the node's private key
    SignMessage { message: String },

    /// [sign] Verify a message with a node's public key
    CheckMessage {
        message: String,
        pubkey: String,
        signature: String,
    },

    /// [redeem] Send on-chain funds to an external address
    RedeemOnchainFunds {
        /// The redeem_onchain_funds destination address
        to_address: String,

        /// The fee rate for the redeem_onchain_funds transaction
        sat_per_vbyte: u32,
    },

    /// [redeem] Calculate the fee (in sats) for a potential transaction
    PrepareRedeemOnchainFunds {
        /// The destination address
        to_address: String,

        /// The fee rate for the transaction in vbyte/sats
        sat_per_vbyte: u32,
    },

    /// [lsp] The up to date lsp information
    LspInfo {},

    /// [lsp] List available LSPs
    ListLsps {},

    /// [lsp] Connect to an LSP
    ConnectLSP {
        /// The lsp id the sdk should connect to
        lsp_id: String,
    },

    /// [lsp] Close all LSP channels
    CloseLSPChannels {},

    /// [support] Fetches the service health check
    ServiceHealthCheck {},

    /// [support] Send a payment failure report
    ReportPaymentFailure {
        payment_hash: String,
        comment: Option<String>,
    },

    /// [node-mgmt] Sync local data with remote node
    Sync {},

    /// [node-mgmt] Triggers a backup of the local data
    Backup {},

    /// [node-mgmt] Fetch the static backup data
    StaticBackup {},

    /// [node-mgmt] Parse a generic string to get its type and relevant metadata
    Parse {
        /// Generic input (URL, LNURL, BIP-21 BTC Address, LN invoice, etc)
        input: String,
    },

    /// [node-mgmt] List all payments
    ListPayments {
        /// The optional from unix timestamp
        #[clap(name = "from_timestamp", short = 'f', long = "from")]
        from_timestamp: Option<i64>,

        /// The optional to unix timestamp
        #[clap(name = "to_timestamp", short = 't', long = "to")]
        to_timestamp: Option<i64>,

        /// Include failed payments
        #[clap(short = 'i', long = "include_failures")]
        include_failures: bool,

        /// Optional limit of listed payments
        #[clap(short = 'l', long = "limit")]
        limit: Option<u32>,

        /// Optional offset in payments
        #[clap(short = 'o', long = "offset")]
        offset: Option<u32>,

        /// Optional metadata filter, in the form of json_path:json_value
        #[clap(short = 'm', long = "metadata", num_args = 1..)]
        metadata_filters: Option<Vec<String>>,
    },

    /// [node-mgmt] Set the metadata for a given payment
    SetPaymentMetadata {
        payment_hash: String,
        metadata: String,
    },

    /// [node-mgmt] Retrieve a payment by its hash
    PaymentByHash { hash: String },

    /// [node-mgmt] The node credentials
    NodeCredentials {},

    /// [node-mgmt] The up to date node information
    NodeInfo {},

    /// [node-mgmt] Configure the node
    ConfigureNode {
        // Optional address to send funds to during a mutual channel close
        #[clap(short = 'c', long = "close_to_address")]
        close_to_address: Option<String>,
    },

    /// [node-mgmt] Stop the node and disconnect from the sdk services
    Disconnect {},

    /// [node-mgmt] Register a webhook URL, where the SDK will trigger a callback on specific events.
    RegisterWebhook { url: String },

    /// [node-mgmt] Unregister a webhook URL.
    UnregisterWebhook { url: String },

    /// [buy] Generates an URL to buy bitcoin from a 3rd party provider
    BuyBitcoin { provider: BuyBitcoinProvider },

    /// [fiat] List fiat currencies
    ListFiat {},

    /// [fiat] Fetch available fiat rates
    FetchFiatRates {},

    /// [dev] Execute a low level node command (used for debugging)
    ExecuteDevCommand { command: String },

    /// [dev] Generates and retrieves a diagnostic data report from the sdk services (used for debugging)
    GenerateDiagnosticData {},
}
