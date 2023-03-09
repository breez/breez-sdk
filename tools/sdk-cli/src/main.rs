#[macro_use]
extern crate log;
mod config;

use std::fs;
use std::io;
use std::str::SplitWhitespace;
use std::sync::Arc;

use crate::config::{get_or_create_config, save_config};
use anyhow::{anyhow, Result};
use bip39::{Language, Mnemonic, MnemonicType, Seed};
use breez_sdk_core::InputType::LnUrlWithdraw;
use breez_sdk_core::{
    parse, BreezEvent, BreezServices, EnvironmentType, EventListener, GreenlightCredentials,
    InputType::LnUrlPay, LspInformation, Network, PaymentTypeFilter,
};
use env_logger::Env;
use once_cell::sync::{Lazy, OnceCell};
use rustyline::error::ReadlineError;
use rustyline::Editor;

static BREEZ_SERVICES: OnceCell<Arc<BreezServices>> = OnceCell::new();
static RT: Lazy<tokio::runtime::Runtime> = Lazy::new(|| tokio::runtime::Runtime::new().unwrap());

fn sdk() -> Result<Arc<BreezServices>> {
    BREEZ_SERVICES
        .get()
        .ok_or("Breez Services not initialized")
        .map_err(|err| anyhow!(err))
        .cloned()
}

fn rt() -> &'static tokio::runtime::Runtime {
    &RT
}

fn get_seed() -> Vec<u8> {
    let filename = "phrase";
    let mnemonic = match fs::read_to_string(filename) {
        Ok(phrase) => Mnemonic::from_phrase(phrase.as_str(), Language::English).unwrap(),
        Err(e) => {
            if e.kind() != io::ErrorKind::NotFound {
                panic!("Can't read from file: {filename}, err {e}");
            }
            let mnemonic = Mnemonic::new(MnemonicType::Words12, Language::English);
            fs::write(filename, mnemonic.phrase()).unwrap();
            mnemonic
        }
    };
    let seed = Seed::new(&mnemonic, "");
    seed.as_bytes().to_vec()
}

fn save_creds(creds: GreenlightCredentials) -> Result<()> {
    let filename = "creds";
    fs::write(filename, serde_json::to_vec(&creds)?)?;
    Ok(())
}

fn get_creds() -> Option<GreenlightCredentials> {
    let filename = "creds";
    let creds: Option<GreenlightCredentials> = match fs::read(filename) {
        Ok(raw) => Some(serde_json::from_slice(raw.as_slice()).unwrap()),
        Err(e) => {
            if e.kind() != io::ErrorKind::NotFound {
                panic!("Can't read from file: {filename}, err {e}");
            }
            None
        }
    };
    creds
}

struct CliEventListener {}
impl EventListener for CliEventListener {
    fn on_event(&self, e: BreezEvent) {
        info!("Received Breez event: {:?}", e);
    }
}

async fn init_sdk(seed: &[u8], creds: &GreenlightCredentials) -> Result<()> {
    let service = BreezServices::init_services(
        get_or_create_config()?.to_sdk_config(),
        seed.to_vec(),
        creds.clone(),
        Box::new(CliEventListener {}),
    )
    .await?;

    BREEZ_SERVICES
        .set(service)
        .map_err(|_| anyhow!("Failed to set Breez Service"))?;

    BreezServices::start(rt(), &sdk()?).await
}

