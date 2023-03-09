use crate::chain::{ChainService, MempoolSpace, RecommendedFees};
use crate::fiat::{FiatCurrency, Rate};
use crate::greenlight::Greenlight;
use crate::grpc::channel_opener_client::ChannelOpenerClient;
use crate::grpc::fund_manager_client::FundManagerClient;
use crate::grpc::information_client::InformationClient;
use crate::grpc::PaymentInformation;
use crate::input_parser::LnUrlPayRequestData;
use crate::invoice::{add_routing_hints, parse_invoice, LNInvoice, RouteHint, RouteHintHop};
use crate::lnurl::pay::model::SuccessAction::Aes;
use crate::lnurl::pay::model::{
    LnUrlPayResult, SuccessAction, SuccessActionProcessed, ValidatedCallbackResponse,
};
use crate::lnurl::pay::validate_lnurl_pay;
use crate::lnurl::withdraw::model::LnUrlWithdrawCallbackStatus;
use crate::lnurl::withdraw::validate_lnurl_withdraw;
use crate::lsp::LspInformation;
use crate::models::{
    parse_short_channel_id, ChannelState, ClosedChannelPaymentDetails, Config, EnvironmentType,
    FiatAPI, GreenlightCredentials, LspAPI, Network, NodeAPI, NodeState, Payment, PaymentDetails,
    PaymentType, PaymentTypeFilter, ReverseSwapPairInfo, ReverseSwapperAPI, SwapInfo, SwapperAPI,
};
use crate::persist::db::SqliteStorage;
use crate::reverseswap::BTCSendSwap;
use crate::swap::BTCReceiveSwap;
use crate::{LnUrlWithdrawRequestData, ReverseSwapInfo};
use anyhow::{anyhow, Result};
use bip39::*;
use std::cmp::max;
use std::str::FromStr;
use std::sync::Arc;
use std::time::{SystemTime, UNIX_EPOCH};
use tokio::runtime::Runtime;
use tokio::sync::{mpsc, Mutex};
use tokio::time::{sleep, Duration};
use tonic::codegen::InterceptedService;
use tonic::metadata::{Ascii, MetadataValue};
use tonic::service::Interceptor;
use tonic::transport::{Channel, Uri};
use tonic::{Request, Status};

/// Trait that can be used to react to various [BreezEvent]s emitted by the SDK.
pub trait EventListener: Send + Sync {
    fn on_event(&self, e: BreezEvent);
}

/// Event emitted by the SDK. To listen for and react to these events, use an [EventListener] when
/// initializing the [BreezServices].
#[derive(Clone, Debug)]
#[allow(clippy::large_enum_variant)]
pub enum BreezEvent {
    /// Indicates that a new block has just been found
    NewBlock { block: u32 },
    /// Indicates that a new invoice has just been paid
    InvoicePaid { details: InvoicePaidDetails },
    /// Indicates that the local SDK state has just been sync-ed with the remote components
    Synced,
    /// Indicates that an outgoing payment has been completed successfully
    PaymentSucceed { details: Payment },
    /// Indicates that an outgoing payment has been failed to complete
    PaymentFailed { error: String },
}

/// Details of an invoice that has been paid, included as payload in an emitted [BreezEvent]
#[derive(Clone, Debug)]
pub struct InvoicePaidDetails {
    pub payment_hash: String,
    pub bolt11: String,
}

/// Starts the BreezServices background threads.
///
/// Internal method. Should only be used as part of [BreezServices::start]
async fn start_threads(
    rt: &Runtime,
    breez_services: Arc<BreezServices>,
) -> Result<mpsc::Sender<()>> {
    // start the signer
    let (shutdown_signer_sender, signer_signer_receiver) = mpsc::channel(1);
    let signer_api = breez_services.clone();
    rt.spawn(async move {
        signer_api
            .node_api
            .start_signer(signer_signer_receiver)
            .await;
    });

    // sync with remote state
    let breez_cloned = breez_services.clone();
    breez_cloned.sync().await?;

    // create a shutdown channel (sender and receiver)
    let (stop_sender, mut stop_receiver) = mpsc::channel(1);

    // poll sdk events
    rt.spawn(async move {
        let current_block: u32 = 0;
        loop {
            tokio::select! {

              poll_result = poll_events(breez_services.clone(), current_block) => {
               match poll_result {
                Ok(()) => {
                 return;
                },
                Err(err) => {
                 debug!("poll_events returned with error: {:?} waiting...", err);
                 sleep(Duration::from_secs(1)).await;
                 continue
                }
               }
              },
              _ = stop_receiver.recv() => {
               _ = shutdown_signer_sender.send(()).await;
               debug!("Received the signal to exit event polling loop");
               return;
             }
            }
        }
    });
    Ok(stop_sender)
}

/// BreezServices is a facade and the single entry point for the SDK.
pub struct BreezServices {
    node_api: Arc<dyn NodeAPI>,
    lsp_api: Arc<dyn LspAPI>,
    fiat_api: Arc<dyn FiatAPI>,
    chain_service: Arc<dyn ChainService>,
    persister: Arc<SqliteStorage>,
    payment_receiver: Arc<PaymentReceiver>,
    btc_receive_swapper: Arc<BTCReceiveSwap>,
    btc_send_swapper: Arc<BTCSendSwap>,
    event_listener: Option<Box<dyn EventListener>>,
    shutdown_sender: Mutex<Option<mpsc::Sender<()>>>,
}

use crate::boltzswap::BoltzApi;
use bitcoin_hashes::{sha256, Hash};

impl BreezServices {
    /// Create a new node for the given network, from the given seed
    pub async fn register_node(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
        Greenlight::register(network, seed.clone()).await
    }

    /// Try to recover a previously created node
    pub async fn recover_node(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
        Greenlight::recover(network, seed.clone()).await
    }

