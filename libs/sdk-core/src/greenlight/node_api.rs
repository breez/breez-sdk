use std::cmp::{max, min};
use std::pin::Pin;
use std::str::FromStr;
use std::sync::Arc;
use std::time::{Duration, SystemTime, UNIX_EPOCH};

use anyhow::{anyhow, Result};
use bitcoin::bech32::{u5, ToBase32};
use bitcoin::blockdata::constants::WITNESS_SCALE_FACTOR;
use bitcoin::hashes::Hash;
use bitcoin::secp256k1::ecdsa::{RecoverableSignature, RecoveryId};
use bitcoin::secp256k1::PublicKey;
use bitcoin::secp256k1::Secp256k1;
use bitcoin::util::bip32::{ChildNumber, ExtendedPrivKey};
use bitcoin::{Address, OutPoint, Script, Sequence, Transaction, TxIn, TxOut, Txid, Witness};
use ecies::symmetric::{sym_decrypt, sym_encrypt};
use gl_client::node::ClnClient;
use gl_client::pb::cln::listinvoices_invoices::ListinvoicesInvoicesStatus;
use gl_client::pb::cln::listpays_pays::ListpaysPaysStatus;
use gl_client::pb::cln::listpeers_peers_channels::ListpeersPeersChannelsState::*;
use gl_client::scheduler::Scheduler;
use gl_client::signer::model::greenlight::{amount, cln, scheduler, OffChainPayment, PayStatus};
use gl_client::signer::Signer;
use gl_client::tls::TlsConfig;
use gl_client::{node, utils};
use lightning::offers::offer::Offer;
use lightning::util::message_signing::verify;
use lightning_invoice::{RawInvoice, SignedRawInvoice};
use serde::{Deserialize, Serialize};
use strum_macros::{Display, EnumString};
use tokio::sync::{mpsc, Mutex};
use tokio::time::sleep;
use tokio_stream::{Stream, StreamExt};
use tonic::Streaming;

use crate::invoice::{parse_invoice, InvoiceError};
use crate::models::*;
use crate::node_api::{NodeAPI, NodeError, NodeResult};
use crate::persist::db::SqliteStorage;
use crate::{Channel, ChannelState, NodeConfig, PrepareSweepRequest, PrepareSweepResponse};
use std::iter::Iterator;

const MAX_PAYMENT_AMOUNT_MSAT: u64 = 4294967000;
const MAX_INBOUND_LIQUIDITY_MSAT: u64 = 4000000000;

