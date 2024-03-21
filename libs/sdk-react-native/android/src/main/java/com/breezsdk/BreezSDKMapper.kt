package com.breezsdk
import breez_sdk.*
import com.facebook.react.bridge.*
import java.util.*

fun asAesSuccessActionDataDecrypted(aesSuccessActionDataDecrypted: ReadableMap): AesSuccessActionDataDecrypted? {
    if (!validateMandatoryFields(
            aesSuccessActionDataDecrypted,
            arrayOf(
                "description",
                "plaintext",
            ),
        )
    ) {
        return null
    }
    val description = aesSuccessActionDataDecrypted.getString("description")!!
    val plaintext = aesSuccessActionDataDecrypted.getString("plaintext")!!
    return AesSuccessActionDataDecrypted(
        description,
        plaintext,
    )
}

fun readableMapOf(aesSuccessActionDataDecrypted: AesSuccessActionDataDecrypted): ReadableMap {
    return readableMapOf(
        "description" to aesSuccessActionDataDecrypted.description,
        "plaintext" to aesSuccessActionDataDecrypted.plaintext,
    )
}

fun asAesSuccessActionDataDecryptedList(arr: ReadableArray): List<AesSuccessActionDataDecrypted> {
    val list = ArrayList<AesSuccessActionDataDecrypted>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asAesSuccessActionDataDecrypted(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asBackupFailedData(backupFailedData: ReadableMap): BackupFailedData? {
    if (!validateMandatoryFields(
            backupFailedData,
            arrayOf(
                "error",
            ),
        )
    ) {
        return null
    }
    val error = backupFailedData.getString("error")!!
    return BackupFailedData(
        error,
    )
}

fun readableMapOf(backupFailedData: BackupFailedData): ReadableMap {
    return readableMapOf(
        "error" to backupFailedData.error,
    )
}

fun asBackupFailedDataList(arr: ReadableArray): List<BackupFailedData> {
    val list = ArrayList<BackupFailedData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asBackupFailedData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asBackupStatus(backupStatus: ReadableMap): BackupStatus? {
    if (!validateMandatoryFields(
            backupStatus,
            arrayOf(
                "backedUp",
            ),
        )
    ) {
        return null
    }
    val backedUp = backupStatus.getBoolean("backedUp")
    val lastBackupTime = if (hasNonNullKey(backupStatus, "lastBackupTime")) backupStatus.getDouble("lastBackupTime").toULong() else null
    return BackupStatus(
        backedUp,
        lastBackupTime,
    )
}

fun readableMapOf(backupStatus: BackupStatus): ReadableMap {
    return readableMapOf(
        "backedUp" to backupStatus.backedUp,
        "lastBackupTime" to backupStatus.lastBackupTime,
    )
}

fun asBackupStatusList(arr: ReadableArray): List<BackupStatus> {
    val list = ArrayList<BackupStatus>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asBackupStatus(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asBitcoinAddressData(bitcoinAddressData: ReadableMap): BitcoinAddressData? {
    if (!validateMandatoryFields(
            bitcoinAddressData,
            arrayOf(
                "address",
                "network",
            ),
        )
    ) {
        return null
    }
    val address = bitcoinAddressData.getString("address")!!
    val network = bitcoinAddressData.getString("network")?.let { asNetwork(it) }!!
    val amountSat = if (hasNonNullKey(bitcoinAddressData, "amountSat")) bitcoinAddressData.getDouble("amountSat").toULong() else null
    val label = if (hasNonNullKey(bitcoinAddressData, "label")) bitcoinAddressData.getString("label") else null
    val message = if (hasNonNullKey(bitcoinAddressData, "message")) bitcoinAddressData.getString("message") else null
    return BitcoinAddressData(
        address,
        network,
        amountSat,
        label,
        message,
    )
}

fun readableMapOf(bitcoinAddressData: BitcoinAddressData): ReadableMap {
    return readableMapOf(
        "address" to bitcoinAddressData.address,
        "network" to bitcoinAddressData.network.name.lowercase(),
        "amountSat" to bitcoinAddressData.amountSat,
        "label" to bitcoinAddressData.label,
        "message" to bitcoinAddressData.message,
    )
}

fun asBitcoinAddressDataList(arr: ReadableArray): List<BitcoinAddressData> {
    val list = ArrayList<BitcoinAddressData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asBitcoinAddressData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asBuyBitcoinRequest(buyBitcoinRequest: ReadableMap): BuyBitcoinRequest? {
    if (!validateMandatoryFields(
            buyBitcoinRequest,
            arrayOf(
                "provider",
            ),
        )
    ) {
        return null
    }
    val provider = buyBitcoinRequest.getString("provider")?.let { asBuyBitcoinProvider(it) }!!
    val openingFeeParams =
        if (hasNonNullKey(buyBitcoinRequest, "openingFeeParams")) {
            buyBitcoinRequest.getMap("openingFeeParams")?.let {
                asOpeningFeeParams(it)
            }
        } else {
            null
        }
    return BuyBitcoinRequest(
        provider,
        openingFeeParams,
    )
}

fun readableMapOf(buyBitcoinRequest: BuyBitcoinRequest): ReadableMap {
    return readableMapOf(
        "provider" to buyBitcoinRequest.provider.name.lowercase(),
        "openingFeeParams" to buyBitcoinRequest.openingFeeParams?.let { readableMapOf(it) },
    )
}

fun asBuyBitcoinRequestList(arr: ReadableArray): List<BuyBitcoinRequest> {
    val list = ArrayList<BuyBitcoinRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asBuyBitcoinRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asBuyBitcoinResponse(buyBitcoinResponse: ReadableMap): BuyBitcoinResponse? {
    if (!validateMandatoryFields(
            buyBitcoinResponse,
            arrayOf(
                "url",
            ),
        )
    ) {
        return null
    }
    val url = buyBitcoinResponse.getString("url")!!
    val openingFeeParams =
        if (hasNonNullKey(buyBitcoinResponse, "openingFeeParams")) {
            buyBitcoinResponse.getMap("openingFeeParams")?.let {
                asOpeningFeeParams(it)
            }
        } else {
            null
        }
    return BuyBitcoinResponse(
        url,
        openingFeeParams,
    )
}

fun readableMapOf(buyBitcoinResponse: BuyBitcoinResponse): ReadableMap {
    return readableMapOf(
        "url" to buyBitcoinResponse.url,
        "openingFeeParams" to buyBitcoinResponse.openingFeeParams?.let { readableMapOf(it) },
    )
}

fun asBuyBitcoinResponseList(arr: ReadableArray): List<BuyBitcoinResponse> {
    val list = ArrayList<BuyBitcoinResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asBuyBitcoinResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asCheckMessageRequest(checkMessageRequest: ReadableMap): CheckMessageRequest? {
    if (!validateMandatoryFields(
            checkMessageRequest,
            arrayOf(
                "message",
                "pubkey",
                "signature",
            ),
        )
    ) {
        return null
    }
    val message = checkMessageRequest.getString("message")!!
    val pubkey = checkMessageRequest.getString("pubkey")!!
    val signature = checkMessageRequest.getString("signature")!!
    return CheckMessageRequest(
        message,
        pubkey,
        signature,
    )
}

fun readableMapOf(checkMessageRequest: CheckMessageRequest): ReadableMap {
    return readableMapOf(
        "message" to checkMessageRequest.message,
        "pubkey" to checkMessageRequest.pubkey,
        "signature" to checkMessageRequest.signature,
    )
}

fun asCheckMessageRequestList(arr: ReadableArray): List<CheckMessageRequest> {
    val list = ArrayList<CheckMessageRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asCheckMessageRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asCheckMessageResponse(checkMessageResponse: ReadableMap): CheckMessageResponse? {
    if (!validateMandatoryFields(
            checkMessageResponse,
            arrayOf(
                "isValid",
            ),
        )
    ) {
        return null
    }
    val isValid = checkMessageResponse.getBoolean("isValid")
    return CheckMessageResponse(
        isValid,
    )
}

fun readableMapOf(checkMessageResponse: CheckMessageResponse): ReadableMap {
    return readableMapOf(
        "isValid" to checkMessageResponse.isValid,
    )
}

fun asCheckMessageResponseList(arr: ReadableArray): List<CheckMessageResponse> {
    val list = ArrayList<CheckMessageResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asCheckMessageResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asClosedChannelPaymentDetails(closedChannelPaymentDetails: ReadableMap): ClosedChannelPaymentDetails? {
    if (!validateMandatoryFields(
            closedChannelPaymentDetails,
            arrayOf(
                "state",
                "fundingTxid",
            ),
        )
    ) {
        return null
    }
    val state = closedChannelPaymentDetails.getString("state")?.let { asChannelState(it) }!!
    val fundingTxid = closedChannelPaymentDetails.getString("fundingTxid")!!
    val shortChannelId =
        if (hasNonNullKey(
                closedChannelPaymentDetails,
                "shortChannelId",
            )
        ) {
            closedChannelPaymentDetails.getString("shortChannelId")
        } else {
            null
        }
    val closingTxid =
        if (hasNonNullKey(
                closedChannelPaymentDetails,
                "closingTxid",
            )
        ) {
            closedChannelPaymentDetails.getString("closingTxid")
        } else {
            null
        }
    return ClosedChannelPaymentDetails(
        state,
        fundingTxid,
        shortChannelId,
        closingTxid,
    )
}

fun readableMapOf(closedChannelPaymentDetails: ClosedChannelPaymentDetails): ReadableMap {
    return readableMapOf(
        "state" to closedChannelPaymentDetails.state.name.lowercase(),
        "fundingTxid" to closedChannelPaymentDetails.fundingTxid,
        "shortChannelId" to closedChannelPaymentDetails.shortChannelId,
        "closingTxid" to closedChannelPaymentDetails.closingTxid,
    )
}

fun asClosedChannelPaymentDetailsList(arr: ReadableArray): List<ClosedChannelPaymentDetails> {
    val list = ArrayList<ClosedChannelPaymentDetails>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asClosedChannelPaymentDetails(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asConfig(config: ReadableMap): Config? {
    if (!validateMandatoryFields(
            config,
            arrayOf(
                "breezserver",
                "chainnotifierUrl",
                "workingDir",
                "network",
                "paymentTimeoutSec",
                "maxfeePercent",
                "exemptfeeMsat",
                "nodeConfig",
            ),
        )
    ) {
        return null
    }
    val breezserver = config.getString("breezserver")!!
    val chainnotifierUrl = config.getString("chainnotifierUrl")!!
    val mempoolspaceUrl = if (hasNonNullKey(config, "mempoolspaceUrl")) config.getString("mempoolspaceUrl") else null
    val workingDir = config.getString("workingDir")!!
    val network = config.getString("network")?.let { asNetwork(it) }!!
    val paymentTimeoutSec = config.getInt("paymentTimeoutSec").toUInt()
    val defaultLspId = if (hasNonNullKey(config, "defaultLspId")) config.getString("defaultLspId") else null
    val apiKey = if (hasNonNullKey(config, "apiKey")) config.getString("apiKey") else null
    val maxfeePercent = config.getDouble("maxfeePercent")
    val exemptfeeMsat = config.getDouble("exemptfeeMsat").toULong()
    val nodeConfig = config.getMap("nodeConfig")?.let { asNodeConfig(it) }!!
    return Config(
        breezserver,
        chainnotifierUrl,
        mempoolspaceUrl,
        workingDir,
        network,
        paymentTimeoutSec,
        defaultLspId,
        apiKey,
        maxfeePercent,
        exemptfeeMsat,
        nodeConfig,
    )
}

fun readableMapOf(config: Config): ReadableMap {
    return readableMapOf(
        "breezserver" to config.breezserver,
        "chainnotifierUrl" to config.chainnotifierUrl,
        "mempoolspaceUrl" to config.mempoolspaceUrl,
        "workingDir" to config.workingDir,
        "network" to config.network.name.lowercase(),
        "paymentTimeoutSec" to config.paymentTimeoutSec,
        "defaultLspId" to config.defaultLspId,
        "apiKey" to config.apiKey,
        "maxfeePercent" to config.maxfeePercent,
        "exemptfeeMsat" to config.exemptfeeMsat,
        "nodeConfig" to readableMapOf(config.nodeConfig),
    )
}

fun asConfigList(arr: ReadableArray): List<Config> {
    val list = ArrayList<Config>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asConfig(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asConfigureNodeRequest(configureNodeRequest: ReadableMap): ConfigureNodeRequest? {
    if (!validateMandatoryFields(
            configureNodeRequest,
            arrayOf(),
        )
    ) {
        return null
    }
    val closeToAddress =
        if (hasNonNullKey(
                configureNodeRequest,
                "closeToAddress",
            )
        ) {
            configureNodeRequest.getString("closeToAddress")
        } else {
            null
        }
    return ConfigureNodeRequest(
        closeToAddress,
    )
}

fun readableMapOf(configureNodeRequest: ConfigureNodeRequest): ReadableMap {
    return readableMapOf(
        "closeToAddress" to configureNodeRequest.closeToAddress,
    )
}

fun asConfigureNodeRequestList(arr: ReadableArray): List<ConfigureNodeRequest> {
    val list = ArrayList<ConfigureNodeRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asConfigureNodeRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asConnectRequest(connectRequest: ReadableMap): ConnectRequest? {
    if (!validateMandatoryFields(
            connectRequest,
            arrayOf(
                "config",
                "seed",
            ),
        )
    ) {
        return null
    }
    val config = connectRequest.getMap("config")?.let { asConfig(it) }!!
    val seed = connectRequest.getArray("seed")?.let { asUByteList(it) }!!
    val restoreOnly = if (hasNonNullKey(connectRequest, "restoreOnly")) connectRequest.getBoolean("restoreOnly") else null
    return ConnectRequest(
        config,
        seed,
        restoreOnly,
    )
}

fun readableMapOf(connectRequest: ConnectRequest): ReadableMap {
    return readableMapOf(
        "config" to readableMapOf(connectRequest.config),
        "seed" to readableArrayOf(connectRequest.seed),
        "restoreOnly" to connectRequest.restoreOnly,
    )
}

fun asConnectRequestList(arr: ReadableArray): List<ConnectRequest> {
    val list = ArrayList<ConnectRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asConnectRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asCurrencyInfo(currencyInfo: ReadableMap): CurrencyInfo? {
    if (!validateMandatoryFields(
            currencyInfo,
            arrayOf(
                "name",
                "fractionSize",
            ),
        )
    ) {
        return null
    }
    val name = currencyInfo.getString("name")!!
    val fractionSize = currencyInfo.getInt("fractionSize").toUInt()
    val spacing = if (hasNonNullKey(currencyInfo, "spacing")) currencyInfo.getInt("spacing").toUInt() else null
    val symbol = if (hasNonNullKey(currencyInfo, "symbol")) currencyInfo.getMap("symbol")?.let { asSymbol(it) } else null
    val uniqSymbol = if (hasNonNullKey(currencyInfo, "uniqSymbol")) currencyInfo.getMap("uniqSymbol")?.let { asSymbol(it) } else null
    val localizedName =
        if (hasNonNullKey(currencyInfo, "localizedName")) {
            currencyInfo.getArray("localizedName")?.let {
                asLocalizedNameList(it)
            }
        } else {
            null
        }
    val localeOverrides =
        if (hasNonNullKey(currencyInfo, "localeOverrides")) {
            currencyInfo.getArray("localeOverrides")?.let {
                asLocaleOverridesList(it)
            }
        } else {
            null
        }
    return CurrencyInfo(
        name,
        fractionSize,
        spacing,
        symbol,
        uniqSymbol,
        localizedName,
        localeOverrides,
    )
}

fun readableMapOf(currencyInfo: CurrencyInfo): ReadableMap {
    return readableMapOf(
        "name" to currencyInfo.name,
        "fractionSize" to currencyInfo.fractionSize,
        "spacing" to currencyInfo.spacing,
        "symbol" to currencyInfo.symbol?.let { readableMapOf(it) },
        "uniqSymbol" to currencyInfo.uniqSymbol?.let { readableMapOf(it) },
        "localizedName" to currencyInfo.localizedName?.let { readableArrayOf(it) },
        "localeOverrides" to currencyInfo.localeOverrides?.let { readableArrayOf(it) },
    )
}

fun asCurrencyInfoList(arr: ReadableArray): List<CurrencyInfo> {
    val list = ArrayList<CurrencyInfo>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asCurrencyInfo(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asFiatCurrency(fiatCurrency: ReadableMap): FiatCurrency? {
    if (!validateMandatoryFields(
            fiatCurrency,
            arrayOf(
                "id",
                "info",
            ),
        )
    ) {
        return null
    }
    val id = fiatCurrency.getString("id")!!
    val info = fiatCurrency.getMap("info")?.let { asCurrencyInfo(it) }!!
    return FiatCurrency(
        id,
        info,
    )
}

fun readableMapOf(fiatCurrency: FiatCurrency): ReadableMap {
    return readableMapOf(
        "id" to fiatCurrency.id,
        "info" to readableMapOf(fiatCurrency.info),
    )
}

fun asFiatCurrencyList(arr: ReadableArray): List<FiatCurrency> {
    val list = ArrayList<FiatCurrency>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asFiatCurrency(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asGreenlightCredentials(greenlightCredentials: ReadableMap): GreenlightCredentials? {
    if (!validateMandatoryFields(
            greenlightCredentials,
            arrayOf(
                "deviceKey",
                "deviceCert",
            ),
        )
    ) {
        return null
    }
    val deviceKey = greenlightCredentials.getArray("deviceKey")?.let { asUByteList(it) }!!
    val deviceCert = greenlightCredentials.getArray("deviceCert")?.let { asUByteList(it) }!!
    return GreenlightCredentials(
        deviceKey,
        deviceCert,
    )
}

fun readableMapOf(greenlightCredentials: GreenlightCredentials): ReadableMap {
    return readableMapOf(
        "deviceKey" to readableArrayOf(greenlightCredentials.deviceKey),
        "deviceCert" to readableArrayOf(greenlightCredentials.deviceCert),
    )
}

fun asGreenlightCredentialsList(arr: ReadableArray): List<GreenlightCredentials> {
    val list = ArrayList<GreenlightCredentials>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asGreenlightCredentials(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asGreenlightNodeConfig(greenlightNodeConfig: ReadableMap): GreenlightNodeConfig? {
    if (!validateMandatoryFields(
            greenlightNodeConfig,
            arrayOf(),
        )
    ) {
        return null
    }
    val partnerCredentials =
        if (hasNonNullKey(
                greenlightNodeConfig,
                "partnerCredentials",
            )
        ) {
            greenlightNodeConfig.getMap("partnerCredentials")?.let {
                asGreenlightCredentials(it)
            }
        } else {
            null
        }
    val inviteCode = if (hasNonNullKey(greenlightNodeConfig, "inviteCode")) greenlightNodeConfig.getString("inviteCode") else null
    return GreenlightNodeConfig(
        partnerCredentials,
        inviteCode,
    )
}

fun readableMapOf(greenlightNodeConfig: GreenlightNodeConfig): ReadableMap {
    return readableMapOf(
        "partnerCredentials" to greenlightNodeConfig.partnerCredentials?.let { readableMapOf(it) },
        "inviteCode" to greenlightNodeConfig.inviteCode,
    )
}

fun asGreenlightNodeConfigList(arr: ReadableArray): List<GreenlightNodeConfig> {
    val list = ArrayList<GreenlightNodeConfig>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asGreenlightNodeConfig(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asInvoicePaidDetails(invoicePaidDetails: ReadableMap): InvoicePaidDetails? {
    if (!validateMandatoryFields(
            invoicePaidDetails,
            arrayOf(
                "paymentHash",
                "bolt11",
            ),
        )
    ) {
        return null
    }
    val paymentHash = invoicePaidDetails.getString("paymentHash")!!
    val bolt11 = invoicePaidDetails.getString("bolt11")!!
    val payment = if (hasNonNullKey(invoicePaidDetails, "payment")) invoicePaidDetails.getMap("payment")?.let { asPayment(it) } else null
    return InvoicePaidDetails(
        paymentHash,
        bolt11,
        payment,
    )
}

fun readableMapOf(invoicePaidDetails: InvoicePaidDetails): ReadableMap {
    return readableMapOf(
        "paymentHash" to invoicePaidDetails.paymentHash,
        "bolt11" to invoicePaidDetails.bolt11,
        "payment" to invoicePaidDetails.payment?.let { readableMapOf(it) },
    )
}

fun asInvoicePaidDetailsList(arr: ReadableArray): List<InvoicePaidDetails> {
    val list = ArrayList<InvoicePaidDetails>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asInvoicePaidDetails(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnInvoice(lnInvoice: ReadableMap): LnInvoice? {
    if (!validateMandatoryFields(
            lnInvoice,
            arrayOf(
                "bolt11",
                "network",
                "payeePubkey",
                "paymentHash",
                "timestamp",
                "expiry",
                "routingHints",
                "paymentSecret",
                "minFinalCltvExpiryDelta",
            ),
        )
    ) {
        return null
    }
    val bolt11 = lnInvoice.getString("bolt11")!!
    val network = lnInvoice.getString("network")?.let { asNetwork(it) }!!
    val payeePubkey = lnInvoice.getString("payeePubkey")!!
    val paymentHash = lnInvoice.getString("paymentHash")!!
    val description = if (hasNonNullKey(lnInvoice, "description")) lnInvoice.getString("description") else null
    val descriptionHash = if (hasNonNullKey(lnInvoice, "descriptionHash")) lnInvoice.getString("descriptionHash") else null
    val amountMsat = if (hasNonNullKey(lnInvoice, "amountMsat")) lnInvoice.getDouble("amountMsat").toULong() else null
    val timestamp = lnInvoice.getDouble("timestamp").toULong()
    val expiry = lnInvoice.getDouble("expiry").toULong()
    val routingHints = lnInvoice.getArray("routingHints")?.let { asRouteHintList(it) }!!
    val paymentSecret = lnInvoice.getArray("paymentSecret")?.let { asUByteList(it) }!!
    val minFinalCltvExpiryDelta = lnInvoice.getDouble("minFinalCltvExpiryDelta").toULong()
    return LnInvoice(
        bolt11,
        network,
        payeePubkey,
        paymentHash,
        description,
        descriptionHash,
        amountMsat,
        timestamp,
        expiry,
        routingHints,
        paymentSecret,
        minFinalCltvExpiryDelta,
    )
}

fun readableMapOf(lnInvoice: LnInvoice): ReadableMap {
    return readableMapOf(
        "bolt11" to lnInvoice.bolt11,
        "network" to lnInvoice.network.name.lowercase(),
        "payeePubkey" to lnInvoice.payeePubkey,
        "paymentHash" to lnInvoice.paymentHash,
        "description" to lnInvoice.description,
        "descriptionHash" to lnInvoice.descriptionHash,
        "amountMsat" to lnInvoice.amountMsat,
        "timestamp" to lnInvoice.timestamp,
        "expiry" to lnInvoice.expiry,
        "routingHints" to readableArrayOf(lnInvoice.routingHints),
        "paymentSecret" to readableArrayOf(lnInvoice.paymentSecret),
        "minFinalCltvExpiryDelta" to lnInvoice.minFinalCltvExpiryDelta,
    )
}

fun asLnInvoiceList(arr: ReadableArray): List<LnInvoice> {
    val list = ArrayList<LnInvoice>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnInvoice(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asListPaymentsRequest(listPaymentsRequest: ReadableMap): ListPaymentsRequest? {
    if (!validateMandatoryFields(
            listPaymentsRequest,
            arrayOf(),
        )
    ) {
        return null
    }
    val filters =
        if (hasNonNullKey(listPaymentsRequest, "filters")) {
            listPaymentsRequest.getArray("filters")?.let {
                asPaymentTypeFilterList(it)
            }
        } else {
            null
        }
    val metadataFilters =
        if (hasNonNullKey(listPaymentsRequest, "metadataFilters")) {
            listPaymentsRequest.getArray("metadataFilters")?.let {
                asMetadataFilterList(it)
            }
        } else {
            null
        }
    val fromTimestamp =
        if (hasNonNullKey(
                listPaymentsRequest,
                "fromTimestamp",
            )
        ) {
            listPaymentsRequest.getDouble("fromTimestamp").toLong()
        } else {
            null
        }
    val toTimestamp = if (hasNonNullKey(listPaymentsRequest, "toTimestamp")) listPaymentsRequest.getDouble("toTimestamp").toLong() else null
    val includeFailures =
        if (hasNonNullKey(
                listPaymentsRequest,
                "includeFailures",
            )
        ) {
            listPaymentsRequest.getBoolean("includeFailures")
        } else {
            null
        }
    val offset = if (hasNonNullKey(listPaymentsRequest, "offset")) listPaymentsRequest.getInt("offset").toUInt() else null
    val limit = if (hasNonNullKey(listPaymentsRequest, "limit")) listPaymentsRequest.getInt("limit").toUInt() else null
    return ListPaymentsRequest(
        filters,
        metadataFilters,
        fromTimestamp,
        toTimestamp,
        includeFailures,
        offset,
        limit,
    )
}

fun readableMapOf(listPaymentsRequest: ListPaymentsRequest): ReadableMap {
    return readableMapOf(
        "filters" to listPaymentsRequest.filters?.let { readableArrayOf(it) },
        "metadataFilters" to listPaymentsRequest.metadataFilters?.let { readableArrayOf(it) },
        "fromTimestamp" to listPaymentsRequest.fromTimestamp,
        "toTimestamp" to listPaymentsRequest.toTimestamp,
        "includeFailures" to listPaymentsRequest.includeFailures,
        "offset" to listPaymentsRequest.offset,
        "limit" to listPaymentsRequest.limit,
    )
}

fun asListPaymentsRequestList(arr: ReadableArray): List<ListPaymentsRequest> {
    val list = ArrayList<ListPaymentsRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asListPaymentsRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnPaymentDetails(lnPaymentDetails: ReadableMap): LnPaymentDetails? {
    if (!validateMandatoryFields(
            lnPaymentDetails,
            arrayOf(
                "paymentHash",
                "label",
                "destinationPubkey",
                "paymentPreimage",
                "keysend",
                "bolt11",
            ),
        )
    ) {
        return null
    }
    val paymentHash = lnPaymentDetails.getString("paymentHash")!!
    val label = lnPaymentDetails.getString("label")!!
    val destinationPubkey = lnPaymentDetails.getString("destinationPubkey")!!
    val paymentPreimage = lnPaymentDetails.getString("paymentPreimage")!!
    val keysend = lnPaymentDetails.getBoolean("keysend")
    val bolt11 = lnPaymentDetails.getString("bolt11")!!
    val openChannelBolt11 =
        if (hasNonNullKey(
                lnPaymentDetails,
                "openChannelBolt11",
            )
        ) {
            lnPaymentDetails.getString("openChannelBolt11")
        } else {
            null
        }
    val lnurlSuccessAction =
        if (hasNonNullKey(lnPaymentDetails, "lnurlSuccessAction")) {
            lnPaymentDetails.getMap("lnurlSuccessAction")?.let {
                asSuccessActionProcessed(it)
            }
        } else {
            null
        }
    val lnurlPayDomain = if (hasNonNullKey(lnPaymentDetails, "lnurlPayDomain")) lnPaymentDetails.getString("lnurlPayDomain") else null
    val lnurlMetadata = if (hasNonNullKey(lnPaymentDetails, "lnurlMetadata")) lnPaymentDetails.getString("lnurlMetadata") else null
    val lnAddress = if (hasNonNullKey(lnPaymentDetails, "lnAddress")) lnPaymentDetails.getString("lnAddress") else null
    val lnurlWithdrawEndpoint =
        if (hasNonNullKey(
                lnPaymentDetails,
                "lnurlWithdrawEndpoint",
            )
        ) {
            lnPaymentDetails.getString("lnurlWithdrawEndpoint")
        } else {
            null
        }
    val swapInfo = if (hasNonNullKey(lnPaymentDetails, "swapInfo")) lnPaymentDetails.getMap("swapInfo")?.let { asSwapInfo(it) } else null
    val reverseSwapInfo =
        if (hasNonNullKey(lnPaymentDetails, "reverseSwapInfo")) {
            lnPaymentDetails.getMap("reverseSwapInfo")?.let {
                asReverseSwapInfo(it)
            }
        } else {
            null
        }
    val pendingExpirationBlock =
        if (hasNonNullKey(
                lnPaymentDetails,
                "pendingExpirationBlock",
            )
        ) {
            lnPaymentDetails.getInt("pendingExpirationBlock").toUInt()
        } else {
            null
        }
    return LnPaymentDetails(
        paymentHash,
        label,
        destinationPubkey,
        paymentPreimage,
        keysend,
        bolt11,
        openChannelBolt11,
        lnurlSuccessAction,
        lnurlPayDomain,
        lnurlMetadata,
        lnAddress,
        lnurlWithdrawEndpoint,
        swapInfo,
        reverseSwapInfo,
        pendingExpirationBlock,
    )
}

fun readableMapOf(lnPaymentDetails: LnPaymentDetails): ReadableMap {
    return readableMapOf(
        "paymentHash" to lnPaymentDetails.paymentHash,
        "label" to lnPaymentDetails.label,
        "destinationPubkey" to lnPaymentDetails.destinationPubkey,
        "paymentPreimage" to lnPaymentDetails.paymentPreimage,
        "keysend" to lnPaymentDetails.keysend,
        "bolt11" to lnPaymentDetails.bolt11,
        "openChannelBolt11" to lnPaymentDetails.openChannelBolt11,
        "lnurlSuccessAction" to lnPaymentDetails.lnurlSuccessAction?.let { readableMapOf(it) },
        "lnurlPayDomain" to lnPaymentDetails.lnurlPayDomain,
        "lnurlMetadata" to lnPaymentDetails.lnurlMetadata,
        "lnAddress" to lnPaymentDetails.lnAddress,
        "lnurlWithdrawEndpoint" to lnPaymentDetails.lnurlWithdrawEndpoint,
        "swapInfo" to lnPaymentDetails.swapInfo?.let { readableMapOf(it) },
        "reverseSwapInfo" to lnPaymentDetails.reverseSwapInfo?.let { readableMapOf(it) },
        "pendingExpirationBlock" to lnPaymentDetails.pendingExpirationBlock,
    )
}

fun asLnPaymentDetailsList(arr: ReadableArray): List<LnPaymentDetails> {
    val list = ArrayList<LnPaymentDetails>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnPaymentDetails(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlAuthRequestData(lnUrlAuthRequestData: ReadableMap): LnUrlAuthRequestData? {
    if (!validateMandatoryFields(
            lnUrlAuthRequestData,
            arrayOf(
                "k1",
                "domain",
                "url",
            ),
        )
    ) {
        return null
    }
    val k1 = lnUrlAuthRequestData.getString("k1")!!
    val domain = lnUrlAuthRequestData.getString("domain")!!
    val url = lnUrlAuthRequestData.getString("url")!!
    val action = if (hasNonNullKey(lnUrlAuthRequestData, "action")) lnUrlAuthRequestData.getString("action") else null
    return LnUrlAuthRequestData(
        k1,
        domain,
        url,
        action,
    )
}

fun readableMapOf(lnUrlAuthRequestData: LnUrlAuthRequestData): ReadableMap {
    return readableMapOf(
        "k1" to lnUrlAuthRequestData.k1,
        "domain" to lnUrlAuthRequestData.domain,
        "url" to lnUrlAuthRequestData.url,
        "action" to lnUrlAuthRequestData.action,
    )
}

fun asLnUrlAuthRequestDataList(arr: ReadableArray): List<LnUrlAuthRequestData> {
    val list = ArrayList<LnUrlAuthRequestData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlAuthRequestData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlErrorData(lnUrlErrorData: ReadableMap): LnUrlErrorData? {
    if (!validateMandatoryFields(
            lnUrlErrorData,
            arrayOf(
                "reason",
            ),
        )
    ) {
        return null
    }
    val reason = lnUrlErrorData.getString("reason")!!
    return LnUrlErrorData(
        reason,
    )
}

fun readableMapOf(lnUrlErrorData: LnUrlErrorData): ReadableMap {
    return readableMapOf(
        "reason" to lnUrlErrorData.reason,
    )
}

fun asLnUrlErrorDataList(arr: ReadableArray): List<LnUrlErrorData> {
    val list = ArrayList<LnUrlErrorData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlErrorData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlPayErrorData(lnUrlPayErrorData: ReadableMap): LnUrlPayErrorData? {
    if (!validateMandatoryFields(
            lnUrlPayErrorData,
            arrayOf(
                "paymentHash",
                "reason",
            ),
        )
    ) {
        return null
    }
    val paymentHash = lnUrlPayErrorData.getString("paymentHash")!!
    val reason = lnUrlPayErrorData.getString("reason")!!
    return LnUrlPayErrorData(
        paymentHash,
        reason,
    )
}

fun readableMapOf(lnUrlPayErrorData: LnUrlPayErrorData): ReadableMap {
    return readableMapOf(
        "paymentHash" to lnUrlPayErrorData.paymentHash,
        "reason" to lnUrlPayErrorData.reason,
    )
}

fun asLnUrlPayErrorDataList(arr: ReadableArray): List<LnUrlPayErrorData> {
    val list = ArrayList<LnUrlPayErrorData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlPayErrorData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlPayRequest(lnUrlPayRequest: ReadableMap): LnUrlPayRequest? {
    if (!validateMandatoryFields(
            lnUrlPayRequest,
            arrayOf(
                "data",
                "amountMsat",
            ),
        )
    ) {
        return null
    }
    val data = lnUrlPayRequest.getMap("data")?.let { asLnUrlPayRequestData(it) }!!
    val amountMsat = lnUrlPayRequest.getDouble("amountMsat").toULong()
    val comment = if (hasNonNullKey(lnUrlPayRequest, "comment")) lnUrlPayRequest.getString("comment") else null
    return LnUrlPayRequest(
        data,
        amountMsat,
        comment,
    )
}

fun readableMapOf(lnUrlPayRequest: LnUrlPayRequest): ReadableMap {
    return readableMapOf(
        "data" to readableMapOf(lnUrlPayRequest.data),
        "amountMsat" to lnUrlPayRequest.amountMsat,
        "comment" to lnUrlPayRequest.comment,
    )
}

fun asLnUrlPayRequestList(arr: ReadableArray): List<LnUrlPayRequest> {
    val list = ArrayList<LnUrlPayRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlPayRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlPayRequestData(lnUrlPayRequestData: ReadableMap): LnUrlPayRequestData? {
    if (!validateMandatoryFields(
            lnUrlPayRequestData,
            arrayOf(
                "callback",
                "minSendable",
                "maxSendable",
                "metadataStr",
                "commentAllowed",
                "domain",
            ),
        )
    ) {
        return null
    }
    val callback = lnUrlPayRequestData.getString("callback")!!
    val minSendable = lnUrlPayRequestData.getDouble("minSendable").toULong()
    val maxSendable = lnUrlPayRequestData.getDouble("maxSendable").toULong()
    val metadataStr = lnUrlPayRequestData.getString("metadataStr")!!
    val commentAllowed = lnUrlPayRequestData.getInt("commentAllowed").toUShort()
    val domain = lnUrlPayRequestData.getString("domain")!!
    val lnAddress = if (hasNonNullKey(lnUrlPayRequestData, "lnAddress")) lnUrlPayRequestData.getString("lnAddress") else null
    return LnUrlPayRequestData(
        callback,
        minSendable,
        maxSendable,
        metadataStr,
        commentAllowed,
        domain,
        lnAddress,
    )
}

fun readableMapOf(lnUrlPayRequestData: LnUrlPayRequestData): ReadableMap {
    return readableMapOf(
        "callback" to lnUrlPayRequestData.callback,
        "minSendable" to lnUrlPayRequestData.minSendable,
        "maxSendable" to lnUrlPayRequestData.maxSendable,
        "metadataStr" to lnUrlPayRequestData.metadataStr,
        "commentAllowed" to lnUrlPayRequestData.commentAllowed,
        "domain" to lnUrlPayRequestData.domain,
        "lnAddress" to lnUrlPayRequestData.lnAddress,
    )
}

fun asLnUrlPayRequestDataList(arr: ReadableArray): List<LnUrlPayRequestData> {
    val list = ArrayList<LnUrlPayRequestData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlPayRequestData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlPaySuccessData(lnUrlPaySuccessData: ReadableMap): LnUrlPaySuccessData? {
    if (!validateMandatoryFields(
            lnUrlPaySuccessData,
            arrayOf(
                "paymentHash",
            ),
        )
    ) {
        return null
    }
    val successAction =
        if (hasNonNullKey(lnUrlPaySuccessData, "successAction")) {
            lnUrlPaySuccessData.getMap("successAction")?.let {
                asSuccessActionProcessed(it)
            }
        } else {
            null
        }
    val paymentHash = lnUrlPaySuccessData.getString("paymentHash")!!
    return LnUrlPaySuccessData(
        successAction,
        paymentHash,
    )
}

fun readableMapOf(lnUrlPaySuccessData: LnUrlPaySuccessData): ReadableMap {
    return readableMapOf(
        "successAction" to lnUrlPaySuccessData.successAction?.let { readableMapOf(it) },
        "paymentHash" to lnUrlPaySuccessData.paymentHash,
    )
}

fun asLnUrlPaySuccessDataList(arr: ReadableArray): List<LnUrlPaySuccessData> {
    val list = ArrayList<LnUrlPaySuccessData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlPaySuccessData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlWithdrawRequest(lnUrlWithdrawRequest: ReadableMap): LnUrlWithdrawRequest? {
    if (!validateMandatoryFields(
            lnUrlWithdrawRequest,
            arrayOf(
                "data",
                "amountMsat",
            ),
        )
    ) {
        return null
    }
    val data = lnUrlWithdrawRequest.getMap("data")?.let { asLnUrlWithdrawRequestData(it) }!!
    val amountMsat = lnUrlWithdrawRequest.getDouble("amountMsat").toULong()
    val description = if (hasNonNullKey(lnUrlWithdrawRequest, "description")) lnUrlWithdrawRequest.getString("description") else null
    return LnUrlWithdrawRequest(
        data,
        amountMsat,
        description,
    )
}

fun readableMapOf(lnUrlWithdrawRequest: LnUrlWithdrawRequest): ReadableMap {
    return readableMapOf(
        "data" to readableMapOf(lnUrlWithdrawRequest.data),
        "amountMsat" to lnUrlWithdrawRequest.amountMsat,
        "description" to lnUrlWithdrawRequest.description,
    )
}

fun asLnUrlWithdrawRequestList(arr: ReadableArray): List<LnUrlWithdrawRequest> {
    val list = ArrayList<LnUrlWithdrawRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlWithdrawRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlWithdrawRequestData(lnUrlWithdrawRequestData: ReadableMap): LnUrlWithdrawRequestData? {
    if (!validateMandatoryFields(
            lnUrlWithdrawRequestData,
            arrayOf(
                "callback",
                "k1",
                "defaultDescription",
                "minWithdrawable",
                "maxWithdrawable",
            ),
        )
    ) {
        return null
    }
    val callback = lnUrlWithdrawRequestData.getString("callback")!!
    val k1 = lnUrlWithdrawRequestData.getString("k1")!!
    val defaultDescription = lnUrlWithdrawRequestData.getString("defaultDescription")!!
    val minWithdrawable = lnUrlWithdrawRequestData.getDouble("minWithdrawable").toULong()
    val maxWithdrawable = lnUrlWithdrawRequestData.getDouble("maxWithdrawable").toULong()
    return LnUrlWithdrawRequestData(
        callback,
        k1,
        defaultDescription,
        minWithdrawable,
        maxWithdrawable,
    )
}

fun readableMapOf(lnUrlWithdrawRequestData: LnUrlWithdrawRequestData): ReadableMap {
    return readableMapOf(
        "callback" to lnUrlWithdrawRequestData.callback,
        "k1" to lnUrlWithdrawRequestData.k1,
        "defaultDescription" to lnUrlWithdrawRequestData.defaultDescription,
        "minWithdrawable" to lnUrlWithdrawRequestData.minWithdrawable,
        "maxWithdrawable" to lnUrlWithdrawRequestData.maxWithdrawable,
    )
}

fun asLnUrlWithdrawRequestDataList(arr: ReadableArray): List<LnUrlWithdrawRequestData> {
    val list = ArrayList<LnUrlWithdrawRequestData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlWithdrawRequestData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlWithdrawSuccessData(lnUrlWithdrawSuccessData: ReadableMap): LnUrlWithdrawSuccessData? {
    if (!validateMandatoryFields(
            lnUrlWithdrawSuccessData,
            arrayOf(
                "invoice",
            ),
        )
    ) {
        return null
    }
    val invoice = lnUrlWithdrawSuccessData.getMap("invoice")?.let { asLnInvoice(it) }!!
    return LnUrlWithdrawSuccessData(
        invoice,
    )
}

fun readableMapOf(lnUrlWithdrawSuccessData: LnUrlWithdrawSuccessData): ReadableMap {
    return readableMapOf(
        "invoice" to readableMapOf(lnUrlWithdrawSuccessData.invoice),
    )
}

fun asLnUrlWithdrawSuccessDataList(arr: ReadableArray): List<LnUrlWithdrawSuccessData> {
    val list = ArrayList<LnUrlWithdrawSuccessData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlWithdrawSuccessData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLocaleOverrides(localeOverrides: ReadableMap): LocaleOverrides? {
    if (!validateMandatoryFields(
            localeOverrides,
            arrayOf(
                "locale",
                "symbol",
            ),
        )
    ) {
        return null
    }
    val locale = localeOverrides.getString("locale")!!
    val spacing = if (hasNonNullKey(localeOverrides, "spacing")) localeOverrides.getInt("spacing").toUInt() else null
    val symbol = localeOverrides.getMap("symbol")?.let { asSymbol(it) }!!
    return LocaleOverrides(
        locale,
        spacing,
        symbol,
    )
}

fun readableMapOf(localeOverrides: LocaleOverrides): ReadableMap {
    return readableMapOf(
        "locale" to localeOverrides.locale,
        "spacing" to localeOverrides.spacing,
        "symbol" to readableMapOf(localeOverrides.symbol),
    )
}

fun asLocaleOverridesList(arr: ReadableArray): List<LocaleOverrides> {
    val list = ArrayList<LocaleOverrides>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLocaleOverrides(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLocalizedName(localizedName: ReadableMap): LocalizedName? {
    if (!validateMandatoryFields(
            localizedName,
            arrayOf(
                "locale",
                "name",
            ),
        )
    ) {
        return null
    }
    val locale = localizedName.getString("locale")!!
    val name = localizedName.getString("name")!!
    return LocalizedName(
        locale,
        name,
    )
}

fun readableMapOf(localizedName: LocalizedName): ReadableMap {
    return readableMapOf(
        "locale" to localizedName.locale,
        "name" to localizedName.name,
    )
}

fun asLocalizedNameList(arr: ReadableArray): List<LocalizedName> {
    val list = ArrayList<LocalizedName>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLocalizedName(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLogEntry(logEntry: ReadableMap): LogEntry? {
    if (!validateMandatoryFields(
            logEntry,
            arrayOf(
                "line",
                "level",
            ),
        )
    ) {
        return null
    }
    val line = logEntry.getString("line")!!
    val level = logEntry.getString("level")!!
    return LogEntry(
        line,
        level,
    )
}

fun readableMapOf(logEntry: LogEntry): ReadableMap {
    return readableMapOf(
        "line" to logEntry.line,
        "level" to logEntry.level,
    )
}

fun asLogEntryList(arr: ReadableArray): List<LogEntry> {
    val list = ArrayList<LogEntry>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLogEntry(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLspInformation(lspInformation: ReadableMap): LspInformation? {
    if (!validateMandatoryFields(
            lspInformation,
            arrayOf(
                "id",
                "name",
                "widgetUrl",
                "pubkey",
                "host",
                "baseFeeMsat",
                "feeRate",
                "timeLockDelta",
                "minHtlcMsat",
                "lspPubkey",
                "openingFeeParamsList",
            ),
        )
    ) {
        return null
    }
    val id = lspInformation.getString("id")!!
    val name = lspInformation.getString("name")!!
    val widgetUrl = lspInformation.getString("widgetUrl")!!
    val pubkey = lspInformation.getString("pubkey")!!
    val host = lspInformation.getString("host")!!
    val baseFeeMsat = lspInformation.getDouble("baseFeeMsat").toLong()
    val feeRate = lspInformation.getDouble("feeRate")
    val timeLockDelta = lspInformation.getInt("timeLockDelta").toUInt()
    val minHtlcMsat = lspInformation.getDouble("minHtlcMsat").toLong()
    val lspPubkey = lspInformation.getArray("lspPubkey")?.let { asUByteList(it) }!!
    val openingFeeParamsList = lspInformation.getMap("openingFeeParamsList")?.let { asOpeningFeeParamsMenu(it) }!!
    return LspInformation(
        id,
        name,
        widgetUrl,
        pubkey,
        host,
        baseFeeMsat,
        feeRate,
        timeLockDelta,
        minHtlcMsat,
        lspPubkey,
        openingFeeParamsList,
    )
}

fun readableMapOf(lspInformation: LspInformation): ReadableMap {
    return readableMapOf(
        "id" to lspInformation.id,
        "name" to lspInformation.name,
        "widgetUrl" to lspInformation.widgetUrl,
        "pubkey" to lspInformation.pubkey,
        "host" to lspInformation.host,
        "baseFeeMsat" to lspInformation.baseFeeMsat,
        "feeRate" to lspInformation.feeRate,
        "timeLockDelta" to lspInformation.timeLockDelta,
        "minHtlcMsat" to lspInformation.minHtlcMsat,
        "lspPubkey" to readableArrayOf(lspInformation.lspPubkey),
        "openingFeeParamsList" to readableMapOf(lspInformation.openingFeeParamsList),
    )
}

fun asLspInformationList(arr: ReadableArray): List<LspInformation> {
    val list = ArrayList<LspInformation>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLspInformation(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asMaxReverseSwapAmountResponse(maxReverseSwapAmountResponse: ReadableMap): MaxReverseSwapAmountResponse? {
    if (!validateMandatoryFields(
            maxReverseSwapAmountResponse,
            arrayOf(
                "totalSat",
            ),
        )
    ) {
        return null
    }
    val totalSat = maxReverseSwapAmountResponse.getDouble("totalSat").toULong()
    return MaxReverseSwapAmountResponse(
        totalSat,
    )
}

fun readableMapOf(maxReverseSwapAmountResponse: MaxReverseSwapAmountResponse): ReadableMap {
    return readableMapOf(
        "totalSat" to maxReverseSwapAmountResponse.totalSat,
    )
}

fun asMaxReverseSwapAmountResponseList(arr: ReadableArray): List<MaxReverseSwapAmountResponse> {
    val list = ArrayList<MaxReverseSwapAmountResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asMaxReverseSwapAmountResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asMessageSuccessActionData(messageSuccessActionData: ReadableMap): MessageSuccessActionData? {
    if (!validateMandatoryFields(
            messageSuccessActionData,
            arrayOf(
                "message",
            ),
        )
    ) {
        return null
    }
    val message = messageSuccessActionData.getString("message")!!
    return MessageSuccessActionData(
        message,
    )
}

fun readableMapOf(messageSuccessActionData: MessageSuccessActionData): ReadableMap {
    return readableMapOf(
        "message" to messageSuccessActionData.message,
    )
}

fun asMessageSuccessActionDataList(arr: ReadableArray): List<MessageSuccessActionData> {
    val list = ArrayList<MessageSuccessActionData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asMessageSuccessActionData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asMetadataFilter(metadataFilter: ReadableMap): MetadataFilter? {
    if (!validateMandatoryFields(
            metadataFilter,
            arrayOf(
                "jsonPath",
                "jsonValue",
            ),
        )
    ) {
        return null
    }
    val jsonPath = metadataFilter.getString("jsonPath")!!
    val jsonValue = metadataFilter.getString("jsonValue")!!
    return MetadataFilter(
        jsonPath,
        jsonValue,
    )
}

fun readableMapOf(metadataFilter: MetadataFilter): ReadableMap {
    return readableMapOf(
        "jsonPath" to metadataFilter.jsonPath,
        "jsonValue" to metadataFilter.jsonValue,
    )
}

fun asMetadataFilterList(arr: ReadableArray): List<MetadataFilter> {
    val list = ArrayList<MetadataFilter>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asMetadataFilter(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asMetadataItem(metadataItem: ReadableMap): MetadataItem? {
    if (!validateMandatoryFields(
            metadataItem,
            arrayOf(
                "key",
                "value",
            ),
        )
    ) {
        return null
    }
    val key = metadataItem.getString("key")!!
    val value = metadataItem.getString("value")!!
    return MetadataItem(
        key,
        value,
    )
}

fun readableMapOf(metadataItem: MetadataItem): ReadableMap {
    return readableMapOf(
        "key" to metadataItem.key,
        "value" to metadataItem.value,
    )
}

fun asMetadataItemList(arr: ReadableArray): List<MetadataItem> {
    val list = ArrayList<MetadataItem>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asMetadataItem(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asNodeState(nodeState: ReadableMap): NodeState? {
    if (!validateMandatoryFields(
            nodeState,
            arrayOf(
                "id",
                "blockHeight",
                "channelsBalanceMsat",
                "onchainBalanceMsat",
                "pendingOnchainBalanceMsat",
                "utxos",
                "maxPayableMsat",
                "maxReceivableMsat",
                "maxSinglePaymentAmountMsat",
                "maxChanReserveMsats",
                "connectedPeers",
                "inboundLiquidityMsats",
            ),
        )
    ) {
        return null
    }
    val id = nodeState.getString("id")!!
    val blockHeight = nodeState.getInt("blockHeight").toUInt()
    val channelsBalanceMsat = nodeState.getDouble("channelsBalanceMsat").toULong()
    val onchainBalanceMsat = nodeState.getDouble("onchainBalanceMsat").toULong()
    val pendingOnchainBalanceMsat = nodeState.getDouble("pendingOnchainBalanceMsat").toULong()
    val utxos = nodeState.getArray("utxos")?.let { asUnspentTransactionOutputList(it) }!!
    val maxPayableMsat = nodeState.getDouble("maxPayableMsat").toULong()
    val maxReceivableMsat = nodeState.getDouble("maxReceivableMsat").toULong()
    val maxSinglePaymentAmountMsat = nodeState.getDouble("maxSinglePaymentAmountMsat").toULong()
    val maxChanReserveMsats = nodeState.getDouble("maxChanReserveMsats").toULong()
    val connectedPeers = nodeState.getArray("connectedPeers")?.let { asStringList(it) }!!
    val inboundLiquidityMsats = nodeState.getDouble("inboundLiquidityMsats").toULong()
    return NodeState(
        id,
        blockHeight,
        channelsBalanceMsat,
        onchainBalanceMsat,
        pendingOnchainBalanceMsat,
        utxos,
        maxPayableMsat,
        maxReceivableMsat,
        maxSinglePaymentAmountMsat,
        maxChanReserveMsats,
        connectedPeers,
        inboundLiquidityMsats,
    )
}

fun readableMapOf(nodeState: NodeState): ReadableMap {
    return readableMapOf(
        "id" to nodeState.id,
        "blockHeight" to nodeState.blockHeight,
        "channelsBalanceMsat" to nodeState.channelsBalanceMsat,
        "onchainBalanceMsat" to nodeState.onchainBalanceMsat,
        "pendingOnchainBalanceMsat" to nodeState.pendingOnchainBalanceMsat,
        "utxos" to readableArrayOf(nodeState.utxos),
        "maxPayableMsat" to nodeState.maxPayableMsat,
        "maxReceivableMsat" to nodeState.maxReceivableMsat,
        "maxSinglePaymentAmountMsat" to nodeState.maxSinglePaymentAmountMsat,
        "maxChanReserveMsats" to nodeState.maxChanReserveMsats,
        "connectedPeers" to readableArrayOf(nodeState.connectedPeers),
        "inboundLiquidityMsats" to nodeState.inboundLiquidityMsats,
    )
}

fun asNodeStateList(arr: ReadableArray): List<NodeState> {
    val list = ArrayList<NodeState>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asNodeState(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asOnchainPaymentLimitsResponse(onchainPaymentLimitsResponse: ReadableMap): OnchainPaymentLimitsResponse? {
    if (!validateMandatoryFields(
            onchainPaymentLimitsResponse,
            arrayOf(
                "minSat",
                "maxSat",
            ),
        )
    ) {
        return null
    }
    val minSat = onchainPaymentLimitsResponse.getDouble("minSat").toULong()
    val maxSat = onchainPaymentLimitsResponse.getDouble("maxSat").toULong()
    return OnchainPaymentLimitsResponse(
        minSat,
        maxSat,
    )
}

fun readableMapOf(onchainPaymentLimitsResponse: OnchainPaymentLimitsResponse): ReadableMap {
    return readableMapOf(
        "minSat" to onchainPaymentLimitsResponse.minSat,
        "maxSat" to onchainPaymentLimitsResponse.maxSat,
    )
}

fun asOnchainPaymentLimitsResponseList(arr: ReadableArray): List<OnchainPaymentLimitsResponse> {
    val list = ArrayList<OnchainPaymentLimitsResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asOnchainPaymentLimitsResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asOpenChannelFeeRequest(openChannelFeeRequest: ReadableMap): OpenChannelFeeRequest? {
    if (!validateMandatoryFields(
            openChannelFeeRequest,
            arrayOf(),
        )
    ) {
        return null
    }
    val amountMsat =
        if (hasNonNullKey(
                openChannelFeeRequest,
                "amountMsat",
            )
        ) {
            openChannelFeeRequest.getDouble("amountMsat").toULong()
        } else {
            null
        }
    val expiry = if (hasNonNullKey(openChannelFeeRequest, "expiry")) openChannelFeeRequest.getInt("expiry").toUInt() else null
    return OpenChannelFeeRequest(
        amountMsat,
        expiry,
    )
}

fun readableMapOf(openChannelFeeRequest: OpenChannelFeeRequest): ReadableMap {
    return readableMapOf(
        "amountMsat" to openChannelFeeRequest.amountMsat,
        "expiry" to openChannelFeeRequest.expiry,
    )
}

fun asOpenChannelFeeRequestList(arr: ReadableArray): List<OpenChannelFeeRequest> {
    val list = ArrayList<OpenChannelFeeRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asOpenChannelFeeRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asOpenChannelFeeResponse(openChannelFeeResponse: ReadableMap): OpenChannelFeeResponse? {
    if (!validateMandatoryFields(
            openChannelFeeResponse,
            arrayOf(
                "feeParams",
            ),
        )
    ) {
        return null
    }
    val feeMsat = if (hasNonNullKey(openChannelFeeResponse, "feeMsat")) openChannelFeeResponse.getDouble("feeMsat").toULong() else null
    val feeParams = openChannelFeeResponse.getMap("feeParams")?.let { asOpeningFeeParams(it) }!!
    return OpenChannelFeeResponse(
        feeMsat,
        feeParams,
    )
}

fun readableMapOf(openChannelFeeResponse: OpenChannelFeeResponse): ReadableMap {
    return readableMapOf(
        "feeMsat" to openChannelFeeResponse.feeMsat,
        "feeParams" to readableMapOf(openChannelFeeResponse.feeParams),
    )
}

fun asOpenChannelFeeResponseList(arr: ReadableArray): List<OpenChannelFeeResponse> {
    val list = ArrayList<OpenChannelFeeResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asOpenChannelFeeResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asOpeningFeeParams(openingFeeParams: ReadableMap): OpeningFeeParams? {
    if (!validateMandatoryFields(
            openingFeeParams,
            arrayOf(
                "minMsat",
                "proportional",
                "validUntil",
                "maxIdleTime",
                "maxClientToSelfDelay",
                "promise",
            ),
        )
    ) {
        return null
    }
    val minMsat = openingFeeParams.getDouble("minMsat").toULong()
    val proportional = openingFeeParams.getInt("proportional").toUInt()
    val validUntil = openingFeeParams.getString("validUntil")!!
    val maxIdleTime = openingFeeParams.getInt("maxIdleTime").toUInt()
    val maxClientToSelfDelay = openingFeeParams.getInt("maxClientToSelfDelay").toUInt()
    val promise = openingFeeParams.getString("promise")!!
    return OpeningFeeParams(
        minMsat,
        proportional,
        validUntil,
        maxIdleTime,
        maxClientToSelfDelay,
        promise,
    )
}

fun readableMapOf(openingFeeParams: OpeningFeeParams): ReadableMap {
    return readableMapOf(
        "minMsat" to openingFeeParams.minMsat,
        "proportional" to openingFeeParams.proportional,
        "validUntil" to openingFeeParams.validUntil,
        "maxIdleTime" to openingFeeParams.maxIdleTime,
        "maxClientToSelfDelay" to openingFeeParams.maxClientToSelfDelay,
        "promise" to openingFeeParams.promise,
    )
}

fun asOpeningFeeParamsList(arr: ReadableArray): List<OpeningFeeParams> {
    val list = ArrayList<OpeningFeeParams>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asOpeningFeeParams(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asOpeningFeeParamsMenu(openingFeeParamsMenu: ReadableMap): OpeningFeeParamsMenu? {
    if (!validateMandatoryFields(
            openingFeeParamsMenu,
            arrayOf(
                "values",
            ),
        )
    ) {
        return null
    }
    val values = openingFeeParamsMenu.getArray("values")?.let { asOpeningFeeParamsList(it) }!!
    return OpeningFeeParamsMenu(
        values,
    )
}

fun readableMapOf(openingFeeParamsMenu: OpeningFeeParamsMenu): ReadableMap {
    return readableMapOf(
        "values" to readableArrayOf(openingFeeParamsMenu.values),
    )
}

fun asOpeningFeeParamsMenuList(arr: ReadableArray): List<OpeningFeeParamsMenu> {
    val list = ArrayList<OpeningFeeParamsMenu>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asOpeningFeeParamsMenu(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPayOnchainRequest(payOnchainRequest: ReadableMap): PayOnchainRequest? {
    if (!validateMandatoryFields(
            payOnchainRequest,
            arrayOf(
                "recipientAddress",
                "prepareRes",
            ),
        )
    ) {
        return null
    }
    val recipientAddress = payOnchainRequest.getString("recipientAddress")!!
    val prepareRes = payOnchainRequest.getMap("prepareRes")?.let { asPrepareOnchainPaymentResponse(it) }!!
    return PayOnchainRequest(
        recipientAddress,
        prepareRes,
    )
}

fun readableMapOf(payOnchainRequest: PayOnchainRequest): ReadableMap {
    return readableMapOf(
        "recipientAddress" to payOnchainRequest.recipientAddress,
        "prepareRes" to readableMapOf(payOnchainRequest.prepareRes),
    )
}

fun asPayOnchainRequestList(arr: ReadableArray): List<PayOnchainRequest> {
    val list = ArrayList<PayOnchainRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPayOnchainRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPayOnchainResponse(payOnchainResponse: ReadableMap): PayOnchainResponse? {
    if (!validateMandatoryFields(
            payOnchainResponse,
            arrayOf(
                "reverseSwapInfo",
            ),
        )
    ) {
        return null
    }
    val reverseSwapInfo = payOnchainResponse.getMap("reverseSwapInfo")?.let { asReverseSwapInfo(it) }!!
    return PayOnchainResponse(
        reverseSwapInfo,
    )
}

fun readableMapOf(payOnchainResponse: PayOnchainResponse): ReadableMap {
    return readableMapOf(
        "reverseSwapInfo" to readableMapOf(payOnchainResponse.reverseSwapInfo),
    )
}

fun asPayOnchainResponseList(arr: ReadableArray): List<PayOnchainResponse> {
    val list = ArrayList<PayOnchainResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPayOnchainResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPayment(payment: ReadableMap): Payment? {
    if (!validateMandatoryFields(
            payment,
            arrayOf(
                "id",
                "paymentType",
                "paymentTime",
                "amountMsat",
                "feeMsat",
                "status",
                "details",
            ),
        )
    ) {
        return null
    }
    val id = payment.getString("id")!!
    val paymentType = payment.getString("paymentType")?.let { asPaymentType(it) }!!
    val paymentTime = payment.getDouble("paymentTime").toLong()
    val amountMsat = payment.getDouble("amountMsat").toULong()
    val feeMsat = payment.getDouble("feeMsat").toULong()
    val status = payment.getString("status")?.let { asPaymentStatus(it) }!!
    val error = if (hasNonNullKey(payment, "error")) payment.getString("error") else null
    val description = if (hasNonNullKey(payment, "description")) payment.getString("description") else null
    val details = payment.getMap("details")?.let { asPaymentDetails(it) }!!
    val metadata = if (hasNonNullKey(payment, "metadata")) payment.getString("metadata") else null
    return Payment(
        id,
        paymentType,
        paymentTime,
        amountMsat,
        feeMsat,
        status,
        error,
        description,
        details,
        metadata,
    )
}

fun readableMapOf(payment: Payment): ReadableMap {
    return readableMapOf(
        "id" to payment.id,
        "paymentType" to payment.paymentType.name.lowercase(),
        "paymentTime" to payment.paymentTime,
        "amountMsat" to payment.amountMsat,
        "feeMsat" to payment.feeMsat,
        "status" to payment.status.name.lowercase(),
        "error" to payment.error,
        "description" to payment.description,
        "details" to readableMapOf(payment.details),
        "metadata" to payment.metadata,
    )
}

fun asPaymentList(arr: ReadableArray): List<Payment> {
    val list = ArrayList<Payment>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPayment(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPaymentFailedData(paymentFailedData: ReadableMap): PaymentFailedData? {
    if (!validateMandatoryFields(
            paymentFailedData,
            arrayOf(
                "error",
                "nodeId",
            ),
        )
    ) {
        return null
    }
    val error = paymentFailedData.getString("error")!!
    val nodeId = paymentFailedData.getString("nodeId")!!
    val invoice = if (hasNonNullKey(paymentFailedData, "invoice")) paymentFailedData.getMap("invoice")?.let { asLnInvoice(it) } else null
    return PaymentFailedData(
        error,
        nodeId,
        invoice,
    )
}

fun readableMapOf(paymentFailedData: PaymentFailedData): ReadableMap {
    return readableMapOf(
        "error" to paymentFailedData.error,
        "nodeId" to paymentFailedData.nodeId,
        "invoice" to paymentFailedData.invoice?.let { readableMapOf(it) },
    )
}

fun asPaymentFailedDataList(arr: ReadableArray): List<PaymentFailedData> {
    val list = ArrayList<PaymentFailedData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPaymentFailedData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPrepareOnchainPaymentRequest(prepareOnchainPaymentRequest: ReadableMap): PrepareOnchainPaymentRequest? {
    if (!validateMandatoryFields(
            prepareOnchainPaymentRequest,
            arrayOf(
                "amountSat",
                "amountType",
                "claimTxFeerate",
            ),
        )
    ) {
        return null
    }
    val amountSat = prepareOnchainPaymentRequest.getDouble("amountSat").toULong()
    val amountType = prepareOnchainPaymentRequest.getString("amountType")?.let { asSwapAmountType(it) }!!
    val claimTxFeerate = prepareOnchainPaymentRequest.getInt("claimTxFeerate").toUInt()
    return PrepareOnchainPaymentRequest(
        amountSat,
        amountType,
        claimTxFeerate,
    )
}

fun readableMapOf(prepareOnchainPaymentRequest: PrepareOnchainPaymentRequest): ReadableMap {
    return readableMapOf(
        "amountSat" to prepareOnchainPaymentRequest.amountSat,
        "amountType" to prepareOnchainPaymentRequest.amountType.name.lowercase(),
        "claimTxFeerate" to prepareOnchainPaymentRequest.claimTxFeerate,
    )
}

fun asPrepareOnchainPaymentRequestList(arr: ReadableArray): List<PrepareOnchainPaymentRequest> {
    val list = ArrayList<PrepareOnchainPaymentRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPrepareOnchainPaymentRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPrepareOnchainPaymentResponse(prepareOnchainPaymentResponse: ReadableMap): PrepareOnchainPaymentResponse? {
    if (!validateMandatoryFields(
            prepareOnchainPaymentResponse,
            arrayOf(
                "feesHash",
                "feesPercentage",
                "feesLockup",
                "feesClaim",
                "senderAmountSat",
                "recipientAmountSat",
                "totalFees",
            ),
        )
    ) {
        return null
    }
    val feesHash = prepareOnchainPaymentResponse.getString("feesHash")!!
    val feesPercentage = prepareOnchainPaymentResponse.getDouble("feesPercentage")
    val feesLockup = prepareOnchainPaymentResponse.getDouble("feesLockup").toULong()
    val feesClaim = prepareOnchainPaymentResponse.getDouble("feesClaim").toULong()
    val senderAmountSat = prepareOnchainPaymentResponse.getDouble("senderAmountSat").toULong()
    val recipientAmountSat = prepareOnchainPaymentResponse.getDouble("recipientAmountSat").toULong()
    val totalFees = prepareOnchainPaymentResponse.getDouble("totalFees").toULong()
    return PrepareOnchainPaymentResponse(
        feesHash,
        feesPercentage,
        feesLockup,
        feesClaim,
        senderAmountSat,
        recipientAmountSat,
        totalFees,
    )
}

fun readableMapOf(prepareOnchainPaymentResponse: PrepareOnchainPaymentResponse): ReadableMap {
    return readableMapOf(
        "feesHash" to prepareOnchainPaymentResponse.feesHash,
        "feesPercentage" to prepareOnchainPaymentResponse.feesPercentage,
        "feesLockup" to prepareOnchainPaymentResponse.feesLockup,
        "feesClaim" to prepareOnchainPaymentResponse.feesClaim,
        "senderAmountSat" to prepareOnchainPaymentResponse.senderAmountSat,
        "recipientAmountSat" to prepareOnchainPaymentResponse.recipientAmountSat,
        "totalFees" to prepareOnchainPaymentResponse.totalFees,
    )
}

fun asPrepareOnchainPaymentResponseList(arr: ReadableArray): List<PrepareOnchainPaymentResponse> {
    val list = ArrayList<PrepareOnchainPaymentResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPrepareOnchainPaymentResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPrepareRedeemOnchainFundsRequest(prepareRedeemOnchainFundsRequest: ReadableMap): PrepareRedeemOnchainFundsRequest? {
    if (!validateMandatoryFields(
            prepareRedeemOnchainFundsRequest,
            arrayOf(
                "toAddress",
                "satPerVbyte",
            ),
        )
    ) {
        return null
    }
    val toAddress = prepareRedeemOnchainFundsRequest.getString("toAddress")!!
    val satPerVbyte = prepareRedeemOnchainFundsRequest.getInt("satPerVbyte").toUInt()
    return PrepareRedeemOnchainFundsRequest(
        toAddress,
        satPerVbyte,
    )
}

fun readableMapOf(prepareRedeemOnchainFundsRequest: PrepareRedeemOnchainFundsRequest): ReadableMap {
    return readableMapOf(
        "toAddress" to prepareRedeemOnchainFundsRequest.toAddress,
        "satPerVbyte" to prepareRedeemOnchainFundsRequest.satPerVbyte,
    )
}

fun asPrepareRedeemOnchainFundsRequestList(arr: ReadableArray): List<PrepareRedeemOnchainFundsRequest> {
    val list = ArrayList<PrepareRedeemOnchainFundsRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPrepareRedeemOnchainFundsRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPrepareRedeemOnchainFundsResponse(prepareRedeemOnchainFundsResponse: ReadableMap): PrepareRedeemOnchainFundsResponse? {
    if (!validateMandatoryFields(
            prepareRedeemOnchainFundsResponse,
            arrayOf(
                "txWeight",
                "txFeeSat",
            ),
        )
    ) {
        return null
    }
    val txWeight = prepareRedeemOnchainFundsResponse.getDouble("txWeight").toULong()
    val txFeeSat = prepareRedeemOnchainFundsResponse.getDouble("txFeeSat").toULong()
    return PrepareRedeemOnchainFundsResponse(
        txWeight,
        txFeeSat,
    )
}

fun readableMapOf(prepareRedeemOnchainFundsResponse: PrepareRedeemOnchainFundsResponse): ReadableMap {
    return readableMapOf(
        "txWeight" to prepareRedeemOnchainFundsResponse.txWeight,
        "txFeeSat" to prepareRedeemOnchainFundsResponse.txFeeSat,
    )
}

fun asPrepareRedeemOnchainFundsResponseList(arr: ReadableArray): List<PrepareRedeemOnchainFundsResponse> {
    val list = ArrayList<PrepareRedeemOnchainFundsResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPrepareRedeemOnchainFundsResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPrepareRefundRequest(prepareRefundRequest: ReadableMap): PrepareRefundRequest? {
    if (!validateMandatoryFields(
            prepareRefundRequest,
            arrayOf(
                "swapAddress",
                "toAddress",
                "satPerVbyte",
            ),
        )
    ) {
        return null
    }
    val swapAddress = prepareRefundRequest.getString("swapAddress")!!
    val toAddress = prepareRefundRequest.getString("toAddress")!!
    val satPerVbyte = prepareRefundRequest.getInt("satPerVbyte").toUInt()
    return PrepareRefundRequest(
        swapAddress,
        toAddress,
        satPerVbyte,
    )
}

fun readableMapOf(prepareRefundRequest: PrepareRefundRequest): ReadableMap {
    return readableMapOf(
        "swapAddress" to prepareRefundRequest.swapAddress,
        "toAddress" to prepareRefundRequest.toAddress,
        "satPerVbyte" to prepareRefundRequest.satPerVbyte,
    )
}

fun asPrepareRefundRequestList(arr: ReadableArray): List<PrepareRefundRequest> {
    val list = ArrayList<PrepareRefundRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPrepareRefundRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPrepareRefundResponse(prepareRefundResponse: ReadableMap): PrepareRefundResponse? {
    if (!validateMandatoryFields(
            prepareRefundResponse,
            arrayOf(
                "refundTxWeight",
                "refundTxFeeSat",
            ),
        )
    ) {
        return null
    }
    val refundTxWeight = prepareRefundResponse.getInt("refundTxWeight").toUInt()
    val refundTxFeeSat = prepareRefundResponse.getDouble("refundTxFeeSat").toULong()
    return PrepareRefundResponse(
        refundTxWeight,
        refundTxFeeSat,
    )
}

fun readableMapOf(prepareRefundResponse: PrepareRefundResponse): ReadableMap {
    return readableMapOf(
        "refundTxWeight" to prepareRefundResponse.refundTxWeight,
        "refundTxFeeSat" to prepareRefundResponse.refundTxFeeSat,
    )
}

fun asPrepareRefundResponseList(arr: ReadableArray): List<PrepareRefundResponse> {
    val list = ArrayList<PrepareRefundResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPrepareRefundResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asRate(rate: ReadableMap): Rate? {
    if (!validateMandatoryFields(
            rate,
            arrayOf(
                "coin",
                "value",
            ),
        )
    ) {
        return null
    }
    val coin = rate.getString("coin")!!
    val value = rate.getDouble("value")
    return Rate(
        coin,
        value,
    )
}

fun readableMapOf(rate: Rate): ReadableMap {
    return readableMapOf(
        "coin" to rate.coin,
        "value" to rate.value,
    )
}

fun asRateList(arr: ReadableArray): List<Rate> {
    val list = ArrayList<Rate>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asRate(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asReceiveOnchainRequest(receiveOnchainRequest: ReadableMap): ReceiveOnchainRequest? {
    if (!validateMandatoryFields(
            receiveOnchainRequest,
            arrayOf(),
        )
    ) {
        return null
    }
    val openingFeeParams =
        if (hasNonNullKey(
                receiveOnchainRequest,
                "openingFeeParams",
            )
        ) {
            receiveOnchainRequest.getMap("openingFeeParams")?.let {
                asOpeningFeeParams(it)
            }
        } else {
            null
        }
    return ReceiveOnchainRequest(
        openingFeeParams,
    )
}

fun readableMapOf(receiveOnchainRequest: ReceiveOnchainRequest): ReadableMap {
    return readableMapOf(
        "openingFeeParams" to receiveOnchainRequest.openingFeeParams?.let { readableMapOf(it) },
    )
}

fun asReceiveOnchainRequestList(arr: ReadableArray): List<ReceiveOnchainRequest> {
    val list = ArrayList<ReceiveOnchainRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asReceiveOnchainRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asReceivePaymentRequest(receivePaymentRequest: ReadableMap): ReceivePaymentRequest? {
    if (!validateMandatoryFields(
            receivePaymentRequest,
            arrayOf(
                "amountMsat",
                "description",
            ),
        )
    ) {
        return null
    }
    val amountMsat = receivePaymentRequest.getDouble("amountMsat").toULong()
    val description = receivePaymentRequest.getString("description")!!
    val preimage =
        if (hasNonNullKey(receivePaymentRequest, "preimage")) {
            receivePaymentRequest.getArray("preimage")?.let {
                asUByteList(it)
            }
        } else {
            null
        }
    val openingFeeParams =
        if (hasNonNullKey(
                receivePaymentRequest,
                "openingFeeParams",
            )
        ) {
            receivePaymentRequest.getMap("openingFeeParams")?.let {
                asOpeningFeeParams(it)
            }
        } else {
            null
        }
    val useDescriptionHash =
        if (hasNonNullKey(
                receivePaymentRequest,
                "useDescriptionHash",
            )
        ) {
            receivePaymentRequest.getBoolean("useDescriptionHash")
        } else {
            null
        }
    val expiry = if (hasNonNullKey(receivePaymentRequest, "expiry")) receivePaymentRequest.getInt("expiry").toUInt() else null
    val cltv = if (hasNonNullKey(receivePaymentRequest, "cltv")) receivePaymentRequest.getInt("cltv").toUInt() else null
    return ReceivePaymentRequest(
        amountMsat,
        description,
        preimage,
        openingFeeParams,
        useDescriptionHash,
        expiry,
        cltv,
    )
}

fun readableMapOf(receivePaymentRequest: ReceivePaymentRequest): ReadableMap {
    return readableMapOf(
        "amountMsat" to receivePaymentRequest.amountMsat,
        "description" to receivePaymentRequest.description,
        "preimage" to receivePaymentRequest.preimage?.let { readableArrayOf(it) },
        "openingFeeParams" to receivePaymentRequest.openingFeeParams?.let { readableMapOf(it) },
        "useDescriptionHash" to receivePaymentRequest.useDescriptionHash,
        "expiry" to receivePaymentRequest.expiry,
        "cltv" to receivePaymentRequest.cltv,
    )
}

fun asReceivePaymentRequestList(arr: ReadableArray): List<ReceivePaymentRequest> {
    val list = ArrayList<ReceivePaymentRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asReceivePaymentRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asReceivePaymentResponse(receivePaymentResponse: ReadableMap): ReceivePaymentResponse? {
    if (!validateMandatoryFields(
            receivePaymentResponse,
            arrayOf(
                "lnInvoice",
            ),
        )
    ) {
        return null
    }
    val lnInvoice = receivePaymentResponse.getMap("lnInvoice")?.let { asLnInvoice(it) }!!
    val openingFeeParams =
        if (hasNonNullKey(
                receivePaymentResponse,
                "openingFeeParams",
            )
        ) {
            receivePaymentResponse.getMap("openingFeeParams")?.let {
                asOpeningFeeParams(it)
            }
        } else {
            null
        }
    val openingFeeMsat =
        if (hasNonNullKey(
                receivePaymentResponse,
                "openingFeeMsat",
            )
        ) {
            receivePaymentResponse.getDouble("openingFeeMsat").toULong()
        } else {
            null
        }
    return ReceivePaymentResponse(
        lnInvoice,
        openingFeeParams,
        openingFeeMsat,
    )
}

fun readableMapOf(receivePaymentResponse: ReceivePaymentResponse): ReadableMap {
    return readableMapOf(
        "lnInvoice" to readableMapOf(receivePaymentResponse.lnInvoice),
        "openingFeeParams" to receivePaymentResponse.openingFeeParams?.let { readableMapOf(it) },
        "openingFeeMsat" to receivePaymentResponse.openingFeeMsat,
    )
}

fun asReceivePaymentResponseList(arr: ReadableArray): List<ReceivePaymentResponse> {
    val list = ArrayList<ReceivePaymentResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asReceivePaymentResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asRecommendedFees(recommendedFees: ReadableMap): RecommendedFees? {
    if (!validateMandatoryFields(
            recommendedFees,
            arrayOf(
                "fastestFee",
                "halfHourFee",
                "hourFee",
                "economyFee",
                "minimumFee",
            ),
        )
    ) {
        return null
    }
    val fastestFee = recommendedFees.getDouble("fastestFee").toULong()
    val halfHourFee = recommendedFees.getDouble("halfHourFee").toULong()
    val hourFee = recommendedFees.getDouble("hourFee").toULong()
    val economyFee = recommendedFees.getDouble("economyFee").toULong()
    val minimumFee = recommendedFees.getDouble("minimumFee").toULong()
    return RecommendedFees(
        fastestFee,
        halfHourFee,
        hourFee,
        economyFee,
        minimumFee,
    )
}

fun readableMapOf(recommendedFees: RecommendedFees): ReadableMap {
    return readableMapOf(
        "fastestFee" to recommendedFees.fastestFee,
        "halfHourFee" to recommendedFees.halfHourFee,
        "hourFee" to recommendedFees.hourFee,
        "economyFee" to recommendedFees.economyFee,
        "minimumFee" to recommendedFees.minimumFee,
    )
}

fun asRecommendedFeesList(arr: ReadableArray): List<RecommendedFees> {
    val list = ArrayList<RecommendedFees>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asRecommendedFees(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asRedeemOnchainFundsRequest(redeemOnchainFundsRequest: ReadableMap): RedeemOnchainFundsRequest? {
    if (!validateMandatoryFields(
            redeemOnchainFundsRequest,
            arrayOf(
                "toAddress",
                "satPerVbyte",
            ),
        )
    ) {
        return null
    }
    val toAddress = redeemOnchainFundsRequest.getString("toAddress")!!
    val satPerVbyte = redeemOnchainFundsRequest.getInt("satPerVbyte").toUInt()
    return RedeemOnchainFundsRequest(
        toAddress,
        satPerVbyte,
    )
}

fun readableMapOf(redeemOnchainFundsRequest: RedeemOnchainFundsRequest): ReadableMap {
    return readableMapOf(
        "toAddress" to redeemOnchainFundsRequest.toAddress,
        "satPerVbyte" to redeemOnchainFundsRequest.satPerVbyte,
    )
}

fun asRedeemOnchainFundsRequestList(arr: ReadableArray): List<RedeemOnchainFundsRequest> {
    val list = ArrayList<RedeemOnchainFundsRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asRedeemOnchainFundsRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asRedeemOnchainFundsResponse(redeemOnchainFundsResponse: ReadableMap): RedeemOnchainFundsResponse? {
    if (!validateMandatoryFields(
            redeemOnchainFundsResponse,
            arrayOf(
                "txid",
            ),
        )
    ) {
        return null
    }
    val txid = redeemOnchainFundsResponse.getArray("txid")?.let { asUByteList(it) }!!
    return RedeemOnchainFundsResponse(
        txid,
    )
}

fun readableMapOf(redeemOnchainFundsResponse: RedeemOnchainFundsResponse): ReadableMap {
    return readableMapOf(
        "txid" to readableArrayOf(redeemOnchainFundsResponse.txid),
    )
}

fun asRedeemOnchainFundsResponseList(arr: ReadableArray): List<RedeemOnchainFundsResponse> {
    val list = ArrayList<RedeemOnchainFundsResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asRedeemOnchainFundsResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asRefundRequest(refundRequest: ReadableMap): RefundRequest? {
    if (!validateMandatoryFields(
            refundRequest,
            arrayOf(
                "swapAddress",
                "toAddress",
                "satPerVbyte",
            ),
        )
    ) {
        return null
    }
    val swapAddress = refundRequest.getString("swapAddress")!!
    val toAddress = refundRequest.getString("toAddress")!!
    val satPerVbyte = refundRequest.getInt("satPerVbyte").toUInt()
    return RefundRequest(
        swapAddress,
        toAddress,
        satPerVbyte,
    )
}

fun readableMapOf(refundRequest: RefundRequest): ReadableMap {
    return readableMapOf(
        "swapAddress" to refundRequest.swapAddress,
        "toAddress" to refundRequest.toAddress,
        "satPerVbyte" to refundRequest.satPerVbyte,
    )
}

fun asRefundRequestList(arr: ReadableArray): List<RefundRequest> {
    val list = ArrayList<RefundRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asRefundRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asRefundResponse(refundResponse: ReadableMap): RefundResponse? {
    if (!validateMandatoryFields(
            refundResponse,
            arrayOf(
                "refundTxId",
            ),
        )
    ) {
        return null
    }
    val refundTxId = refundResponse.getString("refundTxId")!!
    return RefundResponse(
        refundTxId,
    )
}

fun readableMapOf(refundResponse: RefundResponse): ReadableMap {
    return readableMapOf(
        "refundTxId" to refundResponse.refundTxId,
    )
}

fun asRefundResponseList(arr: ReadableArray): List<RefundResponse> {
    val list = ArrayList<RefundResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asRefundResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asReportPaymentFailureDetails(reportPaymentFailureDetails: ReadableMap): ReportPaymentFailureDetails? {
    if (!validateMandatoryFields(
            reportPaymentFailureDetails,
            arrayOf(
                "paymentHash",
            ),
        )
    ) {
        return null
    }
    val paymentHash = reportPaymentFailureDetails.getString("paymentHash")!!
    val comment = if (hasNonNullKey(reportPaymentFailureDetails, "comment")) reportPaymentFailureDetails.getString("comment") else null
    return ReportPaymentFailureDetails(
        paymentHash,
        comment,
    )
}

fun readableMapOf(reportPaymentFailureDetails: ReportPaymentFailureDetails): ReadableMap {
    return readableMapOf(
        "paymentHash" to reportPaymentFailureDetails.paymentHash,
        "comment" to reportPaymentFailureDetails.comment,
    )
}

fun asReportPaymentFailureDetailsList(arr: ReadableArray): List<ReportPaymentFailureDetails> {
    val list = ArrayList<ReportPaymentFailureDetails>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asReportPaymentFailureDetails(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asReverseSwapFeesRequest(reverseSwapFeesRequest: ReadableMap): ReverseSwapFeesRequest? {
    if (!validateMandatoryFields(
            reverseSwapFeesRequest,
            arrayOf(),
        )
    ) {
        return null
    }
    val sendAmountSat =
        if (hasNonNullKey(
                reverseSwapFeesRequest,
                "sendAmountSat",
            )
        ) {
            reverseSwapFeesRequest.getDouble("sendAmountSat").toULong()
        } else {
            null
        }
    val claimTxFeerate =
        if (hasNonNullKey(
                reverseSwapFeesRequest,
                "claimTxFeerate",
            )
        ) {
            reverseSwapFeesRequest.getInt("claimTxFeerate").toUInt()
        } else {
            null
        }
    return ReverseSwapFeesRequest(
        sendAmountSat,
        claimTxFeerate,
    )
}

fun readableMapOf(reverseSwapFeesRequest: ReverseSwapFeesRequest): ReadableMap {
    return readableMapOf(
        "sendAmountSat" to reverseSwapFeesRequest.sendAmountSat,
        "claimTxFeerate" to reverseSwapFeesRequest.claimTxFeerate,
    )
}

fun asReverseSwapFeesRequestList(arr: ReadableArray): List<ReverseSwapFeesRequest> {
    val list = ArrayList<ReverseSwapFeesRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asReverseSwapFeesRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asReverseSwapInfo(reverseSwapInfo: ReadableMap): ReverseSwapInfo? {
    if (!validateMandatoryFields(
            reverseSwapInfo,
            arrayOf(
                "id",
                "claimPubkey",
                "onchainAmountSat",
                "status",
            ),
        )
    ) {
        return null
    }
    val id = reverseSwapInfo.getString("id")!!
    val claimPubkey = reverseSwapInfo.getString("claimPubkey")!!
    val lockupTxid = if (hasNonNullKey(reverseSwapInfo, "lockupTxid")) reverseSwapInfo.getString("lockupTxid") else null
    val claimTxid = if (hasNonNullKey(reverseSwapInfo, "claimTxid")) reverseSwapInfo.getString("claimTxid") else null
    val onchainAmountSat = reverseSwapInfo.getDouble("onchainAmountSat").toULong()
    val status = reverseSwapInfo.getString("status")?.let { asReverseSwapStatus(it) }!!
    return ReverseSwapInfo(
        id,
        claimPubkey,
        lockupTxid,
        claimTxid,
        onchainAmountSat,
        status,
    )
}

fun readableMapOf(reverseSwapInfo: ReverseSwapInfo): ReadableMap {
    return readableMapOf(
        "id" to reverseSwapInfo.id,
        "claimPubkey" to reverseSwapInfo.claimPubkey,
        "lockupTxid" to reverseSwapInfo.lockupTxid,
        "claimTxid" to reverseSwapInfo.claimTxid,
        "onchainAmountSat" to reverseSwapInfo.onchainAmountSat,
        "status" to reverseSwapInfo.status.name.lowercase(),
    )
}

fun asReverseSwapInfoList(arr: ReadableArray): List<ReverseSwapInfo> {
    val list = ArrayList<ReverseSwapInfo>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asReverseSwapInfo(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asReverseSwapPairInfo(reverseSwapPairInfo: ReadableMap): ReverseSwapPairInfo? {
    if (!validateMandatoryFields(
            reverseSwapPairInfo,
            arrayOf(
                "min",
                "max",
                "feesHash",
                "feesPercentage",
                "feesLockup",
                "feesClaim",
            ),
        )
    ) {
        return null
    }
    val min = reverseSwapPairInfo.getDouble("min").toULong()
    val max = reverseSwapPairInfo.getDouble("max").toULong()
    val feesHash = reverseSwapPairInfo.getString("feesHash")!!
    val feesPercentage = reverseSwapPairInfo.getDouble("feesPercentage")
    val feesLockup = reverseSwapPairInfo.getDouble("feesLockup").toULong()
    val feesClaim = reverseSwapPairInfo.getDouble("feesClaim").toULong()
    val totalFees = if (hasNonNullKey(reverseSwapPairInfo, "totalFees")) reverseSwapPairInfo.getDouble("totalFees").toULong() else null
    return ReverseSwapPairInfo(
        min,
        max,
        feesHash,
        feesPercentage,
        feesLockup,
        feesClaim,
        totalFees,
    )
}

fun readableMapOf(reverseSwapPairInfo: ReverseSwapPairInfo): ReadableMap {
    return readableMapOf(
        "min" to reverseSwapPairInfo.min,
        "max" to reverseSwapPairInfo.max,
        "feesHash" to reverseSwapPairInfo.feesHash,
        "feesPercentage" to reverseSwapPairInfo.feesPercentage,
        "feesLockup" to reverseSwapPairInfo.feesLockup,
        "feesClaim" to reverseSwapPairInfo.feesClaim,
        "totalFees" to reverseSwapPairInfo.totalFees,
    )
}

fun asReverseSwapPairInfoList(arr: ReadableArray): List<ReverseSwapPairInfo> {
    val list = ArrayList<ReverseSwapPairInfo>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asReverseSwapPairInfo(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asRouteHint(routeHint: ReadableMap): RouteHint? {
    if (!validateMandatoryFields(
            routeHint,
            arrayOf(
                "hops",
            ),
        )
    ) {
        return null
    }
    val hops = routeHint.getArray("hops")?.let { asRouteHintHopList(it) }!!
    return RouteHint(
        hops,
    )
}

fun readableMapOf(routeHint: RouteHint): ReadableMap {
    return readableMapOf(
        "hops" to readableArrayOf(routeHint.hops),
    )
}

fun asRouteHintList(arr: ReadableArray): List<RouteHint> {
    val list = ArrayList<RouteHint>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asRouteHint(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asRouteHintHop(routeHintHop: ReadableMap): RouteHintHop? {
    if (!validateMandatoryFields(
            routeHintHop,
            arrayOf(
                "srcNodeId",
                "shortChannelId",
                "feesBaseMsat",
                "feesProportionalMillionths",
                "cltvExpiryDelta",
            ),
        )
    ) {
        return null
    }
    val srcNodeId = routeHintHop.getString("srcNodeId")!!
    val shortChannelId = routeHintHop.getDouble("shortChannelId").toULong()
    val feesBaseMsat = routeHintHop.getInt("feesBaseMsat").toUInt()
    val feesProportionalMillionths = routeHintHop.getInt("feesProportionalMillionths").toUInt()
    val cltvExpiryDelta = routeHintHop.getDouble("cltvExpiryDelta").toULong()
    val htlcMinimumMsat = if (hasNonNullKey(routeHintHop, "htlcMinimumMsat")) routeHintHop.getDouble("htlcMinimumMsat").toULong() else null
    val htlcMaximumMsat = if (hasNonNullKey(routeHintHop, "htlcMaximumMsat")) routeHintHop.getDouble("htlcMaximumMsat").toULong() else null
    return RouteHintHop(
        srcNodeId,
        shortChannelId,
        feesBaseMsat,
        feesProportionalMillionths,
        cltvExpiryDelta,
        htlcMinimumMsat,
        htlcMaximumMsat,
    )
}

fun readableMapOf(routeHintHop: RouteHintHop): ReadableMap {
    return readableMapOf(
        "srcNodeId" to routeHintHop.srcNodeId,
        "shortChannelId" to routeHintHop.shortChannelId,
        "feesBaseMsat" to routeHintHop.feesBaseMsat,
        "feesProportionalMillionths" to routeHintHop.feesProportionalMillionths,
        "cltvExpiryDelta" to routeHintHop.cltvExpiryDelta,
        "htlcMinimumMsat" to routeHintHop.htlcMinimumMsat,
        "htlcMaximumMsat" to routeHintHop.htlcMaximumMsat,
    )
}

fun asRouteHintHopList(arr: ReadableArray): List<RouteHintHop> {
    val list = ArrayList<RouteHintHop>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asRouteHintHop(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSendOnchainRequest(sendOnchainRequest: ReadableMap): SendOnchainRequest? {
    if (!validateMandatoryFields(
            sendOnchainRequest,
            arrayOf(
                "amountSat",
                "onchainRecipientAddress",
                "pairHash",
                "satPerVbyte",
            ),
        )
    ) {
        return null
    }
    val amountSat = sendOnchainRequest.getDouble("amountSat").toULong()
    val onchainRecipientAddress = sendOnchainRequest.getString("onchainRecipientAddress")!!
    val pairHash = sendOnchainRequest.getString("pairHash")!!
    val satPerVbyte = sendOnchainRequest.getInt("satPerVbyte").toUInt()
    return SendOnchainRequest(
        amountSat,
        onchainRecipientAddress,
        pairHash,
        satPerVbyte,
    )
}

fun readableMapOf(sendOnchainRequest: SendOnchainRequest): ReadableMap {
    return readableMapOf(
        "amountSat" to sendOnchainRequest.amountSat,
        "onchainRecipientAddress" to sendOnchainRequest.onchainRecipientAddress,
        "pairHash" to sendOnchainRequest.pairHash,
        "satPerVbyte" to sendOnchainRequest.satPerVbyte,
    )
}

fun asSendOnchainRequestList(arr: ReadableArray): List<SendOnchainRequest> {
    val list = ArrayList<SendOnchainRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asSendOnchainRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSendOnchainResponse(sendOnchainResponse: ReadableMap): SendOnchainResponse? {
    if (!validateMandatoryFields(
            sendOnchainResponse,
            arrayOf(
                "reverseSwapInfo",
            ),
        )
    ) {
        return null
    }
    val reverseSwapInfo = sendOnchainResponse.getMap("reverseSwapInfo")?.let { asReverseSwapInfo(it) }!!
    return SendOnchainResponse(
        reverseSwapInfo,
    )
}

fun readableMapOf(sendOnchainResponse: SendOnchainResponse): ReadableMap {
    return readableMapOf(
        "reverseSwapInfo" to readableMapOf(sendOnchainResponse.reverseSwapInfo),
    )
}

fun asSendOnchainResponseList(arr: ReadableArray): List<SendOnchainResponse> {
    val list = ArrayList<SendOnchainResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asSendOnchainResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSendPaymentRequest(sendPaymentRequest: ReadableMap): SendPaymentRequest? {
    if (!validateMandatoryFields(
            sendPaymentRequest,
            arrayOf(
                "bolt11",
            ),
        )
    ) {
        return null
    }
    val bolt11 = sendPaymentRequest.getString("bolt11")!!
    val amountMsat = if (hasNonNullKey(sendPaymentRequest, "amountMsat")) sendPaymentRequest.getDouble("amountMsat").toULong() else null
    return SendPaymentRequest(
        bolt11,
        amountMsat,
    )
}

fun readableMapOf(sendPaymentRequest: SendPaymentRequest): ReadableMap {
    return readableMapOf(
        "bolt11" to sendPaymentRequest.bolt11,
        "amountMsat" to sendPaymentRequest.amountMsat,
    )
}

fun asSendPaymentRequestList(arr: ReadableArray): List<SendPaymentRequest> {
    val list = ArrayList<SendPaymentRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asSendPaymentRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSendPaymentResponse(sendPaymentResponse: ReadableMap): SendPaymentResponse? {
    if (!validateMandatoryFields(
            sendPaymentResponse,
            arrayOf(
                "payment",
            ),
        )
    ) {
        return null
    }
    val payment = sendPaymentResponse.getMap("payment")?.let { asPayment(it) }!!
    return SendPaymentResponse(
        payment,
    )
}

fun readableMapOf(sendPaymentResponse: SendPaymentResponse): ReadableMap {
    return readableMapOf(
        "payment" to readableMapOf(sendPaymentResponse.payment),
    )
}

fun asSendPaymentResponseList(arr: ReadableArray): List<SendPaymentResponse> {
    val list = ArrayList<SendPaymentResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asSendPaymentResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSendSpontaneousPaymentRequest(sendSpontaneousPaymentRequest: ReadableMap): SendSpontaneousPaymentRequest? {
    if (!validateMandatoryFields(
            sendSpontaneousPaymentRequest,
            arrayOf(
                "nodeId",
                "amountMsat",
            ),
        )
    ) {
        return null
    }
    val nodeId = sendSpontaneousPaymentRequest.getString("nodeId")!!
    val amountMsat = sendSpontaneousPaymentRequest.getDouble("amountMsat").toULong()
    val extraTlvs =
        if (hasNonNullKey(
                sendSpontaneousPaymentRequest,
                "extraTlvs",
            )
        ) {
            sendSpontaneousPaymentRequest.getArray("extraTlvs")?.let {
                asTlvEntryList(it)
            }
        } else {
            null
        }
    return SendSpontaneousPaymentRequest(
        nodeId,
        amountMsat,
        extraTlvs,
    )
}

fun readableMapOf(sendSpontaneousPaymentRequest: SendSpontaneousPaymentRequest): ReadableMap {
    return readableMapOf(
        "nodeId" to sendSpontaneousPaymentRequest.nodeId,
        "amountMsat" to sendSpontaneousPaymentRequest.amountMsat,
        "extraTlvs" to sendSpontaneousPaymentRequest.extraTlvs?.let { readableArrayOf(it) },
    )
}

fun asSendSpontaneousPaymentRequestList(arr: ReadableArray): List<SendSpontaneousPaymentRequest> {
    val list = ArrayList<SendSpontaneousPaymentRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asSendSpontaneousPaymentRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asServiceHealthCheckResponse(serviceHealthCheckResponse: ReadableMap): ServiceHealthCheckResponse? {
    if (!validateMandatoryFields(
            serviceHealthCheckResponse,
            arrayOf(
                "status",
            ),
        )
    ) {
        return null
    }
    val status = serviceHealthCheckResponse.getString("status")?.let { asHealthCheckStatus(it) }!!
    return ServiceHealthCheckResponse(
        status,
    )
}

fun readableMapOf(serviceHealthCheckResponse: ServiceHealthCheckResponse): ReadableMap {
    return readableMapOf(
        "status" to serviceHealthCheckResponse.status.name.lowercase(),
    )
}

fun asServiceHealthCheckResponseList(arr: ReadableArray): List<ServiceHealthCheckResponse> {
    val list = ArrayList<ServiceHealthCheckResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asServiceHealthCheckResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSignMessageRequest(signMessageRequest: ReadableMap): SignMessageRequest? {
    if (!validateMandatoryFields(
            signMessageRequest,
            arrayOf(
                "message",
            ),
        )
    ) {
        return null
    }
    val message = signMessageRequest.getString("message")!!
    return SignMessageRequest(
        message,
    )
}

fun readableMapOf(signMessageRequest: SignMessageRequest): ReadableMap {
    return readableMapOf(
        "message" to signMessageRequest.message,
    )
}

fun asSignMessageRequestList(arr: ReadableArray): List<SignMessageRequest> {
    val list = ArrayList<SignMessageRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asSignMessageRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSignMessageResponse(signMessageResponse: ReadableMap): SignMessageResponse? {
    if (!validateMandatoryFields(
            signMessageResponse,
            arrayOf(
                "signature",
            ),
        )
    ) {
        return null
    }
    val signature = signMessageResponse.getString("signature")!!
    return SignMessageResponse(
        signature,
    )
}

fun readableMapOf(signMessageResponse: SignMessageResponse): ReadableMap {
    return readableMapOf(
        "signature" to signMessageResponse.signature,
    )
}

fun asSignMessageResponseList(arr: ReadableArray): List<SignMessageResponse> {
    val list = ArrayList<SignMessageResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asSignMessageResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asStaticBackupRequest(staticBackupRequest: ReadableMap): StaticBackupRequest? {
    if (!validateMandatoryFields(
            staticBackupRequest,
            arrayOf(
                "workingDir",
            ),
        )
    ) {
        return null
    }
    val workingDir = staticBackupRequest.getString("workingDir")!!
    return StaticBackupRequest(
        workingDir,
    )
}

fun readableMapOf(staticBackupRequest: StaticBackupRequest): ReadableMap {
    return readableMapOf(
        "workingDir" to staticBackupRequest.workingDir,
    )
}

fun asStaticBackupRequestList(arr: ReadableArray): List<StaticBackupRequest> {
    val list = ArrayList<StaticBackupRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asStaticBackupRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asStaticBackupResponse(staticBackupResponse: ReadableMap): StaticBackupResponse? {
    if (!validateMandatoryFields(
            staticBackupResponse,
            arrayOf(),
        )
    ) {
        return null
    }
    val backup =
        if (hasNonNullKey(
                staticBackupResponse,
                "backup",
            )
        ) {
            staticBackupResponse.getArray("backup")?.let { asStringList(it) }
        } else {
            null
        }
    return StaticBackupResponse(
        backup,
    )
}

fun readableMapOf(staticBackupResponse: StaticBackupResponse): ReadableMap {
    return readableMapOf(
        "backup" to staticBackupResponse.backup?.let { readableArrayOf(it) },
    )
}

fun asStaticBackupResponseList(arr: ReadableArray): List<StaticBackupResponse> {
    val list = ArrayList<StaticBackupResponse>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asStaticBackupResponse(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSwapInfo(swapInfo: ReadableMap): SwapInfo? {
    if (!validateMandatoryFields(
            swapInfo,
            arrayOf(
                "bitcoinAddress",
                "createdAt",
                "lockHeight",
                "paymentHash",
                "preimage",
                "privateKey",
                "publicKey",
                "swapperPublicKey",
                "script",
                "paidMsat",
                "unconfirmedSats",
                "confirmedSats",
                "totalIncomingTxs",
                "status",
                "refundTxIds",
                "unconfirmedTxIds",
                "confirmedTxIds",
                "minAllowedDeposit",
                "maxAllowedDeposit",
            ),
        )
    ) {
        return null
    }
    val bitcoinAddress = swapInfo.getString("bitcoinAddress")!!
    val createdAt = swapInfo.getDouble("createdAt").toLong()
    val lockHeight = swapInfo.getDouble("lockHeight").toLong()
    val paymentHash = swapInfo.getArray("paymentHash")?.let { asUByteList(it) }!!
    val preimage = swapInfo.getArray("preimage")?.let { asUByteList(it) }!!
    val privateKey = swapInfo.getArray("privateKey")?.let { asUByteList(it) }!!
    val publicKey = swapInfo.getArray("publicKey")?.let { asUByteList(it) }!!
    val swapperPublicKey = swapInfo.getArray("swapperPublicKey")?.let { asUByteList(it) }!!
    val script = swapInfo.getArray("script")?.let { asUByteList(it) }!!
    val bolt11 = if (hasNonNullKey(swapInfo, "bolt11")) swapInfo.getString("bolt11") else null
    val paidMsat = swapInfo.getDouble("paidMsat").toULong()
    val unconfirmedSats = swapInfo.getDouble("unconfirmedSats").toULong()
    val confirmedSats = swapInfo.getDouble("confirmedSats").toULong()
    val totalIncomingTxs = swapInfo.getDouble("totalIncomingTxs").toULong()
    val status = swapInfo.getString("status")?.let { asSwapStatus(it) }!!
    val refundTxIds = swapInfo.getArray("refundTxIds")?.let { asStringList(it) }!!
    val unconfirmedTxIds = swapInfo.getArray("unconfirmedTxIds")?.let { asStringList(it) }!!
    val confirmedTxIds = swapInfo.getArray("confirmedTxIds")?.let { asStringList(it) }!!
    val minAllowedDeposit = swapInfo.getDouble("minAllowedDeposit").toLong()
    val maxAllowedDeposit = swapInfo.getDouble("maxAllowedDeposit").toLong()
    val lastRedeemError = if (hasNonNullKey(swapInfo, "lastRedeemError")) swapInfo.getString("lastRedeemError") else null
    val channelOpeningFees =
        if (hasNonNullKey(swapInfo, "channelOpeningFees")) {
            swapInfo.getMap("channelOpeningFees")?.let {
                asOpeningFeeParams(it)
            }
        } else {
            null
        }
    val confirmedAt = if (hasNonNullKey(swapInfo, "confirmedAt")) swapInfo.getInt("confirmedAt").toUInt() else null
    return SwapInfo(
        bitcoinAddress,
        createdAt,
        lockHeight,
        paymentHash,
        preimage,
        privateKey,
        publicKey,
        swapperPublicKey,
        script,
        bolt11,
        paidMsat,
        unconfirmedSats,
        confirmedSats,
        totalIncomingTxs,
        status,
        refundTxIds,
        unconfirmedTxIds,
        confirmedTxIds,
        minAllowedDeposit,
        maxAllowedDeposit,
        lastRedeemError,
        channelOpeningFees,
        confirmedAt,
    )
}

fun readableMapOf(swapInfo: SwapInfo): ReadableMap {
    return readableMapOf(
        "bitcoinAddress" to swapInfo.bitcoinAddress,
        "createdAt" to swapInfo.createdAt,
        "lockHeight" to swapInfo.lockHeight,
        "paymentHash" to readableArrayOf(swapInfo.paymentHash),
        "preimage" to readableArrayOf(swapInfo.preimage),
        "privateKey" to readableArrayOf(swapInfo.privateKey),
        "publicKey" to readableArrayOf(swapInfo.publicKey),
        "swapperPublicKey" to readableArrayOf(swapInfo.swapperPublicKey),
        "script" to readableArrayOf(swapInfo.script),
        "bolt11" to swapInfo.bolt11,
        "paidMsat" to swapInfo.paidMsat,
        "unconfirmedSats" to swapInfo.unconfirmedSats,
        "confirmedSats" to swapInfo.confirmedSats,
        "totalIncomingTxs" to swapInfo.totalIncomingTxs,
        "status" to swapInfo.status.name.lowercase(),
        "refundTxIds" to readableArrayOf(swapInfo.refundTxIds),
        "unconfirmedTxIds" to readableArrayOf(swapInfo.unconfirmedTxIds),
        "confirmedTxIds" to readableArrayOf(swapInfo.confirmedTxIds),
        "minAllowedDeposit" to swapInfo.minAllowedDeposit,
        "maxAllowedDeposit" to swapInfo.maxAllowedDeposit,
        "lastRedeemError" to swapInfo.lastRedeemError,
        "channelOpeningFees" to swapInfo.channelOpeningFees?.let { readableMapOf(it) },
        "confirmedAt" to swapInfo.confirmedAt,
    )
}

fun asSwapInfoList(arr: ReadableArray): List<SwapInfo> {
    val list = ArrayList<SwapInfo>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asSwapInfo(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSymbol(symbol: ReadableMap): Symbol? {
    if (!validateMandatoryFields(
            symbol,
            arrayOf(),
        )
    ) {
        return null
    }
    val grapheme = if (hasNonNullKey(symbol, "grapheme")) symbol.getString("grapheme") else null
    val template = if (hasNonNullKey(symbol, "template")) symbol.getString("template") else null
    val rtl = if (hasNonNullKey(symbol, "rtl")) symbol.getBoolean("rtl") else null
    val position = if (hasNonNullKey(symbol, "position")) symbol.getInt("position").toUInt() else null
    return Symbol(
        grapheme,
        template,
        rtl,
        position,
    )
}

fun readableMapOf(symbol: Symbol): ReadableMap {
    return readableMapOf(
        "grapheme" to symbol.grapheme,
        "template" to symbol.template,
        "rtl" to symbol.rtl,
        "position" to symbol.position,
    )
}

fun asSymbolList(arr: ReadableArray): List<Symbol> {
    val list = ArrayList<Symbol>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asSymbol(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asTlvEntry(tlvEntry: ReadableMap): TlvEntry? {
    if (!validateMandatoryFields(
            tlvEntry,
            arrayOf(
                "fieldNumber",
                "value",
            ),
        )
    ) {
        return null
    }
    val fieldNumber = tlvEntry.getDouble("fieldNumber").toULong()
    val value = tlvEntry.getArray("value")?.let { asUByteList(it) }!!
    return TlvEntry(
        fieldNumber,
        value,
    )
}

fun readableMapOf(tlvEntry: TlvEntry): ReadableMap {
    return readableMapOf(
        "fieldNumber" to tlvEntry.fieldNumber,
        "value" to readableArrayOf(tlvEntry.value),
    )
}

fun asTlvEntryList(arr: ReadableArray): List<TlvEntry> {
    val list = ArrayList<TlvEntry>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asTlvEntry(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asUnspentTransactionOutput(unspentTransactionOutput: ReadableMap): UnspentTransactionOutput? {
    if (!validateMandatoryFields(
            unspentTransactionOutput,
            arrayOf(
                "txid",
                "outnum",
                "amountMillisatoshi",
                "address",
                "reserved",
            ),
        )
    ) {
        return null
    }
    val txid = unspentTransactionOutput.getArray("txid")?.let { asUByteList(it) }!!
    val outnum = unspentTransactionOutput.getInt("outnum").toUInt()
    val amountMillisatoshi = unspentTransactionOutput.getDouble("amountMillisatoshi").toULong()
    val address = unspentTransactionOutput.getString("address")!!
    val reserved = unspentTransactionOutput.getBoolean("reserved")
    return UnspentTransactionOutput(
        txid,
        outnum,
        amountMillisatoshi,
        address,
        reserved,
    )
}

fun readableMapOf(unspentTransactionOutput: UnspentTransactionOutput): ReadableMap {
    return readableMapOf(
        "txid" to readableArrayOf(unspentTransactionOutput.txid),
        "outnum" to unspentTransactionOutput.outnum,
        "amountMillisatoshi" to unspentTransactionOutput.amountMillisatoshi,
        "address" to unspentTransactionOutput.address,
        "reserved" to unspentTransactionOutput.reserved,
    )
}

fun asUnspentTransactionOutputList(arr: ReadableArray): List<UnspentTransactionOutput> {
    val list = ArrayList<UnspentTransactionOutput>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asUnspentTransactionOutput(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asUrlSuccessActionData(urlSuccessActionData: ReadableMap): UrlSuccessActionData? {
    if (!validateMandatoryFields(
            urlSuccessActionData,
            arrayOf(
                "description",
                "url",
            ),
        )
    ) {
        return null
    }
    val description = urlSuccessActionData.getString("description")!!
    val url = urlSuccessActionData.getString("url")!!
    return UrlSuccessActionData(
        description,
        url,
    )
}

fun readableMapOf(urlSuccessActionData: UrlSuccessActionData): ReadableMap {
    return readableMapOf(
        "description" to urlSuccessActionData.description,
        "url" to urlSuccessActionData.url,
    )
}

fun asUrlSuccessActionDataList(arr: ReadableArray): List<UrlSuccessActionData> {
    val list = ArrayList<UrlSuccessActionData>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asUrlSuccessActionData(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asAesSuccessActionDataResult(aesSuccessActionDataResult: ReadableMap): AesSuccessActionDataResult? {
    val type = aesSuccessActionDataResult.getString("type")

    if (type == "decrypted") {
        return AesSuccessActionDataResult.Decrypted(
            aesSuccessActionDataResult.getMap("data")?.let { asAesSuccessActionDataDecrypted(it) }!!,
        )
    }
    if (type == "errorStatus") {
        return AesSuccessActionDataResult.ErrorStatus(aesSuccessActionDataResult.getString("reason")!!)
    }
    return null
}

fun readableMapOf(aesSuccessActionDataResult: AesSuccessActionDataResult): ReadableMap? {
    val map = Arguments.createMap()
    when (aesSuccessActionDataResult) {
        is AesSuccessActionDataResult.Decrypted -> {
            pushToMap(map, "type", "decrypted")
            pushToMap(map, "data", readableMapOf(aesSuccessActionDataResult.data))
        }
        is AesSuccessActionDataResult.ErrorStatus -> {
            pushToMap(map, "type", "errorStatus")
            pushToMap(map, "reason", aesSuccessActionDataResult.reason)
        }
    }
    return map
}

fun asAesSuccessActionDataResultList(arr: ReadableArray): List<AesSuccessActionDataResult> {
    val list = ArrayList<AesSuccessActionDataResult>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asAesSuccessActionDataResult(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asBreezEvent(breezEvent: ReadableMap): BreezEvent? {
    val type = breezEvent.getString("type")

    if (type == "newBlock") {
        return BreezEvent.NewBlock(breezEvent.getInt("block").toUInt())
    }
    if (type == "invoicePaid") {
        return BreezEvent.InvoicePaid(breezEvent.getMap("details")?.let { asInvoicePaidDetails(it) }!!)
    }
    if (type == "synced") {
        return BreezEvent.Synced
    }
    if (type == "paymentSucceed") {
        return BreezEvent.PaymentSucceed(breezEvent.getMap("details")?.let { asPayment(it) }!!)
    }
    if (type == "paymentFailed") {
        return BreezEvent.PaymentFailed(breezEvent.getMap("details")?.let { asPaymentFailedData(it) }!!)
    }
    if (type == "backupStarted") {
        return BreezEvent.BackupStarted
    }
    if (type == "backupSucceeded") {
        return BreezEvent.BackupSucceeded
    }
    if (type == "backupFailed") {
        return BreezEvent.BackupFailed(breezEvent.getMap("details")?.let { asBackupFailedData(it) }!!)
    }
    if (type == "swapUpdated") {
        return BreezEvent.SwapUpdated(breezEvent.getMap("details")?.let { asSwapInfo(it) }!!)
    }
    return null
}

fun readableMapOf(breezEvent: BreezEvent): ReadableMap? {
    val map = Arguments.createMap()
    when (breezEvent) {
        is BreezEvent.NewBlock -> {
            pushToMap(map, "type", "newBlock")
            pushToMap(map, "block", breezEvent.block)
        }
        is BreezEvent.InvoicePaid -> {
            pushToMap(map, "type", "invoicePaid")
            pushToMap(map, "details", readableMapOf(breezEvent.details))
        }
        is BreezEvent.Synced -> {
            pushToMap(map, "type", "synced")
        }
        is BreezEvent.PaymentSucceed -> {
            pushToMap(map, "type", "paymentSucceed")
            pushToMap(map, "details", readableMapOf(breezEvent.details))
        }
        is BreezEvent.PaymentFailed -> {
            pushToMap(map, "type", "paymentFailed")
            pushToMap(map, "details", readableMapOf(breezEvent.details))
        }
        is BreezEvent.BackupStarted -> {
            pushToMap(map, "type", "backupStarted")
        }
        is BreezEvent.BackupSucceeded -> {
            pushToMap(map, "type", "backupSucceeded")
        }
        is BreezEvent.BackupFailed -> {
            pushToMap(map, "type", "backupFailed")
            pushToMap(map, "details", readableMapOf(breezEvent.details))
        }
        is BreezEvent.SwapUpdated -> {
            pushToMap(map, "type", "swapUpdated")
            pushToMap(map, "details", readableMapOf(breezEvent.details))
        }
    }
    return map
}

fun asBreezEventList(arr: ReadableArray): List<BreezEvent> {
    val list = ArrayList<BreezEvent>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asBreezEvent(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asBuyBitcoinProvider(type: String): BuyBitcoinProvider {
    return BuyBitcoinProvider.valueOf(type.uppercase())
}

fun asBuyBitcoinProviderList(arr: ReadableArray): List<BuyBitcoinProvider> {
    val list = ArrayList<BuyBitcoinProvider>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asBuyBitcoinProvider(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asChannelState(type: String): ChannelState {
    return ChannelState.valueOf(type.uppercase())
}

fun asChannelStateList(arr: ReadableArray): List<ChannelState> {
    val list = ArrayList<ChannelState>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asChannelState(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asEnvironmentType(type: String): EnvironmentType {
    return EnvironmentType.valueOf(type.uppercase())
}

fun asEnvironmentTypeList(arr: ReadableArray): List<EnvironmentType> {
    val list = ArrayList<EnvironmentType>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asEnvironmentType(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asFeeratePreset(type: String): FeeratePreset {
    return FeeratePreset.valueOf(type.uppercase())
}

fun asFeeratePresetList(arr: ReadableArray): List<FeeratePreset> {
    val list = ArrayList<FeeratePreset>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asFeeratePreset(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asHealthCheckStatus(type: String): HealthCheckStatus {
    return HealthCheckStatus.valueOf(type.uppercase())
}

fun asHealthCheckStatusList(arr: ReadableArray): List<HealthCheckStatus> {
    val list = ArrayList<HealthCheckStatus>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asHealthCheckStatus(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asInputType(inputType: ReadableMap): InputType? {
    val type = inputType.getString("type")

    if (type == "bitcoinAddress") {
        return InputType.BitcoinAddress(inputType.getMap("address")?.let { asBitcoinAddressData(it) }!!)
    }
    if (type == "bolt11") {
        return InputType.Bolt11(inputType.getMap("invoice")?.let { asLnInvoice(it) }!!)
    }
    if (type == "nodeId") {
        return InputType.NodeId(inputType.getString("nodeId")!!)
    }
    if (type == "url") {
        return InputType.Url(inputType.getString("url")!!)
    }
    if (type == "lnUrlPay") {
        return InputType.LnUrlPay(inputType.getMap("data")?.let { asLnUrlPayRequestData(it) }!!)
    }
    if (type == "lnUrlWithdraw") {
        return InputType.LnUrlWithdraw(inputType.getMap("data")?.let { asLnUrlWithdrawRequestData(it) }!!)
    }
    if (type == "lnUrlAuth") {
        return InputType.LnUrlAuth(inputType.getMap("data")?.let { asLnUrlAuthRequestData(it) }!!)
    }
    if (type == "lnUrlError") {
        return InputType.LnUrlError(inputType.getMap("data")?.let { asLnUrlErrorData(it) }!!)
    }
    return null
}

fun readableMapOf(inputType: InputType): ReadableMap? {
    val map = Arguments.createMap()
    when (inputType) {
        is InputType.BitcoinAddress -> {
            pushToMap(map, "type", "bitcoinAddress")
            pushToMap(map, "address", readableMapOf(inputType.address))
        }
        is InputType.Bolt11 -> {
            pushToMap(map, "type", "bolt11")
            pushToMap(map, "invoice", readableMapOf(inputType.invoice))
        }
        is InputType.NodeId -> {
            pushToMap(map, "type", "nodeId")
            pushToMap(map, "nodeId", inputType.nodeId)
        }
        is InputType.Url -> {
            pushToMap(map, "type", "url")
            pushToMap(map, "url", inputType.url)
        }
        is InputType.LnUrlPay -> {
            pushToMap(map, "type", "lnUrlPay")
            pushToMap(map, "data", readableMapOf(inputType.data))
        }
        is InputType.LnUrlWithdraw -> {
            pushToMap(map, "type", "lnUrlWithdraw")
            pushToMap(map, "data", readableMapOf(inputType.data))
        }
        is InputType.LnUrlAuth -> {
            pushToMap(map, "type", "lnUrlAuth")
            pushToMap(map, "data", readableMapOf(inputType.data))
        }
        is InputType.LnUrlError -> {
            pushToMap(map, "type", "lnUrlError")
            pushToMap(map, "data", readableMapOf(inputType.data))
        }
    }
    return map
}

fun asInputTypeList(arr: ReadableArray): List<InputType> {
    val list = ArrayList<InputType>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asInputType(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLevelFilter(type: String): LevelFilter {
    return LevelFilter.valueOf(type.uppercase())
}

fun asLevelFilterList(arr: ReadableArray): List<LevelFilter> {
    val list = ArrayList<LevelFilter>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asLevelFilter(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlCallbackStatus(lnUrlCallbackStatus: ReadableMap): LnUrlCallbackStatus? {
    val type = lnUrlCallbackStatus.getString("type")

    if (type == "ok") {
        return LnUrlCallbackStatus.Ok
    }
    if (type == "errorStatus") {
        return LnUrlCallbackStatus.ErrorStatus(lnUrlCallbackStatus.getMap("data")?.let { asLnUrlErrorData(it) }!!)
    }
    return null
}

fun readableMapOf(lnUrlCallbackStatus: LnUrlCallbackStatus): ReadableMap? {
    val map = Arguments.createMap()
    when (lnUrlCallbackStatus) {
        is LnUrlCallbackStatus.Ok -> {
            pushToMap(map, "type", "ok")
        }
        is LnUrlCallbackStatus.ErrorStatus -> {
            pushToMap(map, "type", "errorStatus")
            pushToMap(map, "data", readableMapOf(lnUrlCallbackStatus.data))
        }
    }
    return map
}

fun asLnUrlCallbackStatusList(arr: ReadableArray): List<LnUrlCallbackStatus> {
    val list = ArrayList<LnUrlCallbackStatus>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlCallbackStatus(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlPayResult(lnUrlPayResult: ReadableMap): LnUrlPayResult? {
    val type = lnUrlPayResult.getString("type")

    if (type == "endpointSuccess") {
        return LnUrlPayResult.EndpointSuccess(lnUrlPayResult.getMap("data")?.let { asLnUrlPaySuccessData(it) }!!)
    }
    if (type == "endpointError") {
        return LnUrlPayResult.EndpointError(lnUrlPayResult.getMap("data")?.let { asLnUrlErrorData(it) }!!)
    }
    if (type == "payError") {
        return LnUrlPayResult.PayError(lnUrlPayResult.getMap("data")?.let { asLnUrlPayErrorData(it) }!!)
    }
    return null
}

fun readableMapOf(lnUrlPayResult: LnUrlPayResult): ReadableMap? {
    val map = Arguments.createMap()
    when (lnUrlPayResult) {
        is LnUrlPayResult.EndpointSuccess -> {
            pushToMap(map, "type", "endpointSuccess")
            pushToMap(map, "data", readableMapOf(lnUrlPayResult.data))
        }
        is LnUrlPayResult.EndpointError -> {
            pushToMap(map, "type", "endpointError")
            pushToMap(map, "data", readableMapOf(lnUrlPayResult.data))
        }
        is LnUrlPayResult.PayError -> {
            pushToMap(map, "type", "payError")
            pushToMap(map, "data", readableMapOf(lnUrlPayResult.data))
        }
    }
    return map
}

fun asLnUrlPayResultList(arr: ReadableArray): List<LnUrlPayResult> {
    val list = ArrayList<LnUrlPayResult>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlPayResult(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asLnUrlWithdrawResult(lnUrlWithdrawResult: ReadableMap): LnUrlWithdrawResult? {
    val type = lnUrlWithdrawResult.getString("type")

    if (type == "ok") {
        return LnUrlWithdrawResult.Ok(lnUrlWithdrawResult.getMap("data")?.let { asLnUrlWithdrawSuccessData(it) }!!)
    }
    if (type == "errorStatus") {
        return LnUrlWithdrawResult.ErrorStatus(lnUrlWithdrawResult.getMap("data")?.let { asLnUrlErrorData(it) }!!)
    }
    return null
}

fun readableMapOf(lnUrlWithdrawResult: LnUrlWithdrawResult): ReadableMap? {
    val map = Arguments.createMap()
    when (lnUrlWithdrawResult) {
        is LnUrlWithdrawResult.Ok -> {
            pushToMap(map, "type", "ok")
            pushToMap(map, "data", readableMapOf(lnUrlWithdrawResult.data))
        }
        is LnUrlWithdrawResult.ErrorStatus -> {
            pushToMap(map, "type", "errorStatus")
            pushToMap(map, "data", readableMapOf(lnUrlWithdrawResult.data))
        }
    }
    return map
}

fun asLnUrlWithdrawResultList(arr: ReadableArray): List<LnUrlWithdrawResult> {
    val list = ArrayList<LnUrlWithdrawResult>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asLnUrlWithdrawResult(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asNetwork(type: String): Network {
    return Network.valueOf(type.uppercase())
}

fun asNetworkList(arr: ReadableArray): List<Network> {
    val list = ArrayList<Network>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asNetwork(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asNodeConfig(nodeConfig: ReadableMap): NodeConfig? {
    val type = nodeConfig.getString("type")

    if (type == "greenlight") {
        return NodeConfig.Greenlight(nodeConfig.getMap("config")?.let { asGreenlightNodeConfig(it) }!!)
    }
    return null
}

fun readableMapOf(nodeConfig: NodeConfig): ReadableMap? {
    val map = Arguments.createMap()
    when (nodeConfig) {
        is NodeConfig.Greenlight -> {
            pushToMap(map, "type", "greenlight")
            pushToMap(map, "config", readableMapOf(nodeConfig.config))
        }
    }
    return map
}

fun asNodeConfigList(arr: ReadableArray): List<NodeConfig> {
    val list = ArrayList<NodeConfig>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asNodeConfig(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asNodeCredentials(nodeCredentials: ReadableMap): NodeCredentials? {
    val type = nodeCredentials.getString("type")

    if (type == "greenlight") {
        return NodeCredentials.Greenlight(nodeCredentials.getMap("credentials")?.let { asGreenlightCredentials(it) }!!)
    }
    return null
}

fun readableMapOf(nodeCredentials: NodeCredentials): ReadableMap? {
    val map = Arguments.createMap()
    when (nodeCredentials) {
        is NodeCredentials.Greenlight -> {
            pushToMap(map, "type", "greenlight")
            pushToMap(map, "credentials", readableMapOf(nodeCredentials.credentials))
        }
    }
    return map
}

fun asNodeCredentialsList(arr: ReadableArray): List<NodeCredentials> {
    val list = ArrayList<NodeCredentials>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asNodeCredentials(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPaymentDetails(paymentDetails: ReadableMap): PaymentDetails? {
    val type = paymentDetails.getString("type")

    if (type == "ln") {
        return PaymentDetails.Ln(paymentDetails.getMap("data")?.let { asLnPaymentDetails(it) }!!)
    }
    if (type == "closedChannel") {
        return PaymentDetails.ClosedChannel(paymentDetails.getMap("data")?.let { asClosedChannelPaymentDetails(it) }!!)
    }
    return null
}

fun readableMapOf(paymentDetails: PaymentDetails): ReadableMap? {
    val map = Arguments.createMap()
    when (paymentDetails) {
        is PaymentDetails.Ln -> {
            pushToMap(map, "type", "ln")
            pushToMap(map, "data", readableMapOf(paymentDetails.data))
        }
        is PaymentDetails.ClosedChannel -> {
            pushToMap(map, "type", "closedChannel")
            pushToMap(map, "data", readableMapOf(paymentDetails.data))
        }
    }
    return map
}

fun asPaymentDetailsList(arr: ReadableArray): List<PaymentDetails> {
    val list = ArrayList<PaymentDetails>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asPaymentDetails(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPaymentStatus(type: String): PaymentStatus {
    return PaymentStatus.valueOf(type.uppercase())
}

fun asPaymentStatusList(arr: ReadableArray): List<PaymentStatus> {
    val list = ArrayList<PaymentStatus>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asPaymentStatus(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPaymentType(type: String): PaymentType {
    return PaymentType.valueOf(type.uppercase())
}

fun asPaymentTypeList(arr: ReadableArray): List<PaymentType> {
    val list = ArrayList<PaymentType>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asPaymentType(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asPaymentTypeFilter(type: String): PaymentTypeFilter {
    return PaymentTypeFilter.valueOf(type.uppercase())
}

fun asPaymentTypeFilterList(arr: ReadableArray): List<PaymentTypeFilter> {
    val list = ArrayList<PaymentTypeFilter>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asPaymentTypeFilter(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asReportIssueRequest(reportIssueRequest: ReadableMap): ReportIssueRequest? {
    val type = reportIssueRequest.getString("type")

    if (type == "paymentFailure") {
        return ReportIssueRequest.PaymentFailure(reportIssueRequest.getMap("data")?.let { asReportPaymentFailureDetails(it) }!!)
    }
    return null
}

fun readableMapOf(reportIssueRequest: ReportIssueRequest): ReadableMap? {
    val map = Arguments.createMap()
    when (reportIssueRequest) {
        is ReportIssueRequest.PaymentFailure -> {
            pushToMap(map, "type", "paymentFailure")
            pushToMap(map, "data", readableMapOf(reportIssueRequest.data))
        }
    }
    return map
}

fun asReportIssueRequestList(arr: ReadableArray): List<ReportIssueRequest> {
    val list = ArrayList<ReportIssueRequest>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asReportIssueRequest(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asReverseSwapStatus(type: String): ReverseSwapStatus {
    return ReverseSwapStatus.valueOf(type.uppercase())
}

fun asReverseSwapStatusList(arr: ReadableArray): List<ReverseSwapStatus> {
    val list = ArrayList<ReverseSwapStatus>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asReverseSwapStatus(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSuccessActionProcessed(successActionProcessed: ReadableMap): SuccessActionProcessed? {
    val type = successActionProcessed.getString("type")

    if (type == "aes") {
        return SuccessActionProcessed.Aes(successActionProcessed.getMap("result")?.let { asAesSuccessActionDataResult(it) }!!)
    }
    if (type == "message") {
        return SuccessActionProcessed.Message(successActionProcessed.getMap("data")?.let { asMessageSuccessActionData(it) }!!)
    }
    if (type == "url") {
        return SuccessActionProcessed.Url(successActionProcessed.getMap("data")?.let { asUrlSuccessActionData(it) }!!)
    }
    return null
}

fun readableMapOf(successActionProcessed: SuccessActionProcessed): ReadableMap? {
    val map = Arguments.createMap()
    when (successActionProcessed) {
        is SuccessActionProcessed.Aes -> {
            pushToMap(map, "type", "aes")
            pushToMap(map, "result", readableMapOf(successActionProcessed.result))
        }
        is SuccessActionProcessed.Message -> {
            pushToMap(map, "type", "message")
            pushToMap(map, "data", readableMapOf(successActionProcessed.data))
        }
        is SuccessActionProcessed.Url -> {
            pushToMap(map, "type", "url")
            pushToMap(map, "data", readableMapOf(successActionProcessed.data))
        }
    }
    return map
}

fun asSuccessActionProcessedList(arr: ReadableArray): List<SuccessActionProcessed> {
    val list = ArrayList<SuccessActionProcessed>()
    for (value in arr.toArrayList()) {
        when (value) {
            is ReadableMap -> list.add(asSuccessActionProcessed(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSwapAmountType(type: String): SwapAmountType {
    return SwapAmountType.valueOf(type.uppercase())
}

fun asSwapAmountTypeList(arr: ReadableArray): List<SwapAmountType> {
    val list = ArrayList<SwapAmountType>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asSwapAmountType(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asSwapStatus(type: String): SwapStatus {
    return SwapStatus.valueOf(type.uppercase())
}

fun asSwapStatusList(arr: ReadableArray): List<SwapStatus> {
    val list = ArrayList<SwapStatus>()
    for (value in arr.toArrayList()) {
        when (value) {
            is String -> list.add(asSwapStatus(value)!!)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun readableMapOf(vararg values: Pair<String, *>): ReadableMap {
    val map = Arguments.createMap()
    for ((key, value) in values) {
        pushToMap(map, key, value)
    }
    return map
}

fun hasNonNullKey(
    map: ReadableMap,
    key: String,
): Boolean {
    return map.hasKey(key) && !map.isNull(key)
}

fun validateMandatoryFields(
    map: ReadableMap,
    keys: Array<String>,
): Boolean {
    for (k in keys) {
        if (!hasNonNullKey(map, k)) return false
    }

    return true
}

fun pushToArray(
    array: WritableArray,
    value: Any?,
) {
    when (value) {
        null -> array.pushNull()
        is FiatCurrency -> array.pushMap(readableMapOf(value))
        is LocaleOverrides -> array.pushMap(readableMapOf(value))
        is LocalizedName -> array.pushMap(readableMapOf(value))
        is LspInformation -> array.pushMap(readableMapOf(value))
        is MetadataFilter -> array.pushMap(readableMapOf(value))
        is OpeningFeeParams -> array.pushMap(readableMapOf(value))
        is Payment -> array.pushMap(readableMapOf(value))
        is PaymentTypeFilter -> array.pushString(value.name.lowercase())
        is Rate -> array.pushMap(readableMapOf(value))
        is ReverseSwapInfo -> array.pushMap(readableMapOf(value))
        is RouteHint -> array.pushMap(readableMapOf(value))
        is RouteHintHop -> array.pushMap(readableMapOf(value))
        is String -> array.pushString(value)
        is SwapInfo -> array.pushMap(readableMapOf(value))
        is TlvEntry -> array.pushMap(readableMapOf(value))
        is UByte -> array.pushInt(value.toInt())
        is UnspentTransactionOutput -> array.pushMap(readableMapOf(value))
        is Array<*> -> array.pushArray(readableArrayOf(value.asIterable()))
        is List<*> -> array.pushArray(readableArrayOf(value))
        else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
    }
}

fun pushToMap(
    map: WritableMap,
    key: String,
    value: Any?,
) {
    when (value) {
        null -> map.putNull(key)
        is Boolean -> map.putBoolean(key, value)
        is Byte -> map.putInt(key, value.toInt())
        is Double -> map.putDouble(key, value)
        is Int -> map.putInt(key, value)
        is Long -> map.putDouble(key, value.toDouble())
        is ReadableArray -> map.putArray(key, value)
        is ReadableMap -> map.putMap(key, value)
        is String -> map.putString(key, value)
        is UByte -> map.putInt(key, value.toInt())
        is UInt -> map.putInt(key, value.toInt())
        is UShort -> map.putInt(key, value.toInt())
        is ULong -> map.putDouble(key, value.toDouble())
        is Array<*> -> map.putArray(key, readableArrayOf(value.asIterable()))
        is List<*> -> map.putArray(key, readableArrayOf(value))
        else -> throw SdkException.Generic("Unexpected type ${value::class.java.name} for key [$key]")
    }
}

fun readableArrayOf(values: Iterable<*>?): ReadableArray {
    val array = Arguments.createArray()
    if (values != null) {
        for (value in values) {
            pushToArray(array, value)
        }
    }

    return array
}

fun asUByteList(arr: ReadableArray): List<UByte> {
    val list = ArrayList<UByte>()
    for (value in arr.toArrayList()) {
        when (value) {
            is Double -> list.add(value.toInt().toUByte())
            is Int -> list.add(value.toUByte())
            is UByte -> list.add(value)
            else -> throw SdkException.Generic(errUnexpectedType("${value::class.java.name}"))
        }
    }
    return list
}

fun asStringList(arr: ReadableArray): List<String> {
    val list = ArrayList<String>()
    for (value in arr.toArrayList()) {
        list.add(value.toString())
    }
    return list
}

fun errMissingMandatoryField(
    fieldName: String,
    typeName: String,
): String {
    return "Missing mandatory field $fieldName for type $typeName"
}

fun errUnexpectedType(typeName: String): String {
    return "Unexpected type $typeName"
}

fun errUnexpectedValue(fieldName: String): String {
    return "Unexpected value for optional field $fieldName"
}
