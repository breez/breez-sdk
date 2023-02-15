import Foundation

@objc(BreezSDK)
class BreezSDK: RCTEventEmitter {
    private var breezServices: BlockingBreezServices!
    private var creds: GreenlightCredentials!
    
    @objc
    override static func moduleName() -> String! {
        "BreezSDK"
    }
    
    override func supportedEvents() -> [String]! {
        return [BreezListener.emitterName]
    }
    
    @objc
    override static func requiresMainQueueSetup() -> Bool {
        return false
    }

    @objc(initServices:deviceCert:seed:resolver:rejecter:)
    func initServices(_ deviceKey:[UInt8], deviceCert:[UInt8], seed:[UInt8], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        self.creds = GreenlightCredentials(deviceKey: deviceKey, deviceCert: deviceCert)
                
        var config = breez_sdk.defaultConfig(envType: EnvironmentType.production)
        config.apiKey = Bundle.main.object(forInfoDictionaryKey: "BREEZ_API_KEY") as? String
        
        do {
            self.breezServices = try breez_sdk.initServices(config: config, seed: seed, creds: self.creds, listener: BreezListener(emitter: self))
            
            resolve([])
        } catch let err {
            reject("error", err.localizedDescription, err)
        }
    }
    
    @objc(mnemonicToSeed:resolver:rejecter:)
    func mnemonicToSeed(_ phrase: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        do {
            let seed = try breez_sdk.mnemonicToSeed(phrase: phrase)
            
            resolve(seed)
        } catch let err {
            reject("error", err.localizedDescription, err)
        }
    }
}
