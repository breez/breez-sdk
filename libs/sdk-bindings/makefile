CURRENT_DIR := $(shell pwd)
SOURCES=$(sort $(wildcard ./src/*.rs ./src/**/*.rs))
SHELL := /bin/bash
OS_NAME=$(shell uname | tr '[:upper:]' '[:lower:]')

.PHONY: init
init:
	rustup target add aarch64-apple-ios x86_64-apple-ios
	rustup target add aarch64-apple-darwin x86_64-apple-darwin
	rustup target add aarch64-apple-ios-sim
	#rustup target add armv7-apple-ios armv7s-apple-ios i386-apple-ios ## deprecated
	rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android
	rustup target add aarch64-unknown-linux-gnu x86_64-unknown-linux-gnu
	@if [ $$(uname) == "Darwin" ] ; then cargo install cargo-lipo ; fi
	cargo install cbindgen
	cargo install cargo-ndk

all: swift-ios swift-darwin bindings-swift kotlin bindings-android csharp-darwin golang-darwin

ios-universal: $(SOURCES)		
	mkdir -p ../target/ios-universal/release
	mkdir -p ../target/ios-universal-sim/release
	cargo build --release --target aarch64-apple-ios ;\
	cargo build --release --target x86_64-apple-ios ;\
	cargo build --release --target aarch64-apple-ios-sim ;\
	# build universal lib for arm device and x86 sim
	lipo -create -output ../target/ios-universal/release/libbreez_sdk_bindings.a ../target/aarch64-apple-ios/release/libbreez_sdk_bindings.a ../target/x86_64-apple-ios/release/libbreez_sdk_bindings.a
	# build universal lib for arm sim and x86 sim
	lipo -create -output ../target/ios-universal-sim/release/libbreez_sdk_bindings.a ../target/aarch64-apple-ios-sim/release/libbreez_sdk_bindings.a ../target/x86_64-apple-ios/release/libbreez_sdk_bindings.a

darwin-universal: $(SOURCES)
	mkdir -p ../target/darwin-universal/release
	cargo lipo --release --targets aarch64-apple-darwin
	cargo lipo --release --targets x86_64-apple-darwin
	lipo -create -output ../target/darwin-universal/release/libbreez_sdk_bindings.dylib ../target/aarch64-apple-darwin/release/libbreez_sdk_bindings.dylib ../target/x86_64-apple-darwin/release/libbreez_sdk_bindings.dylib
	lipo -create -output ../target/darwin-universal/release/libbreez_sdk_bindings.a ../target/aarch64-apple-darwin/release/libbreez_sdk_bindings.a ../target/x86_64-apple-darwin/release/libbreez_sdk_bindings.a

csharp-darwin: darwin-universal
	cargo install uniffi-bindgen-cs --git https://github.com/breez/uniffi-bindgen-cs --branch namespace
	uniffi-bindgen-cs src/breez_sdk.udl -o ffi/csharp -c ./uniffi.toml
	cp ../target/darwin-universal/release/libbreez_sdk_bindings.dylib ffi/csharp

TARGET ?= aarch64-unknown-linux-gnu
csharp-linux: $(SOURCES)
	cargo install uniffi-bindgen-cs --git https://github.com/breez/uniffi-bindgen-cs --branch namespace
	cargo build --release --target $(TARGET)
	uniffi-bindgen-cs src/breez_sdk.udl -o ffi/csharp -c ./uniffi.toml
	cp ../target/$(TARGET)/release/libbreez_sdk_bindings.so ffi/csharp

golang-darwin: darwin-universal
	cargo install uniffi-bindgen-go --git https://github.com/NordSecurity/uniffi-bindgen-go --tag v0.2.1+v0.25.0
	uniffi-bindgen-go src/breez_sdk.udl -o ffi/golang -c ./uniffi.toml
	cp ../target/darwin-universal/release/libbreez_sdk_bindings.dylib ffi/golang
	cp -r ffi/golang/breez/breez_sdk tests/bindings/golang/

