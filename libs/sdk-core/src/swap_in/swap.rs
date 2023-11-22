use std::str::FromStr;
use std::sync::Arc;

use crate::binding::parse_invoice;
use crate::chain::{get_utxos, AddressUtxos, ChainService, MempoolSpace, OnchainTx};
use crate::grpc::{AddFundInitRequest, GetSwapPaymentRequest};
use crate::swap_in::error::SwapError;
use crate::{
    OpeningFeeParams, PrepareRefundRequest, PrepareRefundResponse, ReceivePaymentRequest,
    RefundRequest, RefundResponse, SWAP_PAYMENT_FEE_EXPIRY_SECONDS,
};
use anyhow::{anyhow, Result};
use bitcoin::blockdata::constants::WITNESS_SCALE_FACTOR;
use bitcoin::blockdata::opcodes;
use bitcoin::blockdata::script::Builder;
use bitcoin::consensus::encode;
use bitcoin::psbt::serialize::Serialize;
use bitcoin::secp256k1::{Message, PublicKey, Secp256k1, SecretKey};
use bitcoin::{Address, EcdsaSighashType, Script, Sequence, Transaction, TxIn, TxOut, Witness};

use bitcoin::hashes::sha256;
use bitcoin::util::sighash::SighashCache;
use rand::Rng;
use ripemd::{Digest, Ripemd160};

use crate::breez_services::{BreezEvent, BreezServer, PaymentReceiver, Receiver};
use crate::models::{Swap, SwapInfo, SwapStatus, SwapperAPI};

use super::error::SwapResult;

#[tonic::async_trait]
impl SwapperAPI for BreezServer {
    async fn create_swap(
        &self,
        hash: Vec<u8>,
        payer_pubkey: Vec<u8>,
        node_id: String,
    ) -> SwapResult<Swap> {
        let mut fund_client = self.get_fund_manager_client().await?;
        let req = AddFundInitRequest {
            hash: hash.clone(),
            pubkey: payer_pubkey.clone(),
            node_id,
            notification_token: "".to_string(),
        };

        let result = fund_client.add_fund_init(req).await?.into_inner();
        Ok(Swap {
            bitcoin_address: result.address,
            swapper_pubkey: result.pubkey,
            lock_height: result.lock_height,
            max_allowed_deposit: result.max_allowed_deposit,
            error_message: result.error_message,
            required_reserve: result.required_reserve,
            min_allowed_deposit: result.min_allowed_deposit,
        })
    }

    async fn complete_swap(&self, bolt11: String) -> Result<()> {
        let req = GetSwapPaymentRequest {
            payment_request: bolt11,
        };
        self.get_fund_manager_client()
            .await?
            .get_swap_payment(req)
            .await?
            .into_inner();
        Ok(())
    }
}

/// This struct is responsible for handling on-chain funds with lightning payments.
/// It uses internally an implementation of SwapperAPI that represents the actually swapper service.
pub(crate) struct BTCReceiveSwap {
    network: bitcoin::Network,
    swapper_api: Arc<dyn SwapperAPI>,
    persister: Arc<crate::persist::db::SqliteStorage>,
    chain_service: Arc<dyn ChainService>,
    payment_receiver: Arc<dyn Receiver>,
}

impl BTCReceiveSwap {
    pub(crate) fn new(
        network: bitcoin::Network,
        swapper_api: Arc<dyn SwapperAPI>,
        persister: Arc<crate::persist::db::SqliteStorage>,
        chain_service: Arc<MempoolSpace>,
        payment_receiver: Arc<PaymentReceiver>,
    ) -> Self {
        Self {
            network,
            swapper_api,
            persister,
            chain_service,
            payment_receiver,
        }
    }

    /// Listening to events is required in order to:
    /// * Refresh on-chain status of swap addresses.
    /// * Refresh lighting status of swap addresses, e.g lookup for corresponding lightning payment
    /// * Redeem funds related to swap addresses, e.g when on chain funds are discovered use the SwapperAPI to
    ///   req payment by passing bolt11 invoice.
    pub(crate) async fn on_event(&self, e: BreezEvent) -> Result<()> {
        match e {
            BreezEvent::NewBlock { block: tip } => {
                debug!("got chain event {:?}", e);
                _ = self.execute_pending_swaps(tip).await;
            }

            // When invoice is paid we lookup for a swap that matches the same hash.
            // In case we find one, we update its paid amount.
            BreezEvent::InvoicePaid { details } => {
                debug!("swap InvoicePaid event!");
                let hash_raw = hex::decode(details.payment_hash.clone())?;
                let swap_info = self.persister.get_swap_info_by_hash(&hash_raw)?;
                if swap_info.is_some() {
                    let payment = self
                        .persister
                        .get_completed_payment_by_hash(&details.payment_hash)?;
                    if payment.is_some() {
                        self.persister.update_swap_paid_amount(
                            swap_info.unwrap().bitcoin_address,
                            payment.unwrap().amount_msat as u32,
                        )?;
                    }
                }
            }
            _ => {} // skip events were are not interested in
        }

        Ok(())
    }

    /// Create a [SwapInfo] that represents the details of an on-going swap.
    ///
    /// See [SwapInfo] for details.
    pub(crate) async fn create_swap_address(
        &self,
        channel_opening_fees: OpeningFeeParams,
    ) -> SwapResult<SwapInfo> {
        let node_state = self
            .persister
            .get_node_state()?
            .ok_or(anyhow!("Node info not found"))?;

        // check first that we don't have any swap in progress waiting for redeem.
        if let Some(in_progress_swap) = self.list_unused()?.first().cloned() {
            info!("Found unused swap when trying to create new swap address");

            self.persister.update_swap_fees(
                in_progress_swap.bitcoin_address.clone(),
                channel_opening_fees,
            )?;
            return Ok(in_progress_swap);
        }

        // create swap keys
        let swap_keys = create_swap_keys()?;
        let pubkey = swap_keys.public_key_bytes()?;
        let hash = swap_keys.preimage_hash_bytes();

        // use swap API to fetch a new swap address
        let swap_reply = self
            .swapper_api
            .create_swap(hash.clone(), pubkey.clone(), node_state.id)
            .await?;

        // calculate the submarine swap script
        let our_script = create_submarine_swap_script(
            hash.clone(),
            swap_reply.swapper_pubkey.clone(),
            pubkey.clone(),
            swap_reply.lock_height,
        )?;

        let address = Address::p2wsh(&our_script, self.network);
        let address_str = address.to_string();

        // Ensure our address generation match the service
        if address_str != swap_reply.bitcoin_address {
            return Err(SwapError::Generic(anyhow!("Wrong address: {address_str}")));
        }

        let swap_info = SwapInfo {
            bitcoin_address: swap_reply.bitcoin_address,
            created_at: 0,
            lock_height: swap_reply.lock_height,
            payment_hash: hash.clone(),
            preimage: swap_keys.preimage,
            private_key: swap_keys.priv_key.to_vec(),
            public_key: pubkey.clone(),
            swapper_public_key: swap_reply.swapper_pubkey.clone(),
            script: our_script.as_bytes().to_vec(),
            bolt11: None,
            paid_sats: 0,
            unconfirmed_sats: 0,
            confirmed_sats: 0,
            refund_tx_ids: Vec::new(),
            confirmed_tx_ids: Vec::new(),
            unconfirmed_tx_ids: Vec::new(),
            status: SwapStatus::Initial,
            min_allowed_deposit: swap_reply.min_allowed_deposit,
            max_allowed_deposit: swap_reply.max_allowed_deposit,
            last_redeem_error: None,
            channel_opening_fees: Some(channel_opening_fees),
        };

        // persist the address
        self.persister.insert_swap(swap_info.clone())?;
        Ok(swap_info)

        // return swap.bitcoinAddress;
    }

