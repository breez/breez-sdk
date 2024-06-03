use std::cmp::{min, Reverse};
use std::iter::Iterator;
use std::pin::Pin;
use std::str::FromStr;
use std::sync::atomic::{AtomicU16, Ordering};
use std::sync::Arc;
use std::time::{Duration, SystemTime, UNIX_EPOCH};

use anyhow::{anyhow, Result};
use clap::Parser;
use ecies::symmetric::{sym_decrypt, sym_encrypt};
use futures::{Future, Stream};
use gl_client::node::ClnClient;
use gl_client::pb::cln::listinvoices_invoices::ListinvoicesInvoicesStatus;
use gl_client::pb::cln::listpays_pays::ListpaysPaysStatus;
use gl_client::pb::cln::listpeers_peers_channels::ListpeersPeersChannelsState::*;
use gl_client::pb::cln::{
    self, Amount, GetrouteRequest, GetrouteRoute, ListchannelsRequest,
    ListclosedchannelsClosedchannels, ListpeersPeersChannels, PreapproveinvoiceRequest,
    SendpayRequest, SendpayRoute, WaitsendpayRequest,
};
use gl_client::pb::scheduler::scheduler_client::SchedulerClient;
use gl_client::pb::scheduler::{NodeInfoRequest, UpgradeRequest};
use gl_client::pb::{OffChainPayment, PayStatus};
use gl_client::scheduler::Scheduler;
use gl_client::signer::model::greenlight::{amount, scheduler};
use gl_client::signer::{Error, Signer};
use gl_client::tls::TlsConfig;
use gl_client::{node, utils};
use serde::{Deserialize, Serialize};
use strum_macros::{Display, EnumString};
use tokio::sync::{mpsc, watch, Mutex};
use tokio::time::{sleep, MissedTickBehavior};
use tokio_stream::StreamExt;
use tonic::transport::{Endpoint, Uri};
use tonic::{Code, Streaming};

use crate::bitcoin::bech32::{u5, ToBase32};
use crate::bitcoin::blockdata::constants::WITNESS_SCALE_FACTOR;
use crate::bitcoin::hashes::Hash;
use crate::bitcoin::secp256k1::ecdsa::{RecoverableSignature, RecoveryId};
use crate::bitcoin::secp256k1::PublicKey;
use crate::bitcoin::secp256k1::Secp256k1;
use crate::bitcoin::util::bip32::{ChildNumber, ExtendedPrivKey};
use crate::bitcoin::{
    Address, OutPoint, Script, Sequence, Transaction, TxIn, TxOut, Txid, Witness,
};
use crate::invoice::{parse_invoice, validate_network, InvoiceError, RouteHintHop};
use crate::lightning::util::message_signing::verify;
use crate::lightning_invoice::{RawBolt11Invoice, SignedRawBolt11Invoice};
use crate::models::*;
use crate::node_api::{
    CreateInvoiceRequest, FetchBolt11Result, GraphChannel, NodeAPI, NodeError, NodeResult,
};
use crate::persist::db::SqliteStorage;
use crate::{
    NodeConfig, PrepareRedeemOnchainFundsRequest, PrepareRedeemOnchainFundsResponse, RouteHint,
};

const MAX_PAYMENT_AMOUNT_MSAT: u64 = 4294967000;
const MAX_INBOUND_LIQUIDITY_MSAT: u64 = 4000000000;

pub(crate) struct Greenlight {
    sdk_config: Config,
    signer: Signer,
    tls_config: TlsConfig,
    gl_client: Mutex<Option<node::Client>>,
    node_client: Mutex<Option<ClnClient>>,
    persister: Arc<SqliteStorage>,
    inprogress_payments: AtomicU16,
}

#[derive(Serialize, Deserialize)]
struct InvoiceLabel {
    pub unix_milli: u128,
    pub payer_amount_msat: Option<u64>,
}

impl Greenlight {
    /// Connects to a live node using the provided seed and config.
    /// If the node is not registered, it will try to recover it using the seed.
    /// If the node is not created, it will register it using the provided partner credentials
    /// or invite code
    /// If the node is already registered and an existing credentials were found, it will try to
    /// connect to the node using these credentials.
    pub async fn connect(
        config: Config,
        seed: Vec<u8>,
        restore_only: Option<bool>,
        persister: Arc<SqliteStorage>,
    ) -> NodeResult<Self> {
        // Derive the encryption key from the seed
        let signer = Signer::new(seed.clone(), config.network.into(), TlsConfig::new()?)?;
        let encryption_key = Self::derive_bip32_key(
            config.network,
            &signer,
            vec![ChildNumber::from_hardened_idx(140)?, ChildNumber::from(0)],
        )?
        .to_priv()
        .to_bytes();
        let encryption_key_slice = encryption_key.as_slice();

        let register_credentials = match config.node_config.clone() {
            NodeConfig::Greenlight { config } => config,
        };

        // Query for the existing credentials
        let mut parsed_credentials =
            Self::get_node_credentials(config.network, &signer, persister.clone())?
                .ok_or(NodeError::generic("No credentials found"));
        if parsed_credentials.is_err() {
            info!("No credentials found, trying to recover existing node");
            parsed_credentials = match Self::recover(config.network, seed.clone()).await {
                Ok(creds) => Ok(creds),
                Err(_) => {
                    match restore_only.unwrap_or(false) {
                        false => {
                            // If we got here it means we failed to recover so we need to register a new node
                            info!("Failed to recover node, registering new one");
                            let credentials = Self::register(
                                config.clone().network,
                                seed.clone(),
                                register_credentials.partner_credentials,
                                register_credentials.invite_code,
                            )
                            .await?;
                            Ok(credentials)
                        }
                        true => {
                            return Err(NodeError::RestoreOnly("Node does not exist".to_string()));
                        }
                    }
                }
            }
        }

        // Persist the connection credentials for future use and return the node instance
        let res = match parsed_credentials {
            Ok(creds) => {
                let json_creds = serde_json::to_string(&creds)?.as_bytes().to_vec();
                let encrypted_creds = sym_encrypt(encryption_key_slice, json_creds.as_slice());
                match encrypted_creds {
                    Some(c) => {
                        persister.set_gl_credentials(c)?;
                        Greenlight::new(config, seed, creds, persister)
                    }
                    None => {
                        return Err(NodeError::generic("Failed to encrypt credentials"));
                    }
                }
            }
            Err(_) => Err(NodeError::generic("Failed to get gl credentials")),
        };
        res
    }

    fn new(
        sdk_config: Config,
        seed: Vec<u8>,
        connection_credentials: GreenlightCredentials,
        persister: Arc<SqliteStorage>,
    ) -> NodeResult<Greenlight> {
        let greenlight_network = sdk_config.network.into();
        let tls_config = TlsConfig::new()?.identity(
            connection_credentials.device_cert,
            connection_credentials.device_key,
        );
        let signer = Signer::new(seed, greenlight_network, tls_config.clone())?;

        Ok(Greenlight {
            sdk_config,
            signer,
            tls_config,
            gl_client: Mutex::new(None),
            node_client: Mutex::new(None),
            persister,
            inprogress_payments: AtomicU16::new(0),
        })
    }

    /// Create and, if necessary, upgrade the scheduler
    async fn init_scheduler(&self) -> Result<SchedulerClient<tonic::transport::channel::Channel>> {
        let channel = Endpoint::from_shared(utils::scheduler_uri())?
            .tls_config(self.tls_config.client_tls_config())?
            .tcp_keepalive(Some(Duration::from_secs(5)))
            .http2_keep_alive_interval(Duration::from_secs(5))
            .keep_alive_timeout(Duration::from_secs(90))
            .keep_alive_while_idle(true)
            .connect_lazy();
        let mut scheduler = SchedulerClient::new(channel);

        // Upgrade node if necessary.
        // If it fails due to connection error, sleep and retry. Re-throw all other errors.
        info!("Entering the upgrade loop");
        loop {
            #[allow(deprecated)]
            let maybe_upgrade_res = scheduler
                .maybe_upgrade(UpgradeRequest {
                    initmsg: self.signer.get_init(),
                    signer_version: self.signer.version().to_owned(),
                    startupmsgs: self
                        .signer
                        .get_startup_messages()
                        .into_iter()
                        .map(|s| s.into())
                        .collect(),
                })
                .await;

            if let Err(err_status) = maybe_upgrade_res {
                match err_status.code() {
                    Code::Unavailable => {
                        debug!("Cannot connect to scheduler, sleeping and retrying");
                        sleep(Duration::from_secs(3)).await;
                        continue;
                    }
                    _ => {
                        return Err(Error::Upgrade(err_status))?;
                    }
                }
            }

            break;
        }

        Ok(scheduler)
    }

    /// The core signer loop. Connects to the signer and keeps the connection alive.
    ///
    /// Used as inner loop for `run_forever`.
    async fn run_forever_inner(
        &self,
        mut scheduler: SchedulerClient<tonic::transport::channel::Channel>,
    ) -> Result<(), anyhow::Error> {
        loop {
            debug!("Start of the signer loop, getting node_info from scheduler");
            let node_info_res = scheduler
                .get_node_info(NodeInfoRequest {
                    node_id: self.signer.node_id(),
                    // Purposely not using the `wait` parameter
                    wait: false,
                })
                .await;

            let node_info = match node_info_res.map(|v| v.into_inner()) {
                Ok(v) => {
                    debug!("Got node_info from scheduler: {:?}", v);
                    v
                }
                Err(e) => {
                    trace!("Got an error from the scheduler: {e}. Sleeping before retrying");
                    sleep(Duration::from_millis(1000)).await;
                    continue;
                }
            };

            if node_info.grpc_uri.is_empty() {
                trace!("Got an empty GRPC URI, node is not scheduled, sleeping and retrying");
                sleep(Duration::from_millis(1000)).await;
                continue;
            }

            if let Err(e) = self
                .signer
                .run_once(Uri::from_maybe_shared(node_info.grpc_uri)?)
                .await
            {
                warn!("Error running against node: {e}");
            }
        }
    }

    async fn run_forever(&self, mut shutdown: mpsc::Receiver<()>) -> Result<(), anyhow::Error> {
        let scheduler = self.init_scheduler().await?;
        tokio::select! {
            run_forever_inner_res = self.run_forever_inner(scheduler) => {
                error!("Inner signer loop exited unexpectedly: {run_forever_inner_res:?}");
            },
            _ = shutdown.recv() => debug!("Received the signal to exit the signer loop")
        };

        info!("Exiting the signer loop");
        Ok(())
    }

