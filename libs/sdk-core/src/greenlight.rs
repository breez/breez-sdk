use crate::invoice::parse_invoice;
use crate::models::{
    Config, GreenlightCredentials, LnPaymentDetails, Network, NodeAPI, NodeState, PaymentDetails,
    PaymentType, SyncResponse, UnspentTransactionOutput,
};

use anyhow::{anyhow, Result};
use bitcoin::bech32::{u5, ToBase32};
use bitcoin::secp256k1::ecdsa::{RecoverableSignature, RecoveryId};
use gl_client::pb::amount::Unit;

use gl_client::pb::{
    Amount, CloseChannelRequest, CloseChannelResponse, Invoice, InvoiceRequest, InvoiceStatus,
    OffChainPayment, PayStatus, WithdrawResponse,
};
use gl_client::scheduler::Scheduler;
use gl_client::signer::Signer;
use gl_client::tls::TlsConfig;
use gl_client::{node, pb};

use bitcoin::secp256k1::Secp256k1;
use bitcoin::util::bip32::{ChildNumber, ExtendedPrivKey};
use gl_client::pb::Peer;
use lightning_invoice::{RawInvoice, SignedRawInvoice};
use serde::{Deserialize, Serialize};
use std::cmp::{max, min};
use std::str::FromStr;
use std::time::{SystemTime, UNIX_EPOCH};
use strum_macros::{Display, EnumString};
use tokio::sync::{mpsc, Mutex};
use tonic::Streaming;

const MAX_PAYMENT_AMOUNT_MSAT: u64 = 4294967000;
const MAX_INBOUND_LIQUIDITY_MSAT: u64 = 4000000000;

pub(crate) struct Greenlight {
    sdk_config: Config,
    tls_config: TlsConfig,
    signer: Signer,
    scheduler: Mutex<Option<Scheduler>>,
}

impl Greenlight {
    pub(crate) async fn new(
        sdk_config: Config,
        seed: Vec<u8>,
        creds: GreenlightCredentials,
    ) -> Result<Greenlight> {
        let greenlight_network = sdk_config.network.into();
        let tls_config = TlsConfig::new()?.identity(creds.device_cert, creds.device_key);
        let signer = Signer::new(seed, greenlight_network, tls_config.clone())?;
        Ok(Greenlight {
            sdk_config,
            tls_config,
            signer,
            scheduler: Mutex::new(None),
        })
    }

    pub(crate) async fn register(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
        let greenlight_network = network.into();
        let tls_config = TlsConfig::new()?;
        let signer = Signer::new(seed, greenlight_network, tls_config.clone())?;
        let scheduler = Scheduler::new(signer.node_id(), greenlight_network).await?;
        let recover_res: pb::scheduler::RegistrationResponse =
            scheduler.register(&signer, None).await?;

        Ok(GreenlightCredentials {
            device_key: recover_res.device_key.into(),
            device_cert: recover_res.device_cert.into(),
        })
    }

    pub(crate) async fn recover(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
        let greenlight_network = network.into();
        let tls_config = TlsConfig::new()?;
        let signer = Signer::new(seed, greenlight_network, tls_config.clone())?;
        let scheduler = Scheduler::new(signer.node_id(), greenlight_network).await?;
        let recover_res: pb::scheduler::RecoveryResponse = scheduler.recover(&signer).await?;

        Ok(GreenlightCredentials {
            device_key: recover_res.device_key.as_bytes().to_vec(),
            device_cert: recover_res.device_cert.as_bytes().to_vec(),
        })
    }

    async fn get_client(&self) -> Result<node::Client> {
        let client: node::Client = self
            .scheduler()
            .await?
            .schedule(self.tls_config.clone())
            .await?;
        Ok(client)
    }

    async fn scheduler(&self) -> Result<Scheduler> {
        let mut existing = self.scheduler.lock().await;
        if existing.is_none() {
            let scheduler =
                Scheduler::new(self.signer.node_id(), self.sdk_config.network.into()).await?;
            *existing = Some(scheduler);
        }
        Ok(existing.as_ref().unwrap().clone())
    }
}

#[tonic::async_trait]
impl NodeAPI for Greenlight {
    async fn start(&self) -> Result<()> {
        self.get_client().await?;
        Ok(())
    }

    async fn start_signer(&self, shutdown: mpsc::Receiver<()>) {
        _ = self.signer.run_forever(shutdown).await;
        error!("signer exited");
    }

