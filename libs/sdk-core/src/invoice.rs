use anyhow::anyhow;
use bitcoin::secp256k1::{self, PublicKey};
use hex::ToHex;
use lightning::routing::gossip::RoutingFees;
use lightning::routing::*;
use lightning_invoice::*;
use regex::Regex;
use serde::{Deserialize, Serialize};
use std::str::FromStr;
use std::time::{SystemTimeError, UNIX_EPOCH};

pub type InvoiceResult<T, E = InvoiceError> = Result<T, E>;

#[derive(Debug, thiserror::Error)]
pub enum InvoiceError {
    #[error("Generic: {0}")]
    Generic(#[from] anyhow::Error),

    #[error("Validation: {0}")]
    Validation(anyhow::Error),
}

impl From<lightning_invoice::CreationError> for InvoiceError {
    fn from(err: lightning_invoice::CreationError) -> Self {
        Self::Generic(anyhow::Error::new(err))
    }
}

impl From<lightning_invoice::ParseError> for InvoiceError {
    fn from(err: lightning_invoice::ParseError) -> Self {
        Self::Validation(anyhow::Error::new(err))
    }
}

impl From<lightning_invoice::SemanticError> for InvoiceError {
    fn from(err: lightning_invoice::SemanticError) -> Self {
        Self::Validation(anyhow::Error::new(err))
    }
}

impl From<regex::Error> for InvoiceError {
    fn from(err: regex::Error) -> Self {
        Self::Generic(anyhow::Error::new(err))
    }
}

impl From<secp256k1::Error> for InvoiceError {
    fn from(err: secp256k1::Error) -> Self {
        Self::Generic(anyhow::Error::new(err))
    }
}

impl From<SystemTimeError> for InvoiceError {
    fn from(err: SystemTimeError) -> Self {
        Self::Generic(anyhow::Error::new(err))
    }
}

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub enum Quantity {
    Bounded { amount: u64 },
    Unbounded,
    One,
}

impl From<lightning::offers::offer::Quantity> for Quantity {
    fn from(value: lightning::offers::offer::Quantity) -> Self {
        match value {
            lightning::offers::offer::Quantity::One => Quantity::One,
            lightning::offers::offer::Quantity::Unbounded => Quantity::Unbounded,
            lightning::offers::offer::Quantity::Bounded(n) => Quantity::Bounded { amount: n.into() },
        }
    }
}

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub enum Amount {
    Bitcoin {
        amount_msat: u64,
    },
    Currency {
        // Reference to [FiatCurrency.id]
        iso4217_code: String,
        fractional_amount: u64,
    },
}

impl From<lightning::offers::offer::Amount> for Amount {
    fn from(amount: lightning::offers::offer::Amount) -> Self {
        match amount {
            lightning::offers::offer::Amount::Bitcoin { amount_msats } => Amount::Bitcoin {
                amount_msat: amount_msats,
            },
            lightning::offers::offer::Amount::Currency {
                iso4217_code,
                amount,
            } => Amount::Currency {
                iso4217_code: String::from_utf8(iso4217_code.to_vec())
                    .expect("Expecting a valid ISO 4217 character sequence"),
                fractional_amount: amount,
            },
        }
    }
}

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub struct LNOffer {
    pub bolt12: String,
    pub chains: Vec<String>,
    pub amount: Option<Amount>,
    pub description: String,
    pub absolute_expiry: Option<u64>,
    pub issuer: Option<String>,
    pub supported_quantity: Quantity,
    pub signing_pubkey: String,
    pub metadata: Option<Vec<u8>>,
    // pub features: Features<OfferContext>,
    // pub paths: Vec<BlindedPath>,
}

/// Wrapper for a BOLT11/12 LN invoice
#[derive(Clone, Debug, Serialize, Deserialize, PartialEq)]
pub struct LNInvoice {
    pub bolt11: String,
    pub payee_pubkey: String,
    pub payment_hash: String,
    pub description: Option<String>,
    pub description_hash: Option<String>,
    pub amount_msat: Option<u64>,
    pub timestamp: u64,
    pub expiry: u64,
    pub routing_hints: Vec<RouteHint>,
    pub payment_secret: Vec<u8>,
}

/// Details of a specific hop in a larger route hint
#[derive(Clone, Default, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub struct RouteHintHop {
    /// The node_id of the non-target end of the route
    pub src_node_id: String,
    /// The short_channel_id of this channel
    pub short_channel_id: u64,
    /// The fees which must be paid to use this channel
    pub fees_base_msat: u32,
    pub fees_proportional_millionths: u32,