    /// Create and initialize the node services instance
    pub async fn init_services(
        config: Config,
        seed: Vec<u8>,
        creds: GreenlightCredentials,
        event_listener: Box<dyn EventListener>,
    ) -> Result<Arc<BreezServices>> {
        BreezServicesBuilder::new(config)
            .greenlight_credentials(creds, seed)
            .build(Some(event_listener))
            .await
    }

    /// Starts the BreezServices background threads for this instance.
    ///
    /// It should be called once right after creating [BreezServices], since it is essential for the
    /// communicating with the node.
    ///
    /// It should be called only once when the app is started, regardless whether the app is sent to
    /// background and back.
    pub async fn start(runtime: &Runtime, breez_services: &Arc<BreezServices>) -> Result<()> {
        let mut start_lock = breez_services.shutdown_sender.lock().await;
        if start_lock.is_some() {
            return Err(anyhow!("start can only be called once"));
        }
        let shutdown_handler = start_threads(runtime, breez_services.clone()).await?;
        *start_lock = Some(shutdown_handler);
        Ok(())
    }

    /// Trigger the stopping of BreezServices background threads for this instance.
    pub async fn stop(&self) -> Result<()> {
        let unlocked = self.shutdown_sender.lock().await;
        if unlocked.is_none() {
            return Err(anyhow!("node has not been started"));
        }
        let sender = unlocked.as_ref().unwrap();
        sender.send(()).await.map_err(anyhow::Error::msg)
    }

    /// Pay a bolt11 invoice
    ///
    /// If the invoice doesn't specify an amount, the amount is taken from the `amount_sats` arg.
    ///
    /// # Arguments
    ///
    /// * `bolt11` - The bolt11 invoice
    /// * `amount_sats` - The amount to pay in satoshis
    pub async fn send_payment(&self, bolt11: String, amount_sats: Option<u64>) -> Result<Payment> {
        self.start_node().await?;
        let payment_res = self.node_api.send_payment(bolt11, amount_sats).await;
        self.on_payment_completed(payment_res).await
    }

    /// Pay directly to a node id using keysend
    ///
    /// # Arguments
    ///
    /// * `node_id` - The destination node_id
    /// * `amount_sats` - The amount to pay in satoshis
    pub async fn send_spontaneous_payment(
        &self,
        node_id: String,
        amount_sats: u64,
    ) -> Result<Payment> {
        self.start_node().await?;
        let payment_res = self
            .node_api
            .send_spontaneous_payment(node_id, amount_sats)
            .await;
        self.on_payment_completed(payment_res).await
    }

    /// Second step of LNURL-pay. The first step is `parse()`, which also validates the LNURL destination
    /// and generates the `LnUrlPayRequestData` payload needed here.
    ///
    /// This call will validate the given `user_amount_sat` and `comment` against the parameters
    /// of the LNURL endpoint (`req_data`). If they match the endpoint requirements, the LNURL payment
    /// is made.
    ///
    /// This method will return an [anyhow::Error] when any validation check fails.
    pub async fn lnurl_pay(
        &self,
        user_amount_sat: u64,
        comment: Option<String>,
        req_data: LnUrlPayRequestData,
    ) -> Result<LnUrlPayResult> {
        match validate_lnurl_pay(user_amount_sat, comment, req_data).await? {
            ValidatedCallbackResponse::EndpointError { data: e } => {
                Ok(LnUrlPayResult::EndpointError { data: e })
            }
            ValidatedCallbackResponse::EndpointSuccess { data: cb } => {
                let payment = self.send_payment(cb.pr, None).await?;
                let details = match &payment.details {
                    PaymentDetails::ClosedChannel { .. } => {
                        return Err(anyhow!("Payment lookup found unexpected payment type"));
                    }
                    PaymentDetails::Ln { data } => data,
                };

                Ok(LnUrlPayResult::EndpointSuccess {
                    data: match cb.success_action {
                        Some(sa) => {
                            let processed_sa = match sa {
                                // For AES, we decrypt the contents on the fly
                                Aes(data) => {
                                    let preimage =
                                        sha256::Hash::from_str(&details.payment_preimage)?;
                                    let preimage_arr: [u8; 32] = preimage.into_inner();

                                    let decrypted = (data, &preimage_arr).try_into()?;
                                    SuccessActionProcessed::Aes { data: decrypted }
                                }
                                SuccessAction::Message(data) => {
                                    SuccessActionProcessed::Message { data }
                                }
                                SuccessAction::Url(data) => SuccessActionProcessed::Url { data },
                            };

                            // Store SA in its own table, associated to payment_hash
                            self.persister.insert_lnurl_success_action(
                                &details.payment_hash,
                                &processed_sa,
                            )?;

                            Some(processed_sa)
                        }
                        None => None,
                    },
                })
            }
        }
    }

    /// Second step of LNURL-withdraw. The first step is `parse()`, which also validates the LNURL destination
    /// and generates the `LnUrlWithdrawRequestData` payload needed here.
    ///
    /// This call will validate the given `amount_sats` against the parameters
    /// of the LNURL endpoint (`req_data`). If they match the endpoint requirements, the LNURL withdraw
    /// request is made. A successful result here means the endpoint started the payment.
    pub async fn lnurl_withdraw(
        &self,
        req_data: LnUrlWithdrawRequestData,
        amount_sats: u64,
        description: Option<String>,
    ) -> Result<LnUrlWithdrawCallbackStatus> {
        let invoice = self
            .receive_payment(amount_sats, description.unwrap_or_default())
            .await?;
        validate_lnurl_withdraw(req_data, invoice).await
    }

    /// Creates an bolt11 payment request.
    /// This also works when the node doesn't have any channels and need inbound liquidity.
    /// In such case when the invoice is paid a new zero-conf channel will be open by the LSP,
    /// providing inbound liquidity and the payment will be routed via this new channel.
    ///
    /// # Arguments
    ///
    /// * `description` - The bolt11 payment request description
    /// * `amount_sats` - The amount to receive in satoshis
    pub async fn receive_payment(
        &self,
        amount_sats: u64,
        description: String,
    ) -> Result<LNInvoice> {
        self.payment_receiver
            .receive_payment(amount_sats, description, None)
            .await
    }