    fn derive_bip32_key(
        network: Network,
        signer: &Signer,
        path: Vec<ChildNumber>,
    ) -> NodeResult<ExtendedPrivKey> {
        Ok(
            ExtendedPrivKey::new_master(network.into(), &signer.bip32_ext_key())?
                .derive_priv(&Secp256k1::new(), &path)?,
        )
    }

    fn legacy_derive_bip32_key(
        network: Network,
        signer: &Signer,
        path: Vec<ChildNumber>,
    ) -> NodeResult<ExtendedPrivKey> {
        Ok(
            ExtendedPrivKey::new_master(network.into(), &signer.legacy_bip32_ext_key())?
                .derive_priv(&Secp256k1::new(), &path)?,
        )
    }

    async fn register(
        network: Network,
        seed: Vec<u8>,
        register_credentials: Option<GreenlightCredentials>,
        invite_code: Option<String>,
    ) -> Result<GreenlightCredentials> {
        if invite_code.is_some() && register_credentials.is_some() {
            return Err(anyhow!("Cannot specify both invite code and credentials"));
        }
        let greenlight_network = network.into();
        let tls_config = match register_credentials {
            Some(creds) => {
                debug!("registering with credentials");
                TlsConfig::new()?.identity(creds.device_cert, creds.device_key)
            }
            None => TlsConfig::new()?,
        };

        let signer = Signer::new(seed, greenlight_network, tls_config.clone())?;
        let scheduler = Scheduler::with(
            signer.node_id(),
            greenlight_network,
            utils::scheduler_uri(),
            &tls_config,
        )
        .await?;
        let recover_res: scheduler::RegistrationResponse =
            scheduler.register(&signer, invite_code).await?;

        Ok(GreenlightCredentials {
            device_key: recover_res.device_key.into(),
            device_cert: recover_res.device_cert.into(),
        })
    }

    async fn recover(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
        let greenlight_network = network.into();
        let tls_config = TlsConfig::new()?;
        let signer = Signer::new(seed, greenlight_network, tls_config.clone())?;
        let scheduler = Scheduler::new(signer.node_id(), greenlight_network).await?;
        let recover_res: scheduler::RecoveryResponse = scheduler.recover(&signer).await?;

        Ok(GreenlightCredentials {
            device_key: recover_res.device_key.as_bytes().to_vec(),
            device_cert: recover_res.device_cert.as_bytes().to_vec(),
        })
    }

    async fn get_client(&self) -> NodeResult<node::Client> {
        let mut gl_client = self.gl_client.lock().await;
        if gl_client.is_none() {
            let scheduler = Scheduler::new(self.signer.node_id(), self.sdk_config.network.into())
                .await
                .map_err(|e| NodeError::ServiceConnectivity(e.to_string()))?;
            *gl_client = Some(
                scheduler
                    .schedule(self.tls_config.clone())
                    .await
                    .map_err(|e| NodeError::ServiceConnectivity(e.to_string()))?,
            );
        }
        Ok(gl_client.clone().unwrap())
    }

    pub(crate) async fn get_node_client(&self) -> NodeResult<node::ClnClient> {
        let mut node_client = self.node_client.lock().await;
        if node_client.is_none() {
            let scheduler = Scheduler::new(self.signer.node_id(), self.sdk_config.network.into())
                .await
                .map_err(|e| NodeError::ServiceConnectivity(e.to_string()))?;
            *node_client = Some(
                scheduler
                    .schedule(self.tls_config.clone())
                    .await
                    .map_err(|e| NodeError::ServiceConnectivity(e.to_string()))?,
            );
        }
        Ok(node_client.clone().unwrap())
    }

    fn get_node_credentials(
        network: Network,
        signer: &Signer,
        persister: Arc<SqliteStorage>,
    ) -> NodeResult<Option<GreenlightCredentials>> {
        // Derive the encryption key from the seed
        let encryption_key = Self::derive_bip32_key(
            network,
            signer,
            vec![ChildNumber::from_hardened_idx(140)?, ChildNumber::from(0)],
        )?
        .to_priv()
        .to_bytes();
        let encryption_key_slice = encryption_key.as_slice();

        let legacy_encryption_key = Self::legacy_derive_bip32_key(
            network,
            signer,
            vec![ChildNumber::from_hardened_idx(140)?, ChildNumber::from(0)],
        )?
        .to_priv()
        .to_bytes();
        let legacy_encryption_key_slice = legacy_encryption_key.as_slice();

        match persister.get_gl_credentials()? {
            Some(encrypted_creds) => {
                let mut decrypted_credentials =
                    sym_decrypt(encryption_key_slice, encrypted_creds.as_slice());
                if decrypted_credentials.is_none() {
                    info!("Failed to decrypt credentials, trying legacy key");
                    decrypted_credentials =
                        sym_decrypt(legacy_encryption_key_slice, encrypted_creds.as_slice());
                }
                match decrypted_credentials {
                    Some(decrypted_creds) => {
                        let credentials: GreenlightCredentials =
                            serde_json::from_slice(decrypted_creds.as_slice())
                                .map_err(|_| NodeError::generic("Unable to parse credentials"))?;
                        Ok(Some(credentials))
                    }
                    None => Err(NodeError::generic(
                        "Failed to decrypt credentials, seed doesn't match existing node",
                    )),
                }
            }
            None => Ok(None),
        }
    }

    async fn fetch_outgoing_payment_with_retry(
        mut cln_client: node::ClnClient,
        payment_hash: Vec<u8>,
    ) -> Result<cln::ListpaysPays> {
        let mut response = cln::ListpaysResponse::default();
        let mut retry = 0;
        let max_retries = 20;
        while response.pays.is_empty() && retry < max_retries {
            response = cln_client
                .list_pays(cln::ListpaysRequest {
                    payment_hash: Some(payment_hash.clone()),
                    status: Some(cln::listpays_request::ListpaysStatus::Complete.into()),
                    ..cln::ListpaysRequest::default()
                })
                .await?
                .into_inner();
            if response.pays.is_empty() {
                debug!("fetch outgoing payment failed, retrying in 100ms...");
                sleep(Duration::from_millis(100)).await;
            }
            retry += 1;
        }

        if response.pays.is_empty() {
            return Err(anyhow!("Payment not found"));
        }
        Ok(response.pays[0].clone())
    }

    async fn fetch_channels_and_balance_with_retry(
        cln_client: node::ClnClient,
        persister: Arc<SqliteStorage>,
        match_local_balance: bool,
    ) -> NodeResult<(
        Vec<cln::ListpeersPeersChannels>,
        Vec<cln::ListpeersPeersChannels>,
        Vec<String>,
        u64,
    )> {
        let (mut all_channels, mut opened_channels, mut connected_peers, mut channels_balance) =
            Greenlight::fetch_channels_and_balance(cln_client.clone()).await?;
        if match_local_balance {
            let node_state = persister.get_node_state()?;
            if let Some(state) = node_state {
                let mut retry_count = 0;
                while state.channels_balance_msat != channels_balance && retry_count < 10 {
                    warn!("balance matching local state is required and not yet satisfied, retrying in 100ms...");
                    sleep(Duration::from_millis(100)).await;
                    (
                        all_channels,
                        opened_channels,
                        connected_peers,
                        channels_balance,
                    ) = Greenlight::fetch_channels_and_balance(cln_client.clone()).await?;
                    retry_count += 1;
                }
            }
        }
        Ok((
            all_channels,
            opened_channels,
            connected_peers,
            channels_balance,
        ))
    }

    async fn fetch_channels_and_balance(
        mut cln_client: node::ClnClient,
    ) -> NodeResult<(
        Vec<cln::ListpeersPeersChannels>,
        Vec<cln::ListpeersPeersChannels>,
        Vec<String>,
        u64,
    )> {
        // list all peers
        let peers = cln_client
            .list_peers(cln::ListpeersRequest::default())
            .await?
            .into_inner();

        // filter only connected peers
        let connected_peers: Vec<String> = peers
            .peers
            .iter()
            .filter(|p| p.connected)
            .map(|p| hex::encode(p.id.clone()))
            .collect();
        let mut all_channels: Vec<cln::ListpeersPeersChannels> = vec![];
        peers.peers.iter().for_each(|p| {
            let peer_channels = &mut p.channels.clone();
            all_channels.append(peer_channels);
        });

        // filter only opened channels
        let opened_channels: Vec<cln::ListpeersPeersChannels> = all_channels
            .iter()
            .filter(|c| c.state() == ChanneldNormal)
            .cloned()
            .collect();

        // calculate channels balance only from opened channels
        let channels_balance = opened_channels
            .iter()
            .map(|c| Channel::from(c.clone()))
            .map(|c| c.spendable_msat)
            .sum::<u64>();
        Ok((
            all_channels,
            opened_channels,
            connected_peers,
            channels_balance,
        ))
    }

    async fn list_funds(&self) -> Result<cln::ListfundsResponse> {
        let mut client = self.get_node_client().await?;
        let funds: cln::ListfundsResponse = client
            .list_funds(cln::ListfundsRequest::default())
            .await?
            .into_inner();
        Ok(funds)
    }

    async fn on_chain_balance(&self, funds: &cln::ListfundsResponse) -> Result<u64> {
        let on_chain_balance = funds.outputs.iter().fold(0, |a, b| {
            if b.reserved {
                return a;
            }
            a + b.amount_msat.clone().unwrap_or_default().msat
        });
        Ok(on_chain_balance)
    }

    async fn pending_onchain_balance(
        &self,
        peer_channels: &[cln::ListpeersPeersChannels],
    ) -> Result<u64> {
        let pending_onchain_balance = peer_channels.iter().fold(0, |a, b| match b.state() {
            ChanneldShuttingDown | ClosingdSigexchange | ClosingdComplete | AwaitingUnilateral
            | FundingSpendSeen => a + b.min_to_us_msat.clone().unwrap_or_default().msat,

            // When we  unilaterally close the channel it will get status as `AwaitingUnilateral`
            // first, but when the closing transaction is confirmed onchain the funds receive status
            // as `Onchain`. Though if we closed the channel we'll have to wait for the timelock to
            // pass before the funds can be spent.
            Onchain => {
                if b.closer() == cln::ChannelSide::Local
                    && b.status
                        .last()
                        .is_some_and(|status| status.contains("DELAYED_OUTPUT_TO_US"))
                {
                    a + b.min_to_us_msat.clone().unwrap_or_default().msat
                } else {
                    a
                }
            }
            _ => a,
        });
        info!("pending_onchain_balance is {}", pending_onchain_balance);
        Ok(pending_onchain_balance)
    }

