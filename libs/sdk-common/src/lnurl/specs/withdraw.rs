use std::str::FromStr;

use crate::error::{ServiceConnectivityError, ServiceConnectivityErrorKind};
use crate::prelude::*;

/// Validates invoice and performs the second and last step of LNURL-withdraw, as per
/// <https://github.com/lnurl/luds/blob/luds/03.md>
///
/// See the [parse] docs for more detail on the full workflow.
///
/// Note that the invoice amount has to respect two separate min/max limits:
/// * those in the [LnUrlWithdrawRequestData] showing the limits of the LNURL endpoint, and
/// * those of the current node, depending on the LSP settings and LN channel conditions
pub async fn validate_lnurl_withdraw(
    req_data: LnUrlWithdrawRequestData,
    invoice: LNInvoice,
) -> LnUrlResult<LnUrlWithdrawResult> {
    let amount_msat = invoice.amount_msat.ok_or(LnUrlError::generic(
        "Expected invoice amount, but found none",
    ))?;

    ensure_sdk!(
        amount_msat >= req_data.min_withdrawable,
        LnUrlError::generic(
            "Amount is smaller than the minimum allowed by the LNURL-withdraw endpoint"
        )
    );
    ensure_sdk!(
        amount_msat <= req_data.max_withdrawable,
        LnUrlError::generic(
            "Amount is bigger than the maximum allowed by the LNURL-withdraw endpoint"
        )
    );

    // Send invoice to the LNURL-w endpoint via the callback
    let callback_url = build_withdraw_callback_url(&req_data, &invoice)?;
    let withdraw_status = match get_parse_and_log_response(&callback_url, false).await {
        Ok(LnUrlCallbackStatus::Ok) => LnUrlWithdrawResult::Ok {
            data: LnUrlWithdrawSuccessData { invoice },
        },
        Ok(LnUrlCallbackStatus::ErrorStatus { data }) => LnUrlWithdrawResult::ErrorStatus { data },
        Err(ServiceConnectivityError {
            kind: ServiceConnectivityErrorKind::Timeout,
            err: _,
        }) => LnUrlWithdrawResult::Timeout {
            data: LnUrlWithdrawSuccessData { invoice },
        },
        Err(e) => return Err(LnUrlError::ServiceConnectivity(e.to_string())),
    };

    Ok(withdraw_status)
}

pub fn build_withdraw_callback_url(
    req_data: &LnUrlWithdrawRequestData,
    invoice: &LNInvoice,
) -> LnUrlResult<String> {
    let mut url = reqwest::Url::from_str(&req_data.callback)
        .map_err(|e| LnUrlError::InvalidUri(e.to_string()))?;

    url.query_pairs_mut().append_pair("k1", &req_data.k1);
    url.query_pairs_mut().append_pair("pr", &invoice.bolt11);

    Ok(url.to_string())
}

pub mod model {
    use serde::{Deserialize, Serialize};
    use thiserror::Error;

    use crate::prelude::*;

    #[derive(Debug, Serialize, Deserialize)]
    pub struct LnUrlWithdrawRequest {
        /// Request data containing information on how to call the lnurl withdraw
        /// endpoint. Typically retrieved by calling `parse()` on a lnurl withdraw
        /// input.
        pub data: LnUrlWithdrawRequestData,

        /// The amount to withdraw from the lnurl withdraw endpoint. Must be between
        /// `min_withdrawable` and `max_withdrawable`.
        pub amount_msat: u64,

        /// Optional description that will be put in the payment request for the
        /// lnurl withdraw endpoint.
        pub description: Option<String>,
    }

    /// Wrapped in a [LnUrlWithdraw], this is the result of [parse] when given a LNURL-withdraw endpoint.
    ///
    /// It represents the endpoint's parameters for the LNURL workflow.
    ///
    /// See <https://github.com/lnurl/luds/blob/luds/03.md>
    #[derive(Clone, Deserialize, Debug, Serialize)]
    #[serde(rename_all = "camelCase")]
    pub struct LnUrlWithdrawRequestData {
        pub callback: String,
        pub k1: String,
        pub default_description: String,
        /// The minimum amount, in millisats, that this LNURL-withdraw endpoint accepts
        pub min_withdrawable: u64,
        /// The maximum amount, in millisats, that this LNURL-withdraw endpoint accepts
        pub max_withdrawable: u64,
    }

    /// [LnUrlCallbackStatus] specific to LNURL-withdraw, where the success case contains the invoice.
    #[derive(Clone, Serialize)]
    pub enum LnUrlWithdrawResult {
        Ok { data: LnUrlWithdrawSuccessData },
        Timeout { data: LnUrlWithdrawSuccessData },
        ErrorStatus { data: LnUrlErrorData },
    }

    #[derive(Clone, Deserialize, Debug, Serialize)]
    pub struct LnUrlWithdrawSuccessData {
        pub invoice: LNInvoice,
    }