    /// Retrieve the node state from the persistent storage
    pub fn node_info(&self) -> Result<Option<NodeState>> {
        self.persister.get_node_state()
    }

    /// List payments matching the given filters, as retrieved from persistent storage
    pub async fn list_payments(
        &self,
        filter: PaymentTypeFilter,
        from_timestamp: Option<i64>,
        to_timestamp: Option<i64>,
    ) -> Result<Vec<Payment>> {
        self.persister
            .list_payments(filter, from_timestamp, to_timestamp)
            .map_err(|err| anyhow!(err))
    }

    /// Sweep on-chain funds to the specified on-chain address, with the given feerate
    pub async fn sweep(&self, to_address: String, fee_rate_sats_per_byte: u64) -> Result<()> {
        self.start_node().await?;
        self.node_api
            .sweep(to_address, fee_rate_sats_per_byte)
            .await?;
        self.sync().await?;
        Ok(())
    }

    /// Fetch live rates of fiat currencies
    pub async fn fetch_fiat_rates(&self) -> Result<Vec<Rate>> {
        self.fiat_api.fetch_fiat_rates().await
    }

    /// List all supported fiat currencies for which there is a known exchange rate.
    pub async fn list_fiat_currencies(&self) -> Result<Vec<FiatCurrency>> {
        self.fiat_api.list_fiat_currencies().await
    }

    /// List available LSPs that can be selected by the user
    pub async fn list_lsps(&self) -> Result<Vec<LspInformation>> {
        self.lsp_api
            .list_lsps(self.node_info()?.ok_or_else(|| anyhow!("err"))?.id)
            .await
    }

    /// Select the LSP to be used and provide inbound liquidity
    pub async fn connect_lsp(&self, lsp_id: String) -> Result<()> {
        self.persister.set_lsp_id(lsp_id)?;
        self.sync().await?;
        Ok(())
    }

    /// Get the current LSP's ID
    pub async fn lsp_id(&self) -> Result<Option<String>> {
        self.persister.get_lsp_id()
    }

    /// Convenience method to look up [LspInformation] for a given LSP ID
    pub async fn fetch_lsp_info(&self, id: String) -> Result<Option<LspInformation>> {
        get_lsp_by_id(self.persister.clone(), self.lsp_api.clone(), id.as_str()).await
    }

    /// Close all channels with the current LSP.
    ///
    /// Should be called  when the user wants to close all the channels.
    pub async fn close_lsp_channels(&self) -> Result<()> {
        self.start_node().await?;
        let lsp = self.lsp_info().await?;
        self.node_api
            .close_peer_channels(lsp.pubkey)
            .await
            .map(|_| ())?;
        self.sync().await
    }

    /// Onchain receive swap API
    ///
    /// Create a [SwapInfo] that represents the details required to start a swap.
    /// Since we only allow one in-progress swap this method will return error if there is currenly
    /// a swap waiting for confirmation to be redeemed and by that complete the swap.
    /// In such case the [BreezServices::in_progress_swap] can be used to query the live swap status.
    ///
    /// See [SwapInfo] for details.
    pub async fn receive_onchain(&self) -> Result<SwapInfo> {
        let in_progress = self.in_progress_swap().await?;
        if in_progress.is_some() {
            return Err(anyhow!(format!(
                  "Swap in progress was detected for address {}.Use in_progress_swap method to get the current swap state",
                  in_progress.unwrap().bitcoin_address
              )));
        }

        self.btc_receive_swapper.create_swap_address().await
    }

    /// Returns an optional in-progress [SwapInfo].
    /// A [SwapInfo] is in-progress if it is waiting for confirmation to be redeemed and complete the swap.    
    pub async fn in_progress_swap(&self) -> Result<Option<SwapInfo>> {
        let tip = self.chain_service.current_tip().await?;
        self.btc_receive_swapper.execute_pending_swaps(tip).await?;
        let in_progress = self.btc_receive_swapper.list_in_progress().await?;
        if !in_progress.is_empty() {
            return Ok(Some(in_progress[0].clone()));
        }
        Ok(None)
    }

    pub async fn reverse_swap_info(&self) -> Result<ReverseSwapPairInfo> {
        self.btc_send_swapper.reverse_swap_info().await
    }

    /// The steps for a full reverse swap are:
    ///
    /// 1. User starts reverse swap (input: desired amount, destination BTC address)
    /// 2. Receive HODL invoice from Boltz
    /// 3. Pay the HODL invoice
    /// 4. Monitor on-chain "lock" tx (poll), notify user on confirmation
    /// 5. Broadcast "claim" tx (reveal preimage)
    ///
    /// This method covers steps 1 and 2 above.
    pub async fn send_onchain(
        &self,
        amount_sat: u64,
        onchain_recipient_address: String,
        pair_hash: String,
    ) -> Result<ReverseSwapInfo> {
        let routing_hop = self.lsp_info().await?;
        self.btc_send_swapper
            .create_reverse_swap(
                amount_sat,
                onchain_recipient_address.clone(),
                pair_hash,
                routing_hop.pubkey,
            )
            .await
    }

    /// list non-completed expired swaps that should be refunded bu calling [BreezServices::refund]
    pub async fn list_refundables(&self) -> Result<Vec<SwapInfo>> {
        self.btc_receive_swapper.list_refundables()
    }

    /// Construct and broadcast a refund transaction for a failed/expired swap
    pub async fn refund(
        &self,
        swap_address: String,
        to_address: String,
        sat_per_vbyte: u32,
    ) -> Result<String> {
        self.btc_receive_swapper
            .refund_swap(swap_address, to_address, sat_per_vbyte)
            .await
    }

