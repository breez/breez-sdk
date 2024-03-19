use crate::{LogEntry, LogStream};
use anyhow::{anyhow, Result};
use chrono::Local;
use env_logger::{Builder, Logger, Target};
use flutter_rust_bridge::StreamSink;
use lazy_static::lazy_static;
use log::{
    max_level, set_boxed_logger, set_max_level, warn, LevelFilter, Log, Metadata, Record,
    STATIC_MAX_LEVEL,
};
use parking_lot::RwLock;
use std::fs::OpenOptions;
use std::io::Write;

use std::sync::Once;

/* env_logger */

const ENV_LOGGER_FILTER: &str = r#"
debug,
breez_sdk_core::backup=info,
breez_sdk_core::breez_services=info,
breez_sdk_core::input_parser=warn,
breez_sdk_core::persist::reverseswap=info,
breez_sdk_core::reverseswap=info,
gl_client::node=info,
gl_client::node::service=info,
gl_client::tls=info,
gl_client::scheduler=info,
gl_client::signer=info,
gl_client=debug,
h2=warn,
h2::client=info,
h2::codec::framed_read=warn,
h2::codec::framed_write=warn,
h2::proto::connection=info,
h2::proto::settings=info,
hyper=warn,
hyper::client::connect::dns=info,
hyper::client::connect::https=info,
lightning_signer=warn,
lightning_signer::node=warn,
reqwest=warn,
reqwest::connect=warn,
rustls=warn,
rustls::anchors=warn,
rustls::conn=warn,
rustls::client::common=warn,
rustls::client::hs=warn,
rustls::client::tls13=warn,
rustyline=warn,
rusqlite_migration=warn,
tower::buffer::worker=warn,
vls_protocol_signer=warn,
vls_protocol_signer::handler::HandlerBuilder::do_build=warn
"#;

fn init_env_logger(target: Option<Target>, filter_level: Option<LevelFilter>) -> Logger {
    let mut binding = Builder::new();
    let builder = binding
        .parse_filters(ENV_LOGGER_FILTER)
        .format(|buf, record| {
            writeln!(
                buf,
                "[{} {} {}:{}] {}",
                Local::now().format("%Y-%m-%d %H:%M:%S%.3f"),
                record.level(),
                record.module_path().unwrap_or("unknown"),
                record.line().unwrap_or(0),
                record.args()
            )
        });
    if let Some(target) = target {
        builder.target(target);
    }
    if let Some(filter_level) = filter_level {
        builder.filter_level(filter_level);
    }
    builder.build()
}

/* Dart */

static INIT_DART_LOGGER: Once = Once::new();

pub fn init_dart_logger() {
    INIT_DART_LOGGER.call_once(|| {
        let level = LevelFilter::Info;

        assert!(
            level <= STATIC_MAX_LEVEL,
            "Should respect STATIC_MAX_LEVEL={:?}, which is done in compile time. level{:?}",
            STATIC_MAX_LEVEL,
            level
        );
        let env_logger = Builder::new()
            .target(Target::Stdout)
            .filter_level(level)
            .format(|buf, record| {
                writeln!(
                    buf,
                    "[{} {} {}:{}] {}",
                    Local::now().format("%Y-%m-%d %H:%M:%S%.3f"),
                    record.level(),
                    record.module_path().unwrap_or("unknown"),
                    record.line().unwrap_or(0),
                    record.args()
                )
            })
            .build();

        let dart_logger = DartLogger { env_logger, level };
        set_boxed_logger(Box::new(dart_logger))
            .unwrap_or_else(|_| error!("Log stream already created."));
        set_max_level(level);
    });
}

lazy_static! {
    static ref DART_LOGGER_STREAM_SINK: RwLock<Option<StreamSink<LogEntry>>> = RwLock::new(None);
}

pub struct DartLogger {
    level: LevelFilter,
    env_logger: Logger,
}

impl DartLogger {
    pub fn set_stream_sink(stream_sink: StreamSink<LogEntry>) {
        let mut guard = DART_LOGGER_STREAM_SINK.write();
        if guard.is_some() {
            warn!(
                "BindingLogger::set_stream_sink but already exist a sink, thus overriding. \
                (This may or may not be a problem. It will happen normally if hot-reload Flutter app.)"
            );
        }
        *guard = Some(stream_sink);
        drop(guard)
    }

    fn record_to_entry(record: &Record) -> LogEntry {
        LogEntry {
            line: format!("{}", record.args()),
            level: format!("{}", record.level()),
        }
    }
}