    fn list_unused(&self) -> Result<Vec<SwapInfo>> {
        Ok(self
            .persister
            .list_swaps_with_status(SwapStatus::Initial)?
            .into_iter()
            .filter(SwapInfo::unused)
            .collect())
    }

    pub(crate) async fn list_in_progress(&self) -> Result<Vec<SwapInfo>> {
        Ok(self
            .persister
            .list_swaps_with_status(SwapStatus::Initial)?
            .into_iter()
            .filter(SwapInfo::in_progress)
            .collect())
    }

    pub fn list_monitored(&self) -> Result<Vec<SwapInfo>> {
        Ok(self
            .persister
            .list_swaps()?
            .into_iter()
            .filter(SwapInfo::monitored)
            .collect())
    }

    pub(crate) fn list_refundables(&self) -> Result<Vec<SwapInfo>> {
        Ok(self
            .persister
            .list_swaps_with_status(SwapStatus::Expired)?
            .into_iter()
            .filter(SwapInfo::refundable)
            .collect())
    }

    #[allow(dead_code)]
    pub(crate) fn list_redeemables(&self) -> Result<Vec<SwapInfo>> {
        Ok(self
            .persister
            .list_swaps_with_status(SwapStatus::Initial)?
            .into_iter()
            .filter(SwapInfo::redeemable)
            .collect())
    }

    pub(crate) fn get_swap_info(&self, address: String) -> Result<Option<SwapInfo>> {
        Ok(self.persister.get_swap_info_by_address(address)?)
    }

    fn get_swap_info_ok(&self, address: String) -> Result<SwapInfo> {
        self.get_swap_info(address.clone())?
            .ok_or_else(|| anyhow!(format!("Swap address {} was not found", address)))
    }

    pub(crate) async fn execute_pending_swaps(&self, tip: u32) -> Result<()> {
        // first refresh all swaps we monitor
        _ = self.refresh_monitored_swaps(tip).await?;

        // redeem swaps
        let redeemable_swaps = self.list_redeemables()?;
        for s in redeemable_swaps {
            let redeem_res = self.redeem_swap(s.bitcoin_address.clone()).await;

            if redeem_res.is_err() {
                let err = redeem_res.as_ref().err().unwrap();
                error!(
                    "failed to redeem swap {:?}: {} {}",
                    err,
                    s.bitcoin_address,
                    s.bolt11.unwrap_or_default(),
                );
                self.persister
                    .update_swap_redeem_error(s.bitcoin_address, err.to_string())?;
            } else {
                info!(
                    "succeed to redeem swap {:?}: {}",
                    s.bitcoin_address,
                    s.bolt11.unwrap_or_default()
                )
            }
        }

        Ok(())
    }

    async fn refresh_monitored_swaps(&self, tip: u32) -> Result<Vec<SwapInfo>> {
        let to_check = self.list_monitored()?;
        for s in to_check {
            let address = s.bitcoin_address.clone();
            let result = self
                .refresh_swap_on_chain_status(address.clone(), tip)
                .await;
            if result.is_err() {
                error!(
                    "failed to refresh swap status for address {} {}",
                    address.clone(),
                    result.err().unwrap()
                )
            }
        }
        self.list_monitored()
    }

    /// refreshes the on-chain status of the swap. This method updates the following information
    /// on a SwapInfo and save it to the persistent storage:
    /// confirmed_sats - the number of unspent satoshis that were sent to this address
    /// confirmed_txs - all utxo that are sent to this address
    /// swap_status - Either Initial or Expired.
    pub(crate) async fn refresh_swap_on_chain_status(
        &self,
        bitcoin_address: String,
        current_tip: u32,
    ) -> Result<SwapInfo> {
        let swap_info = self
            .persister
            .get_swap_info_by_address(bitcoin_address.clone())?
            .ok_or_else(|| {
                anyhow!(format!(
                    "swap address {} was not found",
                    bitcoin_address.clone()
                ))
            })?;
        let txs = self
            .chain_service
            .address_transactions(bitcoin_address.clone())
            .await?;
        let confirmed_txs: Vec<OnchainTx> = txs
            .clone()
            .into_iter()
            .filter(|t| t.status.block_height.is_some())
            .collect();
        let utxos = get_utxos(bitcoin_address.clone(), txs)?;
        let confirmed_block = confirmed_txs.iter().fold(0, |b, item| {
            let confirmed_block = item.status.block_height.unwrap();
            if confirmed_block != 0 || confirmed_block < b {
                confirmed_block
            } else {
                b
            }
        });

        let mut swap_status = swap_info.status.clone();
        if !confirmed_txs.is_empty()
            && current_tip - confirmed_block >= swap_info.lock_height as u32
        {
            swap_status = SwapStatus::Expired
        }

        debug!(
            "updating swap on-chain info {:?}: confirmed_sats={:?} refund_tx_ids={:?}, confirmed_tx_ids={:?} swap_status={:?}",
            bitcoin_address.clone(), utxos.confirmed_sats(), swap_info.refund_tx_ids, utxos.confirmed_tx_ids(), swap_status
        );

        let payment = self
            .persister
            .get_completed_payment_by_hash(&hex::encode(swap_info.payment_hash.clone()))?;
        if payment.is_some() {
            debug!(
                "found payment for hash {:?}, {:?}",
                &hex::encode(swap_info.payment_hash.clone()),
                payment
            );
            self.persister.update_swap_paid_amount(
                bitcoin_address.clone(),
                payment.unwrap().amount_msat as u32,
            )?;
        }

        Ok(self.persister.update_swap_chain_info(
            bitcoin_address,
            utxos.unconfirmed_sats(),
            utxos.unconfirmed_tx_ids(),
            utxos.confirmed_sats(),
            utxos.confirmed_tx_ids(),
            swap_status,
        )?)
    }

    /// redeem_swap executes the final step of receiving lightning payment
    /// in exchange for the on chain funds.
    async fn redeem_swap(&self, bitcoin_address: String) -> Result<()> {
        let mut swap_info = self
            .persister
            .get_swap_info_by_address(bitcoin_address.clone())?
            .ok_or_else(|| anyhow!(format!("swap address {bitcoin_address} was not found")))?;

        // we are creating and invoice for this swap if we didn't
        // do it already
        if swap_info.bolt11.is_none() {
            let invoice = self
                .payment_receiver
                .receive_payment(ReceivePaymentRequest {
                    amount_msat: swap_info.confirmed_sats * 1000,
                    description: String::from("Bitcoin Transfer"),
                    preimage: Some(swap_info.preimage),
                    opening_fee_params: swap_info.channel_opening_fees,
                    use_description_hash: Some(false),
                    expiry: Some(SWAP_PAYMENT_FEE_EXPIRY_SECONDS),
                    cltv: None,
                })
                .await?
                .ln_invoice;
            self.persister
                .update_swap_bolt11(bitcoin_address.clone(), invoice.bolt11)?;
            swap_info = self
                .persister
                .get_swap_info_by_address(bitcoin_address)?
                .unwrap();
        }

        // Making sure the invoice amount matches the on-chain amount
        let payreq = swap_info.bolt11.unwrap();
        let ln_invoice = parse_invoice(payreq.clone())?;
        debug!("swap info confirmed = {}", swap_info.confirmed_sats);
        if ln_invoice.amount_msat.unwrap() != (swap_info.confirmed_sats * 1000) {
            warn!(
                "invoice amount doesn't match confirmed sats {:?}",
                ln_invoice.amount_msat.unwrap()
            );
            return Err(anyhow!("Does not match confirmed sats"));
        }

        // Asking the service to initiate the lightning payment.
        self.swapper_api.complete_swap(payreq.clone()).await
    }

