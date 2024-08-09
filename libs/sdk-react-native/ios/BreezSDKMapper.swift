import BreezSDK
import Foundation

enum BreezSDKMapper {
    static func asAesSuccessActionDataDecrypted(aesSuccessActionDataDecrypted: [String: Any?]) throws -> AesSuccessActionDataDecrypted {
        guard let description = aesSuccessActionDataDecrypted["description"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "description", typeName: "AesSuccessActionDataDecrypted"))
        }
        guard let plaintext = aesSuccessActionDataDecrypted["plaintext"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "plaintext", typeName: "AesSuccessActionDataDecrypted"))
        }

        return AesSuccessActionDataDecrypted(
            description: description,
            plaintext: plaintext
        )
    }

    static func dictionaryOf(aesSuccessActionDataDecrypted: AesSuccessActionDataDecrypted) -> [String: Any?] {
        return [
            "description": aesSuccessActionDataDecrypted.description,
            "plaintext": aesSuccessActionDataDecrypted.plaintext,
        ]
    }

    static func asAesSuccessActionDataDecryptedList(arr: [Any]) throws -> [AesSuccessActionDataDecrypted] {
        var list = [AesSuccessActionDataDecrypted]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var aesSuccessActionDataDecrypted = try asAesSuccessActionDataDecrypted(aesSuccessActionDataDecrypted: val)
                list.append(aesSuccessActionDataDecrypted)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "AesSuccessActionDataDecrypted"))
            }
        }
        return list
    }

    static func arrayOf(aesSuccessActionDataDecryptedList: [AesSuccessActionDataDecrypted]) -> [Any] {
        return aesSuccessActionDataDecryptedList.map { v -> [String: Any?] in return dictionaryOf(aesSuccessActionDataDecrypted: v) }
    }

    static func asBackupFailedData(backupFailedData: [String: Any?]) throws -> BackupFailedData {
        guard let error = backupFailedData["error"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "error", typeName: "BackupFailedData"))
        }

        return BackupFailedData(
            error: error)
    }

    static func dictionaryOf(backupFailedData: BackupFailedData) -> [String: Any?] {
        return [
            "error": backupFailedData.error,
        ]
    }

    static func asBackupFailedDataList(arr: [Any]) throws -> [BackupFailedData] {
        var list = [BackupFailedData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var backupFailedData = try asBackupFailedData(backupFailedData: val)
                list.append(backupFailedData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "BackupFailedData"))
            }
        }
        return list
    }

    static func arrayOf(backupFailedDataList: [BackupFailedData]) -> [Any] {
        return backupFailedDataList.map { v -> [String: Any?] in return dictionaryOf(backupFailedData: v) }
    }

    static func asBackupStatus(backupStatus: [String: Any?]) throws -> BackupStatus {
        guard let backedUp = backupStatus["backedUp"] as? Bool else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "backedUp", typeName: "BackupStatus"))
        }
        var lastBackupTime: UInt64?
        if hasNonNilKey(data: backupStatus, key: "lastBackupTime") {
            guard let lastBackupTimeTmp = backupStatus["lastBackupTime"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "lastBackupTime"))
            }
            lastBackupTime = lastBackupTimeTmp
        }

        return BackupStatus(
            backedUp: backedUp,
            lastBackupTime: lastBackupTime
        )
    }

    static func dictionaryOf(backupStatus: BackupStatus) -> [String: Any?] {
        return [
            "backedUp": backupStatus.backedUp,
            "lastBackupTime": backupStatus.lastBackupTime == nil ? nil : backupStatus.lastBackupTime,
        ]
    }

    static func asBackupStatusList(arr: [Any]) throws -> [BackupStatus] {
        var list = [BackupStatus]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var backupStatus = try asBackupStatus(backupStatus: val)
                list.append(backupStatus)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "BackupStatus"))
            }
        }
        return list
    }

    static func arrayOf(backupStatusList: [BackupStatus]) -> [Any] {
        return backupStatusList.map { v -> [String: Any?] in return dictionaryOf(backupStatus: v) }
    }

    static func asBitcoinAddressData(bitcoinAddressData: [String: Any?]) throws -> BitcoinAddressData {
        guard let address = bitcoinAddressData["address"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "address", typeName: "BitcoinAddressData"))
        }
        guard let networkTmp = bitcoinAddressData["network"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "network", typeName: "BitcoinAddressData"))
        }
        let network = try asNetwork(network: networkTmp)

        var amountSat: UInt64?
        if hasNonNilKey(data: bitcoinAddressData, key: "amountSat") {
            guard let amountSatTmp = bitcoinAddressData["amountSat"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "amountSat"))
            }
            amountSat = amountSatTmp
        }
        var label: String?
        if hasNonNilKey(data: bitcoinAddressData, key: "label") {
            guard let labelTmp = bitcoinAddressData["label"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "label"))
            }
            label = labelTmp
        }
        var message: String?
        if hasNonNilKey(data: bitcoinAddressData, key: "message") {
            guard let messageTmp = bitcoinAddressData["message"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "message"))
            }
            message = messageTmp
        }

        return BitcoinAddressData(
            address: address,
            network: network,
            amountSat: amountSat,
            label: label,
            message: message
        )
    }

    static func dictionaryOf(bitcoinAddressData: BitcoinAddressData) -> [String: Any?] {
        return [
            "address": bitcoinAddressData.address,
            "network": valueOf(network: bitcoinAddressData.network),
            "amountSat": bitcoinAddressData.amountSat == nil ? nil : bitcoinAddressData.amountSat,
            "label": bitcoinAddressData.label == nil ? nil : bitcoinAddressData.label,
            "message": bitcoinAddressData.message == nil ? nil : bitcoinAddressData.message,
        ]
    }

    static func asBitcoinAddressDataList(arr: [Any]) throws -> [BitcoinAddressData] {
        var list = [BitcoinAddressData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var bitcoinAddressData = try asBitcoinAddressData(bitcoinAddressData: val)
                list.append(bitcoinAddressData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "BitcoinAddressData"))
            }
        }
        return list
    }

    static func arrayOf(bitcoinAddressDataList: [BitcoinAddressData]) -> [Any] {
        return bitcoinAddressDataList.map { v -> [String: Any?] in return dictionaryOf(bitcoinAddressData: v) }
    }

    static func asBuyBitcoinRequest(buyBitcoinRequest: [String: Any?]) throws -> BuyBitcoinRequest {
        guard let providerTmp = buyBitcoinRequest["provider"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "provider", typeName: "BuyBitcoinRequest"))
        }
        let provider = try asBuyBitcoinProvider(buyBitcoinProvider: providerTmp)

        var openingFeeParams: OpeningFeeParams?
        if let openingFeeParamsTmp = buyBitcoinRequest["openingFeeParams"] as? [String: Any?] {
            openingFeeParams = try asOpeningFeeParams(openingFeeParams: openingFeeParamsTmp)
        }

        var redirectUrl: String?
        if hasNonNilKey(data: buyBitcoinRequest, key: "redirectUrl") {
            guard let redirectUrlTmp = buyBitcoinRequest["redirectUrl"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "redirectUrl"))
            }
            redirectUrl = redirectUrlTmp
        }

        return BuyBitcoinRequest(
            provider: provider,
            openingFeeParams: openingFeeParams,
            redirectUrl: redirectUrl
        )
    }

    static func dictionaryOf(buyBitcoinRequest: BuyBitcoinRequest) -> [String: Any?] {
        return [
            "provider": valueOf(buyBitcoinProvider: buyBitcoinRequest.provider),
            "openingFeeParams": buyBitcoinRequest.openingFeeParams == nil ? nil : dictionaryOf(openingFeeParams: buyBitcoinRequest.openingFeeParams!),
            "redirectUrl": buyBitcoinRequest.redirectUrl == nil ? nil : buyBitcoinRequest.redirectUrl,
        ]
    }

    static func asBuyBitcoinRequestList(arr: [Any]) throws -> [BuyBitcoinRequest] {
        var list = [BuyBitcoinRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var buyBitcoinRequest = try asBuyBitcoinRequest(buyBitcoinRequest: val)
                list.append(buyBitcoinRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "BuyBitcoinRequest"))
            }
        }
        return list
    }

    static func arrayOf(buyBitcoinRequestList: [BuyBitcoinRequest]) -> [Any] {
        return buyBitcoinRequestList.map { v -> [String: Any?] in return dictionaryOf(buyBitcoinRequest: v) }
    }

    static func asBuyBitcoinResponse(buyBitcoinResponse: [String: Any?]) throws -> BuyBitcoinResponse {
        guard let url = buyBitcoinResponse["url"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "url", typeName: "BuyBitcoinResponse"))
        }
        var openingFeeParams: OpeningFeeParams?
        if let openingFeeParamsTmp = buyBitcoinResponse["openingFeeParams"] as? [String: Any?] {
            openingFeeParams = try asOpeningFeeParams(openingFeeParams: openingFeeParamsTmp)
        }

        return BuyBitcoinResponse(
            url: url,
            openingFeeParams: openingFeeParams
        )
    }

    static func dictionaryOf(buyBitcoinResponse: BuyBitcoinResponse) -> [String: Any?] {
        return [
            "url": buyBitcoinResponse.url,
            "openingFeeParams": buyBitcoinResponse.openingFeeParams == nil ? nil : dictionaryOf(openingFeeParams: buyBitcoinResponse.openingFeeParams!),
        ]
    }

    static func asBuyBitcoinResponseList(arr: [Any]) throws -> [BuyBitcoinResponse] {
        var list = [BuyBitcoinResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var buyBitcoinResponse = try asBuyBitcoinResponse(buyBitcoinResponse: val)
                list.append(buyBitcoinResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "BuyBitcoinResponse"))
            }
        }
        return list
    }

    static func arrayOf(buyBitcoinResponseList: [BuyBitcoinResponse]) -> [Any] {
        return buyBitcoinResponseList.map { v -> [String: Any?] in return dictionaryOf(buyBitcoinResponse: v) }
    }

    static func asCheckMessageRequest(checkMessageRequest: [String: Any?]) throws -> CheckMessageRequest {
        guard let message = checkMessageRequest["message"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "message", typeName: "CheckMessageRequest"))
        }
        guard let pubkey = checkMessageRequest["pubkey"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "pubkey", typeName: "CheckMessageRequest"))
        }
        guard let signature = checkMessageRequest["signature"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "signature", typeName: "CheckMessageRequest"))
        }

        return CheckMessageRequest(
            message: message,
            pubkey: pubkey,
            signature: signature
        )
    }

    static func dictionaryOf(checkMessageRequest: CheckMessageRequest) -> [String: Any?] {
        return [
            "message": checkMessageRequest.message,
            "pubkey": checkMessageRequest.pubkey,
            "signature": checkMessageRequest.signature,
        ]
    }

    static func asCheckMessageRequestList(arr: [Any]) throws -> [CheckMessageRequest] {
        var list = [CheckMessageRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var checkMessageRequest = try asCheckMessageRequest(checkMessageRequest: val)
                list.append(checkMessageRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "CheckMessageRequest"))
            }
        }
        return list
    }

    static func arrayOf(checkMessageRequestList: [CheckMessageRequest]) -> [Any] {
        return checkMessageRequestList.map { v -> [String: Any?] in return dictionaryOf(checkMessageRequest: v) }
    }

    static func asCheckMessageResponse(checkMessageResponse: [String: Any?]) throws -> CheckMessageResponse {
        guard let isValid = checkMessageResponse["isValid"] as? Bool else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "isValid", typeName: "CheckMessageResponse"))
        }

        return CheckMessageResponse(
            isValid: isValid)
    }

    static func dictionaryOf(checkMessageResponse: CheckMessageResponse) -> [String: Any?] {
        return [
            "isValid": checkMessageResponse.isValid,
        ]
    }

    static func asCheckMessageResponseList(arr: [Any]) throws -> [CheckMessageResponse] {
        var list = [CheckMessageResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var checkMessageResponse = try asCheckMessageResponse(checkMessageResponse: val)
                list.append(checkMessageResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "CheckMessageResponse"))
            }
        }
        return list
    }

    static func arrayOf(checkMessageResponseList: [CheckMessageResponse]) -> [Any] {
        return checkMessageResponseList.map { v -> [String: Any?] in return dictionaryOf(checkMessageResponse: v) }
    }

    static func asClosedChannelPaymentDetails(closedChannelPaymentDetails: [String: Any?]) throws -> ClosedChannelPaymentDetails {
        guard let stateTmp = closedChannelPaymentDetails["state"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "state", typeName: "ClosedChannelPaymentDetails"))
        }
        let state = try asChannelState(channelState: stateTmp)

        guard let fundingTxid = closedChannelPaymentDetails["fundingTxid"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "fundingTxid", typeName: "ClosedChannelPaymentDetails"))
        }
        var shortChannelId: String?
        if hasNonNilKey(data: closedChannelPaymentDetails, key: "shortChannelId") {
            guard let shortChannelIdTmp = closedChannelPaymentDetails["shortChannelId"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "shortChannelId"))
            }
            shortChannelId = shortChannelIdTmp
        }
        var closingTxid: String?
        if hasNonNilKey(data: closedChannelPaymentDetails, key: "closingTxid") {
            guard let closingTxidTmp = closedChannelPaymentDetails["closingTxid"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "closingTxid"))
            }
            closingTxid = closingTxidTmp
        }

        return ClosedChannelPaymentDetails(
            state: state,
            fundingTxid: fundingTxid,
            shortChannelId: shortChannelId,
            closingTxid: closingTxid
        )
    }

    static func dictionaryOf(closedChannelPaymentDetails: ClosedChannelPaymentDetails) -> [String: Any?] {
        return [
            "state": valueOf(channelState: closedChannelPaymentDetails.state),
            "fundingTxid": closedChannelPaymentDetails.fundingTxid,
            "shortChannelId": closedChannelPaymentDetails.shortChannelId == nil ? nil : closedChannelPaymentDetails.shortChannelId,
            "closingTxid": closedChannelPaymentDetails.closingTxid == nil ? nil : closedChannelPaymentDetails.closingTxid,
        ]
    }

    static func asClosedChannelPaymentDetailsList(arr: [Any]) throws -> [ClosedChannelPaymentDetails] {
        var list = [ClosedChannelPaymentDetails]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var closedChannelPaymentDetails = try asClosedChannelPaymentDetails(closedChannelPaymentDetails: val)
                list.append(closedChannelPaymentDetails)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ClosedChannelPaymentDetails"))
            }
        }
        return list
    }

    static func arrayOf(closedChannelPaymentDetailsList: [ClosedChannelPaymentDetails]) -> [Any] {
        return closedChannelPaymentDetailsList.map { v -> [String: Any?] in return dictionaryOf(closedChannelPaymentDetails: v) }
    }

    static func asConfig(config: [String: Any?]) throws -> Config {
        guard let breezserver = config["breezserver"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "breezserver", typeName: "Config"))
        }
        guard let chainnotifierUrl = config["chainnotifierUrl"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "chainnotifierUrl", typeName: "Config"))
        }
        var mempoolspaceUrl: String?
        if hasNonNilKey(data: config, key: "mempoolspaceUrl") {
            guard let mempoolspaceUrlTmp = config["mempoolspaceUrl"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "mempoolspaceUrl"))
            }
            mempoolspaceUrl = mempoolspaceUrlTmp
        }
        guard let workingDir = config["workingDir"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "workingDir", typeName: "Config"))
        }
        guard let networkTmp = config["network"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "network", typeName: "Config"))
        }
        let network = try asNetwork(network: networkTmp)

        guard let paymentTimeoutSec = config["paymentTimeoutSec"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentTimeoutSec", typeName: "Config"))
        }
        var defaultLspId: String?
        if hasNonNilKey(data: config, key: "defaultLspId") {
            guard let defaultLspIdTmp = config["defaultLspId"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "defaultLspId"))
            }
            defaultLspId = defaultLspIdTmp
        }
        var apiKey: String?
        if hasNonNilKey(data: config, key: "apiKey") {
            guard let apiKeyTmp = config["apiKey"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "apiKey"))
            }
            apiKey = apiKeyTmp
        }
        guard let maxfeePercent = config["maxfeePercent"] as? Double else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxfeePercent", typeName: "Config"))
        }
        guard let exemptfeeMsat = config["exemptfeeMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "exemptfeeMsat", typeName: "Config"))
        }
        guard let nodeConfigTmp = config["nodeConfig"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "nodeConfig", typeName: "Config"))
        }
        let nodeConfig = try asNodeConfig(nodeConfig: nodeConfigTmp)

        return Config(
            breezserver: breezserver,
            chainnotifierUrl: chainnotifierUrl,
            mempoolspaceUrl: mempoolspaceUrl,
            workingDir: workingDir,
            network: network,
            paymentTimeoutSec: paymentTimeoutSec,
            defaultLspId: defaultLspId,
            apiKey: apiKey,
            maxfeePercent: maxfeePercent,
            exemptfeeMsat: exemptfeeMsat,
            nodeConfig: nodeConfig
        )
    }

    static func dictionaryOf(config: Config) -> [String: Any?] {
        return [
            "breezserver": config.breezserver,
            "chainnotifierUrl": config.chainnotifierUrl,
            "mempoolspaceUrl": config.mempoolspaceUrl == nil ? nil : config.mempoolspaceUrl,
            "workingDir": config.workingDir,
            "network": valueOf(network: config.network),
            "paymentTimeoutSec": config.paymentTimeoutSec,
            "defaultLspId": config.defaultLspId == nil ? nil : config.defaultLspId,
            "apiKey": config.apiKey == nil ? nil : config.apiKey,
            "maxfeePercent": config.maxfeePercent,
            "exemptfeeMsat": config.exemptfeeMsat,
            "nodeConfig": dictionaryOf(nodeConfig: config.nodeConfig),
        ]
    }

    static func asConfigList(arr: [Any]) throws -> [Config] {
        var list = [Config]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var config = try asConfig(config: val)
                list.append(config)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "Config"))
            }
        }
        return list
    }

    static func arrayOf(configList: [Config]) -> [Any] {
        return configList.map { v -> [String: Any?] in return dictionaryOf(config: v) }
    }

    static func asConfigureNodeRequest(configureNodeRequest: [String: Any?]) throws -> ConfigureNodeRequest {
        var closeToAddress: String?
        if hasNonNilKey(data: configureNodeRequest, key: "closeToAddress") {
            guard let closeToAddressTmp = configureNodeRequest["closeToAddress"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "closeToAddress"))
            }
            closeToAddress = closeToAddressTmp
        }

        return ConfigureNodeRequest(
            closeToAddress: closeToAddress)
    }

    static func dictionaryOf(configureNodeRequest: ConfigureNodeRequest) -> [String: Any?] {
        return [
            "closeToAddress": configureNodeRequest.closeToAddress == nil ? nil : configureNodeRequest.closeToAddress,
        ]
    }

    static func asConfigureNodeRequestList(arr: [Any]) throws -> [ConfigureNodeRequest] {
        var list = [ConfigureNodeRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var configureNodeRequest = try asConfigureNodeRequest(configureNodeRequest: val)
                list.append(configureNodeRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ConfigureNodeRequest"))
            }
        }
        return list
    }

    static func arrayOf(configureNodeRequestList: [ConfigureNodeRequest]) -> [Any] {
        return configureNodeRequestList.map { v -> [String: Any?] in return dictionaryOf(configureNodeRequest: v) }
    }

    static func asConnectRequest(connectRequest: [String: Any?]) throws -> ConnectRequest {
        guard let configTmp = connectRequest["config"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "config", typeName: "ConnectRequest"))
        }
        let config = try asConfig(config: configTmp)

        guard let seed = connectRequest["seed"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "seed", typeName: "ConnectRequest"))
        }
        var restoreOnly: Bool?
        if hasNonNilKey(data: connectRequest, key: "restoreOnly") {
            guard let restoreOnlyTmp = connectRequest["restoreOnly"] as? Bool else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "restoreOnly"))
            }
            restoreOnly = restoreOnlyTmp
        }

        return ConnectRequest(
            config: config,
            seed: seed,
            restoreOnly: restoreOnly
        )
    }

    static func dictionaryOf(connectRequest: ConnectRequest) -> [String: Any?] {
        return [
            "config": dictionaryOf(config: connectRequest.config),
            "seed": connectRequest.seed,
            "restoreOnly": connectRequest.restoreOnly == nil ? nil : connectRequest.restoreOnly,
        ]
    }

    static func asConnectRequestList(arr: [Any]) throws -> [ConnectRequest] {
        var list = [ConnectRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var connectRequest = try asConnectRequest(connectRequest: val)
                list.append(connectRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ConnectRequest"))
            }
        }
        return list
    }

    static func arrayOf(connectRequestList: [ConnectRequest]) -> [Any] {
        return connectRequestList.map { v -> [String: Any?] in return dictionaryOf(connectRequest: v) }
    }

    static func asConnectedPeer(connectedPeer: [String: Any?]) throws -> ConnectedPeer {
        guard let id = connectedPeer["id"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "id", typeName: "ConnectedPeer"))
        }
        guard let featuresTmp = connectedPeer["features"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "features", typeName: "ConnectedPeer"))
        }
        let features = try asPeerFeatures(peerFeatures: featuresTmp)

        return ConnectedPeer(
            id: id,
            features: features
        )
    }

    static func dictionaryOf(connectedPeer: ConnectedPeer) -> [String: Any?] {
        return [
            "id": connectedPeer.id,
            "features": dictionaryOf(peerFeatures: connectedPeer.features),
        ]
    }

    static func asConnectedPeerList(arr: [Any]) throws -> [ConnectedPeer] {
        var list = [ConnectedPeer]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var connectedPeer = try asConnectedPeer(connectedPeer: val)
                list.append(connectedPeer)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ConnectedPeer"))
            }
        }
        return list
    }

    static func arrayOf(connectedPeerList: [ConnectedPeer]) -> [Any] {
        return connectedPeerList.map { v -> [String: Any?] in return dictionaryOf(connectedPeer: v) }
    }

    static func asCurrencyInfo(currencyInfo: [String: Any?]) throws -> CurrencyInfo {
        guard let name = currencyInfo["name"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "name", typeName: "CurrencyInfo"))
        }
        guard let fractionSize = currencyInfo["fractionSize"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "fractionSize", typeName: "CurrencyInfo"))
        }
        var spacing: UInt32?
        if hasNonNilKey(data: currencyInfo, key: "spacing") {
            guard let spacingTmp = currencyInfo["spacing"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "spacing"))
            }
            spacing = spacingTmp
        }
        var symbol: Symbol?
        if let symbolTmp = currencyInfo["symbol"] as? [String: Any?] {
            symbol = try asSymbol(symbol: symbolTmp)
        }

        var uniqSymbol: Symbol?
        if let uniqSymbolTmp = currencyInfo["uniqSymbol"] as? [String: Any?] {
            uniqSymbol = try asSymbol(symbol: uniqSymbolTmp)
        }

        guard let localizedNameTmp = currencyInfo["localizedName"] as? [[String: Any?]] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "localizedName", typeName: "CurrencyInfo"))
        }
        let localizedName = try asLocalizedNameList(arr: localizedNameTmp)

        guard let localeOverridesTmp = currencyInfo["localeOverrides"] as? [[String: Any?]] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "localeOverrides", typeName: "CurrencyInfo"))
        }
        let localeOverrides = try asLocaleOverridesList(arr: localeOverridesTmp)

        return CurrencyInfo(
            name: name,
            fractionSize: fractionSize,
            spacing: spacing,
            symbol: symbol,
            uniqSymbol: uniqSymbol,
            localizedName: localizedName,
            localeOverrides: localeOverrides
        )
    }

    static func dictionaryOf(currencyInfo: CurrencyInfo) -> [String: Any?] {
        return [
            "name": currencyInfo.name,
            "fractionSize": currencyInfo.fractionSize,
            "spacing": currencyInfo.spacing == nil ? nil : currencyInfo.spacing,
            "symbol": currencyInfo.symbol == nil ? nil : dictionaryOf(symbol: currencyInfo.symbol!),
            "uniqSymbol": currencyInfo.uniqSymbol == nil ? nil : dictionaryOf(symbol: currencyInfo.uniqSymbol!),
            "localizedName": arrayOf(localizedNameList: currencyInfo.localizedName),
            "localeOverrides": arrayOf(localeOverridesList: currencyInfo.localeOverrides),
        ]
    }

    static func asCurrencyInfoList(arr: [Any]) throws -> [CurrencyInfo] {
        var list = [CurrencyInfo]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var currencyInfo = try asCurrencyInfo(currencyInfo: val)
                list.append(currencyInfo)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "CurrencyInfo"))
            }
        }
        return list
    }

    static func arrayOf(currencyInfoList: [CurrencyInfo]) -> [Any] {
        return currencyInfoList.map { v -> [String: Any?] in return dictionaryOf(currencyInfo: v) }
    }

    static func asFiatCurrency(fiatCurrency: [String: Any?]) throws -> FiatCurrency {
        guard let id = fiatCurrency["id"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "id", typeName: "FiatCurrency"))
        }
        guard let infoTmp = fiatCurrency["info"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "info", typeName: "FiatCurrency"))
        }
        let info = try asCurrencyInfo(currencyInfo: infoTmp)

        return FiatCurrency(
            id: id,
            info: info
        )
    }

    static func dictionaryOf(fiatCurrency: FiatCurrency) -> [String: Any?] {
        return [
            "id": fiatCurrency.id,
            "info": dictionaryOf(currencyInfo: fiatCurrency.info),
        ]
    }

    static func asFiatCurrencyList(arr: [Any]) throws -> [FiatCurrency] {
        var list = [FiatCurrency]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var fiatCurrency = try asFiatCurrency(fiatCurrency: val)
                list.append(fiatCurrency)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "FiatCurrency"))
            }
        }
        return list
    }

    static func arrayOf(fiatCurrencyList: [FiatCurrency]) -> [Any] {
        return fiatCurrencyList.map { v -> [String: Any?] in return dictionaryOf(fiatCurrency: v) }
    }

    static func asGreenlightCredentials(greenlightCredentials: [String: Any?]) throws -> GreenlightCredentials {
        guard let developerKey = greenlightCredentials["developerKey"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "developerKey", typeName: "GreenlightCredentials"))
        }
        guard let developerCert = greenlightCredentials["developerCert"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "developerCert", typeName: "GreenlightCredentials"))
        }

        return GreenlightCredentials(
            developerKey: developerKey,
            developerCert: developerCert
        )
    }

    static func dictionaryOf(greenlightCredentials: GreenlightCredentials) -> [String: Any?] {
        return [
            "developerKey": greenlightCredentials.developerKey,
            "developerCert": greenlightCredentials.developerCert,
        ]
    }

    static func asGreenlightCredentialsList(arr: [Any]) throws -> [GreenlightCredentials] {
        var list = [GreenlightCredentials]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var greenlightCredentials = try asGreenlightCredentials(greenlightCredentials: val)
                list.append(greenlightCredentials)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "GreenlightCredentials"))
            }
        }
        return list
    }

    static func arrayOf(greenlightCredentialsList: [GreenlightCredentials]) -> [Any] {
        return greenlightCredentialsList.map { v -> [String: Any?] in return dictionaryOf(greenlightCredentials: v) }
    }

    static func asGreenlightDeviceCredentials(greenlightDeviceCredentials: [String: Any?]) throws -> GreenlightDeviceCredentials {
        guard let device = greenlightDeviceCredentials["device"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "device", typeName: "GreenlightDeviceCredentials"))
        }

        return GreenlightDeviceCredentials(
            device: device)
    }

    static func dictionaryOf(greenlightDeviceCredentials: GreenlightDeviceCredentials) -> [String: Any?] {
        return [
            "device": greenlightDeviceCredentials.device,
        ]
    }

    static func asGreenlightDeviceCredentialsList(arr: [Any]) throws -> [GreenlightDeviceCredentials] {
        var list = [GreenlightDeviceCredentials]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var greenlightDeviceCredentials = try asGreenlightDeviceCredentials(greenlightDeviceCredentials: val)
                list.append(greenlightDeviceCredentials)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "GreenlightDeviceCredentials"))
            }
        }
        return list
    }

    static func arrayOf(greenlightDeviceCredentialsList: [GreenlightDeviceCredentials]) -> [Any] {
        return greenlightDeviceCredentialsList.map { v -> [String: Any?] in return dictionaryOf(greenlightDeviceCredentials: v) }
    }

    static func asGreenlightNodeConfig(greenlightNodeConfig: [String: Any?]) throws -> GreenlightNodeConfig {
        var partnerCredentials: GreenlightCredentials?
        if let partnerCredentialsTmp = greenlightNodeConfig["partnerCredentials"] as? [String: Any?] {
            partnerCredentials = try asGreenlightCredentials(greenlightCredentials: partnerCredentialsTmp)
        }

        var inviteCode: String?
        if hasNonNilKey(data: greenlightNodeConfig, key: "inviteCode") {
            guard let inviteCodeTmp = greenlightNodeConfig["inviteCode"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "inviteCode"))
            }
            inviteCode = inviteCodeTmp
        }

        return GreenlightNodeConfig(
            partnerCredentials: partnerCredentials,
            inviteCode: inviteCode
        )
    }

    static func dictionaryOf(greenlightNodeConfig: GreenlightNodeConfig) -> [String: Any?] {
        return [
            "partnerCredentials": greenlightNodeConfig.partnerCredentials == nil ? nil : dictionaryOf(greenlightCredentials: greenlightNodeConfig.partnerCredentials!),
            "inviteCode": greenlightNodeConfig.inviteCode == nil ? nil : greenlightNodeConfig.inviteCode,
        ]
    }

    static func asGreenlightNodeConfigList(arr: [Any]) throws -> [GreenlightNodeConfig] {
        var list = [GreenlightNodeConfig]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var greenlightNodeConfig = try asGreenlightNodeConfig(greenlightNodeConfig: val)
                list.append(greenlightNodeConfig)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "GreenlightNodeConfig"))
            }
        }
        return list
    }

    static func arrayOf(greenlightNodeConfigList: [GreenlightNodeConfig]) -> [Any] {
        return greenlightNodeConfigList.map { v -> [String: Any?] in return dictionaryOf(greenlightNodeConfig: v) }
    }

    static func asInvoicePaidDetails(invoicePaidDetails: [String: Any?]) throws -> InvoicePaidDetails {
        guard let paymentHash = invoicePaidDetails["paymentHash"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentHash", typeName: "InvoicePaidDetails"))
        }
        guard let bolt11 = invoicePaidDetails["bolt11"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "bolt11", typeName: "InvoicePaidDetails"))
        }
        var payment: Payment?
        if let paymentTmp = invoicePaidDetails["payment"] as? [String: Any?] {
            payment = try asPayment(payment: paymentTmp)
        }

        return InvoicePaidDetails(
            paymentHash: paymentHash,
            bolt11: bolt11,
            payment: payment
        )
    }

    static func dictionaryOf(invoicePaidDetails: InvoicePaidDetails) -> [String: Any?] {
        return [
            "paymentHash": invoicePaidDetails.paymentHash,
            "bolt11": invoicePaidDetails.bolt11,
            "payment": invoicePaidDetails.payment == nil ? nil : dictionaryOf(payment: invoicePaidDetails.payment!),
        ]
    }

    static func asInvoicePaidDetailsList(arr: [Any]) throws -> [InvoicePaidDetails] {
        var list = [InvoicePaidDetails]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var invoicePaidDetails = try asInvoicePaidDetails(invoicePaidDetails: val)
                list.append(invoicePaidDetails)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "InvoicePaidDetails"))
            }
        }
        return list
    }

    static func arrayOf(invoicePaidDetailsList: [InvoicePaidDetails]) -> [Any] {
        return invoicePaidDetailsList.map { v -> [String: Any?] in return dictionaryOf(invoicePaidDetails: v) }
    }

    static func asLnInvoice(lnInvoice: [String: Any?]) throws -> LnInvoice {
        guard let bolt11 = lnInvoice["bolt11"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "bolt11", typeName: "LnInvoice"))
        }
        guard let networkTmp = lnInvoice["network"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "network", typeName: "LnInvoice"))
        }
        let network = try asNetwork(network: networkTmp)

        guard let payeePubkey = lnInvoice["payeePubkey"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "payeePubkey", typeName: "LnInvoice"))
        }
        guard let paymentHash = lnInvoice["paymentHash"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentHash", typeName: "LnInvoice"))
        }
        var description: String?
        if hasNonNilKey(data: lnInvoice, key: "description") {
            guard let descriptionTmp = lnInvoice["description"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "description"))
            }
            description = descriptionTmp
        }
        var descriptionHash: String?
        if hasNonNilKey(data: lnInvoice, key: "descriptionHash") {
            guard let descriptionHashTmp = lnInvoice["descriptionHash"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "descriptionHash"))
            }
            descriptionHash = descriptionHashTmp
        }
        var amountMsat: UInt64?
        if hasNonNilKey(data: lnInvoice, key: "amountMsat") {
            guard let amountMsatTmp = lnInvoice["amountMsat"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "amountMsat"))
            }
            amountMsat = amountMsatTmp
        }
        guard let timestamp = lnInvoice["timestamp"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "timestamp", typeName: "LnInvoice"))
        }
        guard let expiry = lnInvoice["expiry"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "expiry", typeName: "LnInvoice"))
        }
        guard let routingHintsTmp = lnInvoice["routingHints"] as? [[String: Any?]] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "routingHints", typeName: "LnInvoice"))
        }
        let routingHints = try asRouteHintList(arr: routingHintsTmp)

        guard let paymentSecret = lnInvoice["paymentSecret"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentSecret", typeName: "LnInvoice"))
        }
        guard let minFinalCltvExpiryDelta = lnInvoice["minFinalCltvExpiryDelta"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "minFinalCltvExpiryDelta", typeName: "LnInvoice"))
        }

        return LnInvoice(
            bolt11: bolt11,
            network: network,
            payeePubkey: payeePubkey,
            paymentHash: paymentHash,
            description: description,
            descriptionHash: descriptionHash,
            amountMsat: amountMsat,
            timestamp: timestamp,
            expiry: expiry,
            routingHints: routingHints,
            paymentSecret: paymentSecret,
            minFinalCltvExpiryDelta: minFinalCltvExpiryDelta
        )
    }

    static func dictionaryOf(lnInvoice: LnInvoice) -> [String: Any?] {
        return [
            "bolt11": lnInvoice.bolt11,
            "network": valueOf(network: lnInvoice.network),
            "payeePubkey": lnInvoice.payeePubkey,
            "paymentHash": lnInvoice.paymentHash,
            "description": lnInvoice.description == nil ? nil : lnInvoice.description,
            "descriptionHash": lnInvoice.descriptionHash == nil ? nil : lnInvoice.descriptionHash,
            "amountMsat": lnInvoice.amountMsat == nil ? nil : lnInvoice.amountMsat,
            "timestamp": lnInvoice.timestamp,
            "expiry": lnInvoice.expiry,
            "routingHints": arrayOf(routeHintList: lnInvoice.routingHints),
            "paymentSecret": lnInvoice.paymentSecret,
            "minFinalCltvExpiryDelta": lnInvoice.minFinalCltvExpiryDelta,
        ]
    }

    static func asLnInvoiceList(arr: [Any]) throws -> [LnInvoice] {
        var list = [LnInvoice]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnInvoice = try asLnInvoice(lnInvoice: val)
                list.append(lnInvoice)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnInvoice"))
            }
        }
        return list
    }

    static func arrayOf(lnInvoiceList: [LnInvoice]) -> [Any] {
        return lnInvoiceList.map { v -> [String: Any?] in return dictionaryOf(lnInvoice: v) }
    }

    static func asListPaymentsRequest(listPaymentsRequest: [String: Any?]) throws -> ListPaymentsRequest {
        var filters: [PaymentTypeFilter]?
        if let filtersTmp = listPaymentsRequest["filters"] as? [String] {
            filters = try asPaymentTypeFilterList(arr: filtersTmp)
        }

        var metadataFilters: [MetadataFilter]?
        if let metadataFiltersTmp = listPaymentsRequest["metadataFilters"] as? [[String: Any?]] {
            metadataFilters = try asMetadataFilterList(arr: metadataFiltersTmp)
        }

        var fromTimestamp: Int64?
        if hasNonNilKey(data: listPaymentsRequest, key: "fromTimestamp") {
            guard let fromTimestampTmp = listPaymentsRequest["fromTimestamp"] as? Int64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "fromTimestamp"))
            }
            fromTimestamp = fromTimestampTmp
        }
        var toTimestamp: Int64?
        if hasNonNilKey(data: listPaymentsRequest, key: "toTimestamp") {
            guard let toTimestampTmp = listPaymentsRequest["toTimestamp"] as? Int64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "toTimestamp"))
            }
            toTimestamp = toTimestampTmp
        }
        var includeFailures: Bool?
        if hasNonNilKey(data: listPaymentsRequest, key: "includeFailures") {
            guard let includeFailuresTmp = listPaymentsRequest["includeFailures"] as? Bool else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "includeFailures"))
            }
            includeFailures = includeFailuresTmp
        }
        var offset: UInt32?
        if hasNonNilKey(data: listPaymentsRequest, key: "offset") {
            guard let offsetTmp = listPaymentsRequest["offset"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "offset"))
            }
            offset = offsetTmp
        }
        var limit: UInt32?
        if hasNonNilKey(data: listPaymentsRequest, key: "limit") {
            guard let limitTmp = listPaymentsRequest["limit"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "limit"))
            }
            limit = limitTmp
        }

        return ListPaymentsRequest(
            filters: filters,
            metadataFilters: metadataFilters,
            fromTimestamp: fromTimestamp,
            toTimestamp: toTimestamp,
            includeFailures: includeFailures,
            offset: offset,
            limit: limit
        )
    }

    static func dictionaryOf(listPaymentsRequest: ListPaymentsRequest) -> [String: Any?] {
        return [
            "filters": listPaymentsRequest.filters == nil ? nil : arrayOf(paymentTypeFilterList: listPaymentsRequest.filters!),
            "metadataFilters": listPaymentsRequest.metadataFilters == nil ? nil : arrayOf(metadataFilterList: listPaymentsRequest.metadataFilters!),
            "fromTimestamp": listPaymentsRequest.fromTimestamp == nil ? nil : listPaymentsRequest.fromTimestamp,
            "toTimestamp": listPaymentsRequest.toTimestamp == nil ? nil : listPaymentsRequest.toTimestamp,
            "includeFailures": listPaymentsRequest.includeFailures == nil ? nil : listPaymentsRequest.includeFailures,
            "offset": listPaymentsRequest.offset == nil ? nil : listPaymentsRequest.offset,
            "limit": listPaymentsRequest.limit == nil ? nil : listPaymentsRequest.limit,
        ]
    }

    static func asListPaymentsRequestList(arr: [Any]) throws -> [ListPaymentsRequest] {
        var list = [ListPaymentsRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var listPaymentsRequest = try asListPaymentsRequest(listPaymentsRequest: val)
                list.append(listPaymentsRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ListPaymentsRequest"))
            }
        }
        return list
    }

    static func arrayOf(listPaymentsRequestList: [ListPaymentsRequest]) -> [Any] {
        return listPaymentsRequestList.map { v -> [String: Any?] in return dictionaryOf(listPaymentsRequest: v) }
    }

    static func asLnPaymentDetails(lnPaymentDetails: [String: Any?]) throws -> LnPaymentDetails {
        guard let paymentHash = lnPaymentDetails["paymentHash"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentHash", typeName: "LnPaymentDetails"))
        }
        guard let label = lnPaymentDetails["label"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "label", typeName: "LnPaymentDetails"))
        }
        guard let destinationPubkey = lnPaymentDetails["destinationPubkey"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "destinationPubkey", typeName: "LnPaymentDetails"))
        }
        guard let paymentPreimage = lnPaymentDetails["paymentPreimage"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentPreimage", typeName: "LnPaymentDetails"))
        }
        guard let keysend = lnPaymentDetails["keysend"] as? Bool else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "keysend", typeName: "LnPaymentDetails"))
        }
        guard let bolt11 = lnPaymentDetails["bolt11"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "bolt11", typeName: "LnPaymentDetails"))
        }
        var openChannelBolt11: String?
        if hasNonNilKey(data: lnPaymentDetails, key: "openChannelBolt11") {
            guard let openChannelBolt11Tmp = lnPaymentDetails["openChannelBolt11"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "openChannelBolt11"))
            }
            openChannelBolt11 = openChannelBolt11Tmp
        }
        var lnurlSuccessAction: SuccessActionProcessed?
        if let lnurlSuccessActionTmp = lnPaymentDetails["lnurlSuccessAction"] as? [String: Any?] {
            lnurlSuccessAction = try asSuccessActionProcessed(successActionProcessed: lnurlSuccessActionTmp)
        }

        var lnurlPayDomain: String?
        if hasNonNilKey(data: lnPaymentDetails, key: "lnurlPayDomain") {
            guard let lnurlPayDomainTmp = lnPaymentDetails["lnurlPayDomain"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "lnurlPayDomain"))
            }
            lnurlPayDomain = lnurlPayDomainTmp
        }
        var lnurlPayComment: String?
        if hasNonNilKey(data: lnPaymentDetails, key: "lnurlPayComment") {
            guard let lnurlPayCommentTmp = lnPaymentDetails["lnurlPayComment"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "lnurlPayComment"))
            }
            lnurlPayComment = lnurlPayCommentTmp
        }
        var lnurlMetadata: String?
        if hasNonNilKey(data: lnPaymentDetails, key: "lnurlMetadata") {
            guard let lnurlMetadataTmp = lnPaymentDetails["lnurlMetadata"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "lnurlMetadata"))
            }
            lnurlMetadata = lnurlMetadataTmp
        }
        var lnAddress: String?
        if hasNonNilKey(data: lnPaymentDetails, key: "lnAddress") {
            guard let lnAddressTmp = lnPaymentDetails["lnAddress"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "lnAddress"))
            }
            lnAddress = lnAddressTmp
        }
        var lnurlWithdrawEndpoint: String?
        if hasNonNilKey(data: lnPaymentDetails, key: "lnurlWithdrawEndpoint") {
            guard let lnurlWithdrawEndpointTmp = lnPaymentDetails["lnurlWithdrawEndpoint"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "lnurlWithdrawEndpoint"))
            }
            lnurlWithdrawEndpoint = lnurlWithdrawEndpointTmp
        }
        var swapInfo: SwapInfo?
        if let swapInfoTmp = lnPaymentDetails["swapInfo"] as? [String: Any?] {
            swapInfo = try asSwapInfo(swapInfo: swapInfoTmp)
        }

        var reverseSwapInfo: ReverseSwapInfo?
        if let reverseSwapInfoTmp = lnPaymentDetails["reverseSwapInfo"] as? [String: Any?] {
            reverseSwapInfo = try asReverseSwapInfo(reverseSwapInfo: reverseSwapInfoTmp)
        }

        var pendingExpirationBlock: UInt32?
        if hasNonNilKey(data: lnPaymentDetails, key: "pendingExpirationBlock") {
            guard let pendingExpirationBlockTmp = lnPaymentDetails["pendingExpirationBlock"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "pendingExpirationBlock"))
            }
            pendingExpirationBlock = pendingExpirationBlockTmp
        }

        return LnPaymentDetails(
            paymentHash: paymentHash,
            label: label,
            destinationPubkey: destinationPubkey,
            paymentPreimage: paymentPreimage,
            keysend: keysend,
            bolt11: bolt11,
            openChannelBolt11: openChannelBolt11,
            lnurlSuccessAction: lnurlSuccessAction,
            lnurlPayDomain: lnurlPayDomain,
            lnurlPayComment: lnurlPayComment,
            lnurlMetadata: lnurlMetadata,
            lnAddress: lnAddress,
            lnurlWithdrawEndpoint: lnurlWithdrawEndpoint,
            swapInfo: swapInfo,
            reverseSwapInfo: reverseSwapInfo,
            pendingExpirationBlock: pendingExpirationBlock
        )
    }

    static func dictionaryOf(lnPaymentDetails: LnPaymentDetails) -> [String: Any?] {
        return [
            "paymentHash": lnPaymentDetails.paymentHash,
            "label": lnPaymentDetails.label,
            "destinationPubkey": lnPaymentDetails.destinationPubkey,
            "paymentPreimage": lnPaymentDetails.paymentPreimage,
            "keysend": lnPaymentDetails.keysend,
            "bolt11": lnPaymentDetails.bolt11,
            "openChannelBolt11": lnPaymentDetails.openChannelBolt11 == nil ? nil : lnPaymentDetails.openChannelBolt11,
            "lnurlSuccessAction": lnPaymentDetails.lnurlSuccessAction == nil ? nil : dictionaryOf(successActionProcessed: lnPaymentDetails.lnurlSuccessAction!),
            "lnurlPayDomain": lnPaymentDetails.lnurlPayDomain == nil ? nil : lnPaymentDetails.lnurlPayDomain,
            "lnurlPayComment": lnPaymentDetails.lnurlPayComment == nil ? nil : lnPaymentDetails.lnurlPayComment,
            "lnurlMetadata": lnPaymentDetails.lnurlMetadata == nil ? nil : lnPaymentDetails.lnurlMetadata,
            "lnAddress": lnPaymentDetails.lnAddress == nil ? nil : lnPaymentDetails.lnAddress,
            "lnurlWithdrawEndpoint": lnPaymentDetails.lnurlWithdrawEndpoint == nil ? nil : lnPaymentDetails.lnurlWithdrawEndpoint,
            "swapInfo": lnPaymentDetails.swapInfo == nil ? nil : dictionaryOf(swapInfo: lnPaymentDetails.swapInfo!),
            "reverseSwapInfo": lnPaymentDetails.reverseSwapInfo == nil ? nil : dictionaryOf(reverseSwapInfo: lnPaymentDetails.reverseSwapInfo!),
            "pendingExpirationBlock": lnPaymentDetails.pendingExpirationBlock == nil ? nil : lnPaymentDetails.pendingExpirationBlock,
        ]
    }

    static func asLnPaymentDetailsList(arr: [Any]) throws -> [LnPaymentDetails] {
        var list = [LnPaymentDetails]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnPaymentDetails = try asLnPaymentDetails(lnPaymentDetails: val)
                list.append(lnPaymentDetails)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnPaymentDetails"))
            }
        }
        return list
    }

    static func arrayOf(lnPaymentDetailsList: [LnPaymentDetails]) -> [Any] {
        return lnPaymentDetailsList.map { v -> [String: Any?] in return dictionaryOf(lnPaymentDetails: v) }
    }

    static func asLnUrlAuthRequestData(lnUrlAuthRequestData: [String: Any?]) throws -> LnUrlAuthRequestData {
        guard let k1 = lnUrlAuthRequestData["k1"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "k1", typeName: "LnUrlAuthRequestData"))
        }
        guard let domain = lnUrlAuthRequestData["domain"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "domain", typeName: "LnUrlAuthRequestData"))
        }
        guard let url = lnUrlAuthRequestData["url"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "url", typeName: "LnUrlAuthRequestData"))
        }
        var action: String?
        if hasNonNilKey(data: lnUrlAuthRequestData, key: "action") {
            guard let actionTmp = lnUrlAuthRequestData["action"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "action"))
            }
            action = actionTmp
        }

        return LnUrlAuthRequestData(
            k1: k1,
            domain: domain,
            url: url,
            action: action
        )
    }

    static func dictionaryOf(lnUrlAuthRequestData: LnUrlAuthRequestData) -> [String: Any?] {
        return [
            "k1": lnUrlAuthRequestData.k1,
            "domain": lnUrlAuthRequestData.domain,
            "url": lnUrlAuthRequestData.url,
            "action": lnUrlAuthRequestData.action == nil ? nil : lnUrlAuthRequestData.action,
        ]
    }

    static func asLnUrlAuthRequestDataList(arr: [Any]) throws -> [LnUrlAuthRequestData] {
        var list = [LnUrlAuthRequestData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlAuthRequestData = try asLnUrlAuthRequestData(lnUrlAuthRequestData: val)
                list.append(lnUrlAuthRequestData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlAuthRequestData"))
            }
        }
        return list
    }

    static func arrayOf(lnUrlAuthRequestDataList: [LnUrlAuthRequestData]) -> [Any] {
        return lnUrlAuthRequestDataList.map { v -> [String: Any?] in return dictionaryOf(lnUrlAuthRequestData: v) }
    }

    static func asLnUrlErrorData(lnUrlErrorData: [String: Any?]) throws -> LnUrlErrorData {
        guard let reason = lnUrlErrorData["reason"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "reason", typeName: "LnUrlErrorData"))
        }

        return LnUrlErrorData(
            reason: reason)
    }

    static func dictionaryOf(lnUrlErrorData: LnUrlErrorData) -> [String: Any?] {
        return [
            "reason": lnUrlErrorData.reason,
        ]
    }

    static func asLnUrlErrorDataList(arr: [Any]) throws -> [LnUrlErrorData] {
        var list = [LnUrlErrorData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlErrorData = try asLnUrlErrorData(lnUrlErrorData: val)
                list.append(lnUrlErrorData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlErrorData"))
            }
        }
        return list
    }

    static func arrayOf(lnUrlErrorDataList: [LnUrlErrorData]) -> [Any] {
        return lnUrlErrorDataList.map { v -> [String: Any?] in return dictionaryOf(lnUrlErrorData: v) }
    }

    static func asLnUrlPayErrorData(lnUrlPayErrorData: [String: Any?]) throws -> LnUrlPayErrorData {
        guard let paymentHash = lnUrlPayErrorData["paymentHash"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentHash", typeName: "LnUrlPayErrorData"))
        }
        guard let reason = lnUrlPayErrorData["reason"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "reason", typeName: "LnUrlPayErrorData"))
        }

        return LnUrlPayErrorData(
            paymentHash: paymentHash,
            reason: reason
        )
    }

    static func dictionaryOf(lnUrlPayErrorData: LnUrlPayErrorData) -> [String: Any?] {
        return [
            "paymentHash": lnUrlPayErrorData.paymentHash,
            "reason": lnUrlPayErrorData.reason,
        ]
    }

    static func asLnUrlPayErrorDataList(arr: [Any]) throws -> [LnUrlPayErrorData] {
        var list = [LnUrlPayErrorData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlPayErrorData = try asLnUrlPayErrorData(lnUrlPayErrorData: val)
                list.append(lnUrlPayErrorData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlPayErrorData"))
            }
        }
        return list
    }

    static func arrayOf(lnUrlPayErrorDataList: [LnUrlPayErrorData]) -> [Any] {
        return lnUrlPayErrorDataList.map { v -> [String: Any?] in return dictionaryOf(lnUrlPayErrorData: v) }
    }

    static func asLnUrlPayRequest(lnUrlPayRequest: [String: Any?]) throws -> LnUrlPayRequest {
        guard let dataTmp = lnUrlPayRequest["data"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "LnUrlPayRequest"))
        }
        let data = try asLnUrlPayRequestData(lnUrlPayRequestData: dataTmp)

        guard let amountMsat = lnUrlPayRequest["amountMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "amountMsat", typeName: "LnUrlPayRequest"))
        }
        guard let useTrampoline = lnUrlPayRequest["useTrampoline"] as? Bool else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "useTrampoline", typeName: "LnUrlPayRequest"))
        }
        var comment: String?
        if hasNonNilKey(data: lnUrlPayRequest, key: "comment") {
            guard let commentTmp = lnUrlPayRequest["comment"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "comment"))
            }
            comment = commentTmp
        }
        var paymentLabel: String?
        if hasNonNilKey(data: lnUrlPayRequest, key: "paymentLabel") {
            guard let paymentLabelTmp = lnUrlPayRequest["paymentLabel"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "paymentLabel"))
            }
            paymentLabel = paymentLabelTmp
        }
        var validateSuccessActionUrl: Bool?
        if hasNonNilKey(data: lnUrlPayRequest, key: "validateSuccessActionUrl") {
            guard let validateSuccessActionUrlTmp = lnUrlPayRequest["validateSuccessActionUrl"] as? Bool else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "validateSuccessActionUrl"))
            }
            validateSuccessActionUrl = validateSuccessActionUrlTmp
        }

        return LnUrlPayRequest(
            data: data,
            amountMsat: amountMsat,
            useTrampoline: useTrampoline,
            comment: comment,
            paymentLabel: paymentLabel,
            validateSuccessActionUrl: validateSuccessActionUrl
        )
    }

    static func dictionaryOf(lnUrlPayRequest: LnUrlPayRequest) -> [String: Any?] {
        return [
            "data": dictionaryOf(lnUrlPayRequestData: lnUrlPayRequest.data),
            "amountMsat": lnUrlPayRequest.amountMsat,
            "useTrampoline": lnUrlPayRequest.useTrampoline,
            "comment": lnUrlPayRequest.comment == nil ? nil : lnUrlPayRequest.comment,
            "paymentLabel": lnUrlPayRequest.paymentLabel == nil ? nil : lnUrlPayRequest.paymentLabel,
            "validateSuccessActionUrl": lnUrlPayRequest.validateSuccessActionUrl == nil ? nil : lnUrlPayRequest.validateSuccessActionUrl,
        ]
    }

    static func asLnUrlPayRequestList(arr: [Any]) throws -> [LnUrlPayRequest] {
        var list = [LnUrlPayRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlPayRequest = try asLnUrlPayRequest(lnUrlPayRequest: val)
                list.append(lnUrlPayRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlPayRequest"))
            }
        }
        return list
    }

    static func arrayOf(lnUrlPayRequestList: [LnUrlPayRequest]) -> [Any] {
        return lnUrlPayRequestList.map { v -> [String: Any?] in return dictionaryOf(lnUrlPayRequest: v) }
    }

    static func asLnUrlPayRequestData(lnUrlPayRequestData: [String: Any?]) throws -> LnUrlPayRequestData {
        guard let callback = lnUrlPayRequestData["callback"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "callback", typeName: "LnUrlPayRequestData"))
        }
        guard let minSendable = lnUrlPayRequestData["minSendable"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "minSendable", typeName: "LnUrlPayRequestData"))
        }
        guard let maxSendable = lnUrlPayRequestData["maxSendable"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxSendable", typeName: "LnUrlPayRequestData"))
        }
        guard let metadataStr = lnUrlPayRequestData["metadataStr"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "metadataStr", typeName: "LnUrlPayRequestData"))
        }
        guard let commentAllowed = lnUrlPayRequestData["commentAllowed"] as? UInt16 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "commentAllowed", typeName: "LnUrlPayRequestData"))
        }
        guard let domain = lnUrlPayRequestData["domain"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "domain", typeName: "LnUrlPayRequestData"))
        }
        guard let allowsNostr = lnUrlPayRequestData["allowsNostr"] as? Bool else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "allowsNostr", typeName: "LnUrlPayRequestData"))
        }
        var nostrPubkey: String?
        if hasNonNilKey(data: lnUrlPayRequestData, key: "nostrPubkey") {
            guard let nostrPubkeyTmp = lnUrlPayRequestData["nostrPubkey"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "nostrPubkey"))
            }
            nostrPubkey = nostrPubkeyTmp
        }
        var lnAddress: String?
        if hasNonNilKey(data: lnUrlPayRequestData, key: "lnAddress") {
            guard let lnAddressTmp = lnUrlPayRequestData["lnAddress"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "lnAddress"))
            }
            lnAddress = lnAddressTmp
        }

        return LnUrlPayRequestData(
            callback: callback,
            minSendable: minSendable,
            maxSendable: maxSendable,
            metadataStr: metadataStr,
            commentAllowed: commentAllowed,
            domain: domain,
            allowsNostr: allowsNostr,
            nostrPubkey: nostrPubkey,
            lnAddress: lnAddress
        )
    }

    static func dictionaryOf(lnUrlPayRequestData: LnUrlPayRequestData) -> [String: Any?] {
        return [
            "callback": lnUrlPayRequestData.callback,
            "minSendable": lnUrlPayRequestData.minSendable,
            "maxSendable": lnUrlPayRequestData.maxSendable,
            "metadataStr": lnUrlPayRequestData.metadataStr,
            "commentAllowed": lnUrlPayRequestData.commentAllowed,
            "domain": lnUrlPayRequestData.domain,
            "allowsNostr": lnUrlPayRequestData.allowsNostr,
            "nostrPubkey": lnUrlPayRequestData.nostrPubkey == nil ? nil : lnUrlPayRequestData.nostrPubkey,
            "lnAddress": lnUrlPayRequestData.lnAddress == nil ? nil : lnUrlPayRequestData.lnAddress,
        ]
    }

    static func asLnUrlPayRequestDataList(arr: [Any]) throws -> [LnUrlPayRequestData] {
        var list = [LnUrlPayRequestData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlPayRequestData = try asLnUrlPayRequestData(lnUrlPayRequestData: val)
                list.append(lnUrlPayRequestData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlPayRequestData"))
            }
        }
        return list
    }

    static func arrayOf(lnUrlPayRequestDataList: [LnUrlPayRequestData]) -> [Any] {
        return lnUrlPayRequestDataList.map { v -> [String: Any?] in return dictionaryOf(lnUrlPayRequestData: v) }
    }

    static func asLnUrlPaySuccessData(lnUrlPaySuccessData: [String: Any?]) throws -> LnUrlPaySuccessData {
        var successAction: SuccessActionProcessed?
        if let successActionTmp = lnUrlPaySuccessData["successAction"] as? [String: Any?] {
            successAction = try asSuccessActionProcessed(successActionProcessed: successActionTmp)
        }

        guard let paymentTmp = lnUrlPaySuccessData["payment"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "payment", typeName: "LnUrlPaySuccessData"))
        }
        let payment = try asPayment(payment: paymentTmp)

        return LnUrlPaySuccessData(
            successAction: successAction,
            payment: payment
        )
    }

    static func dictionaryOf(lnUrlPaySuccessData: LnUrlPaySuccessData) -> [String: Any?] {
        return [
            "successAction": lnUrlPaySuccessData.successAction == nil ? nil : dictionaryOf(successActionProcessed: lnUrlPaySuccessData.successAction!),
            "payment": dictionaryOf(payment: lnUrlPaySuccessData.payment),
        ]
    }

    static func asLnUrlPaySuccessDataList(arr: [Any]) throws -> [LnUrlPaySuccessData] {
        var list = [LnUrlPaySuccessData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlPaySuccessData = try asLnUrlPaySuccessData(lnUrlPaySuccessData: val)
                list.append(lnUrlPaySuccessData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlPaySuccessData"))
            }
        }
        return list
    }

    static func arrayOf(lnUrlPaySuccessDataList: [LnUrlPaySuccessData]) -> [Any] {
        return lnUrlPaySuccessDataList.map { v -> [String: Any?] in return dictionaryOf(lnUrlPaySuccessData: v) }
    }

    static func asLnUrlWithdrawRequest(lnUrlWithdrawRequest: [String: Any?]) throws -> LnUrlWithdrawRequest {
        guard let dataTmp = lnUrlWithdrawRequest["data"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "LnUrlWithdrawRequest"))
        }
        let data = try asLnUrlWithdrawRequestData(lnUrlWithdrawRequestData: dataTmp)

        guard let amountMsat = lnUrlWithdrawRequest["amountMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "amountMsat", typeName: "LnUrlWithdrawRequest"))
        }
        var description: String?
        if hasNonNilKey(data: lnUrlWithdrawRequest, key: "description") {
            guard let descriptionTmp = lnUrlWithdrawRequest["description"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "description"))
            }
            description = descriptionTmp
        }

        return LnUrlWithdrawRequest(
            data: data,
            amountMsat: amountMsat,
            description: description
        )
    }

    static func dictionaryOf(lnUrlWithdrawRequest: LnUrlWithdrawRequest) -> [String: Any?] {
        return [
            "data": dictionaryOf(lnUrlWithdrawRequestData: lnUrlWithdrawRequest.data),
            "amountMsat": lnUrlWithdrawRequest.amountMsat,
            "description": lnUrlWithdrawRequest.description == nil ? nil : lnUrlWithdrawRequest.description,
        ]
    }

    static func asLnUrlWithdrawRequestList(arr: [Any]) throws -> [LnUrlWithdrawRequest] {
        var list = [LnUrlWithdrawRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlWithdrawRequest = try asLnUrlWithdrawRequest(lnUrlWithdrawRequest: val)
                list.append(lnUrlWithdrawRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlWithdrawRequest"))
            }
        }
        return list
    }

    static func arrayOf(lnUrlWithdrawRequestList: [LnUrlWithdrawRequest]) -> [Any] {
        return lnUrlWithdrawRequestList.map { v -> [String: Any?] in return dictionaryOf(lnUrlWithdrawRequest: v) }
    }

    static func asLnUrlWithdrawRequestData(lnUrlWithdrawRequestData: [String: Any?]) throws -> LnUrlWithdrawRequestData {
        guard let callback = lnUrlWithdrawRequestData["callback"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "callback", typeName: "LnUrlWithdrawRequestData"))
        }
        guard let k1 = lnUrlWithdrawRequestData["k1"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "k1", typeName: "LnUrlWithdrawRequestData"))
        }
        guard let defaultDescription = lnUrlWithdrawRequestData["defaultDescription"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "defaultDescription", typeName: "LnUrlWithdrawRequestData"))
        }
        guard let minWithdrawable = lnUrlWithdrawRequestData["minWithdrawable"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "minWithdrawable", typeName: "LnUrlWithdrawRequestData"))
        }
        guard let maxWithdrawable = lnUrlWithdrawRequestData["maxWithdrawable"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxWithdrawable", typeName: "LnUrlWithdrawRequestData"))
        }

        return LnUrlWithdrawRequestData(
            callback: callback,
            k1: k1,
            defaultDescription: defaultDescription,
            minWithdrawable: minWithdrawable,
            maxWithdrawable: maxWithdrawable
        )
    }

    static func dictionaryOf(lnUrlWithdrawRequestData: LnUrlWithdrawRequestData) -> [String: Any?] {
        return [
            "callback": lnUrlWithdrawRequestData.callback,
            "k1": lnUrlWithdrawRequestData.k1,
            "defaultDescription": lnUrlWithdrawRequestData.defaultDescription,
            "minWithdrawable": lnUrlWithdrawRequestData.minWithdrawable,
            "maxWithdrawable": lnUrlWithdrawRequestData.maxWithdrawable,
        ]
    }

    static func asLnUrlWithdrawRequestDataList(arr: [Any]) throws -> [LnUrlWithdrawRequestData] {
        var list = [LnUrlWithdrawRequestData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlWithdrawRequestData = try asLnUrlWithdrawRequestData(lnUrlWithdrawRequestData: val)
                list.append(lnUrlWithdrawRequestData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlWithdrawRequestData"))
            }
        }
        return list
    }

    static func arrayOf(lnUrlWithdrawRequestDataList: [LnUrlWithdrawRequestData]) -> [Any] {
        return lnUrlWithdrawRequestDataList.map { v -> [String: Any?] in return dictionaryOf(lnUrlWithdrawRequestData: v) }
    }

    static func asLnUrlWithdrawSuccessData(lnUrlWithdrawSuccessData: [String: Any?]) throws -> LnUrlWithdrawSuccessData {
        guard let invoiceTmp = lnUrlWithdrawSuccessData["invoice"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "invoice", typeName: "LnUrlWithdrawSuccessData"))
        }
        let invoice = try asLnInvoice(lnInvoice: invoiceTmp)

        return LnUrlWithdrawSuccessData(
            invoice: invoice)
    }

    static func dictionaryOf(lnUrlWithdrawSuccessData: LnUrlWithdrawSuccessData) -> [String: Any?] {
        return [
            "invoice": dictionaryOf(lnInvoice: lnUrlWithdrawSuccessData.invoice),
        ]
    }

    static func asLnUrlWithdrawSuccessDataList(arr: [Any]) throws -> [LnUrlWithdrawSuccessData] {
        var list = [LnUrlWithdrawSuccessData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlWithdrawSuccessData = try asLnUrlWithdrawSuccessData(lnUrlWithdrawSuccessData: val)
                list.append(lnUrlWithdrawSuccessData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlWithdrawSuccessData"))
            }
        }
        return list
    }

    static func arrayOf(lnUrlWithdrawSuccessDataList: [LnUrlWithdrawSuccessData]) -> [Any] {
        return lnUrlWithdrawSuccessDataList.map { v -> [String: Any?] in return dictionaryOf(lnUrlWithdrawSuccessData: v) }
    }

    static func asLocaleOverrides(localeOverrides: [String: Any?]) throws -> LocaleOverrides {
        guard let locale = localeOverrides["locale"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "locale", typeName: "LocaleOverrides"))
        }
        var spacing: UInt32?
        if hasNonNilKey(data: localeOverrides, key: "spacing") {
            guard let spacingTmp = localeOverrides["spacing"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "spacing"))
            }
            spacing = spacingTmp
        }
        guard let symbolTmp = localeOverrides["symbol"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "symbol", typeName: "LocaleOverrides"))
        }
        let symbol = try asSymbol(symbol: symbolTmp)

        return LocaleOverrides(
            locale: locale,
            spacing: spacing,
            symbol: symbol
        )
    }

    static func dictionaryOf(localeOverrides: LocaleOverrides) -> [String: Any?] {
        return [
            "locale": localeOverrides.locale,
            "spacing": localeOverrides.spacing == nil ? nil : localeOverrides.spacing,
            "symbol": dictionaryOf(symbol: localeOverrides.symbol),
        ]
    }

    static func asLocaleOverridesList(arr: [Any]) throws -> [LocaleOverrides] {
        var list = [LocaleOverrides]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var localeOverrides = try asLocaleOverrides(localeOverrides: val)
                list.append(localeOverrides)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LocaleOverrides"))
            }
        }
        return list
    }

    static func arrayOf(localeOverridesList: [LocaleOverrides]) -> [Any] {
        return localeOverridesList.map { v -> [String: Any?] in return dictionaryOf(localeOverrides: v) }
    }

    static func asLocalizedName(localizedName: [String: Any?]) throws -> LocalizedName {
        guard let locale = localizedName["locale"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "locale", typeName: "LocalizedName"))
        }
        guard let name = localizedName["name"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "name", typeName: "LocalizedName"))
        }

        return LocalizedName(
            locale: locale,
            name: name
        )
    }

    static func dictionaryOf(localizedName: LocalizedName) -> [String: Any?] {
        return [
            "locale": localizedName.locale,
            "name": localizedName.name,
        ]
    }

    static func asLocalizedNameList(arr: [Any]) throws -> [LocalizedName] {
        var list = [LocalizedName]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var localizedName = try asLocalizedName(localizedName: val)
                list.append(localizedName)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LocalizedName"))
            }
        }
        return list
    }

    static func arrayOf(localizedNameList: [LocalizedName]) -> [Any] {
        return localizedNameList.map { v -> [String: Any?] in return dictionaryOf(localizedName: v) }
    }

    static func asLogEntry(logEntry: [String: Any?]) throws -> LogEntry {
        guard let line = logEntry["line"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "line", typeName: "LogEntry"))
        }
        guard let level = logEntry["level"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "level", typeName: "LogEntry"))
        }

        return LogEntry(
            line: line,
            level: level
        )
    }

    static func dictionaryOf(logEntry: LogEntry) -> [String: Any?] {
        return [
            "line": logEntry.line,
            "level": logEntry.level,
        ]
    }

    static func asLogEntryList(arr: [Any]) throws -> [LogEntry] {
        var list = [LogEntry]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var logEntry = try asLogEntry(logEntry: val)
                list.append(logEntry)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LogEntry"))
            }
        }
        return list
    }

    static func arrayOf(logEntryList: [LogEntry]) -> [Any] {
        return logEntryList.map { v -> [String: Any?] in return dictionaryOf(logEntry: v) }
    }

    static func asLspInformation(lspInformation: [String: Any?]) throws -> LspInformation {
        guard let id = lspInformation["id"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "id", typeName: "LspInformation"))
        }
        guard let name = lspInformation["name"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "name", typeName: "LspInformation"))
        }
        guard let widgetUrl = lspInformation["widgetUrl"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "widgetUrl", typeName: "LspInformation"))
        }
        guard let pubkey = lspInformation["pubkey"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "pubkey", typeName: "LspInformation"))
        }
        guard let host = lspInformation["host"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "host", typeName: "LspInformation"))
        }
        guard let baseFeeMsat = lspInformation["baseFeeMsat"] as? Int64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "baseFeeMsat", typeName: "LspInformation"))
        }
        guard let feeRate = lspInformation["feeRate"] as? Double else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feeRate", typeName: "LspInformation"))
        }
        guard let timeLockDelta = lspInformation["timeLockDelta"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "timeLockDelta", typeName: "LspInformation"))
        }
        guard let minHtlcMsat = lspInformation["minHtlcMsat"] as? Int64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "minHtlcMsat", typeName: "LspInformation"))
        }
        guard let lspPubkey = lspInformation["lspPubkey"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "lspPubkey", typeName: "LspInformation"))
        }
        guard let openingFeeParamsListTmp = lspInformation["openingFeeParamsList"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "openingFeeParamsList", typeName: "LspInformation"))
        }
        let openingFeeParamsList = try asOpeningFeeParamsMenu(openingFeeParamsMenu: openingFeeParamsListTmp)

        return LspInformation(
            id: id,
            name: name,
            widgetUrl: widgetUrl,
            pubkey: pubkey,
            host: host,
            baseFeeMsat: baseFeeMsat,
            feeRate: feeRate,
            timeLockDelta: timeLockDelta,
            minHtlcMsat: minHtlcMsat,
            lspPubkey: lspPubkey,
            openingFeeParamsList: openingFeeParamsList
        )
    }

    static func dictionaryOf(lspInformation: LspInformation) -> [String: Any?] {
        return [
            "id": lspInformation.id,
            "name": lspInformation.name,
            "widgetUrl": lspInformation.widgetUrl,
            "pubkey": lspInformation.pubkey,
            "host": lspInformation.host,
            "baseFeeMsat": lspInformation.baseFeeMsat,
            "feeRate": lspInformation.feeRate,
            "timeLockDelta": lspInformation.timeLockDelta,
            "minHtlcMsat": lspInformation.minHtlcMsat,
            "lspPubkey": lspInformation.lspPubkey,
            "openingFeeParamsList": dictionaryOf(openingFeeParamsMenu: lspInformation.openingFeeParamsList),
        ]
    }

    static func asLspInformationList(arr: [Any]) throws -> [LspInformation] {
        var list = [LspInformation]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lspInformation = try asLspInformation(lspInformation: val)
                list.append(lspInformation)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LspInformation"))
            }
        }
        return list
    }

    static func arrayOf(lspInformationList: [LspInformation]) -> [Any] {
        return lspInformationList.map { v -> [String: Any?] in return dictionaryOf(lspInformation: v) }
    }

    static func asMaxReverseSwapAmountResponse(maxReverseSwapAmountResponse: [String: Any?]) throws -> MaxReverseSwapAmountResponse {
        guard let totalSat = maxReverseSwapAmountResponse["totalSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "totalSat", typeName: "MaxReverseSwapAmountResponse"))
        }

        return MaxReverseSwapAmountResponse(
            totalSat: totalSat)
    }

    static func dictionaryOf(maxReverseSwapAmountResponse: MaxReverseSwapAmountResponse) -> [String: Any?] {
        return [
            "totalSat": maxReverseSwapAmountResponse.totalSat,
        ]
    }

    static func asMaxReverseSwapAmountResponseList(arr: [Any]) throws -> [MaxReverseSwapAmountResponse] {
        var list = [MaxReverseSwapAmountResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var maxReverseSwapAmountResponse = try asMaxReverseSwapAmountResponse(maxReverseSwapAmountResponse: val)
                list.append(maxReverseSwapAmountResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "MaxReverseSwapAmountResponse"))
            }
        }
        return list
    }

    static func arrayOf(maxReverseSwapAmountResponseList: [MaxReverseSwapAmountResponse]) -> [Any] {
        return maxReverseSwapAmountResponseList.map { v -> [String: Any?] in return dictionaryOf(maxReverseSwapAmountResponse: v) }
    }

    static func asMessageSuccessActionData(messageSuccessActionData: [String: Any?]) throws -> MessageSuccessActionData {
        guard let message = messageSuccessActionData["message"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "message", typeName: "MessageSuccessActionData"))
        }

        return MessageSuccessActionData(
            message: message)
    }

    static func dictionaryOf(messageSuccessActionData: MessageSuccessActionData) -> [String: Any?] {
        return [
            "message": messageSuccessActionData.message,
        ]
    }

    static func asMessageSuccessActionDataList(arr: [Any]) throws -> [MessageSuccessActionData] {
        var list = [MessageSuccessActionData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var messageSuccessActionData = try asMessageSuccessActionData(messageSuccessActionData: val)
                list.append(messageSuccessActionData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "MessageSuccessActionData"))
            }
        }
        return list
    }

    static func arrayOf(messageSuccessActionDataList: [MessageSuccessActionData]) -> [Any] {
        return messageSuccessActionDataList.map { v -> [String: Any?] in return dictionaryOf(messageSuccessActionData: v) }
    }

    static func asMetadataFilter(metadataFilter: [String: Any?]) throws -> MetadataFilter {
        guard let jsonPath = metadataFilter["jsonPath"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "jsonPath", typeName: "MetadataFilter"))
        }
        guard let jsonValue = metadataFilter["jsonValue"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "jsonValue", typeName: "MetadataFilter"))
        }

        return MetadataFilter(
            jsonPath: jsonPath,
            jsonValue: jsonValue
        )
    }

    static func dictionaryOf(metadataFilter: MetadataFilter) -> [String: Any?] {
        return [
            "jsonPath": metadataFilter.jsonPath,
            "jsonValue": metadataFilter.jsonValue,
        ]
    }

    static func asMetadataFilterList(arr: [Any]) throws -> [MetadataFilter] {
        var list = [MetadataFilter]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var metadataFilter = try asMetadataFilter(metadataFilter: val)
                list.append(metadataFilter)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "MetadataFilter"))
            }
        }
        return list
    }

    static func arrayOf(metadataFilterList: [MetadataFilter]) -> [Any] {
        return metadataFilterList.map { v -> [String: Any?] in return dictionaryOf(metadataFilter: v) }
    }

    static func asMetadataItem(metadataItem: [String: Any?]) throws -> MetadataItem {
        guard let key = metadataItem["key"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "key", typeName: "MetadataItem"))
        }
        guard let value = metadataItem["value"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "value", typeName: "MetadataItem"))
        }

        return MetadataItem(
            key: key,
            value: value
        )
    }

    static func dictionaryOf(metadataItem: MetadataItem) -> [String: Any?] {
        return [
            "key": metadataItem.key,
            "value": metadataItem.value,
        ]
    }

    static func asMetadataItemList(arr: [Any]) throws -> [MetadataItem] {
        var list = [MetadataItem]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var metadataItem = try asMetadataItem(metadataItem: val)
                list.append(metadataItem)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "MetadataItem"))
            }
        }
        return list
    }

    static func arrayOf(metadataItemList: [MetadataItem]) -> [Any] {
        return metadataItemList.map { v -> [String: Any?] in return dictionaryOf(metadataItem: v) }
    }

    static func asNodeState(nodeState: [String: Any?]) throws -> NodeState {
        guard let id = nodeState["id"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "id", typeName: "NodeState"))
        }
        guard let blockHeight = nodeState["blockHeight"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "blockHeight", typeName: "NodeState"))
        }
        guard let channelsBalanceMsat = nodeState["channelsBalanceMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "channelsBalanceMsat", typeName: "NodeState"))
        }
        guard let onchainBalanceMsat = nodeState["onchainBalanceMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "onchainBalanceMsat", typeName: "NodeState"))
        }
        guard let pendingOnchainBalanceMsat = nodeState["pendingOnchainBalanceMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "pendingOnchainBalanceMsat", typeName: "NodeState"))
        }
        guard let utxosTmp = nodeState["utxos"] as? [[String: Any?]] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "utxos", typeName: "NodeState"))
        }
        let utxos = try asUnspentTransactionOutputList(arr: utxosTmp)

        guard let maxPayableMsat = nodeState["maxPayableMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxPayableMsat", typeName: "NodeState"))
        }
        guard let maxReceivableMsat = nodeState["maxReceivableMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxReceivableMsat", typeName: "NodeState"))
        }
        guard let maxSinglePaymentAmountMsat = nodeState["maxSinglePaymentAmountMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxSinglePaymentAmountMsat", typeName: "NodeState"))
        }
        guard let maxChanReserveMsats = nodeState["maxChanReserveMsats"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxChanReserveMsats", typeName: "NodeState"))
        }
        guard let connectedPeersTmp = nodeState["connectedPeers"] as? [[String: Any?]] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "connectedPeers", typeName: "NodeState"))
        }
        let connectedPeers = try asConnectedPeerList(arr: connectedPeersTmp)

        guard let maxReceivableSinglePaymentAmountMsat = nodeState["maxReceivableSinglePaymentAmountMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxReceivableSinglePaymentAmountMsat", typeName: "NodeState"))
        }
        guard let totalInboundLiquidityMsats = nodeState["totalInboundLiquidityMsats"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "totalInboundLiquidityMsats", typeName: "NodeState"))
        }

        return NodeState(
            id: id,
            blockHeight: blockHeight,
            channelsBalanceMsat: channelsBalanceMsat,
            onchainBalanceMsat: onchainBalanceMsat,
            pendingOnchainBalanceMsat: pendingOnchainBalanceMsat,
            utxos: utxos,
            maxPayableMsat: maxPayableMsat,
            maxReceivableMsat: maxReceivableMsat,
            maxSinglePaymentAmountMsat: maxSinglePaymentAmountMsat,
            maxChanReserveMsats: maxChanReserveMsats,
            connectedPeers: connectedPeers,
            maxReceivableSinglePaymentAmountMsat: maxReceivableSinglePaymentAmountMsat,
            totalInboundLiquidityMsats: totalInboundLiquidityMsats
        )
    }

    static func dictionaryOf(nodeState: NodeState) -> [String: Any?] {
        return [
            "id": nodeState.id,
            "blockHeight": nodeState.blockHeight,
            "channelsBalanceMsat": nodeState.channelsBalanceMsat,
            "onchainBalanceMsat": nodeState.onchainBalanceMsat,
            "pendingOnchainBalanceMsat": nodeState.pendingOnchainBalanceMsat,
            "utxos": arrayOf(unspentTransactionOutputList: nodeState.utxos),
            "maxPayableMsat": nodeState.maxPayableMsat,
            "maxReceivableMsat": nodeState.maxReceivableMsat,
            "maxSinglePaymentAmountMsat": nodeState.maxSinglePaymentAmountMsat,
            "maxChanReserveMsats": nodeState.maxChanReserveMsats,
            "connectedPeers": arrayOf(connectedPeerList: nodeState.connectedPeers),
            "maxReceivableSinglePaymentAmountMsat": nodeState.maxReceivableSinglePaymentAmountMsat,
            "totalInboundLiquidityMsats": nodeState.totalInboundLiquidityMsats,
        ]
    }

    static func asNodeStateList(arr: [Any]) throws -> [NodeState] {
        var list = [NodeState]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var nodeState = try asNodeState(nodeState: val)
                list.append(nodeState)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "NodeState"))
            }
        }
        return list
    }

    static func arrayOf(nodeStateList: [NodeState]) -> [Any] {
        return nodeStateList.map { v -> [String: Any?] in return dictionaryOf(nodeState: v) }
    }

    static func asOnchainPaymentLimitsResponse(onchainPaymentLimitsResponse: [String: Any?]) throws -> OnchainPaymentLimitsResponse {
        guard let minSat = onchainPaymentLimitsResponse["minSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "minSat", typeName: "OnchainPaymentLimitsResponse"))
        }
        guard let maxSat = onchainPaymentLimitsResponse["maxSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxSat", typeName: "OnchainPaymentLimitsResponse"))
        }
        guard let maxPayableSat = onchainPaymentLimitsResponse["maxPayableSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxPayableSat", typeName: "OnchainPaymentLimitsResponse"))
        }

        return OnchainPaymentLimitsResponse(
            minSat: minSat,
            maxSat: maxSat,
            maxPayableSat: maxPayableSat
        )
    }

    static func dictionaryOf(onchainPaymentLimitsResponse: OnchainPaymentLimitsResponse) -> [String: Any?] {
        return [
            "minSat": onchainPaymentLimitsResponse.minSat,
            "maxSat": onchainPaymentLimitsResponse.maxSat,
            "maxPayableSat": onchainPaymentLimitsResponse.maxPayableSat,
        ]
    }

    static func asOnchainPaymentLimitsResponseList(arr: [Any]) throws -> [OnchainPaymentLimitsResponse] {
        var list = [OnchainPaymentLimitsResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var onchainPaymentLimitsResponse = try asOnchainPaymentLimitsResponse(onchainPaymentLimitsResponse: val)
                list.append(onchainPaymentLimitsResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "OnchainPaymentLimitsResponse"))
            }
        }
        return list
    }

    static func arrayOf(onchainPaymentLimitsResponseList: [OnchainPaymentLimitsResponse]) -> [Any] {
        return onchainPaymentLimitsResponseList.map { v -> [String: Any?] in return dictionaryOf(onchainPaymentLimitsResponse: v) }
    }

    static func asOpenChannelFeeRequest(openChannelFeeRequest: [String: Any?]) throws -> OpenChannelFeeRequest {
        var amountMsat: UInt64?
        if hasNonNilKey(data: openChannelFeeRequest, key: "amountMsat") {
            guard let amountMsatTmp = openChannelFeeRequest["amountMsat"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "amountMsat"))
            }
            amountMsat = amountMsatTmp
        }
        var expiry: UInt32?
        if hasNonNilKey(data: openChannelFeeRequest, key: "expiry") {
            guard let expiryTmp = openChannelFeeRequest["expiry"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "expiry"))
            }
            expiry = expiryTmp
        }

        return OpenChannelFeeRequest(
            amountMsat: amountMsat,
            expiry: expiry
        )
    }

    static func dictionaryOf(openChannelFeeRequest: OpenChannelFeeRequest) -> [String: Any?] {
        return [
            "amountMsat": openChannelFeeRequest.amountMsat == nil ? nil : openChannelFeeRequest.amountMsat,
            "expiry": openChannelFeeRequest.expiry == nil ? nil : openChannelFeeRequest.expiry,
        ]
    }

    static func asOpenChannelFeeRequestList(arr: [Any]) throws -> [OpenChannelFeeRequest] {
        var list = [OpenChannelFeeRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var openChannelFeeRequest = try asOpenChannelFeeRequest(openChannelFeeRequest: val)
                list.append(openChannelFeeRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "OpenChannelFeeRequest"))
            }
        }
        return list
    }

    static func arrayOf(openChannelFeeRequestList: [OpenChannelFeeRequest]) -> [Any] {
        return openChannelFeeRequestList.map { v -> [String: Any?] in return dictionaryOf(openChannelFeeRequest: v) }
    }

    static func asOpenChannelFeeResponse(openChannelFeeResponse: [String: Any?]) throws -> OpenChannelFeeResponse {
        var feeMsat: UInt64?
        if hasNonNilKey(data: openChannelFeeResponse, key: "feeMsat") {
            guard let feeMsatTmp = openChannelFeeResponse["feeMsat"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "feeMsat"))
            }
            feeMsat = feeMsatTmp
        }
        guard let feeParamsTmp = openChannelFeeResponse["feeParams"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feeParams", typeName: "OpenChannelFeeResponse"))
        }
        let feeParams = try asOpeningFeeParams(openingFeeParams: feeParamsTmp)

        return OpenChannelFeeResponse(
            feeMsat: feeMsat,
            feeParams: feeParams
        )
    }

    static func dictionaryOf(openChannelFeeResponse: OpenChannelFeeResponse) -> [String: Any?] {
        return [
            "feeMsat": openChannelFeeResponse.feeMsat == nil ? nil : openChannelFeeResponse.feeMsat,
            "feeParams": dictionaryOf(openingFeeParams: openChannelFeeResponse.feeParams),
        ]
    }

    static func asOpenChannelFeeResponseList(arr: [Any]) throws -> [OpenChannelFeeResponse] {
        var list = [OpenChannelFeeResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var openChannelFeeResponse = try asOpenChannelFeeResponse(openChannelFeeResponse: val)
                list.append(openChannelFeeResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "OpenChannelFeeResponse"))
            }
        }
        return list
    }

    static func arrayOf(openChannelFeeResponseList: [OpenChannelFeeResponse]) -> [Any] {
        return openChannelFeeResponseList.map { v -> [String: Any?] in return dictionaryOf(openChannelFeeResponse: v) }
    }

    static func asOpeningFeeParams(openingFeeParams: [String: Any?]) throws -> OpeningFeeParams {
        guard let minMsat = openingFeeParams["minMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "minMsat", typeName: "OpeningFeeParams"))
        }
        guard let proportional = openingFeeParams["proportional"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "proportional", typeName: "OpeningFeeParams"))
        }
        guard let validUntil = openingFeeParams["validUntil"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "validUntil", typeName: "OpeningFeeParams"))
        }
        guard let maxIdleTime = openingFeeParams["maxIdleTime"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxIdleTime", typeName: "OpeningFeeParams"))
        }
        guard let maxClientToSelfDelay = openingFeeParams["maxClientToSelfDelay"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxClientToSelfDelay", typeName: "OpeningFeeParams"))
        }
        guard let promise = openingFeeParams["promise"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "promise", typeName: "OpeningFeeParams"))
        }

        return OpeningFeeParams(
            minMsat: minMsat,
            proportional: proportional,
            validUntil: validUntil,
            maxIdleTime: maxIdleTime,
            maxClientToSelfDelay: maxClientToSelfDelay,
            promise: promise
        )
    }

    static func dictionaryOf(openingFeeParams: OpeningFeeParams) -> [String: Any?] {
        return [
            "minMsat": openingFeeParams.minMsat,
            "proportional": openingFeeParams.proportional,
            "validUntil": openingFeeParams.validUntil,
            "maxIdleTime": openingFeeParams.maxIdleTime,
            "maxClientToSelfDelay": openingFeeParams.maxClientToSelfDelay,
            "promise": openingFeeParams.promise,
        ]
    }

    static func asOpeningFeeParamsList(arr: [Any]) throws -> [OpeningFeeParams] {
        var list = [OpeningFeeParams]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var openingFeeParams = try asOpeningFeeParams(openingFeeParams: val)
                list.append(openingFeeParams)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "OpeningFeeParams"))
            }
        }
        return list
    }

    static func arrayOf(openingFeeParamsList: [OpeningFeeParams]) -> [Any] {
        return openingFeeParamsList.map { v -> [String: Any?] in return dictionaryOf(openingFeeParams: v) }
    }

    static func asOpeningFeeParamsMenu(openingFeeParamsMenu: [String: Any?]) throws -> OpeningFeeParamsMenu {
        guard let valuesTmp = openingFeeParamsMenu["values"] as? [[String: Any?]] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "values", typeName: "OpeningFeeParamsMenu"))
        }
        let values = try asOpeningFeeParamsList(arr: valuesTmp)

        return OpeningFeeParamsMenu(
            values: values)
    }

    static func dictionaryOf(openingFeeParamsMenu: OpeningFeeParamsMenu) -> [String: Any?] {
        return [
            "values": arrayOf(openingFeeParamsList: openingFeeParamsMenu.values),
        ]
    }

    static func asOpeningFeeParamsMenuList(arr: [Any]) throws -> [OpeningFeeParamsMenu] {
        var list = [OpeningFeeParamsMenu]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var openingFeeParamsMenu = try asOpeningFeeParamsMenu(openingFeeParamsMenu: val)
                list.append(openingFeeParamsMenu)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "OpeningFeeParamsMenu"))
            }
        }
        return list
    }

    static func arrayOf(openingFeeParamsMenuList: [OpeningFeeParamsMenu]) -> [Any] {
        return openingFeeParamsMenuList.map { v -> [String: Any?] in return dictionaryOf(openingFeeParamsMenu: v) }
    }

    static func asPayOnchainRequest(payOnchainRequest: [String: Any?]) throws -> PayOnchainRequest {
        guard let recipientAddress = payOnchainRequest["recipientAddress"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "recipientAddress", typeName: "PayOnchainRequest"))
        }
        guard let prepareResTmp = payOnchainRequest["prepareRes"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "prepareRes", typeName: "PayOnchainRequest"))
        }
        let prepareRes = try asPrepareOnchainPaymentResponse(prepareOnchainPaymentResponse: prepareResTmp)

        return PayOnchainRequest(
            recipientAddress: recipientAddress,
            prepareRes: prepareRes
        )
    }

    static func dictionaryOf(payOnchainRequest: PayOnchainRequest) -> [String: Any?] {
        return [
            "recipientAddress": payOnchainRequest.recipientAddress,
            "prepareRes": dictionaryOf(prepareOnchainPaymentResponse: payOnchainRequest.prepareRes),
        ]
    }

    static func asPayOnchainRequestList(arr: [Any]) throws -> [PayOnchainRequest] {
        var list = [PayOnchainRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var payOnchainRequest = try asPayOnchainRequest(payOnchainRequest: val)
                list.append(payOnchainRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PayOnchainRequest"))
            }
        }
        return list
    }

    static func arrayOf(payOnchainRequestList: [PayOnchainRequest]) -> [Any] {
        return payOnchainRequestList.map { v -> [String: Any?] in return dictionaryOf(payOnchainRequest: v) }
    }

    static func asPayOnchainResponse(payOnchainResponse: [String: Any?]) throws -> PayOnchainResponse {
        guard let reverseSwapInfoTmp = payOnchainResponse["reverseSwapInfo"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "reverseSwapInfo", typeName: "PayOnchainResponse"))
        }
        let reverseSwapInfo = try asReverseSwapInfo(reverseSwapInfo: reverseSwapInfoTmp)

        return PayOnchainResponse(
            reverseSwapInfo: reverseSwapInfo)
    }

    static func dictionaryOf(payOnchainResponse: PayOnchainResponse) -> [String: Any?] {
        return [
            "reverseSwapInfo": dictionaryOf(reverseSwapInfo: payOnchainResponse.reverseSwapInfo),
        ]
    }

    static func asPayOnchainResponseList(arr: [Any]) throws -> [PayOnchainResponse] {
        var list = [PayOnchainResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var payOnchainResponse = try asPayOnchainResponse(payOnchainResponse: val)
                list.append(payOnchainResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PayOnchainResponse"))
            }
        }
        return list
    }

    static func arrayOf(payOnchainResponseList: [PayOnchainResponse]) -> [Any] {
        return payOnchainResponseList.map { v -> [String: Any?] in return dictionaryOf(payOnchainResponse: v) }
    }

    static func asPayment(payment: [String: Any?]) throws -> Payment {
        guard let id = payment["id"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "id", typeName: "Payment"))
        }
        guard let paymentTypeTmp = payment["paymentType"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentType", typeName: "Payment"))
        }
        let paymentType = try asPaymentType(paymentType: paymentTypeTmp)

        guard let paymentTime = payment["paymentTime"] as? Int64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentTime", typeName: "Payment"))
        }
        guard let amountMsat = payment["amountMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "amountMsat", typeName: "Payment"))
        }
        guard let feeMsat = payment["feeMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feeMsat", typeName: "Payment"))
        }
        guard let statusTmp = payment["status"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "status", typeName: "Payment"))
        }
        let status = try asPaymentStatus(paymentStatus: statusTmp)

        var error: String?
        if hasNonNilKey(data: payment, key: "error") {
            guard let errorTmp = payment["error"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "error"))
            }
            error = errorTmp
        }
        var description: String?
        if hasNonNilKey(data: payment, key: "description") {
            guard let descriptionTmp = payment["description"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "description"))
            }
            description = descriptionTmp
        }
        guard let detailsTmp = payment["details"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "details", typeName: "Payment"))
        }
        let details = try asPaymentDetails(paymentDetails: detailsTmp)

        var metadata: String?
        if hasNonNilKey(data: payment, key: "metadata") {
            guard let metadataTmp = payment["metadata"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "metadata"))
            }
            metadata = metadataTmp
        }

        return Payment(
            id: id,
            paymentType: paymentType,
            paymentTime: paymentTime,
            amountMsat: amountMsat,
            feeMsat: feeMsat,
            status: status,
            error: error,
            description: description,
            details: details,
            metadata: metadata
        )
    }

    static func dictionaryOf(payment: Payment) -> [String: Any?] {
        return [
            "id": payment.id,
            "paymentType": valueOf(paymentType: payment.paymentType),
            "paymentTime": payment.paymentTime,
            "amountMsat": payment.amountMsat,
            "feeMsat": payment.feeMsat,
            "status": valueOf(paymentStatus: payment.status),
            "error": payment.error == nil ? nil : payment.error,
            "description": payment.description == nil ? nil : payment.description,
            "details": dictionaryOf(paymentDetails: payment.details),
            "metadata": payment.metadata == nil ? nil : payment.metadata,
        ]
    }

    static func asPaymentList(arr: [Any]) throws -> [Payment] {
        var list = [Payment]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var payment = try asPayment(payment: val)
                list.append(payment)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "Payment"))
            }
        }
        return list
    }

    static func arrayOf(paymentList: [Payment]) -> [Any] {
        return paymentList.map { v -> [String: Any?] in return dictionaryOf(payment: v) }
    }

    static func asPaymentFailedData(paymentFailedData: [String: Any?]) throws -> PaymentFailedData {
        guard let error = paymentFailedData["error"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "error", typeName: "PaymentFailedData"))
        }
        guard let nodeId = paymentFailedData["nodeId"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "nodeId", typeName: "PaymentFailedData"))
        }
        var invoice: LnInvoice?
        if let invoiceTmp = paymentFailedData["invoice"] as? [String: Any?] {
            invoice = try asLnInvoice(lnInvoice: invoiceTmp)
        }

        var label: String?
        if hasNonNilKey(data: paymentFailedData, key: "label") {
            guard let labelTmp = paymentFailedData["label"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "label"))
            }
            label = labelTmp
        }

        return PaymentFailedData(
            error: error,
            nodeId: nodeId,
            invoice: invoice,
            label: label
        )
    }

    static func dictionaryOf(paymentFailedData: PaymentFailedData) -> [String: Any?] {
        return [
            "error": paymentFailedData.error,
            "nodeId": paymentFailedData.nodeId,
            "invoice": paymentFailedData.invoice == nil ? nil : dictionaryOf(lnInvoice: paymentFailedData.invoice!),
            "label": paymentFailedData.label == nil ? nil : paymentFailedData.label,
        ]
    }

    static func asPaymentFailedDataList(arr: [Any]) throws -> [PaymentFailedData] {
        var list = [PaymentFailedData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var paymentFailedData = try asPaymentFailedData(paymentFailedData: val)
                list.append(paymentFailedData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PaymentFailedData"))
            }
        }
        return list
    }

    static func arrayOf(paymentFailedDataList: [PaymentFailedData]) -> [Any] {
        return paymentFailedDataList.map { v -> [String: Any?] in return dictionaryOf(paymentFailedData: v) }
    }

    static func asPeerFeatures(peerFeatures: [String: Any?]) throws -> PeerFeatures {
        guard let trampoline = peerFeatures["trampoline"] as? Bool else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "trampoline", typeName: "PeerFeatures"))
        }

        return PeerFeatures(
            trampoline: trampoline)
    }

    static func dictionaryOf(peerFeatures: PeerFeatures) -> [String: Any?] {
        return [
            "trampoline": peerFeatures.trampoline,
        ]
    }

    static func asPeerFeaturesList(arr: [Any]) throws -> [PeerFeatures] {
        var list = [PeerFeatures]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var peerFeatures = try asPeerFeatures(peerFeatures: val)
                list.append(peerFeatures)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PeerFeatures"))
            }
        }
        return list
    }

    static func arrayOf(peerFeaturesList: [PeerFeatures]) -> [Any] {
        return peerFeaturesList.map { v -> [String: Any?] in return dictionaryOf(peerFeatures: v) }
    }

    static func asPrepareOnchainPaymentRequest(prepareOnchainPaymentRequest: [String: Any?]) throws -> PrepareOnchainPaymentRequest {
        guard let amountSat = prepareOnchainPaymentRequest["amountSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "amountSat", typeName: "PrepareOnchainPaymentRequest"))
        }
        guard let amountTypeTmp = prepareOnchainPaymentRequest["amountType"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "amountType", typeName: "PrepareOnchainPaymentRequest"))
        }
        let amountType = try asSwapAmountType(swapAmountType: amountTypeTmp)

        guard let claimTxFeerate = prepareOnchainPaymentRequest["claimTxFeerate"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "claimTxFeerate", typeName: "PrepareOnchainPaymentRequest"))
        }

        return PrepareOnchainPaymentRequest(
            amountSat: amountSat,
            amountType: amountType,
            claimTxFeerate: claimTxFeerate
        )
    }

    static func dictionaryOf(prepareOnchainPaymentRequest: PrepareOnchainPaymentRequest) -> [String: Any?] {
        return [
            "amountSat": prepareOnchainPaymentRequest.amountSat,
            "amountType": valueOf(swapAmountType: prepareOnchainPaymentRequest.amountType),
            "claimTxFeerate": prepareOnchainPaymentRequest.claimTxFeerate,
        ]
    }

    static func asPrepareOnchainPaymentRequestList(arr: [Any]) throws -> [PrepareOnchainPaymentRequest] {
        var list = [PrepareOnchainPaymentRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var prepareOnchainPaymentRequest = try asPrepareOnchainPaymentRequest(prepareOnchainPaymentRequest: val)
                list.append(prepareOnchainPaymentRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PrepareOnchainPaymentRequest"))
            }
        }
        return list
    }

    static func arrayOf(prepareOnchainPaymentRequestList: [PrepareOnchainPaymentRequest]) -> [Any] {
        return prepareOnchainPaymentRequestList.map { v -> [String: Any?] in return dictionaryOf(prepareOnchainPaymentRequest: v) }
    }

    static func asPrepareOnchainPaymentResponse(prepareOnchainPaymentResponse: [String: Any?]) throws -> PrepareOnchainPaymentResponse {
        guard let feesHash = prepareOnchainPaymentResponse["feesHash"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feesHash", typeName: "PrepareOnchainPaymentResponse"))
        }
        guard let feesPercentage = prepareOnchainPaymentResponse["feesPercentage"] as? Double else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feesPercentage", typeName: "PrepareOnchainPaymentResponse"))
        }
        guard let feesLockup = prepareOnchainPaymentResponse["feesLockup"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feesLockup", typeName: "PrepareOnchainPaymentResponse"))
        }
        guard let feesClaim = prepareOnchainPaymentResponse["feesClaim"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feesClaim", typeName: "PrepareOnchainPaymentResponse"))
        }
        guard let senderAmountSat = prepareOnchainPaymentResponse["senderAmountSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "senderAmountSat", typeName: "PrepareOnchainPaymentResponse"))
        }
        guard let recipientAmountSat = prepareOnchainPaymentResponse["recipientAmountSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "recipientAmountSat", typeName: "PrepareOnchainPaymentResponse"))
        }
        guard let totalFees = prepareOnchainPaymentResponse["totalFees"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "totalFees", typeName: "PrepareOnchainPaymentResponse"))
        }

        return PrepareOnchainPaymentResponse(
            feesHash: feesHash,
            feesPercentage: feesPercentage,
            feesLockup: feesLockup,
            feesClaim: feesClaim,
            senderAmountSat: senderAmountSat,
            recipientAmountSat: recipientAmountSat,
            totalFees: totalFees
        )
    }

    static func dictionaryOf(prepareOnchainPaymentResponse: PrepareOnchainPaymentResponse) -> [String: Any?] {
        return [
            "feesHash": prepareOnchainPaymentResponse.feesHash,
            "feesPercentage": prepareOnchainPaymentResponse.feesPercentage,
            "feesLockup": prepareOnchainPaymentResponse.feesLockup,
            "feesClaim": prepareOnchainPaymentResponse.feesClaim,
            "senderAmountSat": prepareOnchainPaymentResponse.senderAmountSat,
            "recipientAmountSat": prepareOnchainPaymentResponse.recipientAmountSat,
            "totalFees": prepareOnchainPaymentResponse.totalFees,
        ]
    }

    static func asPrepareOnchainPaymentResponseList(arr: [Any]) throws -> [PrepareOnchainPaymentResponse] {
        var list = [PrepareOnchainPaymentResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var prepareOnchainPaymentResponse = try asPrepareOnchainPaymentResponse(prepareOnchainPaymentResponse: val)
                list.append(prepareOnchainPaymentResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PrepareOnchainPaymentResponse"))
            }
        }
        return list
    }

    static func arrayOf(prepareOnchainPaymentResponseList: [PrepareOnchainPaymentResponse]) -> [Any] {
        return prepareOnchainPaymentResponseList.map { v -> [String: Any?] in return dictionaryOf(prepareOnchainPaymentResponse: v) }
    }

    static func asPrepareRedeemOnchainFundsRequest(prepareRedeemOnchainFundsRequest: [String: Any?]) throws -> PrepareRedeemOnchainFundsRequest {
        guard let toAddress = prepareRedeemOnchainFundsRequest["toAddress"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "toAddress", typeName: "PrepareRedeemOnchainFundsRequest"))
        }
        guard let satPerVbyte = prepareRedeemOnchainFundsRequest["satPerVbyte"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "satPerVbyte", typeName: "PrepareRedeemOnchainFundsRequest"))
        }

        return PrepareRedeemOnchainFundsRequest(
            toAddress: toAddress,
            satPerVbyte: satPerVbyte
        )
    }

    static func dictionaryOf(prepareRedeemOnchainFundsRequest: PrepareRedeemOnchainFundsRequest) -> [String: Any?] {
        return [
            "toAddress": prepareRedeemOnchainFundsRequest.toAddress,
            "satPerVbyte": prepareRedeemOnchainFundsRequest.satPerVbyte,
        ]
    }

    static func asPrepareRedeemOnchainFundsRequestList(arr: [Any]) throws -> [PrepareRedeemOnchainFundsRequest] {
        var list = [PrepareRedeemOnchainFundsRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var prepareRedeemOnchainFundsRequest = try asPrepareRedeemOnchainFundsRequest(prepareRedeemOnchainFundsRequest: val)
                list.append(prepareRedeemOnchainFundsRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PrepareRedeemOnchainFundsRequest"))
            }
        }
        return list
    }

    static func arrayOf(prepareRedeemOnchainFundsRequestList: [PrepareRedeemOnchainFundsRequest]) -> [Any] {
        return prepareRedeemOnchainFundsRequestList.map { v -> [String: Any?] in return dictionaryOf(prepareRedeemOnchainFundsRequest: v) }
    }

    static func asPrepareRedeemOnchainFundsResponse(prepareRedeemOnchainFundsResponse: [String: Any?]) throws -> PrepareRedeemOnchainFundsResponse {
        guard let txWeight = prepareRedeemOnchainFundsResponse["txWeight"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "txWeight", typeName: "PrepareRedeemOnchainFundsResponse"))
        }
        guard let txFeeSat = prepareRedeemOnchainFundsResponse["txFeeSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "txFeeSat", typeName: "PrepareRedeemOnchainFundsResponse"))
        }

        return PrepareRedeemOnchainFundsResponse(
            txWeight: txWeight,
            txFeeSat: txFeeSat
        )
    }

    static func dictionaryOf(prepareRedeemOnchainFundsResponse: PrepareRedeemOnchainFundsResponse) -> [String: Any?] {
        return [
            "txWeight": prepareRedeemOnchainFundsResponse.txWeight,
            "txFeeSat": prepareRedeemOnchainFundsResponse.txFeeSat,
        ]
    }

    static func asPrepareRedeemOnchainFundsResponseList(arr: [Any]) throws -> [PrepareRedeemOnchainFundsResponse] {
        var list = [PrepareRedeemOnchainFundsResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var prepareRedeemOnchainFundsResponse = try asPrepareRedeemOnchainFundsResponse(prepareRedeemOnchainFundsResponse: val)
                list.append(prepareRedeemOnchainFundsResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PrepareRedeemOnchainFundsResponse"))
            }
        }
        return list
    }

    static func arrayOf(prepareRedeemOnchainFundsResponseList: [PrepareRedeemOnchainFundsResponse]) -> [Any] {
        return prepareRedeemOnchainFundsResponseList.map { v -> [String: Any?] in return dictionaryOf(prepareRedeemOnchainFundsResponse: v) }
    }

    static func asPrepareRefundRequest(prepareRefundRequest: [String: Any?]) throws -> PrepareRefundRequest {
        guard let swapAddress = prepareRefundRequest["swapAddress"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "swapAddress", typeName: "PrepareRefundRequest"))
        }
        guard let toAddress = prepareRefundRequest["toAddress"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "toAddress", typeName: "PrepareRefundRequest"))
        }
        guard let satPerVbyte = prepareRefundRequest["satPerVbyte"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "satPerVbyte", typeName: "PrepareRefundRequest"))
        }

        return PrepareRefundRequest(
            swapAddress: swapAddress,
            toAddress: toAddress,
            satPerVbyte: satPerVbyte
        )
    }

    static func dictionaryOf(prepareRefundRequest: PrepareRefundRequest) -> [String: Any?] {
        return [
            "swapAddress": prepareRefundRequest.swapAddress,
            "toAddress": prepareRefundRequest.toAddress,
            "satPerVbyte": prepareRefundRequest.satPerVbyte,
        ]
    }

    static func asPrepareRefundRequestList(arr: [Any]) throws -> [PrepareRefundRequest] {
        var list = [PrepareRefundRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var prepareRefundRequest = try asPrepareRefundRequest(prepareRefundRequest: val)
                list.append(prepareRefundRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PrepareRefundRequest"))
            }
        }
        return list
    }

    static func arrayOf(prepareRefundRequestList: [PrepareRefundRequest]) -> [Any] {
        return prepareRefundRequestList.map { v -> [String: Any?] in return dictionaryOf(prepareRefundRequest: v) }
    }

    static func asPrepareRefundResponse(prepareRefundResponse: [String: Any?]) throws -> PrepareRefundResponse {
        guard let refundTxWeight = prepareRefundResponse["refundTxWeight"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "refundTxWeight", typeName: "PrepareRefundResponse"))
        }
        guard let refundTxFeeSat = prepareRefundResponse["refundTxFeeSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "refundTxFeeSat", typeName: "PrepareRefundResponse"))
        }

        return PrepareRefundResponse(
            refundTxWeight: refundTxWeight,
            refundTxFeeSat: refundTxFeeSat
        )
    }

    static func dictionaryOf(prepareRefundResponse: PrepareRefundResponse) -> [String: Any?] {
        return [
            "refundTxWeight": prepareRefundResponse.refundTxWeight,
            "refundTxFeeSat": prepareRefundResponse.refundTxFeeSat,
        ]
    }

    static func asPrepareRefundResponseList(arr: [Any]) throws -> [PrepareRefundResponse] {
        var list = [PrepareRefundResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var prepareRefundResponse = try asPrepareRefundResponse(prepareRefundResponse: val)
                list.append(prepareRefundResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PrepareRefundResponse"))
            }
        }
        return list
    }

    static func arrayOf(prepareRefundResponseList: [PrepareRefundResponse]) -> [Any] {
        return prepareRefundResponseList.map { v -> [String: Any?] in return dictionaryOf(prepareRefundResponse: v) }
    }

    static func asRate(rate: [String: Any?]) throws -> Rate {
        guard let coin = rate["coin"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "coin", typeName: "Rate"))
        }
        guard let value = rate["value"] as? Double else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "value", typeName: "Rate"))
        }

        return Rate(
            coin: coin,
            value: value
        )
    }

    static func dictionaryOf(rate: Rate) -> [String: Any?] {
        return [
            "coin": rate.coin,
            "value": rate.value,
        ]
    }

    static func asRateList(arr: [Any]) throws -> [Rate] {
        var list = [Rate]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var rate = try asRate(rate: val)
                list.append(rate)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "Rate"))
            }
        }
        return list
    }

    static func arrayOf(rateList: [Rate]) -> [Any] {
        return rateList.map { v -> [String: Any?] in return dictionaryOf(rate: v) }
    }

    static func asReceiveOnchainRequest(receiveOnchainRequest: [String: Any?]) throws -> ReceiveOnchainRequest {
        var openingFeeParams: OpeningFeeParams?
        if let openingFeeParamsTmp = receiveOnchainRequest["openingFeeParams"] as? [String: Any?] {
            openingFeeParams = try asOpeningFeeParams(openingFeeParams: openingFeeParamsTmp)
        }

        return ReceiveOnchainRequest(
            openingFeeParams: openingFeeParams)
    }

    static func dictionaryOf(receiveOnchainRequest: ReceiveOnchainRequest) -> [String: Any?] {
        return [
            "openingFeeParams": receiveOnchainRequest.openingFeeParams == nil ? nil : dictionaryOf(openingFeeParams: receiveOnchainRequest.openingFeeParams!),
        ]
    }

    static func asReceiveOnchainRequestList(arr: [Any]) throws -> [ReceiveOnchainRequest] {
        var list = [ReceiveOnchainRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var receiveOnchainRequest = try asReceiveOnchainRequest(receiveOnchainRequest: val)
                list.append(receiveOnchainRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ReceiveOnchainRequest"))
            }
        }
        return list
    }

    static func arrayOf(receiveOnchainRequestList: [ReceiveOnchainRequest]) -> [Any] {
        return receiveOnchainRequestList.map { v -> [String: Any?] in return dictionaryOf(receiveOnchainRequest: v) }
    }

    static func asReceivePaymentRequest(receivePaymentRequest: [String: Any?]) throws -> ReceivePaymentRequest {
        guard let amountMsat = receivePaymentRequest["amountMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "amountMsat", typeName: "ReceivePaymentRequest"))
        }
        guard let description = receivePaymentRequest["description"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "description", typeName: "ReceivePaymentRequest"))
        }
        var preimage: [UInt8]?
        if hasNonNilKey(data: receivePaymentRequest, key: "preimage") {
            guard let preimageTmp = receivePaymentRequest["preimage"] as? [UInt8] else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "preimage"))
            }
            preimage = preimageTmp
        }
        var openingFeeParams: OpeningFeeParams?
        if let openingFeeParamsTmp = receivePaymentRequest["openingFeeParams"] as? [String: Any?] {
            openingFeeParams = try asOpeningFeeParams(openingFeeParams: openingFeeParamsTmp)
        }

        var useDescriptionHash: Bool?
        if hasNonNilKey(data: receivePaymentRequest, key: "useDescriptionHash") {
            guard let useDescriptionHashTmp = receivePaymentRequest["useDescriptionHash"] as? Bool else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "useDescriptionHash"))
            }
            useDescriptionHash = useDescriptionHashTmp
        }
        var expiry: UInt32?
        if hasNonNilKey(data: receivePaymentRequest, key: "expiry") {
            guard let expiryTmp = receivePaymentRequest["expiry"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "expiry"))
            }
            expiry = expiryTmp
        }
        var cltv: UInt32?
        if hasNonNilKey(data: receivePaymentRequest, key: "cltv") {
            guard let cltvTmp = receivePaymentRequest["cltv"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "cltv"))
            }
            cltv = cltvTmp
        }

        return ReceivePaymentRequest(
            amountMsat: amountMsat,
            description: description,
            preimage: preimage,
            openingFeeParams: openingFeeParams,
            useDescriptionHash: useDescriptionHash,
            expiry: expiry,
            cltv: cltv
        )
    }

    static func dictionaryOf(receivePaymentRequest: ReceivePaymentRequest) -> [String: Any?] {
        return [
            "amountMsat": receivePaymentRequest.amountMsat,
            "description": receivePaymentRequest.description,
            "preimage": receivePaymentRequest.preimage == nil ? nil : receivePaymentRequest.preimage,
            "openingFeeParams": receivePaymentRequest.openingFeeParams == nil ? nil : dictionaryOf(openingFeeParams: receivePaymentRequest.openingFeeParams!),
            "useDescriptionHash": receivePaymentRequest.useDescriptionHash == nil ? nil : receivePaymentRequest.useDescriptionHash,
            "expiry": receivePaymentRequest.expiry == nil ? nil : receivePaymentRequest.expiry,
            "cltv": receivePaymentRequest.cltv == nil ? nil : receivePaymentRequest.cltv,
        ]
    }

    static func asReceivePaymentRequestList(arr: [Any]) throws -> [ReceivePaymentRequest] {
        var list = [ReceivePaymentRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var receivePaymentRequest = try asReceivePaymentRequest(receivePaymentRequest: val)
                list.append(receivePaymentRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ReceivePaymentRequest"))
            }
        }
        return list
    }

    static func arrayOf(receivePaymentRequestList: [ReceivePaymentRequest]) -> [Any] {
        return receivePaymentRequestList.map { v -> [String: Any?] in return dictionaryOf(receivePaymentRequest: v) }
    }

    static func asReceivePaymentResponse(receivePaymentResponse: [String: Any?]) throws -> ReceivePaymentResponse {
        guard let lnInvoiceTmp = receivePaymentResponse["lnInvoice"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "lnInvoice", typeName: "ReceivePaymentResponse"))
        }
        let lnInvoice = try asLnInvoice(lnInvoice: lnInvoiceTmp)

        var openingFeeParams: OpeningFeeParams?
        if let openingFeeParamsTmp = receivePaymentResponse["openingFeeParams"] as? [String: Any?] {
            openingFeeParams = try asOpeningFeeParams(openingFeeParams: openingFeeParamsTmp)
        }

        var openingFeeMsat: UInt64?
        if hasNonNilKey(data: receivePaymentResponse, key: "openingFeeMsat") {
            guard let openingFeeMsatTmp = receivePaymentResponse["openingFeeMsat"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "openingFeeMsat"))
            }
            openingFeeMsat = openingFeeMsatTmp
        }

        return ReceivePaymentResponse(
            lnInvoice: lnInvoice,
            openingFeeParams: openingFeeParams,
            openingFeeMsat: openingFeeMsat
        )
    }

    static func dictionaryOf(receivePaymentResponse: ReceivePaymentResponse) -> [String: Any?] {
        return [
            "lnInvoice": dictionaryOf(lnInvoice: receivePaymentResponse.lnInvoice),
            "openingFeeParams": receivePaymentResponse.openingFeeParams == nil ? nil : dictionaryOf(openingFeeParams: receivePaymentResponse.openingFeeParams!),
            "openingFeeMsat": receivePaymentResponse.openingFeeMsat == nil ? nil : receivePaymentResponse.openingFeeMsat,
        ]
    }

    static func asReceivePaymentResponseList(arr: [Any]) throws -> [ReceivePaymentResponse] {
        var list = [ReceivePaymentResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var receivePaymentResponse = try asReceivePaymentResponse(receivePaymentResponse: val)
                list.append(receivePaymentResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ReceivePaymentResponse"))
            }
        }
        return list
    }

    static func arrayOf(receivePaymentResponseList: [ReceivePaymentResponse]) -> [Any] {
        return receivePaymentResponseList.map { v -> [String: Any?] in return dictionaryOf(receivePaymentResponse: v) }
    }

    static func asRecommendedFees(recommendedFees: [String: Any?]) throws -> RecommendedFees {
        guard let fastestFee = recommendedFees["fastestFee"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "fastestFee", typeName: "RecommendedFees"))
        }
        guard let halfHourFee = recommendedFees["halfHourFee"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "halfHourFee", typeName: "RecommendedFees"))
        }
        guard let hourFee = recommendedFees["hourFee"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "hourFee", typeName: "RecommendedFees"))
        }
        guard let economyFee = recommendedFees["economyFee"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "economyFee", typeName: "RecommendedFees"))
        }
        guard let minimumFee = recommendedFees["minimumFee"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "minimumFee", typeName: "RecommendedFees"))
        }

        return RecommendedFees(
            fastestFee: fastestFee,
            halfHourFee: halfHourFee,
            hourFee: hourFee,
            economyFee: economyFee,
            minimumFee: minimumFee
        )
    }

    static func dictionaryOf(recommendedFees: RecommendedFees) -> [String: Any?] {
        return [
            "fastestFee": recommendedFees.fastestFee,
            "halfHourFee": recommendedFees.halfHourFee,
            "hourFee": recommendedFees.hourFee,
            "economyFee": recommendedFees.economyFee,
            "minimumFee": recommendedFees.minimumFee,
        ]
    }

    static func asRecommendedFeesList(arr: [Any]) throws -> [RecommendedFees] {
        var list = [RecommendedFees]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var recommendedFees = try asRecommendedFees(recommendedFees: val)
                list.append(recommendedFees)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "RecommendedFees"))
            }
        }
        return list
    }

    static func arrayOf(recommendedFeesList: [RecommendedFees]) -> [Any] {
        return recommendedFeesList.map { v -> [String: Any?] in return dictionaryOf(recommendedFees: v) }
    }

    static func asRedeemOnchainFundsRequest(redeemOnchainFundsRequest: [String: Any?]) throws -> RedeemOnchainFundsRequest {
        guard let toAddress = redeemOnchainFundsRequest["toAddress"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "toAddress", typeName: "RedeemOnchainFundsRequest"))
        }
        guard let satPerVbyte = redeemOnchainFundsRequest["satPerVbyte"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "satPerVbyte", typeName: "RedeemOnchainFundsRequest"))
        }

        return RedeemOnchainFundsRequest(
            toAddress: toAddress,
            satPerVbyte: satPerVbyte
        )
    }

    static func dictionaryOf(redeemOnchainFundsRequest: RedeemOnchainFundsRequest) -> [String: Any?] {
        return [
            "toAddress": redeemOnchainFundsRequest.toAddress,
            "satPerVbyte": redeemOnchainFundsRequest.satPerVbyte,
        ]
    }

    static func asRedeemOnchainFundsRequestList(arr: [Any]) throws -> [RedeemOnchainFundsRequest] {
        var list = [RedeemOnchainFundsRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var redeemOnchainFundsRequest = try asRedeemOnchainFundsRequest(redeemOnchainFundsRequest: val)
                list.append(redeemOnchainFundsRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "RedeemOnchainFundsRequest"))
            }
        }
        return list
    }

    static func arrayOf(redeemOnchainFundsRequestList: [RedeemOnchainFundsRequest]) -> [Any] {
        return redeemOnchainFundsRequestList.map { v -> [String: Any?] in return dictionaryOf(redeemOnchainFundsRequest: v) }
    }

    static func asRedeemOnchainFundsResponse(redeemOnchainFundsResponse: [String: Any?]) throws -> RedeemOnchainFundsResponse {
        guard let txid = redeemOnchainFundsResponse["txid"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "txid", typeName: "RedeemOnchainFundsResponse"))
        }

        return RedeemOnchainFundsResponse(
            txid: txid)
    }

    static func dictionaryOf(redeemOnchainFundsResponse: RedeemOnchainFundsResponse) -> [String: Any?] {
        return [
            "txid": redeemOnchainFundsResponse.txid,
        ]
    }

    static func asRedeemOnchainFundsResponseList(arr: [Any]) throws -> [RedeemOnchainFundsResponse] {
        var list = [RedeemOnchainFundsResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var redeemOnchainFundsResponse = try asRedeemOnchainFundsResponse(redeemOnchainFundsResponse: val)
                list.append(redeemOnchainFundsResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "RedeemOnchainFundsResponse"))
            }
        }
        return list
    }

    static func arrayOf(redeemOnchainFundsResponseList: [RedeemOnchainFundsResponse]) -> [Any] {
        return redeemOnchainFundsResponseList.map { v -> [String: Any?] in return dictionaryOf(redeemOnchainFundsResponse: v) }
    }

    static func asRefundRequest(refundRequest: [String: Any?]) throws -> RefundRequest {
        guard let swapAddress = refundRequest["swapAddress"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "swapAddress", typeName: "RefundRequest"))
        }
        guard let toAddress = refundRequest["toAddress"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "toAddress", typeName: "RefundRequest"))
        }
        guard let satPerVbyte = refundRequest["satPerVbyte"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "satPerVbyte", typeName: "RefundRequest"))
        }

        return RefundRequest(
            swapAddress: swapAddress,
            toAddress: toAddress,
            satPerVbyte: satPerVbyte
        )
    }

    static func dictionaryOf(refundRequest: RefundRequest) -> [String: Any?] {
        return [
            "swapAddress": refundRequest.swapAddress,
            "toAddress": refundRequest.toAddress,
            "satPerVbyte": refundRequest.satPerVbyte,
        ]
    }

    static func asRefundRequestList(arr: [Any]) throws -> [RefundRequest] {
        var list = [RefundRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var refundRequest = try asRefundRequest(refundRequest: val)
                list.append(refundRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "RefundRequest"))
            }
        }
        return list
    }

    static func arrayOf(refundRequestList: [RefundRequest]) -> [Any] {
        return refundRequestList.map { v -> [String: Any?] in return dictionaryOf(refundRequest: v) }
    }

    static func asRefundResponse(refundResponse: [String: Any?]) throws -> RefundResponse {
        guard let refundTxId = refundResponse["refundTxId"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "refundTxId", typeName: "RefundResponse"))
        }

        return RefundResponse(
            refundTxId: refundTxId)
    }

    static func dictionaryOf(refundResponse: RefundResponse) -> [String: Any?] {
        return [
            "refundTxId": refundResponse.refundTxId,
        ]
    }

    static func asRefundResponseList(arr: [Any]) throws -> [RefundResponse] {
        var list = [RefundResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var refundResponse = try asRefundResponse(refundResponse: val)
                list.append(refundResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "RefundResponse"))
            }
        }
        return list
    }

    static func arrayOf(refundResponseList: [RefundResponse]) -> [Any] {
        return refundResponseList.map { v -> [String: Any?] in return dictionaryOf(refundResponse: v) }
    }

    static func asReportPaymentFailureDetails(reportPaymentFailureDetails: [String: Any?]) throws -> ReportPaymentFailureDetails {
        guard let paymentHash = reportPaymentFailureDetails["paymentHash"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentHash", typeName: "ReportPaymentFailureDetails"))
        }
        var comment: String?
        if hasNonNilKey(data: reportPaymentFailureDetails, key: "comment") {
            guard let commentTmp = reportPaymentFailureDetails["comment"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "comment"))
            }
            comment = commentTmp
        }

        return ReportPaymentFailureDetails(
            paymentHash: paymentHash,
            comment: comment
        )
    }

    static func dictionaryOf(reportPaymentFailureDetails: ReportPaymentFailureDetails) -> [String: Any?] {
        return [
            "paymentHash": reportPaymentFailureDetails.paymentHash,
            "comment": reportPaymentFailureDetails.comment == nil ? nil : reportPaymentFailureDetails.comment,
        ]
    }

    static func asReportPaymentFailureDetailsList(arr: [Any]) throws -> [ReportPaymentFailureDetails] {
        var list = [ReportPaymentFailureDetails]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var reportPaymentFailureDetails = try asReportPaymentFailureDetails(reportPaymentFailureDetails: val)
                list.append(reportPaymentFailureDetails)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ReportPaymentFailureDetails"))
            }
        }
        return list
    }

    static func arrayOf(reportPaymentFailureDetailsList: [ReportPaymentFailureDetails]) -> [Any] {
        return reportPaymentFailureDetailsList.map { v -> [String: Any?] in return dictionaryOf(reportPaymentFailureDetails: v) }
    }

    static func asReverseSwapFeesRequest(reverseSwapFeesRequest: [String: Any?]) throws -> ReverseSwapFeesRequest {
        var sendAmountSat: UInt64?
        if hasNonNilKey(data: reverseSwapFeesRequest, key: "sendAmountSat") {
            guard let sendAmountSatTmp = reverseSwapFeesRequest["sendAmountSat"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "sendAmountSat"))
            }
            sendAmountSat = sendAmountSatTmp
        }
        var claimTxFeerate: UInt32?
        if hasNonNilKey(data: reverseSwapFeesRequest, key: "claimTxFeerate") {
            guard let claimTxFeerateTmp = reverseSwapFeesRequest["claimTxFeerate"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "claimTxFeerate"))
            }
            claimTxFeerate = claimTxFeerateTmp
        }

        return ReverseSwapFeesRequest(
            sendAmountSat: sendAmountSat,
            claimTxFeerate: claimTxFeerate
        )
    }

    static func dictionaryOf(reverseSwapFeesRequest: ReverseSwapFeesRequest) -> [String: Any?] {
        return [
            "sendAmountSat": reverseSwapFeesRequest.sendAmountSat == nil ? nil : reverseSwapFeesRequest.sendAmountSat,
            "claimTxFeerate": reverseSwapFeesRequest.claimTxFeerate == nil ? nil : reverseSwapFeesRequest.claimTxFeerate,
        ]
    }

    static func asReverseSwapFeesRequestList(arr: [Any]) throws -> [ReverseSwapFeesRequest] {
        var list = [ReverseSwapFeesRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var reverseSwapFeesRequest = try asReverseSwapFeesRequest(reverseSwapFeesRequest: val)
                list.append(reverseSwapFeesRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ReverseSwapFeesRequest"))
            }
        }
        return list
    }

    static func arrayOf(reverseSwapFeesRequestList: [ReverseSwapFeesRequest]) -> [Any] {
        return reverseSwapFeesRequestList.map { v -> [String: Any?] in return dictionaryOf(reverseSwapFeesRequest: v) }
    }

    static func asReverseSwapInfo(reverseSwapInfo: [String: Any?]) throws -> ReverseSwapInfo {
        guard let id = reverseSwapInfo["id"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "id", typeName: "ReverseSwapInfo"))
        }
        guard let claimPubkey = reverseSwapInfo["claimPubkey"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "claimPubkey", typeName: "ReverseSwapInfo"))
        }
        var lockupTxid: String?
        if hasNonNilKey(data: reverseSwapInfo, key: "lockupTxid") {
            guard let lockupTxidTmp = reverseSwapInfo["lockupTxid"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "lockupTxid"))
            }
            lockupTxid = lockupTxidTmp
        }
        var claimTxid: String?
        if hasNonNilKey(data: reverseSwapInfo, key: "claimTxid") {
            guard let claimTxidTmp = reverseSwapInfo["claimTxid"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "claimTxid"))
            }
            claimTxid = claimTxidTmp
        }
        guard let onchainAmountSat = reverseSwapInfo["onchainAmountSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "onchainAmountSat", typeName: "ReverseSwapInfo"))
        }
        guard let statusTmp = reverseSwapInfo["status"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "status", typeName: "ReverseSwapInfo"))
        }
        let status = try asReverseSwapStatus(reverseSwapStatus: statusTmp)

        return ReverseSwapInfo(
            id: id,
            claimPubkey: claimPubkey,
            lockupTxid: lockupTxid,
            claimTxid: claimTxid,
            onchainAmountSat: onchainAmountSat,
            status: status
        )
    }

    static func dictionaryOf(reverseSwapInfo: ReverseSwapInfo) -> [String: Any?] {
        return [
            "id": reverseSwapInfo.id,
            "claimPubkey": reverseSwapInfo.claimPubkey,
            "lockupTxid": reverseSwapInfo.lockupTxid == nil ? nil : reverseSwapInfo.lockupTxid,
            "claimTxid": reverseSwapInfo.claimTxid == nil ? nil : reverseSwapInfo.claimTxid,
            "onchainAmountSat": reverseSwapInfo.onchainAmountSat,
            "status": valueOf(reverseSwapStatus: reverseSwapInfo.status),
        ]
    }

    static func asReverseSwapInfoList(arr: [Any]) throws -> [ReverseSwapInfo] {
        var list = [ReverseSwapInfo]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var reverseSwapInfo = try asReverseSwapInfo(reverseSwapInfo: val)
                list.append(reverseSwapInfo)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ReverseSwapInfo"))
            }
        }
        return list
    }

    static func arrayOf(reverseSwapInfoList: [ReverseSwapInfo]) -> [Any] {
        return reverseSwapInfoList.map { v -> [String: Any?] in return dictionaryOf(reverseSwapInfo: v) }
    }

    static func asReverseSwapPairInfo(reverseSwapPairInfo: [String: Any?]) throws -> ReverseSwapPairInfo {
        guard let min = reverseSwapPairInfo["min"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "min", typeName: "ReverseSwapPairInfo"))
        }
        guard let max = reverseSwapPairInfo["max"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "max", typeName: "ReverseSwapPairInfo"))
        }
        guard let feesHash = reverseSwapPairInfo["feesHash"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feesHash", typeName: "ReverseSwapPairInfo"))
        }
        guard let feesPercentage = reverseSwapPairInfo["feesPercentage"] as? Double else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feesPercentage", typeName: "ReverseSwapPairInfo"))
        }
        guard let feesLockup = reverseSwapPairInfo["feesLockup"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feesLockup", typeName: "ReverseSwapPairInfo"))
        }
        guard let feesClaim = reverseSwapPairInfo["feesClaim"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feesClaim", typeName: "ReverseSwapPairInfo"))
        }
        var totalFees: UInt64?
        if hasNonNilKey(data: reverseSwapPairInfo, key: "totalFees") {
            guard let totalFeesTmp = reverseSwapPairInfo["totalFees"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "totalFees"))
            }
            totalFees = totalFeesTmp
        }

        return ReverseSwapPairInfo(
            min: min,
            max: max,
            feesHash: feesHash,
            feesPercentage: feesPercentage,
            feesLockup: feesLockup,
            feesClaim: feesClaim,
            totalFees: totalFees
        )
    }

    static func dictionaryOf(reverseSwapPairInfo: ReverseSwapPairInfo) -> [String: Any?] {
        return [
            "min": reverseSwapPairInfo.min,
            "max": reverseSwapPairInfo.max,
            "feesHash": reverseSwapPairInfo.feesHash,
            "feesPercentage": reverseSwapPairInfo.feesPercentage,
            "feesLockup": reverseSwapPairInfo.feesLockup,
            "feesClaim": reverseSwapPairInfo.feesClaim,
            "totalFees": reverseSwapPairInfo.totalFees == nil ? nil : reverseSwapPairInfo.totalFees,
        ]
    }

    static func asReverseSwapPairInfoList(arr: [Any]) throws -> [ReverseSwapPairInfo] {
        var list = [ReverseSwapPairInfo]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var reverseSwapPairInfo = try asReverseSwapPairInfo(reverseSwapPairInfo: val)
                list.append(reverseSwapPairInfo)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ReverseSwapPairInfo"))
            }
        }
        return list
    }

    static func arrayOf(reverseSwapPairInfoList: [ReverseSwapPairInfo]) -> [Any] {
        return reverseSwapPairInfoList.map { v -> [String: Any?] in return dictionaryOf(reverseSwapPairInfo: v) }
    }

    static func asRouteHint(routeHint: [String: Any?]) throws -> RouteHint {
        guard let hopsTmp = routeHint["hops"] as? [[String: Any?]] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "hops", typeName: "RouteHint"))
        }
        let hops = try asRouteHintHopList(arr: hopsTmp)

        return RouteHint(
            hops: hops)
    }

    static func dictionaryOf(routeHint: RouteHint) -> [String: Any?] {
        return [
            "hops": arrayOf(routeHintHopList: routeHint.hops),
        ]
    }

    static func asRouteHintList(arr: [Any]) throws -> [RouteHint] {
        var list = [RouteHint]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var routeHint = try asRouteHint(routeHint: val)
                list.append(routeHint)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "RouteHint"))
            }
        }
        return list
    }

    static func arrayOf(routeHintList: [RouteHint]) -> [Any] {
        return routeHintList.map { v -> [String: Any?] in return dictionaryOf(routeHint: v) }
    }

    static func asRouteHintHop(routeHintHop: [String: Any?]) throws -> RouteHintHop {
        guard let srcNodeId = routeHintHop["srcNodeId"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "srcNodeId", typeName: "RouteHintHop"))
        }
        guard let shortChannelId = routeHintHop["shortChannelId"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "shortChannelId", typeName: "RouteHintHop"))
        }
        guard let feesBaseMsat = routeHintHop["feesBaseMsat"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feesBaseMsat", typeName: "RouteHintHop"))
        }
        guard let feesProportionalMillionths = routeHintHop["feesProportionalMillionths"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "feesProportionalMillionths", typeName: "RouteHintHop"))
        }
        guard let cltvExpiryDelta = routeHintHop["cltvExpiryDelta"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "cltvExpiryDelta", typeName: "RouteHintHop"))
        }
        var htlcMinimumMsat: UInt64?
        if hasNonNilKey(data: routeHintHop, key: "htlcMinimumMsat") {
            guard let htlcMinimumMsatTmp = routeHintHop["htlcMinimumMsat"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "htlcMinimumMsat"))
            }
            htlcMinimumMsat = htlcMinimumMsatTmp
        }
        var htlcMaximumMsat: UInt64?
        if hasNonNilKey(data: routeHintHop, key: "htlcMaximumMsat") {
            guard let htlcMaximumMsatTmp = routeHintHop["htlcMaximumMsat"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "htlcMaximumMsat"))
            }
            htlcMaximumMsat = htlcMaximumMsatTmp
        }

        return RouteHintHop(
            srcNodeId: srcNodeId,
            shortChannelId: shortChannelId,
            feesBaseMsat: feesBaseMsat,
            feesProportionalMillionths: feesProportionalMillionths,
            cltvExpiryDelta: cltvExpiryDelta,
            htlcMinimumMsat: htlcMinimumMsat,
            htlcMaximumMsat: htlcMaximumMsat
        )
    }

    static func dictionaryOf(routeHintHop: RouteHintHop) -> [String: Any?] {
        return [
            "srcNodeId": routeHintHop.srcNodeId,
            "shortChannelId": routeHintHop.shortChannelId,
            "feesBaseMsat": routeHintHop.feesBaseMsat,
            "feesProportionalMillionths": routeHintHop.feesProportionalMillionths,
            "cltvExpiryDelta": routeHintHop.cltvExpiryDelta,
            "htlcMinimumMsat": routeHintHop.htlcMinimumMsat == nil ? nil : routeHintHop.htlcMinimumMsat,
            "htlcMaximumMsat": routeHintHop.htlcMaximumMsat == nil ? nil : routeHintHop.htlcMaximumMsat,
        ]
    }

    static func asRouteHintHopList(arr: [Any]) throws -> [RouteHintHop] {
        var list = [RouteHintHop]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var routeHintHop = try asRouteHintHop(routeHintHop: val)
                list.append(routeHintHop)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "RouteHintHop"))
            }
        }
        return list
    }

    static func arrayOf(routeHintHopList: [RouteHintHop]) -> [Any] {
        return routeHintHopList.map { v -> [String: Any?] in return dictionaryOf(routeHintHop: v) }
    }

    static func asSendOnchainRequest(sendOnchainRequest: [String: Any?]) throws -> SendOnchainRequest {
        guard let amountSat = sendOnchainRequest["amountSat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "amountSat", typeName: "SendOnchainRequest"))
        }
        guard let onchainRecipientAddress = sendOnchainRequest["onchainRecipientAddress"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "onchainRecipientAddress", typeName: "SendOnchainRequest"))
        }
        guard let pairHash = sendOnchainRequest["pairHash"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "pairHash", typeName: "SendOnchainRequest"))
        }
        guard let satPerVbyte = sendOnchainRequest["satPerVbyte"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "satPerVbyte", typeName: "SendOnchainRequest"))
        }

        return SendOnchainRequest(
            amountSat: amountSat,
            onchainRecipientAddress: onchainRecipientAddress,
            pairHash: pairHash,
            satPerVbyte: satPerVbyte
        )
    }

    static func dictionaryOf(sendOnchainRequest: SendOnchainRequest) -> [String: Any?] {
        return [
            "amountSat": sendOnchainRequest.amountSat,
            "onchainRecipientAddress": sendOnchainRequest.onchainRecipientAddress,
            "pairHash": sendOnchainRequest.pairHash,
            "satPerVbyte": sendOnchainRequest.satPerVbyte,
        ]
    }

    static func asSendOnchainRequestList(arr: [Any]) throws -> [SendOnchainRequest] {
        var list = [SendOnchainRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var sendOnchainRequest = try asSendOnchainRequest(sendOnchainRequest: val)
                list.append(sendOnchainRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SendOnchainRequest"))
            }
        }
        return list
    }

    static func arrayOf(sendOnchainRequestList: [SendOnchainRequest]) -> [Any] {
        return sendOnchainRequestList.map { v -> [String: Any?] in return dictionaryOf(sendOnchainRequest: v) }
    }

    static func asSendOnchainResponse(sendOnchainResponse: [String: Any?]) throws -> SendOnchainResponse {
        guard let reverseSwapInfoTmp = sendOnchainResponse["reverseSwapInfo"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "reverseSwapInfo", typeName: "SendOnchainResponse"))
        }
        let reverseSwapInfo = try asReverseSwapInfo(reverseSwapInfo: reverseSwapInfoTmp)

        return SendOnchainResponse(
            reverseSwapInfo: reverseSwapInfo)
    }

    static func dictionaryOf(sendOnchainResponse: SendOnchainResponse) -> [String: Any?] {
        return [
            "reverseSwapInfo": dictionaryOf(reverseSwapInfo: sendOnchainResponse.reverseSwapInfo),
        ]
    }

    static func asSendOnchainResponseList(arr: [Any]) throws -> [SendOnchainResponse] {
        var list = [SendOnchainResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var sendOnchainResponse = try asSendOnchainResponse(sendOnchainResponse: val)
                list.append(sendOnchainResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SendOnchainResponse"))
            }
        }
        return list
    }

    static func arrayOf(sendOnchainResponseList: [SendOnchainResponse]) -> [Any] {
        return sendOnchainResponseList.map { v -> [String: Any?] in return dictionaryOf(sendOnchainResponse: v) }
    }

    static func asSendPaymentRequest(sendPaymentRequest: [String: Any?]) throws -> SendPaymentRequest {
        guard let bolt11 = sendPaymentRequest["bolt11"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "bolt11", typeName: "SendPaymentRequest"))
        }
        guard let useTrampoline = sendPaymentRequest["useTrampoline"] as? Bool else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "useTrampoline", typeName: "SendPaymentRequest"))
        }
        var amountMsat: UInt64?
        if hasNonNilKey(data: sendPaymentRequest, key: "amountMsat") {
            guard let amountMsatTmp = sendPaymentRequest["amountMsat"] as? UInt64 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "amountMsat"))
            }
            amountMsat = amountMsatTmp
        }
        var label: String?
        if hasNonNilKey(data: sendPaymentRequest, key: "label") {
            guard let labelTmp = sendPaymentRequest["label"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "label"))
            }
            label = labelTmp
        }

        return SendPaymentRequest(
            bolt11: bolt11,
            useTrampoline: useTrampoline,
            amountMsat: amountMsat,
            label: label
        )
    }

    static func dictionaryOf(sendPaymentRequest: SendPaymentRequest) -> [String: Any?] {
        return [
            "bolt11": sendPaymentRequest.bolt11,
            "useTrampoline": sendPaymentRequest.useTrampoline,
            "amountMsat": sendPaymentRequest.amountMsat == nil ? nil : sendPaymentRequest.amountMsat,
            "label": sendPaymentRequest.label == nil ? nil : sendPaymentRequest.label,
        ]
    }

    static func asSendPaymentRequestList(arr: [Any]) throws -> [SendPaymentRequest] {
        var list = [SendPaymentRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var sendPaymentRequest = try asSendPaymentRequest(sendPaymentRequest: val)
                list.append(sendPaymentRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SendPaymentRequest"))
            }
        }
        return list
    }

    static func arrayOf(sendPaymentRequestList: [SendPaymentRequest]) -> [Any] {
        return sendPaymentRequestList.map { v -> [String: Any?] in return dictionaryOf(sendPaymentRequest: v) }
    }

    static func asSendPaymentResponse(sendPaymentResponse: [String: Any?]) throws -> SendPaymentResponse {
        guard let paymentTmp = sendPaymentResponse["payment"] as? [String: Any?] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "payment", typeName: "SendPaymentResponse"))
        }
        let payment = try asPayment(payment: paymentTmp)

        return SendPaymentResponse(
            payment: payment)
    }

    static func dictionaryOf(sendPaymentResponse: SendPaymentResponse) -> [String: Any?] {
        return [
            "payment": dictionaryOf(payment: sendPaymentResponse.payment),
        ]
    }

    static func asSendPaymentResponseList(arr: [Any]) throws -> [SendPaymentResponse] {
        var list = [SendPaymentResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var sendPaymentResponse = try asSendPaymentResponse(sendPaymentResponse: val)
                list.append(sendPaymentResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SendPaymentResponse"))
            }
        }
        return list
    }

    static func arrayOf(sendPaymentResponseList: [SendPaymentResponse]) -> [Any] {
        return sendPaymentResponseList.map { v -> [String: Any?] in return dictionaryOf(sendPaymentResponse: v) }
    }

    static func asSendSpontaneousPaymentRequest(sendSpontaneousPaymentRequest: [String: Any?]) throws -> SendSpontaneousPaymentRequest {
        guard let nodeId = sendSpontaneousPaymentRequest["nodeId"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "nodeId", typeName: "SendSpontaneousPaymentRequest"))
        }
        guard let amountMsat = sendSpontaneousPaymentRequest["amountMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "amountMsat", typeName: "SendSpontaneousPaymentRequest"))
        }
        var extraTlvs: [TlvEntry]?
        if let extraTlvsTmp = sendSpontaneousPaymentRequest["extraTlvs"] as? [[String: Any?]] {
            extraTlvs = try asTlvEntryList(arr: extraTlvsTmp)
        }

        var label: String?
        if hasNonNilKey(data: sendSpontaneousPaymentRequest, key: "label") {
            guard let labelTmp = sendSpontaneousPaymentRequest["label"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "label"))
            }
            label = labelTmp
        }

        return SendSpontaneousPaymentRequest(
            nodeId: nodeId,
            amountMsat: amountMsat,
            extraTlvs: extraTlvs,
            label: label
        )
    }

    static func dictionaryOf(sendSpontaneousPaymentRequest: SendSpontaneousPaymentRequest) -> [String: Any?] {
        return [
            "nodeId": sendSpontaneousPaymentRequest.nodeId,
            "amountMsat": sendSpontaneousPaymentRequest.amountMsat,
            "extraTlvs": sendSpontaneousPaymentRequest.extraTlvs == nil ? nil : arrayOf(tlvEntryList: sendSpontaneousPaymentRequest.extraTlvs!),
            "label": sendSpontaneousPaymentRequest.label == nil ? nil : sendSpontaneousPaymentRequest.label,
        ]
    }

    static func asSendSpontaneousPaymentRequestList(arr: [Any]) throws -> [SendSpontaneousPaymentRequest] {
        var list = [SendSpontaneousPaymentRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var sendSpontaneousPaymentRequest = try asSendSpontaneousPaymentRequest(sendSpontaneousPaymentRequest: val)
                list.append(sendSpontaneousPaymentRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SendSpontaneousPaymentRequest"))
            }
        }
        return list
    }

    static func arrayOf(sendSpontaneousPaymentRequestList: [SendSpontaneousPaymentRequest]) -> [Any] {
        return sendSpontaneousPaymentRequestList.map { v -> [String: Any?] in return dictionaryOf(sendSpontaneousPaymentRequest: v) }
    }

    static func asServiceHealthCheckResponse(serviceHealthCheckResponse: [String: Any?]) throws -> ServiceHealthCheckResponse {
        guard let statusTmp = serviceHealthCheckResponse["status"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "status", typeName: "ServiceHealthCheckResponse"))
        }
        let status = try asHealthCheckStatus(healthCheckStatus: statusTmp)

        return ServiceHealthCheckResponse(
            status: status)
    }

    static func dictionaryOf(serviceHealthCheckResponse: ServiceHealthCheckResponse) -> [String: Any?] {
        return [
            "status": valueOf(healthCheckStatus: serviceHealthCheckResponse.status),
        ]
    }

    static func asServiceHealthCheckResponseList(arr: [Any]) throws -> [ServiceHealthCheckResponse] {
        var list = [ServiceHealthCheckResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var serviceHealthCheckResponse = try asServiceHealthCheckResponse(serviceHealthCheckResponse: val)
                list.append(serviceHealthCheckResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ServiceHealthCheckResponse"))
            }
        }
        return list
    }

    static func arrayOf(serviceHealthCheckResponseList: [ServiceHealthCheckResponse]) -> [Any] {
        return serviceHealthCheckResponseList.map { v -> [String: Any?] in return dictionaryOf(serviceHealthCheckResponse: v) }
    }

    static func asSignMessageRequest(signMessageRequest: [String: Any?]) throws -> SignMessageRequest {
        guard let message = signMessageRequest["message"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "message", typeName: "SignMessageRequest"))
        }

        return SignMessageRequest(
            message: message)
    }

    static func dictionaryOf(signMessageRequest: SignMessageRequest) -> [String: Any?] {
        return [
            "message": signMessageRequest.message,
        ]
    }

    static func asSignMessageRequestList(arr: [Any]) throws -> [SignMessageRequest] {
        var list = [SignMessageRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var signMessageRequest = try asSignMessageRequest(signMessageRequest: val)
                list.append(signMessageRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SignMessageRequest"))
            }
        }
        return list
    }

    static func arrayOf(signMessageRequestList: [SignMessageRequest]) -> [Any] {
        return signMessageRequestList.map { v -> [String: Any?] in return dictionaryOf(signMessageRequest: v) }
    }

    static func asSignMessageResponse(signMessageResponse: [String: Any?]) throws -> SignMessageResponse {
        guard let signature = signMessageResponse["signature"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "signature", typeName: "SignMessageResponse"))
        }

        return SignMessageResponse(
            signature: signature)
    }

    static func dictionaryOf(signMessageResponse: SignMessageResponse) -> [String: Any?] {
        return [
            "signature": signMessageResponse.signature,
        ]
    }

    static func asSignMessageResponseList(arr: [Any]) throws -> [SignMessageResponse] {
        var list = [SignMessageResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var signMessageResponse = try asSignMessageResponse(signMessageResponse: val)
                list.append(signMessageResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SignMessageResponse"))
            }
        }
        return list
    }

    static func arrayOf(signMessageResponseList: [SignMessageResponse]) -> [Any] {
        return signMessageResponseList.map { v -> [String: Any?] in return dictionaryOf(signMessageResponse: v) }
    }

    static func asStaticBackupRequest(staticBackupRequest: [String: Any?]) throws -> StaticBackupRequest {
        guard let workingDir = staticBackupRequest["workingDir"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "workingDir", typeName: "StaticBackupRequest"))
        }

        return StaticBackupRequest(
            workingDir: workingDir)
    }

    static func dictionaryOf(staticBackupRequest: StaticBackupRequest) -> [String: Any?] {
        return [
            "workingDir": staticBackupRequest.workingDir,
        ]
    }

    static func asStaticBackupRequestList(arr: [Any]) throws -> [StaticBackupRequest] {
        var list = [StaticBackupRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var staticBackupRequest = try asStaticBackupRequest(staticBackupRequest: val)
                list.append(staticBackupRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "StaticBackupRequest"))
            }
        }
        return list
    }

    static func arrayOf(staticBackupRequestList: [StaticBackupRequest]) -> [Any] {
        return staticBackupRequestList.map { v -> [String: Any?] in return dictionaryOf(staticBackupRequest: v) }
    }

    static func asStaticBackupResponse(staticBackupResponse: [String: Any?]) throws -> StaticBackupResponse {
        var backup: [String]?
        if hasNonNilKey(data: staticBackupResponse, key: "backup") {
            guard let backupTmp = staticBackupResponse["backup"] as? [String] else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "backup"))
            }
            backup = backupTmp
        }

        return StaticBackupResponse(
            backup: backup)
    }

    static func dictionaryOf(staticBackupResponse: StaticBackupResponse) -> [String: Any?] {
        return [
            "backup": staticBackupResponse.backup == nil ? nil : staticBackupResponse.backup,
        ]
    }

    static func asStaticBackupResponseList(arr: [Any]) throws -> [StaticBackupResponse] {
        var list = [StaticBackupResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var staticBackupResponse = try asStaticBackupResponse(staticBackupResponse: val)
                list.append(staticBackupResponse)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "StaticBackupResponse"))
            }
        }
        return list
    }

    static func arrayOf(staticBackupResponseList: [StaticBackupResponse]) -> [Any] {
        return staticBackupResponseList.map { v -> [String: Any?] in return dictionaryOf(staticBackupResponse: v) }
    }

    static func asSwapInfo(swapInfo: [String: Any?]) throws -> SwapInfo {
        guard let bitcoinAddress = swapInfo["bitcoinAddress"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "bitcoinAddress", typeName: "SwapInfo"))
        }
        guard let createdAt = swapInfo["createdAt"] as? Int64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "createdAt", typeName: "SwapInfo"))
        }
        guard let lockHeight = swapInfo["lockHeight"] as? Int64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "lockHeight", typeName: "SwapInfo"))
        }
        guard let paymentHash = swapInfo["paymentHash"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paymentHash", typeName: "SwapInfo"))
        }
        guard let preimage = swapInfo["preimage"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "preimage", typeName: "SwapInfo"))
        }
        guard let privateKey = swapInfo["privateKey"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "privateKey", typeName: "SwapInfo"))
        }
        guard let publicKey = swapInfo["publicKey"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "publicKey", typeName: "SwapInfo"))
        }
        guard let swapperPublicKey = swapInfo["swapperPublicKey"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "swapperPublicKey", typeName: "SwapInfo"))
        }
        guard let script = swapInfo["script"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "script", typeName: "SwapInfo"))
        }
        var bolt11: String?
        if hasNonNilKey(data: swapInfo, key: "bolt11") {
            guard let bolt11Tmp = swapInfo["bolt11"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "bolt11"))
            }
            bolt11 = bolt11Tmp
        }
        guard let paidMsat = swapInfo["paidMsat"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "paidMsat", typeName: "SwapInfo"))
        }
        guard let unconfirmedSats = swapInfo["unconfirmedSats"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "unconfirmedSats", typeName: "SwapInfo"))
        }
        guard let confirmedSats = swapInfo["confirmedSats"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "confirmedSats", typeName: "SwapInfo"))
        }
        guard let totalIncomingTxs = swapInfo["totalIncomingTxs"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "totalIncomingTxs", typeName: "SwapInfo"))
        }
        guard let statusTmp = swapInfo["status"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "status", typeName: "SwapInfo"))
        }
        let status = try asSwapStatus(swapStatus: statusTmp)

        guard let refundTxIds = swapInfo["refundTxIds"] as? [String] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "refundTxIds", typeName: "SwapInfo"))
        }
        guard let unconfirmedTxIds = swapInfo["unconfirmedTxIds"] as? [String] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "unconfirmedTxIds", typeName: "SwapInfo"))
        }
        guard let confirmedTxIds = swapInfo["confirmedTxIds"] as? [String] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "confirmedTxIds", typeName: "SwapInfo"))
        }
        guard let minAllowedDeposit = swapInfo["minAllowedDeposit"] as? Int64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "minAllowedDeposit", typeName: "SwapInfo"))
        }
        guard let maxAllowedDeposit = swapInfo["maxAllowedDeposit"] as? Int64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxAllowedDeposit", typeName: "SwapInfo"))
        }
        guard let maxSwapperPayable = swapInfo["maxSwapperPayable"] as? Int64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "maxSwapperPayable", typeName: "SwapInfo"))
        }
        var lastRedeemError: String?
        if hasNonNilKey(data: swapInfo, key: "lastRedeemError") {
            guard let lastRedeemErrorTmp = swapInfo["lastRedeemError"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "lastRedeemError"))
            }
            lastRedeemError = lastRedeemErrorTmp
        }
        var channelOpeningFees: OpeningFeeParams?
        if let channelOpeningFeesTmp = swapInfo["channelOpeningFees"] as? [String: Any?] {
            channelOpeningFees = try asOpeningFeeParams(openingFeeParams: channelOpeningFeesTmp)
        }

        var confirmedAt: UInt32?
        if hasNonNilKey(data: swapInfo, key: "confirmedAt") {
            guard let confirmedAtTmp = swapInfo["confirmedAt"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "confirmedAt"))
            }
            confirmedAt = confirmedAtTmp
        }

        return SwapInfo(
            bitcoinAddress: bitcoinAddress,
            createdAt: createdAt,
            lockHeight: lockHeight,
            paymentHash: paymentHash,
            preimage: preimage,
            privateKey: privateKey,
            publicKey: publicKey,
            swapperPublicKey: swapperPublicKey,
            script: script,
            bolt11: bolt11,
            paidMsat: paidMsat,
            unconfirmedSats: unconfirmedSats,
            confirmedSats: confirmedSats,
            totalIncomingTxs: totalIncomingTxs,
            status: status,
            refundTxIds: refundTxIds,
            unconfirmedTxIds: unconfirmedTxIds,
            confirmedTxIds: confirmedTxIds,
            minAllowedDeposit: minAllowedDeposit,
            maxAllowedDeposit: maxAllowedDeposit,
            maxSwapperPayable: maxSwapperPayable,
            lastRedeemError: lastRedeemError,
            channelOpeningFees: channelOpeningFees,
            confirmedAt: confirmedAt
        )
    }

    static func dictionaryOf(swapInfo: SwapInfo) -> [String: Any?] {
        return [
            "bitcoinAddress": swapInfo.bitcoinAddress,
            "createdAt": swapInfo.createdAt,
            "lockHeight": swapInfo.lockHeight,
            "paymentHash": swapInfo.paymentHash,
            "preimage": swapInfo.preimage,
            "privateKey": swapInfo.privateKey,
            "publicKey": swapInfo.publicKey,
            "swapperPublicKey": swapInfo.swapperPublicKey,
            "script": swapInfo.script,
            "bolt11": swapInfo.bolt11 == nil ? nil : swapInfo.bolt11,
            "paidMsat": swapInfo.paidMsat,
            "unconfirmedSats": swapInfo.unconfirmedSats,
            "confirmedSats": swapInfo.confirmedSats,
            "totalIncomingTxs": swapInfo.totalIncomingTxs,
            "status": valueOf(swapStatus: swapInfo.status),
            "refundTxIds": swapInfo.refundTxIds,
            "unconfirmedTxIds": swapInfo.unconfirmedTxIds,
            "confirmedTxIds": swapInfo.confirmedTxIds,
            "minAllowedDeposit": swapInfo.minAllowedDeposit,
            "maxAllowedDeposit": swapInfo.maxAllowedDeposit,
            "maxSwapperPayable": swapInfo.maxSwapperPayable,
            "lastRedeemError": swapInfo.lastRedeemError == nil ? nil : swapInfo.lastRedeemError,
            "channelOpeningFees": swapInfo.channelOpeningFees == nil ? nil : dictionaryOf(openingFeeParams: swapInfo.channelOpeningFees!),
            "confirmedAt": swapInfo.confirmedAt == nil ? nil : swapInfo.confirmedAt,
        ]
    }

    static func asSwapInfoList(arr: [Any]) throws -> [SwapInfo] {
        var list = [SwapInfo]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var swapInfo = try asSwapInfo(swapInfo: val)
                list.append(swapInfo)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SwapInfo"))
            }
        }
        return list
    }

    static func arrayOf(swapInfoList: [SwapInfo]) -> [Any] {
        return swapInfoList.map { v -> [String: Any?] in return dictionaryOf(swapInfo: v) }
    }

    static func asSymbol(symbol: [String: Any?]) throws -> Symbol {
        var grapheme: String?
        if hasNonNilKey(data: symbol, key: "grapheme") {
            guard let graphemeTmp = symbol["grapheme"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "grapheme"))
            }
            grapheme = graphemeTmp
        }
        var template: String?
        if hasNonNilKey(data: symbol, key: "template") {
            guard let templateTmp = symbol["template"] as? String else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "template"))
            }
            template = templateTmp
        }
        var rtl: Bool?
        if hasNonNilKey(data: symbol, key: "rtl") {
            guard let rtlTmp = symbol["rtl"] as? Bool else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "rtl"))
            }
            rtl = rtlTmp
        }
        var position: UInt32?
        if hasNonNilKey(data: symbol, key: "position") {
            guard let positionTmp = symbol["position"] as? UInt32 else {
                throw SdkError.Generic(message: errUnexpectedValue(fieldName: "position"))
            }
            position = positionTmp
        }

        return Symbol(
            grapheme: grapheme,
            template: template,
            rtl: rtl,
            position: position
        )
    }

    static func dictionaryOf(symbol: Symbol) -> [String: Any?] {
        return [
            "grapheme": symbol.grapheme == nil ? nil : symbol.grapheme,
            "template": symbol.template == nil ? nil : symbol.template,
            "rtl": symbol.rtl == nil ? nil : symbol.rtl,
            "position": symbol.position == nil ? nil : symbol.position,
        ]
    }

    static func asSymbolList(arr: [Any]) throws -> [Symbol] {
        var list = [Symbol]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var symbol = try asSymbol(symbol: val)
                list.append(symbol)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "Symbol"))
            }
        }
        return list
    }

    static func arrayOf(symbolList: [Symbol]) -> [Any] {
        return symbolList.map { v -> [String: Any?] in return dictionaryOf(symbol: v) }
    }

    static func asTlvEntry(tlvEntry: [String: Any?]) throws -> TlvEntry {
        guard let fieldNumber = tlvEntry["fieldNumber"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "fieldNumber", typeName: "TlvEntry"))
        }
        guard let value = tlvEntry["value"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "value", typeName: "TlvEntry"))
        }

        return TlvEntry(
            fieldNumber: fieldNumber,
            value: value
        )
    }

    static func dictionaryOf(tlvEntry: TlvEntry) -> [String: Any?] {
        return [
            "fieldNumber": tlvEntry.fieldNumber,
            "value": tlvEntry.value,
        ]
    }

    static func asTlvEntryList(arr: [Any]) throws -> [TlvEntry] {
        var list = [TlvEntry]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var tlvEntry = try asTlvEntry(tlvEntry: val)
                list.append(tlvEntry)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "TlvEntry"))
            }
        }
        return list
    }

    static func arrayOf(tlvEntryList: [TlvEntry]) -> [Any] {
        return tlvEntryList.map { v -> [String: Any?] in return dictionaryOf(tlvEntry: v) }
    }

    static func asUnspentTransactionOutput(unspentTransactionOutput: [String: Any?]) throws -> UnspentTransactionOutput {
        guard let txid = unspentTransactionOutput["txid"] as? [UInt8] else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "txid", typeName: "UnspentTransactionOutput"))
        }
        guard let outnum = unspentTransactionOutput["outnum"] as? UInt32 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "outnum", typeName: "UnspentTransactionOutput"))
        }
        guard let amountMillisatoshi = unspentTransactionOutput["amountMillisatoshi"] as? UInt64 else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "amountMillisatoshi", typeName: "UnspentTransactionOutput"))
        }
        guard let address = unspentTransactionOutput["address"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "address", typeName: "UnspentTransactionOutput"))
        }
        guard let reserved = unspentTransactionOutput["reserved"] as? Bool else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "reserved", typeName: "UnspentTransactionOutput"))
        }

        return UnspentTransactionOutput(
            txid: txid,
            outnum: outnum,
            amountMillisatoshi: amountMillisatoshi,
            address: address,
            reserved: reserved
        )
    }

    static func dictionaryOf(unspentTransactionOutput: UnspentTransactionOutput) -> [String: Any?] {
        return [
            "txid": unspentTransactionOutput.txid,
            "outnum": unspentTransactionOutput.outnum,
            "amountMillisatoshi": unspentTransactionOutput.amountMillisatoshi,
            "address": unspentTransactionOutput.address,
            "reserved": unspentTransactionOutput.reserved,
        ]
    }

    static func asUnspentTransactionOutputList(arr: [Any]) throws -> [UnspentTransactionOutput] {
        var list = [UnspentTransactionOutput]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var unspentTransactionOutput = try asUnspentTransactionOutput(unspentTransactionOutput: val)
                list.append(unspentTransactionOutput)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "UnspentTransactionOutput"))
            }
        }
        return list
    }

    static func arrayOf(unspentTransactionOutputList: [UnspentTransactionOutput]) -> [Any] {
        return unspentTransactionOutputList.map { v -> [String: Any?] in return dictionaryOf(unspentTransactionOutput: v) }
    }

    static func asUrlSuccessActionData(urlSuccessActionData: [String: Any?]) throws -> UrlSuccessActionData {
        guard let description = urlSuccessActionData["description"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "description", typeName: "UrlSuccessActionData"))
        }
        guard let url = urlSuccessActionData["url"] as? String else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "url", typeName: "UrlSuccessActionData"))
        }
        guard let matchesCallbackDomain = urlSuccessActionData["matchesCallbackDomain"] as? Bool else {
            throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "matchesCallbackDomain", typeName: "UrlSuccessActionData"))
        }

        return UrlSuccessActionData(
            description: description,
            url: url,
            matchesCallbackDomain: matchesCallbackDomain
        )
    }

    static func dictionaryOf(urlSuccessActionData: UrlSuccessActionData) -> [String: Any?] {
        return [
            "description": urlSuccessActionData.description,
            "url": urlSuccessActionData.url,
            "matchesCallbackDomain": urlSuccessActionData.matchesCallbackDomain,
        ]
    }

    static func asUrlSuccessActionDataList(arr: [Any]) throws -> [UrlSuccessActionData] {
        var list = [UrlSuccessActionData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var urlSuccessActionData = try asUrlSuccessActionData(urlSuccessActionData: val)
                list.append(urlSuccessActionData)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "UrlSuccessActionData"))
            }
        }
        return list
    }

    static func arrayOf(urlSuccessActionDataList: [UrlSuccessActionData]) -> [Any] {
        return urlSuccessActionDataList.map { v -> [String: Any?] in return dictionaryOf(urlSuccessActionData: v) }
    }

    static func asAesSuccessActionDataResult(aesSuccessActionDataResult: [String: Any?]) throws -> AesSuccessActionDataResult {
        let type = aesSuccessActionDataResult["type"] as! String
        if type == "decrypted" {
            guard let dataTmp = aesSuccessActionDataResult["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "AesSuccessActionDataResult"))
            }
            let _data = try asAesSuccessActionDataDecrypted(aesSuccessActionDataDecrypted: dataTmp)

            return AesSuccessActionDataResult.decrypted(data: _data)
        }
        if type == "errorStatus" {
            guard let _reason = aesSuccessActionDataResult["reason"] as? String else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "reason", typeName: "AesSuccessActionDataResult"))
            }
            return AesSuccessActionDataResult.errorStatus(reason: _reason)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum AesSuccessActionDataResult")
    }

    static func dictionaryOf(aesSuccessActionDataResult: AesSuccessActionDataResult) -> [String: Any?] {
        switch aesSuccessActionDataResult {
        case let .decrypted(
            data
        ):
            return [
                "type": "decrypted",
                "data": dictionaryOf(aesSuccessActionDataDecrypted: data),
            ]

        case let .errorStatus(
            reason
        ):
            return [
                "type": "errorStatus",
                "reason": reason,
            ]
        }
    }

    static func arrayOf(aesSuccessActionDataResultList: [AesSuccessActionDataResult]) -> [Any] {
        return aesSuccessActionDataResultList.map { v -> [String: Any?] in return dictionaryOf(aesSuccessActionDataResult: v) }
    }

    static func asAesSuccessActionDataResultList(arr: [Any]) throws -> [AesSuccessActionDataResult] {
        var list = [AesSuccessActionDataResult]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var aesSuccessActionDataResult = try asAesSuccessActionDataResult(aesSuccessActionDataResult: val)
                list.append(aesSuccessActionDataResult)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "AesSuccessActionDataResult"))
            }
        }
        return list
    }

    static func asBreezEvent(breezEvent: [String: Any?]) throws -> BreezEvent {
        let type = breezEvent["type"] as! String
        if type == "newBlock" {
            guard let _block = breezEvent["block"] as? UInt32 else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "block", typeName: "BreezEvent"))
            }
            return BreezEvent.newBlock(block: _block)
        }
        if type == "invoicePaid" {
            guard let detailsTmp = breezEvent["details"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "details", typeName: "BreezEvent"))
            }
            let _details = try asInvoicePaidDetails(invoicePaidDetails: detailsTmp)

            return BreezEvent.invoicePaid(details: _details)
        }
        if type == "synced" {
            return BreezEvent.synced
        }
        if type == "paymentSucceed" {
            guard let detailsTmp = breezEvent["details"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "details", typeName: "BreezEvent"))
            }
            let _details = try asPayment(payment: detailsTmp)

            return BreezEvent.paymentSucceed(details: _details)
        }
        if type == "paymentFailed" {
            guard let detailsTmp = breezEvent["details"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "details", typeName: "BreezEvent"))
            }
            let _details = try asPaymentFailedData(paymentFailedData: detailsTmp)

            return BreezEvent.paymentFailed(details: _details)
        }
        if type == "backupStarted" {
            return BreezEvent.backupStarted
        }
        if type == "backupSucceeded" {
            return BreezEvent.backupSucceeded
        }
        if type == "backupFailed" {
            guard let detailsTmp = breezEvent["details"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "details", typeName: "BreezEvent"))
            }
            let _details = try asBackupFailedData(backupFailedData: detailsTmp)

            return BreezEvent.backupFailed(details: _details)
        }
        if type == "reverseSwapUpdated" {
            guard let detailsTmp = breezEvent["details"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "details", typeName: "BreezEvent"))
            }
            let _details = try asReverseSwapInfo(reverseSwapInfo: detailsTmp)

            return BreezEvent.reverseSwapUpdated(details: _details)
        }
        if type == "swapUpdated" {
            guard let detailsTmp = breezEvent["details"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "details", typeName: "BreezEvent"))
            }
            let _details = try asSwapInfo(swapInfo: detailsTmp)

            return BreezEvent.swapUpdated(details: _details)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum BreezEvent")
    }

    static func dictionaryOf(breezEvent: BreezEvent) -> [String: Any?] {
        switch breezEvent {
        case let .newBlock(
            block
        ):
            return [
                "type": "newBlock",
                "block": block,
            ]

        case let .invoicePaid(
            details
        ):
            return [
                "type": "invoicePaid",
                "details": dictionaryOf(invoicePaidDetails: details),
            ]

        case .synced:
            return [
                "type": "synced",
            ]

        case let .paymentSucceed(
            details
        ):
            return [
                "type": "paymentSucceed",
                "details": dictionaryOf(payment: details),
            ]

        case let .paymentFailed(
            details
        ):
            return [
                "type": "paymentFailed",
                "details": dictionaryOf(paymentFailedData: details),
            ]

        case .backupStarted:
            return [
                "type": "backupStarted",
            ]

        case .backupSucceeded:
            return [
                "type": "backupSucceeded",
            ]

        case let .backupFailed(
            details
        ):
            return [
                "type": "backupFailed",
                "details": dictionaryOf(backupFailedData: details),
            ]

        case let .reverseSwapUpdated(
            details
        ):
            return [
                "type": "reverseSwapUpdated",
                "details": dictionaryOf(reverseSwapInfo: details),
            ]

        case let .swapUpdated(
            details
        ):
            return [
                "type": "swapUpdated",
                "details": dictionaryOf(swapInfo: details),
            ]
        }
    }

    static func arrayOf(breezEventList: [BreezEvent]) -> [Any] {
        return breezEventList.map { v -> [String: Any?] in return dictionaryOf(breezEvent: v) }
    }

    static func asBreezEventList(arr: [Any]) throws -> [BreezEvent] {
        var list = [BreezEvent]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var breezEvent = try asBreezEvent(breezEvent: val)
                list.append(breezEvent)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "BreezEvent"))
            }
        }
        return list
    }

    static func asBuyBitcoinProvider(buyBitcoinProvider: String) throws -> BuyBitcoinProvider {
        switch buyBitcoinProvider {
        case "moonpay":
            return BuyBitcoinProvider.moonpay

        default: throw SdkError.Generic(message: "Invalid variant \(buyBitcoinProvider) for enum BuyBitcoinProvider")
        }
    }

    static func valueOf(buyBitcoinProvider: BuyBitcoinProvider) -> String {
        switch buyBitcoinProvider {
        case .moonpay:
            return "moonpay"
        }
    }

    static func arrayOf(buyBitcoinProviderList: [BuyBitcoinProvider]) -> [String] {
        return buyBitcoinProviderList.map { v -> String in return valueOf(buyBitcoinProvider: v) }
    }

    static func asBuyBitcoinProviderList(arr: [Any]) throws -> [BuyBitcoinProvider] {
        var list = [BuyBitcoinProvider]()
        for value in arr {
            if let val = value as? String {
                var buyBitcoinProvider = try asBuyBitcoinProvider(buyBitcoinProvider: val)
                list.append(buyBitcoinProvider)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "BuyBitcoinProvider"))
            }
        }
        return list
    }

    static func asChannelState(channelState: String) throws -> ChannelState {
        switch channelState {
        case "pendingOpen":
            return ChannelState.pendingOpen

        case "opened":
            return ChannelState.opened

        case "pendingClose":
            return ChannelState.pendingClose

        case "closed":
            return ChannelState.closed

        default: throw SdkError.Generic(message: "Invalid variant \(channelState) for enum ChannelState")
        }
    }

    static func valueOf(channelState: ChannelState) -> String {
        switch channelState {
        case .pendingOpen:
            return "pendingOpen"

        case .opened:
            return "opened"

        case .pendingClose:
            return "pendingClose"

        case .closed:
            return "closed"
        }
    }

    static func arrayOf(channelStateList: [ChannelState]) -> [String] {
        return channelStateList.map { v -> String in return valueOf(channelState: v) }
    }

    static func asChannelStateList(arr: [Any]) throws -> [ChannelState] {
        var list = [ChannelState]()
        for value in arr {
            if let val = value as? String {
                var channelState = try asChannelState(channelState: val)
                list.append(channelState)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ChannelState"))
            }
        }
        return list
    }

    static func asEnvironmentType(environmentType: String) throws -> EnvironmentType {
        switch environmentType {
        case "production":
            return EnvironmentType.production

        case "staging":
            return EnvironmentType.staging

        default: throw SdkError.Generic(message: "Invalid variant \(environmentType) for enum EnvironmentType")
        }
    }

    static func valueOf(environmentType: EnvironmentType) -> String {
        switch environmentType {
        case .production:
            return "production"

        case .staging:
            return "staging"
        }
    }

    static func arrayOf(environmentTypeList: [EnvironmentType]) -> [String] {
        return environmentTypeList.map { v -> String in return valueOf(environmentType: v) }
    }

    static func asEnvironmentTypeList(arr: [Any]) throws -> [EnvironmentType] {
        var list = [EnvironmentType]()
        for value in arr {
            if let val = value as? String {
                var environmentType = try asEnvironmentType(environmentType: val)
                list.append(environmentType)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "EnvironmentType"))
            }
        }
        return list
    }

    static func asFeeratePreset(feeratePreset: String) throws -> FeeratePreset {
        switch feeratePreset {
        case "regular":
            return FeeratePreset.regular

        case "economy":
            return FeeratePreset.economy

        case "priority":
            return FeeratePreset.priority

        default: throw SdkError.Generic(message: "Invalid variant \(feeratePreset) for enum FeeratePreset")
        }
    }

    static func valueOf(feeratePreset: FeeratePreset) -> String {
        switch feeratePreset {
        case .regular:
            return "regular"

        case .economy:
            return "economy"

        case .priority:
            return "priority"
        }
    }

    static func arrayOf(feeratePresetList: [FeeratePreset]) -> [String] {
        return feeratePresetList.map { v -> String in return valueOf(feeratePreset: v) }
    }

    static func asFeeratePresetList(arr: [Any]) throws -> [FeeratePreset] {
        var list = [FeeratePreset]()
        for value in arr {
            if let val = value as? String {
                var feeratePreset = try asFeeratePreset(feeratePreset: val)
                list.append(feeratePreset)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "FeeratePreset"))
            }
        }
        return list
    }

    static func asHealthCheckStatus(healthCheckStatus: String) throws -> HealthCheckStatus {
        switch healthCheckStatus {
        case "operational":
            return HealthCheckStatus.operational

        case "maintenance":
            return HealthCheckStatus.maintenance

        case "serviceDisruption":
            return HealthCheckStatus.serviceDisruption

        default: throw SdkError.Generic(message: "Invalid variant \(healthCheckStatus) for enum HealthCheckStatus")
        }
    }

    static func valueOf(healthCheckStatus: HealthCheckStatus) -> String {
        switch healthCheckStatus {
        case .operational:
            return "operational"

        case .maintenance:
            return "maintenance"

        case .serviceDisruption:
            return "serviceDisruption"
        }
    }

    static func arrayOf(healthCheckStatusList: [HealthCheckStatus]) -> [String] {
        return healthCheckStatusList.map { v -> String in return valueOf(healthCheckStatus: v) }
    }

    static func asHealthCheckStatusList(arr: [Any]) throws -> [HealthCheckStatus] {
        var list = [HealthCheckStatus]()
        for value in arr {
            if let val = value as? String {
                var healthCheckStatus = try asHealthCheckStatus(healthCheckStatus: val)
                list.append(healthCheckStatus)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "HealthCheckStatus"))
            }
        }
        return list
    }

    static func asInputType(inputType: [String: Any?]) throws -> InputType {
        let type = inputType["type"] as! String
        if type == "bitcoinAddress" {
            guard let addressTmp = inputType["address"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "address", typeName: "InputType"))
            }
            let _address = try asBitcoinAddressData(bitcoinAddressData: addressTmp)

            return InputType.bitcoinAddress(address: _address)
        }
        if type == "bolt11" {
            guard let invoiceTmp = inputType["invoice"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "invoice", typeName: "InputType"))
            }
            let _invoice = try asLnInvoice(lnInvoice: invoiceTmp)

            return InputType.bolt11(invoice: _invoice)
        }
        if type == "nodeId" {
            guard let _nodeId = inputType["nodeId"] as? String else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "nodeId", typeName: "InputType"))
            }
            return InputType.nodeId(nodeId: _nodeId)
        }
        if type == "url" {
            guard let _url = inputType["url"] as? String else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "url", typeName: "InputType"))
            }
            return InputType.url(url: _url)
        }
        if type == "lnUrlPay" {
            guard let dataTmp = inputType["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "InputType"))
            }
            let _data = try asLnUrlPayRequestData(lnUrlPayRequestData: dataTmp)

            return InputType.lnUrlPay(data: _data)
        }
        if type == "lnUrlWithdraw" {
            guard let dataTmp = inputType["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "InputType"))
            }
            let _data = try asLnUrlWithdrawRequestData(lnUrlWithdrawRequestData: dataTmp)

            return InputType.lnUrlWithdraw(data: _data)
        }
        if type == "lnUrlAuth" {
            guard let dataTmp = inputType["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "InputType"))
            }
            let _data = try asLnUrlAuthRequestData(lnUrlAuthRequestData: dataTmp)

            return InputType.lnUrlAuth(data: _data)
        }
        if type == "lnUrlError" {
            guard let dataTmp = inputType["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "InputType"))
            }
            let _data = try asLnUrlErrorData(lnUrlErrorData: dataTmp)

            return InputType.lnUrlError(data: _data)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum InputType")
    }

    static func dictionaryOf(inputType: InputType) -> [String: Any?] {
        switch inputType {
        case let .bitcoinAddress(
            address
        ):
            return [
                "type": "bitcoinAddress",
                "address": dictionaryOf(bitcoinAddressData: address),
            ]

        case let .bolt11(
            invoice
        ):
            return [
                "type": "bolt11",
                "invoice": dictionaryOf(lnInvoice: invoice),
            ]

        case let .nodeId(
            nodeId
        ):
            return [
                "type": "nodeId",
                "nodeId": nodeId,
            ]

        case let .url(
            url
        ):
            return [
                "type": "url",
                "url": url,
            ]

        case let .lnUrlPay(
            data
        ):
            return [
                "type": "lnUrlPay",
                "data": dictionaryOf(lnUrlPayRequestData: data),
            ]

        case let .lnUrlWithdraw(
            data
        ):
            return [
                "type": "lnUrlWithdraw",
                "data": dictionaryOf(lnUrlWithdrawRequestData: data),
            ]

        case let .lnUrlAuth(
            data
        ):
            return [
                "type": "lnUrlAuth",
                "data": dictionaryOf(lnUrlAuthRequestData: data),
            ]

        case let .lnUrlError(
            data
        ):
            return [
                "type": "lnUrlError",
                "data": dictionaryOf(lnUrlErrorData: data),
            ]
        }
    }

    static func arrayOf(inputTypeList: [InputType]) -> [Any] {
        return inputTypeList.map { v -> [String: Any?] in return dictionaryOf(inputType: v) }
    }

    static func asInputTypeList(arr: [Any]) throws -> [InputType] {
        var list = [InputType]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var inputType = try asInputType(inputType: val)
                list.append(inputType)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "InputType"))
            }
        }
        return list
    }

    static func asLnUrlCallbackStatus(lnUrlCallbackStatus: [String: Any?]) throws -> LnUrlCallbackStatus {
        let type = lnUrlCallbackStatus["type"] as! String
        if type == "ok" {
            return LnUrlCallbackStatus.ok
        }
        if type == "errorStatus" {
            guard let dataTmp = lnUrlCallbackStatus["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "LnUrlCallbackStatus"))
            }
            let _data = try asLnUrlErrorData(lnUrlErrorData: dataTmp)

            return LnUrlCallbackStatus.errorStatus(data: _data)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum LnUrlCallbackStatus")
    }

    static func dictionaryOf(lnUrlCallbackStatus: LnUrlCallbackStatus) -> [String: Any?] {
        switch lnUrlCallbackStatus {
        case .ok:
            return [
                "type": "ok",
            ]

        case let .errorStatus(
            data
        ):
            return [
                "type": "errorStatus",
                "data": dictionaryOf(lnUrlErrorData: data),
            ]
        }
    }

    static func arrayOf(lnUrlCallbackStatusList: [LnUrlCallbackStatus]) -> [Any] {
        return lnUrlCallbackStatusList.map { v -> [String: Any?] in return dictionaryOf(lnUrlCallbackStatus: v) }
    }

    static func asLnUrlCallbackStatusList(arr: [Any]) throws -> [LnUrlCallbackStatus] {
        var list = [LnUrlCallbackStatus]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlCallbackStatus = try asLnUrlCallbackStatus(lnUrlCallbackStatus: val)
                list.append(lnUrlCallbackStatus)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlCallbackStatus"))
            }
        }
        return list
    }

    static func asLnUrlPayResult(lnUrlPayResult: [String: Any?]) throws -> LnUrlPayResult {
        let type = lnUrlPayResult["type"] as! String
        if type == "endpointSuccess" {
            guard let dataTmp = lnUrlPayResult["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "LnUrlPayResult"))
            }
            let _data = try asLnUrlPaySuccessData(lnUrlPaySuccessData: dataTmp)

            return LnUrlPayResult.endpointSuccess(data: _data)
        }
        if type == "endpointError" {
            guard let dataTmp = lnUrlPayResult["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "LnUrlPayResult"))
            }
            let _data = try asLnUrlErrorData(lnUrlErrorData: dataTmp)

            return LnUrlPayResult.endpointError(data: _data)
        }
        if type == "payError" {
            guard let dataTmp = lnUrlPayResult["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "LnUrlPayResult"))
            }
            let _data = try asLnUrlPayErrorData(lnUrlPayErrorData: dataTmp)

            return LnUrlPayResult.payError(data: _data)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum LnUrlPayResult")
    }

    static func dictionaryOf(lnUrlPayResult: LnUrlPayResult) -> [String: Any?] {
        switch lnUrlPayResult {
        case let .endpointSuccess(
            data
        ):
            return [
                "type": "endpointSuccess",
                "data": dictionaryOf(lnUrlPaySuccessData: data),
            ]

        case let .endpointError(
            data
        ):
            return [
                "type": "endpointError",
                "data": dictionaryOf(lnUrlErrorData: data),
            ]

        case let .payError(
            data
        ):
            return [
                "type": "payError",
                "data": dictionaryOf(lnUrlPayErrorData: data),
            ]
        }
    }

    static func arrayOf(lnUrlPayResultList: [LnUrlPayResult]) -> [Any] {
        return lnUrlPayResultList.map { v -> [String: Any?] in return dictionaryOf(lnUrlPayResult: v) }
    }

    static func asLnUrlPayResultList(arr: [Any]) throws -> [LnUrlPayResult] {
        var list = [LnUrlPayResult]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlPayResult = try asLnUrlPayResult(lnUrlPayResult: val)
                list.append(lnUrlPayResult)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlPayResult"))
            }
        }
        return list
    }

    static func asLnUrlWithdrawResult(lnUrlWithdrawResult: [String: Any?]) throws -> LnUrlWithdrawResult {
        let type = lnUrlWithdrawResult["type"] as! String
        if type == "ok" {
            guard let dataTmp = lnUrlWithdrawResult["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "LnUrlWithdrawResult"))
            }
            let _data = try asLnUrlWithdrawSuccessData(lnUrlWithdrawSuccessData: dataTmp)

            return LnUrlWithdrawResult.ok(data: _data)
        }
        if type == "timeout" {
            guard let dataTmp = lnUrlWithdrawResult["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "LnUrlWithdrawResult"))
            }
            let _data = try asLnUrlWithdrawSuccessData(lnUrlWithdrawSuccessData: dataTmp)

            return LnUrlWithdrawResult.timeout(data: _data)
        }
        if type == "errorStatus" {
            guard let dataTmp = lnUrlWithdrawResult["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "LnUrlWithdrawResult"))
            }
            let _data = try asLnUrlErrorData(lnUrlErrorData: dataTmp)

            return LnUrlWithdrawResult.errorStatus(data: _data)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum LnUrlWithdrawResult")
    }

    static func dictionaryOf(lnUrlWithdrawResult: LnUrlWithdrawResult) -> [String: Any?] {
        switch lnUrlWithdrawResult {
        case let .ok(
            data
        ):
            return [
                "type": "ok",
                "data": dictionaryOf(lnUrlWithdrawSuccessData: data),
            ]

        case let .timeout(
            data
        ):
            return [
                "type": "timeout",
                "data": dictionaryOf(lnUrlWithdrawSuccessData: data),
            ]

        case let .errorStatus(
            data
        ):
            return [
                "type": "errorStatus",
                "data": dictionaryOf(lnUrlErrorData: data),
            ]
        }
    }

    static func arrayOf(lnUrlWithdrawResultList: [LnUrlWithdrawResult]) -> [Any] {
        return lnUrlWithdrawResultList.map { v -> [String: Any?] in return dictionaryOf(lnUrlWithdrawResult: v) }
    }

    static func asLnUrlWithdrawResultList(arr: [Any]) throws -> [LnUrlWithdrawResult] {
        var list = [LnUrlWithdrawResult]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlWithdrawResult = try asLnUrlWithdrawResult(lnUrlWithdrawResult: val)
                list.append(lnUrlWithdrawResult)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "LnUrlWithdrawResult"))
            }
        }
        return list
    }

    static func asNetwork(network: String) throws -> Network {
        switch network {
        case "bitcoin":
            return Network.bitcoin

        case "testnet":
            return Network.testnet

        case "signet":
            return Network.signet

        case "regtest":
            return Network.regtest

        default: throw SdkError.Generic(message: "Invalid variant \(network) for enum Network")
        }
    }

    static func valueOf(network: Network) -> String {
        switch network {
        case .bitcoin:
            return "bitcoin"

        case .testnet:
            return "testnet"

        case .signet:
            return "signet"

        case .regtest:
            return "regtest"
        }
    }

    static func arrayOf(networkList: [Network]) -> [String] {
        return networkList.map { v -> String in return valueOf(network: v) }
    }

    static func asNetworkList(arr: [Any]) throws -> [Network] {
        var list = [Network]()
        for value in arr {
            if let val = value as? String {
                var network = try asNetwork(network: val)
                list.append(network)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "Network"))
            }
        }
        return list
    }

    static func asNodeConfig(nodeConfig: [String: Any?]) throws -> NodeConfig {
        let type = nodeConfig["type"] as! String
        if type == "greenlight" {
            guard let configTmp = nodeConfig["config"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "config", typeName: "NodeConfig"))
            }
            let _config = try asGreenlightNodeConfig(greenlightNodeConfig: configTmp)

            return NodeConfig.greenlight(config: _config)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum NodeConfig")
    }

    static func dictionaryOf(nodeConfig: NodeConfig) -> [String: Any?] {
        switch nodeConfig {
        case let .greenlight(
            config
        ):
            return [
                "type": "greenlight",
                "config": dictionaryOf(greenlightNodeConfig: config),
            ]
        }
    }

    static func arrayOf(nodeConfigList: [NodeConfig]) -> [Any] {
        return nodeConfigList.map { v -> [String: Any?] in return dictionaryOf(nodeConfig: v) }
    }

    static func asNodeConfigList(arr: [Any]) throws -> [NodeConfig] {
        var list = [NodeConfig]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var nodeConfig = try asNodeConfig(nodeConfig: val)
                list.append(nodeConfig)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "NodeConfig"))
            }
        }
        return list
    }

    static func asNodeCredentials(nodeCredentials: [String: Any?]) throws -> NodeCredentials {
        let type = nodeCredentials["type"] as! String
        if type == "greenlight" {
            guard let credentialsTmp = nodeCredentials["credentials"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "credentials", typeName: "NodeCredentials"))
            }
            let _credentials = try asGreenlightDeviceCredentials(greenlightDeviceCredentials: credentialsTmp)

            return NodeCredentials.greenlight(credentials: _credentials)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum NodeCredentials")
    }

    static func dictionaryOf(nodeCredentials: NodeCredentials) -> [String: Any?] {
        switch nodeCredentials {
        case let .greenlight(
            credentials
        ):
            return [
                "type": "greenlight",
                "credentials": dictionaryOf(greenlightDeviceCredentials: credentials),
            ]
        }
    }

    static func arrayOf(nodeCredentialsList: [NodeCredentials]) -> [Any] {
        return nodeCredentialsList.map { v -> [String: Any?] in return dictionaryOf(nodeCredentials: v) }
    }

    static func asNodeCredentialsList(arr: [Any]) throws -> [NodeCredentials] {
        var list = [NodeCredentials]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var nodeCredentials = try asNodeCredentials(nodeCredentials: val)
                list.append(nodeCredentials)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "NodeCredentials"))
            }
        }
        return list
    }

    static func asPaymentDetails(paymentDetails: [String: Any?]) throws -> PaymentDetails {
        let type = paymentDetails["type"] as! String
        if type == "ln" {
            guard let dataTmp = paymentDetails["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "PaymentDetails"))
            }
            let _data = try asLnPaymentDetails(lnPaymentDetails: dataTmp)

            return PaymentDetails.ln(data: _data)
        }
        if type == "closedChannel" {
            guard let dataTmp = paymentDetails["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "PaymentDetails"))
            }
            let _data = try asClosedChannelPaymentDetails(closedChannelPaymentDetails: dataTmp)

            return PaymentDetails.closedChannel(data: _data)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum PaymentDetails")
    }

    static func dictionaryOf(paymentDetails: PaymentDetails) -> [String: Any?] {
        switch paymentDetails {
        case let .ln(
            data
        ):
            return [
                "type": "ln",
                "data": dictionaryOf(lnPaymentDetails: data),
            ]

        case let .closedChannel(
            data
        ):
            return [
                "type": "closedChannel",
                "data": dictionaryOf(closedChannelPaymentDetails: data),
            ]
        }
    }

    static func arrayOf(paymentDetailsList: [PaymentDetails]) -> [Any] {
        return paymentDetailsList.map { v -> [String: Any?] in return dictionaryOf(paymentDetails: v) }
    }

    static func asPaymentDetailsList(arr: [Any]) throws -> [PaymentDetails] {
        var list = [PaymentDetails]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var paymentDetails = try asPaymentDetails(paymentDetails: val)
                list.append(paymentDetails)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PaymentDetails"))
            }
        }
        return list
    }

    static func asPaymentStatus(paymentStatus: String) throws -> PaymentStatus {
        switch paymentStatus {
        case "pending":
            return PaymentStatus.pending

        case "complete":
            return PaymentStatus.complete

        case "failed":
            return PaymentStatus.failed

        default: throw SdkError.Generic(message: "Invalid variant \(paymentStatus) for enum PaymentStatus")
        }
    }

    static func valueOf(paymentStatus: PaymentStatus) -> String {
        switch paymentStatus {
        case .pending:
            return "pending"

        case .complete:
            return "complete"

        case .failed:
            return "failed"
        }
    }

    static func arrayOf(paymentStatusList: [PaymentStatus]) -> [String] {
        return paymentStatusList.map { v -> String in return valueOf(paymentStatus: v) }
    }

    static func asPaymentStatusList(arr: [Any]) throws -> [PaymentStatus] {
        var list = [PaymentStatus]()
        for value in arr {
            if let val = value as? String {
                var paymentStatus = try asPaymentStatus(paymentStatus: val)
                list.append(paymentStatus)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PaymentStatus"))
            }
        }
        return list
    }

    static func asPaymentType(paymentType: String) throws -> PaymentType {
        switch paymentType {
        case "sent":
            return PaymentType.sent

        case "received":
            return PaymentType.received

        case "closedChannel":
            return PaymentType.closedChannel

        default: throw SdkError.Generic(message: "Invalid variant \(paymentType) for enum PaymentType")
        }
    }

    static func valueOf(paymentType: PaymentType) -> String {
        switch paymentType {
        case .sent:
            return "sent"

        case .received:
            return "received"

        case .closedChannel:
            return "closedChannel"
        }
    }

    static func arrayOf(paymentTypeList: [PaymentType]) -> [String] {
        return paymentTypeList.map { v -> String in return valueOf(paymentType: v) }
    }

    static func asPaymentTypeList(arr: [Any]) throws -> [PaymentType] {
        var list = [PaymentType]()
        for value in arr {
            if let val = value as? String {
                var paymentType = try asPaymentType(paymentType: val)
                list.append(paymentType)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PaymentType"))
            }
        }
        return list
    }

    static func asPaymentTypeFilter(paymentTypeFilter: String) throws -> PaymentTypeFilter {
        switch paymentTypeFilter {
        case "sent":
            return PaymentTypeFilter.sent

        case "received":
            return PaymentTypeFilter.received

        case "closedChannel":
            return PaymentTypeFilter.closedChannel

        default: throw SdkError.Generic(message: "Invalid variant \(paymentTypeFilter) for enum PaymentTypeFilter")
        }
    }

    static func valueOf(paymentTypeFilter: PaymentTypeFilter) -> String {
        switch paymentTypeFilter {
        case .sent:
            return "sent"

        case .received:
            return "received"

        case .closedChannel:
            return "closedChannel"
        }
    }

    static func arrayOf(paymentTypeFilterList: [PaymentTypeFilter]) -> [String] {
        return paymentTypeFilterList.map { v -> String in return valueOf(paymentTypeFilter: v) }
    }

    static func asPaymentTypeFilterList(arr: [Any]) throws -> [PaymentTypeFilter] {
        var list = [PaymentTypeFilter]()
        for value in arr {
            if let val = value as? String {
                var paymentTypeFilter = try asPaymentTypeFilter(paymentTypeFilter: val)
                list.append(paymentTypeFilter)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "PaymentTypeFilter"))
            }
        }
        return list
    }

    static func asReportIssueRequest(reportIssueRequest: [String: Any?]) throws -> ReportIssueRequest {
        let type = reportIssueRequest["type"] as! String
        if type == "paymentFailure" {
            guard let dataTmp = reportIssueRequest["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "ReportIssueRequest"))
            }
            let _data = try asReportPaymentFailureDetails(reportPaymentFailureDetails: dataTmp)

            return ReportIssueRequest.paymentFailure(data: _data)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum ReportIssueRequest")
    }

    static func dictionaryOf(reportIssueRequest: ReportIssueRequest) -> [String: Any?] {
        switch reportIssueRequest {
        case let .paymentFailure(
            data
        ):
            return [
                "type": "paymentFailure",
                "data": dictionaryOf(reportPaymentFailureDetails: data),
            ]
        }
    }

    static func arrayOf(reportIssueRequestList: [ReportIssueRequest]) -> [Any] {
        return reportIssueRequestList.map { v -> [String: Any?] in return dictionaryOf(reportIssueRequest: v) }
    }

    static func asReportIssueRequestList(arr: [Any]) throws -> [ReportIssueRequest] {
        var list = [ReportIssueRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var reportIssueRequest = try asReportIssueRequest(reportIssueRequest: val)
                list.append(reportIssueRequest)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ReportIssueRequest"))
            }
        }
        return list
    }

    static func asReverseSwapStatus(reverseSwapStatus: String) throws -> ReverseSwapStatus {
        switch reverseSwapStatus {
        case "initial":
            return ReverseSwapStatus.initial

        case "inProgress":
            return ReverseSwapStatus.inProgress

        case "cancelled":
            return ReverseSwapStatus.cancelled

        case "completedSeen":
            return ReverseSwapStatus.completedSeen

        case "completedConfirmed":
            return ReverseSwapStatus.completedConfirmed

        default: throw SdkError.Generic(message: "Invalid variant \(reverseSwapStatus) for enum ReverseSwapStatus")
        }
    }

    static func valueOf(reverseSwapStatus: ReverseSwapStatus) -> String {
        switch reverseSwapStatus {
        case .initial:
            return "initial"

        case .inProgress:
            return "inProgress"

        case .cancelled:
            return "cancelled"

        case .completedSeen:
            return "completedSeen"

        case .completedConfirmed:
            return "completedConfirmed"
        }
    }

    static func arrayOf(reverseSwapStatusList: [ReverseSwapStatus]) -> [String] {
        return reverseSwapStatusList.map { v -> String in return valueOf(reverseSwapStatus: v) }
    }

    static func asReverseSwapStatusList(arr: [Any]) throws -> [ReverseSwapStatus] {
        var list = [ReverseSwapStatus]()
        for value in arr {
            if let val = value as? String {
                var reverseSwapStatus = try asReverseSwapStatus(reverseSwapStatus: val)
                list.append(reverseSwapStatus)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "ReverseSwapStatus"))
            }
        }
        return list
    }

    static func asSuccessActionProcessed(successActionProcessed: [String: Any?]) throws -> SuccessActionProcessed {
        let type = successActionProcessed["type"] as! String
        if type == "aes" {
            guard let resultTmp = successActionProcessed["result"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "result", typeName: "SuccessActionProcessed"))
            }
            let _result = try asAesSuccessActionDataResult(aesSuccessActionDataResult: resultTmp)

            return SuccessActionProcessed.aes(result: _result)
        }
        if type == "message" {
            guard let dataTmp = successActionProcessed["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "SuccessActionProcessed"))
            }
            let _data = try asMessageSuccessActionData(messageSuccessActionData: dataTmp)

            return SuccessActionProcessed.message(data: _data)
        }
        if type == "url" {
            guard let dataTmp = successActionProcessed["data"] as? [String: Any?] else {
                throw SdkError.Generic(message: errMissingMandatoryField(fieldName: "data", typeName: "SuccessActionProcessed"))
            }
            let _data = try asUrlSuccessActionData(urlSuccessActionData: dataTmp)

            return SuccessActionProcessed.url(data: _data)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum SuccessActionProcessed")
    }

    static func dictionaryOf(successActionProcessed: SuccessActionProcessed) -> [String: Any?] {
        switch successActionProcessed {
        case let .aes(
            result
        ):
            return [
                "type": "aes",
                "result": dictionaryOf(aesSuccessActionDataResult: result),
            ]

        case let .message(
            data
        ):
            return [
                "type": "message",
                "data": dictionaryOf(messageSuccessActionData: data),
            ]

        case let .url(
            data
        ):
            return [
                "type": "url",
                "data": dictionaryOf(urlSuccessActionData: data),
            ]
        }
    }

    static func arrayOf(successActionProcessedList: [SuccessActionProcessed]) -> [Any] {
        return successActionProcessedList.map { v -> [String: Any?] in return dictionaryOf(successActionProcessed: v) }
    }

    static func asSuccessActionProcessedList(arr: [Any]) throws -> [SuccessActionProcessed] {
        var list = [SuccessActionProcessed]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var successActionProcessed = try asSuccessActionProcessed(successActionProcessed: val)
                list.append(successActionProcessed)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SuccessActionProcessed"))
            }
        }
        return list
    }

    static func asSwapAmountType(swapAmountType: String) throws -> SwapAmountType {
        switch swapAmountType {
        case "send":
            return SwapAmountType.send

        case "receive":
            return SwapAmountType.receive

        default: throw SdkError.Generic(message: "Invalid variant \(swapAmountType) for enum SwapAmountType")
        }
    }

    static func valueOf(swapAmountType: SwapAmountType) -> String {
        switch swapAmountType {
        case .send:
            return "send"

        case .receive:
            return "receive"
        }
    }

    static func arrayOf(swapAmountTypeList: [SwapAmountType]) -> [String] {
        return swapAmountTypeList.map { v -> String in return valueOf(swapAmountType: v) }
    }

    static func asSwapAmountTypeList(arr: [Any]) throws -> [SwapAmountType] {
        var list = [SwapAmountType]()
        for value in arr {
            if let val = value as? String {
                var swapAmountType = try asSwapAmountType(swapAmountType: val)
                list.append(swapAmountType)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SwapAmountType"))
            }
        }
        return list
    }

    static func asSwapStatus(swapStatus: String) throws -> SwapStatus {
        switch swapStatus {
        case "initial":
            return SwapStatus.initial

        case "waitingConfirmation":
            return SwapStatus.waitingConfirmation

        case "redeemable":
            return SwapStatus.redeemable

        case "redeemed":
            return SwapStatus.redeemed

        case "refundable":
            return SwapStatus.refundable

        case "completed":
            return SwapStatus.completed

        default: throw SdkError.Generic(message: "Invalid variant \(swapStatus) for enum SwapStatus")
        }
    }

    static func valueOf(swapStatus: SwapStatus) -> String {
        switch swapStatus {
        case .initial:
            return "initial"

        case .waitingConfirmation:
            return "waitingConfirmation"

        case .redeemable:
            return "redeemable"

        case .redeemed:
            return "redeemed"

        case .refundable:
            return "refundable"

        case .completed:
            return "completed"
        }
    }

    static func arrayOf(swapStatusList: [SwapStatus]) -> [String] {
        return swapStatusList.map { v -> String in return valueOf(swapStatus: v) }
    }

    static func asSwapStatusList(arr: [Any]) throws -> [SwapStatus] {
        var list = [SwapStatus]()
        for value in arr {
            if let val = value as? String {
                var swapStatus = try asSwapStatus(swapStatus: val)
                list.append(swapStatus)
            } else {
                throw SdkError.Generic(message: errUnexpectedType(typeName: "SwapStatus"))
            }
        }
        return list
    }

    static func hasNonNilKey(data: [String: Any?], key: String) -> Bool {
        if let val = data[key] {
            return !(val == nil || val is NSNull)
        }

        return false
    }

    static func errMissingMandatoryField(fieldName: String, typeName: String) -> String {
        return "Missing mandatory field \(fieldName) for type \(typeName)"
    }

    static func errUnexpectedType(typeName: String) -> String {
        return "Unexpected type \(typeName)"
    }

    static func errUnexpectedValue(fieldName: String) -> String {
        return "Unexpected value for optional field \(fieldName)"
    }
}