impl Log for DartLogger {
    fn enabled(&self, _metadata: &Metadata) -> bool {
        _metadata.level() <= self.level
    }

    fn log(&self, record: &Record) {
        if self.enabled(record.metadata()) {
            self.env_logger.log(record);

            let entry = Self::record_to_entry(record);
            if let Some(sink) = &*DART_LOGGER_STREAM_SINK.read() {
                sink.add(entry);
            }
        }
    }

    fn flush(&self) {
        // no need
    }
}

/* UniFFI */

static INIT_UNIFFI_LOGGER: Once = Once::new();

pub fn init_uniffi_logger(log_stream: Box<dyn LogStream>) {
    INIT_UNIFFI_LOGGER.call_once(|| {
        UniFFILogger::set_log_stream(log_stream);
    });
}

pub struct UniFFILogger {
    log_stream: Box<dyn LogStream>,
}

impl UniFFILogger {
    fn set_log_stream(log_stream: Box<dyn LogStream>) {
        let level = LevelFilter::Trace;

        assert!(
            level <= STATIC_MAX_LEVEL,
            "Should respect STATIC_MAX_LEVEL={:?}, which is done in compile time. level{:?}",
            STATIC_MAX_LEVEL,
            level
        );
        let uniffi_logger = UniFFILogger { log_stream };
        set_boxed_logger(Box::new(uniffi_logger))
            .unwrap_or_else(|_| error!("Log stream already created."));
        set_max_level(level);
    }

    fn record_to_entry(record: &Record) -> LogEntry {
        LogEntry {
            line: format!("{}", record.args()),
            level: format!("{}", record.level()),
        }
    }
}

impl Log for UniFFILogger {
    fn enabled(&self, metadata: &Metadata) -> bool {
        // ignore the internal uniffi log to prevent infinite loop.
        return metadata.level() <= max_level()
            && *metadata.target() != *"breez_sdk_bindings::uniffi_binding";
    }

    fn log(&self, record: &Record) {
        let entry = Self::record_to_entry(record);
        self.log_stream.log(entry);
    }
    fn flush(&self) {}
}

/* Rust */

/// Configures a global SDK logger that will log to file and will forward log events to
/// an optional application-specific logger.
///
/// If called, it should be called before any SDK methods (for example, before `connect`).
///
/// It must be called only once in the application lifecycle. Alternatively, If the application
/// already uses a globally-registered logger, this method shouldn't be called at all.
///
/// ### Arguments
///
/// - `log_dir`: Location where the the SDK log file will be created. The directory must already exist.
///
/// - `app_logger`: Optional application logger.
///
/// If the application is to use it's own logger, but would also like the SDK to log SDK-specific
/// log output to a file in the configured `log_dir`, then do not register the
/// app-specific logger as a global logger and instead call this method with the app logger as an arg.
///
/// ### Logging Configuration
///
/// Setting `breez_sdk_core::input_parser=debug` will include in the logs the raw payloads received
/// when interacting with JSON endpoints, for example those used during all LNURL workflows.
///
/// ### Errors
///
/// An error is thrown if the log file cannot be created in the working directory.
///
/// An error is thrown if a global logger is already configured.
pub fn init_sdk_logger(log_dir: &str, app_logger: Option<Box<dyn Log>>) -> Result<()> {
    let target_log_file = Box::new(
        OpenOptions::new()
            .create(true)
            .append(true)
            .open(format!("{log_dir}/sdk.log"))
            .map_err(|e| anyhow!("Can't create log file: {e}"))?,
    );
    let logger = init_env_logger(Some(target_log_file));

    let global_logger = GlobalSdkLogger {
        logger,
        log_listener: app_logger,
    };

    set_boxed_logger(Box::new(global_logger))
        .map_err(|e| anyhow!("Failed to set global logger: {e}"))?;
    set_max_level(LevelFilter::Trace);

    Ok(())
}

pub struct GlobalSdkLogger {
    /// SDK internal logger, which logs to file
    logger: Logger,
    /// Optional external log listener, that can receive a stream of log statements
    log_listener: Option<Box<dyn Log>>,
}

impl Log for GlobalSdkLogger {
    fn enabled(&self, metadata: &Metadata) -> bool {
        metadata.level() <= max_level()
    }

    fn log(&self, record: &Record) {
        if self.enabled(record.metadata()) {
            self.logger.log(record);

            if let Some(s) = &self.log_listener.as_ref() {
                if s.enabled(record.metadata()) {
                    s.log(record);
                }
            }
        }
    }

    fn flush(&self) {}
}
