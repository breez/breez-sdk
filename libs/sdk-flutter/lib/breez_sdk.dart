import 'dart:async';

import 'package:breez_sdk/native_toolkit.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'generated/binding.dart' as binding;

class BreezSDK {
  late BindingBreezServices breezServices;

  BreezSDK() {
    verifyInitialized();
  }

  /* Streams */

  final StreamController<InvoicePaidDetails> _invoicePaidStream = StreamController.broadcast();

  /// Listen to paid Invoice events
  Stream<InvoicePaidDetails> get invoicePaidStream => _invoicePaidStream.stream;

  final StreamController<Payment> _paymentResultStream = StreamController.broadcast();

  /// Listen to payment results
  Stream<Payment> get paymentResultStream => _paymentResultStream.stream;

  Future<void> verifyInitialized() async {
    try {
      if (!BreezSdkBindings.instance.initialized) {
        await BreezSdkBindings.init(externalLibrary: createLibraryImpl());
      }
    } catch (e) {
      throw Exception("Failed to initialize BreezSdkBindings");
    }
  }

  /* SDK Streams */

  StreamSubscription<BreezEvent>? _breezEventsSubscription;
  StreamSubscription<LogEntry>? _breezLogSubscription;

  Stream<BreezEvent>? _breezEventsStream;
  Stream<LogEntry>? _breezLogStream;

  /// Initializes SDK events & log streams.
  ///
  /// Call once on your Dart entrypoint file, e.g.; `lib/main.dart`.
  void initialize() {
    _initializeEventsStream();
    _initializeLogStream();
  }

  void _initializeEventsStream() {
    _breezEventsStream ??= binding.breezEventsStream().asBroadcastStream();
  }