    /// Execute a command directly on the NodeAPI interface.
    /// Mainly used to debugging.
    pub async fn execute_dev_command(&self, command: String) -> Result<String> {
        self.node_api.execute_command(command).await
    }

    /// This method sync the local state with the remote node state.
    /// The synced items are as follows:
    /// * node state - General information about the node and its liquidity status
    /// * channels - The list of channels and their status
    /// * payments - The incoming/outgoing payments
    pub async fn sync(&self) -> Result<()> {
        self.start_node().await?;
        self.connect_lsp_peer().await?;

        // First query the changes since last sync time.
        let since_timestamp = self.persister.last_payment_timestamp().unwrap_or(0);
        let new_data = &self.node_api.pull_changed(since_timestamp).await?;

        debug!(
            "pull changed time={:?} {:?}",
            since_timestamp, new_data.payments
        );

        // update node state and channels state
        self.persister.set_node_state(&new_data.node_state)?;
        self.persister.update_channels(&new_data.channels)?;

        //fetch closed_channel and convert them to Payment items.
        let closed_channel_payments_res: Result<Vec<Payment>> = self
            .persister
            .list_channels()?
            .into_iter()
            .filter(|c| c.state == ChannelState::Closed || c.state == ChannelState::PendingClose)
            .map(closed_channel_to_transaction)
            .collect();

        // update both closed channels and lightning transaction payments
        let mut payments = closed_channel_payments_res?;
        payments.extend(new_data.payments.clone());
        self.persister.insert_payments(&payments)?;
        self.notify_event_listeners(BreezEvent::Synced).await?;
        Ok(())
    }

    /// Connects to the selected LSP, if any
    async fn connect_lsp_peer(&self) -> Result<()> {
        let lsp = self.lsp_info().await.ok();
        if lsp.is_some() {
            let lsp_info = lsp.unwrap().clone();
            let node_id = lsp_info.pubkey;
            let address = lsp_info.host;
            debug!("connecting to lsp {}@{}", node_id.clone(), address.clone());
            self.node_api
                .connect_peer(node_id.clone(), address.clone())
                .await
                .map_err(anyhow::Error::msg)?;
            debug!("connected to lsp {}@{}", node_id.clone(), address.clone());
        }
        Ok(())
    }

    async fn on_payment_completed(&self, payment_res: Result<Payment>) -> Result<Payment> {
        if payment_res.is_err() {
            self.notify_event_listeners(BreezEvent::PaymentFailed {
                error: payment_res.as_ref().err().unwrap().to_string(),
            })
            .await?;
            return payment_res;
        }
        let payment = payment_res.unwrap();
        self.sync().await?;
        self.notify_event_listeners(BreezEvent::PaymentSucceed {
            details: payment.clone(),
        })
        .await?;
        Ok(payment)
    }

    async fn on_event(&self, e: BreezEvent) -> Result<()> {
        debug!("breez services got event {:?}", e);
        match e {
            BreezEvent::InvoicePaid { details: _ } => self.sync().await?,
            BreezEvent::NewBlock { block: _ } => self.sync().await?,
            _ => {}
        };

        self.notify_event_listeners(e.clone()).await
    }

    async fn notify_event_listeners(&self, e: BreezEvent) -> Result<()> {
        if let Err(err) = self.btc_receive_swapper.on_event(e.clone()).await {
            debug!(
                "btc_receive_swapper failed to processed event {:?}: {:?}",
                e, err
            )
        };

        if self.event_listener.is_some() {
            self.event_listener.as_ref().unwrap().on_event(e.clone())
        }
        Ok(())
    }

    /// Convenience method to look up LSP info based on current LSP ID
    pub async fn lsp_info(&self) -> Result<LspInformation> {
        get_lsp(self.persister.clone(), self.lsp_api.clone()).await
    }

    pub(crate) async fn start_node(&self) -> Result<()> {
        self.node_api.start().await
    }

    /// Get the recommended fees for onchain transactions
    pub async fn recommended_fees(&self) -> Result<RecommendedFees> {
        self.chain_service.recommended_fees().await
    }

    /// Get the full default config for a specific environment type
    pub fn default_config(env_type: EnvironmentType) -> Config {
        match env_type {
            EnvironmentType::Production => Config::production(),
            EnvironmentType::Staging => Config::staging(),
        }
    }
}

async fn poll_events(breez_services: Arc<BreezServices>, mut current_block: u32) -> Result<()> {
    let mut interval = tokio::time::interval(Duration::from_secs(30));
    let mut invoice_stream = breez_services.node_api.stream_incoming_payments().await?;
    let mut log_stream = breez_services.node_api.stream_log_messages().await?;

    loop {
        tokio::select! {

         // handle chain events
         _ = interval.tick() => {
          let tip_res = breez_services.chain_service.current_tip().await;
          match tip_res {
           Ok(next_block) => {
            debug!("got tip {:?}", next_block);
            if next_block > current_block {
             _  = breez_services.on_event(BreezEvent::NewBlock{block: next_block}).await;
            }
            current_block = next_block
           },
           Err(e) => {
            error!("failed to fetch next block {}", e)
           }
          };
         },
         paid_invoice_res = invoice_stream.message() => {
          match paid_invoice_res {
           Ok(Some(i)) => {
            debug!("invoice stream got new invoice");
            if let Some(gl_client::pb::incoming_payment::Details::Offchain(p)) = i.details {
                _  = breez_services.on_event(BreezEvent::InvoicePaid{details: InvoicePaidDetails {
                    payment_hash: hex::encode(p.payment_hash),
                    bolt11: p.bolt11,
                }}).await;
            }
           }
           // stream is closed, renew it
           Ok(None) => {
            debug!("invoice stream closed, renewing");
            invoice_stream = breez_services.node_api.stream_incoming_payments().await?;
           }
           Err(err) => {
            debug!("failed to process incoming payment {:?}", err);
            invoice_stream = breez_services.node_api.stream_incoming_payments().await?;
           }
          };
        },
         log_message_res = log_stream.message() => {
          match log_message_res {
           Ok(Some(l)) => {
            debug!("{}", l.line);
           },
           // stream is closed, renew it
           Ok(None) => {
            //debug!("log stream closed, renewing");
            log_stream = breez_services.node_api.stream_log_messages().await?;
           }
           Err(err) => {
            debug!("failed to process log entry {:?}", err);
            log_stream = breez_services.node_api.stream_log_messages().await?;
           }
          };
         }
        }
    }
}

