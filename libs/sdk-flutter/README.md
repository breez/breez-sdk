# sdk-flutter

A flutter plugin project that exposes the sdk-core using ffi. 
The [flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge) is used to generate the bindings.

## Build

### Prerequisites:
* Flutter version `3.19.0`
* set the ANDROID_NDK_HOME env variable to your sdk home folder
```
export ANDROID_NDK_HOME=<your android ndk directory>
```
#### Install [protocol buffer compiler](https://github.com/protocolbuffers/protobuf/releases)
  * MacOS, using Homebrew
```
brew install protobuf
```
  * Linux
```
apt install -y protobuf-compiler
```
* install cargo-ndk to provide simplified android build: 
```
cargo install cargo-ndk
```
* Install [flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge): 
```
cargo install flutter_rust_bridge_codegen --version 2.0.0
```

## Building the plugin
On first usage you will need to run:
```
make init
```
Then for iOS:
```
make ios
```
And for android
```
make android
```

### Generated artifacts:
* Android libraries
 >* ./android/src/main/jniLibs/arm64-v8a/libbreez_sdk_bindings.so
 >* ./android/src/main/jniLibs/armeabi-v7a/libbreez_sdk_bindings.so
 >* ./android/src/main/jniLibs/x86/libbreez_sdk_bindings.so
 >* ./android/src/main/jniLibs/x86_64/libbreez_sdk_bindings.so
* iOS library is imported through libs/sdk-bindings/bindings-swift
