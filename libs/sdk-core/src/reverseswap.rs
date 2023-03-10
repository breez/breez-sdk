use std::sync::Arc;

use crate::chain::{ChainService, MempoolSpace};
use crate::models::ReverseSwapperAPI;
use crate::{ReverseSwapInfo, ReverseSwapPairInfo, ReverseSwapStatus};
use anyhow::Result;
use serde::{Deserialize, Serialize};

#[derive(Clone, Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct CreateReverseSwapResponse {
    id: String,

    /// HODL invoice that has to be paid, for the Boltz service to lock up the funds
    invoice: String,

    /// Redeem script from which the lock address is derived. Can be used to check that the Boltz
    /// service didn't create an address without an HTLC.
    redeem_script: String,

    /// Amount of sats which will be locked
    onchain_amount: u64,

    /// Block height at which the reverse swap will be considered cancelled
    pub(crate) timeout_block_height: u64,

    /// Address to which the funds will be locked
    pub(crate) lockup_address: String,
}

/// This struct is responsible for sending to an onchain address using lightning payments.
/// It uses internally an implementation of [ReverseSwapperAPI] that represents Boltz reverse swapper service.
pub(crate) struct BTCSendSwap {
    _network: bitcoin::Network,
    reverse_swapper_api: Arc<dyn ReverseSwapperAPI>,
    _persister: Arc<crate::persist::db::SqliteStorage>,
    _chain_service: Arc<dyn ChainService>,
    //payment_sender: Arc<dyn Sender>,
}

impl BTCSendSwap {
    pub(crate) fn new(
        _network: bitcoin::Network,
        reverse_swapper_api: Arc<dyn ReverseSwapperAPI>,
        _persister: Arc<crate::persist::db::SqliteStorage>,
        _chain_service: Arc<MempoolSpace>,
        //payment_sender: Arc<PaymentSender>,
    ) -> Self {
        Self {
            _network,
            reverse_swapper_api,
            _persister,
            _chain_service,
            //payment_sender,
        }
    }

    pub(crate) async fn create_reverse_swap(
        &self,
        amount_sat: u64,
        onchain_claim_address: String,
        pair_hash: String,
        routing_node: String,
    ) -> Result<ReverseSwapInfo> {
        let rev_swap = self
            .reverse_swapper_api
            .create_reverse_swap(
                amount_sat,
                onchain_claim_address.clone(),
                pair_hash,
                routing_node,
            )
            .await?;

        let rev_swap_info = ReverseSwapInfo {
            lockup_address: rev_swap.response.lockup_address,
            claim_address: onchain_claim_address,
            status: ReverseSwapStatus::Initial,
        };

        // TODO persist

        Ok(rev_swap_info)
    }

    pub(crate) async fn reverse_swap_info(&self) -> Result<ReverseSwapPairInfo> {
        self.reverse_swapper_api.reverse_swap_info().await
    }
}