#[tokio::main]
async fn main() -> Result<()> {
    env_logger::Builder::from_env(
        Env::default()
            .default_filter_or("debug,rustyline=warn,hyper=warn,reqwest=warn,rustls=warn,h2=warn"),
    )
    .init();
    let seed = get_seed();

    let mut rl = Editor::<()>::new()?;
    if rl.load_history("history.txt").is_err() {
        info!("No previous history.");
    }

    loop {
        let readline = rl.readline("sdk> ");
        match readline {
            Ok(line) => {
                rl.add_history_entry(line.as_str());
                let mut command: SplitWhitespace = line.as_str().split_whitespace();
                match command.next() {
                    Some("set_api_key") => {
                        let api_key = command
                            .next()
                            .ok_or("missing api_key")
                            .map_err(|err| anyhow!(err))?;

                        let mut config = get_or_create_config()?;
                        config.api_key = Some(api_key.to_string());
                        save_config(config)?;
                    }
                    Some("set_env") => {
                        let env: EnvironmentType = command
                            .next()
                            .ok_or("missing env")
                            .map_err(|err| anyhow!(err))?
                            .parse()?;

                        let mut config = get_or_create_config()?;
                        config.env = env;
                        save_config(config)?;
                    }
                    Some("register_node") => {
                        let creds =
                            BreezServices::register_node(Network::Bitcoin, seed.to_vec()).await?;

                        let res = init_sdk(&seed, &creds).await;
                        info!(
                            "device_cert: {}; device_key: {}",
                            hex::encode(&creds.device_cert),
                            hex::encode_upper(&creds.device_key)
                        );
                        save_creds(creds)?;
                        show_results(res);
                    }
                    Some("recover_node") => {
                        let creds =
                            BreezServices::recover_node(Network::Bitcoin, seed.to_vec()).await?;

                        let res = init_sdk(&seed, &creds).await;
                        info!(
                            "device_cert: {}; device_key: {}",
                            hex::encode(&creds.device_cert),
                            hex::encode_upper(&creds.device_key)
                        );
                        save_creds(creds)?;
                        show_results(res);
                    }
                    Some("init") => match get_creds() {
                        Some(creds) => {
                            let res = init_sdk(&seed, &creds).await;
                            show_results(res);
                        }
                        None => error!("Credentials not found"),
                    },
                    Some("sync") => show_results(sdk()?.sync().await),
                    Some("receive_payment") => {
                        let amount_sats: u64 = command.next().unwrap().parse()?;
                        let description = command.next().unwrap().parse()?;

                        show_results(sdk()?.receive_payment(amount_sats, description).await);
                    }
                    Some("lnurl_pay") => {
                        let lnurl_endpoint =
                            rl.readline("Destination LNURL-pay or LN Address: ")?;

                        match parse(&lnurl_endpoint).await? {
                            LnUrlPay { data: pd } => {
                                let prompt = format!(
                                    "Amount to pay in sats (min {} sat, max {} sat: ",
                                    pd.min_sendable / 1000,
                                    pd.max_sendable / 1000
                                );

                                let amount_sat = rl.readline(&prompt)?;
                                let pay_res =
                                    sdk()?.lnurl_pay(amount_sat.parse::<u64>()?, None, pd).await;
                                show_results(pay_res);
                            }
                            _ => error!("Unexpected result type"),
                        }
                    }
                    Some("lnurl_withdraw") => {
                        let lnurl_endpoint = rl.readline("LNURL-withdraw link: ")?;

                        match parse(&lnurl_endpoint).await? {
                            LnUrlWithdraw { data: wd } => {
                                info!("Endpoint description: {}", wd.default_description);

                                // Bounds for a withdrawal amount. Normally these would also consider NodeState params:
                                // max can receive = min(maxWithdrawable, local estimation of how much can be routed into wallet)
                                // min can receive = max(minWithdrawable, local minimal value allowed by wallet)
                                // However, for simplicity, we just use the LNURL-withdraw min/max bounds
                                let user_input_max_sat = wd.max_withdrawable / 1000;
                                let user_input_min_sat = 2001;

                                if user_input_max_sat < user_input_min_sat {
                                    error!("The LNURLw endpoint needs to accept at least {} sats, but min / max withdrawable are {} sat / {} sat",
                                        user_input_min_sat,
                                        wd.min_withdrawable / 1000,
                                        wd.max_withdrawable / 1000
                                    );
                                    break;
                                }

                                let prompt = format!(
                                    "Amount to withdraw in sats (min {user_input_min_sat} sat, max {user_input_max_sat} sat: ",
                                );
                                let user_input_withdraw_amount_sat = rl.readline(&prompt)?;

                                let amount_sats: u64 = user_input_withdraw_amount_sat.parse()?;
                                let description = "LNURL-withdraw";

                                let withdraw_res = sdk()?
                                    .lnurl_withdraw(wd, amount_sats, Some(description.into()))
                                    .await;
                                show_results(withdraw_res);
                            }
                            _ => error!("Unexpected result type"),
                        }
                    }
                    Some("send_payment") => {
                        let bolt11 = command
                            .next()
                            .ok_or("Expected bolt11 arg")
                            .map_err(|err| anyhow!(err))?;
                        let amount_sats: Option<u64> =
                            command.next().and_then(|v| v.parse::<u64>().ok());

                        show_results(sdk()?.send_payment(bolt11.into(), amount_sats).await)
                    }
                    Some("send_spontaneous_payment") => {
                        let node_id = command
                            .next()
                            .ok_or("Expected node_id arg")
                            .map_err(|err| anyhow!(err))?;
                        let amount_sats = command
                            .next()
                            .ok_or("Expected amount_sats arg")
                            .map_err(|err| anyhow!(err))?;

                        show_results(
                            sdk()?
                                .send_spontaneous_payment(node_id.into(), amount_sats.parse()?)
                                .await,
                        )
                    }
                    Some("list_payments") => show_results(
                        sdk()?
                            .list_payments(PaymentTypeFilter::All, None, None)
                            .await,
                    ),
                    Some("sweep") => {
                        let to_address = command
                            .next()
                            .ok_or("Expected to_address arg")
                            .map_err(|err| anyhow!(err))?;
                        let fee_rate_sats_per_byte: u64 = command
                            .next()
                            .ok_or("Expected fee_rate_sats_per_byte arg")
                            .map_err(|err| anyhow!(err))?
                            .parse()?;

                        show_results(
                            sdk()?
                                .sweep(to_address.into(), fee_rate_sats_per_byte)
                                .await,
                        )
                    }
                    Some("list_lsps") => show_results(sdk()?.list_lsps().await),
                    Some("connect_lsp") => {
                        let lsps: Vec<LspInformation> = sdk()?.list_lsps().await?;
                        let chosen_lsp_id = command
                            .next()
                            .ok_or("Expected LSP ID arg")
                            .map_err(|err| anyhow!(err))?;
                        let chosen_lsp: &LspInformation = lsps
                            .iter()
                            .find(|lsp| lsp.id == chosen_lsp_id)
                            .ok_or("No LSP found for given LSP ID")
                            .map_err(|err| anyhow!(err))?;
                        sdk()?.connect_lsp(chosen_lsp_id.to_string()).await?;

                        info!(
                            "Set LSP ID: {} / LSP Name: {}",
                            chosen_lsp_id, chosen_lsp.name
                        );
                    }
                    Some("node_info") => show_results(sdk()?.node_info()),
                    Some("list_fiat") => show_results(sdk()?.list_fiat_currencies().await),
                    Some("fetch_fiat_rates") => show_results(sdk()?.fetch_fiat_rates().await),
                    Some("close_lsp_channels") => show_results(sdk()?.close_lsp_channels().await),
                    Some("stop_node") => show_results(sdk()?.stop().await),
                    Some("recommended_fees") => show_results(sdk()?.recommended_fees().await),
                    Some("receive_onchain") => show_results(sdk()?.receive_onchain().await),
                    Some("reverse_swap_info") => show_results(sdk()?.reverse_swap_info().await),
                    Some("send_onchain") => {
                        let amount_sat: u64 = command
                            .next()
                            .ok_or("Expected amount_sat arg")
                            .map_err(|err| anyhow!(err))?
                            .parse()?;
                        let onchain_recipient_address: String = command
                            .next()
                            .ok_or("Expected onchain_recipient_address arg")
                            .map_err(|err| anyhow!(err))?
                            .into();

                        let temp = sdk()?.reverse_swap_info().await?;
                        show_results(
                            sdk()?
                                .send_onchain(amount_sat, onchain_recipient_address, temp.fees_hash)
                                .await,
                        )
                    }
                    Some("in_progress_swap") => show_results(sdk()?.in_progress_swap().await),
                    Some("list_refundables") => show_results(sdk()?.list_refundables().await),
                    Some("execute_dev_command") => {
                        let cmd = command
                            .next()
                            .ok_or("Expected command")
                            .map_err(|err| anyhow!(err))?;

                        show_results(sdk()?.execute_dev_command(cmd.to_string()).await);
                    }
                    Some("refund") => show_results({
                        let swap_address = command
                            .next()
                            .ok_or("Expected swap_address arg")
                            .map_err(|err| anyhow!(err))?;
                        let to_address = command
                            .next()
                            .ok_or("Expected to_address arg")
                            .map_err(|err| anyhow!(err))?;
                        let sat_per_vbyte: u32 = command
                            .next()
                            .ok_or("Expected fee (sat per vbyte) arg")
                            .map_err(|err| anyhow!(err))?
                            .parse()?;

                        sdk()?
                            .refund(
                                swap_address.to_string(),
                                to_address.to_string(),
                                sat_per_vbyte,
                            )
                            .await
                    }),
                    Some("exit") => break,
                    Some("help") => println!("{}", help_message()),
                    Some(_) => error!("Unrecognized command: {}", line.as_str()),
                    None => (),
                }
                //info!("Line: {}", line);
            }
            Err(ReadlineError::Interrupted) => {
                info!("CTRL-C");
                break;
            }
            Err(ReadlineError::Eof) => {
                info!("CTRL-D");
                break;
            }
            Err(err) => {
                error!("Error: {:?}", err);
                break;
            }
        }
    }
    rl.save_history("history.txt").map_err(|e| anyhow!(e))
}

fn show_results<T>(res: Result<T>)
where
    T: core::fmt::Debug,
{
    match res {
        Ok(inner) => {
            info!("response: {:#?}", inner);
        }
        Err(err) => error!("Error: {}", err),
    }
}

fn help_message() -> String {
    r#"
Configuration:
    set_api_key <key>
    set_env <staging|production>
Node:
    init
    recover_node
    register_node
    stop_node
    node_info
    sync
    execute_command
LSP:
    close_lsp_channels
    connect_lsp
    list_lsps
Payments:
    list_payments
    lnurl_pay
    lnurl_withdraw
    receive_onchain
    receive_payment
    recommended_fees
    send_payment
    send_spontaneous_payment
    sweep
    in_progress_swap
    list_refundables
    refund
Fiat:
    fetch_fiat_rates
    list_fiat
Misc:
    exit: exit the program
    help: show this help
"#
    .to_string()
}
