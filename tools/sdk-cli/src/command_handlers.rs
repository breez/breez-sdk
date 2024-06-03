use std::fs;
use std::sync::Arc;

use anyhow::{anyhow, Context, Error, Result};
use breez_sdk_core::InputType::{LnUrlAuth, LnUrlPay, LnUrlWithdraw};
use breez_sdk_core::{
    parse, BreezEvent, BreezServices, BuyBitcoinRequest, CheckMessageRequest, ConnectRequest,
    EventListener, GreenlightCredentials, ListPaymentsRequest, LnUrlPayRequest,
    LnUrlWithdrawRequest, MetadataFilter, PayOnchainRequest, PrepareOnchainPaymentRequest,
    PrepareRedeemOnchainFundsRequest, PrepareRefundRequest, ReceiveOnchainRequest,
    ReceivePaymentRequest, RedeemOnchainFundsRequest, RefundRequest, ReportIssueRequest,
    ReportPaymentFailureDetails, ReverseSwapFeesRequest, SendOnchainRequest, SendPaymentRequest,
    SendSpontaneousPaymentRequest, SignMessageRequest, StaticBackupRequest, SwapAmountType,
};
use breez_sdk_core::{GreenlightNodeConfig, NodeConfig};
use once_cell::sync::OnceCell;
use qrcode_rs::render::unicode;
use qrcode_rs::{EcLevel, QrCode};
use rustyline::history::DefaultHistory;

use crate::persist::CliPersistence;
use crate::Commands;

use std::borrow::Cow::{self, Owned};

use rustyline::highlight::Highlighter;
use rustyline::hint::HistoryHinter;
use rustyline::Editor;
use rustyline::{Completer, Helper, Hinter, Validator};

static BREEZ_SERVICES: OnceCell<Arc<BreezServices>> = OnceCell::new();

fn sdk() -> Result<Arc<BreezServices>> {
    BREEZ_SERVICES
        .get()
        .ok_or("Breez Services not initialized")
        .map_err(|err| anyhow!(err))
        .cloned()
}

struct CliEventListener {}

impl EventListener for CliEventListener {
    fn on_event(&self, e: BreezEvent) {
        info!("Received Breez event: {e:?}");
    }
}

async fn connect(req: ConnectRequest) -> Result<()> {
    let service = BreezServices::connect(req, Box::new(CliEventListener {})).await?;
    BREEZ_SERVICES
        .set(service)
        .map_err(|_| anyhow!("Breez Services already initialized"))?;

    Ok(())
}

#[derive(Helper, Completer, Hinter, Validator)]
pub(crate) struct CliHelper {
    #[rustyline(Hinter)]
    pub(crate) hinter: HistoryHinter,
}

impl Highlighter for CliHelper {
    fn highlight_hint<'h>(&self, hint: &'h str) -> Cow<'h, str> {
        Owned("\x1b[1m".to_owned() + hint + "\x1b[m")
    }
}

