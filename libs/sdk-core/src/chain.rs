use anyhow::Result;
use bitcoin::{OutPoint, Txid};
use bitcoin_hashes::hex::FromHex;
use serde::{Deserialize, Serialize};

#[tonic::async_trait]
pub trait ChainService: Send + Sync {
    async fn recommended_fees(&self) -> Result<RecommendedFees>;
    /// Gets all transactions associated with this address. Does not distinguish between spent and unspent.
    async fn address_transactions(&self, address: String) -> Result<Vec<OnchainTx>>;
    async fn current_tip(&self) -> Result<u32>;
    async fn broadcast_transaction(&self, tx: Vec<u8>) -> Result<String>;
}

#[derive(Clone)]
pub struct Utxo {
    pub out: OutPoint,
    pub value: u32,
    pub block_height: Option<u32>,
}

#[derive(Clone)]
pub struct AddressUtxos {
    pub unconfirmed: Vec<Utxo>,
    pub confirmed: Vec<Utxo>,
}

impl AddressUtxos {
    pub(crate) fn unconfirmed_sats(&self) -> u32 {
        self.unconfirmed
            .iter()
            .fold(0, |accum, item| accum + item.value)
    }

    pub(crate) fn unconfirmed_tx_ids(&self) -> Vec<String> {
        self.unconfirmed
            .iter()
            .map(|c| c.out.txid.to_string())
            .collect()
    }

    pub(crate) fn confirmed_sats(&self) -> u32 {
        self.confirmed
            .iter()
            .fold(0, |accum, item| accum + item.value)
    }

    pub(crate) fn confirmed_tx_ids(&self) -> Vec<String> {
        self.confirmed
            .iter()
            .map(|c| c.out.txid.to_string())
            .collect()
    }

    /// Get the highest block height of all confirmed transactions that paid to the given onchain address
    pub(crate) fn _confirmed_block(&self) -> u32 {
        self.confirmed.iter().fold(0, |b, item| {
            let confirmed_block = item.block_height.unwrap_or_default();
            if confirmed_block != 0 || confirmed_block < b {
                confirmed_block
            } else {
                b
            }
        })
    }
}

/// Gets unspent tx outputs. Specifically filters out inbound utxos that have been spent.
pub(crate) fn get_utxos(address: String, transactions: Vec<OnchainTx>) -> Result<AddressUtxos> {
    // Calculate confirmed amount associated with this address
    let mut spent_outputs: Vec<OutPoint> = Vec::new();
    let mut utxos: Vec<Utxo> = Vec::new();
    for (_, tx) in transactions.iter().enumerate() {
        for (_, vin) in tx.vin.iter().enumerate() {
            if vin.prevout.scriptpubkey_address == address.clone() {
                spent_outputs.push(OutPoint {
                    txid: Txid::from_hex(vin.txid.as_str())?,
                    vout: vin.vout,
                })
            }
        }
    }

    for (_i, tx) in transactions.iter().enumerate() {
        for (index, vout) in tx.vout.iter().enumerate() {
            if vout.scriptpubkey_address == address {
                let outpoint = OutPoint {
                    txid: Txid::from_hex(tx.txid.as_str())?,
                    vout: index as u32,
                };
                if !spent_outputs.contains(&outpoint) {
                    utxos.push(Utxo {
                        out: outpoint,
                        value: vout.value,
                        block_height: tx.status.block_height,
                    });
                }
            }
        }
    }
    let address_utxos = AddressUtxos {
        unconfirmed: utxos
            .clone()
            .into_iter()
            .filter(|u| u.block_height.is_none())
            .collect(),
        confirmed: utxos
            .clone()
            .into_iter()
            .filter(|u| u.block_height.is_some())
            .collect(),
    };
    Ok(address_utxos)
}

#[derive(Clone)]
pub(crate) struct MempoolSpace {
    pub(crate) base_url: String,
}

/// Wrapper containing the result of the recommended fees query, in sat/vByte, based on mempool.space data
#[derive(Deserialize, Clone, Debug)]
pub struct RecommendedFees {
    #[serde(rename(deserialize = "fastestFee"))]
    pub fastest_fee: u32,

    #[serde(rename(deserialize = "halfHourFee"))]
    pub half_hour_fee: u32,

    #[serde(rename(deserialize = "hourFee"))]
    pub hour_fee: u32,