    /// The difference in CLTV values between this node and the next node.
    pub cltv_expiry_delta: u64,
    /// The minimum value, in msat, which must be relayed to the next hop.
    pub htlc_minimum_msat: Option<u64>,
    /// The maximum value in msat available for routing with a single HTLC.
    pub htlc_maximum_msat: Option<u64>,
}

/// A route hint for a LN payment
#[derive(Clone, Default, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub struct RouteHint {
    pub hops: Vec<RouteHintHop>,
}

impl RouteHint {
    pub fn to_ldk_hint(&self) -> InvoiceResult<router::RouteHint> {
        let mut hops = Vec::new();
        for hop in self.hops.iter() {
            let pubkey_res = PublicKey::from_str(&hop.src_node_id)?;

            let router_hop = router::RouteHintHop {
                src_node_id: pubkey_res,
                short_channel_id: hop.short_channel_id,
                fees: RoutingFees {
                    base_msat: hop.fees_base_msat,
                    proportional_millionths: hop.fees_proportional_millionths,
                },
                cltv_expiry_delta: hop.cltv_expiry_delta as u16,
                htlc_minimum_msat: hop.htlc_minimum_msat,
                htlc_maximum_msat: hop.htlc_maximum_msat,
            };
            hops.push(router_hop);
        }
        Ok(router::RouteHint(hops))
    }

    pub fn from_ldk_hint(hint: &router::RouteHint) -> RouteHint {
        let mut hops = Vec::new();
        for hop in hint.0.iter() {
            let pubkey_res = hop.src_node_id.serialize().encode_hex::<String>();

            let router_hop = RouteHintHop {
                src_node_id: pubkey_res,
                short_channel_id: hop.short_channel_id,
                fees_base_msat: hop.fees.base_msat,
                fees_proportional_millionths: hop.fees.proportional_millionths,
                cltv_expiry_delta: u64::from(hop.cltv_expiry_delta),
                htlc_minimum_msat: hop.htlc_minimum_msat,
                htlc_maximum_msat: hop.htlc_maximum_msat,
            };
            hops.push(router_hop);
        }
        RouteHint { hops }
    }
}

pub fn add_lsp_routing_hints(
    invoice: String,
    lsp_hint: Option<RouteHint>,
    new_amount_msats: u64,
) -> InvoiceResult<RawInvoice> {
    let signed = invoice.parse::<SignedRawInvoice>()?;
    let invoice = Invoice::from_signed(signed)?;

    let mut invoice_builder = InvoiceBuilder::new(invoice.currency())
        .invoice_description(invoice.description())
        .payment_hash(*invoice.payment_hash())
        .timestamp(invoice.timestamp())
        .amount_milli_satoshis(new_amount_msats)
        .expiry_time(invoice.expiry_time())
        .payment_secret(*invoice.payment_secret())
        .min_final_cltv_expiry_delta(invoice.min_final_cltv_expiry_delta());

    // We make sure the hint we add does not conflict with other hints.
    // The lsp hint takes priority so in case the lsp hop is already in one of the existing hints
    // We make sure not to include them in the new hints.
    let unique_hop_hints: Vec<lightning::routing::router::RouteHint> = match lsp_hint {
        None => invoice.route_hints(),
        Some(lsp_hint) => {
            let mut all_hints: Vec<lightning::routing::router::RouteHint> = invoice
                .route_hints()
                .into_iter()
                .filter(|hint| {
                    hint.clone().0.into_iter().all(|hop| {
                        lsp_hint.clone().hops.into_iter().all(|lsp_hop| {
                            hop.src_node_id.serialize().encode_hex::<String>()
                                != lsp_hop.src_node_id
                        })
                    })
                })
                .collect();

            // Adding the lsp hint
            all_hints.push(lsp_hint.to_ldk_hint()?);
            all_hints
        }
    };

    // Adding the unique existing hints
    for hint in unique_hop_hints {
        invoice_builder = invoice_builder.private_route(hint);
    }

    Ok(invoice_builder.build_raw()?)
}

