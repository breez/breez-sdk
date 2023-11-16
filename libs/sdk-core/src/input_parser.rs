use std::str::FromStr;

use anyhow::{anyhow, Result};
use bip21::Uri;
use bitcoin::bech32;
use bitcoin::bech32::FromBase32;
use lightning::offers::offer::Offer;
use serde::Deserialize;
use serde::Serialize;

use crate::ensure_sdk;
use crate::input_parser::InputType::*;
use crate::input_parser::LnUrlRequestData::*;
use crate::invoice::{parse_invoice, LNInvoice, LNOffer};

use crate::lnurl::error::LnUrlResult;
use crate::lnurl::maybe_replace_host_with_mockito_test_host;

/// Parses generic user input, typically pasted from clipboard or scanned from a QR.
///
/// # Examples
///
/// ## On-chain BTC addresses (incl. BIP 21 URIs)
///
/// ```
/// use breez_sdk_core::{InputType::*, parse};
///
/// #[tokio::main]
/// async fn main() {
///     assert!(matches!( parse("1andreas3batLhQa2FawWjeyjCqyBzypd").await, Ok(BitcoinAddress{address: _}) ));
///     assert!(matches!( parse("1andreas3batLhQa2FawWjeyjCqyBzypd?amount=0.00002000").await, Ok(BitcoinAddress{address: _}) ));
///     assert!(matches!( parse("1andreas3batLhQa2FawWjeyjCqyBzypd?amount=0.00002000&label=Hello").await, Ok(BitcoinAddress{address: _}) ));
///     assert!(matches!( parse("1andreas3batLhQa2FawWjeyjCqyBzypd?amount=0.00002000&label=Hello&message=Msg").await, Ok(BitcoinAddress{address: _}) ));
///
///     assert!(matches!( parse("bitcoin:1andreas3batLhQa2FawWjeyjCqyBzypd").await, Ok(BitcoinAddress{address: _}) ));
///     assert!(matches!( parse("bitcoin:1andreas3batLhQa2FawWjeyjCqyBzypd?amount=0.00002000").await, Ok(BitcoinAddress{address: _}) ));
///     assert!(matches!( parse("bitcoin:1andreas3batLhQa2FawWjeyjCqyBzypd?amount=0.00002000&label=Hello").await, Ok(BitcoinAddress{address: _}) ));
///     assert!(matches!( parse("bitcoin:1andreas3batLhQa2FawWjeyjCqyBzypd?amount=0.00002000&label=Hello&message=Msg").await, Ok(BitcoinAddress{address: _}) ));
/// }
/// ```
///
/// ## BOLT 11 invoices
///
/// ```
/// use breez_sdk_core::{InputType::*, parse};
///
/// #[tokio::main]
/// async fn main() {
///     let invoice = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";
///     assert!(matches!( parse(invoice).await, Ok(Bolt11{invoice: _}) ));
///     assert!(matches!( parse( &format!("lightning:{}", invoice) ).await, Ok(Bolt11{invoice: _}) ));
///
///     // BIP 21 with LN fallback parses to a LN invoice
///     let btc_address = "1andreas3batLhQa2FawWjeyjCqyBzypd";
///     assert!(matches!( parse( &format!("bitcoin:{}?lightning={}", btc_address, invoice) ).await, Ok(Bolt11{invoice: _}) ));
/// }
/// ```
///
/// ## Web URLs
///
/// ```
/// use breez_sdk_core::{InputType::*, parse};
///
/// #[tokio::main]
/// async fn main() {
///     assert!(matches!( parse("https://breez.technology").await, Ok(Url{url: _}) ));
///     assert!(matches!( parse("https://breez.technology/test-path").await, Ok(Url{url: _}) ));
///     assert!(matches!( parse("https://breez.technology/test-path?arg=val").await, Ok(Url{url: _}) ));
/// }
/// ```
///
/// ## LNURL
///
/// Both the bech32 and the raw (non-bech32, but with specific prefixes) variants are supported.
///
///
/// ### LNURL pay request
///
/// ```no_run
/// use breez_sdk_core::{InputType::*, LnUrlRequestData::*, parse};
/// use anyhow::Result;
///
/// #[tokio::main]
/// async fn main() -> Result<()> {
///     let lnurl_pay_url = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf";
///
///     assert!(matches!( parse(lnurl_pay_url).await, Ok(LnUrlPay{data: _}) ));
///     // assert!(matches!( parse("lnurlp://domain.com/lnurl-pay?key=val").await, Ok(LnUrlPay{data: _}) ));
///     // assert!(matches!( parse("lightning@address.com").await, Ok(LnUrlPay{data: _}) ));
///
///     if let Ok(LnUrlPay{data: pd}) = parse(lnurl_pay_url).await {
///         assert_eq!(pd.callback, "https://localhost/lnurl-pay/callback/db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7");
///         assert_eq!(pd.max_sendable, 16000); // Max sendable amount, in msats
///         assert_eq!(pd.max_sendable_sats(), 16); // Max sendable amount, in sats
///         assert_eq!(pd.min_sendable, 4000); // Min sendable amount, in msats
///         assert_eq!(pd.min_sendable_sats(), 4); // Min sendable amount, in sats
///         assert_eq!(pd.comment_allowed, 0);
///         assert_eq!(pd.metadata_vec()?.len(), 3);
///     }
///
///     Ok(())
/// }
/// ```
///
/// ### LNURL withdraw request
///
/// ```no_run
/// use breez_sdk_core::{InputType::*, LnUrlRequestData::*, parse};
///
/// #[tokio::main]
/// async fn main() {
///     let lnurl_withdraw_url = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk";
///
///     assert!(matches!( parse(lnurl_withdraw_url).await, Ok(LnUrlWithdraw{data: _}) ));
///     // assert!(matches!( parse("lnurlw://domain.com/lnurl-withdraw?key=val").await, Ok(LnUrlWithdraw{data: _} ));
///
///     if let Ok(LnUrlWithdraw{data: wd}) = parse(lnurl_withdraw_url).await {
///         assert_eq!(wd.callback, "https://localhost/lnurl-withdraw/callback/e464f841c44dbdd86cee4f09f4ccd3ced58d2e24f148730ec192748317b74538");
///         assert_eq!(wd.k1, "37b4c919f871c090830cc47b92a544a30097f03430bc39670b8ec0da89f01a81");
///         assert_eq!(wd.min_withdrawable, 3000); // Min withdrawable amount, in msats
///         assert_eq!(wd.min_withdrawable_sats(), 3); // Min withdrawable amount, in sats
///         assert_eq!(wd.max_withdrawable, 12000); // Max withdrawable amount, in msats
///         assert_eq!(wd.max_withdrawable_sats(), 12); // Max withdrawable amount, in sats
///         assert_eq!(wd.default_description, "sample withdraw");
///     }
/// }
/// ```
///
/// ### LNURL auth request
///
/// ```no_run
/// use breez_sdk_core::{InputType::*, LnUrlRequestData::*, parse};
///
/// #[tokio::main]
/// async fn main() {
///     let lnurl_auth_url = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu";
///
///     assert!(matches!( parse(lnurl_auth_url).await, Ok(LnUrlAuth{data: _}) ));
///     // assert!(matches!( parse("keyauth://domain.com/auth?key=val").await, Ok(LnUrlAuth{data: _}) ));
///
///     if let Ok(LnUrlAuth{data: ad}) = parse(lnurl_auth_url).await {
///         assert_eq!(ad.k1, "1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822");
///     }
/// }
/// ```

