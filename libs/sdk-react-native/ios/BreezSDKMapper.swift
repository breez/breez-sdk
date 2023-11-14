import BreezSDK
import Foundation

enum BreezSDKMapper {
    static func asAesSuccessActionDataDecrypted(aesSuccessActionDataDecrypted: [String: Any?]) throws -> AesSuccessActionDataDecrypted {
        guard let description = aesSuccessActionDataDecrypted["description"] as? String else { throw SdkError.Generic(message: "Missing mandatory field description for type AesSuccessActionDataDecrypted") }
        guard let plaintext = aesSuccessActionDataDecrypted["plaintext"] as? String else { throw SdkError.Generic(message: "Missing mandatory field plaintext for type AesSuccessActionDataDecrypted") }

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
                throw SdkError.Generic(message: "Unexpected type AesSuccessActionDataDecrypted")
            }
        }
        return list
    }

    static func arrayOf(aesSuccessActionDataDecryptedList: [AesSuccessActionDataDecrypted]) -> [Any] {
        return aesSuccessActionDataDecryptedList.map { v -> [String: Any?] in dictionaryOf(aesSuccessActionDataDecrypted: v) }
    }

    static func asBackupFailedData(backupFailedData: [String: Any?]) throws -> BackupFailedData {
        guard let error = backupFailedData["error"] as? String else { throw SdkError.Generic(message: "Missing mandatory field error for type BackupFailedData") }

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
                throw SdkError.Generic(message: "Unexpected type BackupFailedData")
            }
        }
        return list
    }

    static func arrayOf(backupFailedDataList: [BackupFailedData]) -> [Any] {
        return backupFailedDataList.map { v -> [String: Any?] in dictionaryOf(backupFailedData: v) }
    }

    static func asBackupStatus(backupStatus: [String: Any?]) throws -> BackupStatus {
        guard let backedUp = backupStatus["backedUp"] as? Bool else { throw SdkError.Generic(message: "Missing mandatory field backedUp for type BackupStatus") }
        let lastBackupTime = backupStatus["lastBackupTime"] as? UInt64

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
                throw SdkError.Generic(message: "Unexpected type BackupStatus")
            }
        }
        return list
    }

    static func arrayOf(backupStatusList: [BackupStatus]) -> [Any] {
        return backupStatusList.map { v -> [String: Any?] in dictionaryOf(backupStatus: v) }
    }

    static func asBitcoinAddressData(bitcoinAddressData: [String: Any?]) throws -> BitcoinAddressData {
        guard let address = bitcoinAddressData["address"] as? String else { throw SdkError.Generic(message: "Missing mandatory field address for type BitcoinAddressData") }
        guard let networkTmp = bitcoinAddressData["network"] as? String else { throw SdkError.Generic(message: "Missing mandatory field network for type BitcoinAddressData") }
        let network = try asNetwork(network: networkTmp)

        let amountSat = bitcoinAddressData["amountSat"] as? UInt64
        let label = bitcoinAddressData["label"] as? String
        let message = bitcoinAddressData["message"] as? String

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
                throw SdkError.Generic(message: "Unexpected type BitcoinAddressData")
            }
        }
        return list
    }

    static func arrayOf(bitcoinAddressDataList: [BitcoinAddressData]) -> [Any] {
        return bitcoinAddressDataList.map { v -> [String: Any?] in dictionaryOf(bitcoinAddressData: v) }
    }

    static func asBuyBitcoinRequest(buyBitcoinRequest: [String: Any?]) throws -> BuyBitcoinRequest {
        guard let providerTmp = buyBitcoinRequest["provider"] as? String else { throw SdkError.Generic(message: "Missing mandatory field provider for type BuyBitcoinRequest") }
        let provider = try asBuyBitcoinProvider(buyBitcoinProvider: providerTmp)

        var openingFeeParams: OpeningFeeParams?
        if let openingFeeParamsTmp = buyBitcoinRequest["openingFeeParams"] as? [String: Any?] {
            openingFeeParams = try asOpeningFeeParams(openingFeeParams: openingFeeParamsTmp)
        }

        return BuyBitcoinRequest(
            provider: provider,
            openingFeeParams: openingFeeParams
        )
    }

    static func dictionaryOf(buyBitcoinRequest: BuyBitcoinRequest) -> [String: Any?] {
        return [
            "provider": valueOf(buyBitcoinProvider: buyBitcoinRequest.provider),
            "openingFeeParams": buyBitcoinRequest.openingFeeParams == nil ? nil : dictionaryOf(openingFeeParams: buyBitcoinRequest.openingFeeParams!),
        ]
    }

    static func asBuyBitcoinRequestList(arr: [Any]) throws -> [BuyBitcoinRequest] {
        var list = [BuyBitcoinRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var buyBitcoinRequest = try asBuyBitcoinRequest(buyBitcoinRequest: val)
                list.append(buyBitcoinRequest)
            } else {
                throw SdkError.Generic(message: "Unexpected type BuyBitcoinRequest")
            }
        }
        return list
    }

    static func arrayOf(buyBitcoinRequestList: [BuyBitcoinRequest]) -> [Any] {
        return buyBitcoinRequestList.map { v -> [String: Any?] in dictionaryOf(buyBitcoinRequest: v) }
    }

    static func asBuyBitcoinResponse(buyBitcoinResponse: [String: Any?]) throws -> BuyBitcoinResponse {
        guard let url = buyBitcoinResponse["url"] as? String else { throw SdkError.Generic(message: "Missing mandatory field url for type BuyBitcoinResponse") }
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
                throw SdkError.Generic(message: "Unexpected type BuyBitcoinResponse")
            }
        }
        return list
    }

    static func arrayOf(buyBitcoinResponseList: [BuyBitcoinResponse]) -> [Any] {
        return buyBitcoinResponseList.map { v -> [String: Any?] in dictionaryOf(buyBitcoinResponse: v) }
    }

    static func asCheckMessageRequest(checkMessageRequest: [String: Any?]) throws -> CheckMessageRequest {
        guard let message = checkMessageRequest["message"] as? String else { throw SdkError.Generic(message: "Missing mandatory field message for type CheckMessageRequest") }
        guard let pubkey = checkMessageRequest["pubkey"] as? String else { throw SdkError.Generic(message: "Missing mandatory field pubkey for type CheckMessageRequest") }
        guard let signature = checkMessageRequest["signature"] as? String else { throw SdkError.Generic(message: "Missing mandatory field signature for type CheckMessageRequest") }

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
                throw SdkError.Generic(message: "Unexpected type CheckMessageRequest")
            }
        }
        return list
    }

    static func arrayOf(checkMessageRequestList: [CheckMessageRequest]) -> [Any] {
        return checkMessageRequestList.map { v -> [String: Any?] in dictionaryOf(checkMessageRequest: v) }
    }

    static func asCheckMessageResponse(checkMessageResponse: [String: Any?]) throws -> CheckMessageResponse {
        guard let isValid = checkMessageResponse["isValid"] as? Bool else { throw SdkError.Generic(message: "Missing mandatory field isValid for type CheckMessageResponse") }

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
                throw SdkError.Generic(message: "Unexpected type CheckMessageResponse")
            }
        }
        return list
    }

    static func arrayOf(checkMessageResponseList: [CheckMessageResponse]) -> [Any] {
        return checkMessageResponseList.map { v -> [String: Any?] in dictionaryOf(checkMessageResponse: v) }
    }

    static func asClosedChannelPaymentDetails(closedChannelPaymentDetails: [String: Any?]) throws -> ClosedChannelPaymentDetails {
        guard let shortChannelId = closedChannelPaymentDetails["shortChannelId"] as? String else { throw SdkError.Generic(message: "Missing mandatory field shortChannelId for type ClosedChannelPaymentDetails") }
        guard let stateTmp = closedChannelPaymentDetails["state"] as? String else { throw SdkError.Generic(message: "Missing mandatory field state for type ClosedChannelPaymentDetails") }
        let state = try asChannelState(channelState: stateTmp)

        guard let fundingTxid = closedChannelPaymentDetails["fundingTxid"] as? String else { throw SdkError.Generic(message: "Missing mandatory field fundingTxid for type ClosedChannelPaymentDetails") }
        let closingTxid = closedChannelPaymentDetails["closingTxid"] as? String

        return ClosedChannelPaymentDetails(
            shortChannelId: shortChannelId,
            state: state,
            fundingTxid: fundingTxid,
            closingTxid: closingTxid
        )
    }

    static func dictionaryOf(closedChannelPaymentDetails: ClosedChannelPaymentDetails) -> [String: Any?] {
        return [
            "shortChannelId": closedChannelPaymentDetails.shortChannelId,
            "state": valueOf(channelState: closedChannelPaymentDetails.state),
            "fundingTxid": closedChannelPaymentDetails.fundingTxid,
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
                throw SdkError.Generic(message: "Unexpected type ClosedChannelPaymentDetails")
            }
        }
        return list
    }

    static func arrayOf(closedChannelPaymentDetailsList: [ClosedChannelPaymentDetails]) -> [Any] {
        return closedChannelPaymentDetailsList.map { v -> [String: Any?] in dictionaryOf(closedChannelPaymentDetails: v) }
    }

    static func asConfig(config: [String: Any?]) throws -> Config {
        guard let breezserver = config["breezserver"] as? String else { throw SdkError.Generic(message: "Missing mandatory field breezserver for type Config") }
        guard let mempoolspaceUrl = config["mempoolspaceUrl"] as? String else { throw SdkError.Generic(message: "Missing mandatory field mempoolspaceUrl for type Config") }
        guard let workingDir = config["workingDir"] as? String else { throw SdkError.Generic(message: "Missing mandatory field workingDir for type Config") }
        guard let networkTmp = config["network"] as? String else { throw SdkError.Generic(message: "Missing mandatory field network for type Config") }
        let network = try asNetwork(network: networkTmp)

        guard let paymentTimeoutSec = config["paymentTimeoutSec"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field paymentTimeoutSec for type Config") }
        let defaultLspId = config["defaultLspId"] as? String
        let apiKey = config["apiKey"] as? String
        guard let maxfeePercent = config["maxfeePercent"] as? Double else { throw SdkError.Generic(message: "Missing mandatory field maxfeePercent for type Config") }
        guard let exemptfeeMsat = config["exemptfeeMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field exemptfeeMsat for type Config") }
        guard let nodeConfigTmp = config["nodeConfig"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field nodeConfig for type Config") }
        let nodeConfig = try asNodeConfig(nodeConfig: nodeConfigTmp)

        return Config(
            breezserver: breezserver,
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
            "mempoolspaceUrl": config.mempoolspaceUrl,
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
                throw SdkError.Generic(message: "Unexpected type Config")
            }
        }
        return list
    }

    static func arrayOf(configList: [Config]) -> [Any] {
        return configList.map { v -> [String: Any?] in dictionaryOf(config: v) }
    }

    static func asCurrencyInfo(currencyInfo: [String: Any?]) throws -> CurrencyInfo {
        guard let name = currencyInfo["name"] as? String else { throw SdkError.Generic(message: "Missing mandatory field name for type CurrencyInfo") }
        guard let fractionSize = currencyInfo["fractionSize"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field fractionSize for type CurrencyInfo") }
        let spacing = currencyInfo["spacing"] as? UInt32
        var symbol: Symbol?
        if let symbolTmp = currencyInfo["symbol"] as? [String: Any?] {
            symbol = try asSymbol(symbol: symbolTmp)
        }

        var uniqSymbol: Symbol?
        if let uniqSymbolTmp = currencyInfo["uniqSymbol"] as? [String: Any?] {
            uniqSymbol = try asSymbol(symbol: uniqSymbolTmp)
        }

        var localizedName: [LocalizedName]?
        if let localizedNameTmp = currencyInfo["localizedName"] as? [[String: Any?]] {
            localizedName = try asLocalizedNameList(arr: localizedNameTmp)
        }

        var localeOverrides: [LocaleOverrides]?
        if let localeOverridesTmp = currencyInfo["localeOverrides"] as? [[String: Any?]] {
            localeOverrides = try asLocaleOverridesList(arr: localeOverridesTmp)
        }

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
            "localizedName": currencyInfo.localizedName == nil ? nil : arrayOf(localizedNameList: currencyInfo.localizedName!),
            "localeOverrides": currencyInfo.localeOverrides == nil ? nil : arrayOf(localeOverridesList: currencyInfo.localeOverrides!),
        ]
    }

    static func asCurrencyInfoList(arr: [Any]) throws -> [CurrencyInfo] {
        var list = [CurrencyInfo]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var currencyInfo = try asCurrencyInfo(currencyInfo: val)
                list.append(currencyInfo)
            } else {
                throw SdkError.Generic(message: "Unexpected type CurrencyInfo")
            }
        }
        return list
    }

    static func arrayOf(currencyInfoList: [CurrencyInfo]) -> [Any] {
        return currencyInfoList.map { v -> [String: Any?] in dictionaryOf(currencyInfo: v) }
    }

    static func asFiatCurrency(fiatCurrency: [String: Any?]) throws -> FiatCurrency {
        guard let id = fiatCurrency["id"] as? String else { throw SdkError.Generic(message: "Missing mandatory field id for type FiatCurrency") }
        guard let infoTmp = fiatCurrency["info"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field info for type FiatCurrency") }
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
                throw SdkError.Generic(message: "Unexpected type FiatCurrency")
            }
        }
        return list
    }

    static func arrayOf(fiatCurrencyList: [FiatCurrency]) -> [Any] {
        return fiatCurrencyList.map { v -> [String: Any?] in dictionaryOf(fiatCurrency: v) }
    }

    static func asGreenlightCredentials(greenlightCredentials: [String: Any?]) throws -> GreenlightCredentials {
        guard let deviceKey = greenlightCredentials["deviceKey"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field deviceKey for type GreenlightCredentials") }
        guard let deviceCert = greenlightCredentials["deviceCert"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field deviceCert for type GreenlightCredentials") }

        return GreenlightCredentials(
            deviceKey: deviceKey,
            deviceCert: deviceCert
        )
    }

    static func dictionaryOf(greenlightCredentials: GreenlightCredentials) -> [String: Any?] {
        return [
            "deviceKey": greenlightCredentials.deviceKey,
            "deviceCert": greenlightCredentials.deviceCert,
        ]
    }

    static func asGreenlightCredentialsList(arr: [Any]) throws -> [GreenlightCredentials] {
        var list = [GreenlightCredentials]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var greenlightCredentials = try asGreenlightCredentials(greenlightCredentials: val)
                list.append(greenlightCredentials)
            } else {
                throw SdkError.Generic(message: "Unexpected type GreenlightCredentials")
            }
        }
        return list
    }

    static func arrayOf(greenlightCredentialsList: [GreenlightCredentials]) -> [Any] {
        return greenlightCredentialsList.map { v -> [String: Any?] in dictionaryOf(greenlightCredentials: v) }
    }

    static func asGreenlightNodeConfig(greenlightNodeConfig: [String: Any?]) throws -> GreenlightNodeConfig {
        var partnerCredentials: GreenlightCredentials?
        if let partnerCredentialsTmp = greenlightNodeConfig["partnerCredentials"] as? [String: Any?] {
            partnerCredentials = try asGreenlightCredentials(greenlightCredentials: partnerCredentialsTmp)
        }

        let inviteCode = greenlightNodeConfig["inviteCode"] as? String

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
                throw SdkError.Generic(message: "Unexpected type GreenlightNodeConfig")
            }
        }
        return list
    }

    static func arrayOf(greenlightNodeConfigList: [GreenlightNodeConfig]) -> [Any] {
        return greenlightNodeConfigList.map { v -> [String: Any?] in dictionaryOf(greenlightNodeConfig: v) }
    }

    static func asInvoicePaidDetails(invoicePaidDetails: [String: Any?]) throws -> InvoicePaidDetails {
        guard let paymentHash = invoicePaidDetails["paymentHash"] as? String else { throw SdkError.Generic(message: "Missing mandatory field paymentHash for type InvoicePaidDetails") }
        guard let bolt11 = invoicePaidDetails["bolt11"] as? String else { throw SdkError.Generic(message: "Missing mandatory field bolt11 for type InvoicePaidDetails") }

        return InvoicePaidDetails(
            paymentHash: paymentHash,
            bolt11: bolt11
        )
    }

    static func dictionaryOf(invoicePaidDetails: InvoicePaidDetails) -> [String: Any?] {
        return [
            "paymentHash": invoicePaidDetails.paymentHash,
            "bolt11": invoicePaidDetails.bolt11,
        ]
    }

    static func asInvoicePaidDetailsList(arr: [Any]) throws -> [InvoicePaidDetails] {
        var list = [InvoicePaidDetails]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var invoicePaidDetails = try asInvoicePaidDetails(invoicePaidDetails: val)
                list.append(invoicePaidDetails)
            } else {
                throw SdkError.Generic(message: "Unexpected type InvoicePaidDetails")
            }
        }
        return list
    }

    static func arrayOf(invoicePaidDetailsList: [InvoicePaidDetails]) -> [Any] {
        return invoicePaidDetailsList.map { v -> [String: Any?] in dictionaryOf(invoicePaidDetails: v) }
    }

    static func asLnInvoice(lnInvoice: [String: Any?]) throws -> LnInvoice {
        guard let bolt11 = lnInvoice["bolt11"] as? String else { throw SdkError.Generic(message: "Missing mandatory field bolt11 for type LnInvoice") }
        guard let payeePubkey = lnInvoice["payeePubkey"] as? String else { throw SdkError.Generic(message: "Missing mandatory field payeePubkey for type LnInvoice") }
        guard let paymentHash = lnInvoice["paymentHash"] as? String else { throw SdkError.Generic(message: "Missing mandatory field paymentHash for type LnInvoice") }
        let description = lnInvoice["description"] as? String
        let descriptionHash = lnInvoice["descriptionHash"] as? String
        let amountMsat = lnInvoice["amountMsat"] as? UInt64
        guard let timestamp = lnInvoice["timestamp"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field timestamp for type LnInvoice") }
        guard let expiry = lnInvoice["expiry"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field expiry for type LnInvoice") }
        guard let routingHintsTmp = lnInvoice["routingHints"] as? [[String: Any?]] else { throw SdkError.Generic(message: "Missing mandatory field routingHints for type LnInvoice") }
        let routingHints = try asRouteHintList(arr: routingHintsTmp)

        guard let paymentSecret = lnInvoice["paymentSecret"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field paymentSecret for type LnInvoice") }

        return LnInvoice(
            bolt11: bolt11,
            payeePubkey: payeePubkey,
            paymentHash: paymentHash,
            description: description,
            descriptionHash: descriptionHash,
            amountMsat: amountMsat,
            timestamp: timestamp,
            expiry: expiry,
            routingHints: routingHints,
            paymentSecret: paymentSecret
        )
    }

    static func dictionaryOf(lnInvoice: LnInvoice) -> [String: Any?] {
        return [
            "bolt11": lnInvoice.bolt11,
            "payeePubkey": lnInvoice.payeePubkey,
            "paymentHash": lnInvoice.paymentHash,
            "description": lnInvoice.description == nil ? nil : lnInvoice.description,
            "descriptionHash": lnInvoice.descriptionHash == nil ? nil : lnInvoice.descriptionHash,
            "amountMsat": lnInvoice.amountMsat == nil ? nil : lnInvoice.amountMsat,
            "timestamp": lnInvoice.timestamp,
            "expiry": lnInvoice.expiry,
            "routingHints": arrayOf(routeHintList: lnInvoice.routingHints),
            "paymentSecret": lnInvoice.paymentSecret,
        ]
    }

    static func asLnInvoiceList(arr: [Any]) throws -> [LnInvoice] {
        var list = [LnInvoice]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnInvoice = try asLnInvoice(lnInvoice: val)
                list.append(lnInvoice)
            } else {
                throw SdkError.Generic(message: "Unexpected type LnInvoice")
            }
        }
        return list
    }

    static func arrayOf(lnInvoiceList: [LnInvoice]) -> [Any] {
        return lnInvoiceList.map { v -> [String: Any?] in dictionaryOf(lnInvoice: v) }
    }

    static func asListPaymentsRequest(listPaymentsRequest: [String: Any?]) throws -> ListPaymentsRequest {
        var filters: [PaymentTypeFilter]?
        if let filtersTmp = listPaymentsRequest["filters"] as? [String] {
            filters = try asPaymentTypeFilterList(arr: filtersTmp)
        }

        let fromTimestamp = listPaymentsRequest["fromTimestamp"] as? Int64
        let toTimestamp = listPaymentsRequest["toTimestamp"] as? Int64
        let includeFailures = listPaymentsRequest["includeFailures"] as? Bool
        let offset = listPaymentsRequest["offset"] as? UInt32
        let limit = listPaymentsRequest["limit"] as? UInt32

        return ListPaymentsRequest(
            filters: filters,
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
                throw SdkError.Generic(message: "Unexpected type ListPaymentsRequest")
            }
        }
        return list
    }

    static func arrayOf(listPaymentsRequestList: [ListPaymentsRequest]) -> [Any] {
        return listPaymentsRequestList.map { v -> [String: Any?] in dictionaryOf(listPaymentsRequest: v) }
    }

    static func asLnPaymentDetails(lnPaymentDetails: [String: Any?]) throws -> LnPaymentDetails {
        guard let paymentHash = lnPaymentDetails["paymentHash"] as? String else { throw SdkError.Generic(message: "Missing mandatory field paymentHash for type LnPaymentDetails") }
        guard let label = lnPaymentDetails["label"] as? String else { throw SdkError.Generic(message: "Missing mandatory field label for type LnPaymentDetails") }
        guard let destinationPubkey = lnPaymentDetails["destinationPubkey"] as? String else { throw SdkError.Generic(message: "Missing mandatory field destinationPubkey for type LnPaymentDetails") }
        guard let paymentPreimage = lnPaymentDetails["paymentPreimage"] as? String else { throw SdkError.Generic(message: "Missing mandatory field paymentPreimage for type LnPaymentDetails") }
        guard let keysend = lnPaymentDetails["keysend"] as? Bool else { throw SdkError.Generic(message: "Missing mandatory field keysend for type LnPaymentDetails") }
        guard let bolt11 = lnPaymentDetails["bolt11"] as? String else { throw SdkError.Generic(message: "Missing mandatory field bolt11 for type LnPaymentDetails") }
        var lnurlSuccessAction: SuccessActionProcessed?
        if let lnurlSuccessActionTmp = lnPaymentDetails["lnurlSuccessAction"] as? [String: Any?] {
            lnurlSuccessAction = try asSuccessActionProcessed(successActionProcessed: lnurlSuccessActionTmp)
        }

        let lnurlMetadata = lnPaymentDetails["lnurlMetadata"] as? String
        let lnAddress = lnPaymentDetails["lnAddress"] as? String
        let lnurlWithdrawEndpoint = lnPaymentDetails["lnurlWithdrawEndpoint"] as? String

        return LnPaymentDetails(
            paymentHash: paymentHash,
            label: label,
            destinationPubkey: destinationPubkey,
            paymentPreimage: paymentPreimage,
            keysend: keysend,
            bolt11: bolt11,
            lnurlSuccessAction: lnurlSuccessAction,
            lnurlMetadata: lnurlMetadata,
            lnAddress: lnAddress,
            lnurlWithdrawEndpoint: lnurlWithdrawEndpoint
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
            "lnurlSuccessAction": lnPaymentDetails.lnurlSuccessAction == nil ? nil : dictionaryOf(successActionProcessed: lnPaymentDetails.lnurlSuccessAction!),
            "lnurlMetadata": lnPaymentDetails.lnurlMetadata == nil ? nil : lnPaymentDetails.lnurlMetadata,
            "lnAddress": lnPaymentDetails.lnAddress == nil ? nil : lnPaymentDetails.lnAddress,
            "lnurlWithdrawEndpoint": lnPaymentDetails.lnurlWithdrawEndpoint == nil ? nil : lnPaymentDetails.lnurlWithdrawEndpoint,
        ]
    }

    static func asLnPaymentDetailsList(arr: [Any]) throws -> [LnPaymentDetails] {
        var list = [LnPaymentDetails]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnPaymentDetails = try asLnPaymentDetails(lnPaymentDetails: val)
                list.append(lnPaymentDetails)
            } else {
                throw SdkError.Generic(message: "Unexpected type LnPaymentDetails")
            }
        }
        return list
    }

    static func arrayOf(lnPaymentDetailsList: [LnPaymentDetails]) -> [Any] {
        return lnPaymentDetailsList.map { v -> [String: Any?] in dictionaryOf(lnPaymentDetails: v) }
    }

    static func asLnUrlAuthRequestData(lnUrlAuthRequestData: [String: Any?]) throws -> LnUrlAuthRequestData {
        guard let k1 = lnUrlAuthRequestData["k1"] as? String else { throw SdkError.Generic(message: "Missing mandatory field k1 for type LnUrlAuthRequestData") }
        let action = lnUrlAuthRequestData["action"] as? String
        guard let domain = lnUrlAuthRequestData["domain"] as? String else { throw SdkError.Generic(message: "Missing mandatory field domain for type LnUrlAuthRequestData") }
        guard let url = lnUrlAuthRequestData["url"] as? String else { throw SdkError.Generic(message: "Missing mandatory field url for type LnUrlAuthRequestData") }

        return LnUrlAuthRequestData(
            k1: k1,
            action: action,
            domain: domain,
            url: url
        )
    }

    static func dictionaryOf(lnUrlAuthRequestData: LnUrlAuthRequestData) -> [String: Any?] {
        return [
            "k1": lnUrlAuthRequestData.k1,
            "action": lnUrlAuthRequestData.action == nil ? nil : lnUrlAuthRequestData.action,
            "domain": lnUrlAuthRequestData.domain,
            "url": lnUrlAuthRequestData.url,
        ]
    }

    static func asLnUrlAuthRequestDataList(arr: [Any]) throws -> [LnUrlAuthRequestData] {
        var list = [LnUrlAuthRequestData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlAuthRequestData = try asLnUrlAuthRequestData(lnUrlAuthRequestData: val)
                list.append(lnUrlAuthRequestData)
            } else {
                throw SdkError.Generic(message: "Unexpected type LnUrlAuthRequestData")
            }
        }
        return list
    }

    static func arrayOf(lnUrlAuthRequestDataList: [LnUrlAuthRequestData]) -> [Any] {
        return lnUrlAuthRequestDataList.map { v -> [String: Any?] in dictionaryOf(lnUrlAuthRequestData: v) }
    }

    static func asLnUrlErrorData(lnUrlErrorData: [String: Any?]) throws -> LnUrlErrorData {
        guard let reason = lnUrlErrorData["reason"] as? String else { throw SdkError.Generic(message: "Missing mandatory field reason for type LnUrlErrorData") }

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
                throw SdkError.Generic(message: "Unexpected type LnUrlErrorData")
            }
        }
        return list
    }

    static func arrayOf(lnUrlErrorDataList: [LnUrlErrorData]) -> [Any] {
        return lnUrlErrorDataList.map { v -> [String: Any?] in dictionaryOf(lnUrlErrorData: v) }
    }

    static func asLnUrlPayErrorData(lnUrlPayErrorData: [String: Any?]) throws -> LnUrlPayErrorData {
        guard let paymentHash = lnUrlPayErrorData["paymentHash"] as? String else { throw SdkError.Generic(message: "Missing mandatory field paymentHash for type LnUrlPayErrorData") }
        guard let reason = lnUrlPayErrorData["reason"] as? String else { throw SdkError.Generic(message: "Missing mandatory field reason for type LnUrlPayErrorData") }

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
                throw SdkError.Generic(message: "Unexpected type LnUrlPayErrorData")
            }
        }
        return list
    }

    static func arrayOf(lnUrlPayErrorDataList: [LnUrlPayErrorData]) -> [Any] {
        return lnUrlPayErrorDataList.map { v -> [String: Any?] in dictionaryOf(lnUrlPayErrorData: v) }
    }

    static func asLnUrlPayRequest(lnUrlPayRequest: [String: Any?]) throws -> LnUrlPayRequest {
        guard let dataTmp = lnUrlPayRequest["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type LnUrlPayRequest") }
        let data = try asLnUrlPayRequestData(lnUrlPayRequestData: dataTmp)

        guard let amountMsat = lnUrlPayRequest["amountMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field amountMsat for type LnUrlPayRequest") }
        let comment = lnUrlPayRequest["comment"] as? String

        return LnUrlPayRequest(
            data: data,
            amountMsat: amountMsat,
            comment: comment
        )
    }

    static func dictionaryOf(lnUrlPayRequest: LnUrlPayRequest) -> [String: Any?] {
        return [
            "data": dictionaryOf(lnUrlPayRequestData: lnUrlPayRequest.data),
            "amountMsat": lnUrlPayRequest.amountMsat,
            "comment": lnUrlPayRequest.comment == nil ? nil : lnUrlPayRequest.comment,
        ]
    }

    static func asLnUrlPayRequestList(arr: [Any]) throws -> [LnUrlPayRequest] {
        var list = [LnUrlPayRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlPayRequest = try asLnUrlPayRequest(lnUrlPayRequest: val)
                list.append(lnUrlPayRequest)
            } else {
                throw SdkError.Generic(message: "Unexpected type LnUrlPayRequest")
            }
        }
        return list
    }

    static func arrayOf(lnUrlPayRequestList: [LnUrlPayRequest]) -> [Any] {
        return lnUrlPayRequestList.map { v -> [String: Any?] in dictionaryOf(lnUrlPayRequest: v) }
    }

    static func asLnUrlPayRequestData(lnUrlPayRequestData: [String: Any?]) throws -> LnUrlPayRequestData {
        guard let callback = lnUrlPayRequestData["callback"] as? String else { throw SdkError.Generic(message: "Missing mandatory field callback for type LnUrlPayRequestData") }
        guard let minSendable = lnUrlPayRequestData["minSendable"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field minSendable for type LnUrlPayRequestData") }
        guard let maxSendable = lnUrlPayRequestData["maxSendable"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field maxSendable for type LnUrlPayRequestData") }
        guard let metadataStr = lnUrlPayRequestData["metadataStr"] as? String else { throw SdkError.Generic(message: "Missing mandatory field metadataStr for type LnUrlPayRequestData") }
        guard let commentAllowed = lnUrlPayRequestData["commentAllowed"] as? UInt16 else { throw SdkError.Generic(message: "Missing mandatory field commentAllowed for type LnUrlPayRequestData") }
        guard let domain = lnUrlPayRequestData["domain"] as? String else { throw SdkError.Generic(message: "Missing mandatory field domain for type LnUrlPayRequestData") }
        let lnAddress = lnUrlPayRequestData["lnAddress"] as? String

        return LnUrlPayRequestData(
            callback: callback,
            minSendable: minSendable,
            maxSendable: maxSendable,
            metadataStr: metadataStr,
            commentAllowed: commentAllowed,
            domain: domain,
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
                throw SdkError.Generic(message: "Unexpected type LnUrlPayRequestData")
            }
        }
        return list
    }

    static func arrayOf(lnUrlPayRequestDataList: [LnUrlPayRequestData]) -> [Any] {
        return lnUrlPayRequestDataList.map { v -> [String: Any?] in dictionaryOf(lnUrlPayRequestData: v) }
    }

    static func asLnUrlPaySuccessData(lnUrlPaySuccessData: [String: Any?]) throws -> LnUrlPaySuccessData {
        var successAction: SuccessActionProcessed?
        if let successActionTmp = lnUrlPaySuccessData["successAction"] as? [String: Any?] {
            successAction = try asSuccessActionProcessed(successActionProcessed: successActionTmp)
        }

        guard let paymentHash = lnUrlPaySuccessData["paymentHash"] as? String else { throw SdkError.Generic(message: "Missing mandatory field paymentHash for type LnUrlPaySuccessData") }

        return LnUrlPaySuccessData(
            successAction: successAction,
            paymentHash: paymentHash
        )
    }

    static func dictionaryOf(lnUrlPaySuccessData: LnUrlPaySuccessData) -> [String: Any?] {
        return [
            "successAction": lnUrlPaySuccessData.successAction == nil ? nil : dictionaryOf(successActionProcessed: lnUrlPaySuccessData.successAction!),
            "paymentHash": lnUrlPaySuccessData.paymentHash,
        ]
    }

    static func asLnUrlPaySuccessDataList(arr: [Any]) throws -> [LnUrlPaySuccessData] {
        var list = [LnUrlPaySuccessData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlPaySuccessData = try asLnUrlPaySuccessData(lnUrlPaySuccessData: val)
                list.append(lnUrlPaySuccessData)
            } else {
                throw SdkError.Generic(message: "Unexpected type LnUrlPaySuccessData")
            }
        }
        return list
    }

    static func arrayOf(lnUrlPaySuccessDataList: [LnUrlPaySuccessData]) -> [Any] {
        return lnUrlPaySuccessDataList.map { v -> [String: Any?] in dictionaryOf(lnUrlPaySuccessData: v) }
    }

    static func asLnUrlWithdrawRequest(lnUrlWithdrawRequest: [String: Any?]) throws -> LnUrlWithdrawRequest {
        guard let dataTmp = lnUrlWithdrawRequest["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type LnUrlWithdrawRequest") }
        let data = try asLnUrlWithdrawRequestData(lnUrlWithdrawRequestData: dataTmp)

        guard let amountMsat = lnUrlWithdrawRequest["amountMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field amountMsat for type LnUrlWithdrawRequest") }
        let description = lnUrlWithdrawRequest["description"] as? String

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
                throw SdkError.Generic(message: "Unexpected type LnUrlWithdrawRequest")
            }
        }
        return list
    }

    static func arrayOf(lnUrlWithdrawRequestList: [LnUrlWithdrawRequest]) -> [Any] {
        return lnUrlWithdrawRequestList.map { v -> [String: Any?] in dictionaryOf(lnUrlWithdrawRequest: v) }
    }

    static func asLnUrlWithdrawRequestData(lnUrlWithdrawRequestData: [String: Any?]) throws -> LnUrlWithdrawRequestData {
        guard let callback = lnUrlWithdrawRequestData["callback"] as? String else { throw SdkError.Generic(message: "Missing mandatory field callback for type LnUrlWithdrawRequestData") }
        guard let k1 = lnUrlWithdrawRequestData["k1"] as? String else { throw SdkError.Generic(message: "Missing mandatory field k1 for type LnUrlWithdrawRequestData") }
        guard let defaultDescription = lnUrlWithdrawRequestData["defaultDescription"] as? String else { throw SdkError.Generic(message: "Missing mandatory field defaultDescription for type LnUrlWithdrawRequestData") }
        guard let minWithdrawable = lnUrlWithdrawRequestData["minWithdrawable"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field minWithdrawable for type LnUrlWithdrawRequestData") }
        guard let maxWithdrawable = lnUrlWithdrawRequestData["maxWithdrawable"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field maxWithdrawable for type LnUrlWithdrawRequestData") }

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
                throw SdkError.Generic(message: "Unexpected type LnUrlWithdrawRequestData")
            }
        }
        return list
    }

    static func arrayOf(lnUrlWithdrawRequestDataList: [LnUrlWithdrawRequestData]) -> [Any] {
        return lnUrlWithdrawRequestDataList.map { v -> [String: Any?] in dictionaryOf(lnUrlWithdrawRequestData: v) }
    }

    static func asLnUrlWithdrawSuccessData(lnUrlWithdrawSuccessData: [String: Any?]) throws -> LnUrlWithdrawSuccessData {
        guard let invoiceTmp = lnUrlWithdrawSuccessData["invoice"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field invoice for type LnUrlWithdrawSuccessData") }
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
                throw SdkError.Generic(message: "Unexpected type LnUrlWithdrawSuccessData")
            }
        }
        return list
    }

    static func arrayOf(lnUrlWithdrawSuccessDataList: [LnUrlWithdrawSuccessData]) -> [Any] {
        return lnUrlWithdrawSuccessDataList.map { v -> [String: Any?] in dictionaryOf(lnUrlWithdrawSuccessData: v) }
    }

    static func asLocaleOverrides(localeOverrides: [String: Any?]) throws -> LocaleOverrides {
        guard let locale = localeOverrides["locale"] as? String else { throw SdkError.Generic(message: "Missing mandatory field locale for type LocaleOverrides") }
        let spacing = localeOverrides["spacing"] as? UInt32
        guard let symbolTmp = localeOverrides["symbol"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field symbol for type LocaleOverrides") }
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
                throw SdkError.Generic(message: "Unexpected type LocaleOverrides")
            }
        }
        return list
    }

    static func arrayOf(localeOverridesList: [LocaleOverrides]) -> [Any] {
        return localeOverridesList.map { v -> [String: Any?] in dictionaryOf(localeOverrides: v) }
    }

    static func asLocalizedName(localizedName: [String: Any?]) throws -> LocalizedName {
        guard let locale = localizedName["locale"] as? String else { throw SdkError.Generic(message: "Missing mandatory field locale for type LocalizedName") }
        guard let name = localizedName["name"] as? String else { throw SdkError.Generic(message: "Missing mandatory field name for type LocalizedName") }

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
                throw SdkError.Generic(message: "Unexpected type LocalizedName")
            }
        }
        return list
    }

    static func arrayOf(localizedNameList: [LocalizedName]) -> [Any] {
        return localizedNameList.map { v -> [String: Any?] in dictionaryOf(localizedName: v) }
    }

    static func asLogEntry(logEntry: [String: Any?]) throws -> LogEntry {
        guard let line = logEntry["line"] as? String else { throw SdkError.Generic(message: "Missing mandatory field line for type LogEntry") }
        guard let level = logEntry["level"] as? String else { throw SdkError.Generic(message: "Missing mandatory field level for type LogEntry") }

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
                throw SdkError.Generic(message: "Unexpected type LogEntry")
            }
        }
        return list
    }

    static func arrayOf(logEntryList: [LogEntry]) -> [Any] {
        return logEntryList.map { v -> [String: Any?] in dictionaryOf(logEntry: v) }
    }

    static func asLspInformation(lspInformation: [String: Any?]) throws -> LspInformation {
        guard let id = lspInformation["id"] as? String else { throw SdkError.Generic(message: "Missing mandatory field id for type LspInformation") }
        guard let name = lspInformation["name"] as? String else { throw SdkError.Generic(message: "Missing mandatory field name for type LspInformation") }
        guard let widgetUrl = lspInformation["widgetUrl"] as? String else { throw SdkError.Generic(message: "Missing mandatory field widgetUrl for type LspInformation") }
        guard let pubkey = lspInformation["pubkey"] as? String else { throw SdkError.Generic(message: "Missing mandatory field pubkey for type LspInformation") }
        guard let host = lspInformation["host"] as? String else { throw SdkError.Generic(message: "Missing mandatory field host for type LspInformation") }
        guard let channelCapacity = lspInformation["channelCapacity"] as? Int64 else { throw SdkError.Generic(message: "Missing mandatory field channelCapacity for type LspInformation") }
        guard let targetConf = lspInformation["targetConf"] as? Int32 else { throw SdkError.Generic(message: "Missing mandatory field targetConf for type LspInformation") }
        guard let baseFeeMsat = lspInformation["baseFeeMsat"] as? Int64 else { throw SdkError.Generic(message: "Missing mandatory field baseFeeMsat for type LspInformation") }
        guard let feeRate = lspInformation["feeRate"] as? Double else { throw SdkError.Generic(message: "Missing mandatory field feeRate for type LspInformation") }
        guard let timeLockDelta = lspInformation["timeLockDelta"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field timeLockDelta for type LspInformation") }
        guard let minHtlcMsat = lspInformation["minHtlcMsat"] as? Int64 else { throw SdkError.Generic(message: "Missing mandatory field minHtlcMsat for type LspInformation") }
        guard let lspPubkey = lspInformation["lspPubkey"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field lspPubkey for type LspInformation") }
        guard let openingFeeParamsListTmp = lspInformation["openingFeeParamsList"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field openingFeeParamsList for type LspInformation") }
        let openingFeeParamsList = try asOpeningFeeParamsMenu(openingFeeParamsMenu: openingFeeParamsListTmp)

        return LspInformation(
            id: id,
            name: name,
            widgetUrl: widgetUrl,
            pubkey: pubkey,
            host: host,
            channelCapacity: channelCapacity,
            targetConf: targetConf,
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
            "channelCapacity": lspInformation.channelCapacity,
            "targetConf": lspInformation.targetConf,
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
                throw SdkError.Generic(message: "Unexpected type LspInformation")
            }
        }
        return list
    }

    static func arrayOf(lspInformationList: [LspInformation]) -> [Any] {
        return lspInformationList.map { v -> [String: Any?] in dictionaryOf(lspInformation: v) }
    }

    static func asMessageSuccessActionData(messageSuccessActionData: [String: Any?]) throws -> MessageSuccessActionData {
        guard let message = messageSuccessActionData["message"] as? String else { throw SdkError.Generic(message: "Missing mandatory field message for type MessageSuccessActionData") }

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
                throw SdkError.Generic(message: "Unexpected type MessageSuccessActionData")
            }
        }
        return list
    }

    static func arrayOf(messageSuccessActionDataList: [MessageSuccessActionData]) -> [Any] {
        return messageSuccessActionDataList.map { v -> [String: Any?] in dictionaryOf(messageSuccessActionData: v) }
    }

    static func asMetadataItem(metadataItem: [String: Any?]) throws -> MetadataItem {
        guard let key = metadataItem["key"] as? String else { throw SdkError.Generic(message: "Missing mandatory field key for type MetadataItem") }
        guard let value = metadataItem["value"] as? String else { throw SdkError.Generic(message: "Missing mandatory field value for type MetadataItem") }

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
                throw SdkError.Generic(message: "Unexpected type MetadataItem")
            }
        }
        return list
    }

    static func arrayOf(metadataItemList: [MetadataItem]) -> [Any] {
        return metadataItemList.map { v -> [String: Any?] in dictionaryOf(metadataItem: v) }
    }

    static func asNodeState(nodeState: [String: Any?]) throws -> NodeState {
        guard let id = nodeState["id"] as? String else { throw SdkError.Generic(message: "Missing mandatory field id for type NodeState") }
        guard let blockHeight = nodeState["blockHeight"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field blockHeight for type NodeState") }
        guard let channelsBalanceMsat = nodeState["channelsBalanceMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field channelsBalanceMsat for type NodeState") }
        guard let onchainBalanceMsat = nodeState["onchainBalanceMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field onchainBalanceMsat for type NodeState") }
        guard let utxosTmp = nodeState["utxos"] as? [[String: Any?]] else { throw SdkError.Generic(message: "Missing mandatory field utxos for type NodeState") }
        let utxos = try asUnspentTransactionOutputList(arr: utxosTmp)

        guard let maxPayableMsat = nodeState["maxPayableMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field maxPayableMsat for type NodeState") }
        guard let maxReceivableMsat = nodeState["maxReceivableMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field maxReceivableMsat for type NodeState") }
        guard let maxSinglePaymentAmountMsat = nodeState["maxSinglePaymentAmountMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field maxSinglePaymentAmountMsat for type NodeState") }
        guard let maxChanReserveMsats = nodeState["maxChanReserveMsats"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field maxChanReserveMsats for type NodeState") }
        guard let connectedPeers = nodeState["connectedPeers"] as? [String] else { throw SdkError.Generic(message: "Missing mandatory field connectedPeers for type NodeState") }
        guard let inboundLiquidityMsats = nodeState["inboundLiquidityMsats"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field inboundLiquidityMsats for type NodeState") }

        return NodeState(
            id: id,
            blockHeight: blockHeight,
            channelsBalanceMsat: channelsBalanceMsat,
            onchainBalanceMsat: onchainBalanceMsat,
            utxos: utxos,
            maxPayableMsat: maxPayableMsat,
            maxReceivableMsat: maxReceivableMsat,
            maxSinglePaymentAmountMsat: maxSinglePaymentAmountMsat,
            maxChanReserveMsats: maxChanReserveMsats,
            connectedPeers: connectedPeers,
            inboundLiquidityMsats: inboundLiquidityMsats
        )
    }

    static func dictionaryOf(nodeState: NodeState) -> [String: Any?] {
        return [
            "id": nodeState.id,
            "blockHeight": nodeState.blockHeight,
            "channelsBalanceMsat": nodeState.channelsBalanceMsat,
            "onchainBalanceMsat": nodeState.onchainBalanceMsat,
            "utxos": arrayOf(unspentTransactionOutputList: nodeState.utxos),
            "maxPayableMsat": nodeState.maxPayableMsat,
            "maxReceivableMsat": nodeState.maxReceivableMsat,
            "maxSinglePaymentAmountMsat": nodeState.maxSinglePaymentAmountMsat,
            "maxChanReserveMsats": nodeState.maxChanReserveMsats,
            "connectedPeers": nodeState.connectedPeers,
            "inboundLiquidityMsats": nodeState.inboundLiquidityMsats,
        ]
    }

    static func asNodeStateList(arr: [Any]) throws -> [NodeState] {
        var list = [NodeState]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var nodeState = try asNodeState(nodeState: val)
                list.append(nodeState)
            } else {
                throw SdkError.Generic(message: "Unexpected type NodeState")
            }
        }
        return list
    }

    static func arrayOf(nodeStateList: [NodeState]) -> [Any] {
        return nodeStateList.map { v -> [String: Any?] in dictionaryOf(nodeState: v) }
    }

    static func asOpenChannelFeeRequest(openChannelFeeRequest: [String: Any?]) throws -> OpenChannelFeeRequest {
        guard let amountMsat = openChannelFeeRequest["amountMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field amountMsat for type OpenChannelFeeRequest") }
        let expiry = openChannelFeeRequest["expiry"] as? UInt32

        return OpenChannelFeeRequest(
            amountMsat: amountMsat,
            expiry: expiry
        )
    }

    static func dictionaryOf(openChannelFeeRequest: OpenChannelFeeRequest) -> [String: Any?] {
        return [
            "amountMsat": openChannelFeeRequest.amountMsat,
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
                throw SdkError.Generic(message: "Unexpected type OpenChannelFeeRequest")
            }
        }
        return list
    }

    static func arrayOf(openChannelFeeRequestList: [OpenChannelFeeRequest]) -> [Any] {
        return openChannelFeeRequestList.map { v -> [String: Any?] in dictionaryOf(openChannelFeeRequest: v) }
    }

    static func asOpenChannelFeeResponse(openChannelFeeResponse: [String: Any?]) throws -> OpenChannelFeeResponse {
        guard let feeMsat = openChannelFeeResponse["feeMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field feeMsat for type OpenChannelFeeResponse") }
        var usedFeeParams: OpeningFeeParams?
        if let usedFeeParamsTmp = openChannelFeeResponse["usedFeeParams"] as? [String: Any?] {
            usedFeeParams = try asOpeningFeeParams(openingFeeParams: usedFeeParamsTmp)
        }

        return OpenChannelFeeResponse(
            feeMsat: feeMsat,
            usedFeeParams: usedFeeParams
        )
    }

    static func dictionaryOf(openChannelFeeResponse: OpenChannelFeeResponse) -> [String: Any?] {
        return [
            "feeMsat": openChannelFeeResponse.feeMsat,
            "usedFeeParams": openChannelFeeResponse.usedFeeParams == nil ? nil : dictionaryOf(openingFeeParams: openChannelFeeResponse.usedFeeParams!),
        ]
    }

    static func asOpenChannelFeeResponseList(arr: [Any]) throws -> [OpenChannelFeeResponse] {
        var list = [OpenChannelFeeResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var openChannelFeeResponse = try asOpenChannelFeeResponse(openChannelFeeResponse: val)
                list.append(openChannelFeeResponse)
            } else {
                throw SdkError.Generic(message: "Unexpected type OpenChannelFeeResponse")
            }
        }
        return list
    }

    static func arrayOf(openChannelFeeResponseList: [OpenChannelFeeResponse]) -> [Any] {
        return openChannelFeeResponseList.map { v -> [String: Any?] in dictionaryOf(openChannelFeeResponse: v) }
    }

    static func asOpeningFeeParams(openingFeeParams: [String: Any?]) throws -> OpeningFeeParams {
        guard let minMsat = openingFeeParams["minMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field minMsat for type OpeningFeeParams") }
        guard let proportional = openingFeeParams["proportional"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field proportional for type OpeningFeeParams") }
        guard let validUntil = openingFeeParams["validUntil"] as? String else { throw SdkError.Generic(message: "Missing mandatory field validUntil for type OpeningFeeParams") }
        guard let maxIdleTime = openingFeeParams["maxIdleTime"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field maxIdleTime for type OpeningFeeParams") }
        guard let maxClientToSelfDelay = openingFeeParams["maxClientToSelfDelay"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field maxClientToSelfDelay for type OpeningFeeParams") }
        guard let promise = openingFeeParams["promise"] as? String else { throw SdkError.Generic(message: "Missing mandatory field promise for type OpeningFeeParams") }

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
                throw SdkError.Generic(message: "Unexpected type OpeningFeeParams")
            }
        }
        return list
    }

    static func arrayOf(openingFeeParamsList: [OpeningFeeParams]) -> [Any] {
        return openingFeeParamsList.map { v -> [String: Any?] in dictionaryOf(openingFeeParams: v) }
    }

    static func asOpeningFeeParamsMenu(openingFeeParamsMenu: [String: Any?]) throws -> OpeningFeeParamsMenu {
        guard let valuesTmp = openingFeeParamsMenu["values"] as? [[String: Any?]] else { throw SdkError.Generic(message: "Missing mandatory field values for type OpeningFeeParamsMenu") }
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
                throw SdkError.Generic(message: "Unexpected type OpeningFeeParamsMenu")
            }
        }
        return list
    }

    static func arrayOf(openingFeeParamsMenuList: [OpeningFeeParamsMenu]) -> [Any] {
        return openingFeeParamsMenuList.map { v -> [String: Any?] in dictionaryOf(openingFeeParamsMenu: v) }
    }

    static func asPayment(payment: [String: Any?]) throws -> Payment {
        guard let id = payment["id"] as? String else { throw SdkError.Generic(message: "Missing mandatory field id for type Payment") }
        guard let paymentTypeTmp = payment["paymentType"] as? String else { throw SdkError.Generic(message: "Missing mandatory field paymentType for type Payment") }
        let paymentType = try asPaymentType(paymentType: paymentTypeTmp)

        guard let paymentTime = payment["paymentTime"] as? Int64 else { throw SdkError.Generic(message: "Missing mandatory field paymentTime for type Payment") }
        guard let amountMsat = payment["amountMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field amountMsat for type Payment") }
        guard let feeMsat = payment["feeMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field feeMsat for type Payment") }
        guard let statusTmp = payment["status"] as? String else { throw SdkError.Generic(message: "Missing mandatory field status for type Payment") }
        let status = try asPaymentStatus(paymentStatus: statusTmp)

        let description = payment["description"] as? String
        guard let detailsTmp = payment["details"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field details for type Payment") }
        let details = try asPaymentDetails(paymentDetails: detailsTmp)

        return Payment(
            id: id,
            paymentType: paymentType,
            paymentTime: paymentTime,
            amountMsat: amountMsat,
            feeMsat: feeMsat,
            status: status,
            description: description,
            details: details
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
            "description": payment.description == nil ? nil : payment.description,
            "details": dictionaryOf(paymentDetails: payment.details),
        ]
    }

    static func asPaymentList(arr: [Any]) throws -> [Payment] {
        var list = [Payment]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var payment = try asPayment(payment: val)
                list.append(payment)
            } else {
                throw SdkError.Generic(message: "Unexpected type Payment")
            }
        }
        return list
    }

    static func arrayOf(paymentList: [Payment]) -> [Any] {
        return paymentList.map { v -> [String: Any?] in dictionaryOf(payment: v) }
    }

    static func asPaymentFailedData(paymentFailedData: [String: Any?]) throws -> PaymentFailedData {
        guard let error = paymentFailedData["error"] as? String else { throw SdkError.Generic(message: "Missing mandatory field error for type PaymentFailedData") }
        guard let nodeId = paymentFailedData["nodeId"] as? String else { throw SdkError.Generic(message: "Missing mandatory field nodeId for type PaymentFailedData") }
        var invoice: LnInvoice?
        if let invoiceTmp = paymentFailedData["invoice"] as? [String: Any?] {
            invoice = try asLnInvoice(lnInvoice: invoiceTmp)
        }

        return PaymentFailedData(
            error: error,
            nodeId: nodeId,
            invoice: invoice
        )
    }

    static func dictionaryOf(paymentFailedData: PaymentFailedData) -> [String: Any?] {
        return [
            "error": paymentFailedData.error,
            "nodeId": paymentFailedData.nodeId,
            "invoice": paymentFailedData.invoice == nil ? nil : dictionaryOf(lnInvoice: paymentFailedData.invoice!),
        ]
    }

    static func asPaymentFailedDataList(arr: [Any]) throws -> [PaymentFailedData] {
        var list = [PaymentFailedData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var paymentFailedData = try asPaymentFailedData(paymentFailedData: val)
                list.append(paymentFailedData)
            } else {
                throw SdkError.Generic(message: "Unexpected type PaymentFailedData")
            }
        }
        return list
    }

    static func arrayOf(paymentFailedDataList: [PaymentFailedData]) -> [Any] {
        return paymentFailedDataList.map { v -> [String: Any?] in dictionaryOf(paymentFailedData: v) }
    }

    static func asPrepareRefundRequest(prepareRefundRequest: [String: Any?]) throws -> PrepareRefundRequest {
        guard let swapAddress = prepareRefundRequest["swapAddress"] as? String else { throw SdkError.Generic(message: "Missing mandatory field swapAddress for type PrepareRefundRequest") }
        guard let toAddress = prepareRefundRequest["toAddress"] as? String else { throw SdkError.Generic(message: "Missing mandatory field toAddress for type PrepareRefundRequest") }
        guard let satPerVbyte = prepareRefundRequest["satPerVbyte"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field satPerVbyte for type PrepareRefundRequest") }

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
                throw SdkError.Generic(message: "Unexpected type PrepareRefundRequest")
            }
        }
        return list
    }

    static func arrayOf(prepareRefundRequestList: [PrepareRefundRequest]) -> [Any] {
        return prepareRefundRequestList.map { v -> [String: Any?] in dictionaryOf(prepareRefundRequest: v) }
    }

    static func asPrepareRefundResponse(prepareRefundResponse: [String: Any?]) throws -> PrepareRefundResponse {
        guard let refundTxWeight = prepareRefundResponse["refundTxWeight"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field refundTxWeight for type PrepareRefundResponse") }
        guard let refundTxFeeSat = prepareRefundResponse["refundTxFeeSat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field refundTxFeeSat for type PrepareRefundResponse") }

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
                throw SdkError.Generic(message: "Unexpected type PrepareRefundResponse")
            }
        }
        return list
    }

    static func arrayOf(prepareRefundResponseList: [PrepareRefundResponse]) -> [Any] {
        return prepareRefundResponseList.map { v -> [String: Any?] in dictionaryOf(prepareRefundResponse: v) }
    }

    static func asPrepareSweepRequest(prepareSweepRequest: [String: Any?]) throws -> PrepareSweepRequest {
        guard let toAddress = prepareSweepRequest["toAddress"] as? String else { throw SdkError.Generic(message: "Missing mandatory field toAddress for type PrepareSweepRequest") }
        guard let satsPerVbyte = prepareSweepRequest["satsPerVbyte"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field satsPerVbyte for type PrepareSweepRequest") }

        return PrepareSweepRequest(
            toAddress: toAddress,
            satsPerVbyte: satsPerVbyte
        )
    }

    static func dictionaryOf(prepareSweepRequest: PrepareSweepRequest) -> [String: Any?] {
        return [
            "toAddress": prepareSweepRequest.toAddress,
            "satsPerVbyte": prepareSweepRequest.satsPerVbyte,
        ]
    }

    static func asPrepareSweepRequestList(arr: [Any]) throws -> [PrepareSweepRequest] {
        var list = [PrepareSweepRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var prepareSweepRequest = try asPrepareSweepRequest(prepareSweepRequest: val)
                list.append(prepareSweepRequest)
            } else {
                throw SdkError.Generic(message: "Unexpected type PrepareSweepRequest")
            }
        }
        return list
    }

    static func arrayOf(prepareSweepRequestList: [PrepareSweepRequest]) -> [Any] {
        return prepareSweepRequestList.map { v -> [String: Any?] in dictionaryOf(prepareSweepRequest: v) }
    }

    static func asPrepareSweepResponse(prepareSweepResponse: [String: Any?]) throws -> PrepareSweepResponse {
        guard let sweepTxWeight = prepareSweepResponse["sweepTxWeight"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field sweepTxWeight for type PrepareSweepResponse") }
        guard let sweepTxFeeSat = prepareSweepResponse["sweepTxFeeSat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field sweepTxFeeSat for type PrepareSweepResponse") }

        return PrepareSweepResponse(
            sweepTxWeight: sweepTxWeight,
            sweepTxFeeSat: sweepTxFeeSat
        )
    }

    static func dictionaryOf(prepareSweepResponse: PrepareSweepResponse) -> [String: Any?] {
        return [
            "sweepTxWeight": prepareSweepResponse.sweepTxWeight,
            "sweepTxFeeSat": prepareSweepResponse.sweepTxFeeSat,
        ]
    }

    static func asPrepareSweepResponseList(arr: [Any]) throws -> [PrepareSweepResponse] {
        var list = [PrepareSweepResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var prepareSweepResponse = try asPrepareSweepResponse(prepareSweepResponse: val)
                list.append(prepareSweepResponse)
            } else {
                throw SdkError.Generic(message: "Unexpected type PrepareSweepResponse")
            }
        }
        return list
    }

    static func arrayOf(prepareSweepResponseList: [PrepareSweepResponse]) -> [Any] {
        return prepareSweepResponseList.map { v -> [String: Any?] in dictionaryOf(prepareSweepResponse: v) }
    }

    static func asRate(rate: [String: Any?]) throws -> Rate {
        guard let coin = rate["coin"] as? String else { throw SdkError.Generic(message: "Missing mandatory field coin for type Rate") }
        guard let value = rate["value"] as? Double else { throw SdkError.Generic(message: "Missing mandatory field value for type Rate") }

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
                throw SdkError.Generic(message: "Unexpected type Rate")
            }
        }
        return list
    }

    static func arrayOf(rateList: [Rate]) -> [Any] {
        return rateList.map { v -> [String: Any?] in dictionaryOf(rate: v) }
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
                throw SdkError.Generic(message: "Unexpected type ReceiveOnchainRequest")
            }
        }
        return list
    }

    static func arrayOf(receiveOnchainRequestList: [ReceiveOnchainRequest]) -> [Any] {
        return receiveOnchainRequestList.map { v -> [String: Any?] in dictionaryOf(receiveOnchainRequest: v) }
    }

    static func asReceivePaymentRequest(receivePaymentRequest: [String: Any?]) throws -> ReceivePaymentRequest {
        guard let amountMsat = receivePaymentRequest["amountMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field amountMsat for type ReceivePaymentRequest") }
        guard let description = receivePaymentRequest["description"] as? String else { throw SdkError.Generic(message: "Missing mandatory field description for type ReceivePaymentRequest") }
        let preimage = receivePaymentRequest["preimage"] as? [UInt8]
        var openingFeeParams: OpeningFeeParams?
        if let openingFeeParamsTmp = receivePaymentRequest["openingFeeParams"] as? [String: Any?] {
            openingFeeParams = try asOpeningFeeParams(openingFeeParams: openingFeeParamsTmp)
        }

        let useDescriptionHash = receivePaymentRequest["useDescriptionHash"] as? Bool
        let expiry = receivePaymentRequest["expiry"] as? UInt32
        let cltv = receivePaymentRequest["cltv"] as? UInt32

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
                throw SdkError.Generic(message: "Unexpected type ReceivePaymentRequest")
            }
        }
        return list
    }

    static func arrayOf(receivePaymentRequestList: [ReceivePaymentRequest]) -> [Any] {
        return receivePaymentRequestList.map { v -> [String: Any?] in dictionaryOf(receivePaymentRequest: v) }
    }

    static func asReceivePaymentResponse(receivePaymentResponse: [String: Any?]) throws -> ReceivePaymentResponse {
        guard let lnInvoiceTmp = receivePaymentResponse["lnInvoice"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field lnInvoice for type ReceivePaymentResponse") }
        let lnInvoice = try asLnInvoice(lnInvoice: lnInvoiceTmp)

        var openingFeeParams: OpeningFeeParams?
        if let openingFeeParamsTmp = receivePaymentResponse["openingFeeParams"] as? [String: Any?] {
            openingFeeParams = try asOpeningFeeParams(openingFeeParams: openingFeeParamsTmp)
        }

        let openingFeeMsat = receivePaymentResponse["openingFeeMsat"] as? UInt64

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
                throw SdkError.Generic(message: "Unexpected type ReceivePaymentResponse")
            }
        }
        return list
    }

    static func arrayOf(receivePaymentResponseList: [ReceivePaymentResponse]) -> [Any] {
        return receivePaymentResponseList.map { v -> [String: Any?] in dictionaryOf(receivePaymentResponse: v) }
    }

    static func asRecommendedFees(recommendedFees: [String: Any?]) throws -> RecommendedFees {
        guard let fastestFee = recommendedFees["fastestFee"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field fastestFee for type RecommendedFees") }
        guard let halfHourFee = recommendedFees["halfHourFee"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field halfHourFee for type RecommendedFees") }
        guard let hourFee = recommendedFees["hourFee"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field hourFee for type RecommendedFees") }
        guard let economyFee = recommendedFees["economyFee"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field economyFee for type RecommendedFees") }
        guard let minimumFee = recommendedFees["minimumFee"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field minimumFee for type RecommendedFees") }

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
                throw SdkError.Generic(message: "Unexpected type RecommendedFees")
            }
        }
        return list
    }

    static func arrayOf(recommendedFeesList: [RecommendedFees]) -> [Any] {
        return recommendedFeesList.map { v -> [String: Any?] in dictionaryOf(recommendedFees: v) }
    }

    static func asRefundRequest(refundRequest: [String: Any?]) throws -> RefundRequest {
        guard let swapAddress = refundRequest["swapAddress"] as? String else { throw SdkError.Generic(message: "Missing mandatory field swapAddress for type RefundRequest") }
        guard let toAddress = refundRequest["toAddress"] as? String else { throw SdkError.Generic(message: "Missing mandatory field toAddress for type RefundRequest") }
        guard let satPerVbyte = refundRequest["satPerVbyte"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field satPerVbyte for type RefundRequest") }

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
                throw SdkError.Generic(message: "Unexpected type RefundRequest")
            }
        }
        return list
    }

    static func arrayOf(refundRequestList: [RefundRequest]) -> [Any] {
        return refundRequestList.map { v -> [String: Any?] in dictionaryOf(refundRequest: v) }
    }

    static func asRefundResponse(refundResponse: [String: Any?]) throws -> RefundResponse {
        guard let refundTxId = refundResponse["refundTxId"] as? String else { throw SdkError.Generic(message: "Missing mandatory field refundTxId for type RefundResponse") }

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
                throw SdkError.Generic(message: "Unexpected type RefundResponse")
            }
        }
        return list
    }

    static func arrayOf(refundResponseList: [RefundResponse]) -> [Any] {
        return refundResponseList.map { v -> [String: Any?] in dictionaryOf(refundResponse: v) }
    }

    static func asReverseSwapFeesRequest(reverseSwapFeesRequest: [String: Any?]) throws -> ReverseSwapFeesRequest {
        let sendAmountSat = reverseSwapFeesRequest["sendAmountSat"] as? UInt64

        return ReverseSwapFeesRequest(
            sendAmountSat: sendAmountSat)
    }

    static func dictionaryOf(reverseSwapFeesRequest: ReverseSwapFeesRequest) -> [String: Any?] {
        return [
            "sendAmountSat": reverseSwapFeesRequest.sendAmountSat == nil ? nil : reverseSwapFeesRequest.sendAmountSat,
        ]
    }

    static func asReverseSwapFeesRequestList(arr: [Any]) throws -> [ReverseSwapFeesRequest] {
        var list = [ReverseSwapFeesRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var reverseSwapFeesRequest = try asReverseSwapFeesRequest(reverseSwapFeesRequest: val)
                list.append(reverseSwapFeesRequest)
            } else {
                throw SdkError.Generic(message: "Unexpected type ReverseSwapFeesRequest")
            }
        }
        return list
    }

    static func arrayOf(reverseSwapFeesRequestList: [ReverseSwapFeesRequest]) -> [Any] {
        return reverseSwapFeesRequestList.map { v -> [String: Any?] in dictionaryOf(reverseSwapFeesRequest: v) }
    }

    static func asReverseSwapInfo(reverseSwapInfo: [String: Any?]) throws -> ReverseSwapInfo {
        guard let id = reverseSwapInfo["id"] as? String else { throw SdkError.Generic(message: "Missing mandatory field id for type ReverseSwapInfo") }
        guard let claimPubkey = reverseSwapInfo["claimPubkey"] as? String else { throw SdkError.Generic(message: "Missing mandatory field claimPubkey for type ReverseSwapInfo") }
        let lockupTxid = reverseSwapInfo["lockupTxid"] as? String
        let claimTxid = reverseSwapInfo["claimTxid"] as? String
        guard let onchainAmountSat = reverseSwapInfo["onchainAmountSat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field onchainAmountSat for type ReverseSwapInfo") }
        guard let statusTmp = reverseSwapInfo["status"] as? String else { throw SdkError.Generic(message: "Missing mandatory field status for type ReverseSwapInfo") }
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
                throw SdkError.Generic(message: "Unexpected type ReverseSwapInfo")
            }
        }
        return list
    }

    static func arrayOf(reverseSwapInfoList: [ReverseSwapInfo]) -> [Any] {
        return reverseSwapInfoList.map { v -> [String: Any?] in dictionaryOf(reverseSwapInfo: v) }
    }

    static func asReverseSwapPairInfo(reverseSwapPairInfo: [String: Any?]) throws -> ReverseSwapPairInfo {
        guard let min = reverseSwapPairInfo["min"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field min for type ReverseSwapPairInfo") }
        guard let max = reverseSwapPairInfo["max"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field max for type ReverseSwapPairInfo") }
        guard let feesHash = reverseSwapPairInfo["feesHash"] as? String else { throw SdkError.Generic(message: "Missing mandatory field feesHash for type ReverseSwapPairInfo") }
        guard let feesPercentage = reverseSwapPairInfo["feesPercentage"] as? Double else { throw SdkError.Generic(message: "Missing mandatory field feesPercentage for type ReverseSwapPairInfo") }
        guard let feesLockup = reverseSwapPairInfo["feesLockup"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field feesLockup for type ReverseSwapPairInfo") }
        guard let feesClaim = reverseSwapPairInfo["feesClaim"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field feesClaim for type ReverseSwapPairInfo") }
        let totalEstimatedFees = reverseSwapPairInfo["totalEstimatedFees"] as? UInt64

        return ReverseSwapPairInfo(
            min: min,
            max: max,
            feesHash: feesHash,
            feesPercentage: feesPercentage,
            feesLockup: feesLockup,
            feesClaim: feesClaim,
            totalEstimatedFees: totalEstimatedFees
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
            "totalEstimatedFees": reverseSwapPairInfo.totalEstimatedFees == nil ? nil : reverseSwapPairInfo.totalEstimatedFees,
        ]
    }

    static func asReverseSwapPairInfoList(arr: [Any]) throws -> [ReverseSwapPairInfo] {
        var list = [ReverseSwapPairInfo]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var reverseSwapPairInfo = try asReverseSwapPairInfo(reverseSwapPairInfo: val)
                list.append(reverseSwapPairInfo)
            } else {
                throw SdkError.Generic(message: "Unexpected type ReverseSwapPairInfo")
            }
        }
        return list
    }

    static func arrayOf(reverseSwapPairInfoList: [ReverseSwapPairInfo]) -> [Any] {
        return reverseSwapPairInfoList.map { v -> [String: Any?] in dictionaryOf(reverseSwapPairInfo: v) }
    }

    static func asRouteHint(routeHint: [String: Any?]) throws -> RouteHint {
        guard let hopsTmp = routeHint["hops"] as? [[String: Any?]] else { throw SdkError.Generic(message: "Missing mandatory field hops for type RouteHint") }
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
                throw SdkError.Generic(message: "Unexpected type RouteHint")
            }
        }
        return list
    }

    static func arrayOf(routeHintList: [RouteHint]) -> [Any] {
        return routeHintList.map { v -> [String: Any?] in dictionaryOf(routeHint: v) }
    }

    static func asRouteHintHop(routeHintHop: [String: Any?]) throws -> RouteHintHop {
        guard let srcNodeId = routeHintHop["srcNodeId"] as? String else { throw SdkError.Generic(message: "Missing mandatory field srcNodeId for type RouteHintHop") }
        guard let shortChannelId = routeHintHop["shortChannelId"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field shortChannelId for type RouteHintHop") }
        guard let feesBaseMsat = routeHintHop["feesBaseMsat"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field feesBaseMsat for type RouteHintHop") }
        guard let feesProportionalMillionths = routeHintHop["feesProportionalMillionths"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field feesProportionalMillionths for type RouteHintHop") }
        guard let cltvExpiryDelta = routeHintHop["cltvExpiryDelta"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field cltvExpiryDelta for type RouteHintHop") }
        let htlcMinimumMsat = routeHintHop["htlcMinimumMsat"] as? UInt64
        let htlcMaximumMsat = routeHintHop["htlcMaximumMsat"] as? UInt64

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
                throw SdkError.Generic(message: "Unexpected type RouteHintHop")
            }
        }
        return list
    }

    static func arrayOf(routeHintHopList: [RouteHintHop]) -> [Any] {
        return routeHintHopList.map { v -> [String: Any?] in dictionaryOf(routeHintHop: v) }
    }

    static func asSendOnchainRequest(sendOnchainRequest: [String: Any?]) throws -> SendOnchainRequest {
        guard let amountSat = sendOnchainRequest["amountSat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field amountSat for type SendOnchainRequest") }
        guard let onchainRecipientAddress = sendOnchainRequest["onchainRecipientAddress"] as? String else { throw SdkError.Generic(message: "Missing mandatory field onchainRecipientAddress for type SendOnchainRequest") }
        guard let pairHash = sendOnchainRequest["pairHash"] as? String else { throw SdkError.Generic(message: "Missing mandatory field pairHash for type SendOnchainRequest") }
        guard let satPerVbyte = sendOnchainRequest["satPerVbyte"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field satPerVbyte for type SendOnchainRequest") }

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
                throw SdkError.Generic(message: "Unexpected type SendOnchainRequest")
            }
        }
        return list
    }

    static func arrayOf(sendOnchainRequestList: [SendOnchainRequest]) -> [Any] {
        return sendOnchainRequestList.map { v -> [String: Any?] in dictionaryOf(sendOnchainRequest: v) }
    }

    static func asSendOnchainResponse(sendOnchainResponse: [String: Any?]) throws -> SendOnchainResponse {
        guard let reverseSwapInfoTmp = sendOnchainResponse["reverseSwapInfo"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field reverseSwapInfo for type SendOnchainResponse") }
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
                throw SdkError.Generic(message: "Unexpected type SendOnchainResponse")
            }
        }
        return list
    }

    static func arrayOf(sendOnchainResponseList: [SendOnchainResponse]) -> [Any] {
        return sendOnchainResponseList.map { v -> [String: Any?] in dictionaryOf(sendOnchainResponse: v) }
    }

    static func asSendPaymentRequest(sendPaymentRequest: [String: Any?]) throws -> SendPaymentRequest {
        guard let bolt11 = sendPaymentRequest["bolt11"] as? String else { throw SdkError.Generic(message: "Missing mandatory field bolt11 for type SendPaymentRequest") }
        let amountMsat = sendPaymentRequest["amountMsat"] as? UInt64

        return SendPaymentRequest(
            bolt11: bolt11,
            amountMsat: amountMsat
        )
    }

    static func dictionaryOf(sendPaymentRequest: SendPaymentRequest) -> [String: Any?] {
        return [
            "bolt11": sendPaymentRequest.bolt11,
            "amountMsat": sendPaymentRequest.amountMsat == nil ? nil : sendPaymentRequest.amountMsat,
        ]
    }

    static func asSendPaymentRequestList(arr: [Any]) throws -> [SendPaymentRequest] {
        var list = [SendPaymentRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var sendPaymentRequest = try asSendPaymentRequest(sendPaymentRequest: val)
                list.append(sendPaymentRequest)
            } else {
                throw SdkError.Generic(message: "Unexpected type SendPaymentRequest")
            }
        }
        return list
    }

    static func arrayOf(sendPaymentRequestList: [SendPaymentRequest]) -> [Any] {
        return sendPaymentRequestList.map { v -> [String: Any?] in dictionaryOf(sendPaymentRequest: v) }
    }

    static func asSendPaymentResponse(sendPaymentResponse: [String: Any?]) throws -> SendPaymentResponse {
        guard let paymentTmp = sendPaymentResponse["payment"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field payment for type SendPaymentResponse") }
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
                throw SdkError.Generic(message: "Unexpected type SendPaymentResponse")
            }
        }
        return list
    }

    static func arrayOf(sendPaymentResponseList: [SendPaymentResponse]) -> [Any] {
        return sendPaymentResponseList.map { v -> [String: Any?] in dictionaryOf(sendPaymentResponse: v) }
    }

    static func asSendSpontaneousPaymentRequest(sendSpontaneousPaymentRequest: [String: Any?]) throws -> SendSpontaneousPaymentRequest {
        guard let nodeId = sendSpontaneousPaymentRequest["nodeId"] as? String else { throw SdkError.Generic(message: "Missing mandatory field nodeId for type SendSpontaneousPaymentRequest") }
        guard let amountMsat = sendSpontaneousPaymentRequest["amountMsat"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field amountMsat for type SendSpontaneousPaymentRequest") }

        return SendSpontaneousPaymentRequest(
            nodeId: nodeId,
            amountMsat: amountMsat
        )
    }

    static func dictionaryOf(sendSpontaneousPaymentRequest: SendSpontaneousPaymentRequest) -> [String: Any?] {
        return [
            "nodeId": sendSpontaneousPaymentRequest.nodeId,
            "amountMsat": sendSpontaneousPaymentRequest.amountMsat,
        ]
    }

    static func asSendSpontaneousPaymentRequestList(arr: [Any]) throws -> [SendSpontaneousPaymentRequest] {
        var list = [SendSpontaneousPaymentRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var sendSpontaneousPaymentRequest = try asSendSpontaneousPaymentRequest(sendSpontaneousPaymentRequest: val)
                list.append(sendSpontaneousPaymentRequest)
            } else {
                throw SdkError.Generic(message: "Unexpected type SendSpontaneousPaymentRequest")
            }
        }
        return list
    }

    static func arrayOf(sendSpontaneousPaymentRequestList: [SendSpontaneousPaymentRequest]) -> [Any] {
        return sendSpontaneousPaymentRequestList.map { v -> [String: Any?] in dictionaryOf(sendSpontaneousPaymentRequest: v) }
    }

    static func asSignMessageRequest(signMessageRequest: [String: Any?]) throws -> SignMessageRequest {
        guard let message = signMessageRequest["message"] as? String else { throw SdkError.Generic(message: "Missing mandatory field message for type SignMessageRequest") }

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
                throw SdkError.Generic(message: "Unexpected type SignMessageRequest")
            }
        }
        return list
    }

    static func arrayOf(signMessageRequestList: [SignMessageRequest]) -> [Any] {
        return signMessageRequestList.map { v -> [String: Any?] in dictionaryOf(signMessageRequest: v) }
    }

    static func asSignMessageResponse(signMessageResponse: [String: Any?]) throws -> SignMessageResponse {
        guard let signature = signMessageResponse["signature"] as? String else { throw SdkError.Generic(message: "Missing mandatory field signature for type SignMessageResponse") }

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
                throw SdkError.Generic(message: "Unexpected type SignMessageResponse")
            }
        }
        return list
    }

    static func arrayOf(signMessageResponseList: [SignMessageResponse]) -> [Any] {
        return signMessageResponseList.map { v -> [String: Any?] in dictionaryOf(signMessageResponse: v) }
    }

    static func asStaticBackupRequest(staticBackupRequest: [String: Any?]) throws -> StaticBackupRequest {
        guard let workingDir = staticBackupRequest["workingDir"] as? String else { throw SdkError.Generic(message: "Missing mandatory field workingDir for type StaticBackupRequest") }

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
                throw SdkError.Generic(message: "Unexpected type StaticBackupRequest")
            }
        }
        return list
    }

    static func arrayOf(staticBackupRequestList: [StaticBackupRequest]) -> [Any] {
        return staticBackupRequestList.map { v -> [String: Any?] in dictionaryOf(staticBackupRequest: v) }
    }

    static func asStaticBackupResponse(staticBackupResponse: [String: Any?]) throws -> StaticBackupResponse {
        let backup = staticBackupResponse["backup"] as? [String]

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
                throw SdkError.Generic(message: "Unexpected type StaticBackupResponse")
            }
        }
        return list
    }

    static func arrayOf(staticBackupResponseList: [StaticBackupResponse]) -> [Any] {
        return staticBackupResponseList.map { v -> [String: Any?] in dictionaryOf(staticBackupResponse: v) }
    }

    static func asSwapInfo(swapInfo: [String: Any?]) throws -> SwapInfo {
        guard let bitcoinAddress = swapInfo["bitcoinAddress"] as? String else { throw SdkError.Generic(message: "Missing mandatory field bitcoinAddress for type SwapInfo") }
        guard let createdAt = swapInfo["createdAt"] as? Int64 else { throw SdkError.Generic(message: "Missing mandatory field createdAt for type SwapInfo") }
        guard let lockHeight = swapInfo["lockHeight"] as? Int64 else { throw SdkError.Generic(message: "Missing mandatory field lockHeight for type SwapInfo") }
        guard let paymentHash = swapInfo["paymentHash"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field paymentHash for type SwapInfo") }
        guard let preimage = swapInfo["preimage"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field preimage for type SwapInfo") }
        guard let privateKey = swapInfo["privateKey"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field privateKey for type SwapInfo") }
        guard let publicKey = swapInfo["publicKey"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field publicKey for type SwapInfo") }
        guard let swapperPublicKey = swapInfo["swapperPublicKey"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field swapperPublicKey for type SwapInfo") }
        guard let script = swapInfo["script"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field script for type SwapInfo") }
        let bolt11 = swapInfo["bolt11"] as? String
        guard let paidSats = swapInfo["paidSats"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field paidSats for type SwapInfo") }
        guard let unconfirmedSats = swapInfo["unconfirmedSats"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field unconfirmedSats for type SwapInfo") }
        guard let confirmedSats = swapInfo["confirmedSats"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field confirmedSats for type SwapInfo") }
        guard let statusTmp = swapInfo["status"] as? String else { throw SdkError.Generic(message: "Missing mandatory field status for type SwapInfo") }
        let status = try asSwapStatus(swapStatus: statusTmp)

        guard let refundTxIds = swapInfo["refundTxIds"] as? [String] else { throw SdkError.Generic(message: "Missing mandatory field refundTxIds for type SwapInfo") }
        guard let unconfirmedTxIds = swapInfo["unconfirmedTxIds"] as? [String] else { throw SdkError.Generic(message: "Missing mandatory field unconfirmedTxIds for type SwapInfo") }
        guard let confirmedTxIds = swapInfo["confirmedTxIds"] as? [String] else { throw SdkError.Generic(message: "Missing mandatory field confirmedTxIds for type SwapInfo") }
        guard let minAllowedDeposit = swapInfo["minAllowedDeposit"] as? Int64 else { throw SdkError.Generic(message: "Missing mandatory field minAllowedDeposit for type SwapInfo") }
        guard let maxAllowedDeposit = swapInfo["maxAllowedDeposit"] as? Int64 else { throw SdkError.Generic(message: "Missing mandatory field maxAllowedDeposit for type SwapInfo") }
        let lastRedeemError = swapInfo["lastRedeemError"] as? String
        var channelOpeningFees: OpeningFeeParams?
        if let channelOpeningFeesTmp = swapInfo["channelOpeningFees"] as? [String: Any?] {
            channelOpeningFees = try asOpeningFeeParams(openingFeeParams: channelOpeningFeesTmp)
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
            paidSats: paidSats,
            unconfirmedSats: unconfirmedSats,
            confirmedSats: confirmedSats,
            status: status,
            refundTxIds: refundTxIds,
            unconfirmedTxIds: unconfirmedTxIds,
            confirmedTxIds: confirmedTxIds,
            minAllowedDeposit: minAllowedDeposit,
            maxAllowedDeposit: maxAllowedDeposit,
            lastRedeemError: lastRedeemError,
            channelOpeningFees: channelOpeningFees
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
            "paidSats": swapInfo.paidSats,
            "unconfirmedSats": swapInfo.unconfirmedSats,
            "confirmedSats": swapInfo.confirmedSats,
            "status": valueOf(swapStatus: swapInfo.status),
            "refundTxIds": swapInfo.refundTxIds,
            "unconfirmedTxIds": swapInfo.unconfirmedTxIds,
            "confirmedTxIds": swapInfo.confirmedTxIds,
            "minAllowedDeposit": swapInfo.minAllowedDeposit,
            "maxAllowedDeposit": swapInfo.maxAllowedDeposit,
            "lastRedeemError": swapInfo.lastRedeemError == nil ? nil : swapInfo.lastRedeemError,
            "channelOpeningFees": swapInfo.channelOpeningFees == nil ? nil : dictionaryOf(openingFeeParams: swapInfo.channelOpeningFees!),
        ]
    }

    static func asSwapInfoList(arr: [Any]) throws -> [SwapInfo] {
        var list = [SwapInfo]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var swapInfo = try asSwapInfo(swapInfo: val)
                list.append(swapInfo)
            } else {
                throw SdkError.Generic(message: "Unexpected type SwapInfo")
            }
        }
        return list
    }

    static func arrayOf(swapInfoList: [SwapInfo]) -> [Any] {
        return swapInfoList.map { v -> [String: Any?] in dictionaryOf(swapInfo: v) }
    }

    static func asSweepRequest(sweepRequest: [String: Any?]) throws -> SweepRequest {
        guard let toAddress = sweepRequest["toAddress"] as? String else { throw SdkError.Generic(message: "Missing mandatory field toAddress for type SweepRequest") }
        guard let feeRateSatsPerVbyte = sweepRequest["feeRateSatsPerVbyte"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field feeRateSatsPerVbyte for type SweepRequest") }

        return SweepRequest(
            toAddress: toAddress,
            feeRateSatsPerVbyte: feeRateSatsPerVbyte
        )
    }

    static func dictionaryOf(sweepRequest: SweepRequest) -> [String: Any?] {
        return [
            "toAddress": sweepRequest.toAddress,
            "feeRateSatsPerVbyte": sweepRequest.feeRateSatsPerVbyte,
        ]
    }

    static func asSweepRequestList(arr: [Any]) throws -> [SweepRequest] {
        var list = [SweepRequest]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var sweepRequest = try asSweepRequest(sweepRequest: val)
                list.append(sweepRequest)
            } else {
                throw SdkError.Generic(message: "Unexpected type SweepRequest")
            }
        }
        return list
    }

    static func arrayOf(sweepRequestList: [SweepRequest]) -> [Any] {
        return sweepRequestList.map { v -> [String: Any?] in dictionaryOf(sweepRequest: v) }
    }

    static func asSweepResponse(sweepResponse: [String: Any?]) throws -> SweepResponse {
        guard let txid = sweepResponse["txid"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field txid for type SweepResponse") }

        return SweepResponse(
            txid: txid)
    }

    static func dictionaryOf(sweepResponse: SweepResponse) -> [String: Any?] {
        return [
            "txid": sweepResponse.txid,
        ]
    }

    static func asSweepResponseList(arr: [Any]) throws -> [SweepResponse] {
        var list = [SweepResponse]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var sweepResponse = try asSweepResponse(sweepResponse: val)
                list.append(sweepResponse)
            } else {
                throw SdkError.Generic(message: "Unexpected type SweepResponse")
            }
        }
        return list
    }

    static func arrayOf(sweepResponseList: [SweepResponse]) -> [Any] {
        return sweepResponseList.map { v -> [String: Any?] in dictionaryOf(sweepResponse: v) }
    }

    static func asSymbol(symbol: [String: Any?]) throws -> Symbol {
        let grapheme = symbol["grapheme"] as? String
        let template = symbol["template"] as? String
        let rtl = symbol["rtl"] as? Bool
        let position = symbol["position"] as? UInt32

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
                throw SdkError.Generic(message: "Unexpected type Symbol")
            }
        }
        return list
    }

    static func arrayOf(symbolList: [Symbol]) -> [Any] {
        return symbolList.map { v -> [String: Any?] in dictionaryOf(symbol: v) }
    }

    static func asUnspentTransactionOutput(unspentTransactionOutput: [String: Any?]) throws -> UnspentTransactionOutput {
        guard let txid = unspentTransactionOutput["txid"] as? [UInt8] else { throw SdkError.Generic(message: "Missing mandatory field txid for type UnspentTransactionOutput") }
        guard let outnum = unspentTransactionOutput["outnum"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field outnum for type UnspentTransactionOutput") }
        guard let amountMillisatoshi = unspentTransactionOutput["amountMillisatoshi"] as? UInt64 else { throw SdkError.Generic(message: "Missing mandatory field amountMillisatoshi for type UnspentTransactionOutput") }
        guard let address = unspentTransactionOutput["address"] as? String else { throw SdkError.Generic(message: "Missing mandatory field address for type UnspentTransactionOutput") }
        guard let reserved = unspentTransactionOutput["reserved"] as? Bool else { throw SdkError.Generic(message: "Missing mandatory field reserved for type UnspentTransactionOutput") }

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
                throw SdkError.Generic(message: "Unexpected type UnspentTransactionOutput")
            }
        }
        return list
    }

    static func arrayOf(unspentTransactionOutputList: [UnspentTransactionOutput]) -> [Any] {
        return unspentTransactionOutputList.map { v -> [String: Any?] in dictionaryOf(unspentTransactionOutput: v) }
    }

    static func asUrlSuccessActionData(urlSuccessActionData: [String: Any?]) throws -> UrlSuccessActionData {
        guard let description = urlSuccessActionData["description"] as? String else { throw SdkError.Generic(message: "Missing mandatory field description for type UrlSuccessActionData") }
        guard let url = urlSuccessActionData["url"] as? String else { throw SdkError.Generic(message: "Missing mandatory field url for type UrlSuccessActionData") }

        return UrlSuccessActionData(
            description: description,
            url: url
        )
    }

    static func dictionaryOf(urlSuccessActionData: UrlSuccessActionData) -> [String: Any?] {
        return [
            "description": urlSuccessActionData.description,
            "url": urlSuccessActionData.url,
        ]
    }

    static func asUrlSuccessActionDataList(arr: [Any]) throws -> [UrlSuccessActionData] {
        var list = [UrlSuccessActionData]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var urlSuccessActionData = try asUrlSuccessActionData(urlSuccessActionData: val)
                list.append(urlSuccessActionData)
            } else {
                throw SdkError.Generic(message: "Unexpected type UrlSuccessActionData")
            }
        }
        return list
    }

    static func arrayOf(urlSuccessActionDataList: [UrlSuccessActionData]) -> [Any] {
        return urlSuccessActionDataList.map { v -> [String: Any?] in dictionaryOf(urlSuccessActionData: v) }
    }

    static func asBreezEvent(breezEvent: [String: Any?]) throws -> BreezEvent {
        let type = breezEvent["type"] as! String
        if type == "newBlock" {
            guard let _block = breezEvent["block"] as? UInt32 else { throw SdkError.Generic(message: "Missing mandatory field block for type BreezEvent") }
            return BreezEvent.newBlock(block: _block)
        }
        if type == "invoicePaid" {
            guard let detailsTmp = breezEvent["details"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field details for type BreezEvent") }
            let _details = try asInvoicePaidDetails(invoicePaidDetails: detailsTmp)

            return BreezEvent.invoicePaid(details: _details)
        }
        if type == "synced" {
            return BreezEvent.synced
        }
        if type == "paymentSucceed" {
            guard let detailsTmp = breezEvent["details"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field details for type BreezEvent") }
            let _details = try asPayment(payment: detailsTmp)

            return BreezEvent.paymentSucceed(details: _details)
        }
        if type == "paymentFailed" {
            guard let detailsTmp = breezEvent["details"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field details for type BreezEvent") }
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
            guard let detailsTmp = breezEvent["details"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field details for type BreezEvent") }
            let _details = try asBackupFailedData(backupFailedData: detailsTmp)

            return BreezEvent.backupFailed(details: _details)
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
        }
    }

    static func arrayOf(breezEventList: [BreezEvent]) -> [Any] {
        return breezEventList.map { v -> [String: Any?] in dictionaryOf(breezEvent: v) }
    }

    static func asBreezEventList(arr: [Any]) throws -> [BreezEvent] {
        var list = [BreezEvent]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var breezEvent = try asBreezEvent(breezEvent: val)
                list.append(breezEvent)
            } else {
                throw SdkError.Generic(message: "Unexpected type BreezEvent")
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
        return buyBitcoinProviderList.map { v -> String in valueOf(buyBitcoinProvider: v) }
    }

    static func asBuyBitcoinProviderList(arr: [Any]) throws -> [BuyBitcoinProvider] {
        var list = [BuyBitcoinProvider]()
        for value in arr {
            if let val = value as? String {
                var buyBitcoinProvider = try asBuyBitcoinProvider(buyBitcoinProvider: val)
                list.append(buyBitcoinProvider)
            } else {
                throw SdkError.Generic(message: "Unexpected type BuyBitcoinProvider")
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
        return channelStateList.map { v -> String in valueOf(channelState: v) }
    }

    static func asChannelStateList(arr: [Any]) throws -> [ChannelState] {
        var list = [ChannelState]()
        for value in arr {
            if let val = value as? String {
                var channelState = try asChannelState(channelState: val)
                list.append(channelState)
            } else {
                throw SdkError.Generic(message: "Unexpected type ChannelState")
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
        return environmentTypeList.map { v -> String in valueOf(environmentType: v) }
    }

    static func asEnvironmentTypeList(arr: [Any]) throws -> [EnvironmentType] {
        var list = [EnvironmentType]()
        for value in arr {
            if let val = value as? String {
                var environmentType = try asEnvironmentType(environmentType: val)
                list.append(environmentType)
            } else {
                throw SdkError.Generic(message: "Unexpected type EnvironmentType")
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
        return feeratePresetList.map { v -> String in valueOf(feeratePreset: v) }
    }

    static func asFeeratePresetList(arr: [Any]) throws -> [FeeratePreset] {
        var list = [FeeratePreset]()
        for value in arr {
            if let val = value as? String {
                var feeratePreset = try asFeeratePreset(feeratePreset: val)
                list.append(feeratePreset)
            } else {
                throw SdkError.Generic(message: "Unexpected type FeeratePreset")
            }
        }
        return list
    }

    static func asInputType(inputType: [String: Any?]) throws -> InputType {
        let type = inputType["type"] as! String
        if type == "bitcoinAddress" {
            guard let addressTmp = inputType["address"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field address for type InputType") }
            let _address = try asBitcoinAddressData(bitcoinAddressData: addressTmp)

            return InputType.bitcoinAddress(address: _address)
        }
        if type == "bolt11" {
            guard let invoiceTmp = inputType["invoice"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field invoice for type InputType") }
            let _invoice = try asLnInvoice(lnInvoice: invoiceTmp)

            return InputType.bolt11(invoice: _invoice)
        }
        if type == "nodeId" {
            guard let _nodeId = inputType["nodeId"] as? String else { throw SdkError.Generic(message: "Missing mandatory field nodeId for type InputType") }
            return InputType.nodeId(nodeId: _nodeId)
        }
        if type == "url" {
            guard let _url = inputType["url"] as? String else { throw SdkError.Generic(message: "Missing mandatory field url for type InputType") }
            return InputType.url(url: _url)
        }
        if type == "lnUrlPay" {
            guard let dataTmp = inputType["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type InputType") }
            let _data = try asLnUrlPayRequestData(lnUrlPayRequestData: dataTmp)

            return InputType.lnUrlPay(data: _data)
        }
        if type == "lnUrlWithdraw" {
            guard let dataTmp = inputType["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type InputType") }
            let _data = try asLnUrlWithdrawRequestData(lnUrlWithdrawRequestData: dataTmp)

            return InputType.lnUrlWithdraw(data: _data)
        }
        if type == "lnUrlAuth" {
            guard let dataTmp = inputType["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type InputType") }
            let _data = try asLnUrlAuthRequestData(lnUrlAuthRequestData: dataTmp)

            return InputType.lnUrlAuth(data: _data)
        }
        if type == "lnUrlError" {
            guard let dataTmp = inputType["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type InputType") }
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
        return inputTypeList.map { v -> [String: Any?] in dictionaryOf(inputType: v) }
    }

    static func asInputTypeList(arr: [Any]) throws -> [InputType] {
        var list = [InputType]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var inputType = try asInputType(inputType: val)
                list.append(inputType)
            } else {
                throw SdkError.Generic(message: "Unexpected type InputType")
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
            guard let dataTmp = lnUrlCallbackStatus["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type LnUrlCallbackStatus") }
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
        return lnUrlCallbackStatusList.map { v -> [String: Any?] in dictionaryOf(lnUrlCallbackStatus: v) }
    }

    static func asLnUrlCallbackStatusList(arr: [Any]) throws -> [LnUrlCallbackStatus] {
        var list = [LnUrlCallbackStatus]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlCallbackStatus = try asLnUrlCallbackStatus(lnUrlCallbackStatus: val)
                list.append(lnUrlCallbackStatus)
            } else {
                throw SdkError.Generic(message: "Unexpected type LnUrlCallbackStatus")
            }
        }
        return list
    }

    static func asLnUrlPayResult(lnUrlPayResult: [String: Any?]) throws -> LnUrlPayResult {
        let type = lnUrlPayResult["type"] as! String
        if type == "endpointSuccess" {
            guard let dataTmp = lnUrlPayResult["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type LnUrlPayResult") }
            let _data = try asLnUrlPaySuccessData(lnUrlPaySuccessData: dataTmp)

            return LnUrlPayResult.endpointSuccess(data: _data)
        }
        if type == "endpointError" {
            guard let dataTmp = lnUrlPayResult["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type LnUrlPayResult") }
            let _data = try asLnUrlErrorData(lnUrlErrorData: dataTmp)

            return LnUrlPayResult.endpointError(data: _data)
        }
        if type == "payError" {
            guard let dataTmp = lnUrlPayResult["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type LnUrlPayResult") }
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
        return lnUrlPayResultList.map { v -> [String: Any?] in dictionaryOf(lnUrlPayResult: v) }
    }

    static func asLnUrlPayResultList(arr: [Any]) throws -> [LnUrlPayResult] {
        var list = [LnUrlPayResult]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlPayResult = try asLnUrlPayResult(lnUrlPayResult: val)
                list.append(lnUrlPayResult)
            } else {
                throw SdkError.Generic(message: "Unexpected type LnUrlPayResult")
            }
        }
        return list
    }

    static func asLnUrlWithdrawResult(lnUrlWithdrawResult: [String: Any?]) throws -> LnUrlWithdrawResult {
        let type = lnUrlWithdrawResult["type"] as! String
        if type == "ok" {
            guard let dataTmp = lnUrlWithdrawResult["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type LnUrlWithdrawResult") }
            let _data = try asLnUrlWithdrawSuccessData(lnUrlWithdrawSuccessData: dataTmp)

            return LnUrlWithdrawResult.ok(data: _data)
        }
        if type == "errorStatus" {
            guard let dataTmp = lnUrlWithdrawResult["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type LnUrlWithdrawResult") }
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
        return lnUrlWithdrawResultList.map { v -> [String: Any?] in dictionaryOf(lnUrlWithdrawResult: v) }
    }

    static func asLnUrlWithdrawResultList(arr: [Any]) throws -> [LnUrlWithdrawResult] {
        var list = [LnUrlWithdrawResult]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var lnUrlWithdrawResult = try asLnUrlWithdrawResult(lnUrlWithdrawResult: val)
                list.append(lnUrlWithdrawResult)
            } else {
                throw SdkError.Generic(message: "Unexpected type LnUrlWithdrawResult")
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
        return networkList.map { v -> String in valueOf(network: v) }
    }

    static func asNetworkList(arr: [Any]) throws -> [Network] {
        var list = [Network]()
        for value in arr {
            if let val = value as? String {
                var network = try asNetwork(network: val)
                list.append(network)
            } else {
                throw SdkError.Generic(message: "Unexpected type Network")
            }
        }
        return list
    }

    static func asNodeConfig(nodeConfig: [String: Any?]) throws -> NodeConfig {
        let type = nodeConfig["type"] as! String
        if type == "greenlight" {
            guard let configTmp = nodeConfig["config"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field config for type NodeConfig") }
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
        return nodeConfigList.map { v -> [String: Any?] in dictionaryOf(nodeConfig: v) }
    }

    static func asNodeConfigList(arr: [Any]) throws -> [NodeConfig] {
        var list = [NodeConfig]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var nodeConfig = try asNodeConfig(nodeConfig: val)
                list.append(nodeConfig)
            } else {
                throw SdkError.Generic(message: "Unexpected type NodeConfig")
            }
        }
        return list
    }

    static func asPaymentDetails(paymentDetails: [String: Any?]) throws -> PaymentDetails {
        let type = paymentDetails["type"] as! String
        if type == "ln" {
            guard let dataTmp = paymentDetails["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type PaymentDetails") }
            let _data = try asLnPaymentDetails(lnPaymentDetails: dataTmp)

            return PaymentDetails.ln(data: _data)
        }
        if type == "closedChannel" {
            guard let dataTmp = paymentDetails["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type PaymentDetails") }
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
        return paymentDetailsList.map { v -> [String: Any?] in dictionaryOf(paymentDetails: v) }
    }

    static func asPaymentDetailsList(arr: [Any]) throws -> [PaymentDetails] {
        var list = [PaymentDetails]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var paymentDetails = try asPaymentDetails(paymentDetails: val)
                list.append(paymentDetails)
            } else {
                throw SdkError.Generic(message: "Unexpected type PaymentDetails")
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
        return paymentStatusList.map { v -> String in valueOf(paymentStatus: v) }
    }

    static func asPaymentStatusList(arr: [Any]) throws -> [PaymentStatus] {
        var list = [PaymentStatus]()
        for value in arr {
            if let val = value as? String {
                var paymentStatus = try asPaymentStatus(paymentStatus: val)
                list.append(paymentStatus)
            } else {
                throw SdkError.Generic(message: "Unexpected type PaymentStatus")
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
        return paymentTypeList.map { v -> String in valueOf(paymentType: v) }
    }

    static func asPaymentTypeList(arr: [Any]) throws -> [PaymentType] {
        var list = [PaymentType]()
        for value in arr {
            if let val = value as? String {
                var paymentType = try asPaymentType(paymentType: val)
                list.append(paymentType)
            } else {
                throw SdkError.Generic(message: "Unexpected type PaymentType")
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
        return paymentTypeFilterList.map { v -> String in valueOf(paymentTypeFilter: v) }
    }

    static func asPaymentTypeFilterList(arr: [Any]) throws -> [PaymentTypeFilter] {
        var list = [PaymentTypeFilter]()
        for value in arr {
            if let val = value as? String {
                var paymentTypeFilter = try asPaymentTypeFilter(paymentTypeFilter: val)
                list.append(paymentTypeFilter)
            } else {
                throw SdkError.Generic(message: "Unexpected type PaymentTypeFilter")
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
        return reverseSwapStatusList.map { v -> String in valueOf(reverseSwapStatus: v) }
    }

    static func asReverseSwapStatusList(arr: [Any]) throws -> [ReverseSwapStatus] {
        var list = [ReverseSwapStatus]()
        for value in arr {
            if let val = value as? String {
                var reverseSwapStatus = try asReverseSwapStatus(reverseSwapStatus: val)
                list.append(reverseSwapStatus)
            } else {
                throw SdkError.Generic(message: "Unexpected type ReverseSwapStatus")
            }
        }
        return list
    }

    static func asSuccessActionProcessed(successActionProcessed: [String: Any?]) throws -> SuccessActionProcessed {
        let type = successActionProcessed["type"] as! String
        if type == "aes" {
            guard let dataTmp = successActionProcessed["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type SuccessActionProcessed") }
            let _data = try asAesSuccessActionDataDecrypted(aesSuccessActionDataDecrypted: dataTmp)

            return SuccessActionProcessed.aes(data: _data)
        }
        if type == "message" {
            guard let dataTmp = successActionProcessed["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type SuccessActionProcessed") }
            let _data = try asMessageSuccessActionData(messageSuccessActionData: dataTmp)

            return SuccessActionProcessed.message(data: _data)
        }
        if type == "url" {
            guard let dataTmp = successActionProcessed["data"] as? [String: Any?] else { throw SdkError.Generic(message: "Missing mandatory field data for type SuccessActionProcessed") }
            let _data = try asUrlSuccessActionData(urlSuccessActionData: dataTmp)

            return SuccessActionProcessed.url(data: _data)
        }

        throw SdkError.Generic(message: "Unexpected type \(type) for enum SuccessActionProcessed")
    }

    static func dictionaryOf(successActionProcessed: SuccessActionProcessed) -> [String: Any?] {
        switch successActionProcessed {
        case let .aes(
            data
        ):
            return [
                "type": "aes",
                "data": dictionaryOf(aesSuccessActionDataDecrypted: data),
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
        return successActionProcessedList.map { v -> [String: Any?] in dictionaryOf(successActionProcessed: v) }
    }

    static func asSuccessActionProcessedList(arr: [Any]) throws -> [SuccessActionProcessed] {
        var list = [SuccessActionProcessed]()
        for value in arr {
            if let val = value as? [String: Any?] {
                var successActionProcessed = try asSuccessActionProcessed(successActionProcessed: val)
                list.append(successActionProcessed)
            } else {
                throw SdkError.Generic(message: "Unexpected type SuccessActionProcessed")
            }
        }
        return list
    }

    static func asSwapStatus(swapStatus: String) throws -> SwapStatus {
        switch swapStatus {
        case "initial":
            return SwapStatus.initial

        case "expired":
            return SwapStatus.expired

        default: throw SdkError.Generic(message: "Invalid variant \(swapStatus) for enum SwapStatus")
        }
    }

    static func valueOf(swapStatus: SwapStatus) -> String {
        switch swapStatus {
        case .initial:
            return "initial"

        case .expired:
            return "expired"
        }
    }

    static func arrayOf(swapStatusList: [SwapStatus]) -> [String] {
        return swapStatusList.map { v -> String in valueOf(swapStatus: v) }
    }

    static func asSwapStatusList(arr: [Any]) throws -> [SwapStatus] {
        var list = [SwapStatus]()
        for value in arr {
            if let val = value as? String {
                var swapStatus = try asSwapStatus(swapStatus: val)
                list.append(swapStatus)
            } else {
                throw SdkError.Generic(message: "Unexpected type SwapStatus")
            }
        }
        return list
    }
}