pub(crate) async fn handle_command(
    rl: &mut Editor<CliHelper, DefaultHistory>,
    persistence: &CliPersistence,
    command: Commands,
) -> Result<String, Error> {
    match command {
        Commands::SetAPIKey { key } => {
            let mut config = persistence.get_or_create_config()?;
            config.api_key = Some(key);
            persistence.save_config(config)?;
            Ok("API key was set".to_string())
        }
        Commands::SetEnv { env } => {
            let mut config = persistence.get_or_create_config()?;
            config.env = env.clone();
            persistence.save_config(config)?;
            Ok(format!("Environment was set to {env:?}"))
        }
        Commands::Connect {
            partner_cert,
            partner_key,
            invite_code,
            restore_only,
        } => {
            let mut config = persistence
                .get_or_create_config()?
                .to_sdk_config(&persistence.data_dir);
            let mut partner_credentials: Option<GreenlightCredentials> = None;
            if partner_cert.is_some() && partner_key.is_some() {
                let cert = fs::read(partner_cert.unwrap())?;
                let key = fs::read(partner_key.unwrap())?;
                partner_credentials = Some(GreenlightCredentials {
                    device_cert: cert,
                    device_key: key,
                })
            }

            config.node_config = NodeConfig::Greenlight {
                config: GreenlightNodeConfig {
                    partner_credentials,
                    invite_code,
                },
            };

            connect(ConnectRequest {
                config,
                seed: persistence.get_or_create_seed(),
                restore_only: Some(restore_only),
            })
            .await?;
            Ok("Node was connected successfully".to_string())
        }
        Commands::Sync {} => {
            sdk()?.sync().await?;
            Ok("Sync finished successfully".to_string())
        }
        Commands::Parse { input } => parse(&input)
            .await
            .map(|res| serde_json::to_string_pretty(&res))?
            .map_err(|e| e.into()),
        Commands::ReceivePayment {
            amount_msat,
            description,
            use_description_hash,
            expiry,
            cltv,
        } => {
            let recv_payment_response = sdk()?
                .receive_payment(ReceivePaymentRequest {
                    amount_msat,
                    description,
                    use_description_hash,
                    expiry,
                    cltv,
                    ..Default::default()
                })
                .await?;
            let mut result = serde_json::to_string(&recv_payment_response)?;
            result.push('\n');
            result.push_str(&build_qr_text(&recv_payment_response.ln_invoice.bolt11));
            Ok(result)
        }
        Commands::SendOnchain {
            amount_sat,
            onchain_recipient_address,
            sat_per_vbyte,
        } => {
            let pair_info = sdk()?
                .fetch_reverse_swap_fees(ReverseSwapFeesRequest::default())
                .await
                .map_err(|e| anyhow!("Failed to fetch reverse swap fee infos: {e}"))?;

            #[allow(deprecated)]
            let rev_swap_res = sdk()?
                .send_onchain(SendOnchainRequest {
                    amount_sat,
                    onchain_recipient_address,
                    pair_hash: pair_info.fees_hash,
                    sat_per_vbyte,
                })
                .await?;
            serde_json::to_string_pretty(&rev_swap_res.reverse_swap_info).map_err(|e| e.into())
        }
        Commands::MaxReverseSwapAmount {} => {
            #[allow(deprecated)]
            let response = sdk()?.max_reverse_swap_amount().await?;
            serde_json::to_string_pretty(&response).map_err(|e| e.into())
        }
        Commands::OnchainPaymentLimits {} => {
            let response = sdk()?.onchain_payment_limits().await?;
            serde_json::to_string_pretty(&response).map_err(|e| e.into())
        }
        Commands::PrepareOnchainPayment {
            amount_sat,
            is_send,
            claim_tx_feerate,
        } => {
            let req = PrepareOnchainPaymentRequest {
                amount_sat,
                amount_type: match is_send {
                    true => SwapAmountType::Send,
                    false => SwapAmountType::Receive,
                },
                claim_tx_feerate,
            };
            let response = sdk()?.prepare_onchain_payment(req).await?;
            serde_json::to_string_pretty(&response).map_err(|e| e.into())
        }
        Commands::PayOnchain {
            amount_sat,
            is_send,
            claim_tx_feerate,
            recipient_address,
        } => {
            let req_prepare = PrepareOnchainPaymentRequest {
                amount_sat,
                amount_type: match is_send {
                    true => SwapAmountType::Send,
                    false => SwapAmountType::Receive,
                },
                claim_tx_feerate,
            };
            let res_prepare = sdk()?.prepare_onchain_payment(req_prepare).await?;

            let req = PayOnchainRequest {
                recipient_address,
                prepare_res: res_prepare,
            };
            let response = sdk()?.pay_onchain(req).await?;
            serde_json::to_string_pretty(&response).map_err(|e| e.into())
        }
        Commands::FetchOnchainFees {
            send_amount_sat,
            claim_tx_feerate,
        } => {
            let pair_info = sdk()?
                .fetch_reverse_swap_fees(ReverseSwapFeesRequest {
                    send_amount_sat,
                    claim_tx_feerate,
                })
                .await
                .map_err(|e| anyhow!("Failed to fetch reverse swap fee infos: {e}"))?;
            serde_json::to_string_pretty(&pair_info).map_err(|e| e.into())
        }
        Commands::InProgressReverseSwaps {} => {
            let mut res: Vec<String> = vec![];
            for rsi in &sdk()?.in_progress_onchain_payments().await? {
                res.push(format!(
                    "Reverse swap {} is in progress with status {:?}",
                    rsi.id, rsi.status
                ));
            }
            serde_json::to_string_pretty(&res).map_err(|e| e.into())
        }
        Commands::SendPayment {
            bolt11,
            amount_msat,
            label,
        } => {
            let payment = sdk()?
                .send_payment(SendPaymentRequest {
                    bolt11,
                    amount_msat,
                    label,
                })
                .await?;
            serde_json::to_string_pretty(&payment).map_err(|e| e.into())
        }
        Commands::SendSpontaneousPayment {
            node_id,
            amount_msat,
            label,
        } => {
            let response = sdk()?
                .send_spontaneous_payment(SendSpontaneousPaymentRequest {
                    node_id,
                    amount_msat,
                    extra_tlvs: None,
                    label,
                })
                .await?;
            serde_json::to_string_pretty(&response.payment).map_err(|e| e.into())
        }
        Commands::ListPayments {
            from_timestamp,
            to_timestamp,
            include_failures,
            limit,
            offset,
            metadata_filters: metadata_filters_raw,
        } => {
            let metadata_filters = match metadata_filters_raw {
                Some(raw_filters) => {
                    let mut filters = vec![];

                    for filter in raw_filters.iter() {
                        let (json_path, json_value) =
                            filter.split_once(':').context("Invalid metadata filter")?;

                        filters.push(MetadataFilter {
                            json_path: json_path.to_string(),
                            json_value: json_value.to_string(),
                        });
                    }

                    Some(filters)
                }
                None => None,
            };

            let payments = sdk()?
                .list_payments(ListPaymentsRequest {
                    filters: None,
                    metadata_filters,
                    from_timestamp,
                    to_timestamp,
                    include_failures: Some(include_failures),
                    limit,
                    offset,
                })
                .await?;
            serde_json::to_string_pretty(&payments).map_err(|e| e.into())
        }
        Commands::SetPaymentMetadata {
            payment_hash,
            metadata,
        } => {
            sdk()?.set_payment_metadata(payment_hash, metadata).await?;

            Ok("Payment metadata was set successfully".to_string())
        }
        Commands::PaymentByHash { hash } => {
            let payment = sdk()?.payment_by_hash(hash).await?;
            serde_json::to_string_pretty(&payment).map_err(|e| e.into())
        }
        Commands::RedeemOnchainFunds {
            to_address,
            sat_per_vbyte,
        } => {
            let resp = sdk()?
                .redeem_onchain_funds(RedeemOnchainFundsRequest {
                    to_address,
                    sat_per_vbyte,
                })
                .await?;
            serde_json::to_string_pretty(&resp).map_err(|e| e.into())
        }
        Commands::PrepareRedeemOnchainFunds {
            to_address,
            sat_per_vbyte,
        } => {
            let resp = sdk()?
                .prepare_redeem_onchain_funds(PrepareRedeemOnchainFundsRequest {
                    to_address,
                    sat_per_vbyte,
                })
                .await?;
            serde_json::to_string_pretty(&resp).map_err(|e| e.into())
        }
        Commands::ListLsps {} => {
            let lsps = sdk()?.list_lsps().await?;
            serde_json::to_string_pretty(&lsps).map_err(|e| e.into())
        }
        Commands::LspInfo {} => {
            let lsp_info = sdk()?.lsp_info().await?;
            serde_json::to_string_pretty(&lsp_info).map_err(|e| e.into())
        }
        Commands::ConnectLSP { lsp_id } => {
            sdk()?.connect_lsp(lsp_id).await?;
            Ok("LSP connected successfully".to_string())
        }
        Commands::OpenChannelFee {
            amount_msat,
            expiry,
        } => {
            let res = sdk()?
                .open_channel_fee(breez_sdk_core::OpenChannelFeeRequest {
                    amount_msat,
                    expiry,
                })
                .await?;
            serde_json::to_string_pretty(&res).map_err(|e| e.into())
        }
        Commands::NodeCredentials {} => match sdk()?.node_credentials()? {
            Some(credentials) => serde_json::to_string_pretty(&credentials).map_err(|e| e.into()),
            None => Ok("No credentials".into()),
        },
        Commands::NodeInfo {} => {
            serde_json::to_string_pretty(&sdk()?.node_info()?).map_err(|e| e.into())
        }
        Commands::ConfigureNode { close_to_address } => {
            sdk()?
                .configure_node(breez_sdk_core::ConfigureNodeRequest { close_to_address })
                .await?;
            Ok("Node configured successfully".to_string())
        }
        Commands::ListFiat {} => {
            serde_json::to_string_pretty(&sdk()?.list_fiat_currencies().await?)
                .map_err(|e| e.into())
        }
        Commands::FetchFiatRates {} => {
            serde_json::to_string_pretty(&sdk()?.fetch_fiat_rates().await?).map_err(|e| e.into())
        }
        Commands::CloseLSPChannels {} => {
            let tx_ids = sdk()?.close_lsp_channels().await?;
            Ok(format!("Closing transaction ids:\n{tx_ids:?}"))
        }
        Commands::Disconnect {} => {
            sdk()?.disconnect().await?;
            Ok("Node was stopped successfully".to_string())
        }
        Commands::RecommendedFees {} => {
            serde_json::to_string_pretty(&sdk()?.recommended_fees().await?).map_err(|e| e.into())
        }
        Commands::ReceiveOnchain {} => serde_json::to_string_pretty(
            &sdk()?
                .receive_onchain(ReceiveOnchainRequest::default())
                .await?,
        )
        .map_err(|e| e.into()),
        Commands::InProgressSwap {} => {
            serde_json::to_string_pretty(&sdk()?.in_progress_swap().await?).map_err(|e| e.into())
        }
        Commands::ListRefundables {} => {
            serde_json::to_string_pretty(&sdk()?.list_refundables().await?).map_err(|e| e.into())
        }
        Commands::RescanSwaps {} => {
            sdk()?.rescan_swaps().await?;
            Ok("Rescan completed successfully".to_string())
        }
        Commands::PrepareRefund {
            swap_address,
            to_address,
            sat_per_vbyte,
        } => {
            let res = sdk()?
                .prepare_refund(PrepareRefundRequest {
                    swap_address,
                    to_address,
                    sat_per_vbyte,
                })
                .await?;
            Ok(format!(
                "Prepared refund tx - weight: {} - fees: {} sat",
                res.refund_tx_weight, res.refund_tx_fee_sat
            ))
        }
        Commands::Refund {
            swap_address,
            to_address,
            sat_per_vbyte,
        } => {
            let res = sdk()?
                .refund(RefundRequest {
                    swap_address,
                    to_address,
                    sat_per_vbyte,
                })
                .await?;
            Ok(format!("Refund tx: {}", res.refund_tx_id))
        }
        Commands::SignMessage { message } => {
            let req = SignMessageRequest { message };
            let res = sdk()?.sign_message(req).await?;
            Ok(format!("Message signature: {}", res.signature))
        }
        Commands::CheckMessage {
            message,
            pubkey,
            signature,
        } => {
            let req = CheckMessageRequest {
                message,
                pubkey,
                signature,
            };
            let res = sdk()?.check_message(req).await?;
            Ok(format!("Message was signed by node: {}", res.is_valid))
        }
        Commands::LnurlPay { lnurl, label } => match parse(&lnurl).await? {
            LnUrlPay { data: pd } => {
                let prompt = format!(
                    "Amount to pay in millisatoshi (min {} msat, max {} msat: ",
                    pd.min_sendable, pd.max_sendable
                );

                let amount_msat = rl.readline(&prompt)?;
                let pay_res = sdk()?
                    .lnurl_pay(LnUrlPayRequest {
                        data: pd,
                        amount_msat: amount_msat.parse::<u64>()?,
                        comment: None,
                        payment_label: label,
                    })
                    .await?;
                //show_results(pay_res);
                serde_json::to_string_pretty(&pay_res).map_err(|e| e.into())
            }
            _ => Err(anyhow!("Invalid input")),
        },
        Commands::LnurlWithdraw { lnurl } => {
            match parse(&lnurl).await? {
                LnUrlWithdraw { data: wd } => {
                    info!("Endpoint description: {}", wd.default_description);

                    // Bounds for a withdrawal amount. Normally these would also consider NodeState params:
                    // max can receive = min(maxWithdrawable, local estimation of how much can be routed into wallet)
                    // min can receive = max(minWithdrawable, local minimal value allowed by wallet)
                    // However, for simplicity, we just use the LNURL-withdraw min/max bounds
                    let user_input_max_msat = wd.max_withdrawable;
                    let user_input_min_msat = 2_001_000;

                    if user_input_max_msat < user_input_min_msat {
                        error!("The LNURLw endpoint needs to accept at least {user_input_min_msat} msat, but min / max withdrawable are {} msat / {} msat",
                            wd.min_withdrawable,
                            wd.max_withdrawable
                        );
                        return Ok("".to_string());
                    }

                    let prompt = format!(
                        "Amount to withdraw in msat (min {user_input_min_msat} msat, max {user_input_max_msat} msat: "
                    );
                    let user_input_withdraw_amount_msat = rl.readline(&prompt)?;

                    let amount_msat: u64 = user_input_withdraw_amount_msat.parse()?;
                    let description = "LNURL-withdraw";

                    let withdraw_res = sdk()?
                        .lnurl_withdraw(LnUrlWithdrawRequest {
                            data: wd,
                            amount_msat,
                            description: Some(description.into()),
                        })
                        .await?;
                    serde_json::to_string_pretty(&withdraw_res).map_err(|e| e.into())
                }
                _ => Err(anyhow!("Unexpected result type")),
            }
        }
        Commands::LnurlAuth { lnurl } => {
            let lnurl_endpoint = lnurl.trim();

            match parse(lnurl_endpoint).await? {
                LnUrlAuth { data: ad } => {
                    let auth_res = sdk()?.lnurl_auth(ad).await?;
                    serde_json::to_string_pretty(&auth_res).map_err(|e| e.into())
                }
                _ => Err(anyhow!("Unexpected result type")),
            }
        }
        Commands::ServiceHealthCheck {} => {
            let config: crate::config::CliConfig = persistence.get_or_create_config()?;
            match config.api_key {
                Some(api_key) => {
                    let health_check = BreezServices::service_health_check(api_key).await?;
                    serde_json::to_string_pretty(&health_check).map_err(|e| e.into())
                }
                None => Ok("No API key set".into()),
            }
        }
        Commands::ReportPaymentFailure {
            payment_hash,
            comment,
        } => {
            sdk()?
                .report_issue(ReportIssueRequest::PaymentFailure {
                    data: ReportPaymentFailureDetails {
                        payment_hash,
                        comment,
                    },
                })
                .await?;
            Ok("Report sent".into())
        }
        Commands::ExecuteDevCommand { args } => {
            let joined = shlex::try_join(args.iter().map(|s| s.as_ref()))?;
            serde_json::to_string_pretty(&sdk()?.execute_dev_command(joined).await?)
                .map_err(|e| e.into())
        }
        Commands::GenerateDiagnosticData {} => Ok(sdk()?.generate_diagnostic_data().await?),
        Commands::BuyBitcoin { provider } => {
            let res = sdk()?
                .buy_bitcoin(BuyBitcoinRequest {
                    provider: provider.clone(),
                    opening_fee_params: None,
                })
                .await?;
            Ok(format!("Here your {provider:?} url: {}", res.url))
        }
        Commands::Backup {} => {
            sdk().unwrap().backup().await?;
            Ok("Backup completed successfully".into())
        }
        Commands::StaticBackup {} => {
            let config = persistence
                .get_or_create_config()?
                .to_sdk_config(&persistence.data_dir);
            let backup_data = BreezServices::static_backup(StaticBackupRequest {
                working_dir: config.working_dir,
            })?;
            match backup_data.backup {
                Some(backup) => {
                    let backup_str = serde_json::to_string_pretty(&backup)?;
                    Ok(format!("Static backup data:\n{backup_str}"))
                }
                None => Ok("No static backup data".into()),
            }
        }
        Commands::RegisterWebhook { url } => {
            sdk()?.register_webhook(url).await?;
            Ok("Url registered successfully".into())
        }
        Commands::UnregisterWebhook { url } => {
            sdk()?.unregister_webhook(url).await?;
            Ok("Url unregistered successfully".into())
        }
    }
}

fn build_qr_text(text: &str) -> String {
    QrCode::with_error_correction_level(text, EcLevel::L)
        .unwrap()
        .render::<unicode::Dense1x2>()
        .dark_color(unicode::Dense1x2::Light)
        .light_color(unicode::Dense1x2::Dark)
        .build()
}
