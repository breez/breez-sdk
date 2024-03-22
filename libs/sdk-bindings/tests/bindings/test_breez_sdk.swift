
import breez_sdk

class SDKListener: EventListener {
    func onEvent(e: BreezEvent) {
        print("received event ", e);
    }
}

class LogStreamListener: LogStream {
    func log(l: LogEntry){
        if l.level != "TRACE" {
            print(l.line);
        }
    }
}

do {
    try setLogStream(logStream: LogStreamListener(), filterLevel: nil);
    let seed = try mnemonicToSeed(phrase: "cruise clever syrup coil cute execute laundry general cover prevent law sheriff");
    let config = breez_sdk.defaultConfig(envType: EnvironmentType.staging, apiKey: "", nodeConfig: NodeConfig.greenlight(config: GreenlightNodeConfig(partnerCredentials: nil,inviteCode:  "code")));
    let connectRequest = ConnectRequest(config: config, seed: seed)
    let sdkServices = try connect(req: connectRequest, listener: SDKListener());    
    let nodeInfo = try sdkServices.nodeInfo();
    assert(nodeInfo.id == "0352a918bdba7d7a69893a7d52a449f3e6df8e15a0edcc7fe59060be70d6f416f0", "nodeInfo.id");
}catch {
 fatalError("Should have not thrown!")
}