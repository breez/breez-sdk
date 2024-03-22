import BreezSDK
import Foundation

@objc(RNBreezSDK)
class RNBreezSDK: RCTEventEmitter {
    static let TAG: String = "BreezSDK"

    public static var emitter: RCTEventEmitter!
    public static var hasListeners: Bool = false

    private var breezServices: BlockingBreezServices!

    static var breezSdkDirectory: URL {
        let applicationDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let breezSdkDirectory = applicationDirectory.appendingPathComponent("breezSdk", isDirectory: true)

        if !FileManager.default.fileExists(atPath: breezSdkDirectory.path) {
            try! FileManager.default.createDirectory(atPath: breezSdkDirectory.path, withIntermediateDirectories: true)
        }

        return breezSdkDirectory
    }

    override init() {
        super.init()
        RNBreezSDK.emitter = self
    }

    @objc
    override static func moduleName() -> String! {
        TAG
    }

    override func supportedEvents() -> [String]! {
        return [BreezSDKListener.emitterName, BreezSDKLogStream.emitterName]
    }

    override func startObserving() {
        RNBreezSDK.hasListeners = true
    }

    override func stopObserving() {
        RNBreezSDK.hasListeners = false
    }

    @objc
    override static func requiresMainQueueSetup() -> Bool {
        return false
    }

    func getBreezServices() throws -> BlockingBreezServices {
        if breezServices != nil {
            return breezServices
        }

        throw SdkError.Generic(message: "BreezServices not initialized")
    }

    private func ensureWorkingDir(workingDir: String) throws {
        do {
            if !FileManager.default.fileExists(atPath: workingDir) {
                try FileManager.default.createDirectory(atPath: workingDir, withIntermediateDirectories: true)
            }
        } catch {
            throw SdkError.Generic(message: "Mandatory field workingDir must contain a writable directory")
        }
    }

