import 'package:breez_sdk/sdk.dart';

class BackupException implements Exception {
  final BackupFailedData data;

  const BackupException(this.data);

  @override
  String toString() => data.error;
}

class PaymentException implements Exception {
  final PaymentFailedData data;

  const PaymentException(this.data);

  @override
  String toString() => data.error;
}