    pub(crate) async fn prepare_refund_swap(
        &self,
        req: PrepareRefundRequest,
    ) -> Result<PrepareRefundResponse> {
        let swap_info = self.get_swap_info_ok(req.swap_address.clone())?;

        let utxos = self.get_address_utxos(req.swap_address).await?;

        let refund_tx = prepare_refund_tx(&utxos, req.to_address, swap_info.lock_height as u32)?;

        let refund_tx_weight = compute_refund_tx_weight(&refund_tx);
        let refund_tx_fee_sat = compute_tx_fee(refund_tx_weight, req.sat_per_vbyte);
        Ok(PrepareRefundResponse {
            refund_tx_weight,
            refund_tx_fee_sat,
        })
    }

    // refund_swap is the user way to receive on-chain refund for failed swaps.
    pub(crate) async fn refund_swap(&self, req: RefundRequest) -> Result<RefundResponse> {
        let swap_info = self.get_swap_info_ok(req.swap_address.clone())?;

        let utxos = self.get_address_utxos(req.swap_address).await?;

        let script = create_submarine_swap_script(
            swap_info.payment_hash,
            swap_info.swapper_public_key,
            swap_info.public_key,
            swap_info.lock_height,
        )?;
        let refund_tx = create_refund_tx(
            utxos.clone(),
            swap_info.private_key,
            req.to_address,
            swap_info.lock_height as u32,
            &script,
            req.sat_per_vbyte,
        )?;
        info!("broadcasting refund tx {:?}", hex::encode(&refund_tx));
        let tx_id = self.chain_service.broadcast_transaction(refund_tx).await?;

        self.persister
            .insert_swap_refund_tx_ids(swap_info.bitcoin_address, tx_id.clone())?;

        Ok(RefundResponse {
            refund_tx_id: tx_id,
        })
    }

    async fn get_address_utxos(&self, address: String) -> Result<AddressUtxos> {
        let transactions = self
            .chain_service
            .address_transactions(address.clone())
            .await?;
        get_utxos(address, transactions)
    }
}

pub(crate) struct SwapKeys {
    pub(crate) priv_key: Vec<u8>,
    pub(crate) preimage: Vec<u8>,
}

impl SwapKeys {
    pub(crate) fn secret_key(&self) -> Result<SecretKey> {
        Ok(SecretKey::from_slice(&self.priv_key)?)
    }

    pub(crate) fn public_key(&self) -> Result<PublicKey> {
        Ok(PublicKey::from_secret_key(
            &Secp256k1::new(),
            &self.secret_key()?,
        ))
    }

    pub(crate) fn public_key_bytes(&self) -> Result<Vec<u8>> {
        Ok(self.public_key()?.serialize().to_vec())
    }

    pub(crate) fn preimage_hash_bytes(&self) -> Vec<u8> {
        Message::from_hashed_data::<sha256::Hash>(&self.preimage[..])
            .as_ref()
            .to_vec()
    }
}

pub(crate) fn create_swap_keys() -> Result<SwapKeys> {
    let priv_key = rand::thread_rng().gen::<[u8; 32]>().to_vec();
    let preimage = rand::thread_rng().gen::<[u8; 32]>().to_vec();
    Ok(SwapKeys { priv_key, preimage })
}

pub(crate) fn create_submarine_swap_script(
    invoice_hash: Vec<u8>,
    swapper_pub_key: Vec<u8>,
    payer_pub_key: Vec<u8>,
    lock_height: i64,
) -> Result<Script> {
    let mut hasher = Ripemd160::new();
    hasher.update(invoice_hash);
    let result = hasher.finalize();

    Ok(Builder::new()
        .push_opcode(opcodes::all::OP_HASH160)
        .push_slice(&result[..])
        .push_opcode(opcodes::all::OP_EQUAL)
        .push_opcode(opcodes::all::OP_IF)
        .push_slice(&swapper_pub_key[..])
        .push_opcode(opcodes::all::OP_ELSE)
        .push_int(lock_height)
        .push_opcode(opcodes::all::OP_CSV)
        .push_opcode(opcodes::all::OP_DROP)
        .push_slice(&payer_pub_key[..])
        .push_opcode(opcodes::all::OP_ENDIF)
        .push_opcode(opcodes::all::OP_CHECKSIG)
        .into_script())
}

fn compute_refund_tx_weight(tx: &Transaction) -> u32 {
    #[allow(clippy::identity_op)] // Allow "+ 0" term in sum below for clarity
    let refund_witness_input_size: u32 = 1 + 1 + 73 + 1 + 0 + 1 + 100;
    tx.strippedsize() as u32 * WITNESS_SCALE_FACTOR as u32
        + refund_witness_input_size * tx.input.len() as u32
}

fn compute_tx_fee(tx_weight: u32, sat_per_vbyte: u32) -> u64 {
    (tx_weight * sat_per_vbyte / WITNESS_SCALE_FACTOR as u32) as u64
}

/// Prepare the refund transaction that is to be used by the user in case where the swap has
/// expired
fn prepare_refund_tx(
    utxos: &AddressUtxos,
    to_address: String,
    lock_delay: u32,
) -> Result<Transaction> {
    if utxos.confirmed.is_empty() {
        return Err(anyhow!("Must have at least one input"));
    }

    let lock_time = utxos.confirmed.iter().fold(0, |accum, item| {
        let confirmed_height = item.block_height.unwrap();
        if accum >= confirmed_height + lock_delay {
            accum
        } else {
            confirmed_height + lock_delay
        }
    });

    let confirmed_amount: u64 = utxos
        .confirmed
        .iter()
        .fold(0, |accum, item| accum + item.value);

    // create the tx inputs
    let txins: Vec<TxIn> = utxos
        .confirmed
        .iter()
        .map(|utxo| TxIn {
            previous_output: utxo.out,
            script_sig: Script::new(),
            sequence: Sequence(lock_delay),
            witness: Witness::default(),
        })
        .collect();

    // create the tx outputs
    let btc_address = Address::from_str(&to_address)?;
    let tx_out: Vec<TxOut> = vec![TxOut {
        value: confirmed_amount,
        script_pubkey: btc_address.payload.script_pubkey(),
    }];

    // construct the transaction
    let tx = Transaction {
        version: 2,
        lock_time: bitcoin::PackedLockTime(lock_time),
        input: txins,
        output: tx_out,
    };

    Ok(tx)
}

/// Creating the refund transaction that is to be used by the user in case where the swap has
/// expired.
fn create_refund_tx(
    utxos: AddressUtxos,
    private_key: Vec<u8>,
    to_address: String,
    lock_delay: u32,
    input_script: &Script,
    sat_per_vbyte: u32,
) -> Result<Vec<u8>> {
    info!("creating refund tx sat_per_vbyte {}", sat_per_vbyte);

    let mut tx = prepare_refund_tx(&utxos, to_address, lock_delay)?;

    let tx_weight = compute_refund_tx_weight(&tx);
    let fees = compute_tx_fee(tx_weight, sat_per_vbyte);

    if fees >= tx.output[0].value {
        return Err(anyhow!("Insufficient funds to pay fees"));
    }
    tx.output[0].value -= fees;

    let scpt = Secp256k1::signing_only();

    // go over all inputs and sign them
    let mut signed_inputs: Vec<TxIn> = Vec::new();
    for (index, input) in tx.input.iter().enumerate() {
        let mut signer = SighashCache::new(&tx);
        let sig = signer.segwit_signature_hash(
            index,
            input_script,
            utxos.confirmed[index].value,
            EcdsaSighashType::All,
        )?;
        let msg = Message::from_slice(&sig[..])?;
        let secret_key = SecretKey::from_slice(private_key.as_slice())?;
        let sig = scpt.sign_ecdsa(&msg, &secret_key);

        let mut sigvec = sig.serialize_der().to_vec();
        sigvec.push(EcdsaSighashType::All as u8);

        let witness: Vec<Vec<u8>> = vec![sigvec, vec![], input_script.serialize()];

        let mut signed_input = input.clone();
        let w = Witness::from_vec(witness);
        signed_input.witness = w;
        signed_inputs.push(signed_input);
    }
    tx.input = signed_inputs;

    //tx.output[0].value = confirmed_amount;
    Ok(encode::serialize(&tx))
}