fn closed_channel_to_transaction(channel: crate::models::Channel) -> Result<Payment> {
    let now = SystemTime::now();
    Ok(Payment {
        id: channel.funding_txid.clone(),
        payment_type: PaymentType::ClosedChannel,
        payment_time: channel
            .closed_at
            .unwrap_or(now.duration_since(UNIX_EPOCH)?.as_secs()) as i64,
        amount_msat: channel.spendable_msat,
        fee_msat: 0,
        pending: channel.state == ChannelState::PendingClose,
        description: Some("Closed Channel".to_string()),
        details: PaymentDetails::ClosedChannel {
            data: ClosedChannelPaymentDetails {
                short_channel_id: channel.short_channel_id,
                state: channel.state,
                funding_txid: channel.funding_txid,
            },
        },
    })
}

/// A helper struct to configure and build BreezServices
struct BreezServicesBuilder {
    config: Config,
    node_api: Option<Arc<dyn NodeAPI>>,
    creds: Option<GreenlightCredentials>,
    seed: Option<Vec<u8>>,
    lsp_api: Option<Arc<dyn LspAPI>>,
    fiat_api: Option<Arc<dyn FiatAPI>>,
    persister: Option<Arc<SqliteStorage>>,
    swapper_api: Option<Arc<dyn SwapperAPI>>,
    reverse_swapper_api: Option<Arc<dyn ReverseSwapperAPI>>,
}

#[allow(dead_code)]
impl BreezServicesBuilder {
    pub fn new(config: Config) -> BreezServicesBuilder {
        BreezServicesBuilder {
            config,
            node_api: None,
            creds: None,
            seed: None,
            lsp_api: None,
            fiat_api: None,
            persister: None,
            swapper_api: None,
            reverse_swapper_api: None,
        }
    }

    pub fn node_api(&mut self, node_api: Arc<dyn NodeAPI>) -> &mut Self {
        self.node_api = Some(node_api);
        self
    }

    pub fn lsp_api(&mut self, lsp_api: Arc<dyn LspAPI>) -> &mut Self {
        self.lsp_api = Some(lsp_api.clone());
        self
    }

    pub fn fiat_api(&mut self, fiat_api: Arc<dyn FiatAPI>) -> &mut Self {
        self.fiat_api = Some(fiat_api.clone());
        self
    }

    pub fn persister(&mut self, persister: Arc<SqliteStorage>) -> &mut Self {
        self.persister = Some(persister);
        self
    }

    pub fn swapper_api(&mut self, swapper_api: Arc<dyn SwapperAPI>) -> &mut Self {
        self.swapper_api = Some(swapper_api.clone());
        self
    }

    pub fn reverse_swapper_api(
        &mut self,
        reverse_swapper_api: Arc<dyn ReverseSwapperAPI>,
    ) -> &mut Self {
        self.reverse_swapper_api = Some(reverse_swapper_api.clone());
        self
    }

    pub fn greenlight_credentials(
        &mut self,
        creds: GreenlightCredentials,
        seed: Vec<u8>,
    ) -> &mut Self {
        self.creds = Some(creds);
        self.seed = Some(seed);
        self
    }

    pub async fn build(
        &self,
        listener: Option<Box<dyn EventListener>>,
    ) -> Result<Arc<BreezServices>> {
        if self.node_api.is_none() && (self.creds.is_none() || self.seed.is_none()) {
            return Err(anyhow!(
                "Either node_api or both credentials and seed should be provided"
            ));
        }

        let mut node_api = self.node_api.clone();
        if node_api.is_none() {
            if self.creds.is_none() || self.seed.is_none() {
                return Err(anyhow!(
                    "Either node_api or both credentials and seed should be provided"
                ));
            }
            let greenlight = Greenlight::new(
                self.config.clone(),
                self.seed.clone().unwrap(),
                self.creds.clone().unwrap(),
            )
            .await?;
            node_api = Some(Arc::new(greenlight));
        }
        let unwrapped_node_api = node_api.unwrap();

        // breez_server provides both FiatAPI & LspAPI implementations
        let breez_server = Arc::new(BreezServer::new(
            self.config.breezserver.clone(),
            self.config.api_key.clone(),
        ));

        // mempool space is used to monitor the chain
        let chain_service = Arc::new(MempoolSpace::from_base_url(
            self.config.mempoolspace_url.clone(),
        ));

        // The storage is implemented via sqlite.
        let persister = self.persister.clone().unwrap_or_else(|| {
            Arc::new(SqliteStorage::from_file(format!(
                "{}/storage.sql",
                self.config.working_dir
            )))
        });

        persister.init().unwrap();
        let current_lsp_id = persister.get_lsp_id()?;
        if current_lsp_id.is_none() && self.config.default_lsp_id.is_some() {
            persister.set_lsp_id(self.config.default_lsp_id.clone().unwrap())?;
        }

        let payment_receiver = Arc::new(PaymentReceiver {
            node_api: unwrapped_node_api.clone(),
            lsp: breez_server.clone(),
            persister: persister.clone(),
        });

        let btc_receive_swapper = Arc::new(BTCReceiveSwap::new(
            self.config.network.clone().into(),
            self.swapper_api
                .clone()
                .unwrap_or_else(|| breez_server.clone()),
            persister.clone(),
            chain_service.clone(),
            payment_receiver.clone(),
        ));

        let btc_send_swapper = Arc::new(BTCSendSwap::new(
            self.config.network.clone().into(),
            self.reverse_swapper_api
                .clone()
                .unwrap_or_else(|| Arc::new(BoltzApi {})),
            persister.clone(),
            chain_service.clone(),
        ));

        // Create the node services and it them statically
        let breez_services = Arc::new(BreezServices {
            node_api: unwrapped_node_api.clone(),
            lsp_api: self.lsp_api.clone().unwrap_or_else(|| breez_server.clone()),
            fiat_api: self
                .fiat_api
                .clone()
                .unwrap_or_else(|| breez_server.clone()),
            chain_service,
            persister,
            btc_receive_swapper,
            btc_send_swapper,
            payment_receiver,
            event_listener: listener,
            shutdown_sender: Mutex::new(None),
        });

        Ok(breez_services)
    }
}