  void _initializeLogStream() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _breezLogStream ??= const EventChannel('breez_sdk_node_logs')
          .receiveBroadcastStream()
          .map((log) => LogEntry(line: log["line"], level: log["level"]));
    } else {
      _breezLogStream ??= binding.breezLogStream().asBroadcastStream();
    }
  }

  /* Breez Services API's & Streams*/

  final _logStreamController = StreamController<LogEntry>.broadcast();

  /// Listen to log events
  Stream<LogEntry> get logStream => _logStreamController.stream;

  final StreamController<NodeState?> nodeStateController = BehaviorSubject<NodeState?>();

  /// Listen to node state
  Stream<NodeState?> get nodeStateStream => nodeStateController.stream;

  /// connect initializes the global NodeService, schedule the node to run in the cloud and
  /// run the signer. This must be called in order to start communicate with the node
  ///
  /// # Arguments
  ///
  /// * `req` - The connect request containing the `config` sdk configuration and `seed` node private key
  Future<BindingBreezServices> connect({
    required ConnectRequest req,
  }) async {
    breezServices = await binding.connect(req: req);
    _subscribeToSdkStreams();
    await fetchNodeData();
    return breezServices;
  }

  /// get the node state from the persistent storage
  Future<NodeState?> nodeInfo() async {
    final nodeState = await breezServices.nodeInfo();
    nodeStateController.add(nodeState);
    return nodeState;
  }

  /// Cleanup node resources and stop the signer.
  Future<void> disconnect() async {
    await breezServices.disconnect();
    _unsubscribeFromSdkStreams();
  }

  /* Breez Services Helper API's */

  /// Attempts to convert the phrase to a mnemonic, then to a seed.
  ///
  /// If the phrase is not a valid mnemonic, an error is returned.
  Future<Uint8List> mnemonicToSeed(String phrase) async => await binding.mnemonicToSeed(phrase: phrase);

  /// Get the full default config for a specific environment type
  Future<Config> defaultConfig({
    required EnvironmentType envType,
    required String apiKey,
    required NodeConfig nodeConfig,
  }) async {
    return await binding.defaultConfig(
      envType: envType,
      apiKey: apiKey,
      nodeConfig: nodeConfig,
    );
  }

  /* Backup Streams*/

  // Listen to backup results
  final StreamController<BreezEvent?> _backupStreamController = BehaviorSubject<BreezEvent?>();

  Stream<BreezEvent?> get backupStream => _backupStreamController.stream;

  /* Parse API's */

  /// Parse a BOLT11 payment request and return a structure contains the parsed fields.
  Future<LNInvoice> parseInvoice(String invoice) async => await binding.parseInvoice(invoice: invoice);

  /// Parses generic user input, typically pasted from clipboard or scanned from a QR.
  Future<InputType> parseInput({required String input}) async => await binding.parseInput(input: input);

  /// Get the static backup data.
  Future<StaticBackupResponse> staticBackup({
    required StaticBackupRequest req,
  }) async {
    return await binding.staticBackup(req: req);
  }

  /* Payment API's & Streams*/

  /// Listen to payment list
  final StreamController<List<Payment>> paymentsController = BehaviorSubject<List<Payment>>();

  Stream<List<Payment>> get paymentsStream => paymentsController.stream;

  /// list payments (incoming/outgoing payments) from the persistent storage
  Future<List<Payment>> listPayments({
    required ListPaymentsRequest req,
  }) async {
    final paymentsList = await breezServices.listPayments(req: req);
    paymentsController.add(paymentsList);
    return paymentsList;
  }

  /* Fiat Currency API's */

  /// Fetch live rates of fiat currencies
  Future<Map<String, Rate>> fetchFiatRates() async {
    final List<Rate> rates = await breezServices.fetchFiatRates();
    return rates.fold<Map<String, Rate>>({}, (map, rate) {
      map[rate.coin] = rate;
      return map;
    });
  }

  /* Swap Stream */

  final StreamController<BreezEvent_SwapUpdated> _swapEventsStreamController =
      BehaviorSubject<BreezEvent_SwapUpdated>();

  Stream<BreezEvent_SwapUpdated> get swapEventsStream => _swapEventsStreamController.stream;

  /* On-Chain Swap API's */

  /// Withdraw on-chain funds in the wallet to an external btc address
  Future<RedeemOnchainFundsResponse> redeemOnchainFunds({
    required RedeemOnchainFundsRequest req,
  }) async {
    final redeemOnchainFundsResponse = await breezServices.redeemOnchainFunds(req: req);
    await listPayments(req: const ListPaymentsRequest());
    return redeemOnchainFundsResponse;
  }

  /// Fetches the service health check from the support API.
  Future<ServiceHealthCheckResponse> serviceHealthCheck({
    required String apiKey,
  }) async {
    return await binding.serviceHealthCheck(apiKey: apiKey);
  }

  /* Helper Methods */

  /// Validate if given address is a valid BTC address
  Future<bool> isValidBitcoinAddress(
    String address,
  ) async {
    try {
      final inputType = await binding.parseInput(input: address);
      return inputType is InputType_BitcoinAddress;
    } catch (e) {
      return false;
    }
  }

  /// Fetch node state & payment list
  Future fetchNodeData() async {
    await nodeInfo();
    await listPayments(req: const ListPaymentsRequest());
  }

  /// Subscribes to SDK events & log streams.
  void _subscribeToSdkStreams() {
    _subscribeToEventsStream();
    _subscribeToLogStream();
  }

  /// Subscribes to BreezEvent's(new block, invoice paid, synced) stream
  void _subscribeToEventsStream() {
    _breezEventsSubscription = _breezEventsStream?.listen(
      (event) async {
        if (event is BreezEvent_InvoicePaid) {
          _invoicePaidStream.add(event.details);
          await fetchNodeData();
        }
        if (event is BreezEvent_Synced) {
          await fetchNodeData();
        }
        if (event is BreezEvent_PaymentSucceed) {
          _paymentResultStream.add(event.details);
        }
        if (event is BreezEvent_PaymentFailed) {
          _paymentResultStream.addError(PaymentException(event.details));
        }
        if (event is BreezEvent_BackupSucceeded) {
          _backupStreamController.add(event);
        }
        if (event is BreezEvent_BackupStarted) {
          _backupStreamController.add(event);
        }
        if (event is BreezEvent_BackupFailed) {
          _backupStreamController.addError(BackupException(event.details));
        }
        if (event is BreezEvent_SwapUpdated) {
          _swapEventsStreamController.add(event);
        }
      },
    );
  }

  /// Subscribes to node logs stream
  void _subscribeToLogStream() {
    _breezLogSubscription = _breezLogStream?.listen((logEntry) {
      _logStreamController.add(logEntry);
    }, onError: (e) {
      _logStreamController.addError(e);
    });
  }

  /// Unsubscribes from SDK events & log streams.
  void _unsubscribeFromSdkStreams() {
    _breezEventsSubscription?.cancel();
    _breezLogSubscription?.cancel();
  }
}

extension SDKConfig on Config {
  Config copyWith({
    String? breezserver,
    String? chainnotifierUrl,
    String? mempoolspaceUrl,
    String? workingDir,
    Network? network,
    int? paymentTimeoutSec,
    String? defaultLspId,
    String? apiKey,
    double? maxfeePercent,
    BigInt? exemptfeeMsat,
    NodeConfig? nodeConfig,
  }) {
    return Config(
      breezserver: breezserver ?? this.breezserver,
      chainnotifierUrl: chainnotifierUrl ?? this.chainnotifierUrl,
      mempoolspaceUrl: mempoolspaceUrl ?? this.mempoolspaceUrl,
      workingDir: workingDir ?? this.workingDir,
      network: network ?? this.network,
      paymentTimeoutSec: paymentTimeoutSec ?? this.paymentTimeoutSec,
      defaultLspId: defaultLspId ?? this.defaultLspId,
      apiKey: apiKey ?? this.apiKey,
      maxfeePercent: maxfeePercent ?? this.maxfeePercent,
      exemptfeeMsat: exemptfeeMsat ?? this.exemptfeeMsat,
      nodeConfig: nodeConfig ?? this.nodeConfig,
    );
  }
}