    // Collect utxos from onchain funds
    async fn utxos(&self, funds: cln::ListfundsResponse) -> Result<Vec<UnspentTransactionOutput>> {
        let utxos: Vec<UnspentTransactionOutput> = funds
            .outputs
            .iter()
            .map(|output| UnspentTransactionOutput {
                txid: output.txid.clone(),
                outnum: output.output,
                amount_millisatoshi: output
                    .amount_msat
                    .as_ref()
                    .map(|a| a.msat)
                    .unwrap_or_default(),
                address: output.address.clone().unwrap_or_default(),
                reserved: output.reserved,
            })
            .collect();
        Ok(utxos)
    }

    async fn build_payment_path(
        &self,
        route: &Vec<GetrouteRoute>,
        first_edge: PaymentPathEdge,
    ) -> NodeResult<PaymentPath> {
        let mut client = self.get_node_client().await?;
        let mut hops = vec![first_edge];

        for hop in route {
            let hopchannels = client
                .list_channels(ListchannelsRequest {
                    short_channel_id: Some(hop.channel.clone()),
                    source: None,
                    destination: None,
                })
                .await?
                .into_inner()
                .channels;

            let first_channel = hopchannels.first().ok_or(NodeError::RouteNotFound(format!(
                "Channel not found {}",
                hop.channel.clone()
            )))?;

            info!("found channel in route: {:?}", first_channel);
            hops.push(PaymentPathEdge {
                base_fee_msat: first_channel.base_fee_millisatoshi as u64,
                fee_per_millionth: first_channel.fee_per_millionth as u64,
                node_id: hop.id.clone(),
                short_channel_id: hop.channel.clone(),
                channel_delay: first_channel.delay as u64,
            });
        }
        Ok(PaymentPath { edges: hops })
    }

    async fn max_sendable_amount_from_peer(
        &self,
        via_peer_id: Vec<u8>,
        via_peer_channels: Vec<ListpeersPeersChannels>,
        payee_node_id: Option<Vec<u8>>,
        max_hops: u32,
        last_hop_hint: Option<&RouteHintHop>,
    ) -> NodeResult<Vec<MaxChannelAmount>> {
        let mut client = self.get_node_client().await?;

        // Consider the hints as part of the route. If there is a routing hint we will
        // attempt to calculate the path until the last hop in the hint and then add
        // the last hop to the path.
        let (last_node, max_hops) = match last_hop_hint {
            Some(hop) => (hex::decode(&hop.src_node_id)?, max_hops - 1),
            None => match payee_node_id.clone() {
                Some(node_id) => (node_id, max_hops),
                None => {
                    return Err(NodeError::RouteNotFound(
                        "No payee node id or last hop hints provided, cannot calculate max amount"
                            .to_string(),
                    ));
                }
            },
        };

        // fetch a route from greenlight
        info!(
            "calling get_route for peer {} to node {}, max_hops: {}",
            hex::encode(via_peer_id.clone()),
            hex::encode(last_node.clone()),
            max_hops - 1
        );
        let route_result = client
            .get_route(GetrouteRequest {
                id: last_node.clone(),
                amount_msat: Some(Amount { msat: 0 }),
                riskfactor: 0,
                cltv: None,
                fromid: Some(via_peer_id.clone()),
                fuzzpercent: Some(0),
                exclude: vec![],
                // we deduct the first hop that we calculate manually
                maxhops: Some(max_hops - 1),
            })
            .await;

        // In case we have no route better to return no amounts for this peer's channels.
        if let Err(e) = route_result {
            error!(
                "Failed to get route for peer {}: {}",
                hex::encode(via_peer_id.clone()),
                e
            );
            return Ok(vec![]);
        }

        let route_response = route_result?.into_inner();
        info!(
            "max_sendable_amount: route response = {:?}",
            route_response.route
        );

        // We fetch the opened channels so can calculate max amount to send for each channel
        let opened_channels: Vec<cln::ListpeersPeersChannels> = via_peer_channels
            .iter()
            .filter(|c| c.state() == ChanneldNormal)
            .cloned()
            .collect();

        let mut max_per_channel = vec![];
        for c in opened_channels {
            let chan_id = c
                .clone()
                .channel_id
                .ok_or(NodeError::generic("Empty channel id"))?;

            // First hop is forwarding so no fees and delays.
            let first_edge = PaymentPathEdge {
                base_fee_msat: 0,
                fee_per_millionth: 0,
                node_id: via_peer_id.clone(),
                short_channel_id: c.clone().short_channel_id.unwrap_or_default(),
                channel_delay: 0,
            };

            // convert the route to a payment path so we can calculate the amount to forward for each hop
            let mut payment_path = self
                .build_payment_path(&route_response.route, first_edge)
                .await?;

            // Add the last hop hints (if any) to the route
            if let Some(hint) = last_hop_hint {
                payment_path.edges.extend(vec![PaymentPathEdge {
                    base_fee_msat: hint.fees_base_msat as u64,
                    fee_per_millionth: hint.fees_proportional_millionths as u64,
                    node_id: payee_node_id.clone().unwrap_or_default(),
                    short_channel_id: format_short_channel_id(hint.short_channel_id),
                    channel_delay: hint.cltv_expiry_delta,
                }])
            }

            info!("max_sendable_amount: route_hops = {:?}", payment_path.edges);

            // go over each hop and calculate the amount to forward.
            let max_payment_amount =
                payment_path.final_hop_amount(c.clone().spendable_msat.unwrap_or_default().msat);
            max_per_channel.push(MaxChannelAmount {
                channel_id: hex::encode(chan_id),
                amount_msat: max_payment_amount,
                path: payment_path,
            });
        }

        Ok(max_per_channel)
    }

    async fn with_keep_alive<T, F>(&self, f: F) -> T
    where
        F: Future<Output = T>,
    {
        _ = self.inprogress_payments.fetch_add(1, Ordering::Relaxed);
        let res = f.await;
        _ = self.inprogress_payments.fetch_sub(1, Ordering::Relaxed);
        res
    }
}

#[tonic::async_trait]
impl NodeAPI for Greenlight {
    fn node_credentials(&self) -> NodeResult<Option<NodeCredentials>> {
        Ok(Self::get_node_credentials(
            self.sdk_config.network,
            &self.signer,
            self.persister.clone(),
        )?
        .map(|credentials| NodeCredentials::Greenlight { credentials }))
    }

    async fn configure_node(&self, close_to_address: Option<String>) -> NodeResult<()> {
        match close_to_address {
            Some(close_to_addr) => {
                self.get_client()
                    .await?
                    .configure(gl_client::pb::GlConfig { close_to_addr })
                    .await
                    .map_err(|e| NodeError::Generic(format!("Unable to set node config: {}", e)))?;
            }
            None => {
                self.get_node_client()
                    .await?
                    .del_datastore(cln::DeldatastoreRequest {
                        key: vec!["glconf".to_string(), "request".to_string()],
                        generation: None,
                    })
                    .await
                    .map_err(|e| {
                        NodeError::Generic(format!("Unable to delete node config: {}", e))
                    })?;
            }
        }
        Ok(())
    }

    async fn create_invoice(&self, request: CreateInvoiceRequest) -> NodeResult<String> {
        let mut client = self.get_node_client().await?;
        let label = serde_json::to_string(&InvoiceLabel {
            unix_milli: SystemTime::now().duration_since(UNIX_EPOCH)?.as_millis(),
            payer_amount_msat: request.payer_amount_msat,
        })?;
        let cln_request = cln::InvoiceRequest {
            amount_msat: Some(cln::AmountOrAny {
                value: Some(cln::amount_or_any::Value::Amount(cln::Amount {
                    msat: request.amount_msat,
                })),
            }),
            label,
            description: request.description,
            preimage: request.preimage,
            deschashonly: request.use_description_hash,
            expiry: request.expiry.map(|e| e as u64),
            fallbacks: vec![],
            cltv: request.cltv,
        };

        let res = client.invoice(cln_request).await?.into_inner();
        Ok(res.bolt11)
    }

    async fn fetch_bolt11(&self, payment_hash: Vec<u8>) -> NodeResult<Option<FetchBolt11Result>> {
        let request = cln::ListinvoicesRequest {
            payment_hash: Some(payment_hash),
            ..Default::default()
        };

        let result = self
            .get_node_client()
            .await?
            .list_invoices(request)
            .await?
            .into_inner()
            .invoices
            .first()
            .cloned()
            .and_then(|invoice| {
                invoice.bolt11.map(|bolt11| FetchBolt11Result {
                    bolt11,
                    payer_amount_msat: serde_json::from_str::<InvoiceLabel>(&invoice.label)
                        .map(|label| label.payer_amount_msat)
                        .ok()
                        .flatten(),
                })
            });

        Ok(result)
    }

    // implement pull changes from greenlight
    async fn pull_changed(
        &self,
        since_timestamp: u64,
        match_local_balance: bool,
    ) -> NodeResult<SyncResponse> {
        info!("pull changed since {}", since_timestamp);
        let node_client = self.get_node_client().await?;

        // get node info
        let mut node_info_client = node_client.clone();
        let node_info_future = node_info_client.getinfo(cln::GetinfoRequest::default());

        // list both off chain funds and on chain fudns
        let funds_future = self.list_funds();

        // Fetch closed channels from greenlight
        let mut closed_channels_client = node_client.clone();
        let closed_channels_future = closed_channels_client
            .list_closed_channels(cln::ListclosedchannelsRequest { id: None });

        // calculate the node new balance and in case the caller signals balance has changed
        // keep polling until the balance is updated
        let balance_future = Greenlight::fetch_channels_and_balance_with_retry(
            node_client.clone(),
            self.persister.clone(),
            match_local_balance,
        );

        let (node_info_res, funds_res, closed_channels_res, balance_res) = tokio::join!(
            node_info_future,
            funds_future,
            closed_channels_future,
            balance_future
        );

        let node_info = node_info_res?.into_inner();
        let funds = funds_res?;
        let closed_channels = closed_channels_res?.into_inner().closedchannels;
        let (all_channels, opened_channels, connected_peers, channels_balance) = balance_res?;
        let forgotten_closed_channels: NodeResult<Vec<Channel>> = closed_channels
            .into_iter()
            .filter(|cc| {
                all_channels
                    .iter()
                    .all(|ac| ac.funding_txid != Some(cc.funding_txid.clone()))
            })
            .map(TryInto::try_into)
            .collect();
        info!("forgotten_closed_channels {:?}", forgotten_closed_channels);

        let mut all_channel_models: Vec<Channel> =
            all_channels.clone().into_iter().map(|c| c.into()).collect();
        all_channel_models.extend(forgotten_closed_channels?);

        // calculate onchain balance
        let onchain_balance = self.on_chain_balance(&funds).await?;
        let pending_onchain_balance = self.pending_onchain_balance(&all_channels).await?;
        let utxos: Vec<UnspentTransactionOutput> = self.utxos(funds).await?;

        // calculate payment limits and inbound liquidity
        let mut max_payable: u64 = 0;
        let mut max_receivable_single_channel: u64 = 0;
        opened_channels.iter().try_for_each(|c| -> Result<()> {
            max_payable += c
                .spendable_msat
                .as_ref()
                .map(|a| a.msat)
                .unwrap_or_default();
            let receivable_amount = c
                .receivable_msat
                .as_ref()
                .map(|a| a.msat)
                .unwrap_or_default();
            if receivable_amount > max_receivable_single_channel {
                max_receivable_single_channel = receivable_amount;
            }
            Ok(())
        })?;

        let max_allowed_to_receive_msats =
            MAX_INBOUND_LIQUIDITY_MSAT.saturating_sub(channels_balance);
        let node_pubkey = hex::encode(node_info.id);
        // construct the node state
        let node_state = NodeState {
            id: node_pubkey.clone(),
            block_height: node_info.blockheight,
            channels_balance_msat: channels_balance,
            onchain_balance_msat: onchain_balance,
            pending_onchain_balance_msat: pending_onchain_balance,
            utxos,
            max_payable_msat: max_payable,
            max_receivable_msat: max_allowed_to_receive_msats,
            max_single_payment_amount_msat: MAX_PAYMENT_AMOUNT_MSAT,
            max_chan_reserve_msats: channels_balance - min(max_payable, channels_balance),
            connected_peers,
            inbound_liquidity_msats: max_receivable_single_channel,
        };
        let mut htlc_list: Vec<Htlc> = Vec::new();
        for channel in all_channel_models.clone() {
            htlc_list.extend(channel.htlcs);
        }

        Ok(SyncResponse {
            node_state,
            payments: pull_transactions(since_timestamp, node_client.clone(), htlc_list).await?,
            channels: all_channel_models,
        })
    }

