#[macro_use]
extern crate log;
mod command_handlers;
mod commands;
mod config;
mod persist;

use crate::command_handlers::CliHelper;
use anyhow::{anyhow, ensure, Result};
use breez_sdk_core::BreezServices;
use clap::Parser;
use command_handlers::handle_command;
use commands::{Commands, SdkCli};
use persist::CliPersistence;
use rustyline::error::ReadlineError;
use rustyline::hint::HistoryHinter;
use rustyline::Editor;
use std::path::Path;

#[tokio::main]
async fn main() -> Result<()> {
    let cli = SdkCli::parse();
    let data_dir = cli.data_dir.clone().unwrap_or(".".to_string());
    let data_dir_path = Path::new(&data_dir);
    ensure!(
        data_dir_path.exists(),
        "Error: data directory doesn't exist"
    );

    BreezServices::init_logging(&data_dir, None)?;

    let persistence = CliPersistence { data_dir };
    let history_file = &persistence.history_file();

    let rl = &mut Editor::new()?;
    rl.set_helper(Some(CliHelper {
        hinter: HistoryHinter {},
    }));
    if rl.load_history(history_file).is_err() {
        info!("No previous history.");
    }

    loop {
        let readline = rl.readline("sdk> ");
        match readline {
            Ok(line) => {
                rl.add_history_entry(line.as_str())?;
                let mut vec: Vec<String> =
                    shlex::split(&line).ok_or(anyhow!("Could not parse command"))?;
                vec.insert(0, String::from(" "));
                let cli_res = Commands::try_parse_from(vec);
                if cli_res.is_err() {
                    println!("{}", cli_res.unwrap_err());
                    continue;
                }
                let res = handle_command(rl, &persistence, cli_res.unwrap()).await;
                show_results(res);
                continue;
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
    rl.save_history(history_file).map_err(|e| anyhow!(e))
}

fn show_results(res: Result<String>) {
    match res {
        Ok(inner) => println!("{inner}"),
        Err(err) => eprintln!("Error: {err}"),
    }
}