    async fn stream_incoming_payments(&self) -> Result<Streaming<gl_client::pb::IncomingPayment>> {
        let mut client = self.get_client().await?;
        let stream = client
            .stream_incoming(gl_client::pb::StreamIncomingFilter {})
            .await?
            .into_inner();
        Ok(stream)
    }

    async fn stream_log_messages(&self) -> Result<Streaming<gl_client::pb::LogEntry>> {
        let mut client = self.get_client().await?;
        let stream = client
            .stream_log(gl_client::pb::StreamLogRequest {})
            .await?
            .into_inner();
        Ok(stream)
    }

    fn sign_invoice(&self, invoice: RawInvoice) -> Result<String> {
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
        let recoverable_sig =
            RecoverableSignature::from_compact(sig, rid).map_err(|e| anyhow!(e))?;

        let signed_invoice: Result<SignedRawInvoice> = invoice.sign(|_| Ok(recoverable_sig));
        Ok(signed_invoice?.to_string())
    }

    async fn connect_peer(&self, node_id: String, addr: String) -> Result<()> {
        let mut client = self.get_client().await?;
        let connect_req = pb::ConnectRequest { node_id, addr };
        client.connect_peer(connect_req).await?;
        Ok(())
    }

    // implemenet pull changes from greenlight
    async fn pull_changed(&self, since_timestamp: i64) -> Result<SyncResponse> {
        let mut client = self.get_client().await?;

        // list all peers
        let peers = client
            .list_peers(pb::ListPeersRequest::default())
            .await?
            .into_inner();

        // get node info
        let node_info = client
            .get_info(pb::GetInfoRequest::default())
            .await?
            .into_inner();

        // list both off chain funds and on chain fudns
        let funds = client
            .list_funds(pb::ListFundsRequest::default())
            .await?
            .into_inner();
        let offchain_funds = funds.channels;
        let onchain_funds = funds.outputs;

        // filter only connected peers
        let connected_peers: Vec<String> = peers
            .peers
            .clone()
            .iter()
            .filter(|p| p.connected)
            .map(|p| hex::encode(p.id.clone()))
            .collect();

        // make a vector of all channels by searching in peers
        let all_channels: &mut Vec<pb::Channel> = &mut Vec::new();
        peers.peers.clone().iter().for_each(|p| {
            let peer_channels = &mut p.channels.clone();
            all_channels.append(peer_channels);
        });

        // filter only opened channels
        let opened_channels: &mut Vec<&pb::Channel> = &mut all_channels
            .iter()
            .filter(|c| c.state == *"CHANNELD_NORMAL")
            .collect();

        // calculate channels balance only from opened channels
        let channels_balance = offchain_funds.iter().fold(0, |a, b| {
            let hex_txid = hex::encode(b.funding_txid.clone());
            if opened_channels.iter().any(|c| c.funding_txid == hex_txid) {
                return a + b.our_amount_msat;
            }
            a
        });

        // calculate onchain balance
        let onchain_balance = onchain_funds.iter().fold(0, |a, b| {
            if b.reserved {
                return a;
            }
            a + amount_to_msat(&b.amount.clone().unwrap_or_default())
        });

        // Collect utxos from onchain funds
        let utxos = onchain_funds
            .iter()
            .filter_map(|list_funds_output| {
                list_funds_output
                    .output
                    .as_ref()
                    .map(|output| UnspentTransactionOutput {
                        txid: output.txid.clone(),
                        outnum: output.outnum,
                        amount_millisatoshi: list_funds_output
                            .amount
                            .as_ref()
                            .map(amount_to_msat)
                            .unwrap_or_default(),
                        address: list_funds_output.address.clone(),
                        reserved: list_funds_output.reserved,
                        reserved_to_block: list_funds_output.reserved_to_block,
                    })
            })
            .collect();

        // calculate payment limits and inbound liquidity
        let mut max_payable: u64 = 0;
        let mut max_receivable_single_channel: u64 = 0;
        opened_channels.iter().try_for_each(|c| -> Result<()> {
            max_payable += amount_to_msat(&parse_amount(c.spendable.clone())?);
            let receivable_amount = amount_to_msat(&parse_amount(c.receivable.clone())?);
            if receivable_amount > max_receivable_single_channel {
                max_receivable_single_channel = receivable_amount;
            }
            Ok(())
        })?;

        let max_allowed_to_receive_msats = max(MAX_INBOUND_LIQUIDITY_MSAT - channels_balance, 0);
        let node_pubkey = hex::encode(node_info.node_id);

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
            payments: pull_transactions(since_timestamp, client.clone()).await?,
            channels: all_channels.clone().into_iter().map(|c| c.into()).collect(),
        })
    }

    async fn list_peers(&self) -> Result<Vec<Peer>> {
        let mut client = self.get_client().await?;
        Ok(client
            .list_peers(pb::ListPeersRequest::default())
            .await?
            .into_inner()
            .peers)
    }

    async fn create_invoice(
        &self,
        amount_sats: u64,
        description: String,
        preimage: Option<Vec<u8>>,
    ) -> Result<Invoice> {
        let mut client = self.get_client().await?;

        let request = InvoiceRequest {
            amount: Some(Amount {
                unit: Some(Unit::Satoshi(amount_sats)),
            }),
            label: format!(
                "breez-{}",
                SystemTime::now().duration_since(UNIX_EPOCH)?.as_millis()
            ),
            description,
            preimage: preimage.unwrap_or_default(),
        };

        Ok(client.create_invoice(request).await?.into_inner())
    }

    async fn send_payment(
        &self,
        bolt11: String,
        amount_sats: Option<u64>,
    ) -> Result<crate::models::Payment> {
        let mut client = self.get_client().await?;

        let request = pb::PayRequest {
            amount: amount_sats
                .map(Unit::Satoshi)
                .map(Some)
                .map(|amt| Amount { unit: amt }),
            bolt11,
            timeout: self.sdk_config.payment_timeout_sec,
            maxfee: self
                .sdk_config
                .maxfee_sat
                .map(Unit::Satoshi)
                .map(Some)
                .map(|amt| Amount { unit: amt }),
            maxfeepercent: self.sdk_config.maxfeepercent,
        };
        client.pay(request).await?.into_inner().try_into()
    }

    async fn send_spontaneous_payment(
        &self,
        node_id: String,
        amount_sats: u64,
    ) -> Result<crate::models::Payment> {
        let mut client = self.get_client().await?;

        let request = pb::KeysendRequest {
            node_id: hex::decode(node_id)?,
            amount: Some(Amount {
                unit: Some(Unit::Satoshi(amount_sats)),
            }),
            label: format!(
                "breez-{}",
                SystemTime::now().duration_since(UNIX_EPOCH)?.as_millis()
            ),
            extratlvs: vec![],
            routehints: vec![],
        };
        client.keysend(request).await?.into_inner().try_into()
    }

    async fn close_peer_channels(&self, node_id: String) -> Result<CloseChannelResponse> {
        let mut client = self.get_client().await?;

        let request = CloseChannelRequest {
            node_id: hex::decode(node_id)?,
            destination: None,
            unilateraltimeout: None,
        };
        Ok(client.close_channel(request).await?.into_inner())
    }

    async fn sweep(
        &self,
        to_address: String,
        fee_rate_sats_per_byte: u64,
    ) -> Result<WithdrawResponse> {
        let mut client = self.get_client().await?;

        let request = pb::WithdrawRequest {
            feerate: Some(pb::Feerate {
                value: Some(pb::feerate::Value::Perkb(fee_rate_sats_per_byte * 1000)),
            }),
            amount: Some(Amount {
                unit: Some(Unit::All(true)),
            }),
            destination: to_address,
            minconf: None,
            utxos: vec![],
        };

        Ok(client.withdraw(request).await?.into_inner())
    }

    async fn execute_command(&self, command: String) -> Result<String> {
        let node_cmd = NodeCommand::from_str(&command)
            .map_err(|_| anyhow!(format!("command not found: {command}")))?;
        match node_cmd {
            NodeCommand::ListPeers => {
                let resp = self
                    .get_client()
                    .await?
                    .list_peers(pb::ListPeersRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::ListFunds => {
                let resp = self
                    .get_client()
                    .await?
                    .list_funds(pb::ListFundsRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::ListPayments => {
                let resp = self
                    .get_client()
                    .await?
                    .list_payments(pb::ListPaymentsRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::ListInvoices => {
                let resp = self
                    .get_client()
                    .await?
                    .list_invoices(pb::ListInvoicesRequest::default())
                    .await?
                    .into_inner();
                Ok(format!("{resp:?}"))
            }
            NodeCommand::CloseAllChannels => {
                let peers_res = self
                    .get_client()
                    .await?
                    .list_peers(pb::ListPeersRequest::default())
                    .await?
                    .into_inner();
                for p in peers_res.peers {
                    self.close_peer_channels(hex::encode(p.id)).await?;
                }

                Ok("All channels were closed".to_string())
            }
        }
    }

    fn derive_bip32_key(&self, path: Vec<ChildNumber>) -> Result<ExtendedPrivKey> {
        ExtendedPrivKey::new_master(self.sdk_config.network.into(), &self.signer.bip32_ext_key())?
            .derive_priv(&Secp256k1::new(), &path)
            .map_err(|e| anyhow!(e))
    }
}

#[derive(Clone, PartialEq, Eq, Debug, EnumString, Display, Deserialize, Serialize)]
enum NodeCommand {
    #[strum(serialize = "listpeers")]
    ListPeers,

    #[strum(serialize = "listfunds")]
    ListFunds,

    #[strum(serialize = "listpayments")]
    ListPayments,

    #[strum(serialize = "listinvoices")]
    ListInvoices,

    #[strum(serialize = "closeallchannels")]
    CloseAllChannels,
}

// pulls transactions from greenlight based on last sync timestamp.
// greenlight gives us the payments via API and for received payments we are looking for settled invoices.
async fn pull_transactions(
    since_timestamp: i64,
    client: node::Client,
) -> Result<Vec<crate::models::Payment>> {
    let mut c = client.clone();

    // list invoices
    let invoices = c
        .list_invoices(pb::ListInvoicesRequest::default())
        .await?
        .into_inner();

    // construct the received transactions by filtering the invoices to those paid and beyond the filter timestamp
    let received_transations: Result<Vec<crate::models::Payment>> = invoices
        .invoices
        .into_iter()
        .filter(|i| {
            i.payment_time > 0
                && i.status() == InvoiceStatus::Paid
                && i.payment_time as i64 > since_timestamp
        })
        .map(TryInto::try_into)
        .collect();

    // fetch payments from greenlight
    let payments = c
        .list_payments(pb::ListPaymentsRequest::default())
        .await?
        .into_inner();
    debug!("list payments: {:?}", payments);
    // construct the payment transactions
    let sent_transactions: Result<Vec<crate::models::Payment>> = payments
        .payments
        .into_iter()
        .filter(|p| p.created_at as i64 > since_timestamp && p.status() == PayStatus::Complete)
        .map(TryInto::try_into)
        .collect();

    let mut transactions: Vec<crate::models::Payment> = Vec::new();
    transactions.extend(received_transations?);
    transactions.extend(sent_transactions?);

    Ok(transactions)
}

//pub(crate) fn offchain_payment_to_transaction
impl TryFrom<OffChainPayment> for crate::models::Payment {
    type Error = anyhow::Error;

    fn try_from(p: OffChainPayment) -> std::result::Result<Self, Self::Error> {
        let ln_invoice = parse_invoice(&p.bolt11)?;
        Ok(crate::models::Payment {
            id: hex::encode(p.payment_hash.clone()),
            payment_type: PaymentType::Received,
            payment_time: SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs() as i64,
            amount_msat: amount_to_msat(&p.amount.unwrap_or_default()),
            fee_msat: 0,
            pending: false,
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
                },
            },
        })
    }
    // fn from(p: OffChainPayment) -> Self {

    //}
}

/// Construct a lightning transaction from an invoice
impl TryFrom<pb::Invoice> for crate::models::Payment {
    type Error = anyhow::Error;

    fn try_from(invoice: pb::Invoice) -> std::result::Result<Self, Self::Error> {
        let ln_invoice = parse_invoice(&invoice.bolt11)?;
        Ok(crate::models::Payment {
            id: hex::encode(invoice.payment_hash.clone()),
            payment_type: PaymentType::Received,
            payment_time: invoice.payment_time as i64,
            amount_msat: amount_to_msat(&invoice.amount.unwrap_or_default()),
            fee_msat: 0,
            pending: false,
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
                },
            },
        })
    }
}

impl TryFrom<pb::Payment> for crate::models::Payment {
    type Error = anyhow::Error;

    fn try_from(payment: pb::Payment) -> std::result::Result<Self, Self::Error> {
        let mut description = None;
        if !payment.bolt11.is_empty() {
            description = parse_invoice(&payment.bolt11)?.description;
        }

        let payment_amount = amount_to_msat(&payment.amount.unwrap_or_default());
        let payment_amount_sent = amount_to_msat(&payment.amount_sent.unwrap_or_default());

        Ok(crate::models::Payment {
            id: hex::encode(payment.payment_hash.clone()),
            payment_type: PaymentType::Sent,
            payment_time: payment.created_at as i64,
            amount_msat: payment_amount,
            fee_msat: payment_amount_sent - payment_amount,
            pending: pb::PayStatus::from_i32(payment.status) == Some(pb::PayStatus::Pending),
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
                },
            },
        })
    }
}

