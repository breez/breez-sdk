import UserNotifications
import Foundation

struct LnurlInfoRequest: Codable {
    let callback_url: String
    let reply_url: String
}

struct LnurlInfoResponse: Decodable, Encodable {
    let callback: String
    let maxSendable: UInt64
    let minSendable: UInt64
    let metadata: String
    let tag: String
    
    init(callback: String, maxSendable: UInt64, minSendable: UInt64, metadata: String, tag: String) {
        self.callback = callback
        self.maxSendable = maxSendable
        self.minSendable = minSendable
        self.metadata = metadata
        self.tag = tag
    }
}

class LnurlPayInfoTask : LnurlPayTask {
    fileprivate let TAG = "LnurlPayInfoTask"
    
    init(payload: String, logger: ServiceLogger, config: ServiceConfig, contentHandler: ((UNNotificationContent) -> Void)? = nil, bestAttemptContent: UNMutableNotificationContent? = nil) {
        let successNotificationTitle = ResourceHelper.shared.getString(key: Constants.LNURL_PAY_INFO_NOTIFICATION_TITLE, fallback: Constants.DEFAULT_LNURL_PAY_INFO_NOTIFICATION_TITLE)
        let failNotificationTitle = ResourceHelper.shared.getString(key: Constants.LNURL_PAY_NOTIFICATION_FAILURE_TITLE, fallback: Constants.DEFAULT_LNURL_PAY_NOTIFICATION_FAILURE_TITLE)
        super.init(payload: payload, logger: logger, config: config, contentHandler: contentHandler, bestAttemptContent: bestAttemptContent, successNotificationTitle: successNotificationTitle, failNotificationTitle: failNotificationTitle)
    }
    
    override func start(breezSDK: BlockingBreezServices) throws {
        var request: LnurlInfoRequest? = nil
        do {
            request = try JSONDecoder().decode(LnurlInfoRequest.self, from: self.payload.data(using: .utf8)!)
        } catch let e {
            self.logger.log(tag: TAG, line: "failed to decode payload: \(e)", level: "ERROR")
            self.displayPushNotification(title: self.failNotificationTitle, logger: self.logger, threadIdentifier: Constants.NOTIFICATION_THREAD_LNURL_PAY)
            throw e
        }
        
        do {
            let plainTextMetadata = ResourceHelper.shared.getString(key: Constants.LNURL_PAY_METADATA_PLAIN_TEXT, fallback: Constants.DEFAULT_LNURL_PAY_METADATA_PLAIN_TEXT)
            let metadata = "[[\"text/plain\",\"\(plainTextMetadata)\"]]"
            // Get the fee parameters offered by the LSP for opening a new channel
            let ofp = try breezSDK.openChannelFee(req: OpenChannelFeeRequest(amountMsat: nil)).feeParams
            // Calculate the maximum receivable amount within the fee limit (in millisatoshis)
            let feeLimitMsat: UInt64 = config.channelFeeLimitMsat
            let nodeInfo = try breezSDK.nodeInfo()
            let proportionalPercent = Double(ofp.proportional) / 1000000.0
            // Treat fee limit feature as disabled when it's set to 0
            let maxReceivableMsatFeeLimit = (proportionalPercent != 0.0 && feeLimitMsat != 0)
            ? min(
                nodeInfo.maxReceivableMsat,
                UInt64(Double(feeLimitMsat) / proportionalPercent)
            ) : nodeInfo.maxReceivableMsat
            // Calculate the maximum sendable amount (in millisatoshis)
            let maxSendable = max(nodeInfo.inboundLiquidityMsats, maxReceivableMsatFeeLimit)
            // Get the minimum sendable amount (in millisatoshis), can not be less than 1 or more than maxSendable
            let minSendable: UInt64 = nodeInfo.inboundLiquidityMsats < UInt64(1000) ? ofp.minMsat :  UInt64(1000)
            if minSendable > maxSendable {
                throw InvalidMinSendable.largerThanMaxSendable
            }
            replyServer(encodable: LnurlInfoResponse(callback: request!.callback_url, maxSendable: maxSendable, minSendable: minSendable, metadata: metadata, tag: "payRequest"),
                        replyURL: request!.reply_url)
        } catch let e as InvalidMinSendable {
            switch e {
            case .largerThanMaxSendable:
                self.logger.log(tag: TAG, line: "failed to process lnurl: \(e)", level: "ERROR")
                let failNotificationTitle = ResourceHelper.shared.getString(key: Constants.LNURL_PAY_NOTIFICATION_LIQUIDITY_FAILURE_TITLE, fallback: Constants.DEFAULT_LNURL_PAY_NOTIFICATION_LIQUIDITY_FAILURE_TITLE)
                fail(withError: e.localizedDescription, replyURL: request!.reply_url, failNotificationTitle: failNotificationTitle)
            }
        } catch let e {
            self.logger.log(tag: TAG, line: "failed to process lnurl: \(e)", level: "ERROR")
            fail(withError: e.localizedDescription, replyURL: request!.reply_url)
        }
    }
}

private enum InvalidMinSendable: Error {
    case largerThanMaxSendable
}

extension InvalidMinSendable: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .largerThanMaxSendable:
            return NSLocalizedString("Minimum sendable amount can't be greater than maximum sendable amount.", comment: "InvalidMinSendable")
        }
    }
}