pub async fn parse(input: &str) -> Result<InputType> {
    let input = input.trim();

    // Covers BIP 21 URIs and simple onchain BTC addresses (which are valid BIP 21 with the 'bitcoin:' prefix)
    if let Ok(bip21_uri) = prepend_if_missing("bitcoin:", input).parse::<Uri<'_>>() {
        let bitcoin_addr_data = bip21_uri.into();

        // Special case of LN BOLT11 with onchain fallback
        // Search for the `lightning=bolt11` param in the BIP21 URI and, if found, extract the bolt11
        let mut invoice_param: Option<LNInvoice> = None;
        if let Some(query) = input.split('?').collect::<Vec<_>>().get(1) {
            invoice_param = querystring::querify(query)
                .iter()
                .find(|(key, _)| key == &"lightning")
                .map(|(_, value)| parse_invoice(value))
                .transpose()?;
        }

        return match invoice_param {
            None => Ok(BitcoinAddress {
                address: bitcoin_addr_data,
            }),
            Some(invoice) => Ok(Bolt11 { invoice }),
        };
    }

    if let Ok(invoice) = parse_invoice(input) {
        return Ok(Bolt11 { invoice });
    }

    if let Ok(offer) = input.parse::<Offer>() {
        return Ok(Bolt12Offer {
            offer: LNOffer {
                chains: offer
                    .chains()
                    .iter()
                    .map(|chain| chain.to_string())
                    .collect(),
                amount: offer.amount().map(|amount| amount.clone().into()),
                description: offer.description().to_string(),
                absolute_expiry: offer.absolute_expiry().map(|expiry| expiry.as_secs()),
                issuer: offer.issuer().map(|s| s.to_string()),
                supported_quantity: offer.supported_quantity().into(),
                signing_pubkey: offer.signing_pubkey().to_string(),
                metadata: offer.metadata().cloned(),
            },
        });
    }

    // Public key serialized in compressed form (66 hex chars)
    if let Ok(_node_id) = bitcoin::secp256k1::PublicKey::from_str(input) {
        return Ok(NodeId {
            node_id: input.into(),
        });
    }

    // Possible Node URI (check for separator symbol, try to parse pubkey, ignore rest)
    if let Some('@') = input.chars().nth(66) {
        if let Ok(_node_id) = bitcoin::secp256k1::PublicKey::from_str(&input[..66]) {
            return Ok(NodeId {
                node_id: input.into(),
            });
        }
    }

    if let Ok(url) = reqwest::Url::parse(input) {
        if ["http", "https"].contains(&url.scheme()) {
            return Ok(Url { url: input.into() });
        }
    }

    // Try to strip the "lightning:" prefix from possible lnurl string. If prefix is not there, default to original input
    let input = input.strip_prefix("lightning:").unwrap_or(input);
    if let Ok((domain, mut lnurl_endpoint, is_ln_address)) = lnurl_decode(input) {
        // For LNURL-auth links, their type is already known if the link contains the login tag
        // No need to query the endpoint for details
        if lnurl_endpoint.contains("tag=login") {
            return Ok(LnUrlAuth {
                data: crate::lnurl::auth::validate_request(domain, lnurl_endpoint)?,
            });
        }

        lnurl_endpoint = maybe_replace_host_with_mockito_test_host(lnurl_endpoint)?;
        let lnurl_data: LnUrlRequestData = get_parse_and_log_response(&lnurl_endpoint)
            .await
            .map_err(|_| anyhow!("Failed to parse response"))?;
        let temp = lnurl_data.into();
        let temp = match temp {
            // Modify the LnUrlPay payload by adding the domain of the LNURL endpoint
            LnUrlPay { data } => LnUrlPay {
                data: LnUrlPayRequestData {
                    domain,
                    ln_address: match is_ln_address {
                        true => Some(input.to_string()),
                        false => None,
                    },
                    ..data
                },
            },
            _ => temp,
        };

        return Ok(temp);
    }

    Err(anyhow!("Unrecognized input type"))
}

/// Makes a GET request to the specified `url` and logs on DEBUG:
/// - the URL
/// - the raw response body
pub(crate) async fn get_and_log_response(url: &str) -> Result<String> {
    debug!("Making GET request to: {url}");

    let raw_body = reqwest::get(url).await?.text().await?;
    debug!("Received raw response body: {raw_body}");

    Ok(raw_body)
}

/// Wrapper around [get_and_log_response] that, in addition, parses the payload into an expected type
pub(crate) async fn get_parse_and_log_response<T>(url: &str) -> Result<T>
where
    for<'a> T: serde::de::Deserialize<'a>,
{
    let raw_body = get_and_log_response(url).await?;

    Ok(serde_json::from_str(&raw_body)?)
}

/// Prepends the given prefix to the input, if the input doesn't already start with it
fn prepend_if_missing(prefix: &str, input: &str) -> String {
    format!("{}{}", prefix, input.trim_start_matches(prefix))
}

/// Converts the LN Address to the corresponding LNURL-pay endpoint, as per LUD-16:
///
/// - https://<domain>/.well-known/lnurlp/<username> for clearnet domains
/// - http://<domain>/.well-known/lnurlp/<username> for onion domains
///
/// Valid characters for the username are `a-z0-9-_.`
///
/// The result is a tuple of (domain, LNURL-pay endpoint)
fn ln_address_decode(ln_address: &str) -> Result<(String, String)> {
    if ln_address.contains('@') {
        let split = ln_address.split('@').collect::<Vec<&str>>();
        let user = split[0];
        let domain = split[1];

        if user.to_lowercase() != user {
            return Err(anyhow!("Invalid username"));
        }

        if !user
            .chars()
            .all(|c| c.is_alphanumeric() || ['-', '_', '.'].contains(&c))
        {
            return Err(anyhow!("Invalid username"));
        }

        let schema = match domain.ends_with(".onion") {
            true => "http://",
            false => "https://",
        };

        return Ok((
            domain.into(),
            format!("{schema}{domain}/.well-known/lnurlp/{user}"),
        ));
    }

    Err(anyhow!("Invalid LN address"))
}