#[cfg(test)]
mod tests {
    use std::{sync::Arc, vec};

    use anyhow::Result;
    use bitcoin::consensus::deserialize;
    use bitcoin::hashes::{hex::FromHex, sha256};
    use bitcoin::{
        secp256k1::{Message, PublicKey, Secp256k1, SecretKey},
        OutPoint, Transaction, Txid,
    };

    use crate::chain::{AddressUtxos, Utxo};
    use crate::swap_in::swap::{compute_refund_tx_weight, compute_tx_fee, prepare_refund_tx};
    use crate::test_utils::get_test_ofp;
    use crate::{
        breez_services::tests::get_dummy_node_state,
        chain::{ChainService, OnchainTx},
        models::*,
        persist::db::SqliteStorage,
        test_utils::{
            create_test_config, create_test_persister, MockChainService, MockReceiver,
            MockSwapperAPI,
        },
        BreezEvent,
    };

    use super::{create_refund_tx, create_submarine_swap_script, get_utxos, BTCReceiveSwap};

    #[test]
    fn test_build_swap_script() -> Result<()> {
        // swap payer private/public key pair
        // swap payer public key
        let secp = Secp256k1::new();
        let private_key = SecretKey::from_slice(&hex::decode(
            "1ab3fe9f94ff1332d6f198484c3677832d1162781f86ce85f6d7587fa97f0330",
        )?)?;
        let pub_key = PublicKey::from_secret_key(&secp, &private_key)
            .serialize()
            .to_vec();

        // Another pair for preimage/hash
        let preimage =
            hex::decode("4bedf04d0e1ed625e8863163e26abe4e1e6e3e9e5a25fa28cf4fe89500aadd46")?;
        let hash = Message::from_hashed_data::<sha256::Hash>(&preimage[..])
            .as_ref()
            .to_vec();

        // refund lock height
        let lock_height = 288;

        // swapper pubkey
        let swapper_pubkey =
            hex::decode("02b7952870655802bf863fd180de26ceec466d5454da949b159da8c1bf0cb3fe88")?;

        let expected_address = "bc1qwxgj02vc9esa32ylkrqnhmvcamwtd95wndxqpdwk4mh9pj4629uqcjwv8l";

        // create the script
        let script = create_submarine_swap_script(hash, swapper_pubkey, pub_key, lock_height)?;

        // compare the expected and created script
        let expected_script = "a91458163502b02967cfb7c0f3859874db702121b5d487632102b7952870655802bf863fd180de26ceec466d5454da949b159da8c1bf0cb3fe8867022001b27521024ad3b16767cf68d59c41b9544e42340959479447a82a5cd24c320e1ce92adb0968ac".to_string();
        let serialized_script = hex::encode(script.as_bytes());
        assert_eq!(expected_script, serialized_script);

        // compare the expected and created swap address
        let address = bitcoin::Address::p2wsh(&script, bitcoin::Network::Bitcoin);
        let address_str = address.to_string();
        assert_eq!(address_str, expected_address);

        Ok(())
    }

