use std::fmt;
use thiserror::Error;

#[derive(Debug)]
pub enum ServiceConnectivityErrorKind {
    Builder,
    Redirect,
    Status,
    Timeout,
    Request,
    Connect,
    Body,
    Decode,
    Json,
    Other,
}
impl fmt::Display for ServiceConnectivityErrorKind {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{self:?}")
    }
}

#[derive(Debug, Error)]
#[error("{kind}: {err}")]
pub struct ServiceConnectivityError {
    pub kind: ServiceConnectivityErrorKind,
    pub err: String,
}
impl ServiceConnectivityError {
    pub fn new(kind: ServiceConnectivityErrorKind, err: String) -> Self {
        ServiceConnectivityError { kind, err }
    }
}
impl From<reqwest::Error> for ServiceConnectivityError {
    fn from(err: reqwest::Error) -> Self {
        let kind = if err.is_builder() {
            ServiceConnectivityErrorKind::Builder
        } else if err.is_redirect() {
            ServiceConnectivityErrorKind::Redirect
        } else if err.is_status() {
            ServiceConnectivityErrorKind::Status
        } else if err.is_timeout() {
            ServiceConnectivityErrorKind::Timeout
        } else if err.is_request() {
            ServiceConnectivityErrorKind::Request
        } else if err.is_connect() {
            ServiceConnectivityErrorKind::Connect
        } else if err.is_body() {
            ServiceConnectivityErrorKind::Body
        } else if err.is_decode() {
            ServiceConnectivityErrorKind::Decode
        } else {
            ServiceConnectivityErrorKind::Other
        };
        Self {
            kind,
            err: err.to_string(),
        }
    }
}