/// Decodes the input to a human-readable http or https LNURL. Returns a tuple of (domain, url, is_ln_address).
///
/// It can handle three kinds of input:
///
/// - bech32-based (LUD-01), like LNURL1...
/// - LN addresses (LUD-16), like user@domain.com
/// - prefix-based (LUD-17), like lnurlp:// or lnurlp:
///
/// ## Validation notes
///
/// For bech32-encoded LNURLs, the only allowed schemes are http (for onion domains) and https (for clearnet domains).
///
/// LNURLs in all uppercase or all lowercase are valid, but mixed case ones are invalid.
///
/// For LN addresses, the username is limited to `a-z0-9-_.`, which is more restrictive than email addresses.
fn lnurl_decode(encoded: &str) -> LnUrlResult<(String, String, bool)> {
    if let Ok((domain, url)) = ln_address_decode(encoded) {
        return Ok((domain, url, true));
    }

    match bech32::decode(encoded) {
        Ok((_hrp, payload, _variant)) => {
            let decoded = String::from_utf8(Vec::from_base32(&payload)?)?;

            let url = reqwest::Url::parse(&decoded)
                .map_err(|e| super::lnurl::error::LnUrlError::InvalidUri(anyhow::Error::new(e)))?;
            let domain = url.domain().ok_or_else(|| {
                super::lnurl::error::LnUrlError::InvalidUri(anyhow!("Could not determine domain"))
            })?;

            if url.scheme() == "http" && !domain.ends_with(".onion") {
                return Err(super::lnurl::error::LnUrlError::Generic(anyhow!(
                    "HTTP scheme only allowed for onion domains"
                )));
            }
            if url.scheme() == "https" && domain.ends_with(".onion") {
                return Err(super::lnurl::error::LnUrlError::Generic(anyhow!(
                    "HTTPS scheme not allowed for onion domains"
                )));
            }

            Ok((domain.into(), decoded, false))
        }
        Err(_) => {
            let supported_prefixes = ["lnurlp", "lnurlw", "keyauth"];
            let mut encoded = encoded.to_string();

            // Treat prefix: and prefix:// the same, to cover both vendor implementations
            // https://github.com/lnbits/lnbits/pull/762#issue-1309702380
            for pref in supported_prefixes {
                let scheme_simple = &format!("{pref}:");
                let scheme_authority = &format!("{pref}://");
                if encoded.starts_with(scheme_simple) && !encoded.starts_with(scheme_authority) {
                    encoded = encoded.replace(scheme_simple, scheme_authority);
                    break;
                }
            }

            let url = reqwest::Url::parse(&encoded)
                .map_err(|e| super::lnurl::error::LnUrlError::InvalidUri(anyhow::Error::new(e)))?;
            let domain = url.domain().ok_or_else(|| {
                super::lnurl::error::LnUrlError::InvalidUri(anyhow!("Could not determine domain"))
            })?;
            ensure_sdk!(
                supported_prefixes.contains(&url.scheme()),
                super::lnurl::error::LnUrlError::Generic(anyhow!("Invalid prefix scheme"))
            );

            let scheme = url.scheme();
            let new_scheme = match domain.ends_with(".onion") {
                true => "http",
                false => "https",
            };

            Ok((domain.into(), encoded.replace(scheme, new_scheme), false))
        }
    }
}

/// Different kinds of inputs supported by [parse], including any relevant details extracted from the input
#[derive(Debug, Serialize)]
pub enum InputType {
    /// # Supported standards
    ///
    /// - plain on-chain BTC address
    /// - BIP21
    BitcoinAddress {
        address: BitcoinAddressData,
    },

    /// Also covers URIs like `bitcoin:...&lightning=bolt11`. In this case, it returns the BOLT11
    /// and discards all other data.
    Bolt11 {
        invoice: LNInvoice,
    },
    Bolt12Offer {
        offer: LNOffer,
    },
    NodeId {
        node_id: String,
    },
    Url {
        url: String,
    },

    /// # Supported standards
    ///
    /// - LUD-01 LNURL bech32 encoding
    /// - LUD-06 `payRequest` spec
    /// - LUD-16 LN Address
    /// - LUD-17 Support for lnurlp prefix with non-bech32-encoded LNURL URLs
    LnUrlPay {
        data: LnUrlPayRequestData,
    },

    /// # Supported standards
    ///
    /// - LUD-01 LNURL bech32 encoding
    /// - LUD-03 `withdrawRequest` spec
    /// - LUD-17 Support for lnurlw prefix with non-bech32-encoded LNURL URLs
    ///
    /// # Not supported (yet)
    ///
    /// - LUD-14 `balanceCheck`: reusable `withdrawRequest`s
    /// - LUD-19 Pay link discoverable from withdraw link
    LnUrlWithdraw {
        data: LnUrlWithdrawRequestData,
    },

    /// # Supported standards
    ///
    /// - LUD-01 LNURL bech32 encoding
    /// - LUD-04 `auth` base spec
    /// - LUD-17 Support for keyauth prefix with non-bech32-encoded LNURL URLs
    LnUrlAuth {
        data: LnUrlAuthRequestData,
    },

    LnUrlError {
        data: LnUrlErrorData,
    },
}

/// Generic struct containing the possible LNURL payloads returned when contacting a LNURL endpoint
// The uniffi bindings only supports enums with named fields.
// We use #[serde(flatten)] to map the JSON payload fields to the inner enum "data" field
// https://serde.rs/attr-flatten.html
#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
#[serde(untagged)]
pub enum LnUrlRequestData {
    PayRequest {
        #[serde(flatten)]
        data: LnUrlPayRequestData,
    },
    WithdrawRequest {
        #[serde(flatten)]
        data: LnUrlWithdrawRequestData,
    },
    #[serde(rename = "login")]
    AuthRequest {
        #[serde(flatten)]
        data: LnUrlAuthRequestData,
    },
    Error {
        #[serde(flatten)]
        data: LnUrlErrorData,
    },
}

impl From<LnUrlRequestData> for InputType {
    fn from(lnurl_data: LnUrlRequestData) -> Self {
        match lnurl_data {
            PayRequest { data } => LnUrlPay { data },
            WithdrawRequest { data } => LnUrlWithdraw { data },
            AuthRequest { data } => LnUrlAuth { data },
            Error { data } => LnUrlError { data },
        }
    }
}

/// Wrapped in a [LnUrlError], this represents a LNURL-endpoint error.
#[derive(Deserialize, Debug, Serialize)]
pub struct LnUrlErrorData {
    pub reason: String,
}

/// Wrapped in a [LnUrlPay], this is the result of [parse] when given a LNURL-pay endpoint.
///
/// It represents the endpoint's parameters for the LNURL workflow.
///
/// See https://github.com/lnurl/luds/blob/luds/06.md
#[derive(Clone, Deserialize, Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct LnUrlPayRequestData {
    pub callback: String,
    /// The minimum amount, in millisats, that this LNURL-pay endpoint accepts
    pub min_sendable: u64,
    /// The maximum amount, in millisats, that this LNURL-pay endpoint accepts
    pub max_sendable: u64,
    /// As per LUD-06, `metadata` is a raw string (e.g. a json representation of the inner map).
    /// Use `metadata_vec()` to get the parsed items.
    #[serde(rename(deserialize = "metadata"))]
    pub metadata_str: String,
    /// The comment length accepted by this endpoint
    ///
    /// See https://github.com/lnurl/luds/blob/luds/12.md
    #[serde(default)]
    pub comment_allowed: u16,

    /// Indicates the domain of the LNURL-pay service, to be shown to the user when asking for
    /// payment input, as per LUD-06 spec.
    ///
    /// Note: this is not the domain of the callback, but the domain of the LNURL-pay endpoint.
    #[serde(skip_serializing, skip_deserializing)]
    pub domain: String,

    /// If sending to a LN Address, this will be filled.
    #[serde(skip_serializing, skip_deserializing)]
    pub ln_address: Option<String>,
}

