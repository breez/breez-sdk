#import "BreezSDKPlugin.h"
#import "frb_generated.h"
#if __has_include(<breez_sdk/breez_sdk-Swift.h>)
#import <breez_sdk/breez_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "BreezSDKPlugin.h"
#endif

@implementation BreezSDKPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {  
  dummy_method_to_enforce_bundling();
}
@end