    async fn send_pay(&self, bolt11: String, max_hops: u32) -> NodeResult<PaymentResponse> {
        let invoice = parse_invoice(&bolt11)?;
        let last_hop = invoice.routing_hints.first().and_then(|rh| rh.hops.first());
        let mut client: node::ClnClient = self.get_node_client().await?;

        // Valid the invoice network against the config network
        validate_network(invoice.clone(), self.sdk_config.network)?;

        // We first calculate for each channel the max amount to pay (at the receiver)
        let mut max_amount_per_channel = self
            .max_sendable_amount(Some(hex::decode(invoice.payee_pubkey)?), max_hops, last_hop)
            .await?;
        info!("send_pay: routes: {:?}", max_amount_per_channel);

        // Calculate the total amount to pay
        let total_msat: u64 = max_amount_per_channel.iter().map(|m| m.amount_msat).sum();

        // Sort the channels by max amount descending so we can build the route in a way that it
        // drains the largest channels first
        max_amount_per_channel.sort_by_key(|m| Reverse(m.amount_msat));

        let amount_to_pay_msat = match invoice.amount_msat {
            Some(amount) => Ok(amount),
            None => Err(NodeError::generic("Invoice has no amount")),
        }?;

        if amount_to_pay_msat > total_msat {
            return Err(NodeError::RouteNotFound(format!(
                "Amount too high, max amount is {} msat",
                total_msat
            )));
        }

        // This is needed in greenlight for the signer to recognize this invoice.
        client
            .pre_approve_invoice(PreapproveinvoiceRequest {
                bolt11: Some(bolt11.clone()),
            })
            .await?;

        // We need to allocate a part id for each part that we are sending.
        let mut part_id = 1;
        // The total amount we sent. i.e. what the recipient received + fees
        let mut amount_sent_msat = 0;
        // The total amount received by the recipient
        let mut amount_received_msat = 0;
        // Generate a random group_id for the payment
        let group_id = rand::random::<u64>();

        // The algorithm goes over each channel and drains it until the received amount
        // equals to the amount to pay defined in the bolt11 invoice.
        for max in max_amount_per_channel {
            // calculating the incoming amount for the remaining amount to pay.
            let left_to_pay_msat = amount_to_pay_msat - amount_received_msat;
            // Whether we draining the whole channel balance or only what is left to pay
            let to_pay_msat = std::cmp::min(left_to_pay_msat, max.amount_msat);

            // We convert our payment path to an actual route that can be sent to the node.
            // This requires calculating the right fees and cltv delta in each hop.
            let (route, sent_msat) = convert_to_send_pay_route(
                max.path.clone(),
                to_pay_msat,
                invoice.min_final_cltv_expiry_delta,
            );
            info!(
                "send_pay route to pay: {:?}, received_amount = {}",
                route, to_pay_msat
            );

            // We send the part using the node API
            client
                .send_pay(SendpayRequest {
                    route,
                    payment_hash: hex::decode(invoice.payment_hash.clone())?,
                    label: None,
                    amount_msat: Some(Amount {
                        msat: amount_to_pay_msat,
                    }),
                    bolt11: Some(bolt11.clone()),
                    payment_secret: Some(invoice.payment_secret.clone()),
                    partid: Some(part_id),
                    localinvreqid: None,
                    groupid: Some(group_id),
                })
                .await?;
            part_id += 1;
            amount_sent_msat += sent_msat;
            amount_received_msat += to_pay_msat;
            if amount_received_msat == amount_to_pay_msat {
                break;
            }
        }

        // Now we wait for the first part to be completed as a way to wait for the payment
        // to complete.
        let response = self
            .with_keep_alive(client.wait_send_pay(WaitsendpayRequest {
                payment_hash: hex::decode(invoice.payment_hash.clone())?,
                partid: Some(1),
                timeout: Some(self.sdk_config.payment_timeout_sec),
                groupid: Some(group_id),
            }))
            .await?
            .into_inner();
        Ok(PaymentResponse {
            payment_time: response.completed_at.unwrap_or(response.created_at as f64) as i64,
            amount_msat: amount_received_msat,
            fee_msat: amount_sent_msat - amount_received_msat,
            payment_hash: invoice.payment_hash,
            payment_preimage: hex::encode(response.payment_preimage.unwrap_or_default()),
        })
    }

    async fn send_payment(
        &self,
        bolt11: String,
        amount_msat: Option<u64>,
        label: Option<String>,
    ) -> NodeResult<Payment> {
        let mut description = None;
        if !bolt11.is_empty() {
            let invoice = parse_invoice(&bolt11)?;
            validate_network(invoice.clone(), self.sdk_config.network)?;
            description = invoice.description;
        }

        let mut client: node::ClnClient = self.get_node_client().await?;
        let request = cln::PayRequest {
            bolt11,
            amount_msat: amount_msat.map(|amt| cln::Amount { msat: amt }),
            maxfeepercent: Some(self.sdk_config.maxfee_percent),
            retry_for: Some(self.sdk_config.payment_timeout_sec),
            label,
            maxdelay: None,
            riskfactor: None,
            localinvreqid: None,
            exclude: vec![],
            maxfee: None,
            description,
            exemptfee: Some(cln::Amount {
                msat: self.sdk_config.exemptfee_msat,
            }),
        };
        let result: cln::PayResponse = self
            .with_keep_alive(client.pay(request))
            .await?
            .into_inner();

        // Before returning from send_payment we need to make sure it is persisted in the backend node.
        // We do so by polling for the payment.
        let payment = Self::fetch_outgoing_payment_with_retry(client, result.payment_hash).await?;
        payment.try_into()
    }

    async fn send_spontaneous_payment(
        &self,
        node_id: String,
        amount_msat: u64,
        extra_tlvs: Option<Vec<TlvEntry>>,
        label: Option<String>,
    ) -> NodeResult<Payment> {
        let mut client: node::ClnClient = self.get_node_client().await?;
        let request = cln::KeysendRequest {
            destination: hex::decode(node_id)?,
            amount_msat: Some(cln::Amount { msat: amount_msat }),
            label: label.or(Some(format!(
                "breez-{}",
                SystemTime::now().duration_since(UNIX_EPOCH)?.as_millis()
            ))),
            extratlvs: extra_tlvs.map(|tlvs| cln::TlvStream {
                entries: tlvs
                    .into_iter()
                    .map(|tlv| cln::TlvEntry {
                        r#type: tlv.field_number,
                        value: tlv.value,
                    })
                    .collect(),
            }),
            routehints: None,
            maxfeepercent: Some(self.sdk_config.maxfee_percent),
            exemptfee: None,
            retry_for: Some(self.sdk_config.payment_timeout_sec),
            maxdelay: None,
        };
        let result = self
            .with_keep_alive(client.key_send(request))
            .await?
            .into_inner();

        // Before returning from send_payment we need to make sure it is persisted in the backend node.
        // We do so by polling for the payment.
        let payment = Self::fetch_outgoing_payment_with_retry(client, result.payment_hash).await?;
        payment.try_into()
    }

    async fn start(&self) -> NodeResult<String> {
        let node_info = self
            .get_node_client()
            .await?
            .getinfo(cln::GetinfoRequest {})
            .await
            .map_err(|e| NodeError::ServiceConnectivity(e.to_string()))?
            .into_inner();
        Ok(hex::encode(node_info.id))
    }

    async fn redeem_onchain_funds(
        &self,
        to_address: String,
        sat_per_vbyte: u32,
    ) -> NodeResult<Vec<u8>> {
        let mut client = self.get_node_client().await?;

        let request = cln::WithdrawRequest {
            feerate: Some(cln::Feerate {
                style: Some(cln::feerate::Style::Perkw(sat_per_vbyte * 250)),
            }),
            satoshi: Some(cln::AmountOrAll {
                value: Some(cln::amount_or_all::Value::All(true)),
            }),
            destination: to_address,
            minconf: None,
            utxos: vec![],
        };

        Ok(client.withdraw(request).await?.into_inner().txid)
    }

