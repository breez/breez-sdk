use std::collections::HashMap;

use serde::{Deserialize, Serialize};

use anyhow::{anyhow, Result};
use bitcoin_hashes::hex::ToHex;
use bitcoin_hashes::{sha256, Hash};
use serde_json::json;

use const_format::concatcp;
use rand::random;
use reqwest::header::CONTENT_TYPE;
use reqwest::Client;

use crate::models::ReverseSwapPairInfo;
use crate::reverseswap::CreateReverseSwapResponse;
use crate::{ReverseSwap, ReverseSwapperAPI};

const BOLTZ_API_URL: &str = "https://boltz.exchange/api/";
const GET_PAIRS_ENDPOINT: &str = concatcp!(BOLTZ_API_URL, "getpairs");
pub(crate) const CREATE_REVERSE_SWAP_ENDPOINT: &str = concatcp!(BOLTZ_API_URL, "createswap");

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
struct Post {
    id: Option<i32>,
    title: String,
    body: String,
    user_id: i32,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
struct MaximalZeroConf {
    base_asset: u64,
    quote_asset: u64,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
struct Limits {
    maximal: u64,
    minimal: u64,
    maximal_zero_conf: MaximalZeroConf,
}

#[derive(Debug, Serialize, Deserialize)]
struct ReverseFeesAsset {
    lockup: u64,
    claim: u64,
}

#[derive(Debug, Serialize, Deserialize)]
struct FeesAsset {
    normal: u64,
    reverse: ReverseFeesAsset,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
struct MinerFees {
    base_asset: FeesAsset,
    quote_asset: FeesAsset,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
struct Fees {
    percentage: f64,
    miner_fees: MinerFees,
}

#[derive(Debug, Serialize, Deserialize)]
struct Pair {
    rate: f64,
    hash: String,
    limits: Limits,
    fees: Fees,
}

#[derive(Debug, Serialize, Deserialize)]
struct Pairs {
    warnings: Vec<String>,
    info: Vec<String>,
    pairs: HashMap<String, Pair>,
}

pub struct BoltzApi {}

#[tonic::async_trait]
impl ReverseSwapperAPI for BoltzApi {
    async fn reverse_swap_info(&self) -> Result<ReverseSwapPairInfo> {
        reverse_swap_info().await
    }

    async fn create_reverse_swap(
        &self,
        amount_sat: u64,
        onchain_claim_address: String,
        pair_hash: String,
        routing_node: String,
    ) -> Result<ReverseSwap> {
        let rand_bytes: [u8; 32] = random();
        let preimage = sha256::Hash::hash(&rand_bytes);
        let preimage_hash = sha256::Hash::hash(&preimage);
        let preimage_hash_hex = preimage_hash.to_hex();

        let response: CreateReverseSwapResponse = Client::new()
            .post(CREATE_REVERSE_SWAP_ENDPOINT)
            .header(CONTENT_TYPE, "application/json")
            .body(get_boltz_reverse_swap_args(
                amount_sat,
                preimage_hash_hex,
                pair_hash,
                onchain_claim_address,
                routing_node,
            ))
            .send()
            .await?
            .json()
            .await?;

        // TODO In case of error, return Err(str) or Ok(ReverseSwap{ error_message = ..} ) ?
        return Ok(ReverseSwap {
            error_message: None,
            response,
        });
    }
}

pub async fn reverse_swap_info() -> Result<ReverseSwapPairInfo> {
    let pairs = reqwest::get(GET_PAIRS_ENDPOINT)
        .await?
        .json::<Pairs>()
        .await?;
    match pairs.pairs.get("BTC/BTC") {
        None => Err(anyhow!("BTC pair not found")),
        Some(btc_pair) => {
            println!("result: {}", serde_json::to_string_pretty(&btc_pair)?);
            let hash = String::from(&btc_pair.hash);
            Ok(ReverseSwapPairInfo {
                fees_hash: hash,
                min: btc_pair.limits.minimal,
                max: btc_pair.limits.maximal,
                fees_percentage: btc_pair.fees.percentage,
                fees_lockup: btc_pair.fees.miner_fees.base_asset.reverse.lockup,
                fees_claim: btc_pair.fees.miner_fees.base_asset.reverse.claim,
            })
        }
    }
}

fn get_boltz_reverse_swap_args(
    amount_sat: u64,
    preimage_hash_hex: String,
    pair_hash: String,
    claim_pubkey: String,
    routing_node: String,
) -> String {
    json!({
        "type": "reversesubmarine",
        "pairId": "BTC/BTC",
        "orderSide": "buy",
        "invoiceAmount": amount_sat,
        "preimageHash": preimage_hash_hex,
        "pairHash": pair_hash,
        "claimPublicKey": claim_pubkey,
        "routingNode": routing_node
    })
    .to_string()
}