    #[serde(rename(deserialize = "economyFee"))]
    pub economy_fee: u32,

    #[serde(rename(deserialize = "minimumFee"))]
    pub minimum_fee: u32,
}

#[derive(Deserialize, Serialize, Clone, Debug)]
pub struct OnchainTx {
    pub txid: String,
    pub version: u32,
    pub locktime: u32,
    pub vin: Vec<Vin>,
    pub vout: Vec<Vout>,
    pub size: u32,
    pub weight: u32,
    pub fee: u32,
    pub status: TxStatus,
}

#[derive(Deserialize, Serialize, Clone, Debug)]
pub struct TxStatus {
    pub confirmed: bool,
    pub block_height: Option<u32>,
    pub block_hash: Option<String>,
    pub block_time: Option<u64>,
}

#[derive(Deserialize, Serialize, Clone, Debug)]
pub struct Vout {
    pub scriptpubkey: String,
    pub scriptpubkey_asm: String,
    pub scriptpubkey_type: String,
    pub scriptpubkey_address: String,
    pub value: u32,
}

#[derive(Deserialize, Serialize, Clone, Debug)]
pub struct Vin {
    pub txid: String,
    pub vout: u32,
    pub prevout: Vout,
    pub scriptsig: String,
    pub scriptsig_asm: String,
    pub witness: Option<Vec<String>>,
    pub is_coinbase: bool,
    pub sequence: u32,
}

impl Default for MempoolSpace {
    fn default() -> Self {
        MempoolSpace {
            base_url: "https://mempool.space".to_string(),
        }
    }
}

impl MempoolSpace {
    pub fn from_base_url(base_url: String) -> MempoolSpace {
        MempoolSpace { base_url }
    }
}

#[tonic::async_trait]
impl ChainService for MempoolSpace {
    async fn recommended_fees(&self) -> Result<RecommendedFees> {
        Ok(
            reqwest::get(format!("{}/api/v1/fees/recommended", self.base_url))
                .await?
                .json()
                .await?,
        )
    }

    async fn address_transactions(&self, address: String) -> Result<Vec<OnchainTx>> {
        Ok(
            reqwest::get(format!("{}/api/address/{}/txs", self.base_url, address))
                .await?
                .json()
                .await?,
        )
    }

    async fn current_tip(&self) -> Result<u32> {
        Ok(
            reqwest::get(format!("{}/api/blocks/tip/height", self.base_url))
                .await?
                .text()
                .await?
                .parse()?,
        )
    }

    async fn broadcast_transaction(&self, tx: Vec<u8>) -> Result<String> {
        let client = reqwest::Client::new();
        client
            .post(format!("{}/api/tx", self.base_url))
            .body(hex::encode(tx))
            .send()
            .await?
            .text()
            .await
            .map_err(anyhow::Error::msg)
    }
}
#[cfg(test)]
mod tests {
    use crate::chain::{MempoolSpace, OnchainTx};
    use tokio::test;

    use super::ChainService;

    #[tokio::test]
    async fn test_recommended_fees() {
        let ms = Box::new(MempoolSpace::from_base_url(
            "https://mempool.space".to_string(),
        ));
        let fees = ms.recommended_fees().await.unwrap();
        assert!(fees.economy_fee > 0);
        assert!(fees.fastest_fee > 0);
        assert!(fees.half_hour_fee > 0);
        assert!(fees.hour_fee > 0);
        assert!(fees.minimum_fee > 0);
    }