fn amount_to_msat(amount: &pb::Amount) -> u64 {
    match amount.unit {
        Some(pb::amount::Unit::Millisatoshi(val)) => val,
        Some(pb::amount::Unit::Satoshi(val)) => val * 1000,
        Some(pb::amount::Unit::Bitcoin(val)) => val * 100000000,
        Some(_) => 0,
        None => 0,
    }
}

fn parse_amount(amount_str: String) -> Result<pb::Amount> {
    let mut unit = pb::amount::Unit::Millisatoshi(0);
    if amount_str.ends_with("msat") {
        unit = pb::amount::Unit::Millisatoshi(
            amount_str
                .strip_suffix("msat")
                .ok_or_else(|| anyhow!("wrong amount format {}", amount_str))?
                .to_string()
                .parse::<u64>()?,
        );
    } else if amount_str.ends_with("sat") {
        unit = pb::amount::Unit::Satoshi(
            amount_str
                .strip_suffix("sat")
                .ok_or_else(|| anyhow!("wrong amount format {}", amount_str))?
                .to_string()
                .parse::<u64>()?,
        );
    } else if amount_str.ends_with("bitcoin") {
        unit = pb::amount::Unit::Bitcoin(
            amount_str
                .strip_suffix("bitcoin")
                .ok_or_else(|| anyhow!("wrong amount format {}", amount_str))?
                .to_string()
                .parse::<u64>()?,
        );
    };

    Ok(pb::Amount { unit: Some(unit) })
}