TARGET ?= aarch64-unknown-linux-gnu
golang-linux: $(SOURCES)
	cargo install uniffi-bindgen-go --git https://github.com/NordSecurity/uniffi-bindgen-go --tag v0.2.1+v0.25.0
	cargo build --release --target $(TARGET)
	uniffi-bindgen-go src/breez_sdk.udl -o ffi/golang -c ./uniffi.toml
	cp ../target/$(TARGET)/release/libbreez_sdk_bindings.so ffi/golang
	cp -r ffi/golang/breez/breez_sdk tests/bindings/golang/

TARGET ?= aarch64-unknown-linux-gnu
python-linux: $(SOURCES)	
	cargo build --release --target $(TARGET)
	cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/breez_sdk.udl --language python -o ffi/python
	cp ../target/$(TARGET)/release/libbreez_sdk_bindings.so ffi/python

python-darwin: darwin-universal	
	cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/breez_sdk.udl --language python -o ffi/python
	cp ../target/darwin-universal/release/libbreez_sdk_bindings.dylib ffi/python

swift-ios: ios-universal
	cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/breez_sdk.udl -l swift -o ffi/swift-ios
	cp ../target/ios-universal/release/libbreez_sdk_bindings.a ffi/swift-ios
	cd ffi/swift-ios && "swiftc" "-emit-module" "-module-name" "breez_sdk_bindings"  "-Xcc" "-fmodule-map-file=$(CURRENT_DIR)/ffi/swift-ios/breez_sdkFFI.modulemap" "-I" "."  "-L" "." "-lbreez_sdk_bindings" breez_sdk.swift

swift-darwin: darwin-universal
	cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/breez_sdk.udl -l swift -o ffi/swift-darwin
	cp ../target/darwin-universal/release/libbreez_sdk_bindings.dylib ffi/swift-darwin
	cd ffi/swift-darwin && "swiftc" "-emit-module" "-module-name" "breez_sdk_bindings"  "-Xcc" "-fmodule-map-file=$(CURRENT_DIR)/ffi/swift-darwin/breez_sdkFFI.modulemap" "-I" "."  "-L" "." "-lbreez_sdk_bindings" breez_sdk.swift

bindings-swift: ios-universal darwin-universal
	mkdir -p bindings-swift/Sources/BreezSDK
	cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/breez_sdk.udl --no-format --language swift --out-dir bindings-swift/Sources/BreezSDK
	mv bindings-swift/Sources/BreezSDK/breez_sdk.swift bindings-swift/Sources/BreezSDK/BreezSDK.swift
	cp bindings-swift/Sources/BreezSDK/breez_sdkFFI.h bindings-swift/breez_sdkFFI.xcframework/ios-arm64/breez_sdkFFI.framework/Headers
	cp bindings-swift/Sources/BreezSDK/breez_sdkFFI.h bindings-swift/breez_sdkFFI.xcframework/ios-arm64_x86_64-simulator/breez_sdkFFI.framework/Headers
	cp bindings-swift/Sources/BreezSDK/breez_sdkFFI.h bindings-swift/breez_sdkFFI.xcframework/macos-arm64_x86_64/breez_sdkFFI.framework/Headers
	cp ../target/aarch64-apple-ios/release/libbreez_sdk_bindings.a bindings-swift/breez_sdkFFI.xcframework/ios-arm64/breez_sdkFFI.framework/breez_sdkFFI
	cp ../target/ios-universal-sim/release/libbreez_sdk_bindings.a bindings-swift/breez_sdkFFI.xcframework/ios-arm64_x86_64-simulator/breez_sdkFFI.framework/breez_sdkFFI
	cp ../target/darwin-universal/release/libbreez_sdk_bindings.a bindings-swift/breez_sdkFFI.xcframework/macos-arm64_x86_64/breez_sdkFFI.framework/breez_sdkFFI
	rm bindings-swift/Sources/BreezSDK/breez_sdkFFI.h
	rm bindings-swift/Sources/BreezSDK/breez_sdkFFI.modulemap