pub(crate) struct Greenlight {
    sdk_config: Config,
    signer: Signer,
    tls_config: TlsConfig,
    gl_client: Mutex<Option<node::Client>>,
    node_client: Mutex<Option<ClnClient>>,
    persister: Arc<SqliteStorage>,
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
        persister: Arc<SqliteStorage>,
    ) -> Result<Self> {
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

        let legacy_encryption_key = Self::legacy_derive_bip32_key(
            config.network,
            &signer,
            vec![ChildNumber::from_hardened_idx(140)?, ChildNumber::from(0)],
        )?
        .to_priv()
        .to_bytes();
        let legacy_encryption_key_slice = legacy_encryption_key.as_slice();

        let register_credentials = match config.node_config.clone() {
            NodeConfig::Greenlight { config } => config,
        };

        // query for the existing credentials
        let credentials = persister.get_gl_credentials()?;
        let parsed_credentials: Result<GreenlightCredentials> = match credentials {
            // In case we found existing credentials, try to decrypt them and connect to the node
            Some(creds) => {
                let mut decrypted_credentials = sym_decrypt(encryption_key_slice, creds.as_slice());
                if decrypted_credentials.is_none() {
                    info!("Failed to decrypt credentials, trying legacy key");
                    decrypted_credentials =
                        sym_decrypt(legacy_encryption_key_slice, creds.as_slice());
                }
                match decrypted_credentials {
                    Some(creds) => {
                        let built_credentials: GreenlightCredentials =
                            serde_json::from_slice(creds.as_slice())?;
                        info!("Initializing greenlight from existing credentials");
                        Ok(built_credentials)
                    }
                    None => {
                        return Err(anyhow!(
                            "Failed to decrypt credentials, seed doesn't match existing node"
                        ));
                    }
                }
            }
            // In case no credentials were found, try to recover the node
            None => {
                info!("No credentials found, trying to recover existing node");
                let recovered = Self::recover(config.network, seed.clone()).await;
                match recovered {
                    Ok(creds) => Ok(creds),
                    Err(_) => {
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
                }
            }
        };

        // Persist the connection credentials for future use and return the node instance
        let res = match parsed_credentials {
            Ok(creds) => {
                let json_creds = serde_json::to_string(&creds)?.as_bytes().to_vec();
                let encryptd_creds = sym_encrypt(encryption_key_slice, json_creds.as_slice());
                match encryptd_creds {
                    Some(c) => {
                        persister.set_gl_credentials(c)?;
                        let gl_node = Greenlight::new(config, seed, creds, persister).await?;
                        // Make small API call to ensure the signer can be scheduled. This will fail if there are any network issues.
                        // The other two scenarios (recover, register) already include a network call.
                        gl_node.start().await?;
                        Ok(gl_node)
                    }
                    None => {
                        return Err(anyhow!("Failed to encrypt credentials"));
                    }
                }
            }
            Err(_) => Err(anyhow!("Failed to get gl credentials")),
        };
        res
    }

    async fn new(
        sdk_config: Config,
        seed: Vec<u8>,
        connection_credentials: GreenlightCredentials,
        persister: Arc<SqliteStorage>,
    ) -> Result<Greenlight> {
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
        })
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
                .map_err(NodeError::ServiceConnectivity)?;
            *gl_client = Some(
                scheduler
                    .schedule(self.tls_config.clone())
                    .await
                    .map_err(NodeError::ServiceConnectivity)?,
            );
        }
        Ok(gl_client.clone().unwrap())
    }

    pub(crate) async fn get_node_client(&self) -> NodeResult<node::ClnClient> {
        let mut node_client = self.node_client.lock().await;
        if node_client.is_none() {
            let scheduler = Scheduler::new(self.signer.node_id(), self.sdk_config.network.into())
                .await
                .map_err(NodeError::ServiceConnectivity)?;
            *node_client = Some(
                scheduler
                    .schedule(self.tls_config.clone())
                    .await
                    .map_err(NodeError::ServiceConnectivity)?,
            );
        }
        Ok(node_client.clone().unwrap())
    }

    async fn fetch_channels_and_balance_with_retry(
        cln_client: node::ClnClient,
        persister: Arc<SqliteStorage>,
        balance_changed: bool,
    ) -> NodeResult<(
        Vec<cln::ListpeersPeersChannels>,
        Vec<cln::ListpeersPeersChannels>,
        Vec<String>,
        u64,
    )> {
        let (mut all_channels, mut opened_channels, mut connected_peers, mut channels_balance) =
            Greenlight::fetch_channels_and_balance(cln_client.clone()).await?;
        if balance_changed {
            let node_state = persister.get_node_state()?;
            if let Some(state) = node_state {
                let mut retry_count = 0;
                while state.channels_balance_msat == channels_balance && retry_count < 10 {
                    warn!("balance update was required but was not updated, retrying in 100ms...");
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
            .cloned()
            .filter(|c| c.state() == ChanneldNormal)
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

    async fn on_chain_balance(&self, funds: cln::ListfundsResponse) -> Result<u64> {
        let on_chain_balance = funds.outputs.iter().fold(0, |a, b| {
            if b.reserved {
                return a;
            }
            a + b.amount_msat.clone().unwrap_or_default().msat
        });
        Ok(on_chain_balance)
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
}

#[tonic::async_trait]
impl NodeAPI for Greenlight {
    async fn create_invoice(
        &self,
        amount_msat: u64,
        description: String,
        preimage: Option<Vec<u8>>,
        use_description_hash: Option<bool>,
        expiry: Option<u32>,
        cltv: Option<u32>,
    ) -> NodeResult<String> {
        let mut client = self.get_node_client().await?;
        let request = cln::InvoiceRequest {
            amount_msat: Some(cln::AmountOrAny {
                value: Some(cln::amount_or_any::Value::Amount(cln::Amount {
                    msat: amount_msat,
                })),
            }),
            label: format!(
                "breez-{}",
                SystemTime::now().duration_since(UNIX_EPOCH)?.as_millis()
            ),
            description,
            preimage,
            deschashonly: use_description_hash,
            expiry: expiry.map(|e| e as u64),
            fallbacks: vec![],
            cltv,
        };

        let res = client.invoice(request).await?.into_inner();
        Ok(res.bolt11)
    }

    // implement pull changes from greenlight
    async fn pull_changed(
        &self,
        since_timestamp: u64,
        balance_changed: bool,
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
            balance_changed,
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
        let onchain_balance = self.on_chain_balance(funds.clone()).await?;
        let utxos = self.utxos(funds).await?;

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

        let max_allowed_to_receive_msats = max(MAX_INBOUND_LIQUIDITY_MSAT - channels_balance, 0);
        let node_pubkey = hex::encode(node_info.id);

        // construct the node state
        let node_state = NodeState {
            id: node_pubkey.clone(),
            block_height: node_info.blockheight,
            channels_balance_msat: channels_balance,
            onchain_balance_msat: onchain_balance,
            utxos,
            max_payable_msat: max_payable,
            max_receivable_msat: max_allowed_to_receive_msats,
            max_single_payment_amount_msat: MAX_PAYMENT_AMOUNT_MSAT,
            max_chan_reserve_msats: channels_balance - min(max_payable, channels_balance),
            connected_peers,
            inbound_liquidity_msats: max_receivable_single_channel,
        };

        Ok(SyncResponse {
            node_state,
            payments: pull_transactions(since_timestamp, node_client.clone()).await?,
            channels: all_channel_models,
        })
    }

    async fn send_payment(
        &self,
        bolt11: String,
        amount_msat: Option<u64>,
    ) -> NodeResult<PaymentResponse> {
        let mut description = None;
        if !bolt11.is_empty() {
            description = parse_invoice(&bolt11)?.description;
        }

        let mut client: node::ClnClient = self.get_node_client().await?;
        let request = cln::PayRequest {
            bolt11,
            amount_msat: amount_msat.map(|amt| cln::Amount { msat: amt }),
            maxfeepercent: Some(self.sdk_config.maxfee_percent),
            retry_for: Some(self.sdk_config.payment_timeout_sec),
            label: None,
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
        client.pay(request).await?.into_inner().try_into()
    }

    async fn send_spontaneous_payment(
        &self,
        node_id: String,
        amount_msat: u64,
    ) -> NodeResult<PaymentResponse> {
        let mut client: node::ClnClient = self.get_node_client().await?;
        let request = cln::KeysendRequest {
            destination: hex::decode(node_id)?,
            amount_msat: Some(cln::Amount { msat: amount_msat }),
            label: Some(format!(
                "breez-{}",
                SystemTime::now().duration_since(UNIX_EPOCH)?.as_millis()
            )),
            extratlvs: None,
            routehints: None,
            maxfeepercent: Some(self.sdk_config.maxfee_percent),
            exemptfee: None,
            retry_for: Some(self.sdk_config.payment_timeout_sec),
            maxdelay: None,
        };
        client.key_send(request).await?.into_inner().try_into()
    }

    async fn start(&self) -> NodeResult<String> {
        let node_info = self
            .get_node_client()
            .await?
            .getinfo(cln::GetinfoRequest {})
            .await?
            .into_inner();
        Ok(hex::encode(node_info.id))
    }

    async fn sweep(&self, to_address: String, fee_rate_sats_per_vbyte: u32) -> NodeResult<Vec<u8>> {
        let mut client = self.get_node_client().await?;

        let request = cln::WithdrawRequest {
            feerate: Some(cln::Feerate {
                style: Some(cln::feerate::Style::Perkw(fee_rate_sats_per_vbyte * 250)),
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

    async fn prepare_sweep(&self, req: PrepareSweepRequest) -> NodeResult<PrepareSweepResponse> {
        let funds = self.list_funds().await?;
        let utxos = self.utxos(funds).await?;

        let mut amount: u64 = 0;
        let txins: Vec<TxIn> = utxos
            .iter()
            .map(|utxo| {
                amount += utxo.amount_millisatoshi;
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

        // remove millisats lower than 1 satoshi (1-999 msat)
        amount /= 1000;
        amount *= 1000;

        let btc_address = Address::from_str(&req.to_address)?;
        let tx_out: Vec<TxOut> = vec![TxOut {
            value: amount,
            script_pubkey: btc_address.payload.script_pubkey(),
        }];
        let mut tx = Transaction {
            version: 2,
            lock_time: bitcoin::PackedLockTime(0),
            input: txins.clone(),
            output: tx_out,
        };

        let witness_input_size: u64 = 110;
        let tx_weight = tx.strippedsize() as u64 * WITNESS_SCALE_FACTOR as u64
            + witness_input_size * txins.len() as u64;
        let fee: u64 = tx_weight * req.sats_per_vbyte / WITNESS_SCALE_FACTOR as u64;
        if fee >= amount {
            return Err(NodeError::Generic(anyhow!(
                "Insufficient funds to pay fees"
            )));
        }
        tx.output[0].value = amount - fee;

        return Ok(PrepareSweepResponse {
            sweep_tx_weight: tx_weight,
            sweep_tx_fee_sat: fee,
        });
    }

    /// Starts the signer that listens in a loop until the shutdown signal is received
    async fn start_signer(&self, shutdown: mpsc::Receiver<()>) {
        match self.signer.run_forever(shutdown).await {
            Ok(_) => info!("signer exited gracefully"),
            Err(e) => error!("signer exited with error: {e}"),
        }
    }

    async fn list_peers(&self) -> NodeResult<Vec<Peer>> {
        let mut client = self.get_node_client().await?;

        let res: cln::ListpeersResponse = client
            .list_peers(cln::ListpeersRequest::default())
            .await?
            .into_inner();

        let peers_models: Vec<Peer> = res.peers.into_iter().map(|p| p.into()).collect();
        Ok(peers_models)
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

    fn sign_invoice(&self, invoice: RawInvoice) -> NodeResult<String> {
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

        let signed_invoice: Result<SignedRawInvoice> = invoice.sign(|_| Ok(recoverable_sig));
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

    async fn execute_command(&self, command: String) -> NodeResult<String> {
        let node_cmd =
            NodeCommand::from_str(&command).map_err(|_| anyhow!("Command not found: {command}"))?;
        match node_cmd {
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
        }
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

    async fn fetch_invoice(&self, req: FetchInvoiceRequest) -> NodeResult<FetchInvoiceResponse> {
        // Parse the offer locally, to avoid any unnecessary calls to the recipient
        if let Err(_parse_error) = req.offer.parse::<Offer>() {
            return Err(NodeError::InvalidOffer(anyhow!("Invalid offer")));
        };

        // Fetch the invoice from the recipient's node
        let mut client = self.get_node_client().await?;
        let response = client
            .fetch_invoice(Into::<cln::FetchinvoiceRequest>::into(req))
            .await?
            .into_inner();

        Ok(FetchInvoiceResponse {
            bolt12: response.invoice,
            new_amount_msat: match response.changes {
                Some(changes) => changes.amount_msat.map(|amount| amount.msat),
                None => None
            },
        })
    }

    async fn create_offer(
        &self, 
        req: CreateOfferRequest
    ) -> NodeResult<String> {
        let mut client = self.get_node_client().await?;

        let offer = client.offer(cln::OfferRequest {
            amount: req.amount_msat.map(|msat| cln::AmountOrAny {
                value: Some(cln::amount_or_any::Value::Amount(
                    cln::Amount {
                        msat
                    }
                ))
            }),
            description: req.description,
            absolute_expiry: req.absolute_expiry,
            single_use: Some(false),
            issuer: None,
            label: None,
            recurrence: None,
            recurrence_base: None,
            recurrence_paywindow: None,
            recurrence_limit: None,
        })
        .await?
        .into_inner();
         
        Ok(offer.bolt12)
    }
}

#[derive(Clone, PartialEq, Eq, Debug, EnumString, Display, Deserialize, Serialize)]
enum NodeCommand {
    #[strum(serialize = "closeallchannels")]
    CloseAllChannels,

    #[strum(serialize = "getinfo")]
    GetInfo,

    #[strum(serialize = "listfunds")]
    ListFunds,

    #[strum(serialize = "listinvoices")]
    ListInvoices,

    #[strum(serialize = "listpayments")]
    ListPayments,

    #[strum(serialize = "listpeers")]
    ListPeers,

    #[strum(serialize = "listpeerchannels")]
    ListPeerChannels,
}

// pulls transactions from greenlight based on last sync timestamp.
// greenlight gives us the payments via API and for received payments we are looking for settled invoices.
async fn pull_transactions(
    since_timestamp: u64,
    client: node::ClnClient,
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
    debug!("list payments: {:?}", payments);
    // construct the payment transactions (pending and complete)
    let outbound_transactions: NodeResult<Vec<Payment>> = payments
        .pays
        .into_iter()
        .filter(|p| p.created_at > since_timestamp)
        .map(TryInto::try_into)
        .collect();

    let mut transactions: Vec<Payment> = Vec::new();
    transactions.extend(received_transactions?);
    transactions.extend(outbound_transactions?);

    Ok(transactions)
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
                    lnurl_metadata: None,       // For received payments, this is None
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                },
            },
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
                    lnurl_metadata: None,       // For received payments, this is None
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                },
            },
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
                    lnurl_metadata: None,
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                },
            },
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
            .ok_or(InvoiceError::Generic(anyhow!("No bolt11 invoice")))
            .and_then(|b| parse_invoice(b))?;
        Ok(Payment {
            id: hex::encode(invoice.payment_hash.clone()),
            payment_type: PaymentType::Received,
            payment_time: invoice.paid_at.map(|i| i as i64).unwrap_or_default(),
            amount_msat: invoice.amount_msat.map(|a| a.msat).unwrap_or_default(),
            fee_msat: 0,
            status: PaymentStatus::Complete,
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
                    lnurl_metadata: None,       // For received payments, this is None
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                },
            },
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
            .ok_or(InvoiceError::Generic(anyhow!("No bolt11 invoice")))
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
                PaymentStatus::Failed => ln_invoice
                    .as_ref()
                    .map_or(0, |i| i.amount_msat.unwrap_or_default()),
                _ => payment_amount,
            },
            fee_msat: payment_amount_sent - payment_amount,
            status,
            description: ln_invoice.map(|i| i.description).unwrap_or_default(),
            details: PaymentDetails::Ln {
                data: LnPaymentDetails {
                    payment_hash: hex::encode(payment.payment_hash),
                    label: "".to_string(),
                    destination_pubkey: payment.destination.map(hex::encode).unwrap_or_default(),
                    payment_preimage: payment.preimage.map(hex::encode).unwrap_or_default(),
                    keysend: payment.bolt11.is_none(),
                    bolt11: payment.bolt11.unwrap_or_default(),
                    lnurl_success_action: None,
                    lnurl_metadata: None,
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                },
            },
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
            short_channel_id: c.short_channel_id.unwrap_or_default(),
            state,
            funding_txid: c.funding_txid.map(hex::encode).unwrap_or_default(),
            spendable_msat: c.spendable_msat.unwrap_or_default().msat,
            receivable_msat: c.receivable_msat.unwrap_or_default().msat,
            closed_at: None,
            funding_outnum: c.funding_outnum,
            alias_remote,
            alias_local,
            closing_txid: None,
        }
    }
}

/// Conversion for a closed channel
impl TryFrom<cln::ListclosedchannelsClosedchannels> for Channel {
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
        Ok(Channel {
            short_channel_id: c
                .short_channel_id
                .ok_or(anyhow!("short_channel_id is missing"))?,
            state: ChannelState::Closed,
            funding_txid: hex::encode(c.funding_txid),
            spendable_msat: c
                .final_to_us_msat
                .ok_or(anyhow!("final_to_us_msat is missing"))?
                .msat,
            receivable_msat: 0,
            closed_at: None,
            funding_outnum: Some(c.funding_outnum),
            alias_remote,
            alias_local,
            closing_txid: None,
        })
    }
}

impl From<FetchInvoiceRequest> for gl_client::pb::cln::FetchinvoiceRequest {
    fn from(request: FetchInvoiceRequest) -> Self {
        cln::FetchinvoiceRequest {
            offer: request.offer,
            amount_msat: request.amount_msat.map(|msat| cln::Amount { msat }),
            timeout: request.timeout,
            payer_note: request.payer_note,
            // Not yet implemented
            quantity: None,
            recurrence_counter: None,
            recurrence_start: None,
            recurrence_label: None,
        }
    }
}

#[cfg(test)]
mod tests {
    use anyhow::Result;
    use gl_client::pb::cln;
    use gl_client::pb::cln::listpeers_peers_channels::{
        ListpeersPeersChannelsState, ListpeersPeersChannelsState::*,
    };
    use gl_client::pb::cln::Amount;

    use crate::models;

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
