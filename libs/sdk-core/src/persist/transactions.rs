use super::db::SqliteStorage;
use crate::lnurl::pay::model::SuccessActionProcessed;
use crate::models::*;
use anyhow::{anyhow, Result};
use rusqlite::types::{FromSql, FromSqlError, ToSql, ToSqlOutput};
use rusqlite::OptionalExtension;
use rusqlite::Row;
use std::str::FromStr;

impl SqliteStorage {
    /// Inserts payments into the payments table.
    ///
    /// Note that, if a payment has details of type [LnPaymentDetails] which contain a [SuccessActionProcessed],
    /// then the [LnPaymentDetails] will NOT be persisted. In that case, the [SuccessActionProcessed]
    /// can be inserted separately via [SqliteStorage::insert_lnurl_success_action].
    pub fn insert_payments(&self, transactions: &[Payment]) -> Result<()> {
        let con = self.get_connection()?;
        let mut prep_statement = con.prepare(
            "
         INSERT OR REPLACE INTO payments (
           id,
           payment_type,                 
           payment_time,                                  
           amount_msat, 
           fee_msat,                 
           pending,
           description,
           details
         )
         VALUES (?1,?2,?3,?4,?5,?6,?7,?8)
        ",
        )?;

        for ln_tx in transactions {
            _ = prep_statement.execute((
                &ln_tx.id,
                &ln_tx.payment_type.to_string(),
                &ln_tx.payment_time,
                &ln_tx.amount_msat,
                &ln_tx.fee_msat,
                &ln_tx.pending,
                &ln_tx.description,
                &ln_tx.details,
            ))?;
        }
        Ok(())
    }

    pub fn insert_lnurl_success_action(
        &self,
        payment_hash: &str,
        sa: &SuccessActionProcessed,
    ) -> Result<()> {
        let con = self.get_connection()?;
        let mut prep_statement = con.prepare(
            "
         INSERT OR REPLACE INTO payments_external_info (
           payment_id,
           lnurl_success_action
         )
         VALUES (?1,?2)
        ",
        )?;

        _ = prep_statement.execute((payment_hash, &sa))?;

        Ok(())
    }

    pub fn last_payment_timestamp(&self) -> Result<i64> {
        self.get_connection()?
            .query_row("SELECT max(payment_time) FROM payments", [], |row| {
                row.get(0)
            })
            .map_err(anyhow::Error::msg)
    }

    /// Constructs [Payment] by joining data in the `payment` and `payments_external_info` tables
    pub fn list_payments(
        &self,
        type_filter: PaymentTypeFilter,
        from_timestamp: Option<i64>,
        to_timestamp: Option<i64>,
    ) -> Result<Vec<Payment>> {
        let where_clause = filter_to_where_clause(type_filter, from_timestamp, to_timestamp);
        let con = self.get_connection()?;
        let mut stmt = con.prepare(
            format!(
                "
            SELECT 
             p.id,
             p.payment_type,
             p.payment_time,
             p.amount_msat,
             p.fee_msat,
             p.pending,
             p.description,
             p.details,
             e.lnurl_success_action
            FROM payments p
            LEFT JOIN payments_external_info e
            ON
             p.id = e.payment_id
            {where_clause} ORDER BY payment_time DESC
          "
            )
            .as_str(),
        )?;

        let vec: Vec<Payment> = stmt
            .query_map([], |row| self.sql_row_to_payment(row))?
            .map(|i| i.unwrap())
            .collect();

        Ok(vec)
    }

    pub(crate) fn get_payment_by_hash(&self, hash: &String) -> Result<Option<Payment>> {
        self.get_connection()?
            .query_row(
                "
                SELECT
                 p.id,
                 p.payment_type,
                 p.payment_time,
                 p.amount_msat,
                 p.fee_msat,
                 p.pending,
                 p.description,
                 p.details,
                 e.lnurl_success_action
                FROM payments p
                LEFT JOIN payments_external_info e
                ON
                 p.id = e.payment_id
                WHERE
                 id = ?1",
                [hash],
                |row| self.sql_row_to_payment(row),
            )
            .optional()
            .map_err(|e| anyhow!(e))
    }

    fn sql_row_to_payment(&self, row: &Row) -> Result<Payment, rusqlite::Error> {
        let payment_type_str: String = row.get(1)?;
        let mut payment = Payment {
            id: row.get(0)?,
            payment_type: PaymentType::from_str(payment_type_str.as_str()).unwrap(),
            payment_time: row.get(2)?,
            amount_msat: row.get(3)?,
            fee_msat: row.get(4)?,
            pending: row.get(5)?,
            description: row.get(6)?,
            details: row.get(7)?,
        };

        if let PaymentDetails::Ln { ref mut data } = payment.details {
            data.lnurl_success_action = row.get(8)?;
        }

        Ok(payment)
    }
}

