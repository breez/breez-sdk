import 'dart:async';

import 'package:breez_sdk/native_toolkit.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class BreezSDK {
  static const _kNodeLogsEventChannel = "breez_sdk_node_logs";
  static const EventChannel _nodeLogsEventChannel = EventChannel(_kNodeLogsEventChannel);

  static BreezSdkCore get _breezSDK => getNativeToolkit();

  BreezSDK._internal() {
    _initializeLogStream();
    _initializeEventsStream();
  }

  static final BreezSDK _instance = BreezSDK._internal();

  factory BreezSDK() => _instance;

  /* Streams */
  final StreamController<InvoicePaidDetails> _invoicePaidStream = StreamController.broadcast();
  final StreamController<Payment> _paymentResultStream = StreamController.broadcast();
  final StreamController<LogEntry> _logStreamController = StreamController.broadcast();
  final StreamController<NodeState?> _nodeStateController = BehaviorSubject<NodeState?>();
  final StreamController<BreezEvent?> _backupStreamController = BehaviorSubject<BreezEvent?>();
  final StreamController<List<Payment>> _paymentsController = BehaviorSubject<List<Payment>>();

  /// Listen to backup results
  static Stream<BreezEvent?> get backupStream => _instance._backupStreamController.stream;

  /// Listen to paid Invoice events
  static Stream<InvoicePaidDetails> get invoicePaidStream => _instance._invoicePaidStream.stream;

  /// Listen to log events
  static Stream<LogEntry> get logStream => _instance._logStreamController.stream;

  /// Listen to node state
  static Stream<NodeState?> get nodeStateStream => _instance._nodeStateController.stream;

  /// Listen to payment results
  static Stream<Payment> get paymentResultStream => _instance._paymentResultStream.stream;

  /// Listen to payment list
  static Stream<List<Payment>> get paymentsStream => _instance._paymentsController.stream;

  /// Listen to BreezEvent's(new block, invoice paid, synced)
  void _initializeEventsStream() {
    _breezSDK.breezEventsStream().listen((event) async {
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
    });
  }

  /// Listen to node logs
  void _initializeLogStream() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _nodeLogsEventChannel
          .receiveBroadcastStream()
          .map((log) => LogEntry(line: log["line"], level: log["level"]))
          .listen(
            (log) => _logStreamController.add(log),
            onError: (e) => _logStreamController.addError(e),
          );
    } else {
      _breezSDK.breezLogStream().listen((logEntry) {
        _logStreamController.add(logEntry);
      }, onError: (e) {
        _logStreamController.addError(e);
      });
    }
  }

  /* Breez Services API's */

  /// Check whether node service is initialized or not
  static Future<bool> isInitialized() async => await _breezSDK.isInitialized();

  /// connect initializes the global NodeService, schedule the node to run in the cloud and
  /// run the signer. This must be called in order to start communicate with the node
  ///
  /// # Arguments
  ///
  /// * `req` - The connect request containing the `config` sdk configuration and `seed` node private key
  static Future connect({
    required ConnectRequest req,
  }) async {
    await _breezSDK.connect(req: req);
    await fetchNodeData();
  }

  /// This method sync the local state with the remote node state.
  /// The synced items are as follows:
  /// * node state - General information about the node and its liquidity status
  /// * channels - The list of channels and their status
  /// * payments - The incoming/outgoing payments
  static Future<void> sync() async => await _breezSDK.sync();

  /// Get the node state from the persistent storage
  static Future<NodeState?> nodeInfo() async {
    final nodeState = await _breezSDK.nodeInfo();
    _instance._nodeStateController.add(nodeState);
    return nodeState;
  }

  /// Configure an optional address to send funds to during a mutual channel close
  static Future<void> configureNode({
    required ConfigureNodeRequest req,
  }) async {
    return await _breezSDK.configureNode(req: req);
  }

  /// Cleanup node resources and stop the signer.
  static Future<void> disconnect() async => await _breezSDK.disconnect();

  /* Breez Services Helper API's */

  /// Attempts to convert the phrase to a mnemonic, then to a seed.
  ///
  /// If the phrase is not a valid mnemonic, an error is returned.
  static Future<Uint8List> mnemonicToSeed(String phrase) async =>
      await _breezSDK.mnemonicToSeed(phrase: phrase);

  /// Get the full default config for a specific environment type
  static Future<Config> defaultConfig({
    required EnvironmentType envType,
    required String apiKey,
    required NodeConfig nodeConfig,
  }) async {
    return await _breezSDK.defaultConfig(
      envType: envType,
      apiKey: apiKey,
      nodeConfig: nodeConfig,
    );
  }

  /// Sign given message with the private key of the node id. Returns a zbase
  /// encoded signature.
  static Future<SignMessageResponse> signMessage({
    required SignMessageRequest req,
  }) async {
    return await _breezSDK.signMessage(req: req);
  }

  /// Check whether given message was signed by the private key or the given
  /// pubkey and the signature (zbase encoded) is valid.
  static Future<CheckMessageResponse> checkMessage({
    required CheckMessageRequest req,
  }) async {
    return await _breezSDK.checkMessage(req: req);
  }

  /* LSP API's */

  /// List available lsps that can be selected by the user
  static Future<List<LspInformation>> listLsps() async => await _breezSDK.listLsps();

  /// Select the lsp to be used and provide inbound liquidity
  static Future<void> connectLSP(String lspId) async {
    return await _breezSDK.connectLsp(lspId: lspId);
  }

  /// Get the current LSP's ID
  static Future<String?> lspId() async => await _breezSDK.lspId();

  /// Convenience method to look up LSP info based on current LSP ID
  static Future<LspInformation?> lspInfo() async => await _breezSDK.lspInfo();

  /// Convenience method to look up [LspInformation] for a given LSP ID
  static Future<LspInformation?> fetchLspInfo(String lspId) async => await _breezSDK.fetchLspInfo(id: lspId);

  /// close all channels with the current lsp
  static Future closeLspChannels() async => await _breezSDK.closeLspChannels();

  /* Backup API's */

  /// Start the backup process
  static Future<void> backup() async => await _breezSDK.backup();

  /// Returns the state of the backup process
  static Future<BackupStatus> backupStatus() async => await _breezSDK.backupStatus();

  /* Parse API's */

  /// Parse a BOLT11 payment request and return a structure contains the parsed fields.
  static Future<LNInvoice> parseInvoice(String invoice) async =>
      await _breezSDK.parseInvoice(invoice: invoice);

  /// Parses generic user input, typically pasted from clipboard or scanned from a QR.
  static Future<InputType> parseInput({required String input}) async =>
      await _breezSDK.parseInput(input: input);

  /// Get the static backup data.
  static Future<StaticBackupResponse> staticBackup({
    required StaticBackupRequest req,
  }) async {
    return await _breezSDK.staticBackup(req: req);
  }

  /* Payment API's */

  /// list payments (incoming/outgoing payments) from the persistent storage
  static Future<List<Payment>> listPayments({
    required ListPaymentsRequest req,
  }) async {
    final paymentsList = await _breezSDK.listPayments(req: req);
    _instance._paymentsController.add(paymentsList);
    return paymentsList;
  }

  /// Fetch a specific payment by its hash.
  static Future<Payment?> paymentByHash({
    required String hash,
  }) async {
    return await _breezSDK.paymentByHash(hash: hash);
  }

  /// Set the external metadata of a payment as a valid JSON string
  static Future<void> setPaymentMetadata({
    required String hash,
    required String metadata,
  }) async {
    return await _breezSDK.setPaymentMetadata(hash: hash, metadata: metadata);
  }

  /* Lightning Payment API's */

  /// Pay a BOLT11 invoice
  static Future<SendPaymentResponse> sendPayment({
    required SendPaymentRequest req,
  }) async {
    return await _breezSDK.sendPayment(req: req);
  }

  /// Pay directly to a node ID using Keysend
  static Future<SendPaymentResponse> sendSpontaneousPayment({
    required SendSpontaneousPaymentRequest req,
  }) async {
    return await _breezSDK.sendSpontaneousPayment(req: req);
  }

  /// Creates an BOLT11 payment request.
  /// This also works when the node doesn't have any channels and need inbound liquidity.
  /// In such case when the invoice is paid a new zero-conf channel will be open by the LSP,
  /// providing inbound liquidity and the payment will be routed via this new channel.
  static Future<ReceivePaymentResponse> receivePayment({
    required ReceivePaymentRequest req,
  }) async {
    return await _breezSDK.receivePayment(req: req);
  }

  /* LNURL API's */

  /// Second step of LNURL-pay. The first step is `parse()`, which also validates the LNURL destination
  /// and generates the `LnUrlPayRequestData` payload needed here.
  static Future<LnUrlPayResult> lnurlPay({
    required LnUrlPayRequest req,
  }) async {
    return await _breezSDK.lnurlPay(req: req);
  }

  /// Second step of LNURL-withdraw. The first step is `parse()`, which also validates the LNURL destination
  /// and generates the `LnUrlWithdrawRequestData` payload needed here.
  ///
  /// This call will validate the given amount in the `request` against the parameters
  /// of the LNURL endpoint data in the `request`. If they match the endpoint requirements, the LNURL withdraw
  /// request is made. A successful result here means the endpoint started the payment.
  static Future<LnUrlWithdrawResult> lnurlWithdraw({required LnUrlWithdrawRequest req}) async {
    return await _breezSDK.lnurlWithdraw(req: req);
  }

  /// Third and last step of LNURL-auth. The first step is `parse()`, which also validates the LNURL destination
  /// and generates the `LnUrlAuthRequestData` payload needed here. The second step is user approval of auth action.
  ///
  /// This call will sign `k1` of the LNURL endpoint (`req_data`) on `secp256k1` using `linkingPrivKey` and DER-encodes the signature.
  /// If they match the endpoint requirements, the LNURL auth request is made. A successful result here means the client signature is verified.
  static Future<LnUrlCallbackStatus> lnurlAuth({
    required LnUrlAuthRequestData reqData,
  }) async {
    return await _breezSDK.lnurlAuth(reqData: reqData);
  }

  /* Fiat Currency API's */

  /// Fetch live rates of fiat currencies
  static Future<Map<String, Rate>> fetchFiatRates() async {
    final List<Rate> rates = await _breezSDK.fetchFiatRates();
    return rates.fold<Map<String, Rate>>({}, (map, rate) {
      map[rate.coin] = rate;
      return map;
    });
  }

  /// List all available fiat currencies
  static Future<List<FiatCurrency>> listFiatCurrencies() async => await _breezSDK.listFiatCurrencies();

  /* On-Chain Swap API's */

  /// Creates a reverse swap and attempts to pay the HODL invoice
  @Deprecated(
    'Use payOnchain instead. '
    'This method was deprecated after v0.3.3',
  )
  static Future<SendOnchainResponse> sendOnchain({
    required SendOnchainRequest req,
  }) async {
    return await _breezSDK.sendOnchain(req: req);
  }

  static Future<OnchainPaymentLimitsResponse> onchainPaymentLimits() async {
    return await _breezSDK.onchainPaymentLimits();
  }

  /// Creates a reverse swap and attempts to pay the HODL invoice
  static Future<PayOnchainResponse> payOnchain({
    required PayOnchainRequest req,
  }) async {
    return await _breezSDK.payOnchain(req: req);
  }

  /// Onchain receive swap API
  static Future<SwapInfo> receiveOnchain({
    required ReceiveOnchainRequest req,
  }) async {
    return await _breezSDK.receiveOnchain(req: req);
  }

  /// Generates an url that can be used by a third part provider to buy Bitcoin with fiat currency
  static Future<BuyBitcoinResponse> buyBitcoin({
    required BuyBitcoinRequest req,
  }) async {
    return await _breezSDK.buyBitcoin(req: req);
  }

  /// Withdraw on-chain funds in the wallet to an external btc address
  static Future<RedeemOnchainFundsResponse> redeemOnchainFunds({
    required RedeemOnchainFundsRequest req,
  }) async {
    final redeemOnchainFundsResponse = await _breezSDK.redeemOnchainFunds(req: req);
    await listPayments(req: const ListPaymentsRequest());
    return redeemOnchainFundsResponse;
  }

  /// Returns the max amount that can be sent on-chain using the send_onchain method.
  /// The returned amount is the sum of the max amount that can be sent on each channel
  /// minus the expected fees.
  /// This is possible since the route to the swapper node is known in advance and is expected
  /// to consist of maximum 3 hops.
  @Deprecated(
    'Use onchainPaymentLimits instead. '
    'This method was deprecated after v0.3.3',
  )
  static Future<MaxReverseSwapAmountResponse> maxReverseSwapAmount() async {
    return await _breezSDK.maxReverseSwapAmount();
  }

  /* Refundables API's */

  /// list non-completed expired swaps that should be refunded by calling refund()
  static Future<List<SwapInfo>> listRefundables() async => await _breezSDK.listRefundables();

  /// Construct and broadcast a refund transaction for a failed/expired swap
  static Future<RefundResponse> refund({
    required RefundRequest req,
  }) async {
    return await _breezSDK.refund(req: req);
  }

  /// Prepares a refund transaction for a failed/expired swap.
  ///
  /// Can optionally be used before refund to know how much fees will be paid
  /// to perform the refund.
  static Future<PrepareRefundResponse> prepareRefund({
    required PrepareRefundRequest req,
  }) async {
    return await _breezSDK.prepareRefund(req: req);
  }

  /// Iterate all historical swap addresses and fetch their current status from the blockchain.
  /// The status is then updated in the persistent storage.
  static Future<void> rescanSwaps() async => await _breezSDK.rescanSwaps();

  /* In Progress Swap API's */

  /// Returns an optional in-progress [SwapInfo].
  /// A [SwapInfo] is in-progress if it is waiting for confirmation to be redeemed and complete the swap.
  static Future<SwapInfo?> inProgressSwap() async => await _breezSDK.inProgressSwap();

  /// Redeems an individual swap.
  ///
  /// To be used only in the context of mobile notifications, where the notification triggers
  /// an individual redeem.
  ///
  /// This is taken care of automatically in the context of typical SDK usage.
  static Future<void> redeemSwap({
    required String swapAddress,
  }) async {
    return await _breezSDK.redeemSwap(swapAddress: swapAddress);
  }

  /// Returns the blocking [ReverseSwapInfo]s that are in progress
  static Future<List<ReverseSwapInfo>> inProgressReverseSwaps() async => _breezSDK.inProgressReverseSwaps();

  /* Swap Fee API's */

  /// Gets the fees required to open a channel for a given amount.
  static Future<OpenChannelFeeResponse> openChannelFee({
    required OpenChannelFeeRequest req,
  }) async {
    return await _breezSDK.openChannelFee(req: req);
  }

  /// Lookup the most recent reverse swap pair info using the Boltz API
  @Deprecated(
    'Use prepareOnchainPayment instead. '
    'This method was deprecated after v0.3.3',
  )
  static Future<ReverseSwapPairInfo> fetchReverseSwapFees({
    required ReverseSwapFeesRequest req,
  }) async {
    return await _breezSDK.fetchReverseSwapFees(req: req);
  }

  /// Lookup the most recent reverse swap pair info using the Boltz API
  static Future<PrepareOnchainPaymentResponse> prepareOnchainPayment({
    required PrepareOnchainPaymentRequest req,
  }) async {
    return await _breezSDK.prepareOnchainPayment(req: req);
  }

  /// Fetches the current recommended fees
  static Future<RecommendedFees> recommendedFees() async => await _breezSDK.recommendedFees();

  static Future<PrepareRedeemOnchainFundsResponse> prepareRedeemOnchainFunds({
    required PrepareRedeemOnchainFundsRequest req,
  }) async {
    return _breezSDK.prepareRedeemOnchainFunds(req: req);
  }

  /* Notification API's */

  /// Register for webhook callbacks at the given `webhook_url` whenever a new payment is received.
  ///
  /// More webhook types may be supported in the static Future.
  static Future<void> registerWebhook({required String webhookUrl}) async {
    return _breezSDK.registerWebhook(webhookUrl: webhookUrl);
  }

  /* Support API's */

  /// Send an issue report using the Support API.
  /// - `ReportIssueRequest.paymentFailure` sends a payment failure report to the Support API
  ///   using the provided `paymentHash` to lookup the failed `Payment` and the current `NodeState`.
  static Future<void> reportIssue({
    required ReportIssueRequest req,
  }) async {
    return await _breezSDK.reportIssue(req: req);
  }

  /// Fetches the service health check from the support API.
  static Future<ServiceHealthCheckResponse> serviceHealthCheck({
    required String apiKey,
  }) async {
    return await _breezSDK.serviceHealthCheck(apiKey: apiKey);
  }

  /* CLI API's */

  /// Execute a command directly on the NodeAPI interface.
  /// Mainly used to debugging.
  static Future<String> executeCommand({required String command}) async {
    return await _breezSDK.executeCommand(command: command);
  }

  /* Helper Methods */

  /// Validate if given address is a valid BTC address
  static Future<bool> isValidBitcoinAddress(
    String address,
  ) async {
    try {
      final inputType = await _breezSDK.parseInput(input: address);
      return inputType is InputType_BitcoinAddress;
    } catch (e) {
      return false;
    }
  }

  /// Fetch node state & payment list
  static Future fetchNodeData() async {
    await nodeInfo();
    await listPayments(req: const ListPaymentsRequest());
  }

  /* Misc */

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BreezSDK && other.hashCode == hashCode;
  }

  @override
  int get hashCode => _instance.hashCode;

  @override
  String toString() => 'BreezSDK';
}