#[derive(Clone)]
pub struct BreezServer {
    server_url: String,
    api_key: Option<String>,
}

impl BreezServer {
    pub fn new(server_url: String, api_key: Option<String>) -> Self {
        Self {
            server_url,
            api_key,
        }
    }

    pub(crate) async fn get_channel_opener_client(
        &self,
    ) -> Result<ChannelOpenerClient<InterceptedService<Channel, ApiKeyInterceptor>>> {
        let s = self.server_url.clone();
        let channel = Channel::from_shared(s)?.connect().await?;

        let api_key_metadata: Option<MetadataValue<Ascii>> = match &self.api_key {
            Some(key) => Some(format!("Bearer {key}").parse()?),
            _ => None,
        };
        let client =
            ChannelOpenerClient::with_interceptor(channel, ApiKeyInterceptor { api_key_metadata });
        Ok(client)
    }

    pub(crate) async fn get_information_client(&self) -> Result<InformationClient<Channel>> {
        InformationClient::connect(Uri::from_str(&self.server_url)?)
            .await
            .map_err(|e| anyhow!(e))
    }

    pub(crate) async fn get_fund_manager_client(&self) -> Result<FundManagerClient<Channel>> {
        FundManagerClient::connect(Uri::from_str(&self.server_url)?)
            .await
            .map_err(|e| anyhow!(e))
    }
}

pub(crate) struct ApiKeyInterceptor {
    api_key_metadata: Option<MetadataValue<Ascii>>,
}
impl Interceptor for ApiKeyInterceptor {
    fn call(&mut self, mut req: Request<()>) -> Result<Request<()>, Status> {
        if self.api_key_metadata.clone().is_some() {
            req.metadata_mut()
                .insert("authorization", self.api_key_metadata.clone().unwrap());
        }
        Ok(req)
    }
}

/// Attempts to convert the phrase to a mnemonic, then to a seed.
///
/// If the phrase is not a valid mnemonic, an error is returned.
pub fn mnemonic_to_seed(phrase: String) -> Result<Vec<u8>> {
    let mnemonic = Mnemonic::from_phrase(&phrase, Language::English)?;
    let seed = Seed::new(&mnemonic, "");
    Ok(seed.as_bytes().to_vec())
}

#[tonic::async_trait]
pub trait Receiver: Send + Sync {
    async fn receive_payment(
        &self,
        amount_sats: u64,
        description: String,
        preimage: Option<Vec<u8>>,
    ) -> Result<LNInvoice>;
}

pub(crate) struct PaymentReceiver {
    node_api: Arc<dyn NodeAPI>,
    lsp: Arc<dyn LspAPI>,
    persister: Arc<SqliteStorage>,
}