fn filter_to_where_clause(
    type_filter: PaymentTypeFilter,
    from_timestamp: Option<i64>,
    to_timestamp: Option<i64>,
) -> String {
    let mut where_clause: Vec<String> = Vec::new();

    if let Some(t) = from_timestamp {
        where_clause.push(format!("payment_time >= {t}"));
    };
    if let Some(t) = to_timestamp {
        where_clause.push(format!("payment_time <= {t}"));
    };

    match type_filter {
        PaymentTypeFilter::Sent => {
            where_clause.push(format!(
                "payment_type in ('{}','{}') ",
                PaymentType::Sent,
                PaymentType::ClosedChannel
            ));
        }
        PaymentTypeFilter::Received => {
            where_clause.push(format!("payment_type = '{}' ", PaymentType::Received));
        }
        PaymentTypeFilter::All => (),
    }

    let mut where_clause_str = String::new();
    if !where_clause.is_empty() {
        where_clause_str = String::from("where ");
        where_clause_str.push_str(where_clause.join(" and ").as_str());
    }
    where_clause_str
}

impl FromSql for PaymentDetails {
    fn column_result(value: rusqlite::types::ValueRef<'_>) -> rusqlite::types::FromSqlResult<Self> {
        serde_json::from_str(value.as_str()?).map_err(|_| FromSqlError::InvalidType)
    }
}

impl ToSql for PaymentDetails {
    fn to_sql(&self) -> rusqlite::Result<rusqlite::types::ToSqlOutput<'_>> {
        Ok(ToSqlOutput::from(
            serde_json::to_string(&self).map_err(|_| FromSqlError::InvalidType)?,
        ))
    }
}

impl FromSql for SuccessActionProcessed {
    fn column_result(value: rusqlite::types::ValueRef<'_>) -> rusqlite::types::FromSqlResult<Self> {
        serde_json::from_str(value.as_str()?).map_err(|_| FromSqlError::InvalidType)
    }
}

impl ToSql for SuccessActionProcessed {
    fn to_sql(&self) -> rusqlite::Result<rusqlite::types::ToSqlOutput<'_>> {
        Ok(ToSqlOutput::from(
            serde_json::to_string(&self).map_err(|_| FromSqlError::InvalidType)?,
        ))
    }
}

#[test]
fn test_ln_transactions() -> Result<(), Box<dyn std::error::Error>> {
    use crate::lnurl::pay::model::MessageSuccessActionData;
    use crate::lnurl::pay::model::SuccessActionProcessed;
    use crate::models::{LnPaymentDetails, Payment, PaymentDetails};
    use crate::persist::test_utils;

    let sa = SuccessActionProcessed::Message {
        data: MessageSuccessActionData {
            message: "test message".into(),
        },
    };

    let payment_hash_with_lnurl_success_action = "123";
    let txs = [
        Payment {
            id: payment_hash_with_lnurl_success_action.to_string(),
            payment_type: PaymentType::Sent,
            payment_time: 1001,
            amount_msat: 100,
            fee_msat: 20,
            pending: false,
            description: None,
            details: PaymentDetails::Ln {
                data: LnPaymentDetails {
                    payment_hash: payment_hash_with_lnurl_success_action.to_string(),
                    label: "label".to_string(),
                    destination_pubkey: "pubey".to_string(),
                    payment_preimage: "payment_preimage".to_string(),
                    keysend: true,
                    bolt11: "bolt11".to_string(),
                    lnurl_success_action: Some(sa.clone()),
                },
            },
        },
        Payment {
            id: "124".to_string(),
            payment_type: PaymentType::Received,
            payment_time: 1000,
            amount_msat: 100,
            fee_msat: 20,
            pending: false,
            description: Some("desc".to_string()),
            details: PaymentDetails::Ln {
                data: LnPaymentDetails {
                    payment_hash: "124".to_string(),
                    label: "label".to_string(),
                    destination_pubkey: "pubey".to_string(),
                    payment_preimage: "payment_preimage".to_string(),
                    keysend: true,
                    bolt11: "bolt11".to_string(),
                    lnurl_success_action: None,
                },
            },
        },
    ];
    let storage =
        SqliteStorage::from_file(test_utils::create_test_sql_file("transactions".to_string()));
    storage.init()?;
    storage.insert_payments(&txs)?;
    storage.insert_lnurl_success_action(payment_hash_with_lnurl_success_action, &sa)?;

    // retrieve all
    let retrieve_txs = storage.list_payments(PaymentTypeFilter::All, None, None)?;
    assert_eq!(retrieve_txs.len(), 2);
    assert_eq!(retrieve_txs, txs);

    //test only sent
    let retrieve_txs = storage.list_payments(PaymentTypeFilter::Sent, None, None)?;
    assert_eq!(retrieve_txs.len(), 1);
    assert_eq!(retrieve_txs[0], txs[0]);
    assert!(
        matches!( &retrieve_txs[0].details, PaymentDetails::Ln {data: LnPaymentDetails {lnurl_success_action, ..}} if lnurl_success_action == &Some(sa))
    );

    //test only received
    let retrieve_txs = storage.list_payments(PaymentTypeFilter::Received, None, None)?;
    assert_eq!(retrieve_txs.len(), 1);
    assert_eq!(retrieve_txs[0], txs[1]);

    let max_ts = storage.last_payment_timestamp()?;
    assert_eq!(max_ts, 1001);

    storage.insert_payments(&txs)?;
    let retrieve_txs = storage.list_payments(PaymentTypeFilter::All, None, None)?;
    assert_eq!(retrieve_txs.len(), 2);
    assert_eq!(retrieve_txs, txs);

    Ok(())
}