    #[tokio::test]
    async fn test_get_utxo() -> Result<()> {
        let swap_address = String::from("35kRn3rF7oDFU1BFRHuQM9txBWBXqipoJ3");
        let txs: Vec<OnchainTx> = serde_json::from_str(
            r#"[{"txid":"5e0668bf1cd24f2f8656ee82d4886f5303a06b26838e24b7db73afc59e228985","version":2,"locktime":0,"vin":[{"txid":"07c9d3fbffc20f96ea7c93ef3bcdf346c8a8456c25850ea76be62b24a7cf690c","vout":0,"prevout":{"scriptpubkey":"001465c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 65c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2","value":263216},"scriptsig":"","scriptsig_asm":"","witness":["3045022100a2f0ac810ce88625890f7e212d175eb1cd6b7c73ffed95a2bec06b38e0b2de060220036675c6a5c89845988cc27e7acba772e7655f2abb0575449471d8323d5900b301","026b815dddaf1687a05349d75d25911c9b6e2381e55ba72148009cfa0a577c89d9"],"is_coinbase":false,"sequence":0},{"txid":"6d6766c283093e2d043ae877bb915175b3d8672a20f0459300267aaab1b5766a","vout":0,"prevout":{"scriptpubkey":"001485b33c1937058ed08b5b122e30caf18e67ccb282","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 85b33c1937058ed08b5b122e30caf18e67ccb282","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qskencxfhqk8dpz6mzghrpjh33enuev5zh0mrjw","value":33247},"scriptsig":"","scriptsig_asm":"","witness":["304402200272cac1a312aae2a4ee64150e5b26e611a56509a467176e38c905b632d3ce56022005497d0d3ff14911214cb0fbb22a1aa16830ba669f6ff38723684750ceb4b11a01","0397d3b72557bd2044508ee3b22d1216b3f871c0963500f8c8dc6a143ee7a6a206"],"is_coinbase":false,"sequence":0},{"txid":"81af33ae00a9dadeb83b915b05742e986a470fff7456540e3f018deb94abda0e","vout":1,"prevout":{"scriptpubkey":"001431505647092347abb0e4d2a34f6773b74a999d45","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 31505647092347abb0e4d2a34f6773b74a999d45","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qx9g9v3cfydr6hv8y62357emnka9fn8294e73yl","value":172952},"scriptsig":"","scriptsig_asm":"","witness":["30450221008426c1b3d535f10c7cbccec6be3ea9be3514f3a86bf234584722665325283f35022010b6a617a465d1d7eea45562632f0ab80b0894da44b67fab65191a98fd9d3acb01","0221250914423379d3caf662297e8069621ca2c362cf92107388483929f4d9eb67"],"is_coinbase":false,"sequence":0}],"vout":[{"scriptpubkey":"001459c70c09f22b1bb007439af43b6809d6a2bc31b5","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 59c70c09f22b1bb007439af43b6809d6a2bc31b5","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qt8rscz0j9vdmqp6rnt6rk6qf663tcvd44f6gxa","value":2920},{"scriptpubkey":"00202c404e6e9c4d032267a29a6074c5db9333c6ccae0c9d430ced666316233d8c2f","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_32 2c404e6e9c4d032267a29a6074c5db9333c6ccae0c9d430ced666316233d8c2f","scriptpubkey_type":"v0_p2wsh","scriptpubkey_address":"bc1q93qyum5uf5pjyeaznfs8f3wmjveudn9wpjw5xr8dve33vgea3shs9jhvww","value":442557}],"size":532,"weight":1153,"fee":23938,"status":{"confirmed":true,"block_height":674358,"block_hash":"00000000000000000004c6171622f56692cc480d3c76ecae4355e69699a6ae44","block_time":1615595727}},{"txid":"07c9d3fbffc20f96ea7c93ef3bcdf346c8a8456c25850ea76be62b24a7cf690c","version":2,"locktime":0,"vin":[{"txid":"9332d8d11d81c3b674caff75db5543491e7f22e619ecc034bedf4a007518fe3a","vout":0,"prevout":{"scriptpubkey":"001415f0dad74806b03612687038d4f5bab200afcf8e","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 15f0dad74806b03612687038d4f5bab200afcf8e","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qzhcd446gq6crvyngwqudfad6kgq2lnuw9r2a86","value":470675},"scriptsig":"","scriptsig_asm":"","witness":["3045022100f30d84532f96b5e489047174e81394883cd519d427ca8f4facc2366f718cc678022007c083634402f40708c645cd0c1a2757b56de2076ca6ee856e514859381cd93801","02942b44eb4289e3af0aeeb73dfa82b0a5c8a3a06ae85bfd22aa3dcfcd64096462"],"is_coinbase":false,"sequence":0},{"txid":"c62da0c2d1929ab2a2c04d4fbae2a6e4e947f867cba584d1f80c4a1a62f4a75f","vout":1,"prevout":{"scriptpubkey":"0014f0c1d6b471d5e4a483fc146d4220a4e81587bf11","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 f0c1d6b471d5e4a483fc146d4220a4e81587bf11","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1q7rqaddr36hj2fqluz3k5yg9yaq2c00c3tw4qy5","value":899778},"scriptsig":"","scriptsig_asm":"","witness":["304402202da0eac25786003181526c4fe1592f982aa8d0f32c642a5103cdebbf4aa8b5a80220750cd6859bfb9a7df8d7c4d79a70e17a6df87f150fe1fdaade4650332ef0f47c01","02ecab80fcfe949633064c25fc33854fd09b8730decdf679db1f429bce201ec685"],"is_coinbase":false,"sequence":0}],"vout":[{"scriptpubkey":"001465c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 65c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2","value":263216},{"scriptpubkey":"00200cea60ae9eea43e64b17ba65a4c17bd3acf9dac307825deda85d5a093181dbc0","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_32 0cea60ae9eea43e64b17ba65a4c17bd3acf9dac307825deda85d5a093181dbc0","scriptpubkey_type":"v0_p2wsh","scriptpubkey_address":"bc1qpn4xpt57afp7vjchhfj6fstm6wk0nkkrq7p9mmdgt4dqjvvpm0qqlxqrns","value":1088924}],"size":383,"weight":881,"fee":18313,"status":{"confirmed":true,"block_height":674357,"block_hash":"00000000000000000008d0d007995a8bc9d60de17bd6b55e28a6e4c6918cb206","block_time":1615594996}}]"#,
        )?;
        let utxos = get_utxos(swap_address, txs)?;
        assert_eq!(utxos.confirmed.len(), 0);

        let swap_address = String::from("35kRn3rF7oDFU1BFRHuQM9txBWBXqipoJ3");
        let txs: Vec<OnchainTx> = serde_json::from_str(r#"[{"txid":"9f13dd16167430c2ccb3b89b5f915a3c836722c486e30505791c9604f1017a99","version":1,"locktime":0,"vin":[{"txid":"3d8e3b3e7ad5a396902f8814a5446139dd55757c6f3fa5fc63e905f1fef00a10","vout":66,"prevout":{"scriptpubkey":"a914b0f4345fad758790048c03d46fccf66b852ec9e387","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 b0f4345fad758790048c03d46fccf66b852ec9e3 OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"3HpfPwMTCggpmwMNxebnJB6y8jJP8Y3mdM","value":8832100},"scriptsig":"160014716588545d5a9ddcc2e38802d7382b8fc37e90ba","scriptsig_asm":"OP_PUSHBYTES_22 0014716588545d5a9ddcc2e38802d7382b8fc37e90ba","witness":["30450221008d73700314bd2de9e56256ce0548fe08f220f5c928075a242ca9a7980b0e7f5602202701318e9a6c3ba128dcf915c6c3997928e9870d4023150e6bfb84a783617a1c01","025dddb140932a1247c1cdc2dec534ba2a7647bb03c989a88e6d18117517f388f3"],"is_coinbase":false,"sequence":4294967293,"inner_redeemscript_asm":"OP_0 OP_PUSHBYTES_20 716588545d5a9ddcc2e38802d7382b8fc37e90ba"},{"txid":"9e64ea8118b13871d02d941552fa42af6d079e4e9384aa71a7da747d52cb468b","vout":0,"prevout":{"scriptpubkey":"a914b7969fec4adfad203881f98b6c04dfeeff774f5487","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 b7969fec4adfad203881f98b6c04dfeeff774f54 OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"3JRk2EfAr1mjYmXSMf5heBRnA6ym7WFsX1","value":23093207},"scriptsig":"160014d7f0a22aab7bd11dcb977e43f06ecfd6c44b7c2d","scriptsig_asm":"OP_PUSHBYTES_22 0014d7f0a22aab7bd11dcb977e43f06ecfd6c44b7c2d","witness":["30440220368b9584a2837542b600bbce16293811b01d0c5f919d153eb0d6c6716c4357000220379b6f91cb24c3d8193e39acaed2dbb973084bff10aff48059a1086672c5cde401","02074b5af43b526fedea5527edf1d246d1821867f161ebd9ca26295e21aeddb30a"],"is_coinbase":false,"sequence":4294967293,"inner_redeemscript_asm":"OP_0 OP_PUSHBYTES_20 d7f0a22aab7bd11dcb977e43f06ecfd6c44b7c2d"}],"vout":[{"scriptpubkey":"a9142c85a9b818d3cdf89bd3a1057bb21b2c7e64ad6087","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 2c85a9b818d3cdf89bd3a1057bb21b2c7e64ad60 OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"35kRn3rF7oDFU1BFRHuQM9txBWBXqipoJ3","value":31461100}],"size":387,"weight":897,"fee":464207,"status":{"confirmed":true,"block_height":764153,"block_hash":"00000000000000000000199349a95526c4f83959f0ef06697048a297f25e7fac","block_time":1669044812}}]"#).unwrap();
        let utxos = get_utxos(swap_address, txs)?;
        assert_eq!(utxos.confirmed.len(), 1);

        // test mempool transactions
        let swap_address = String::from("35kRn3rF7oDFU1BFRHuQM9txBWBXqipoJ3");
        let txs: Vec<OnchainTx> = serde_json::from_str(
            r#"[{"txid":"9f13dd16167430c2ccb3b89b5f915a3c836722c486e30505791c9604f1017a99","version":1,"locktime":0,"vin":[{"txid":"3d8e3b3e7ad5a396902f8814a5446139dd55757c6f3fa5fc63e905f1fef00a10","vout":66,"prevout":{"scriptpubkey":"a914b0f4345fad758790048c03d46fccf66b852ec9e387","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 b0f4345fad758790048c03d46fccf66b852ec9e3 OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"3HpfPwMTCggpmwMNxebnJB6y8jJP8Y3mdM","value":8832100},"scriptsig":"160014716588545d5a9ddcc2e38802d7382b8fc37e90ba","scriptsig_asm":"OP_PUSHBYTES_22 0014716588545d5a9ddcc2e38802d7382b8fc37e90ba","witness":["30450221008d73700314bd2de9e56256ce0548fe08f220f5c928075a242ca9a7980b0e7f5602202701318e9a6c3ba128dcf915c6c3997928e9870d4023150e6bfb84a783617a1c01","025dddb140932a1247c1cdc2dec534ba2a7647bb03c989a88e6d18117517f388f3"],"is_coinbase":false,"sequence":4294967293,"inner_redeemscript_asm":"OP_0 OP_PUSHBYTES_20 716588545d5a9ddcc2e38802d7382b8fc37e90ba"},{"txid":"9e64ea8118b13871d02d941552fa42af6d079e4e9384aa71a7da747d52cb468b","vout":0,"prevout":{"scriptpubkey":"a914b7969fec4adfad203881f98b6c04dfeeff774f5487","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 b7969fec4adfad203881f98b6c04dfeeff774f54 OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"3JRk2EfAr1mjYmXSMf5heBRnA6ym7WFsX1","value":23093207},"scriptsig":"160014d7f0a22aab7bd11dcb977e43f06ecfd6c44b7c2d","scriptsig_asm":"OP_PUSHBYTES_22 0014d7f0a22aab7bd11dcb977e43f06ecfd6c44b7c2d","witness":["30440220368b9584a2837542b600bbce16293811b01d0c5f919d153eb0d6c6716c4357000220379b6f91cb24c3d8193e39acaed2dbb973084bff10aff48059a1086672c5cde401","02074b5af43b526fedea5527edf1d246d1821867f161ebd9ca26295e21aeddb30a"],"is_coinbase":false,"sequence":4294967293,"inner_redeemscript_asm":"OP_0 OP_PUSHBYTES_20 d7f0a22aab7bd11dcb977e43f06ecfd6c44b7c2d"}],"vout":[{"scriptpubkey":"a9142c85a9b818d3cdf89bd3a1057bb21b2c7e64ad6087","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 2c85a9b818d3cdf89bd3a1057bb21b2c7e64ad60 OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"35kRn3rF7oDFU1BFRHuQM9txBWBXqipoJ3","value":31461100}],"size":387,"weight":897,"fee":464207,"status":{"confirmed":false}}]"#,
        )?;
        let utxos = get_utxos(swap_address, txs)?;
        assert_eq!(utxos.confirmed.len(), 0);
        assert_eq!(utxos.unconfirmed.len(), 1);

        Ok(())
    }

    // 1. User has sent funds to swap address
    // 2. Swap didn't complete before timeout
    // Swap should move to Expired status and returned in the refundable list.
    #[tokio::test]
    async fn test_expired_swap() -> Result<()> {
        let chain_service = Arc::new(MockChainService::default());
        let (mut swapper, _) = create_swapper(chain_service.clone())?;
        let swap_info = swapper
            .create_swap_address(get_test_ofp(10, 10, true).into())
            .await?;

        // We test the case that a confirmed transaction was detected on chain that
        // sent funds to this address but the lock timeout has expired.
        swapper.chain_service = chain_service_with_confirmed_txs(swap_info.clone().bitcoin_address);
        swapper
            .on_event(BreezEvent::NewBlock {
                block: chain_service.tip + 145,
            })
            .await?;

        let swap = swapper
            .get_swap_info(swap_info.clone().bitcoin_address)?
            .unwrap();
        assert_eq!(swap.refund_tx_ids, Vec::<String>::new());
        assert_eq!(
            swap.confirmed_tx_ids,
            vec!["ec901bcab07df7d475d98fff2933dcb56d57bbdaa029c4142aed93462b6928fe".to_string()]
        );

        assert_eq!(swap.confirmed_sats, 50000);
        assert_eq!(swap.paid_sats, 0);
        assert_eq!(swap.status, SwapStatus::Expired);
        assert_eq!(swapper.list_redeemables().unwrap().len(), 0);
        assert_eq!(swapper.list_refundables().unwrap().len(), 1);

        // broadcast refund transaction
        let req = RefundRequest {
            swap_address: swap.bitcoin_address,
            to_address: String::from("34RQERthXaruAXtW6q1bvrGTeUbqi2Sm1i"),
            sat_per_vbyte: 1,
        };
        let refund_response = swapper.refund_swap(req).await?;
        let swap = swapper
            .get_swap_info(swap_info.clone().bitcoin_address)?
            .unwrap();
        assert_eq!(swap.status, SwapStatus::Expired);
        assert_eq!(swapper.list_redeemables().unwrap().len(), 0);

        // the swap should be refundable by now
        let refundables = swapper.list_refundables()?;
        assert_eq!(refundables.len(), 1);
        assert_eq!(refundables[0].clone().refund_tx_ids.len(), 1);
        assert_eq!(
            refundables[0].clone().refund_tx_ids[0],
            refund_response.refund_tx_id
        );

        Ok(())
    }

    // 1. User sent funds to swap address
    // 2. Funds are redeemed in lightning transaction
    // Swap paid amount is updated and no longer redeemable.
    #[tokio::test]
    async fn test_redeem_swap() -> Result<()> {
        let chain_service = Arc::new(MockChainService::default());
        let (mut swapper, persister) = create_swapper(chain_service.clone())?;
        let swap_info = swapper
            .create_swap_address(get_test_ofp(10, 10, true).into())
            .await?;

        // add a payment with the same hash and test that the swapper updates the paid_amount for
        // the swap.
        let payment = Payment {
            id: hex::encode(swap_info.payment_hash.clone()),
            payment_type: PaymentType::Received,
            payment_time: 0,
            amount_msat: 5000,
            fee_msat: 0,
            status: PaymentStatus::Complete,
            description: Some("desc".to_string()),
            details: PaymentDetails::Ln {
                data: LnPaymentDetails {
                    payment_hash: hex::encode(swap_info.payment_hash.clone()),
                    label: "".to_string(),
                    destination_pubkey: "".to_string(),
                    payment_preimage: "111".to_string(),
                    keysend: false,
                    bolt11: "".to_string(),
                    lnurl_success_action: None,
                    lnurl_metadata: None,
                    ln_address: None,
                    lnurl_withdraw_endpoint: None,
                },
            },
        };
        persister.insert_or_update_payments(&vec![payment.clone()])?;

        // We test the case that a confirmed transaction was detected on chain that
        // sent funds to this address.
        swapper.chain_service = chain_service_with_confirmed_txs(swap_info.clone().bitcoin_address);
        swapper
            .on_event(BreezEvent::NewBlock {
                block: chain_service.tip + 1,
            })
            .await?;

        let swap = swapper
            .get_swap_info(swap_info.clone().bitcoin_address)?
            .unwrap();
        assert_eq!(swap.refund_tx_ids, Vec::<String>::new());
        assert_eq!(
            swap.confirmed_tx_ids,
            vec!["ec901bcab07df7d475d98fff2933dcb56d57bbdaa029c4142aed93462b6928fe".to_string()]
        );

        assert_eq!(swap.confirmed_sats, 50000);
        assert_eq!(swap.paid_sats, 5000);

        assert_eq!(swapper.list_redeemables().unwrap().len(), 0);
        assert_eq!(swapper.list_refundables().unwrap().len(), 0);

        // change payment amout and test that the InvoicePaid event triggers updating the
        // paid_amount of the swap.
        let mut payment = payment.clone();
        payment.amount_msat = 2000;
        persister.insert_or_update_payments(&vec![payment])?;
        swapper
            .on_event(BreezEvent::InvoicePaid {
                details: crate::InvoicePaidDetails {
                    payment_hash: hex::encode(swap_info.payment_hash.clone()),
                    bolt11: "".to_string(),
                },
            })
            .await?;
        let swap = swapper
            .get_swap_info(swap_info.clone().bitcoin_address)?
            .unwrap();
        assert_eq!(swap.paid_sats, 2000);

        Ok(())
    }

    // 1. User sent funds to swap address
    // 2. Funds are redeemed in lightning transaction
    // Swap paid amount is updated and no longer redeemable.
    #[tokio::test]
    async fn test_spent_swap() -> Result<()> {
        let chain_service = Arc::new(MockChainService::default());
        let (mut swapper, _) = create_swapper(chain_service.clone())?;
        let swap_info = swapper
            .create_swap_address(get_test_ofp(10, 10, true).into())
            .await?;

        // Once swap is spent on-chain the confirmed_sats would be set to zero again.
        swapper.chain_service = chain_service_after_spent(swap_info.clone().bitcoin_address);
        swapper
            .on_event(BreezEvent::NewBlock {
                block: chain_service.tip + 1,
            })
            .await?;

        let swap = swapper
            .get_swap_info(swap_info.clone().bitcoin_address)?
            .unwrap();
        assert_eq!(swap.refund_tx_ids, Vec::<String>::new());
        assert_eq!(swap.confirmed_tx_ids, Vec::<String>::new());
        assert_eq!(swap.confirmed_sats, 0);
        assert_eq!(swapper.list_redeemables().unwrap().len(), 0);
        assert_eq!(swapper.list_refundables().unwrap().len(), 0);

        // timeout expired
        swapper
            .on_event(BreezEvent::NewBlock {
                block: chain_service.tip + 145,
            })
            .await?;

        let swap = swapper
            .get_swap_info(swap_info.clone().bitcoin_address)?
            .unwrap();

        assert_eq!(swap.status, SwapStatus::Expired);
        assert_eq!(swapper.list_redeemables().unwrap().len(), 0);
        assert_eq!(swapper.list_refundables().unwrap().len(), 0);

        Ok(())
    }

    #[test]
    fn test_prepare_refund() -> Result<()> {
        // test parameters
        let to_address = String::from("bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2");
        let lock_time = 288;

        let utxos = AddressUtxos {
            confirmed: vec![Utxo {
                out: OutPoint {
                    txid: Txid::from_hex(
                        "1ab3fe9f94ff1332d6f198484c3677832d1162781f86ce85f6d7587fa97f0330",
                    )?,
                    vout: 0,
                },
                value: 20000,
                block_height: Some(700000),
            }],
            unconfirmed: vec![],
        };

        let prepared_refund_tx = prepare_refund_tx(&utxos, to_address, lock_time as u32)?;

        // Get the same `Transaction` used in `test_refund()`
        let raw_tx_bytes = hex::decode("0200000000010130037fa97f58d7f685ce861f7862112d8377364c4898f1d63213ff949ffeb31a00000000002001000001204e00000000000016001465c96c830168b8f0b584294d3b9716bb8584c2d80347304402203285efcf44640551a56c53bde677988964ef1b4d11182d5d6634096042c320120220227b625f7827993aca5b9d2f4690c5e5fae44d8d42fdd5f3778ba21df8ba7c7b010064a9148a486ff2e31d6158bf39e2608864d63fefd09d5b876321024d4b6cd1361032ca9bd2aeb9d900aa4d45d9ead80ac9423374c451a7254d076667022001b27521031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f68ac80af0a00").unwrap();
        let tx: Transaction = deserialize(&raw_tx_bytes).unwrap();
        let weight = Transaction::weight(&tx) as u64;

        let refund_tx_weight = compute_refund_tx_weight(&prepared_refund_tx);
        assert_eq!(refund_tx_weight, weight as u32);

        let refund_tx_fee_sat = compute_tx_fee(refund_tx_weight, 0);
        assert_eq!(refund_tx_fee_sat, 0);

        let refund_tx_fee_sat = compute_tx_fee(refund_tx_weight, 1);
        assert_eq!(refund_tx_fee_sat, weight / 4);

        let refund_tx_fee_sat = compute_tx_fee(refund_tx_weight, 20);
        assert_eq!(refund_tx_fee_sat, weight * 20 / 4);

        Ok(())
    }

    #[test]
    fn test_refund() -> Result<()> {
        // test parameters
        let payer_priv_key_raw = [1; 32].to_vec();
        let swapper_priv_key_raw = [2; 32].to_vec();
        let preimage: [u8; 32] = [3; 32];
        let to_address = String::from("bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2");
        let lock_time = 288;

        let utxos = AddressUtxos {
            confirmed: vec![Utxo {
                out: OutPoint {
                    txid: Txid::from_hex(
                        "1ab3fe9f94ff1332d6f198484c3677832d1162781f86ce85f6d7587fa97f0330",
                    )?,
                    vout: 0,
                },
                value: 20000,
                block_height: Some(700000),
            }],
            unconfirmed: vec![],
        };

        // payer keys
        let secp = Secp256k1::new();
        let payer_private_key = SecretKey::from_slice(&payer_priv_key_raw)?;
        let payer_pub_key = PublicKey::from_secret_key(&secp, &payer_private_key)
            .serialize()
            .to_vec();

        // swapper keys
        let swapper_private_key = SecretKey::from_slice(&swapper_priv_key_raw)?;
        let swapper_pub_key = PublicKey::from_secret_key(&secp, &swapper_private_key)
            .serialize()
            .to_vec();

        // calculate payment hash
        let payment_hash = Message::from_hashed_data::<sha256::Hash>(&preimage[..])
            .as_ref()
            .to_vec();

        let script =
            create_submarine_swap_script(payment_hash, swapper_pub_key, payer_pub_key, lock_time)?;

        let refund_tx = create_refund_tx(
            utxos,
            payer_priv_key_raw,
            to_address,
            lock_time as u32,
            &script,
            0,
        )?;

        /*  We test that the refund transaction looks like this
           {
            "addresses": [
                "bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2"
            ],
            "block_height": -1,
            "block_index": -1,
            "confirmations": 0,
            "double_spend": false,
            "fees": 0,
            "hash": "3f9cf5bef98a0ed82c0ef8e4bd34e3624bbedf60b4cbaae3b1180569d562f2fb",
            "inputs": [
                {
                    "age": 0,
                    "output_index": 0,
                    "prev_hash": "1ab3fe9f94ff1332d6f198484c3677832d1162781f86ce85f6d7587fa97f0330",
                    "script_type": "empty",
                    "sequence": 288
                }
            ],
            "lock_time": 700288,
            "opt_in_rbf": true,
            "outputs": [
                {
                    "addresses": [
                        "bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2"
                    ],
                    "script": "001465c96c830168b8f0b584294d3b9716bb8584c2d8",
                    "script_type": "pay-to-witness-pubkey-hash",
                    "value": 20000
                }
            ],
            "preference": "low",
            "received": "2022-11-16T10:24:20.100655728Z",
            "relayed_by": "3.235.183.11",
            "size": 157,
            "total": 20000,
            "ver": 2,
            "vin_sz": 1,
            "vout_sz": 1,
            "vsize": 101
        }
        */
        assert_eq!(hex::encode(refund_tx), "0200000000010130037fa97f58d7f685ce861f7862112d8377364c4898f1d63213ff949ffeb31a00000000002001000001204e00000000000016001465c96c830168b8f0b584294d3b9716bb8584c2d80347304402203285efcf44640551a56c53bde677988964ef1b4d11182d5d6634096042c320120220227b625f7827993aca5b9d2f4690c5e5fae44d8d42fdd5f3778ba21df8ba7c7b010064a9148a486ff2e31d6158bf39e2608864d63fefd09d5b876321024d4b6cd1361032ca9bd2aeb9d900aa4d45d9ead80ac9423374c451a7254d076667022001b27521031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f68ac80af0a00");

        Ok(())
    }

    fn create_swapper(
        chain_service: Arc<dyn ChainService>,
    ) -> Result<(BTCReceiveSwap, Arc<SqliteStorage>)> {
        let config = create_test_config();
        debug!("working = {}", config.working_dir);

        let persister = Arc::new(create_test_persister(config));
        persister.init()?;

        let dummy_node_state = get_dummy_node_state();
        persister.set_node_state(&dummy_node_state)?;

        let swapper = BTCReceiveSwap {
            network: bitcoin::Network::Bitcoin,
            swapper_api: Arc::new(MockSwapperAPI {}),
            persister: persister.clone(),
            chain_service: chain_service.clone(),
            payment_receiver: Arc::new(MockReceiver::default()),
        };
        Ok((swapper, persister))
    }

    fn chain_service_with_confirmed_txs(address: String) -> Arc<dyn ChainService> {
        let confirmed_txs_raw = r#"[{"txid":"ec901bcab07df7d475d98fff2933dcb56d57bbdaa029c4142aed93462b6928fe","version":1,"locktime":767636,"vin":[{"txid":"d4344fc9e7f66b3a1a50d1d76836a157629ba0c6ede093e94f1c809d334c9146","vout":0,"prevout":{"scriptpubkey":"0014cab22290b7adc75f861de820baa97d319c1110a6","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 cab22290b7adc75f861de820baa97d319c1110a6","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qe2ez9y9h4hr4lpsaaqst42taxxwpzy9xlzqt8k","value":209639471},"scriptsig":"","scriptsig_asm":"","witness":["304402202e914c35b75da798f0898c7cfe6ead207aaee41219afd77124fd56971f05d9030220123ce5d124f4635171b7622995dae35e00373a5fbf8117bfdca5e5080ad6554101","02122fa6d20413bb5da5c7e3fb42228be5436b1bd84e29b294bfc200db5eac460e"],"is_coinbase":false,"sequence":4294967293}],"vout":[{"scriptpubkey":"0014b34b7da80e662d1db3fcfbe34b7f4cacc4fac34d","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 b34b7da80e662d1db3fcfbe34b7f4cacc4fac34d","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qkd9hm2qwvck3mvlul035kl6v4nz04s6dmryeq5","value":50000},{"scriptpubkey":"0014f0e2a057d0e60411ac3d7218e29bf9489a59df18","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 f0e2a057d0e60411ac3d7218e29bf9489a59df18","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1q7r32q47suczprtpawgvw9xlefzd9nhccyatxvu","value":12140465}],"size":222,"weight":561,"fee":1753,"status":{"confirmed":true,"block_height":767637,"block_hash":"000000000000000000077769f3b2e6a28b9ed688f0d773f9ff2d73c622a2cfac","block_time":1671174562}}]"#;
        let confirmed_txs = confirmed_txs_raw.replace(
            "bc1qkd9hm2qwvck3mvlul035kl6v4nz04s6dmryeq5",
            address.as_str(),
        );
        chain_service_with_transactions(address, confirmed_txs)
    }

    fn chain_service_after_spent(address: String) -> Arc<dyn ChainService> {
        let txs_raw = r#"[{"txid":"a418e856bb22b6345868dc0b1ac1dd7a6b7fae1d231b275b74172f9584fa0bdf","version":1,"locktime":0,"vin":[{"txid":"ec901bcab07df7d475d98fff2933dcb56d57bbdaa029c4142aed93462b6928fe","vout":0,"prevout":{"scriptpubkey":"0014b34b7da80e662d1db3fcfbe34b7f4cacc4fac34d","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 b34b7da80e662d1db3fcfbe34b7f4cacc4fac34d","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qkd9hm2qwvck3mvlul035kl6v4nz04s6dmryeq5","value":50000},"scriptsig":"","scriptsig_asm":"","witness":["304502210089933e46614114e060d3d681c54af71e3d47f8be8131d9310ef8fe231c060f3302204103910a6790e3a678964df6f0f9ae2107666a91e777bd87f9172a28653e374701","0356f385879fefb8c52758126f6e7b9ac57374c2f73f2ee9047b4c61df0ba390b9"],"is_coinbase":false,"sequence":4294967293},{"txid":"fda3ce37f5fb849502e2027958d51efebd1841cb43bbfdd5f3d354c93a551ef9","vout":0,"prevout":{"scriptpubkey":"00145c7f3b6ceb79d03d5a5397df83f2334394ebdd2c","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 5c7f3b6ceb79d03d5a5397df83f2334394ebdd2c","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qt3lnkm8t08gr6kjnjl0c8u3ngw2whhfvzwsxrg","value":786885},"scriptsig":"","scriptsig_asm":"","witness":["304402200ae5465efe824609f7faf1094cce0195763df52e5409dd9ae0526568bf3bcaa20220103749041a87e082cf95bf1e12c5174881e5e4c55e75ab2db29a68538dbabbad01","03dfd8cc1f72f46d259dc0afc6d756bce551fce2fbf58a9ad36409a1b82a17e64f"],"is_coinbase":false,"sequence":4294967293}],"vout":[{"scriptpubkey":"a9141df45814863edfd6d87457e8f8bd79607a116a8f87","scriptpubkey_asm":"OP_HASH160 OP_PUSHBYTES_20 1df45814863edfd6d87457e8f8bd79607a116a8f OP_EQUAL","scriptpubkey_type":"p2sh","scriptpubkey_address":"34RQERthXaruAXtW6q1bvrGTeUbqi2Sm1i","value":26087585},{"scriptpubkey":"001479001aa5f4b981a0b654c3f834d0573595b0ed53","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 79001aa5f4b981a0b654c3f834d0573595b0ed53","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1q0yqp4f05hxq6pdj5c0urf5zhxk2mpm2ndx85za","value":171937413}],"size":372,"weight":837,"fee":259140,"status":{"confirmed":true,"block_height":767637,"block_hash":"000000000000000000077769f3b2e6a28b9ed688f0d773f9ff2d73c622a2cfac","block_time":1671174562}},{"txid":"ec901bcab07df7d475d98fff2933dcb56d57bbdaa029c4142aed93462b6928fe","version":1,"locktime":767636,"vin":[{"txid":"d4344fc9e7f66b3a1a50d1d76836a157629ba0c6ede093e94f1c809d334c9146","vout":0,"prevout":{"scriptpubkey":"0014cab22290b7adc75f861de820baa97d319c1110a6","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 cab22290b7adc75f861de820baa97d319c1110a6","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qe2ez9y9h4hr4lpsaaqst42taxxwpzy9xlzqt8k","value":209639471},"scriptsig":"","scriptsig_asm":"","witness":["304402202e914c35b75da798f0898c7cfe6ead207aaee41219afd77124fd56971f05d9030220123ce5d124f4635171b7622995dae35e00373a5fbf8117bfdca5e5080ad6554101","02122fa6d20413bb5da5c7e3fb42228be5436b1bd84e29b294bfc200db5eac460e"],"is_coinbase":false,"sequence":4294967293}],"vout":[{"scriptpubkey":"0014b34b7da80e662d1db3fcfbe34b7f4cacc4fac34d","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 b34b7da80e662d1db3fcfbe34b7f4cacc4fac34d","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qkd9hm2qwvck3mvlul035kl6v4nz04s6dmryeq5","value":50000},{"scriptpubkey":"0014f0e2a057d0e60411ac3d7218e29bf9489a59df18","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 f0e2a057d0e60411ac3d7218e29bf9489a59df18","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1q7r32q47suczprtpawgvw9xlefzd9nhccyatxvu","value":12140465}],"size":222,"weight":561,"fee":1753,"status":{"confirmed":true,"block_height":767637,"block_hash":"000000000000000000077769f3b2e6a28b9ed688f0d773f9ff2d73c622a2cfac","block_time":1671174562}}]"#;
        let with_spent_txs = txs_raw.replace(
            "bc1qkd9hm2qwvck3mvlul035kl6v4nz04s6dmryeq5",
            address.as_str(),
        );
        chain_service_with_transactions(address, with_spent_txs)
    }

    fn chain_service_with_transactions(
        address: String,
        transactions: String,
    ) -> Arc<dyn ChainService> {
        let mut chain_service = MockChainService::default();
        let spent_txs_json: Vec<OnchainTx> = serde_json::from_str(&transactions).unwrap();
        chain_service.address_to_transactions.clear();
        chain_service
            .address_to_transactions
            .insert(address, spent_txs_json);

        Arc::new(chain_service)
    }
}