impl LnUrlPayRequestData {
    /// The minimum amount, in sats, accepted by this LNURL-pay endpoint
    pub fn min_sendable_sats(&self) -> u64 {
        self.min_sendable / 1000
    }

    /// The maximum amount, in sats, accepted by this LNURL-pay endpoint
    pub fn max_sendable_sats(&self) -> u64 {
        self.max_sendable / 1000
    }

    /// Parsed metadata items. Use `metadata_str` to get the raw metadata string, as received from
    /// the LNURL endpoint.
    pub fn metadata_vec(&self) -> Result<Vec<MetadataItem>> {
        Ok(serde_json::from_str::<Vec<MetadataItem>>(
            &self.metadata_str,
        )?)
    }
}

/// Wrapped in a [LnUrlWithdraw], this is the result of [parse] when given a LNURL-withdraw endpoint.
///
/// It represents the endpoint's parameters for the LNURL workflow.
///
/// See https://github.com/lnurl/luds/blob/luds/03.md
#[derive(Deserialize, Debug, Serialize)]
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

impl LnUrlWithdrawRequestData {
    /// The minimum amount, in sats, accepted by this LNURL-withdraw endpoint
    pub fn min_withdrawable_sats(&self) -> u64 {
        self.min_withdrawable / 1000
    }

    /// The maximum amount, in sats, accepted by this LNURL-withdraw endpoint
    pub fn max_withdrawable_sats(&self) -> u64 {
        self.max_withdrawable / 1000
    }
}

/// Wrapped in a [LnUrlAuth], this is the result of [parse] when given a LNURL-auth endpoint.
///
/// It represents the endpoint's parameters for the LNURL workflow.
///
/// See https://github.com/lnurl/luds/blob/luds/04.md
#[derive(Deserialize, Debug, Serialize)]
pub struct LnUrlAuthRequestData {
    /// Hex encoded 32 bytes of challenge
    pub k1: String,

    /// When available, one of: register, login, link, auth
    pub action: Option<String>,

    /// Indicates the domain of the LNURL-auth service, to be shown to the user when asking for
    /// auth confirmation, as per LUD-04 spec.
    #[serde(skip_serializing, skip_deserializing)]
    pub domain: String,

    /// Indicates the URL of the LNURL-auth service, including the query arguments. This will be
    /// extended with the signed challenge and the linking key, then called in the second step of the workflow.
    #[serde(skip_serializing, skip_deserializing)]
    pub url: String,
}

/// Key-value pair in the [LnUrlPayRequestData], as returned by the LNURL-pay endpoint
#[derive(Deserialize, Debug)]
pub struct MetadataItem {
    pub key: String,
    pub value: String,
}

/// Wrapped in a [BitcoinAddress], this is the result of [parse] when given a plain or BIP-21 BTC address.
#[derive(Debug, Serialize)]
pub struct BitcoinAddressData {
    pub address: String,
    pub network: crate::models::Network,
    pub amount_sat: Option<u64>,
    pub label: Option<String>,
    pub message: Option<String>,
}

impl From<Uri<'_>> for BitcoinAddressData {
    fn from(uri: Uri) -> Self {
        BitcoinAddressData {
            address: uri.address.to_string(),
            network: uri.address.network.into(),
            amount_sat: uri.amount.map(|a| a.to_sat()),
            label: uri.label.map(|label| label.try_into().unwrap()),
            message: uri.message.map(|msg| msg.try_into().unwrap()),
        }
    }
}

#[cfg(test)]
pub(crate) mod tests {
    use std::sync::Mutex;

    use anyhow::anyhow;
    use anyhow::Result;
    use bitcoin::bech32;
    use bitcoin::bech32::{ToBase32, Variant};
    use bitcoin::secp256k1::{PublicKey, Secp256k1, SecretKey};
    use mockito::{Mock, Server, ServerGuard};
    use once_cell::sync::Lazy;

    use crate::input_parser::*;
    use crate::models::Network;

    /// Mock server used in tests. As the server is shared between tests,
    /// we should not mock the same url twice with two different outputs,
    /// one way to do so is to add a random string that will be a differentiator
    /// in the URL.
    pub(crate) static MOCK_HTTP_SERVER: Lazy<Mutex<ServerGuard>> =
        Lazy::new(|| Mutex::new(Server::new()));

    #[tokio::test]
    async fn test_generic_invalid_input() -> Result<(), Box<dyn std::error::Error>> {
        assert!(parse("invalid_input").await.is_err());

        Ok(())
    }

    #[tokio::test]
    async fn test_trim_input() -> Result<()> {
        for address in [
            r#"1andreas3batLhQa2FawWjeyjCqyBzypd"#,
            r#"1andreas3batLhQa2FawWjeyjCqyBzypd "#,
            r#"1andreas3batLhQa2FawWjeyjCqyBzypd
            "#,
            r#"
            1andreas3batLhQa2FawWjeyjCqyBzypd
            "#,
            r#" 1andreas3batLhQa2FawWjeyjCqyBzypd
            "#,
        ] {
            assert!(matches!(
                parse(address).await?,
                InputType::BitcoinAddress { address: _ }
            ));
        }
        Ok(())
    }

    #[tokio::test]
    async fn test_bitcoin_address() -> Result<()> {
        for address in [
            "1andreas3batLhQa2FawWjeyjCqyBzypd",
            "12c6DSiU4Rq3P4ZxziKxzrL5LmMBrzjrJX",
            "bc1qxhmdufsvnuaaaer4ynz88fspdsxq2h9e9cetdj",
            "3CJ7cNxChpcUykQztFSqKFrMVQDN4zTTsp",
        ] {
            assert!(matches!(
                parse(address).await?,
                InputType::BitcoinAddress { address: _ }
            ));
        }
        Ok(())
    }