    #[test]
    async fn test_address_transactions() {
        let ms = MempoolSpace::from_base_url("https://mempool.space".to_string());
        let txs = ms
            .address_transactions("bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2".to_string())
            .await
            .unwrap();
        let serialized_res = serde_json::to_string(&txs).unwrap();

        let expected = r#"[{"txid":"5e0668bf1cd24f2f8656ee82d4886f5303a06b26838e24b7db73afc59e228985","version":2,"locktime":0,"vin":[{"txid":"07c9d3fbffc20f96ea7c93ef3bcdf346c8a8456c25850ea76be62b24a7cf690c","vout":0,"prevout":{"scriptpubkey":"001465c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 65c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2","value":263216},"scriptsig":"","scriptsig_asm":"","witness":["3045022100a2f0ac810ce88625890f7e212d175eb1cd6b7c73ffed95a2bec06b38e0b2de060220036675c6a5c89845988cc27e7acba772e7655f2abb0575449471d8323d5900b301","026b815dddaf1687a05349d75d25911c9b6e2381e55ba72148009cfa0a577c89d9"],"is_coinbase":false,"sequence":0},{"txid":"6d6766c283093e2d043ae877bb915175b3d8672a20f0459300267aaab1b5766a","vout":0,"prevout":{"scriptpubkey":"001485b33c1937058ed08b5b122e30caf18e67ccb282","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 85b33c1937058ed08b5b122e30caf18e67ccb282","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qskencxfhqk8dpz6mzghrpjh33enuev5zh0mrjw","value":33247},"scriptsig":"","scriptsig_asm":"","witness":["304402200272cac1a312aae2a4ee64150e5b26e611a56509a467176e38c905b632d3ce56022005497d0d3ff14911214cb0fbb22a1aa16830ba669f6ff38723684750ceb4b11a01","0397d3b72557bd2044508ee3b22d1216b3f871c0963500f8c8dc6a143ee7a6a206"],"is_coinbase":false,"sequence":0},{"txid":"81af33ae00a9dadeb83b915b05742e986a470fff7456540e3f018deb94abda0e","vout":1,"prevout":{"scriptpubkey":"001431505647092347abb0e4d2a34f6773b74a999d45","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 31505647092347abb0e4d2a34f6773b74a999d45","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qx9g9v3cfydr6hv8y62357emnka9fn8294e73yl","value":172952},"scriptsig":"","scriptsig_asm":"","witness":["30450221008426c1b3d535f10c7cbccec6be3ea9be3514f3a86bf234584722665325283f35022010b6a617a465d1d7eea45562632f0ab80b0894da44b67fab65191a98fd9d3acb01","0221250914423379d3caf662297e8069621ca2c362cf92107388483929f4d9eb67"],"is_coinbase":false,"sequence":0}],"vout":[{"scriptpubkey":"001459c70c09f22b1bb007439af43b6809d6a2bc31b5","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 59c70c09f22b1bb007439af43b6809d6a2bc31b5","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qt8rscz0j9vdmqp6rnt6rk6qf663tcvd44f6gxa","value":2920},{"scriptpubkey":"00202c404e6e9c4d032267a29a6074c5db9333c6ccae0c9d430ced666316233d8c2f","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_32 2c404e6e9c4d032267a29a6074c5db9333c6ccae0c9d430ced666316233d8c2f","scriptpubkey_type":"v0_p2wsh","scriptpubkey_address":"bc1q93qyum5uf5pjyeaznfs8f3wmjveudn9wpjw5xr8dve33vgea3shs9jhvww","value":442557}],"size":532,"weight":1153,"fee":23938,"status":{"confirmed":true,"block_height":674358,"block_hash":"00000000000000000004c6171622f56692cc480d3c76ecae4355e69699a6ae44","block_time":1615595727}},{"txid":"07c9d3fbffc20f96ea7c93ef3bcdf346c8a8456c25850ea76be62b24a7cf690c","version":2,"locktime":0,"vin":[{"txid":"9332d8d11d81c3b674caff75db5543491e7f22e619ecc034bedf4a007518fe3a","vout":0,"prevout":{"scriptpubkey":"001415f0dad74806b03612687038d4f5bab200afcf8e","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 15f0dad74806b03612687038d4f5bab200afcf8e","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qzhcd446gq6crvyngwqudfad6kgq2lnuw9r2a86","value":470675},"scriptsig":"","scriptsig_asm":"","witness":["3045022100f30d84532f96b5e489047174e81394883cd519d427ca8f4facc2366f718cc678022007c083634402f40708c645cd0c1a2757b56de2076ca6ee856e514859381cd93801","02942b44eb4289e3af0aeeb73dfa82b0a5c8a3a06ae85bfd22aa3dcfcd64096462"],"is_coinbase":false,"sequence":0},{"txid":"c62da0c2d1929ab2a2c04d4fbae2a6e4e947f867cba584d1f80c4a1a62f4a75f","vout":1,"prevout":{"scriptpubkey":"0014f0c1d6b471d5e4a483fc146d4220a4e81587bf11","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 f0c1d6b471d5e4a483fc146d4220a4e81587bf11","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1q7rqaddr36hj2fqluz3k5yg9yaq2c00c3tw4qy5","value":899778},"scriptsig":"","scriptsig_asm":"","witness":["304402202da0eac25786003181526c4fe1592f982aa8d0f32c642a5103cdebbf4aa8b5a80220750cd6859bfb9a7df8d7c4d79a70e17a6df87f150fe1fdaade4650332ef0f47c01","02ecab80fcfe949633064c25fc33854fd09b8730decdf679db1f429bce201ec685"],"is_coinbase":false,"sequence":0}],"vout":[{"scriptpubkey":"001465c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 65c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2","value":263216},{"scriptpubkey":"00200cea60ae9eea43e64b17ba65a4c17bd3acf9dac307825deda85d5a093181dbc0","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_32 0cea60ae9eea43e64b17ba65a4c17bd3acf9dac307825deda85d5a093181dbc0","scriptpubkey_type":"v0_p2wsh","scriptpubkey_address":"bc1qpn4xpt57afp7vjchhfj6fstm6wk0nkkrq7p9mmdgt4dqjvvpm0qqlxqrns","value":1088924}],"size":383,"weight":881,"fee":18313,"status":{"confirmed":true,"block_height":674357,"block_hash":"00000000000000000008d0d007995a8bc9d60de17bd6b55e28a6e4c6918cb206","block_time":1615594996}}]"#;
        let expected_txs: Vec<OnchainTx> = serde_json::from_str(expected).unwrap();
        let expected_serialized = serde_json::to_string(&expected_txs).unwrap();

        assert_eq!(expected_serialized, serialized_res);
    }

