#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(RNBreezSDK, RCTEventEmitter)

RCT_EXTERN_METHOD(
    parseInvoice: (NSString*)invoice
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    parseInput: (NSString*)s
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    mnemonicToSeed: (NSString*)phrase
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    defaultConfig: (NSString*)envType
    apiKey: (NSString*)apiKey
    nodeConfig: (NSDictionary*)nodeConfig
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    staticBackup: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)
  
RCT_EXTERN_METHOD(
    setLogStream: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    connect: (NSDictionary*)config
    seed: (NSArray*)seed
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    disconnect: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    sendPayment: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    sendSpontaneousPayment: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    receivePayment: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    payLnurl: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    withdrawLnurl: (NSDictionary*)request
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    lnurlAuth: (NSDictionary*)reqData
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    nodeInfo: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    signMessage: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    checkMessage: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    backupStatus: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    backup: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    paymentByHash: (NSString*)hash
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    listPayments: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    sweep: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    fetchFiatRates: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    listFiatCurrencies: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    listLsps: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    connectLsp: (NSString*)lspId
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    fetchLspInfo: (NSString*)lspId
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    openChannelFee: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    lspId: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    lspInfo: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    closeLspChannels: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    receiveOnchain: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    inProgressSwap: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    listRefundables: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    prepareRefund: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    refund: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    fetchReverseSwapFees: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    inProgressReverseSwaps: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    sendOnchain: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    executeDevCommand: (NSString*)command
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    sync: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    recommendedFees: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    buyBitcoin: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    prepareSweep: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    createOffer: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

RCT_EXTERN_METHOD(
    payOffer: (NSDictionary*)req
    resolve: (RCTPromiseResolveBlock)resolve
    reject: (RCTPromiseRejectBlock)reject
)

@end