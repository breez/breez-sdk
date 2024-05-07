import 'dart:async';

import 'package:breez_sdk/native_toolkit.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'generated/binding.dart' as binding;

class BreezSDK {
  BreezSDK() {
    verifyInitialized();
  }

  /* Streams */

  /// Listen to paid Invoice events
  final StreamController<InvoicePaidDetails> _invoicePaidStream = StreamController.broadcast();

  Stream<InvoicePaidDetails> get invoicePaidStream => _invoicePaidStream.stream;

  /// Listen to payment results
  final StreamController<Payment> _paymentResultStream = StreamController.broadcast();

  Stream<Payment> get paymentResultStream => _paymentResultStream.stream;

  Future<void> verifyInitialized() async {
    try {
      if (!BreezSdkCore.instance.initialized) {
        await BreezSdkCore.init(externalLibrary: createLibraryImpl());
      }
    } catch (e) {
      throw Exception("Failed to initialize BreezSdkCore");
    }
  }

  /// Initializes SDK events & log streams
  void initialize() {
    _initializeEventsStream();
    _initializeLogStream();
  }

  /// Listen to BreezEvent's(new block, invoice paid, synced)
  void _initializeEventsStream() {
    binding.breezEventsStream().listen((event) async {
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
    });
  }

  /// Listen to node logs
  void _initializeLogStream() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      const EventChannel('breez_sdk_node_logs')
          .receiveBroadcastStream()
          .map((log) => LogEntry(line: log["line"], level: log["level"]))
          .listen(
            (log) => _logStreamController.add(log),
            onError: (e) => _logStreamController.addError(e),
          );
    } else {
      binding.breezLogStream().listen((logEntry) {
        _logStreamController.add(logEntry);
      }, onError: (e) {
        _logStreamController.addError(e);
      });
    }
  }

  final _logStreamController = StreamController<LogEntry>.broadcast();

  /// Listen to log events
  Stream<LogEntry> get logStream => _logStreamController.stream;

  /* Breez Services API's & Streams*/

  /// Listen to node state
  final StreamController<NodeState?> nodeStateController = BehaviorSubject<NodeState?>();

  Stream<NodeState?> get nodeStateStream => nodeStateController.stream;

  /// Register for webhook callbacks at the given `webhook_url` whenever a new payment is received.
  ///
  /// More webhook types may be supported in the future.
  Future<void> registerWebhook({required String webhookUrl}) async {
    return binding.registerWebhook(webhookUrl: webhookUrl);
  }

  /// connect initializes the global NodeService, schedule the node to run in the cloud and
  /// run the signer. This must be called in order to start communicate with the node
  ///
  /// # Arguments
  ///
  /// * `req` - The connect request containing the `config` sdk configuration and `seed` node private key
  Future connect({
    required ConnectRequest req,
  }) async {
    await binding.connect(
      req: req,
    );
    await fetchNodeData();
  }

  /// Check whether node service is initialized or not
  Future<bool> isInitialized() async => await binding.isInitialized();

  /// This method sync the local state with the remote node state.
  /// The synced items are as follows:
  /// * node state - General information about the node and its liquidity status
  /// * channels - The list of channels and their status
  /// * payments - The incoming/outgoing payments
  Future<void> sync() async => await binding.sync();

  /// get the node state from the persistent storage
  Future<NodeState?> nodeInfo() async {
    final nodeState = await binding.nodeInfo();
    nodeStateController.add(nodeState);
    return nodeState;
  }

  /// Configure an optional address to send funds to during a mutual channel close
  Future<void> configureNode({
    required ConfigureNodeRequest req,
  }) async {
    return await binding.configureNode(req: req);
  }

  /// Cleanup node resources and stop the signer.
  Future<void> disconnect() async => await binding.disconnect();

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

  /// Sign given message with the private key of the node id. Returns a zbase
  /// encoded signature.
  Future<SignMessageResponse> signMessage({
    required SignMessageRequest req,
  }) async {
    return await binding.signMessage(req: req);
  }

  /// Check whether given message was signed by the private key or the given
  /// pubkey and the signature (zbase encoded) is valid.
  Future<CheckMessageResponse> checkMessage({
    required CheckMessageRequest req,
  }) async {
    return await binding.checkMessage(req: req);
  }

  /* LSP API's */

  /// List available lsps that can be selected by the user
  Future<List<LspInformation>> listLsps() async => await binding.listLsps();

  /// Select the lsp to be used and provide inbound liquidity
  Future<void> connectLSP(String lspId) async {
    return await binding.connectLsp(lspId: lspId);
  }

  /// Get the current LSP's ID
  Future<String?> lspId() async => await binding.lspId();

  /// Convenience method to look up LSP info based on current LSP ID
  Future<LspInformation?> lspInfo() async => await binding.lspInfo();

  /// Convenience method to look up [LspInformation] for a given LSP ID
  Future<LspInformation?> fetchLspInfo(String lspId) async => await binding.fetchLspInfo(id: lspId);

  /// close all channels with the current lsp
  Future closeLspChannels() async => await binding.closeLspChannels();

  /* Backup API's & Streams*/

  // Listen to backup results
  final StreamController<BreezEvent?> _backupStreamController = BehaviorSubject<BreezEvent?>();

  Stream<BreezEvent?> get backupStream => _backupStreamController.stream;

  /// Start the backup process
  Future<void> backup() async => await binding.backup();

  /// Returns the state of the backup process
  Future<BackupStatus> backupStatus() async => await binding.backupStatus();

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
    final paymentsList = await binding.listPayments(req: req);
    paymentsController.add(paymentsList);
    return paymentsList;
  }

  /// Fetch a specific payment by its hash.
  Future<Payment?> paymentByHash({
    required String hash,
  }) async {
    return await binding.paymentByHash(hash: hash);
  }

  /// Set the external metadata of a payment as a valid JSON string
  Future<void> setPaymentMetadata({
    required String hash,
    required String metadata,
  }) async {
    return await binding.setPaymentMetadata(hash: hash, metadata: metadata);
  }

  /* Lightning Payment API's */

  /// pay a bolt11 invoice
  Future<SendPaymentResponse> sendPayment({
    required SendPaymentRequest req,
  }) async {
    return await binding.sendPayment(req: req);
  }

  /// pay directly to a node id using keysend
  Future<SendPaymentResponse> sendSpontaneousPayment({
    required SendSpontaneousPaymentRequest req,
  }) async {
    return await binding.sendSpontaneousPayment(req: req);
  }

  /// Creates an bolt11 payment request.
  /// This also works when the node doesn't have any channels and need inbound liquidity.
  /// In such case when the invoice is paid a new zero-conf channel will be open by the LSP,
  /// providing inbound liquidity and the payment will be routed via this new channel.
  Future<ReceivePaymentResponse> receivePayment({
    required ReceivePaymentRequest req,
  }) async {
    return await binding.receivePayment(req: req);
  }

  /* LNURL API's */

  /// Second step of LNURL-pay. The first step is `parse()`, which also validates the LNURL destination
  /// and generates the `LnUrlPayRequestData` payload needed here.
  Future<LnUrlPayResult> lnurlPay({
    required LnUrlPayRequest req,
  }) async {
    return await binding.lnurlPay(req: req);
  }

  /// Second step of LNURL-withdraw. The first step is `parse()`, which also validates the LNURL destination
  /// and generates the `LnUrlWithdrawRequestData` payload needed here.
  ///
  /// This call will validate the given amount in the `request` against the parameters
  /// of the LNURL endpoint data in the `request`. If they match the endpoint requirements, the LNURL withdraw
  /// request is made. A successful result here means the endpoint started the payment.
  Future<LnUrlWithdrawResult> lnurlWithdraw({required LnUrlWithdrawRequest req}) async {
    return await binding.lnurlWithdraw(req: req);
  }

  /// Third and last step of LNURL-auth. The first step is `parse()`, which also validates the LNURL destination
  /// and generates the `LnUrlAuthRequestData` payload needed here. The second step is user approval of auth action.
  ///
  /// This call will sign `k1` of the LNURL endpoint (`req_data`) on `secp256k1` using `linkingPrivKey` and DER-encodes the signature.
  /// If they match the endpoint requirements, the LNURL auth request is made. A successful result here means the client signature is verified.
  Future<LnUrlCallbackStatus> lnurlAuth({
    required LnUrlAuthRequestData reqData,
  }) async {
    return await binding.lnurlAuth(reqData: reqData);
  }

  /* Fiat Currency API's */

  /// Fetch live rates of fiat currencies
  Future<Map<String, Rate>> fetchFiatRates() async {
    final List<Rate> rates = await binding.fetchFiatRates();
    return rates.fold<Map<String, Rate>>({}, (map, rate) {
      map[rate.coin] = rate;
      return map;
    });
  }

  /// List all available fiat currencies
  Future<List<FiatCurrency>> listFiatCurrencies() async => await binding.listFiatCurrencies();

  /* Swap Stream */

  final StreamController<BreezEvent_SwapUpdated> _swapEventsStreamController =
      BehaviorSubject<BreezEvent_SwapUpdated>();

  Stream<BreezEvent_SwapUpdated> get swapEventsStream => _swapEventsStreamController.stream;

  /* On-Chain Swap API's */

  /// Creates a reverse swap and attempts to pay the HODL invoice
  @Deprecated(
    'Use payOnchain instead. '
    'This method was deprecated after v0.3.2',
  )
  Future<SendOnchainResponse> sendOnchain({
    required SendOnchainRequest req,
  }) async {
    return await binding.sendOnchain(req: req);
  }

  Future<OnchainPaymentLimitsResponse> onchainPaymentLimits() async {
    return await binding.onchainPaymentLimits();
  }

  /// Creates a reverse swap and attempts to pay the HODL invoice
  Future<PayOnchainResponse> payOnchain({
    required PayOnchainRequest req,
  }) async {
    return await binding.payOnchain(req: req);
  }

  /// Onchain receive swap API
  Future<SwapInfo> receiveOnchain({
    required ReceiveOnchainRequest req,
  }) async {
    return await binding.receiveOnchain(req: req);
  }

  /// Generates an url that can be used by a third part provider to buy Bitcoin with fiat currency
  Future<BuyBitcoinResponse> buyBitcoin({
    required BuyBitcoinRequest req,
  }) async {
    return await binding.buyBitcoin(req: req);
  }

  /// Withdraw on-chain funds in the wallet to an external btc address
  Future<RedeemOnchainFundsResponse> redeemOnchainFunds({
    required RedeemOnchainFundsRequest req,
  }) async {
    final redeemOnchainFundsResponse = await binding.redeemOnchainFunds(req: req);
    await listPayments(req: const ListPaymentsRequest());
    return redeemOnchainFundsResponse;
  }

  /// Returns the max amount that can be sent on-chain using the send_onchain method.
  /// The returned amount is the sum of the max amount that can be sent on each channel
  /// minus the expected fees.
  /// This is possible since the route to the swapper node is known in advance and is expected
  /// to consist of maximum 3 hops.
  Future<MaxReverseSwapAmountResponse> maxReverseSwapAmount() async {
    return await binding.maxReverseSwapAmount();
  }

  /* Refundables API's */

  /// list non-completed expired swaps that should be refunded by calling refund()
  Future<List<SwapInfo>> listRefundables() async => await binding.listRefundables();

  /// Construct and broadcast a refund transaction for a failed/expired swap
  Future<RefundResponse> refund({
    required RefundRequest req,
  }) async {
    return await binding.refund(req: req);
  }

  /// Prepares a refund transaction for a failed/expired swap.
  ///
  /// Can optionally be used before refund to know how much fees will be paid
  /// to perform the refund.
  Future<PrepareRefundResponse> prepareRefund({
    required PrepareRefundRequest req,
  }) async {
    return await binding.prepareRefund(req: req);
  }

  /// Iterate all historical swap addresses and fetch their current status from the blockchain.
  /// The status is then updated in the persistent storage.
  Future<void> rescanSwaps() async => await binding.rescanSwaps();

  /* In Progress Swap API's */

  /// Returns an optional in-progress [SwapInfo].
  /// A [SwapInfo] is in-progress if it is waiting for confirmation to be redeemed and complete the swap.
  Future<SwapInfo?> inProgressSwap() async => await binding.inProgressSwap();

  /// Redeems an individual swap.
  ///
  /// To be used only in the context of mobile notifications, where the notification triggers
  /// an individual redeem.
  ///
  /// This is taken care of automatically in the context of typical SDK usage.
  Future<void> redeemSwap({
    required String swapAddress,
  }) async {
    return await binding.redeemSwap(swapAddress: swapAddress);
  }

  /// Returns the blocking [ReverseSwapInfo]s that are in progress
  @Deprecated(
    'Use inProgressOnchainPayments instead. '
    'This method was deprecated after v0.3.6',
  )
  Future<List<ReverseSwapInfo>> inProgressReverseSwaps() async => binding.inProgressReverseSwaps();

  /* Swap Fee API's */

  /// Gets the fees required to open a channel for a given amount.
  Future<OpenChannelFeeResponse> openChannelFee({
    required OpenChannelFeeRequest req,
  }) async {
    return await binding.openChannelFee(req: req);
  }

  /// Lookup the most recent reverse swap pair info using the Boltz API
  @Deprecated(
    'Use prepareOnchainPayment instead. '
    'This method was deprecated after v0.3.2',
  )
  Future<ReverseSwapPairInfo> fetchReverseSwapFees({
    required ReverseSwapFeesRequest req,
  }) async {
    return await binding.fetchReverseSwapFees(req: req);
  }

  /// Lookup the most recent reverse swap pair info using the Boltz API
  Future<PrepareOnchainPaymentResponse> prepareOnchainPayment({
    required PrepareOnchainPaymentRequest req,
  }) async {
    return await binding.prepareOnchainPayment(req: req);
  }

  /// Returns the blocking [ReverseSwapInfo]s that are in progress
  Future<List<ReverseSwapInfo>> inProgressOnchainPayments() async => binding.inProgressOnchainPayments();

  /// Fetches the current recommended fees
  Future<RecommendedFees> recommendedFees() async => await binding.recommendedFees();

  Future<PrepareRedeemOnchainFundsResponse> prepareRedeemOnchainFunds({
    required PrepareRedeemOnchainFundsRequest req,
  }) async =>
      binding.prepareRedeemOnchainFunds(req: req);

  /* Support API's */

  /// Send an issue report using the Support API.
  /// - `ReportIssueRequest.paymentFailure` sends a payment failure report to the Support API
  ///   using the provided `paymentHash` to lookup the failed `Payment` and the current `NodeState`.
  Future<void> reportIssue({
    required ReportIssueRequest req,
  }) async {
    return await binding.reportIssue(req: req);
  }

  /// Fetches the service health check from the support API.
  Future<ServiceHealthCheckResponse> serviceHealthCheck({
    required String apiKey,
  }) async =>
      await binding.serviceHealthCheck(apiKey: apiKey);

  /* CLI API's */

  /// Execute a command directly on the NodeAPI interface.
  /// Mainly used to debugging.
  Future<String> executeCommand({required String command}) async {
    return await binding.executeCommand(command: command);
  }

  /// Generate diagnostic data.
  /// Mainly used to debugging.
  Future<String> generateDiagnosticData() async {
    return await binding.generateDiagnosticData();
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
    int? exemptfeeMsat,
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
