import 'package:breez_sdk/bridge_generated.dart';

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
