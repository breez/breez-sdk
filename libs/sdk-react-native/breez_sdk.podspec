require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "breez_sdk"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/breez-sdk/react-native-breez-sdk.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"  

  s.dependency "React-Core"

  # will use BreezSDK from CocoaPods trunk
  # remove this for local development but don't commit its removal.
  s.dependency "BreezSDK", package["version"]

  # will use local BreezSDK build for easy and fast development
  # add this for local development but don't commit it.
  # s.vendored_frameworks = "ios/bindings-swift/breez_sdkFFI.xcframework"
end
