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
    /// Set the API key
    SetAPIKey {
        /// The API key to use        
        key: String,
    },
    /// Set the Environment type
    SetEnv {
        /// The environment to use (staging|production)        
        env: EnvironmentType,
    },
    /// Connect to the sdk services, make it operational
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
    },

    /// Sync local data with remote node
    Sync {},

    /// Triggers a backup of the local data
    Backup {},

    /// Fetch the static backup data
    StaticBackup {},

    /// Parse a generic string to get its type and relevant metadata
    Parse {
        /// Generic input (URL, LNURL, BIP-21 BTC Address, LN invoice, etc)
        input: String,
    },

    /// Generate a bolt11 invoice
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

    /// Pay using lnurl pay
    LnurlPay { lnurl: String },

    /// Withdraw using lnurl withdraw
    LnurlWithdraw { lnurl: String },

    /// Authenticate using lnurl auth
    LnurlAuth { lnurl: String },

    /// Send on-chain using a reverse swap
    SendOnchain {
        amount_sat: u64,
        onchain_recipient_address: String,
        /// The fee rate for the claim transaction
        sat_per_vbyte: u32,
    },

    /// Get the current fees for a potential new reverse swap
    FetchOnchainFees {
        #[clap(name = "amount", short = 'a', long = "amt")]
        send_amount_sat: Option<u64>,
    },

    /// Get the current blocking in-progress reverse swaps, if any exist
    InProgressReverseSwaps {},

    /// Send a lightning payment
    SendPayment {
        bolt11: String,

        #[clap(name = "amount_msat", short = 'a', long = "amt")]
        amount_msat: Option<u64>,
    },

    /// Send a spontaneous (keysend) payment
    SendSpontaneousPayment { node_id: String, amount_msat: u64 },

    /// Sign a message with the node's private key
    SignMessage { message: String },

    /// Verify a message with a node's public key
    CheckMessage {
        message: String,
        pubkey: String,
        signature: String,
    },

    /// List all payments
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
    },

    /// Retrieve a payment by its hash
    PaymentByHash { hash: String },

    /// Send on-chain funds to an external address
    Sweep {
        /// The sweep destination address
        to_address: String,

        /// The fee rate for the sweep transaction
        fee_rate_sats_per_vbyte: u32,
    },

    /// Calculate the fee (in sats) for a potential transaction
    PrepareSweep {
        /// The destination address
        to_address: String,

        /// The fee rate for the transaction in vbyte/sats
        sats_per_vbyte: u32,
    },

    /// List available LSPs
    ListLsps {},

    /// Connect to an LSP
    ConnectLSP {
        /// The lsp id the sdk should connect to
        lsp_id: String,
    },

    OpenChannelFee {
        /// The received amount
        amount_msat: u64,

        /// The expiration of the fee returned
        expiry: Option<u32>,
    },

    /// The up to date node information
    NodeInfo {},

    /// List fiat currencies
    ListFiat {},

    /// Fetch available fiat rates
    FetchFiatRates {},

    /// Close all LSP channels
    CloseLSPChannels {},

    /// Stop the node and disconnect from the sdk services
    Disconnect {},

    /// List recommended fees based on the mempool
    RecommendedFees {},

    /// Generate address to receive onchain
    ReceiveOnchain {},

    /// Get the current in-progress swap if exists
    InProgressSwap {},

    /// List refundable swap addresses
    ListRefundables {},

    /// Broadcast a refund transaction for an incomplete swap
    Refund {
        swap_address: String,
        to_address: String,
        sat_per_vbyte: u32,
    },

    /// Execute a low level node command (used for debugging)
    ExecuteDevCommand { command: String },

    /// Generates an URL to buy bitcoin from a 3rd party provider
    BuyBitcoin { provider: BuyBitcoinProvider },
}
