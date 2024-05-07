SOURCES=$(sort $(wildcard ../sdk-core/src/*.rs ../sdk-core/src/**/*.rs))
SHELL := /bin/bash
OS_NAME=$(shell uname | tr '[:upper:]' '[:lower:]')

.PHONY: init
init:
	cargo install cargo-ndk
	cargo install cargo-expand
	flutter pub get

## all: Compile iOS, Android
all: ios android

flutter_rust_bridge:
	cargo install flutter_rust_bridge_codegen --version 2.0.0-dev.33
	mkdir -p ./lib/generated
	flutter_rust_bridge_codegen generate
	dart format -l 110 ./lib/generated

ios: $(SOURCES) flutter_rust_bridge
	make -C ../sdk-bindings bindings-swift
	rm -rf ios/bindings-swift
	cp -r ../sdk-bindings/bindings-swift ios/bindings-swift
	rm -rf ios/bindings-swift/Tests
	rm -f ios/bindings-swift/Package.swift

## android: Compile the android targets (arm64, armv7 and i686)
.PHONY: android
android: $(SOURCES) flutter_rust_bridge
	make -C ../sdk-bindings kotlin
	mkdir -p ./android/src/main/jniLibs
	cp -r ../sdk-bindings/ffi/kotlin/jniLibs/* ./android/src/main/jniLibs
	mkdir -p ./android/src/main/kotlin/breez_sdk/
	cp -r ../sdk-bindings/ffi/kotlin/breez_sdk/* ./android/src/main/kotlin/breez_sdk/
	mkdir -p ./android/src/main/kotlin/breez_sdk_notification/
	cp -r ../sdk-bindings/bindings-android/lib/src/main/kotlin/breez_sdk_notification/* ./android/src/main/kotlin/breez_sdk_notification/

## desktop: compiles for x86_64-unknown-linux-gnu by default, other targets can be specified
## with the TARGET variable eg. make desktop TARGET=aarch64-unknown-linux-gnu
TARGET ?= x86_64-unknown-linux-gnu
.PHONY: desktop
desktop: $(SOURCES) flutter_rust_bridge
	make -C ../sdk-bindings $(TARGET)
	cd ../sdk-bindings && make $(TARGET)
	mkdir -p ./$(TARGET)
	cp ../target/$(TARGET)/release/libbreez_sdk_bindings.so ./$(TARGET)/libbreez_sdk_bindings.so

## clean:
.PHONY: clean
clean:
	cargo clean
	rm -rf ./lib/generated/
	rm -rf ./android/src/main/jniLibs
	rm -rf ./android/src/main/kotlin/breez_sdk/
	rm -rf ./android/src/main/kotlin/breez_sdk_notification/
	rm -rf ./ios/libbreez_sdk_bindings.a
	rm -rf ./ios/bindings-swift
	rm -rf ./$(TARGET)/libbreez_sdk_bindings.so