    async fn prepare_redeem_onchain_funds(
        &self,
        req: PrepareRedeemOnchainFundsRequest,
    ) -> NodeResult<PrepareRedeemOnchainFundsResponse> {
        let funds = self.list_funds().await?;
        let utxos = self.utxos(funds).await?;

        let mut amount_msat: u64 = 0;
        let txins: Vec<TxIn> = utxos
            .iter()
            .map(|utxo| {
                amount_msat += utxo.amount_millisatoshi;
                TxIn {
                    previous_output: OutPoint {
                        txid: Txid::from_slice(&utxo.txid).unwrap(),
                        vout: 0,
                    },
                    script_sig: Script::new(),
                    sequence: Sequence(0),
                    witness: Witness::default(),
                }
            })
            .collect();

        let amount_sat = amount_msat / 1_000;
        let btc_address = Address::from_str(&req.to_address)?;
        let tx_out: Vec<TxOut> = vec![TxOut {
            value: amount_sat,
            script_pubkey: btc_address.payload.script_pubkey(),
        }];
        let tx = Transaction {
            version: 2,
            lock_time: crate::bitcoin::PackedLockTime(0),
            input: txins.clone(),
            output: tx_out,
        };

        let witness_input_size: u64 = 110;
        let tx_weight = tx.strippedsize() as u64 * WITNESS_SCALE_FACTOR as u64
            + witness_input_size * txins.len() as u64;
        let fee: u64 = tx_weight * req.sat_per_vbyte as u64 / WITNESS_SCALE_FACTOR as u64;
        if fee >= amount_sat {
            return Err(NodeError::generic("Insufficient funds to pay fees"));
        }

        return Ok(PrepareRedeemOnchainFundsResponse {
            tx_weight,
            tx_fee_sat: fee,
        });
    }

    /// Starts the signer that listens in a loop until the shutdown signal is received
    async fn start_signer(&self, shutdown: mpsc::Receiver<()>) {
        match self.run_forever(shutdown).await {
            Ok(_) => info!("signer exited gracefully"),
            Err(e) => error!("signer exited with error: {e}"),
        }
    }

    async fn start_keep_alive(&self, mut shutdown: watch::Receiver<()>) {
        info!("keep alive started");
        let mut interval = tokio::time::interval(Duration::from_secs(15));
        interval.set_missed_tick_behavior(MissedTickBehavior::Skip);
        loop {
            tokio::select! {
                  _ = shutdown.changed() => {
                    info!("keep alive exited");
                    break;
                  }
                  _ = interval.tick() => {
                    let inprogress_payments = self.inprogress_payments.load(Ordering::Relaxed);
                    if inprogress_payments == 0 {
                      continue
                    }
                    let client_res = self.get_node_client().await;
                    match client_res {
                      Ok(mut client) => {
                        let res = client.getinfo(cln::GetinfoRequest {}).await;
                        match res {
                          Ok(_) => {
                            info!("keep alive ping sent, in progress payments: {inprogress_payments}");
                          }
                          Err(e) => {
                            error!("keep alive ping failed: {e}");
                          }
                        }
                      }
                      Err(e) => {
                        error!("keep alive ping failed to create client: {e}");
                      }
                    }
                  }
            }
        }
    }

    async fn connect_peer(&self, id: String, addr: String) -> NodeResult<()> {
        let mut client = self.get_node_client().await?;
        let connect_req = cln::ConnectRequest {
            id: format!("{id}@{addr}"),
            host: None,
            port: None,
        };
        client.connect_peer(connect_req).await?;
        Ok(())
    }

    async fn sign_message(&self, message: &str) -> NodeResult<String> {
        let (sig, recovery_id) = self.signer.sign_message(message.as_bytes().to_vec())?;
        let mut complete_signature = vec![31 + recovery_id];
        complete_signature.extend_from_slice(&sig);
        Ok(zbase32::encode_full_bytes(&complete_signature))
    }

    async fn check_message(
        &self,
        message: &str,
        pubkey: &str,
        signature: &str,
    ) -> NodeResult<bool> {
        let pk = PublicKey::from_str(pubkey)?;
        Ok(verify(message.as_bytes(), signature, &pk))
    }

    fn sign_invoice(&self, invoice: RawBolt11Invoice) -> NodeResult<String> {
        let hrp_bytes = invoice.hrp.to_string().as_bytes().to_vec();
        let data_bytes = invoice.data.to_base32();

        // create the message for the signer
        let msg_type: u16 = 8;
        let data_len: u16 = data_bytes.len().try_into()?;
        let mut data_len_bytes = data_len.to_be_bytes().to_vec();
        let mut data_buf = data_bytes.iter().copied().map(u5::to_u8).collect();

        let hrp_len: u16 = hrp_bytes.len().try_into()?;
        let mut hrp_len_bytes = hrp_len.to_be_bytes().to_vec();
        let mut hrp_buf = hrp_bytes.to_vec();

        let mut buf = msg_type.to_be_bytes().to_vec();
        buf.append(&mut data_len_bytes);
        buf.append(&mut data_buf);
        buf.append(&mut hrp_len_bytes);
        buf.append(&mut hrp_buf);
        // Sign the invoice using the signer
        let raw_result = self.signer.sign_invoice(buf)?;
        info!(
            "recover id: {:?} raw = {:?}",
            raw_result, raw_result[64] as i32
        );
        // contruct the RecoveryId
        let rid = RecoveryId::from_i32(raw_result[64] as i32).expect("recovery ID");
        let sig = &raw_result[0..64];
        let recoverable_sig = RecoverableSignature::from_compact(sig, rid)?;

        let signed_invoice: Result<SignedRawBolt11Invoice> = invoice.sign(|_| Ok(recoverable_sig));
        Ok(signed_invoice?.to_string())
    }

    async fn close_peer_channels(&self, node_id: String) -> NodeResult<Vec<String>> {
        let mut client = self.get_node_client().await?;
        let closed_channels = client
            .list_peer_channels(cln::ListpeerchannelsRequest {
                id: Some(hex::decode(node_id)?),
            })
            .await?
            .into_inner();
        let mut tx_ids = vec![];
        for channel in closed_channels.channels {
            let mut should_close = false;
            if let Some(state) = channel.state {
                match cln::ChannelState::from_i32(state) {
                    Some(cln::ChannelState::Openingd) => should_close = true,
                    Some(cln::ChannelState::ChanneldAwaitingLockin) => should_close = true,
                    Some(cln::ChannelState::ChanneldNormal) => should_close = true,
                    Some(cln::ChannelState::ChanneldShuttingDown) => should_close = true,
                    Some(cln::ChannelState::FundingSpendSeen) => should_close = true,
                    Some(cln::ChannelState::DualopendOpenInit) => should_close = true,
                    Some(cln::ChannelState::DualopendAwaitingLockin) => should_close = true,
                    Some(_) => should_close = false,
                    None => should_close = false,
                }
            }

            if should_close {
                let chan_id = channel.channel_id.ok_or(anyhow!("Empty channel id"))?;
                let response = client
                    .close(cln::CloseRequest {
                        id: hex::encode(chan_id),
                        unilateraltimeout: None,
                        destination: None,
                        fee_negotiation_step: None,
                        wrong_funding: None,
                        force_lease_closed: None,
                        feerange: vec![],
                    })
                    .await;
                match response {
                    Ok(res) => {
                        tx_ids.push(hex::encode(
                            res.into_inner()
                                .txid
                                .ok_or(anyhow!("Empty txid in close response"))?,
                        ));
                    }
                    Err(e) => Err(anyhow!("Empty closing channel: {e}"))?,
                };
            }
        }
        Ok(tx_ids)
    }

    async fn stream_incoming_payments(
        &self,
    ) -> NodeResult<Streaming<gl_client::signer::model::greenlight::IncomingPayment>> {
        let mut client = self.get_client().await?;
        let stream = client
            .stream_incoming(gl_client::signer::model::greenlight::StreamIncomingFilter {})
            .await?
            .into_inner();
        Ok(stream)
    }

    async fn stream_log_messages(
        &self,
    ) -> NodeResult<Streaming<gl_client::signer::model::greenlight::LogEntry>> {
        let mut client = self.get_client().await?;
        let stream = client
            .stream_log(gl_client::signer::model::greenlight::StreamLogRequest {})
            .await?
            .into_inner();
        Ok(stream)
    }

    async fn static_backup(&self) -> NodeResult<Vec<String>> {
        let mut client = self.get_node_client().await?;
        let res = client
            .static_backup(cln::StaticbackupRequest {})
            .await?
            .into_inner();
        let hex_vec: Vec<String> = res.scb.into_iter().map(hex::encode).collect();
        Ok(hex_vec)
    }

    async fn generate_diagnostic_data(&self) -> NodeResult<String> {
        let all_commands = vec![
            NodeCommand::GetInfo.to_string(),
            NodeCommand::ListPeerChannels.to_string(),
            NodeCommand::ListFunds.to_string(),
            NodeCommand::ListPayments.to_string(),
            NodeCommand::ListInvoices.to_string(),
        ];

        let mut result = String::new();
        for command in all_commands {
            let command_name = command.clone();
            let res = self
                .execute_command(command)
                .await
                .unwrap_or_else(|e| e.to_string());
            result += &format!("***{command_name}:***\n\n {res}\n\n");
        }
        Ok(result)
    }

