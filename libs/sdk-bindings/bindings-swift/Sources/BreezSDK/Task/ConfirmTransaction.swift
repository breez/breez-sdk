import UserNotifications
import Foundation

struct AddressTxsConfirmedRequest: Codable {
    let address: String
}

class ConfirmTransactionTask : TaskProtocol {
    fileprivate let TAG = "ConfirmTransactionTask"
    
    internal var payload: String
    internal var contentHandler: ((UNNotificationContent) -> Void)?
    internal var bestAttemptContent: UNMutableNotificationContent?
    internal var logger: ServiceLogger
    internal var bitcoinAddress: String? = nil
    
    init(payload: String, logger: ServiceLogger, contentHandler: ((UNNotificationContent) -> Void)? = nil, bestAttemptContent: UNMutableNotificationContent? = nil) {
        self.payload = payload
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
        self.logger = logger
    }
    
    public func onEvent(e: BreezEvent) {
        if let address = self.bitcoinAddress {
            switch e {
            case .reverseSwapUpdated(details: let revSwapInfo):
                self.logger.log(tag: TAG, line: "Received reverse swap updated event: \(revSwapInfo.id), current address: \(address) status: \(revSwapInfo.status)\n", level: "INFO")
                if case .completedSeen = revSwapInfo.status, case  .completedConfirmed = revSwapInfo.status {
                    self.notifySuccess()
                }
                break
            case .swapUpdated(details: let swapInfo):
                self.logger.log(tag: TAG, line: "Received swap updated event: \(swapInfo.bitcoinAddress), current address: \(address) status: \(swapInfo.status)\n", level: "INFO")
                if address == swapInfo.bitcoinAddress {
                    if (swapInfo.paidMsat > 0) {
                        self.notifySuccess()
                    }
                }
                break
            default:
                break
            }
        }
    }
    
    func start(breezSDK: BlockingBreezServices) throws {
        do {
            let addressTxsConfirmedRequest = try JSONDecoder().decode(AddressTxsConfirmedRequest.self, from: self.payload.data(using: .utf8)!)
            self.bitcoinAddress = addressTxsConfirmedRequest.address
        } catch let e {
            self.logger.log(tag: TAG, line: "Failed to decode payload: \(e)", level: "ERROR")
            self.onShutdown()
            throw e
        }
        
        guard let address = bitcoinAddress else {
            self.logger.log(tag: TAG, line: "Address not in payload", level: "ERROR")
            self.onShutdown()
            return
        }
        
        do {
            try breezSDK.redeemSwap(swapAddress: address)
            self.logger.log(tag: TAG, line: "Found swap for \(address)", level: "DEBUG")
            return
        } catch let e {
            self.logger.log(tag: TAG, line: "Failed to redeem swap: \(e)", level: "ERROR")
        }
        
        do {
            try breezSDK.processReverseSwap(lockupAddress: address)
            self.logger.log(tag: TAG, line: "Found reverse swap for \(address)", level: "DEBUG")
        } catch let e {
            self.logger.log(tag: TAG, line: "Failed to process reverse swap: \(e)", level: "ERROR")
        }
    }

    func onShutdown() {
        let notificationTitle = ResourceHelper.shared.getString(key: Constants.SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TITLE, fallback: Constants.DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TITLE)
        let notificationBody = ResourceHelper.shared.getString(key: Constants.SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TEXT, fallback: Constants.DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TEXT)
        self.displayPushNotification(title: notificationTitle, body: notificationBody, logger: self.logger, threadIdentifier: Constants.NOTIFICATION_THREAD_ADDRESS_TXS_CONFIRMED)
    }

    func notifySuccess() {
        self.logger.log(tag: TAG, line: "Address \(self.bitcoinAddress) processed successfully", level: "INFO")
        let notificationTitle = ResourceHelper.shared.getString(key: Constants.SWAP_TX_CONFIRMED_NOTIFICATION_TITLE, fallback: Constants.DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_TITLE)
        self.displayPushNotification(title: notificationTitle, logger: self.logger, threadIdentifier: Constants.NOTIFICATION_THREAD_ADDRESS_TXS_CONFIRMED)
    }
}