    #[tokio::test]
    async fn test_bitcoin_address_bip21() -> Result<()> {
        // Addresses from https://github.com/Kixunil/bip21/blob/master/src/lib.rs

        // Valid address with the `bitcoin:` prefix
        assert!(parse("bitcoin:1andreas3batLhQa2FawWjeyjCqyBzypd")
            .await
            .is_ok());
        assert!(parse("bitcoin:testinvalidaddress").await.is_err());

        let addr = "1andreas3batLhQa2FawWjeyjCqyBzypd";

        // Address with amount
        let addr_1 = format!("bitcoin:{addr}?amount=0.00002000");
        match parse(&addr_1).await? {
            BitcoinAddress {
                address: addr_with_amount_parsed,
            } => {
                assert_eq!(addr_with_amount_parsed.address, addr);
                assert_eq!(addr_with_amount_parsed.network, Network::Bitcoin);
                assert_eq!(addr_with_amount_parsed.amount_sat, Some(2000));
                assert_eq!(addr_with_amount_parsed.label, None);
                assert_eq!(addr_with_amount_parsed.message, None);
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        // Address with amount and label
        let label = "test-label";
        let addr_2 = format!("bitcoin:{addr}?amount=0.00002000&label={label}");
        match parse(&addr_2).await? {
            BitcoinAddress {
                address: addr_with_amount_parsed,
            } => {
                assert_eq!(addr_with_amount_parsed.address, addr);
                assert_eq!(addr_with_amount_parsed.network, Network::Bitcoin);
                assert_eq!(addr_with_amount_parsed.amount_sat, Some(2000));
                assert_eq!(addr_with_amount_parsed.label, Some(label.into()));
                assert_eq!(addr_with_amount_parsed.message, None);
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        // Address with amount, label and message
        let message = "test-message";
        let addr_3 = format!("bitcoin:{addr}?amount=0.00002000&label={label}&message={message}");
        match parse(&addr_3).await? {
            BitcoinAddress {
                address: addr_with_amount_parsed,
            } => {
                assert_eq!(addr_with_amount_parsed.address, addr);
                assert_eq!(addr_with_amount_parsed.network, Network::Bitcoin);
                assert_eq!(addr_with_amount_parsed.amount_sat, Some(2000));
                assert_eq!(addr_with_amount_parsed.label, Some(label.into()));
                assert_eq!(addr_with_amount_parsed.message, Some(message.into()));
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        Ok(())
    }

    #[tokio::test]
    async fn test_bolt11() -> Result<()> {
        let bolt11 = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";

        // Invoice without prefix
        assert!(matches!(
            parse(bolt11).await?,
            InputType::Bolt11 { invoice: _invoice }
        ));

        // Invoice with prefix
        let invoice_with_prefix = format!("lightning:{bolt11}");
        assert!(matches!(
            parse(&invoice_with_prefix).await?,
            InputType::Bolt11 { invoice: _invoice }
        ));

        Ok(())
    }

    #[tokio::test]
    async fn test_bolt11_with_fallback_bitcoin_address() -> Result<()> {
        let addr = "1andreas3batLhQa2FawWjeyjCqyBzypd";
        let bolt11 = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";

        // Address and invoice
        // BOLT11 is the first URI arg (preceded by '?')
        let addr_1 = format!("bitcoin:{addr}?lightning={bolt11}");
        assert!(matches!(
            parse(&addr_1).await?,
            InputType::Bolt11 { invoice: _invoice }
        ));

        // Address, amount and invoice
        // BOLT11 is not the first URI arg (preceded by '&')
        let addr_2 = format!("bitcoin:{addr}?amount=0.00002000&lightning={bolt11}");
        assert!(matches!(
            parse(&addr_2).await?,
            InputType::Bolt11 { invoice: _invoice }
        ));

        Ok(())
    }

    #[tokio::test]
    async fn test_bolt12_offer() -> Result<()> {
        let offer = "lno1pqqnyzsmx5cx6umpwssx6atvw35j6ut4v9h8g6t50ysx7enxv4epyrmjw4ehgcm0wfczucm0d5hxzag5qqtzzq3lxgva5qlw9xsjmeqs0ek9cdj0vpec9ur972l7mywa66u3q7dlhs";

        assert!(matches!(
            parse(offer).await?,
            InputType::Bolt12Offer { offer: _offer }
        ));
        Ok(())
    }

    #[tokio::test]
    async fn test_url() -> Result<()> {
        assert!(matches!(
            parse("https://breez.technology").await?,
            InputType::Url { url: _url }
        ));
        assert!(matches!(
            parse("https://breez.technology/").await?,
            InputType::Url { url: _url }
        ));
        assert!(matches!(
            parse("https://breez.technology/test-path").await?,
            InputType::Url { url: _url }
        ));
        assert!(matches!(
            parse("https://breez.technology/test-path?arg1=val1&arg2=val2").await?,
            InputType::Url { url: _url }
        ));

        Ok(())
    }

    #[tokio::test]
    async fn test_node_id() -> Result<()> {
        let secp = Secp256k1::new();
        let secret_key = SecretKey::from_slice(&[0xab; 32])?;
        let public_key = PublicKey::from_secret_key(&secp, &secret_key);

        match parse(&public_key.to_string()).await? {
            NodeId { node_id } => {
                assert_eq!(node_id, public_key.to_string());
            }
            _ => return Err(anyhow!("Unexpected type")),
        }

        // Other formats and sizes
        assert!(
            parse("012345678901234567890123456789012345678901234567890123456789mnop")
                .await
                .is_err()
        );
        assert!(parse("0123456789").await.is_err());
        assert!(parse("abcdefghij").await.is_err());

        // Plain Node ID
        assert!(
            parse("03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f")
                .await
                .is_ok()
        );
        // Plain Node ID (66 hex chars) with @ separator and any string afterwards
        assert!(
            parse("03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f@")
                .await
                .is_ok()
        );
        assert!(parse(
            "03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f@sdfsffs"
        )
        .await
        .is_ok());
        assert!(parse(
            "03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f@1.2.3.4:1234"
        )
        .await
        .is_ok());

        // Invalid Node ID (66 chars ending in non-hex-chars) with @ separator and any string afterwards -> invalid
        assert!(
            parse("03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3zzz@")
                .await
                .is_err()
        );
        assert!(parse(
            "03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3zzz@sdfsffs"
        )
        .await
        .is_err());
        assert!(parse(
            "03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3zzz@1.2.3.4:1234"
        )
        .await
        .is_err());

        Ok(())
    }

    #[test]
    fn test_lnurl_pay_lud_01() -> Result<()> {
        // Covers cases in LUD-01: Base LNURL encoding and decoding
        // https://github.com/lnurl/luds/blob/luds/01.md

        // HTTPS allowed with clearnet domains
        assert_eq!(
            lnurl_decode(&bech32::encode(
                "LNURL",
                "https://domain.com".to_base32(),
                Variant::Bech32
            )?)?,
            ("domain.com".into(), "https://domain.com".into(), false)
        );

        // HTTP not allowed with clearnet domains
        assert!(lnurl_decode(&bech32::encode(
            "LNURL",
            "http://domain.com".to_base32(),
            Variant::Bech32
        )?)
        .is_err());

        // HTTP allowed with onion domains
        assert_eq!(
            lnurl_decode(&bech32::encode(
                "LNURL",
                "http://3fdsf.onion".to_base32(),
                Variant::Bech32
            )?)?,
            ("3fdsf.onion".into(), "http://3fdsf.onion".into(), false)
        );

        // HTTPS not allowed with onion domains
        assert!(lnurl_decode(&bech32::encode(
            "LNURL",
            "https://3fdsf.onion".to_base32(),
            Variant::Bech32
        )?)
        .is_err());

        let decoded_url = "https://service.com/api?q=3fc3645b439ce8e7f2553a69e5267081d96dcd340693afabe04be7b0ccd178df";
        let lnurl_raw = "LNURL1DP68GURN8GHJ7UM9WFMXJCM99E3K7MF0V9CXJ0M385EKVCENXC6R2C35XVUKXEFCV5MKVV34X5EKZD3EV56NYD3HXQURZEPEXEJXXEPNXSCRVWFNV9NXZCN9XQ6XYEFHVGCXXCMYXYMNSERXFQ5FNS";

        assert_eq!(
            lnurl_decode(lnurl_raw)?,
            ("service.com".into(), decoded_url.into(), false)
        );

        // Uppercase and lowercase allowed, but mixed case is invalid
        assert!(lnurl_decode(&lnurl_raw.to_uppercase()).is_ok());
        assert!(lnurl_decode(&lnurl_raw.to_lowercase()).is_ok());
        assert!(lnurl_decode(&format!(
            "{}{}",
            lnurl_raw[..5].to_uppercase(),
            lnurl_raw[5..].to_lowercase()
        ))
        .is_err());

        Ok(())
    }

    fn mock_lnurl_withdraw_endpoint(path: &str, return_lnurl_error: Option<String>) -> Mock {
        let expected_lnurl_withdraw_data = r#"
{
    "tag":"withdrawRequest",
    "callback":"https://localhost/lnurl-withdraw/callback/e464f841c44dbdd86cee4f09f4ccd3ced58d2e24f148730ec192748317b74538",
    "k1":"37b4c919f871c090830cc47b92a544a30097f03430bc39670b8ec0da89f01a81",
    "minWithdrawable":3000,
    "maxWithdrawable":12000,
    "defaultDescription":"sample withdraw"
}
        "#.replace('\n', "");

        let response_body = match return_lnurl_error {
            None => expected_lnurl_withdraw_data,
            Some(err_reason) => {
                ["{\"status\": \"ERROR\", \"reason\": \"", &err_reason, "\"}"].join("")
            }
        };

        let mut server = MOCK_HTTP_SERVER.lock().unwrap();
        server.mock("GET", path).with_body(response_body).create()
    }

    #[tokio::test]
    async fn test_lnurl_withdraw_lud_03() -> Result<(), Box<dyn std::error::Error>> {
        // Covers cases in LUD-03: withdrawRequest base spec
        // https://github.com/lnurl/luds/blob/luds/03.md

        let path = "/lnurl-withdraw?session=bc893fafeb9819046781b47d68fdcf88fa39a28898784c183b42b7ac13820d81";
        let _m = mock_lnurl_withdraw_endpoint(path, None);

        let lnurl_withdraw_encoded = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4exctthd96xserjv9mn7um9wdekjmmw843xxwpexdnxzen9vgunsvfexq6rvdecx93rgdmyxcuxverrvcursenpxvukzv3c8qunsdecx33nzwpnvg6ryc3hv93nzvecxgcxgwp3h33lxk";
        assert_eq!(
            lnurl_decode(lnurl_withdraw_encoded)?,
            (
                "localhost".into(),
                format!("https://localhost{path}"),
                false
            )
        );

        if let LnUrlWithdraw { data: wd } = parse(lnurl_withdraw_encoded).await? {
            assert_eq!(wd.callback, "https://localhost/lnurl-withdraw/callback/e464f841c44dbdd86cee4f09f4ccd3ced58d2e24f148730ec192748317b74538");
            assert_eq!(
                wd.k1,
                "37b4c919f871c090830cc47b92a544a30097f03430bc39670b8ec0da89f01a81"
            );
            assert_eq!(wd.min_withdrawable, 3000);
            assert_eq!(wd.max_withdrawable, 12000);
            assert_eq!(wd.default_description, "sample withdraw");
        }

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_auth_lud_04() -> Result<()> {
        // Covers cases in LUD-04: `auth` base spec
        // https://github.com/lnurl/luds/blob/luds/04.md

        // No action specified
        let decoded_url = "https://localhost/lnurl-login?tag=login&k1=1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822";
        let lnurl_auth_encoded = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgeqgntfgu";
        assert_eq!(
            lnurl_decode(lnurl_auth_encoded)?,
            ("localhost".into(), decoded_url.into(), false)
        );

        if let LnUrlAuth { data: ad } = parse(lnurl_auth_encoded).await? {
            assert_eq!(
                ad.k1,
                "1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822"
            );
            assert_eq!(ad.domain, "localhost".to_string());
            assert_eq!(ad.action, None);
        }

        // Action = register
        let _decoded_url = "https://localhost/lnurl-login?tag=login&k1=1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822&action=register";
        let lnurl_auth_encoded = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgezvctrw35k7m3awfjkw6tnw3jhys2umys";
        if let LnUrlAuth { data: ad } = parse(lnurl_auth_encoded).await? {
            assert_eq!(
                ad.k1,
                "1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822"
            );
            assert_eq!(ad.domain, "localhost".to_string());
            assert_eq!(ad.action, Some("register".into()));
        }

        // Action = login
        let _decoded_url = "https://localhost/lnurl-login?tag=login&k1=1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822&action=login";
        let lnurl_auth_encoded = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgezvctrw35k7m3ad3hkw6tw2acjtx";
        if let LnUrlAuth { data: ad } = parse(lnurl_auth_encoded).await? {
            assert_eq!(
                ad.k1,
                "1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822"
            );
            assert_eq!(ad.domain, "localhost".to_string());
            assert_eq!(ad.action, Some("login".into()));
        }

        // Action = link
        let _decoded_url = "https://localhost/lnurl-login?tag=login&k1=1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822&action=link";
        let lnurl_auth_encoded = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgezvctrw35k7m3ad35ku6cc8mvs6";
        if let LnUrlAuth { data: ad } = parse(lnurl_auth_encoded).await? {
            assert_eq!(
                ad.k1,
                "1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822"
            );
            assert_eq!(ad.domain, "localhost".to_string());
            assert_eq!(ad.action, Some("link".into()));
        }

        // Action = auth
        let _decoded_url = "https://localhost/lnurl-login?tag=login&k1=1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822&action=auth";
        let lnurl_auth_encoded = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgezvctrw35k7m3av96hg6qmg6zgu";
        if let LnUrlAuth { data: ad } = parse(lnurl_auth_encoded).await? {
            assert_eq!(
                ad.k1,
                "1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822"
            );
            assert_eq!(ad.domain, "localhost".to_string());
            assert_eq!(ad.action, Some("auth".into()));
        }

        // Action = another, invalid type
        let _decoded_url = "https://localhost/lnurl-login?tag=login&k1=1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822&action=invalid";
        let lnurl_auth_encoded = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttvdankjm3lw3skw0tvdankjm3xdvcn6vtp8q6n2dfsx5mrjwtrxdjnqvtzv56rzcnyv3jrxv3sxqmkyenrvv6kve3exv6nqdtyv43nqcmzvdsnvdrzx33rsenxx5unqc3cxgezvctrw35k7m3ad9h8vctvd9jq2s4vfw";
        assert!(parse(lnurl_auth_encoded).await.is_err());

        Ok(())
    }

    fn mock_lnurl_pay_endpoint(path: &str, return_lnurl_error: Option<String>) -> Mock {
        let expected_lnurl_pay_data = r#"
{
    "callback":"https://localhost/lnurl-pay/callback/db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7",
    "tag":"payRequest",
    "maxSendable":16000,
    "minSendable":4000,
    "metadata":"[
        [\"text/plain\",\"WRhtV\"],
        [\"text/long-desc\",\"MBTrTiLCFS\"],
        [\"image/png;base64\",\"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\"]
    ]",
    "commentAllowed":0,
    "payerData":{
        "name":{"mandatory":false},
        "pubkey":{"mandatory":false},
        "identifier":{"mandatory":false},
        "email":{"mandatory":false},
        "auth":{"mandatory":false,"k1":"18ec6d5b96db6f219baed2f188aee7359fcf5bea11bb7d5b47157519474c2222"}
    }
}
        "#.replace('\n', "");

        let response_body = match return_lnurl_error {
            None => expected_lnurl_pay_data,
            Some(err_reason) => {
                ["{\"status\": \"ERROR\", \"reason\": \"", &err_reason, "\"}"].join("")
            }
        };

        let mut server = MOCK_HTTP_SERVER.lock().unwrap();
        server.mock("GET", path).with_body(response_body).create()
    }

    fn mock_lnurl_ln_address_endpoint(
        ln_address: &str,
        return_lnurl_error: Option<String>,
    ) -> Result<Mock> {
        let (_domain, lnurl_pay_url) = ln_address_decode(ln_address)?;
        let url = reqwest::Url::parse(&lnurl_pay_url)?;
        let path = url.path();

        let expected_lnurl_pay_data = r#"
{
    "callback":"https://localhost/lnurl-pay/callback/db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7",
    "tag":"payRequest",
    "maxSendable":16000,
    "minSendable":4000,
    "metadata":"[
        [\"text/plain\",\"WRhtV\"],
        [\"text/long-desc\",\"MBTrTiLCFS\"],
        [\"image/png;base64\",\"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\"]
    ]",
    "commentAllowed":0,
    "payerData":{
        "name":{"mandatory":false},
        "pubkey":{"mandatory":false},
        "identifier":{"mandatory":false},
        "email":{"mandatory":false},
        "auth":{"mandatory":false,"k1":"18ec6d5b96db6f219baed2f188aee7359fcf5bea11bb7d5b47157519474c2222"}
    }
}
        "#.replace('\n', "");

        let response_body = match return_lnurl_error {
            None => expected_lnurl_pay_data,
            Some(err_reason) => {
                ["{\"status\": \"ERROR\", \"reason\": \"", &err_reason, "\"}"].join("")
            }
        };

        let mut server = MOCK_HTTP_SERVER.lock().unwrap();
        Ok(server.mock("GET", path).with_body(response_body).create())
    }

    #[tokio::test]
    async fn test_lnurl_pay_lud_06() -> Result<(), Box<dyn std::error::Error>> {
        // Covers cases in LUD-06: payRequest base spec
        // https://github.com/lnurl/luds/blob/luds/06.md

        let path =
            "/lnurl-pay?session=db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7";
        let _m = mock_lnurl_pay_endpoint(path, None);

        let lnurl_pay_encoded = "lnurl1dp68gurn8ghj7mr0vdskc6r0wd6z7mrww4excttsv9un7um9wdekjmmw84jxywf5x43rvv35xgmr2enrxanr2cfcvsmnwe3jxcukvde48qukgdec89snwde3vfjxvepjxpjnjvtpxd3kvdnxx5crxwpjvyunsephsz36jf";
        assert_eq!(
            lnurl_decode(lnurl_pay_encoded)?,
            (
                "localhost".into(),
                format!("https://localhost{path}"),
                false
            )
        );

        if let LnUrlPay { data: pd } = parse(lnurl_pay_encoded).await? {
            assert_eq!(pd.callback, "https://localhost/lnurl-pay/callback/db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7");
            assert_eq!(pd.max_sendable, 16000);
            assert_eq!(pd.min_sendable, 4000);
            assert_eq!(pd.comment_allowed, 0);
            assert_eq!(pd.domain, "localhost");

            assert_eq!(pd.metadata_vec()?.len(), 3);
            assert_eq!(
                pd.metadata_vec()?.get(0).ok_or("Key not found")?.key,
                "text/plain"
            );
            assert_eq!(
                pd.metadata_vec()?.get(0).ok_or("Key not found")?.value,
                "WRhtV"
            );
            assert_eq!(
                pd.metadata_vec()?.get(1).ok_or("Key not found")?.key,
                "text/long-desc"
            );
            assert_eq!(
                pd.metadata_vec()?.get(1).ok_or("Key not found")?.value,
                "MBTrTiLCFS"
            );
            assert_eq!(
                pd.metadata_vec()?.get(2).ok_or("Key not found")?.key,
                "image/png;base64"
            );
        }

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_pay_lud_16_ln_address() -> Result<(), Box<dyn std::error::Error>> {
        // Covers cases in LUD-16: Paying to static internet identifiers (LN Address)
        // https://github.com/lnurl/luds/blob/luds/16.md

        let ln_address = "user@domain.net";
        let _m = mock_lnurl_ln_address_endpoint(ln_address, None)?;

        if let LnUrlPay { data: pd } = parse(ln_address).await? {
            assert_eq!(pd.callback, "https://localhost/lnurl-pay/callback/db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7");
            assert_eq!(pd.max_sendable, 16000);
            assert_eq!(pd.min_sendable, 4000);
            assert_eq!(pd.comment_allowed, 0);
            assert_eq!(pd.domain, "domain.net");
            assert_eq!(pd.ln_address, Some(ln_address.to_string()));

            assert_eq!(pd.metadata_vec()?.len(), 3);
            assert_eq!(
                pd.metadata_vec()?.get(0).ok_or("Key not found")?.key,
                "text/plain"
            );
            assert_eq!(
                pd.metadata_vec()?.get(0).ok_or("Key not found")?.value,
                "WRhtV"
            );
            assert_eq!(
                pd.metadata_vec()?.get(1).ok_or("Key not found")?.key,
                "text/long-desc"
            );
            assert_eq!(
                pd.metadata_vec()?.get(1).ok_or("Key not found")?.value,
                "MBTrTiLCFS"
            );
            assert_eq!(
                pd.metadata_vec()?.get(2).ok_or("Key not found")?.key,
                "image/png;base64"
            );
        }

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_pay_lud_16_ln_address_error() -> Result<()> {
        // Covers cases in LUD-16: Paying to static internet identifiers (LN Address)
        // https://github.com/lnurl/luds/blob/luds/16.md

        let ln_address = "error@domain.com";
        let expected_err = "Error msg from LNURL endpoint found via LN Address";
        let _m = mock_lnurl_ln_address_endpoint(ln_address, Some(expected_err.to_string()))?;

        if let LnUrlError { data: msg } = parse(ln_address).await? {
            assert_eq!(msg.reason, expected_err);
            return Ok(());
        }

        Err(anyhow!("Unrecognized input type"))
    }

    #[test]
    fn test_ln_address_lud_16_decode() -> Result<(), Box<dyn std::error::Error>> {
        assert_eq!(
            lnurl_decode("user@domain.onion")?,
            (
                "domain.onion".into(),
                "http://domain.onion/.well-known/lnurlp/user".into(),
                true
            )
        );
        assert_eq!(
            lnurl_decode("user@domain.com")?,
            (
                "domain.com".into(),
                "https://domain.com/.well-known/lnurlp/user".into(),
                true
            )
        );
        assert_eq!(
            lnurl_decode("user@domain.net")?,
            (
                "domain.net".into(),
                "https://domain.net/.well-known/lnurlp/user".into(),
                true
            )
        );
        assert!(ln_address_decode("invalid_ln_address").is_err());

        // Valid chars are a-z0-9-_.
        assert!(lnurl_decode("user.testy_test1@domain.com").is_ok());
        assert!(lnurl_decode("user+1@domain.com").is_err());
        assert!(lnurl_decode("User@domain.com").is_err());

        Ok(())
    }

    #[test]
    fn test_lnurl_lud_17_prefixes() -> Result<(), Box<dyn std::error::Error>> {
        // Covers cases in LUD-17: Protocol schemes and raw (non bech32-encoded) URLs
        // https://github.com/lnurl/luds/blob/luds/17.md

        // Variant-specific prefix replaces https for clearnet and http for onion

        // For onion addresses, the prefix maps to an equivalent HTTP URL
        assert_eq!(
            lnurl_decode("lnurlp://asfddf2dsf3f.onion")?,
            (
                "asfddf2dsf3f.onion".into(),
                "http://asfddf2dsf3f.onion".into(),
                false
            )
        );
        assert_eq!(
            lnurl_decode("lnurlw://asfddf2dsf3f.onion")?,
            (
                "asfddf2dsf3f.onion".into(),
                "http://asfddf2dsf3f.onion".into(),
                false
            )
        );
        assert_eq!(
            lnurl_decode("keyauth://asfddf2dsf3f.onion")?,
            (
                "asfddf2dsf3f.onion".into(),
                "http://asfddf2dsf3f.onion".into(),
                false
            )
        );

        // For non-onion addresses, the prefix maps to an equivalent HTTPS URL
        assert_eq!(
            lnurl_decode("lnurlp://domain.com")?,
            ("domain.com".into(), "https://domain.com".into(), false)
        );
        assert_eq!(
            lnurl_decode("lnurlw://domain.com")?,
            ("domain.com".into(), "https://domain.com".into(), false)
        );
        assert_eq!(
            lnurl_decode("keyauth://domain.com")?,
            ("domain.com".into(), "https://domain.com".into(), false)
        );

        // Same as above, but prefix: approach instead of prefix://
        assert_eq!(
            lnurl_decode("lnurlp:asfddf2dsf3f.onion")?,
            (
                "asfddf2dsf3f.onion".into(),
                "http://asfddf2dsf3f.onion".into(),
                false
            )
        );
        assert_eq!(
            lnurl_decode("lnurlw:asfddf2dsf3f.onion")?,
            (
                "asfddf2dsf3f.onion".into(),
                "http://asfddf2dsf3f.onion".into(),
                false
            )
        );
        assert_eq!(
            lnurl_decode("keyauth:asfddf2dsf3f.onion")?,
            (
                "asfddf2dsf3f.onion".into(),
                "http://asfddf2dsf3f.onion".into(),
                false
            )
        );

        assert_eq!(
            lnurl_decode("lnurlp:domain.com")?,
            ("domain.com".into(), "https://domain.com".into(), false)
        );
        assert_eq!(
            lnurl_decode("lnurlw:domain.com")?,
            ("domain.com".into(), "https://domain.com".into(), false)
        );
        assert_eq!(
            lnurl_decode("keyauth:domain.com")?,
            ("domain.com".into(), "https://domain.com".into(), false)
        );

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_pay_lud_17() -> Result<(), Box<dyn std::error::Error>> {
        let pay_path =
            "/lnurl-pay?session=db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7";
        let _m = mock_lnurl_pay_endpoint(pay_path, None);

        let lnurl_pay_url = format!("lnurlp://localhost{pay_path}");
        if let LnUrlPay { data: pd } = parse(&lnurl_pay_url).await? {
            assert_eq!(pd.callback, "https://localhost/lnurl-pay/callback/db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7");
            assert_eq!(pd.max_sendable, 16000);
            assert_eq!(pd.min_sendable, 4000);
            assert_eq!(pd.comment_allowed, 0);
            assert_eq!(pd.domain, "localhost");

            assert_eq!(pd.metadata_vec()?.len(), 3);
            assert_eq!(
                pd.metadata_vec()?.get(0).ok_or("Key not found")?.key,
                "text/plain"
            );
            assert_eq!(
                pd.metadata_vec()?.get(0).ok_or("Key not found")?.value,
                "WRhtV"
            );
            assert_eq!(
                pd.metadata_vec()?.get(1).ok_or("Key not found")?.key,
                "text/long-desc"
            );
            assert_eq!(
                pd.metadata_vec()?.get(1).ok_or("Key not found")?.value,
                "MBTrTiLCFS"
            );
            assert_eq!(
                pd.metadata_vec()?.get(2).ok_or("Key not found")?.key,
                "image/png;base64"
            );
        }

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_withdraw_lud_17() -> Result<(), Box<dyn std::error::Error>> {
        let withdraw_path = "/lnurl-withdraw?session=e464f841c44dbdd86cee4f09f4ccd3ced58d2e24f148730ec192748317b74538";
        let _m = mock_lnurl_withdraw_endpoint(withdraw_path, None);

        if let LnUrlWithdraw { data: wd } =
            parse(&format!("lnurlw://localhost{withdraw_path}")).await?
        {
            assert_eq!(wd.callback, "https://localhost/lnurl-withdraw/callback/e464f841c44dbdd86cee4f09f4ccd3ced58d2e24f148730ec192748317b74538");
            assert_eq!(
                wd.k1,
                "37b4c919f871c090830cc47b92a544a30097f03430bc39670b8ec0da89f01a81"
            );
            assert_eq!(wd.min_withdrawable, 3000);
            assert_eq!(wd.max_withdrawable, 12000);
            assert_eq!(wd.default_description, "sample withdraw");
        }

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_auth_lud_17() -> Result<()> {
        let auth_path = "/lnurl-login?tag=login&k1=1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822";

        if let LnUrlAuth { data: ad } = parse(&format!("keyauth://localhost{auth_path}")).await? {
            assert_eq!(
                ad.k1,
                "1a855505699c3e01be41bddd32007bfcc5ff93505dec0cbca64b4b8ff590b822"
            );
        }

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_pay_lud_17_error() -> Result<()> {
        let pay_path = "/lnurl-pay?session=paylud17error";
        let expected_error_msg = "test pay error";
        let _m = mock_lnurl_pay_endpoint(pay_path, Some(expected_error_msg.to_string()));

        if let LnUrlError { data: msg } = parse(&format!("lnurlp://localhost{pay_path}")).await? {
            assert_eq!(msg.reason, expected_error_msg);
            return Ok(());
        }

        Err(anyhow!("Unrecognized input type"))
    }

    #[tokio::test]
    async fn test_lnurl_withdraw_lud_17_error() -> Result<()> {
        let withdraw_path = "/lnurl-withdraw?session=withdrawlud17error";
        let expected_error_msg = "test withdraw error";
        let _m = mock_lnurl_withdraw_endpoint(withdraw_path, Some(expected_error_msg.to_string()));

        if let LnUrlError { data: msg } =
            parse(&format!("lnurlw://localhost{withdraw_path}")).await?
        {
            assert_eq!(msg.reason, expected_error_msg);
            return Ok(());
        }

        Err(anyhow!("Unrecognized input type"))
    }
}