#[tonic::async_trait]
impl Receiver for PaymentReceiver {
    async fn receive_payment(
        &self,
        amount_sats: u64,
        description: String,
        preimage: Option<Vec<u8>>,
    ) -> Result<LNInvoice> {
        self.node_api.start().await?;
        let lsp_info = get_lsp(self.persister.clone(), self.lsp.clone()).await?;
        let node_state = self
            .persister
            .get_node_state()?
            .ok_or("Failed to retrieve node state")
            .map_err(|err| anyhow!(err))?;

        let amount_msats = amount_sats * 1000;

        let mut short_channel_id = parse_short_channel_id("1x0x0")?;
        let mut destination_invoice_amount_sats = amount_msats;

        // check if we need to open channel
        if node_state.inbound_liquidity_msats < amount_msats {
            info!("We need to open a channel");

            // we need to open channel so we are calculating the fees for the LSP
            let channel_fees_msat_calculated =
                amount_msats * lsp_info.channel_fee_permyriad as u64 / 10_000 / 1_000_000;
            let channel_fees_msat = max(
                channel_fees_msat_calculated,
                lsp_info.channel_minimum_fee_msat as u64,
            );

            if amount_msats < channel_fees_msat + 1000 {
                return Err(anyhow!(
                    "requestPayment: Amount should be more than the minimum fees {} sats",
                    lsp_info.channel_minimum_fee_msat / 1000
                ));
            }

            // remove the fees from the amount to get the small amount on the current node invoice.
            destination_invoice_amount_sats = amount_sats - channel_fees_msat / 1000;
        } else {
            // not opening a channel so we need to get the real channel id into the routing hints
            info!("Finding channel ID for routing hint");
            for peer in self.node_api.list_peers().await? {
                if hex::encode(peer.id) == lsp_info.pubkey && !peer.channels.is_empty() {
                    let active_channel = peer
                        .channels
                        .iter()
                        .find(|&c| c.state == "CHANNELD_NORMAL")
                        .ok_or("No open channel found")
                        .map_err(|err| anyhow!(err))?;
                    let hint = match active_channel.clone().alias {
                        Some(aliases) => aliases.remote,
                        _ => active_channel.clone().short_channel_id,
                    };

                    short_channel_id = parse_short_channel_id(&hint)?;
                    info!(
                        "Found channel ID: {} {:?}",
                        short_channel_id, active_channel
                    );
                    break;
                }
            }
        }

        info!("Creating invoice on NodeAPI");
        let invoice = &self
            .node_api
            .create_invoice(amount_sats, description, preimage)
            .await?;
        info!("Invoice created {}", invoice.bolt11);

        let mut parsed_invoice = parse_invoice(&invoice.bolt11)?;

        // check if the lsp hint already exists
        let has_lsp_hint = parsed_invoice.routing_hints.iter().any(|h| {
            h.hops
                .iter()
                .any(|h| h.src_node_id == lsp_info.pubkey.clone())
        });

        if !has_lsp_hint {
            info!("Adding routing hint");
            let lsp_hop = RouteHintHop {
                src_node_id: lsp_info.pubkey.clone(), // TODO correct?
                short_channel_id,
                fees_base_msat: lsp_info.base_fee_msat as u32,
                fees_proportional_millionths: 10, // TODO
                cltv_expiry_delta: lsp_info.time_lock_delta as u64,
                htlc_minimum_msat: Some(lsp_info.min_htlc_msat as u64), // TODO correct?
                htlc_maximum_msat: Some(1000000000),                    // TODO ?
            };

            info!("lsp hop = {:?}", lsp_hop);

            let raw_invoice_with_hint = add_routing_hints(
                invoice.bolt11.clone(),
                vec![RouteHint {
                    hops: vec![lsp_hop],
                }],
                amount_sats * 1000,
            )?;
            info!("Routing hint added");
            let signed_invoice_with_hint = self.node_api.sign_invoice(raw_invoice_with_hint)?;
            parsed_invoice = parse_invoice(&signed_invoice_with_hint)?;
        }

        // register the payment at the lsp if needed
        if destination_invoice_amount_sats < amount_sats {
            info!("Registering payment with LSP");
            self.lsp
                .register_payment(
                    lsp_info.id.clone(),
                    lsp_info.lsp_pubkey.clone(),
                    PaymentInformation {
                        payment_hash: hex::decode(parsed_invoice.payment_hash.clone())?,
                        payment_secret: parsed_invoice.payment_secret.clone(),
                        destination: hex::decode(parsed_invoice.payee_pubkey.clone())?,
                        incoming_amount_msat: amount_msats as i64,
                        outgoing_amount_msat: (destination_invoice_amount_sats * 1000) as i64,
                    },
                )
                .await?;
            info!("Payment registered");
        }

        // return the signed, converted invoice with hints
        Ok(parsed_invoice)
    }
}

/// Convenience method to look up LSP info based on current LSP ID
async fn get_lsp(persister: Arc<SqliteStorage>, lsp: Arc<dyn LspAPI>) -> Result<LspInformation> {
    let lsp_id = persister
        .get_lsp_id()?
        .ok_or("No LSP ID found")
        .map_err(|err| anyhow!(err))?;

    get_lsp_by_id(persister, lsp, lsp_id.as_str())
        .await?
        .ok_or_else(|| anyhow!("No LSP found for id {}", lsp_id))
}

async fn get_lsp_by_id(
    persister: Arc<SqliteStorage>,
    lsp: Arc<dyn LspAPI>,
    lsp_id: &str,
) -> Result<Option<LspInformation>> {
    let node_pubkey = persister
        .get_node_state()?
        .ok_or("No NodeState found")
        .map_err(|err| anyhow!(err))?
        .id;

    Ok(lsp
        .list_lsps(node_pubkey)
        .await?
        .iter()
        .find(|&lsp| lsp.id.as_str() == lsp_id)
        .cloned())
}

#[cfg(test)]
pub(crate) mod tests {
    use std::sync::Arc;

    use anyhow::{anyhow, Result};

    use crate::breez_services::{BreezServices, BreezServicesBuilder};
    use crate::fiat::Rate;
    use crate::lnurl::pay::model::MessageSuccessActionData;
    use crate::lnurl::pay::model::SuccessActionProcessed;
    use crate::models::{LnPaymentDetails, NodeState, Payment, PaymentDetails, PaymentTypeFilter};
    use crate::PaymentType;
    use crate::{parse_short_channel_id, test_utils::*};

    use super::{PaymentReceiver, Receiver};

