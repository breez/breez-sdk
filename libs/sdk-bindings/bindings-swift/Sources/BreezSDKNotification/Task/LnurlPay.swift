import UserNotifications
import Foundation

struct LnurlErrorResponse: Decodable, Encodable {
    let status: String
    let reason: String
    
    init(status: String, reason: String) {
        self.status = status
        self.reason = reason
    }
}

class LnurlPayTask : TaskProtocol {
    var payload: String
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var logger: ServiceLogger
    var config: ServiceConfig
    var successNotifiationTitle: String
    var failNotificationTitle: String
    
    init(payload: String, logger: ServiceLogger, config: ServiceConfig, contentHandler: ((UNNotificationContent) -> Void)? = nil, bestAttemptContent: UNMutableNotificationContent? = nil, successNotificationTitle: String, failNotificationTitle: String) {
        self.payload = payload
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
        self.logger = logger
        self.config = config
        self.successNotifiationTitle = successNotificationTitle;
        self.failNotificationTitle = failNotificationTitle;
    }
    
    public func onEvent(e: BreezEvent) {}
    
    func start(breezSDK: BlockingBreezServices) throws {}
    
    func onShutdown() {
        displayPushNotification(title: self.failNotificationTitle, logger: self.logger)
    }
    
    func replyServer(encodable: Encodable, replyURL: String) {
        guard let serverReplyURL = URL(string: replyURL) else {
            self.displayPushNotification(title: self.failNotificationTitle, logger: self.logger)
            return
        }
        var request = URLRequest(url: serverReplyURL)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(encodable)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                self.displayPushNotification(title: self.successNotifiationTitle, logger: self.logger)
            } else {
                self.displayPushNotification(title: self.failNotificationTitle, logger: self.logger)
                return
            }
        }
        task.resume()
    }
    
    func fail(withError: String, replyURL: String) {
        if let serverReplyURL = URL(string: replyURL) {
            var request = URLRequest(url: serverReplyURL)
            request.httpMethod = "POST"
            request.httpBody = try! JSONEncoder().encode(LnurlErrorResponse(status: "ERROR", reason: withError))
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                let _ = (response as! HTTPURLResponse).statusCode
            }
            task.resume()
        }
        self.displayPushNotification(title: self.failNotificationTitle, logger: self.logger)
    }
}