/// Parse a BOLT11 payment request and return a structure contains the parsed fields.
pub fn parse_invoice(bolt11: &str) -> InvoiceResult<LNInvoice> {
    if bolt11.trim().is_empty() {
        return Err(InvoiceError::Validation(anyhow!(
            "bolt11 is an empty string"
        )));
    }
    let re = Regex::new(r"(?i)^lightning:")?;
    let bolt11 = re.replace_all(bolt11, "");
    let signed = bolt11.parse::<SignedRawInvoice>()?;
    let invoice = Invoice::from_signed(signed)?;

    let since_the_epoch = invoice.timestamp().duration_since(UNIX_EPOCH)?;

    // make sure signature is valid
    invoice.check_signature()?;

    // Try to take payee pubkey from the tagged fields, if doesn't exist recover it from the signature
    let payee_pubkey: String = match invoice.payee_pub_key() {
        Some(key) => key.serialize().encode_hex::<String>(),
        None => invoice
            .recover_payee_pub_key()
            .serialize()
            .encode_hex::<String>(),
    };

    // convert hints to bridge interface
    let invoice_hints = invoice.route_hints();
    let converted_hints = invoice_hints.iter().map(RouteHint::from_ldk_hint).collect();
    // return the parsed invoice
    let ln_invoice = LNInvoice {
        bolt11: bolt11.to_string(),
        payee_pubkey,
        expiry: invoice.expiry_time().as_secs(),
        amount_msat: invoice.amount_milli_satoshis(),
        timestamp: since_the_epoch.as_secs(),
        routing_hints: converted_hints,
        payment_hash: invoice.payment_hash().encode_hex::<String>(),
        payment_secret: invoice.payment_secret().0.to_vec(),
        description: match invoice.description() {
            InvoiceDescription::Direct(msg) => Some(msg.to_string()),
            InvoiceDescription::Hash(_) => None,
        },
        description_hash: match invoice.description() {
            InvoiceDescription::Direct(_) => None,
            InvoiceDescription::Hash(h) => Some(h.0.to_string()),
        },
    };
    Ok(ln_invoice)
}

#[cfg(test)]
mod tests {
    use crate::invoice::*;

    #[test]
    fn test_parse_invoice() {
        let payreq = String::from("lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz");
        let res = parse_invoice(&payreq).unwrap();

        let private_key_vec =
            hex::decode("3e171115f50b2c355836dc026a6d54d525cf0d796eb50b3460a205d25c9d38fd")
                .unwrap();
        let mut private_key: [u8; 32] = Default::default();
        private_key.copy_from_slice(&private_key_vec[0..32]);
        let hint_hop = RouteHintHop {
            src_node_id: res.payee_pubkey,
            short_channel_id: 1234,
            fees_base_msat: 1000,
            fees_proportional_millionths: 100,
            cltv_expiry_delta: 2000,
            htlc_minimum_msat: Some(3000),
            htlc_maximum_msat: Some(4000),
        };
        let route_hint = RouteHint {
            hops: vec![hint_hop],
        };

        let encoded = add_lsp_routing_hints(payreq, Some(route_hint), 100).unwrap();
        print!("{encoded:?}");
    }
}