    #[derive(Debug, Error)]
    pub enum LnUrlWithdrawError {
        /// This error is raised when a general error occurs not specific to other error variants
        /// in this enum.
        #[error("Generic: {err}")]
        Generic { err: String },

        /// This error is raised when the amount is zero or the amount does not cover
        /// the cost to open a new channel.
        #[error("Invalid amount: {err}")]
        InvalidAmount { err: String },

        /// This error is raised when the lightning invoice cannot be parsed.
        #[error("Invalid invoice: {err}")]
        InvalidInvoice { err: String },

        /// This error is raised when the decoded LNURL URI is not compliant to the specification.
        #[error("Invalid uri: {err}")]
        InvalidUri { err: String },

        /// This error is raised when no routing hints were able to be added to the invoice
        /// while trying to receive a payment.
        #[error("No routing hints: {err}")]
        InvoiceNoRoutingHints { err: String },

        /// This error is raised when a connection to an external service fails.
        #[error("Service connectivity: {err}")]
        ServiceConnectivity { err: String },
    }

    impl From<InvoiceError> for LnUrlWithdrawError {
        fn from(value: InvoiceError) -> Self {
            match value {
                InvoiceError::Validation(err) => Self::InvalidInvoice { err },
                _ => Self::Generic {
                    err: value.to_string(),
                },
            }
        }
    }

    impl From<LnUrlError> for LnUrlWithdrawError {
        fn from(value: LnUrlError) -> Self {
            match value {
                LnUrlError::Generic(err) => Self::Generic { err },
                LnUrlError::InvalidUri(err) => Self::InvalidUri { err },
                LnUrlError::InvalidInvoice(err) => Self::InvalidInvoice { err },
                LnUrlError::ServiceConnectivity(err) => Self::ServiceConnectivity { err },
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use anyhow::Result;
    use mockito::Mock;

    use crate::input_parser::tests::MOCK_HTTP_SERVER;
    use crate::lnurl::tests::rand_string;
    use crate::prelude::*;

    #[tokio::test]
    async fn test_lnurl_withdraw_validate_amount_failure() -> Result<()> {
        let invoice_str = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";
        let invoice = crate::invoice::parse_invoice(invoice_str)?;
        let withdraw_req = get_test_withdraw_req_data(0, 1);

        // Fail validation before even calling the endpoint (no mock needed)
        assert!(validate_lnurl_withdraw(withdraw_req, invoice)
            .await
            .is_err());

        Ok(())
    }

    /// Mock an LNURL-withdraw endpoint that responds with an OK to a withdraw attempt
    fn mock_lnurl_withdraw_callback(
        withdraw_req: &LnUrlWithdrawRequestData,
        invoice: &LNInvoice,
        error: Option<String>,
    ) -> Result<Mock> {
        let callback_url = build_withdraw_callback_url(withdraw_req, invoice)?;
        let url = reqwest::Url::parse(&callback_url)?;
        let mockito_path: &str = &format!("{}?{}", url.path(), url.query().unwrap());

        let expected_payload = r#"
            {"status": "OK"}
        "#
        .replace('\n', "");

        let response_body = match error {
            None => expected_payload,
            Some(err_reason) => {
                ["{\"status\": \"ERROR\", \"reason\": \"", &err_reason, "\"}"].join("")
            }
        };

        let mut server = MOCK_HTTP_SERVER.lock().unwrap();
        Ok(server
            .mock("GET", mockito_path)
            .with_body(response_body)
            .create())
    }

    fn get_test_withdraw_req_data(min_sat: u64, max_sat: u64) -> LnUrlWithdrawRequestData {
        LnUrlWithdrawRequestData {
            min_withdrawable: min_sat * 1000,
            max_withdrawable: max_sat * 1000,
            k1: rand_string(10),
            default_description: "test description".into(),
            callback: "http://127.0.0.1:8080/callback".into(),
        }
    }

    #[tokio::test]
    async fn test_lnurl_withdraw_success() -> Result<()> {
        let invoice_str = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";
        let req_invoice = crate::invoice::parse_invoice(invoice_str)?;
        let withdraw_req = get_test_withdraw_req_data(0, 100);

        let _m = mock_lnurl_withdraw_callback(&withdraw_req, &req_invoice, None)?;

        assert!(matches!(
            validate_lnurl_withdraw(withdraw_req, req_invoice.clone()).await?,
            LnUrlWithdrawResult::Ok { data: LnUrlWithdrawSuccessData { invoice } } if invoice == req_invoice
        ));

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_withdraw_endpoint_failure() -> Result<()> {
        let invoice_str = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";
        let invoice = crate::invoice::parse_invoice(invoice_str)?;
        let withdraw_req = get_test_withdraw_req_data(0, 100);

        // Generic error reported by endpoint
        let _m = mock_lnurl_withdraw_callback(&withdraw_req, &invoice, Some("error".parse()?))?;

        assert!(matches!(
            validate_lnurl_withdraw(withdraw_req, invoice).await?,
            LnUrlWithdrawResult::ErrorStatus { data: _ }
        ));

        Ok(())
    }
}