impl From<pb::Channel> for crate::models::Channel {
    fn from(c: pb::Channel) -> Self {
        let state = match c.state.as_str() {
            "OPENINGD" | "CHANNELD_AWAITING_LOCKIN" => crate::models::ChannelState::PendingOpen,
            "CHANNELD_NORMAL" => crate::models::ChannelState::Opened,
            "CLOSED" => crate::models::ChannelState::Closed,
            _ => crate::models::ChannelState::PendingClose,
        };

        crate::models::Channel {
            short_channel_id: c.short_channel_id,
            state,
            funding_txid: c.funding_txid,
            spendable_msat: amount_to_msat(&parse_amount(c.spendable).unwrap_or_default()),
            receivable_msat: amount_to_msat(&parse_amount(c.receivable).unwrap_or_default()),
            closed_at: None,
        }
    }
}

#[cfg(test)]
mod tests {
    use crate::models;
    use anyhow::Result;
    use gl_client::pb;

    #[test]
    fn test_channel_states() -> Result<()> {
        for s in &["OPENINGD", "CHANNELD_AWAITING_LOCKIN"] {
            let c: models::Channel = gl_channel(s).into();
            assert_eq!(c.state, models::ChannelState::PendingOpen);
        }

        let s = &"CHANNELD_NORMAL";
        let c: models::Channel = gl_channel(s).into();
        assert_eq!(c.state, models::ChannelState::Opened);

        for s in &[
            "CHANNELD_SHUTTING_DOWN",
            "CLOSINGD_SIGEXCHANGE",
            "CLOSINGD_COMPLETE",
            "AWAITING_UNILATERAL",
            "FUNDING_SPEND_SEEN",
            "ONCHAIN",
        ] {
            let c: models::Channel = gl_channel(s).into();
            assert_eq!(c.state, models::ChannelState::PendingClose);
        }

        let s = &"CLOSED";
        let c: models::Channel = gl_channel(s).into();
        assert_eq!(c.state, models::ChannelState::Closed);

        Ok(())
        //let c =
    }

    fn gl_channel(state: &str) -> pb::Channel {
        pb::Channel {
            state: state.to_string(),
            owner: "".to_string(),
            short_channel_id: "".to_string(),
            direction: 0,
            channel_id: "".to_string(),
            funding_txid: "".to_string(),
            close_to_addr: "".to_string(),
            close_to: "".to_string(),
            private: true,
            total: "1000msat".to_string(),
            dust_limit: "10msat".to_string(),
            spendable: "20msat".to_string(),
            receivable: "960msat".to_string(),
            their_to_self_delay: 144,
            our_to_self_delay: 144,
            status: vec![],
            alias: None,
            htlcs: vec![],
        }
    }
}
