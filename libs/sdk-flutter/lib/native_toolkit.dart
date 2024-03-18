import 'dart:ffi';
import 'dart:io';

import 'package:breez_sdk/sdk.dart';

BreezSdkCore? _breezSDK;

const _libName = "libbreez_sdk_bindings.so";
const _iosLibName = "breez_sdk";

class UnsupportedPlatform implements Exception {
  UnsupportedPlatform(String s);
}

BreezSdkCore getNativeToolkit() {
  _breezSDK ??= BreezSdkCoreImpl(_getDynamicLibrary());
  return _breezSDK!;
}

DynamicLibrary _getDynamicLibrary() {
  if (Platform.isAndroid || Platform.isLinux) {
    // On Linux the lib needs to be in LD_LIBRARY_PATH or working directory
    return DynamicLibrary.open(_libName);
  } else if (Platform.isIOS || Platform.isMacOS) {
    try {
      return DynamicLibrary.open("$_iosLibName.framework/$_iosLibName");
    } catch (e) {
      return DynamicLibrary.process();
    }
  } else {
    throw UnsupportedPlatform('${Platform.operatingSystem} is not yet supported!');
  }
}
