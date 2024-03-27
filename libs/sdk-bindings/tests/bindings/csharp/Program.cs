
using Breez.Sdk;

try
{
 var seed = BreezSdkMethods.MnemonicToSeed("cruise clever syrup coil cute execute laundry general cover prevent law sheriff");
 BreezSdkMethods.SetLogStream(new LogStreamListener(), null);
 var config = BreezSdkMethods.DefaultConfig(EnvironmentType.STAGING, "code", new NodeConfig.Greenlight(new GreenlightNodeConfig(null, "")));
 var connectRequest = new ConnectRequest(config, seed);
 BlockingBreezServices sdkServices = BreezSdkMethods.Connect(connectRequest, new SDKListener());
 NodeState? nodeInfo = sdkServices.NodeInfo();
 Console.WriteLine(nodeInfo!.id);
}
catch (Exception e)
{
 Console.WriteLine(e.Message);
}

class SDKListener : EventListener
{
 public void OnEvent(BreezEvent e)
 {
  Console.WriteLine("received event " + e);
 }
}

class LogStreamListener : LogStream
{
 public void Log(LogEntry l)
 {
  Console.WriteLine(l.line);
 }
}
