use super::{db::SqliteStorage, error::PersistResult};
use crate::{FullReverseSwapInfo, ReverseSwapInfoCached, ReverseSwapStatus};
use rusqlite::{named_params, OptionalExtension, Row, TransactionBehavior};

impl SqliteStorage {
    pub(crate) fn insert_reverse_swap(&self, rsi: &FullReverseSwapInfo) -> PersistResult<()> {
        let mut con = self.get_connection()?;
        let tx = con.transaction_with_behavior(TransactionBehavior::Immediate)?;

        tx.execute(
            "INSERT INTO sync.reverse_swaps (id, created_at_block_height, preimage, private_key, claim_pubkey, timeout_block_height, invoice, onchain_amount_sat, sat_per_vbyte, receive_amount_sat, redeem_script)\
            VALUES (:id, :created_at_block_height, :preimage, :private_key, :claim_pubkey, :timeout_block_height, :invoice, :onchain_amount_sat, :sat_per_vbyte, :receive_amount_sat, :redeem_script)",
            named_params! {
                ":id": rsi.id,
                ":created_at_block_height": rsi.created_at_block_height,
                ":preimage": rsi.preimage,
                ":private_key": rsi.private_key,
                ":claim_pubkey": rsi.claim_pubkey,
                ":timeout_block_height": rsi.timeout_block_height,
                ":invoice": rsi.invoice,
                ":onchain_amount_sat": rsi.onchain_amount_sat,
                ":sat_per_vbyte": rsi.sat_per_vbyte,
                ":receive_amount_sat": rsi.receive_amount_sat,
                ":redeem_script": rsi.redeem_script
            },
        )?;

        tx.execute(
            "INSERT INTO reverse_swaps_info (id, status)\
            VALUES (:id, :status)",
            named_params! {
                ":id": rsi.id,
                ":status": serde_json::to_value(rsi.cache.status)?
            },
        )?;

        tx.commit()?;
        Ok(())
    }

    pub(crate) fn update_reverse_swap_status(
        &self,
        id: &str,
        status: &ReverseSwapStatus,
    ) -> PersistResult<()> {
        debug!("Persisting new status for reverse swap {id} to be {status:?}");

        self.get_connection()?.execute(
            "INSERT OR REPLACE INTO reverse_swaps_info(id, status) VALUES(:id, :status)",
            named_params! {
             ":status": serde_json::to_value(status)?,
             ":id": id,
            },
        )?;

        Ok(())
    }

    pub(crate) fn update_reverse_swap_lockup_txid(
        &self,
        id: &str,
        lockup_txid: Option<String>,
    ) -> PersistResult<()> {
        debug!("Updating lockup_txid for reverse swap {id} to be - lockup_txid: {lockup_txid:?}");

        self.get_connection()?.execute(
            "UPDATE reverse_swaps_info SET lockup_txid = :lockup_txid WHERE id = :id",
            named_params! {
             ":id": id,
             ":lockup_txid": lockup_txid,
            },
        )?;

        Ok(())
    }

    pub(crate) fn update_reverse_swap_claim_txid(
        &self,
        id: &str,
        claim_txid: Option<String>,
    ) -> PersistResult<()> {
        debug!("Updating claim_txid for reverse swap {id} to be - claim_txid: {claim_txid:?}");

        self.get_connection()?.execute(
            "UPDATE reverse_swaps_info SET claim_txid = :claim_txid WHERE id = :id",
            named_params! {
             ":id": id,
             ":claim_txid": claim_txid,
            },
        )?;

        Ok(())
    }

    pub(crate) fn get_reverse_swap(&self, id: &str) -> PersistResult<Option<FullReverseSwapInfo>> {
        Ok(self
            .get_connection()?
            .query_row(
                &self.select_reverse_swap_query("reverse_swaps.id = ?1", ""),
                [id],
                |row| self.sql_row_to_reverse_swap(row, ""),
            )
            .optional()?)
    }

