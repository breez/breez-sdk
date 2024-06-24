import 'dart:io';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

ExternalLibrary? _breezSDK;

const _libName = "breez_sdk_bindings";
const _iosLibName = "breez_sdkFFI";

ExternalLibrary createLibraryImpl() {
  if (_breezSDK == null) {
    if (Platform.isAndroid || Platform.isLinux) {
      // On Linux the lib needs to be in LD_LIBRARY_PATH or working directory
      _breezSDK = ExternalLibrary.open('lib$_libName.so');
    } else if (Platform.isIOS || Platform.isMacOS) {
      try {
        // TODO: Fails to load dynamic library
        _breezSDK = ExternalLibrary.open('$_iosLibName.framework/$_iosLibName');
      } catch (e) {
        // Resolving to this on apps that have multiple packages that use flutter_rust_bridge
        // (breez-sdk & bdk-flutter where we're concerned) may cause issues.
        _breezSDK = ExternalLibrary.process(iKnowHowToUseIt: true);
      }
    } else {
      throw UnsupportedError('${Platform.operatingSystem} is not yet supported!');
    }
  }
  return _breezSDK!;
}