    @objc(parseInvoice:resolve:reject:)
    func parseInvoice(_ invoice: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try BreezSDK.parseInvoice(invoice: invoice)
            resolve(BreezSDKMapper.dictionaryOf(lnInvoice: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(parseInput:resolve:reject:)
    func parseInput(_ s: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try BreezSDK.parseInput(s: s)
            resolve(BreezSDKMapper.dictionaryOf(inputType: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(mnemonicToSeed:resolve:reject:)
    func mnemonicToSeed(_ phrase: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try BreezSDK.mnemonicToSeed(phrase: phrase)
            resolve(res)
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(defaultConfig:apiKey:nodeConfig:resolve:reject:)
    func defaultConfig(_ envType: String, apiKey: String, nodeConfig: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let envTypeTmp = try BreezSDKMapper.asEnvironmentType(environmentType: envType)
            let nodeConfigTmp = try BreezSDKMapper.asNodeConfig(nodeConfig: nodeConfig)
            var res = BreezSDK.defaultConfig(envType: envTypeTmp, apiKey: apiKey, nodeConfig: nodeConfigTmp)
            res.workingDir = RNBreezSDK.breezSdkDirectory.path
            resolve(BreezSDKMapper.dictionaryOf(config: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(staticBackup:resolve:reject:)
    func staticBackup(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let staticBackupRequest = try BreezSDKMapper.asStaticBackupRequest(staticBackupRequest: req)
            var res = try BreezSDK.staticBackup(req: staticBackupRequest)
            resolve(BreezSDKMapper.dictionaryOf(staticBackupResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(serviceHealthCheck:resolve:reject:)
    func serviceHealthCheck(_ apiKey: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try BreezSDK.serviceHealthCheck(apiKey: apiKey)
            resolve(BreezSDKMapper.dictionaryOf(serviceHealthCheckResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(setLogStream:resolve:reject:)
    func setLogStream(_ filterLevel: String?, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var levelFilter: LevelFilter? = nil
            if filterLevel != nil {
                levelFilter = try BreezSDKMapper.asLevelFilter(levelFilter: filterLevel!)
            }
            try BreezSDK.setLogStream(logStream: BreezSDKLogStream(), filterLevel: levelFilter)
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(connect:resolve:reject:)
    func connect(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        if breezServices != nil {
            reject("Generic", "BreezServices already initialized", nil)
            return
        }

        do {
            let connectRequest = try BreezSDKMapper.asConnectRequest(connectRequest: req)
            try ensureWorkingDir(workingDir: connectRequest.config.workingDir)

            breezServices = try BreezSDK.connect(req: connectRequest, listener: BreezSDKListener())
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(disconnect:reject:)
    func disconnect(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            try getBreezServices().disconnect()
            breezServices = nil
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(configureNode:resolve:reject:)
    func configureNode(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let configureNodeRequest = try BreezSDKMapper.asConfigureNodeRequest(configureNodeRequest: req)
            try getBreezServices().configureNode(req: configureNodeRequest)
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(sendPayment:resolve:reject:)
    func sendPayment(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let sendPaymentRequest = try BreezSDKMapper.asSendPaymentRequest(sendPaymentRequest: req)
            var res = try getBreezServices().sendPayment(req: sendPaymentRequest)
            resolve(BreezSDKMapper.dictionaryOf(sendPaymentResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(sendSpontaneousPayment:resolve:reject:)
    func sendSpontaneousPayment(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let sendSpontaneousPaymentRequest = try BreezSDKMapper.asSendSpontaneousPaymentRequest(sendSpontaneousPaymentRequest: req)
            var res = try getBreezServices().sendSpontaneousPayment(req: sendSpontaneousPaymentRequest)
            resolve(BreezSDKMapper.dictionaryOf(sendPaymentResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(receivePayment:resolve:reject:)
    func receivePayment(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let receivePaymentRequest = try BreezSDKMapper.asReceivePaymentRequest(receivePaymentRequest: req)
            var res = try getBreezServices().receivePayment(req: receivePaymentRequest)
            resolve(BreezSDKMapper.dictionaryOf(receivePaymentResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(payLnurl:resolve:reject:)
    func payLnurl(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let lnUrlPayRequest = try BreezSDKMapper.asLnUrlPayRequest(lnUrlPayRequest: req)
            var res = try getBreezServices().payLnurl(req: lnUrlPayRequest)
            resolve(BreezSDKMapper.dictionaryOf(lnUrlPayResult: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(withdrawLnurl:resolve:reject:)
    func withdrawLnurl(_ request: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let lnUrlWithdrawRequest = try BreezSDKMapper.asLnUrlWithdrawRequest(lnUrlWithdrawRequest: request)
            var res = try getBreezServices().withdrawLnurl(request: lnUrlWithdrawRequest)
            resolve(BreezSDKMapper.dictionaryOf(lnUrlWithdrawResult: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(lnurlAuth:resolve:reject:)
    func lnurlAuth(_ reqData: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let lnUrlAuthRequestData = try BreezSDKMapper.asLnUrlAuthRequestData(lnUrlAuthRequestData: reqData)
            var res = try getBreezServices().lnurlAuth(reqData: lnUrlAuthRequestData)
            resolve(BreezSDKMapper.dictionaryOf(lnUrlCallbackStatus: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(reportIssue:resolve:reject:)
    func reportIssue(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let reqTmp = try BreezSDKMapper.asReportIssueRequest(reportIssueRequest: req)
            try getBreezServices().reportIssue(req: reqTmp)
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(nodeCredentials:reject:)
    func nodeCredentials(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().nodeCredentials()
            if res != nil {
                resolve(BreezSDKMapper.dictionaryOf(nodeCredentials: res!))
            } else {
                resolve(nil)
            }
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(nodeInfo:reject:)
    func nodeInfo(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().nodeInfo()
            resolve(BreezSDKMapper.dictionaryOf(nodeState: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(signMessage:resolve:reject:)
    func signMessage(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let signMessageRequest = try BreezSDKMapper.asSignMessageRequest(signMessageRequest: req)
            var res = try getBreezServices().signMessage(req: signMessageRequest)
            resolve(BreezSDKMapper.dictionaryOf(signMessageResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(checkMessage:resolve:reject:)
    func checkMessage(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let checkMessageRequest = try BreezSDKMapper.asCheckMessageRequest(checkMessageRequest: req)
            var res = try getBreezServices().checkMessage(req: checkMessageRequest)
            resolve(BreezSDKMapper.dictionaryOf(checkMessageResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(backupStatus:reject:)
    func backupStatus(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().backupStatus()
            resolve(BreezSDKMapper.dictionaryOf(backupStatus: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(backup:reject:)
    func backup(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            try getBreezServices().backup()
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(listPayments:resolve:reject:)
    func listPayments(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let listPaymentsRequest = try BreezSDKMapper.asListPaymentsRequest(listPaymentsRequest: req)
            var res = try getBreezServices().listPayments(req: listPaymentsRequest)
            resolve(BreezSDKMapper.arrayOf(paymentList: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(paymentByHash:resolve:reject:)
    func paymentByHash(_ hash: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().paymentByHash(hash: hash)
            if res != nil {
                resolve(BreezSDKMapper.dictionaryOf(payment: res!))
            } else {
                resolve(nil)
            }
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(setPaymentMetadata:metadata:resolve:reject:)
    func setPaymentMetadata(_ hash: String, metadata: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            try getBreezServices().setPaymentMetadata(hash: hash, metadata: metadata)
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(redeemOnchainFunds:resolve:reject:)
    func redeemOnchainFunds(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let redeemOnchainFundsRequest = try BreezSDKMapper.asRedeemOnchainFundsRequest(redeemOnchainFundsRequest: req)
            var res = try getBreezServices().redeemOnchainFunds(req: redeemOnchainFundsRequest)
            resolve(BreezSDKMapper.dictionaryOf(redeemOnchainFundsResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(fetchFiatRates:reject:)
    func fetchFiatRates(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().fetchFiatRates()
            resolve(BreezSDKMapper.arrayOf(rateList: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(listFiatCurrencies:reject:)
    func listFiatCurrencies(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().listFiatCurrencies()
            resolve(BreezSDKMapper.arrayOf(fiatCurrencyList: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(listLsps:reject:)
    func listLsps(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().listLsps()
            resolve(BreezSDKMapper.arrayOf(lspInformationList: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(connectLsp:resolve:reject:)
    func connectLsp(_ lspId: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            try getBreezServices().connectLsp(lspId: lspId)
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(fetchLspInfo:resolve:reject:)
    func fetchLspInfo(_ lspId: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().fetchLspInfo(lspId: lspId)
            if res != nil {
                resolve(BreezSDKMapper.dictionaryOf(lspInformation: res!))
            } else {
                resolve(nil)
            }
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(openChannelFee:resolve:reject:)
    func openChannelFee(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let openChannelFeeRequest = try BreezSDKMapper.asOpenChannelFeeRequest(openChannelFeeRequest: req)
            var res = try getBreezServices().openChannelFee(req: openChannelFeeRequest)
            resolve(BreezSDKMapper.dictionaryOf(openChannelFeeResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(lspId:reject:)
    func lspId(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().lspId()
            if res != nil {
                resolve(res!)
            } else {
                resolve(nil)
            }
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(lspInfo:reject:)
    func lspInfo(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().lspInfo()
            resolve(BreezSDKMapper.dictionaryOf(lspInformation: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(closeLspChannels:reject:)
    func closeLspChannels(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            try getBreezServices().closeLspChannels()
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(registerWebhook:resolve:reject:)
    func registerWebhook(_ webhookUrl: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            try getBreezServices().registerWebhook(webhookUrl: webhookUrl)
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(receiveOnchain:resolve:reject:)
    func receiveOnchain(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let receiveOnchainRequest = try BreezSDKMapper.asReceiveOnchainRequest(receiveOnchainRequest: req)
            var res = try getBreezServices().receiveOnchain(req: receiveOnchainRequest)
            resolve(BreezSDKMapper.dictionaryOf(swapInfo: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(inProgressSwap:reject:)
    func inProgressSwap(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().inProgressSwap()
            if res != nil {
                resolve(BreezSDKMapper.dictionaryOf(swapInfo: res!))
            } else {
                resolve(nil)
            }
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(rescanSwaps:reject:)
    func rescanSwaps(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            try getBreezServices().rescanSwaps()
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(redeemSwap:resolve:reject:)
    func redeemSwap(_ swapAddress: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            try getBreezServices().redeemSwap(swapAddress: swapAddress)
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(listRefundables:reject:)
    func listRefundables(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().listRefundables()
            resolve(BreezSDKMapper.arrayOf(swapInfoList: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(prepareRefund:resolve:reject:)
    func prepareRefund(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let prepareRefundRequest = try BreezSDKMapper.asPrepareRefundRequest(prepareRefundRequest: req)
            var res = try getBreezServices().prepareRefund(req: prepareRefundRequest)
            resolve(BreezSDKMapper.dictionaryOf(prepareRefundResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(refund:resolve:reject:)
    func refund(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let refundRequest = try BreezSDKMapper.asRefundRequest(refundRequest: req)
            var res = try getBreezServices().refund(req: refundRequest)
            resolve(BreezSDKMapper.dictionaryOf(refundResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(fetchReverseSwapFees:resolve:reject:)
    func fetchReverseSwapFees(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let reverseSwapFeesRequest = try BreezSDKMapper.asReverseSwapFeesRequest(reverseSwapFeesRequest: req)
            var res = try getBreezServices().fetchReverseSwapFees(req: reverseSwapFeesRequest)
            resolve(BreezSDKMapper.dictionaryOf(reverseSwapPairInfo: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(onchainPaymentLimits:reject:)
    func onchainPaymentLimits(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().onchainPaymentLimits()
            resolve(BreezSDKMapper.dictionaryOf(onchainPaymentLimitsResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(prepareOnchainPayment:resolve:reject:)
    func prepareOnchainPayment(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let prepareOnchainPaymentRequest = try BreezSDKMapper.asPrepareOnchainPaymentRequest(prepareOnchainPaymentRequest: req)
            var res = try getBreezServices().prepareOnchainPayment(req: prepareOnchainPaymentRequest)
            resolve(BreezSDKMapper.dictionaryOf(prepareOnchainPaymentResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(inProgressOnchainPayments:reject:)
    func inProgressOnchainPayments(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().inProgressOnchainPayments()
            resolve(BreezSDKMapper.arrayOf(reverseSwapInfoList: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(inProgressReverseSwaps:reject:)
    func inProgressReverseSwaps(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().inProgressReverseSwaps()
            resolve(BreezSDKMapper.arrayOf(reverseSwapInfoList: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(maxReverseSwapAmount:reject:)
    func maxReverseSwapAmount(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().maxReverseSwapAmount()
            resolve(BreezSDKMapper.dictionaryOf(maxReverseSwapAmountResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(sendOnchain:resolve:reject:)
    func sendOnchain(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let sendOnchainRequest = try BreezSDKMapper.asSendOnchainRequest(sendOnchainRequest: req)
            var res = try getBreezServices().sendOnchain(req: sendOnchainRequest)
            resolve(BreezSDKMapper.dictionaryOf(sendOnchainResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(payOnchain:resolve:reject:)
    func payOnchain(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let payOnchainRequest = try BreezSDKMapper.asPayOnchainRequest(payOnchainRequest: req)
            var res = try getBreezServices().payOnchain(req: payOnchainRequest)
            resolve(BreezSDKMapper.dictionaryOf(payOnchainResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(executeDevCommand:resolve:reject:)
    func executeDevCommand(_ command: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().executeDevCommand(command: command)
            resolve(res)
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(sync:reject:)
    func sync(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            try getBreezServices().sync()
            resolve(["status": "ok"])
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(recommendedFees:reject:)
    func recommendedFees(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            var res = try getBreezServices().recommendedFees()
            resolve(BreezSDKMapper.dictionaryOf(recommendedFees: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(buyBitcoin:resolve:reject:)
    func buyBitcoin(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let buyBitcoinRequest = try BreezSDKMapper.asBuyBitcoinRequest(buyBitcoinRequest: req)
            var res = try getBreezServices().buyBitcoin(req: buyBitcoinRequest)
            resolve(BreezSDKMapper.dictionaryOf(buyBitcoinResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    @objc(prepareRedeemOnchainFunds:resolve:reject:)
    func prepareRedeemOnchainFunds(_ req: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        do {
            let prepareRedeemOnchainFundsRequest = try BreezSDKMapper.asPrepareRedeemOnchainFundsRequest(prepareRedeemOnchainFundsRequest: req)
            var res = try getBreezServices().prepareRedeemOnchainFunds(req: prepareRedeemOnchainFundsRequest)
            resolve(BreezSDKMapper.dictionaryOf(prepareRedeemOnchainFundsResponse: res))
        } catch let err {
            rejectErr(err: err, reject: reject)
        }
    }

    func rejectErr(err: Error, reject: @escaping RCTPromiseRejectBlock) {
        var errorName = "Generic"
        var message = "\(err)"
        if let errAssociated = Mirror(reflecting: err).children.first {
            errorName = errAssociated.label ?? errorName
            if let associatedMessage = Mirror(reflecting: errAssociated.value).children.first {
                message = associatedMessage.value as! String
            }
        }
        reject(errorName, message, err)
    }
}