kotlin: android
	cargo run --features=uniffi/cli --bin uniffi-bindgen generate src/breez_sdk.udl --language kotlin -o ffi/kotlin

android: aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

aarch64-linux-android: $(SOURCES) ndk-home
	cargo ndk -t aarch64-linux-android -o ffi/kotlin/jniLibs build --release	
	cp -a $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/sysroot/usr/lib/aarch64-linux-android/libc++_shared.so ffi/kotlin/jniLibs/arm64-v8a/

armv7-linux-androideabi: $(SOURCES) ndk-home
	cargo ndk -t armv7-linux-androideabi -o ffi/kotlin/jniLibs build --release
	cp -a $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/sysroot/usr/lib/arm-linux-androideabi/libc++_shared.so ffi/kotlin/jniLibs/armeabi-v7a/

i686-linux-android: $(SOURCES) ndk-home
	cargo ndk -t i686-linux-android -o ffi/kotlin/jniLibs build --release
	cp -a $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/sysroot/usr/lib/i686-linux-android/libc++_shared.so ffi/kotlin/jniLibs/x86/

x86_64-linux-android: $(SOURCES) ndk-home
	cargo ndk -t x86_64-linux-android -o ffi/kotlin/jniLibs build --release
	cp -a $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/sysroot/usr/lib/x86_64-linux-android/libc++_shared.so ffi/kotlin/jniLibs/x86_64/

bindings-android: kotlin
	cp -r ffi/kotlin/jniLibs bindings-android/lib/src/main
	cp -r ffi/kotlin/breez_sdk bindings-android/lib/src/main/kotlin/
	cd bindings-android && ./gradlew assemble
	mkdir -p ffi/android
	cp bindings-android/lib/build/outputs/aar/lib-release.aar ffi/android

bindings-kotlin-multiplatform: ios-universal kotlin
	mkdir -p bindings-kotlin-multiplatform/breez-sdk-kmp/src/androidMain
	cp -r ffi/kotlin/jniLibs/ bindings-kotlin-multiplatform/breez-sdk-kmp/src/androidMain/jniLibs/
	cp -r ffi/kmm/* bindings-kotlin-multiplatform/breez-sdk-kmp/src/

	cp -r bindings-kotlin-multiplatform/breez-sdk-kmp/src/jvmMain/kotlin bindings-kotlin-multiplatform/breez-sdk-kmp/src/androidMain/

	mkdir -p bindings-kotlin-multiplatform/breez-sdk-kmp/src/libs/ios-arm64/
	mkdir -p bindings-kotlin-multiplatform/breez-sdk-kmp/src/libs/ios-simulator-arm64/
	mkdir -p bindings-kotlin-multiplatform/breez-sdk-kmp/src/libs/ios-simulator-x64/

	cp ../target/aarch64-apple-ios/release/libbreez_sdk_bindings.a bindings-kotlin-multiplatform/breez-sdk-kmp/src/libs/ios-arm64/
	cp ../target/aarch64-apple-ios-sim/release/libbreez_sdk_bindings.a bindings-kotlin-multiplatform/breez-sdk-kmp/src/libs/ios-simulator-arm64/
	cp ../target/x86_64-apple-ios/release/libbreez_sdk_bindings.a bindings-kotlin-multiplatform/breez-sdk-kmp/src/libs/ios-simulator-x64/
	cd bindings-kotlin-multiplatform && ./gradlew :breez-sdk-kmp:assemble
	
react-native:
	make -C bindings-react-native codegen

.PHONY: ndk-home
ndk-home:
	@if [ ! -d "${ANDROID_NDK_HOME}" ] ; then \
		echo "Error: Please, set the ANDROID_NDK_HOME env variable to point to your NDK folder" ; \
		exit 1 ; \
	fi

## clean:
.PHONY: clean
clean:
	cargo clean
	rm -rf ffi
	rm -rf kmm
## test:
.PHONY: test
test:
	cargo test