    async fn execute_command(&self, command: String) -> NodeResult<String> {
        let mut args = shlex::split(&command).ok_or(anyhow!("Command not found: {command}"))?;
        args.insert(0, String::from(" "));
        let command = NodeCommand::try_parse_from(args)?;
        match command {
            NodeCommand::ListPeers => {
                let resp = self
                    .get_node_client()
                    .await?
                    .list_peers(cln::ListpeersRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::ListPeerChannels => {
                let resp = self
                    .get_node_client()
                    .await?
                    .list_peer_channels(cln::ListpeerchannelsRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::ListFunds => {
                let resp = self
                    .get_node_client()
                    .await?
                    .list_funds(cln::ListfundsRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::ListPayments => {
                let resp = self
                    .get_node_client()
                    .await?
                    .list_pays(cln::ListpaysRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::ListInvoices => {
                let resp = self
                    .get_node_client()
                    .await?
                    .list_invoices(cln::ListinvoicesRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::CloseAllChannels => {
                let peers_res = self
                    .get_node_client()
                    .await?
                    .list_peers(cln::ListpeersRequest::default())
                    .await?
                    .into_inner();
                for p in peers_res.peers {
                    self.close_peer_channels(hex::encode(p.id)).await?;
                }

                Ok("All channels were closed".to_string())
            }
            NodeCommand::GetInfo => {
                let resp = self
                    .get_node_client()
                    .await?
                    .getinfo(cln::GetinfoRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::GenerateDiagnosticData => {
                let resp = self.generate_diagnostic_data().await?;
                Ok(format!("{resp:?}"))
            }
            NodeCommand::Stop => {
                let resp = self
                    .get_node_client()
                    .await?
                    .stop(cln::StopRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::ListChannels {
                source,
                destination,
                short_channel_id,
            } => {
                let resp = self
                    .get_node_client()
                    .await?
                    .list_channels(cln::ListchannelsRequest {
                        source: source.and_then(|d| hex::decode(d).ok()),
                        destination: destination.and_then(|d| hex::decode(d).ok()),
                        short_channel_id,
                    })
                    .await?
                    .into_inner()
                    .channels
                    .iter()
                    .map(|c| GraphChannel {
                        active: c.active,
                        public: c.public,
                        base_fee_msat: c.base_fee_millisatoshi,
                        capacity_sat: c.amount_msat.clone().map(|a| a.msat / 1000),
                        cltv_delta: c.delay,
                        fee_per_millionth: c.fee_per_millionth as u64,
                        htlc_max_msat: c.htlc_maximum_msat.clone().map(|m| m.msat),
                        destination: hex::encode(c.destination.clone()),
                        short_channel_id: c.short_channel_id.clone(),
                        source: hex::encode(c.source.clone()),
                        htlc_min_msat: c.htlc_minimum_msat.clone().map(|m| m.msat),
                        last_update: c.last_update,
                    })
                    .collect::<Vec<GraphChannel>>();
                Ok(format!("{resp:?}"))
            }
        }
    }

    async fn max_sendable_amount(
        &self,
        payee_node_id: Option<Vec<u8>>,
        max_hops: u32,
        last_hop_hint: Option<&RouteHintHop>,
    ) -> NodeResult<Vec<MaxChannelAmount>> {
        let mut client = self.get_node_client().await?;

        let peers = client
            .list_peers(cln::ListpeersRequest::default())
            .await?
            .into_inner();

        let mut max_channel_amounts = vec![];
        for peer in peers.peers {
            let max_amounts_for_peer = self
                .max_sendable_amount_from_peer(
                    peer.id,
                    peer.channels,
                    payee_node_id.clone(),
                    max_hops,
                    last_hop_hint,
                )
                .await?;
            max_channel_amounts.extend_from_slice(max_amounts_for_peer.as_slice());
        }
        Ok(max_channel_amounts)
    }

    fn derive_bip32_key(&self, path: Vec<ChildNumber>) -> NodeResult<ExtendedPrivKey> {
        Self::derive_bip32_key(self.sdk_config.network, &self.signer, path)
    }

    fn legacy_derive_bip32_key(&self, path: Vec<ChildNumber>) -> NodeResult<ExtendedPrivKey> {
        Self::legacy_derive_bip32_key(self.sdk_config.network, &self.signer, path)
    }

    async fn stream_custom_messages(
        &self,
    ) -> NodeResult<Pin<Box<dyn Stream<Item = Result<CustomMessage>> + Send>>> {
        let stream = {
            let mut client = match self.get_client().await {
                Ok(c) => Ok(c),
                Err(e) => Err(anyhow!("{}", e)),
            }?;

            match client
                .stream_custommsg(gl_client::signer::model::greenlight::StreamCustommsgRequest {})
                .await
            {
                Ok(s) => Ok(s),
                Err(e) => Err(anyhow!("{}", e)),
            }?
            .into_inner()
        };

        Ok(Box::pin(stream.filter_map(|msg| {
            let msg = match msg {
                Ok(msg) => msg,
                Err(e) => return Some(Err(anyhow!("failed to receive message: {}", e))),
            };

            if msg.payload.len() < 2 {
                debug!(
                    "received too short custom message payload: {:?}",
                    &msg.payload
                );
                return None;
            }

            let msg_type = u16::from_be_bytes([msg.payload[0], msg.payload[1]]);

            Some(Ok(CustomMessage {
                peer_id: msg.peer_id,
                message_type: msg_type,
                payload: msg.payload[2..].to_vec(),
            }))
        })))
    }

    async fn send_custom_message(&self, message: CustomMessage) -> NodeResult<()> {
        let mut msg = message.message_type.to_be_bytes().to_vec();
        msg.extend(message.payload);
        let resp = self
            .get_node_client()
            .await?
            .send_custom_msg(cln::SendcustommsgRequest {
                msg,
                node_id: message.peer_id,
            })
            .await?
            .into_inner();
        debug!("send_custom_message returned status {:?}", resp.status);
        Ok(())
    }

    // Gets the routing hints related to all private channels that the node has
    async fn get_routing_hints(&self) -> NodeResult<(Vec<RouteHint>, bool)> {
        let mut hints: Vec<RouteHint> = vec![];
        let mut node_client = self.get_node_client().await?;
        let channels = node_client
            .list_peer_channels(cln::ListpeerchannelsRequest::default())
            .await?
            .into_inner();

        let mut has_public_channel = false;
        let mut open_channels: Vec<cln::ListpeerchannelsChannels> = channels
            .channels
            .into_iter()
            .filter(|c| {
                let is_private = c.private.unwrap_or_default();
                has_public_channel |= !is_private;
                is_private && c.state == Some(cln::ChannelState::ChanneldNormal as i32)
            })
            .collect();

        // Ensure one private channel from each peer.
        open_channels.dedup_by_key(|c| c.peer_id.clone());

        // Ceate a routing hint from each channel.
        for c in open_channels {
            let (alias_remote, _) = match c.alias {
                Some(a) => (a.remote.clone(), a.local.clone()),
                None => (None, None),
            };

            let optional_channel_id = alias_remote.clone().or(c.short_channel_id.clone());

            if let Some(channel_id) = optional_channel_id {
                let scid = parse_short_channel_id(&channel_id)?;
                let hint = RouteHint {
                    hops: vec![RouteHintHop {
                        src_node_id: hex::encode(c.peer_id.ok_or(anyhow!("no peer id"))?),
                        short_channel_id: scid,
                        fees_base_msat: c.fee_base_msat.clone().unwrap_or_default().msat as u32,
                        fees_proportional_millionths: c
                            .fee_proportional_millionths
                            .unwrap_or_default(),
                        cltv_expiry_delta: 144,
                        htlc_minimum_msat: Some(
                            c.minimum_htlc_in_msat.clone().unwrap_or_default().msat,
                        ),
                        htlc_maximum_msat: None,
                    }],
                };
                info!("Generating hint hop as routing hint: {:?}", hint);
                hints.push(hint);
            }
        }
        Ok((hints, has_public_channel))
    }
}

#[derive(Parser, Clone, PartialEq, Eq, Debug, EnumString, Display, Deserialize, Serialize)]
enum NodeCommand {
    /// Generates diagnostic data report.
    #[command(name = "generatediagnosticdata")]
    #[strum(serialize = "generatediagnosticdata")]
    GenerateDiagnosticData,

    /// Closes all channels of all peers.
    #[command(name = "closeallchannels")]
    #[strum(serialize = "closeallchannels")]
    CloseAllChannels,

    /// See <https://docs.corelightning.org/reference/lightning-getinfo>
    #[command(name = "getinfo")]
    #[strum(serialize = "getinfo")]
    GetInfo,

    /// See <https://docs.corelightning.org/reference/lightning-listfunds>
    #[command(name = "listfunds")]
    #[strum(serialize = "listfunds")]
    ListFunds,

    /// See <https://docs.corelightning.org/reference/lightning-listinvoices>
    #[command(name = "listinvoices")]
    #[strum(serialize = "listinvoices")]
    ListInvoices,

    /// See <https://docs.corelightning.org/reference/lightning-listpays>
    #[command(name = "listpayments")]
    #[strum(serialize = "listpayments")]
    ListPayments,

    /// See <https://docs.corelightning.org/reference/lightning-listpeers>
    #[command(name = "listpeers")]
    #[strum(serialize = "listpeers")]
    ListPeers,

    /// See <https://docs.corelightning.org/reference/lightning-listpeerchannels>
    #[command(name = "listpeerchannels")]
    #[strum(serialize = "listpeerchannels")]
    ListPeerChannels,

    /// See <https://docs.corelightning.org/reference/lightning-listchannels>
    #[command(name = "listchannels")]
    #[strum(serialize = "listchannels")]
    ListChannels {
        #[arg(long)]
        source: Option<String>,
        #[arg(long)]
        destination: Option<String>,
        #[arg(long)]
        short_channel_id: Option<String>,
    },

    /// Stops the node.
    ///
    /// Note that this command will return an error, as the node is stopped before it can reply.
    ///
    /// See <https://docs.corelightning.org/reference/lightning-stop>
    #[command(name = "stop")]
    #[strum(serialize = "stop")]
    Stop,
}

// pulls transactions from greenlight based on last sync timestamp.
// greenlight gives us the payments via API and for received payments we are looking for settled invoices.
async fn pull_transactions(
    since_timestamp: u64,
    client: node::ClnClient,
    htlc_list: Vec<Htlc>,
) -> NodeResult<Vec<Payment>> {
    let mut c = client.clone();

    // list invoices
    let invoices = c
        .list_invoices(cln::ListinvoicesRequest::default())
        .await?
        .into_inner();
    // construct the received transactions by filtering the invoices to those paid and beyond the filter timestamp
    let received_transactions: NodeResult<Vec<Payment>> = invoices
        .invoices
        .into_iter()
        .filter(|i| {
            i.paid_at.unwrap_or_default() > since_timestamp
                && i.status() == ListinvoicesInvoicesStatus::Paid
        })
        .map(TryInto::try_into)
        .collect();

    // fetch payments from greenlight
    let payments = c
        .list_pays(cln::ListpaysRequest::default())
        .await?
        .into_inner();
    trace!("list payments (unfiltered): {:?}", payments);
    // construct the payment transactions (pending and complete)
    let outbound_transactions: NodeResult<Vec<Payment>> = payments
        .pays
        .into_iter()
        .filter(|p| {
            p.created_at > since_timestamp
                || match p.completed_at {
                    None => true,
                    Some(completed_at) => completed_at > since_timestamp,
                }
        })
        .map(TryInto::try_into)
        .collect();

    let outbound_transactions: NodeResult<Vec<Payment>> =
        update_payment_expirations(outbound_transactions?, htlc_list);

    let mut transactions: Vec<Payment> = Vec::new();
    transactions.extend(received_transactions?);
    transactions.extend(outbound_transactions?);

    Ok(transactions)
}

fn update_payment_expirations(
    payments: Vec<Payment>,
    htlc_list: Vec<Htlc>,
) -> NodeResult<Vec<Payment>> {
    if htlc_list.is_empty() {
        return Ok(payments);
    }

    let mut payments_res: Vec<Payment> = Vec::new();
    for mut payment in payments {
        if payment.status == PaymentStatus::Pending {
            let new_data = payment.clone().details;
            if let PaymentDetails::Ln { data } = new_data {
                for htlc in &htlc_list {
                    let payment_hash = hex::encode(htlc.clone().payment_hash);
                    if payment_hash == data.payment_hash
                        && data.pending_expiration_block < Some(htlc.expiry)
                    {
                        payment.details.add_pending_expiration_block(htlc.clone())
                    }
                }
            }
        }
        payments_res.push(payment);
    }
    info!("pending htlc payments {:?}", payments_res);
    Ok(payments_res)
}

//pub(crate) fn offchain_payment_to_transaction
impl TryFrom<OffChainPayment> for Payment {
    type Error = NodeError;

    fn try_from(p: OffChainPayment) -> std::result::Result<Self, Self::Error> {
        let ln_invoice = parse_invoice(&p.bolt11)?;
        Ok(Payment {
            id: hex::encode(p.payment_hash.clone()),
            payment_type: PaymentType::Received,
            payment_time: SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs() as i64,
            amount_msat: amount_to_msat(&p.amount.unwrap_or_default()),
            fee_msat: 0,
            status: PaymentStatus::Complete,
            error: None,
            description: ln_invoice.description,
            details: PaymentDetails::Ln {
                data: LnPaymentDetails {
                    payment_hash: hex::encode(p.payment_hash),
                    label: p.label,
                    destination_pubkey: ln_invoice.payee_pubkey,
                    payment_preimage: hex::encode(p.preimage),
                    keysend: false,
                    bolt11: p.bolt11,
                    lnurl_success_action: None, // For received payments, this is None
                    lnurl_pay_domain: None,     // For received payments, this is None
                    lnurl_pay_comment: None,    // For received payments, this is None
                    lnurl_metadata: None,       // For received payments, this is None
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                    swap_info: None,
                    reverse_swap_info: None,
                    pending_expiration_block: None,
                    open_channel_bolt11: None,
                },
            },
            metadata: None,
        })
    }
    // fn from(p: OffChainPayment) -> Self {

    //}
}

/// Construct a lightning transaction from an invoice
impl TryFrom<gl_client::signer::model::greenlight::Invoice> for Payment {
    type Error = NodeError;

    fn try_from(
        invoice: gl_client::signer::model::greenlight::Invoice,
    ) -> std::result::Result<Self, Self::Error> {
        let ln_invoice = parse_invoice(&invoice.bolt11)?;
        Ok(Payment {
            id: hex::encode(invoice.payment_hash.clone()),
            payment_type: PaymentType::Received,
            payment_time: invoice.payment_time as i64,
            amount_msat: amount_to_msat(&invoice.amount.unwrap_or_default()),
            fee_msat: 0,
            status: PaymentStatus::Complete,
            error: None,
            description: ln_invoice.description,
            details: PaymentDetails::Ln {
                data: LnPaymentDetails {
                    payment_hash: hex::encode(invoice.payment_hash),
                    label: invoice.label,
                    destination_pubkey: ln_invoice.payee_pubkey,
                    payment_preimage: hex::encode(invoice.payment_preimage),
                    keysend: false,
                    bolt11: invoice.bolt11,
                    lnurl_success_action: None, // For received payments, this is None
                    lnurl_pay_domain: None,     // For received payments, this is None
                    lnurl_pay_comment: None,    // For received payments, this is None
                    lnurl_metadata: None,       // For received payments, this is None
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                    swap_info: None,
                    reverse_swap_info: None,
                    pending_expiration_block: None,
                    open_channel_bolt11: None,
                },
            },
            metadata: None,
        })
    }
}

impl From<PayStatus> for PaymentStatus {
    fn from(value: PayStatus) -> Self {
        match value {
            PayStatus::Pending => PaymentStatus::Pending,
            PayStatus::Complete => PaymentStatus::Complete,
            PayStatus::Failed => PaymentStatus::Failed,
        }
    }
}

/// Construct a lightning transaction from an invoice
impl TryFrom<gl_client::signer::model::greenlight::Payment> for Payment {
    type Error = NodeError;

    fn try_from(
        payment: gl_client::signer::model::greenlight::Payment,
    ) -> std::result::Result<Self, Self::Error> {
        let mut description = None;
        if !payment.bolt11.is_empty() {
            description = parse_invoice(&payment.bolt11)?.description;
        }

        let payment_amount = amount_to_msat(&payment.amount.clone().unwrap_or_default());
        let payment_amount_sent = amount_to_msat(&payment.amount_sent.clone().unwrap_or_default());
        let status = payment.status().into();

        Ok(Payment {
            id: hex::encode(payment.payment_hash.clone()),
            payment_type: PaymentType::Sent,
            payment_time: payment.created_at as i64,
            amount_msat: payment_amount,
            fee_msat: payment_amount_sent - payment_amount,
            status,
            error: None,
            description,
            details: PaymentDetails::Ln {
                data: LnPaymentDetails {
                    payment_hash: hex::encode(payment.payment_hash),
                    label: "".to_string(),
                    destination_pubkey: hex::encode(payment.destination),
                    payment_preimage: hex::encode(payment.payment_preimage),
                    keysend: payment.bolt11.is_empty(),
                    bolt11: payment.bolt11,
                    lnurl_success_action: None,
                    lnurl_pay_domain: None,
                    lnurl_pay_comment: None,
                    lnurl_metadata: None,
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                    swap_info: None,
                    reverse_swap_info: None,
                    pending_expiration_block: None,
                    open_channel_bolt11: None,
                },
            },
            metadata: None,
        })
    }
}

/// Construct a lightning transaction from an invoice
impl TryFrom<cln::ListinvoicesInvoices> for Payment {
    type Error = NodeError;

    fn try_from(invoice: cln::ListinvoicesInvoices) -> std::result::Result<Self, Self::Error> {
        let ln_invoice = invoice
            .bolt11
            .as_ref()
            .ok_or(InvoiceError::generic("No bolt11 invoice"))
            .and_then(|b| parse_invoice(b))?;
        Ok(Payment {
            id: hex::encode(invoice.payment_hash.clone()),
            payment_type: PaymentType::Received,
            payment_time: invoice.paid_at.map(|i| i as i64).unwrap_or_default(),
            amount_msat: invoice.amount_msat.map(|a| a.msat).unwrap_or_default(),
            fee_msat: 0,
            status: PaymentStatus::Complete,
            error: None,
            description: ln_invoice.description,
            details: PaymentDetails::Ln {
                data: LnPaymentDetails {
                    payment_hash: hex::encode(invoice.payment_hash),
                    label: invoice.label,
                    destination_pubkey: ln_invoice.payee_pubkey,
                    payment_preimage: invoice
                        .payment_preimage
                        .map(hex::encode)
                        .unwrap_or_default(),
                    keysend: false,
                    bolt11: invoice.bolt11.unwrap_or_default(),
                    lnurl_success_action: None, // For received payments, this is None
                    lnurl_pay_domain: None,     // For received payments, this is None
                    lnurl_pay_comment: None,    // For received payments, this is None
                    lnurl_metadata: None,       // For received payments, this is None
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                    swap_info: None,
                    reverse_swap_info: None,
                    pending_expiration_block: None,
                    open_channel_bolt11: None,
                },
            },
            metadata: None,
        })
    }
}

impl From<ListpaysPaysStatus> for PaymentStatus {
    fn from(value: ListpaysPaysStatus) -> Self {
        match value {
            ListpaysPaysStatus::Pending => PaymentStatus::Pending,
            ListpaysPaysStatus::Complete => PaymentStatus::Complete,
            ListpaysPaysStatus::Failed => PaymentStatus::Failed,
        }
    }
}

impl TryFrom<cln::ListpaysPays> for Payment {
    type Error = NodeError;

    fn try_from(payment: cln::ListpaysPays) -> NodeResult<Self, Self::Error> {
        let ln_invoice = payment
            .bolt11
            .as_ref()
            .ok_or(InvoiceError::generic("No bolt11 invoice"))
            .and_then(|b| parse_invoice(b));
        let payment_amount = payment
            .amount_msat
            .clone()
            .map(|a| a.msat)
            .unwrap_or_default();
        let payment_amount_sent = payment
            .amount_sent_msat
            .clone()
            .map(|a| a.msat)
            .unwrap_or_default();
        let status = payment.status().into();

        Ok(Payment {
            id: hex::encode(payment.payment_hash.clone()),
            payment_type: PaymentType::Sent,
            payment_time: payment.completed_at.unwrap_or(payment.created_at) as i64,
            amount_msat: match status {
                PaymentStatus::Complete => payment_amount,
                _ => ln_invoice
                    .as_ref()
                    .map_or(0, |i| i.amount_msat.unwrap_or_default()),
            },
            fee_msat: payment_amount_sent - payment_amount,
            status,
            error: None,
            description: ln_invoice.map(|i| i.description).unwrap_or_default(),
            details: PaymentDetails::Ln {
                data: LnPaymentDetails {
                    payment_hash: hex::encode(payment.payment_hash),
                    label: payment.label.unwrap_or_default(),
                    destination_pubkey: payment.destination.map(hex::encode).unwrap_or_default(),
                    payment_preimage: payment.preimage.map(hex::encode).unwrap_or_default(),
                    keysend: payment.bolt11.is_none(),
                    bolt11: payment.bolt11.unwrap_or_default(),
                    lnurl_success_action: None,
                    lnurl_pay_domain: None,
                    lnurl_pay_comment: None,
                    lnurl_metadata: None,
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                    swap_info: None,
                    reverse_swap_info: None,
                    pending_expiration_block: None,
                    open_channel_bolt11: None,
                },
            },
            metadata: None,
        })
    }
}

impl TryFrom<cln::PayResponse> for PaymentResponse {
    type Error = NodeError;

    fn try_from(payment: cln::PayResponse) -> std::result::Result<Self, Self::Error> {
        let payment_amount = payment.amount_msat.unwrap_or_default().msat;
        let payment_amount_sent = payment.amount_sent_msat.unwrap_or_default().msat;

        Ok(PaymentResponse {
            payment_time: payment.created_at as i64,
            amount_msat: payment_amount,
            fee_msat: payment_amount_sent - payment_amount,
            payment_hash: hex::encode(payment.payment_hash),
            payment_preimage: hex::encode(payment.payment_preimage),
        })
    }
}

impl TryFrom<cln::KeysendResponse> for PaymentResponse {
    type Error = NodeError;

    fn try_from(payment: cln::KeysendResponse) -> std::result::Result<Self, Self::Error> {
        let payment_amount = payment.amount_msat.unwrap_or_default().msat;
        let payment_amount_sent = payment.amount_sent_msat.unwrap_or_default().msat;

        Ok(PaymentResponse {
            payment_time: payment.created_at as i64,
            amount_msat: payment_amount,
            fee_msat: payment_amount_sent - payment_amount,
            payment_hash: hex::encode(payment.payment_hash),
            payment_preimage: hex::encode(payment.payment_preimage),
        })
    }
}

fn amount_to_msat(amount: &gl_client::pb::greenlight::Amount) -> u64 {
    match amount.unit {
        Some(amount::Unit::Millisatoshi(val)) => val,
        Some(amount::Unit::Satoshi(val)) => val * 1000,
        Some(amount::Unit::Bitcoin(val)) => val * 100000000,
        Some(_) => 0,
        None => 0,
    }
}

impl From<cln::ListpeersPeers> for Peer {
    fn from(c: cln::ListpeersPeers) -> Self {
        Peer {
            id: c.id,
            channels: c.channels.into_iter().map(|c| c.into()).collect(),
        }
    }
}

/// Conversion for an open channel
impl From<cln::ListpeersPeersChannels> for Channel {
    fn from(c: cln::ListpeersPeersChannels) -> Self {
        let state = match c.state() {
            Openingd | ChanneldAwaitingLockin | DualopendOpenInit | DualopendAwaitingLockin => {
                ChannelState::PendingOpen
            }
            ChanneldNormal => ChannelState::Opened,
            Onchain => ChannelState::Closed,
            _ => ChannelState::PendingClose,
        };

        let (alias_remote, alias_local) = match c.alias {
            Some(a) => (a.remote, a.local),
            None => (None, None),
        };

        Channel {
            short_channel_id: c.short_channel_id,
            state,
            funding_txid: c.funding_txid.map(hex::encode).unwrap_or_default(),
            spendable_msat: c.spendable_msat.unwrap_or_default().msat,
            local_balance_msat: c.to_us_msat.unwrap_or_default().msat,
            receivable_msat: c.receivable_msat.unwrap_or_default().msat,
            closed_at: None,
            funding_outnum: c.funding_outnum,
            alias_remote,
            alias_local,
            closing_txid: None,
            htlcs: c
                .htlcs
                .into_iter()
                .map(|c| Htlc::from(c.expiry, c.payment_hash))
                .collect(),
        }
    }
}

fn convert_to_send_pay_route(
    route: PaymentPath,
    to_pay_msat: u64,
    final_cltv_delta: u64,
) -> (Vec<SendpayRoute>, u64) {
    let mut sendpay_route = vec![];
    let mut to_forward = to_pay_msat;
    let mut cltv_delay = 0;
    let hops_arr = route.edges.as_slice();

    let reverse_hops: Vec<&PaymentPathEdge> = hops_arr.iter().rev().collect();

    // Iterating over the path in a reverse order so we can calculate
    // the cltv deltas and fees.
    for (reverse_index, hop) in reverse_hops.iter().enumerate() {
        //let hop = h.clone();
        (to_forward, cltv_delay) = match reverse_index == 0 {
            // last hop should not take any fees and should use the final_cltv_delta.
            true => (to_forward, final_cltv_delta),

            // all other hops are forwarding therefore should take fees and increase the cltv delta.
            false => (
                reverse_hops[reverse_index - 1].amount_from_forward(to_forward),
                cltv_delay + reverse_hops[reverse_index - 1].channel_delay,
            ),
        };

        sendpay_route.insert(
            0,
            SendpayRoute {
                amount_msat: Some(gl_client::pb::cln::Amount { msat: to_forward }),
                id: hop.node_id.clone(),
                delay: cltv_delay as u32,
                channel: hop.short_channel_id.clone(),
            },
        );
    }

    (sendpay_route, to_forward)
}

impl TryFrom<ListclosedchannelsClosedchannels> for Channel {
    type Error = NodeError;

    fn try_from(
        c: cln::ListclosedchannelsClosedchannels,
    ) -> std::result::Result<Self, Self::Error> {
        let (alias_remote, alias_local) = match c.alias {
            Some(a) => (a.remote, a.local),
            None => (None, None),
        };

        // To keep the conversion simple and fast, some closing-related fields (closed_at, closing_txid)
        // are left empty here in the conversion, but populated later (via chain service lookup, or DB lookup)
        let local_balance_msat = c
            .final_to_us_msat
            .ok_or(anyhow!("final_to_us_msat is missing"))?
            .msat;
        Ok(Channel {
            short_channel_id: c.short_channel_id,
            state: ChannelState::Closed,
            funding_txid: hex::encode(c.funding_txid),
            spendable_msat: local_balance_msat,
            local_balance_msat,
            receivable_msat: 0,
            closed_at: None,
            funding_outnum: Some(c.funding_outnum),
            alias_remote,
            alias_local,
            closing_txid: None,
            htlcs: Vec::new(),
        })
    }
}

#[cfg(test)]
mod tests {
    use anyhow::Result;
    use gl_client::pb::cln::listpeers_peers_channels::{
        ListpeersPeersChannelsState, ListpeersPeersChannelsState::*,
    };
    use gl_client::pb::cln::Amount;
    use gl_client::pb::{self, cln};

    use crate::greenlight::node_api::convert_to_send_pay_route;
    use crate::{models, PaymentPath, PaymentPathEdge};

    #[test]
    fn test_convert_route() -> Result<()> {
        let path = PaymentPath {
            edges: vec![
                PaymentPathEdge {
                    node_id: vec![1],
                    short_channel_id: "807189x2048x0".into(),
                    channel_delay: 34,
                    base_fee_msat: 1000,
                    fee_per_millionth: 10,
                },
                PaymentPathEdge {
                    node_id: vec![2],
                    short_channel_id: "811871x2726x1".into(),
                    channel_delay: 34,
                    base_fee_msat: 0,
                    fee_per_millionth: 0,
                },
                PaymentPathEdge {
                    node_id: vec![3],
                    short_channel_id: "16000000x0x18087".into(),
                    channel_delay: 40,
                    base_fee_msat: 1000,
                    fee_per_millionth: 1,
                },
            ],
        };

        let (r, sent) = convert_to_send_pay_route(path, 50000000, 144);
        assert_eq!(
            r,
            vec![
                pb::cln::SendpayRoute {
                    amount_msat: Some(gl_client::pb::cln::Amount { msat: 50001050 }),
                    id: vec![1],
                    delay: 218,
                    channel: "807189x2048x0".into(),
                },
                pb::cln::SendpayRoute {
                    amount_msat: Some(gl_client::pb::cln::Amount { msat: 50001050 }),
                    id: vec![2],
                    delay: 184,
                    channel: "811871x2726x1".into(),
                },
                pb::cln::SendpayRoute {
                    amount_msat: Some(gl_client::pb::cln::Amount { msat: 50000000 }),
                    id: vec![3],
                    delay: 144,
                    channel: "16000000x0x18087".into(),
                }
            ]
        );
        assert_eq!(sent, 50001050);

        let path = PaymentPath {
            edges: vec![
                PaymentPathEdge {
                    node_id: vec![1],
                    short_channel_id: "807189x2048x0".into(),
                    channel_delay: 34,
                    base_fee_msat: 1000,
                    fee_per_millionth: 10,
                },
                PaymentPathEdge {
                    node_id: vec![2],
                    short_channel_id: "811871x2726x1".into(),
                    channel_delay: 34,
                    base_fee_msat: 0,
                    fee_per_millionth: 0,
                },
                PaymentPathEdge {
                    node_id: vec![3],
                    short_channel_id: "16000000x0x18087".into(),
                    channel_delay: 40,
                    base_fee_msat: 0,
                    fee_per_millionth: 2000,
                },
            ],
        };
        let (r, sent) = convert_to_send_pay_route(path, 50000000, 144);
        assert_eq!(
            r,
            vec![
                pb::cln::SendpayRoute {
                    amount_msat: Some(gl_client::pb::cln::Amount { msat: 50100000 }),
                    id: vec![1],
                    delay: 218,
                    channel: "807189x2048x0".into(),
                },
                pb::cln::SendpayRoute {
                    amount_msat: Some(gl_client::pb::cln::Amount { msat: 50100000 }),
                    id: vec![2],
                    delay: 184,
                    channel: "811871x2726x1".into(),
                },
                pb::cln::SendpayRoute {
                    amount_msat: Some(gl_client::pb::cln::Amount { msat: 50000000 }),
                    id: vec![3],
                    delay: 144,
                    channel: "16000000x0x18087".into(),
                }
            ]
        );
        assert_eq!(sent, 50100000);

        Ok(())
    }

    #[test]
    fn test_channel_states() -> Result<()> {
        for s in &[Openingd, ChanneldAwaitingLockin] {
            let c: models::Channel = cln_channel(s).into();
            assert_eq!(c.state, models::ChannelState::PendingOpen);
        }

        let s = ChanneldNormal;
        let c: models::Channel = cln_channel(&s).into();
        assert_eq!(c.state, models::ChannelState::Opened);

        for s in &[
            ChanneldShuttingDown,
            ClosingdSigexchange,
            ClosingdComplete,
            AwaitingUnilateral,
            FundingSpendSeen,
        ] {
            let c: models::Channel = cln_channel(s).into();
            assert_eq!(c.state, models::ChannelState::PendingClose);
        }

        let c: models::Channel = cln_channel(&Onchain).into();
        assert_eq!(c.state, models::ChannelState::Closed);

        Ok(())
    }

    fn cln_channel(state: &ListpeersPeersChannelsState) -> cln::ListpeersPeersChannels {
        cln::ListpeersPeersChannels {
            state: (*state).into(),
            scratch_txid: None,
            feerate: None,
            owner: None,
            short_channel_id: None,
            channel_id: None,
            funding_txid: None,
            funding_outnum: None,
            initial_feerate: None,
            last_feerate: None,
            next_feerate: None,
            next_fee_step: None,
            inflight: vec![],
            close_to: None,
            private: Some(true),
            opener: 0,
            closer: None,
            features: vec![],
            funding: None,
            to_us_msat: None,
            min_to_us_msat: None,
            max_to_us_msat: None,
            total_msat: Some(Amount { msat: 1_000 }),
            fee_base_msat: None,
            fee_proportional_millionths: None,
            dust_limit_msat: Some(Amount { msat: 10 }),
            max_total_htlc_in_msat: None,
            their_reserve_msat: None,
            our_reserve_msat: None,
            spendable_msat: Some(Amount { msat: 20_000 }),
            receivable_msat: Some(Amount { msat: 960_000 }),
            minimum_htlc_in_msat: None,
            minimum_htlc_out_msat: None,
            maximum_htlc_out_msat: None,
            their_to_self_delay: Some(144),
            our_to_self_delay: Some(144),
            max_accepted_htlcs: None,
            alias: None,
            status: vec![],
            in_payments_offered: None,
            in_offered_msat: None,
            in_payments_fulfilled: None,
            in_fulfilled_msat: None,
            out_payments_offered: None,
            out_offered_msat: None,
            out_payments_fulfilled: None,
            out_fulfilled_msat: None,
            htlcs: vec![],
            close_to_addr: None,
        }
    }
}