    pub(crate) fn list_reverse_swaps(&self) -> PersistResult<Vec<FullReverseSwapInfo>> {
        let con = self.get_connection()?;
        let mut stmt = con.prepare(&self.select_reverse_swap_query("true", ""))?;

        let vec: Vec<FullReverseSwapInfo> = stmt
            .query_map([], |row| self.sql_row_to_reverse_swap(row, ""))?
            .map(|i| i.unwrap())
            .collect();

        Ok(vec)
    }

    pub(crate) fn select_reverse_swap_fields(&self, prefix: &str) -> String {
        format!(
            "        
        {prefix}id,
        {prefix}created_at_block_height,
        {prefix}preimage,
        {prefix}private_key,
        {prefix}timeout_block_height,
        {prefix}claim_pubkey,
        {prefix}invoice,
        {prefix}onchain_amount_sat,
        {prefix}sat_per_vbyte,
        {prefix}receive_amount_sat,
        {prefix}redeem_script,
        {prefix}status,
        {prefix}lockup_txid,
        {prefix}claim_txid           
        "
        )
    }

    pub(crate) fn sql_row_to_reverse_swap(
        &self,
        row: &Row,
        prefix: &str,
    ) -> PersistResult<FullReverseSwapInfo, rusqlite::Error> {
        Ok(FullReverseSwapInfo {
            id: row.get(format!("{prefix}id").as_str())?,
            created_at_block_height: row
                .get(format!("{prefix}created_at_block_height").as_str())?,
            preimage: row.get(format!("{prefix}preimage").as_str())?,
            private_key: row.get(format!("{prefix}private_key").as_str())?,
            timeout_block_height: row.get(format!("{prefix}timeout_block_height").as_str())?,
            claim_pubkey: row.get(format!("{prefix}claim_pubkey").as_str())?,
            invoice: row.get(format!("{prefix}invoice").as_str())?,
            onchain_amount_sat: row.get(format!("{prefix}onchain_amount_sat").as_str())?,
            sat_per_vbyte: row.get(format!("{prefix}sat_per_vbyte").as_str())?,
            receive_amount_sat: row.get(format!("{prefix}receive_amount_sat").as_str())?,
            redeem_script: row.get(format!("{prefix}redeem_script").as_str())?,
            cache: ReverseSwapInfoCached {
                // The status is stored in the main DB, which is empty when the node is restored.
                // We therefore default to the Initial state. This will be updated at the end of sync().
                status: serde_json::from_value(row.get(format!("{prefix}status").as_str())?)
                    .unwrap_or(ReverseSwapStatus::Initial),
                lockup_txid: row.get(format!("{prefix}lockup_txid").as_str())?,
                claim_txid: row.get(format!("{prefix}claim_txid").as_str())?,
            },
        })
    }

    pub(crate) fn select_reverse_swap_query(&self, where_clause: &str, prefix: &str) -> String {
        let fields = format!(
            "        
            reverse_swaps.id as {prefix}id,
            created_at_block_height as {prefix}created_at_block_height,
            preimage as {prefix}preimage,
            private_key as {prefix}private_key,
            timeout_block_height as {prefix}timeout_block_height,
            claim_pubkey as {prefix}claim_pubkey,
            invoice as {prefix}invoice,
            onchain_amount_sat as {prefix}onchain_amount_sat,
            sat_per_vbyte as {prefix}sat_per_vbyte,
            receive_amount_sat as {prefix}receive_amount_sat,
            redeem_script as {prefix}redeem_script,
            status as {prefix}status,
            lockup_txid as {prefix}lockup_txid,
            claim_txid as {prefix}claim_txid         
            "
        );

        format!(
            "
            SELECT
             {fields}
            FROM sync.reverse_swaps
             LEFT JOIN reverse_swaps_info ON reverse_swaps.id = reverse_swaps_info.id
            WHERE {}
            ",
            where_clause
        )
    }
}
