use log::*;
use reqwest::StatusCode;
use std::time::Duration;

use crate::error::{ServiceConnectivityError, ServiceConnectivityErrorKind};

/// Creates an HTTP client with a built-in connection timeout
pub fn get_reqwest_client() -> Result<reqwest::Client, ServiceConnectivityError> {
    reqwest::Client::builder()
        .timeout(Duration::from_secs(30))
        .build()
        .map_err(Into::into)
}

pub async fn post_and_log_response(
    url: &str,
    body: Option<String>,
) -> Result<String, ServiceConnectivityError> {
    debug!("Making POST request to: {url}");

    let mut req = get_reqwest_client()?.post(url);
    if let Some(body) = body {
        req = req.body(body);
    }
    let raw_body = req.send().await?.text().await?;
    debug!("Received raw response body: {raw_body}");

    Ok(raw_body)
}

/// Makes a GET request to the specified `url` and logs on DEBUG:
/// - the URL
/// - the raw response body
/// - the response HTTP status code
pub async fn get_and_log_response(
    url: &str,
) -> Result<(String, StatusCode), ServiceConnectivityError> {
    debug!("Making GET request to: {url}");

    let response = get_reqwest_client()?.get(url).send().await?;
    let status = response.status();
    let raw_body = response.text().await?;
    debug!("Received response, status: {status}, raw response body: {raw_body}");

    Ok((raw_body, status))
}

/// Wrapper around [get_and_log_response] that, in addition, parses the payload into an expected type.
///
/// ### Arguments
///
/// - `url`: the URL on which GET will be called
/// - `enforce_status_check`: if true, the HTTP status code is checked in addition to trying to
/// parse the payload. In this case, an HTTP error code will automatically cause this function to
/// return `Err`, regardless of the payload. If false, the result type will be determined only
/// by the result of parsing the payload into the desired target type.
pub async fn get_parse_and_log_response<T>(
    url: &str,
    enforce_status_check: bool,
) -> Result<T, ServiceConnectivityError>
where
    for<'a> T: serde::de::Deserialize<'a>,
{
    let (raw_body, status) = get_and_log_response(url).await?;
    if enforce_status_check && !status.is_success() {
        let err = format!("GET request {url} failed with status: {status}");
        error!("{err}");
        return Err(ServiceConnectivityError::new(
            ServiceConnectivityErrorKind::Status,
            err,
        ));
    }

    serde_json::from_str::<T>(&raw_body).map_err(|e| {
        ServiceConnectivityError::new(ServiceConnectivityErrorKind::Json, e.to_string())
    })
}
