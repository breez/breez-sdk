SOURCES=$(sort $(wildcard ../sdk-core/src/*.rs ../sdk-core/src/**/*.rs))

.PHONY: init
init:
	cargo install cargo-ndk
	cargo install flutter_rust_bridge_codegen --version 1.69.0
	flutter pub get

## all: Compile iOS, Android
all: ios-universal android

flutter_rust_bridge:
	flutter_rust_bridge_codegen -r ../sdk-core/src/binding.rs -d lib/bridge_generated.dart -c ios/Classes/bridge_generated.h

ios-universal: $(SOURCES) flutter_rust_bridge
	cd ../sdk-core && make ios	
	cp ../target/universal/release/libbreez_sdk_core.a ./ios/libbreez_sdk_core.a

## android: Compile the android targets (arm64, armv7 and i686)
.PHONY: android
android: $(SOURCES) flutter_rust_bridge
	cd ../sdk-core && make android
	mkdir -p ./android/src/main/jniLibs/arm64-v8a
	mkdir -p ./android/src/main/jniLibs/armeabi-v7a
	mkdir -p ./android/src/main/jniLibs/x86
	mkdir -p ./android/src/main/jniLibs/x86_64
	cp ../target/aarch64-linux-android/release/libbreez_sdk_core.so ./android/src/main/jniLibs/arm64-v8a/libbreez_sdk_core.so
	cp ../target/armv7-linux-androideabi/release/libbreez_sdk_core.so android/src/main/jniLibs/armeabi-v7a/libbreez_sdk_core.so
	cp ../target/i686-linux-android/release/libbreez_sdk_core.so android/src/main/jniLibs/x86/libbreez_sdk_core.so
	cp ../target/x86_64-linux-android/release/libbreez_sdk_core.so android/src/main/jniLibs/x86_64/libbreez_sdk_core.so

## clean:
.PHONY: clean
clean:
	cargo clean
	rm -rf ./android/src/main/jniLibs
	rm -rf ./ios/libbreez_sdk_core.a