    #[tokio::test]
    async fn test_node_state() -> Result<(), Box<dyn std::error::Error>> {
        let storage_path = format!("{}/storage.sql", get_test_working_dir());
        std::fs::remove_file(storage_path).ok();

        let dummy_node_state = get_dummy_node_state();

        let sa = SuccessActionProcessed::Message {
            data: MessageSuccessActionData {
                message: "test message".into(),
            },
        };

        let payment_hash_with_lnurl_success_action = "3333";
        let dummy_transactions = vec![
            Payment {
                id: "1111".to_string(),
                payment_type: PaymentType::Received,
                payment_time: 100000,
                amount_msat: 10,
                fee_msat: 0,
                pending: false,
                description: Some("test receive".to_string()),
                details: PaymentDetails::Ln {
                    data: LnPaymentDetails {
                        payment_hash: "1111".to_string(),
                        label: "".to_string(),
                        destination_pubkey: "1111".to_string(),
                        payment_preimage: "2222".to_string(),
                        keysend: false,
                        bolt11: "1111".to_string(),
                        lnurl_success_action: None,
                    },
                },
            },
            Payment {
                id: payment_hash_with_lnurl_success_action.to_string(),
                payment_type: PaymentType::Sent,
                payment_time: 200000,
                amount_msat: 8,
                fee_msat: 2,
                pending: false,
                description: Some("test payment".to_string()),
                details: PaymentDetails::Ln {
                    data: LnPaymentDetails {
                        payment_hash: payment_hash_with_lnurl_success_action.to_string(),
                        label: "".to_string(),
                        destination_pubkey: "123".to_string(),
                        payment_preimage: "4444".to_string(),
                        keysend: false,
                        bolt11: "123".to_string(),
                        lnurl_success_action: Some(sa.clone()),
                    },
                },
            },
        ];
        let node_api = Arc::new(MockNodeAPI {
            node_state: dummy_node_state.clone(),
            transactions: dummy_transactions.clone(),
        });

        let test_config = create_test_config();
        let persister = Arc::new(create_test_persister(test_config.clone()));
        persister.init()?;
        persister.insert_payments(&dummy_transactions)?;
        persister.insert_lnurl_success_action(payment_hash_with_lnurl_success_action, &sa)?;

        let mut builder = BreezServicesBuilder::new(test_config.clone());
        let breez_services = builder
            .lsp_api(Arc::new(MockBreezServer {}))
            .fiat_api(Arc::new(MockBreezServer {}))
            .node_api(node_api)
            .persister(persister)
            .build(None)
            .await?;

        breez_services.sync().await?;
        let fetched_state = breez_services
            .node_info()?
            .ok_or("No NodeState found")
            .map_err(|err| anyhow!(err))?;
        assert_eq!(fetched_state, dummy_node_state);

        let all = breez_services
            .list_payments(PaymentTypeFilter::All, None, None)
            .await?;
        let mut cloned = all.clone();

        // test the right order
        cloned.reverse();
        assert_eq!(dummy_transactions, cloned);

        let received = breez_services
            .list_payments(PaymentTypeFilter::Received, None, None)
            .await?;
        assert_eq!(received, vec![cloned[0].clone()]);

        let sent = breez_services
            .list_payments(PaymentTypeFilter::Sent, None, None)
            .await?;
        assert_eq!(sent, vec![cloned[1].clone()]);
        assert!(matches!(
                &sent[0].details, PaymentDetails::Ln {data: LnPaymentDetails {lnurl_success_action, ..}} if lnurl_success_action == &Some(sa)));

        Ok(())
    }

    #[tokio::test]
    async fn test_receive_with_open_channel() -> Result<(), Box<dyn std::error::Error>> {
        let config = create_test_config();
        let persister = Arc::new(create_test_persister(config.clone()));
        persister.init().unwrap();

        let dummy_node_state = get_dummy_node_state();
        let node_api = Arc::new(MockNodeAPI {
            node_state: dummy_node_state.clone(),
            transactions: vec![],
        });

        let breez_server = Arc::new(MockBreezServer {});
        persister.set_lsp_id(breez_server.lsp_id()).unwrap();
        persister.set_node_state(&dummy_node_state).unwrap();

        let receiver: Arc<dyn Receiver> = Arc::new(PaymentReceiver {
            node_api,
            persister,
            lsp: breez_server.clone(),
        });
        let ln_invoice = receiver
            .receive_payment(3000, "should populate lsp hints".to_string(), None)
            .await?;
        assert_eq!(ln_invoice.routing_hints[0].hops.len(), 1);
        let lsp_hop = &ln_invoice.routing_hints[0].hops[0];
        assert_eq!(lsp_hop.src_node_id, breez_server.clone().lsp_pub_key());
        assert_eq!(
            lsp_hop.short_channel_id,
            parse_short_channel_id("1x0x0").unwrap()
        );
        Ok(())
    }

    #[tokio::test]
    async fn test_list_lsps() -> Result<(), Box<dyn std::error::Error>> {
        let storage_path = format!("{}/storage.sql", get_test_working_dir());
        std::fs::remove_file(storage_path).ok();

        let breez_services = breez_services().await?;
        breez_services.sync().await?;

        let node_pubkey = breez_services
            .node_info()?
            .ok_or("No NodeState found")
            .map_err(|err| anyhow!(err))?
            .id;
        let lsps = breez_services.lsp_api.list_lsps(node_pubkey).await?;
        assert_eq!(lsps.len(), 1);

        Ok(())
    }

    #[tokio::test]
    async fn test_fetch_rates() -> Result<(), Box<dyn std::error::Error>> {
        let breez_services = breez_services().await?;
        breez_services.sync().await?;

        let rates = breez_services.fiat_api.fetch_fiat_rates().await?;
        assert_eq!(rates.len(), 1);
        assert_eq!(
            rates[0],
            Rate {
                coin: "USD".to_string(),
                value: 20_000.00
            }
        );

        Ok(())
    }

    /// Build node service for tests
    pub(crate) async fn breez_services() -> Result<Arc<BreezServices>> {
        breez_services_with(vec![]).await
    }

    /// Build node service for tests with a list of known payments
    pub(crate) async fn breez_services_with(
        known_payments: Vec<Payment>,
    ) -> Result<Arc<BreezServices>> {
        let node_api = Arc::new(MockNodeAPI {
            node_state: get_dummy_node_state(),
            transactions: known_payments.clone(),
        });

        let test_config = create_test_config();
        let persister = Arc::new(create_test_persister(test_config.clone()));
        persister.init()?;
        persister.insert_payments(&known_payments)?;

        let mut builder = BreezServicesBuilder::new(test_config.clone());
        let breez_services = builder
            .lsp_api(Arc::new(MockBreezServer {}))
            .fiat_api(Arc::new(MockBreezServer {}))
            .persister(persister)
            .node_api(node_api)
            .build(None)
            .await
            .unwrap();

        Ok(breez_services)
    }

    /// Build dummy NodeState for tests
    pub(crate) fn get_dummy_node_state() -> NodeState {
        NodeState {
            id: "tx1".to_string(),
            block_height: 1,
            channels_balance_msat: 100,
            onchain_balance_msat: 1000,
            utxos: vec![],
            max_payable_msat: 95,
            max_receivable_msat: 1000,
            max_single_payment_amount_msat: 1000,
            max_chan_reserve_msats: 0,
            connected_peers: vec!["1111".to_string()],
            inbound_liquidity_msats: 2000,
        }
    }
}