    // #[test]
    // async fn test_address_transactions_mempool() {
    //     let ms = MempoolSpace::from_base_url("https://mempool.space".to_string());
    //     let txs = ms
    //         .address_transactions("1N4f3y3LYJZ2Qd9FyPt3AcHp451qt12paR".to_string())
    //         .await
    //         .unwrap();
    //     let serialized_res = serde_json::to_string(&txs).unwrap();

    //     let expected = r#"[{"txid":"5e0668bf1cd24f2f8656ee82d4886f5303a06b26838e24b7db73afc59e228985","version":2,"locktime":0,"vin":[{"txid":"07c9d3fbffc20f96ea7c93ef3bcdf346c8a8456c25850ea76be62b24a7cf690c","vout":0,"prevout":{"scriptpubkey":"001465c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 65c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2","value":263216},"scriptsig":"","scriptsig_asm":"","witness":["3045022100a2f0ac810ce88625890f7e212d175eb1cd6b7c73ffed95a2bec06b38e0b2de060220036675c6a5c89845988cc27e7acba772e7655f2abb0575449471d8323d5900b301","026b815dddaf1687a05349d75d25911c9b6e2381e55ba72148009cfa0a577c89d9"],"is_coinbase":false,"sequence":0},{"txid":"6d6766c283093e2d043ae877bb915175b3d8672a20f0459300267aaab1b5766a","vout":0,"prevout":{"scriptpubkey":"001485b33c1937058ed08b5b122e30caf18e67ccb282","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 85b33c1937058ed08b5b122e30caf18e67ccb282","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qskencxfhqk8dpz6mzghrpjh33enuev5zh0mrjw","value":33247},"scriptsig":"","scriptsig_asm":"","witness":["304402200272cac1a312aae2a4ee64150e5b26e611a56509a467176e38c905b632d3ce56022005497d0d3ff14911214cb0fbb22a1aa16830ba669f6ff38723684750ceb4b11a01","0397d3b72557bd2044508ee3b22d1216b3f871c0963500f8c8dc6a143ee7a6a206"],"is_coinbase":false,"sequence":0},{"txid":"81af33ae00a9dadeb83b915b05742e986a470fff7456540e3f018deb94abda0e","vout":1,"prevout":{"scriptpubkey":"001431505647092347abb0e4d2a34f6773b74a999d45","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 31505647092347abb0e4d2a34f6773b74a999d45","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qx9g9v3cfydr6hv8y62357emnka9fn8294e73yl","value":172952},"scriptsig":"","scriptsig_asm":"","witness":["30450221008426c1b3d535f10c7cbccec6be3ea9be3514f3a86bf234584722665325283f35022010b6a617a465d1d7eea45562632f0ab80b0894da44b67fab65191a98fd9d3acb01","0221250914423379d3caf662297e8069621ca2c362cf92107388483929f4d9eb67"],"is_coinbase":false,"sequence":0}],"vout":[{"scriptpubkey":"001459c70c09f22b1bb007439af43b6809d6a2bc31b5","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 59c70c09f22b1bb007439af43b6809d6a2bc31b5","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qt8rscz0j9vdmqp6rnt6rk6qf663tcvd44f6gxa","value":2920},{"scriptpubkey":"00202c404e6e9c4d032267a29a6074c5db9333c6ccae0c9d430ced666316233d8c2f","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_32 2c404e6e9c4d032267a29a6074c5db9333c6ccae0c9d430ced666316233d8c2f","scriptpubkey_type":"v0_p2wsh","scriptpubkey_address":"bc1q93qyum5uf5pjyeaznfs8f3wmjveudn9wpjw5xr8dve33vgea3shs9jhvww","value":442557}],"size":532,"weight":1153,"fee":23938,"status":{"confirmed":true,"block_height":674358,"block_hash":"00000000000000000004c6171622f56692cc480d3c76ecae4355e69699a6ae44","block_time":1615595727}},{"txid":"07c9d3fbffc20f96ea7c93ef3bcdf346c8a8456c25850ea76be62b24a7cf690c","version":2,"locktime":0,"vin":[{"txid":"9332d8d11d81c3b674caff75db5543491e7f22e619ecc034bedf4a007518fe3a","vout":0,"prevout":{"scriptpubkey":"001415f0dad74806b03612687038d4f5bab200afcf8e","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 15f0dad74806b03612687038d4f5bab200afcf8e","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qzhcd446gq6crvyngwqudfad6kgq2lnuw9r2a86","value":470675},"scriptsig":"","scriptsig_asm":"","witness":["3045022100f30d84532f96b5e489047174e81394883cd519d427ca8f4facc2366f718cc678022007c083634402f40708c645cd0c1a2757b56de2076ca6ee856e514859381cd93801","02942b44eb4289e3af0aeeb73dfa82b0a5c8a3a06ae85bfd22aa3dcfcd64096462"],"is_coinbase":false,"sequence":0},{"txid":"c62da0c2d1929ab2a2c04d4fbae2a6e4e947f867cba584d1f80c4a1a62f4a75f","vout":1,"prevout":{"scriptpubkey":"0014f0c1d6b471d5e4a483fc146d4220a4e81587bf11","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 f0c1d6b471d5e4a483fc146d4220a4e81587bf11","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1q7rqaddr36hj2fqluz3k5yg9yaq2c00c3tw4qy5","value":899778},"scriptsig":"","scriptsig_asm":"","witness":["304402202da0eac25786003181526c4fe1592f982aa8d0f32c642a5103cdebbf4aa8b5a80220750cd6859bfb9a7df8d7c4d79a70e17a6df87f150fe1fdaade4650332ef0f47c01","02ecab80fcfe949633064c25fc33854fd09b8730decdf679db1f429bce201ec685"],"is_coinbase":false,"sequence":0}],"vout":[{"scriptpubkey":"001465c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_20 65c96c830168b8f0b584294d3b9716bb8584c2d8","scriptpubkey_type":"v0_p2wpkh","scriptpubkey_address":"bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2","value":263216},{"scriptpubkey":"00200cea60ae9eea43e64b17ba65a4c17bd3acf9dac307825deda85d5a093181dbc0","scriptpubkey_asm":"OP_0 OP_PUSHBYTES_32 0cea60ae9eea43e64b17ba65a4c17bd3acf9dac307825deda85d5a093181dbc0","scriptpubkey_type":"v0_p2wsh","scriptpubkey_address":"bc1qpn4xpt57afp7vjchhfj6fstm6wk0nkkrq7p9mmdgt4dqjvvpm0qqlxqrns","value":1088924}],"size":383,"weight":881,"fee":18313,"status":{"confirmed":true,"block_height":674357,"block_hash":"00000000000000000008d0d007995a8bc9d60de17bd6b55e28a6e4c6918cb206","block_time":1615594996}}]"#;
    //     let expected_txs: Vec<OnchainTx> = serde_json::from_str(expected).unwrap();
    //     let expected_serialized = serde_json::to_string(&expected_txs).unwrap();

    //     assert_eq!(expected_serialized, serialized_res);
    // }
}
