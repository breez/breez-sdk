import { NativeModules, NativeEventEmitter, Platform } from "react-native"

const LINKING_ERROR =
    `The package 'react-native-breez-sdk' doesn't seem to be linked. Make sure: \n\n` +
    Platform.select({ ios: "- You have run 'pod install'\n", default: "" }) +
    "- You rebuilt the app after installing the package\n" +
    "- You are not using Expo managed workflow\n"

const BreezSDK = NativeModules.BreezSDK
    ? NativeModules.BreezSDK
    : new Proxy(
          {},
          {
              get() {
                  throw new Error(LINKING_ERROR)
              }
          }
      )

const BreezSDKEmitter = new NativeEventEmitter(BreezSDK)

enum EventType {
    INVOICE_PAID = "invoicePaid",
    NEW_BLOCK = "newBlock",
    PAYMENT_SUCCEED = "paymentSucceed",
    PAYMENT_FAILED = "paymentFailed",
    SYNCED = "synced"
}

enum InputType {
    BITCOIN_ADDRESS = "bitcoinAddress",
    BOLT11 = "bolt11",
    LNURL_AUTH = "lnUrlAuth",
    LNURL_ERROR = "lnUrlError",
    LNURL_PAY = "lnUrlPay",
    LNURL_WITHDRAW = "lnUrlWithdraw",
    NODE_ID = "nodeId",
    URL = "url"
}

enum LnUrlPayResult {
    ENDPOINT_SUCCESS = "endpointSuccess",
    ENDPOINT_FAILURE = "endpointFailure"
}

export enum PaymentType {
    SEND = "send",
    RECEIVED = "received",
    CLOSED_CHANNEL = "closed_channel"
}

enum PaymentDetailType {
    LN = "ln",
    CLOSED_CHANNEL = "closed_channel"
}

export enum PaymentTypeFilter {
    SENT = "sent",
    RECEIVED = "received",
    ALL = "all"
}

export enum Network {
    BITCOIN = "bitcoin",
    REGTEST = "regtest",
    SIGNET = "signet",
    TESTNET = "testnet"
}

enum SuccessActionDataType {
    AES = "aes",
    MESSAGE = "message",
    URL = "url"
}

enum SwapStatus {
    INITIAL = "initial",
    EXPIRED = "expired"
}

export type AesSuccessActionDataDecrypted = {
    description: string
    plaintext: string
}

export type BitcoinAddressData = {
    address: string
    network: Network
    amountSat?: number
    label?: string
    message?: string
}

export type ClosedChannelPaymentDetails = {
    shortChannelId: string
    state: string
    fundingTxid: string
}

export type CurrencyInfo = {
    name: string
    fractionSize: number
    spacing: number
    symbol?: Symbol
    uniqSymbol?: Symbol
    localizedName?: LocalizedName[]
    localeOverrides?: LocaleOverrides[]
}

export type GreenlightCredentials = {
    deviceKey: Uint8Array
    deviceCert: Uint8Array
}

export type FiatCurrency = {
    id: string
    info: CurrencyInfo
}

export type InvoicePaidDetails = {
    paymentHash: string
    bolt11: string
}

export type LnInvoice = {
    bolt11: string
    payeePubkey: string
    paymentHash: string
    description?: string
    descriptionHash?: string
    amountMsat?: number
    timestamp: number
    expiry: number
    routingHints: RouteHint[]
    paymentSecret?: Uint8Array
}

export type LogEntry = {
    line: string
    level: string
}

export type EventFn = (type: EventType, data?: InvoicePaidDetails | Payment | number | string) => void

export type LogEntryFn = (l: LogEntry) => void

export type LnPaymentDetails = {
    paymentHash: string
    label: string
    destinationPubkey: string
    paymentPreimage: string
    keysend: boolean
    bolt11: string
    lnurlSuccessAction?: AesSuccessActionDataDecrypted | MessageSuccessActionData | UrlSuccessActionData
    lnurlMetadata?: string
    lnAddress?: string
}

export type LnUrlAuthRequestData = {
    k1: string
    action?: string
    domain: string
    url: string
}

export type LnUrlErrorData = {
    reason: string
}

export type LnUrlPayRequestData = {
    callback: string
    minSendable: number
    maxSendable: number
    metadataStr: string
    commentAllowed: number
    domain: string
    lnAddress?: string
}

export type LnUrlWithdrawCallbackStatus = {
    status: string
    reason?: string
}

export type LnUrlAuthCallbackStatus = {
    status: string
    reason?: string
}

export type EndpointSuccess = {
    data?: AesSuccessActionDataDecrypted | MessageSuccessActionData | UrlSuccessActionData
}

export type EndpointFailure = {
    data: LnUrlErrorData
}

export type LnUrlWithdrawRequestData = {
    callback: string
    k1: string
    defaultDescription: string
    minWithdrawable: number
    maxWithdrawable: number
}

export type LocaleOverrides = {
    locale: string
    spacing?: number
    symbol: Symbol
}

export type LocalizedName = {
    locale: string
    name: string
}

export type LspInformation = {
    id: string
    name: string
    widgetUrl: string
    pubkey: string
    host: string
    channelCapacity: number
    targetConf: number
    baseFeeMsat: number
    feeRate: number
    timeLockDelta: number
    minHtlcMsat: number
    channelFeePermyriad: number
    lspPubkey: Uint8Array
    maxInactiveDuration: number
    channelMinimumFeeMsat: number
}

export type MessageSuccessActionData = {
    message: string
}

export type NodeId = string

export type NodeState = {
    id: string
    blockHeight: number
    channelsBalanceMsat: number
    onchainBalanceMsat: number
    utxos: UnspentTransactionOutput[]
    maxPayableMsat: number
    maxReceivableMsat: number
    maxSinglePaymentAmountMsat: number
    maxChanReserveMsats: number
    connectedPeers: string[]
    inboundLiquidityMsats: number
}

export type Payment = {
    id: string
    paymentType: PaymentType
    paymentTime: number
    amountMsat: number
    feeMsat: number
    pending: boolean
    description?: string
    details: LnPaymentDetails | ClosedChannelPaymentDetails
}

export type Rate = {
    coin: string
    value: number
}

export type RecommendedFees = {
    fastestFee: number
    halfHourFee: number
    hourFee: number
    economyFee: number
    minimumFee: number
}

export type RouteHint = {
    hops: RouteHintHops[]
}

export type RouteHintHops = {
    srcNodeId: string
    shortChannelId: number
    feesBaseMsat: number
    feesProportionalMillionths: number
    cltvExpiryDelta: number
    htlcMinimumMsat?: number
    htlcMaximumMsat: number
}

export type SwapInfo = {
    bitcoinAddress: string
    createdAt: number
    lockHeight: number
    paymentHash: Uint8Array
    preimage: Uint8Array
    privateKey: Uint8Array
    publicKey: Uint8Array
    swapperPublicKey: Uint8Array
    script: Uint8Array
    bolt11?: string
    paidSats: number
    unconfirmedSats: number
    confirmedSats: number
    status: SwapStatus
    refundTxIds: string[]
    unconfirmedTxIds: string[]
    confirmedTxIds: string[]
    minAllowedDeposit: number
    maxAllowedDeposit: number
    lastRedeemError?: string
}

export type Symbol = {
    grapheme?: string
    template?: string
    rtl?: boolean
    position?: number
}

export type Url = string

export type UrlSuccessActionData = {
    description: string
    url: string
}

export type UnspentTransactionOutput = {
    txid: Uint8Array
    outnum: number
    amountMillisatoshi: number
    address: string
    reserved: boolean
    reservedToBlock: number
}

function eventProcessor(eventFn: EventFn) {
    return (event: any) => {
        switch (event.type) {
            case EventType.INVOICE_PAID:
                return eventFn(EventType.INVOICE_PAID, event.data as InvoicePaidDetails)
            case EventType.NEW_BLOCK:
                return eventFn(EventType.NEW_BLOCK, event.data)
            case EventType.PAYMENT_FAILED:
                return eventFn(EventType.PAYMENT_FAILED, event.data)
            case EventType.PAYMENT_SUCCEED:
                const payment = event.data as Payment

                switch (event.data.details.type) {
                    case PaymentDetailType.CLOSED_CHANNEL:
                        payment.details = event.data.details as ClosedChannelPaymentDetails
                        break
                    case PaymentDetailType.LN:
                        payment.details = event.data.details as LnPaymentDetails

                        if (event.data.details.lnurlSuccessAction) {
                            switch (event.data.details.lnurlSuccessAction.type) {
                                case SuccessActionDataType.AES:
                                    payment.details.lnurlSuccessAction = event.data.details.lnurlSuccessAction as AesSuccessActionDataDecrypted
                                    break
                                case SuccessActionDataType.MESSAGE:
                                    payment.details.lnurlSuccessAction = event.data.details.lnurlSuccessAction as MessageSuccessActionData
                                    break
                                case SuccessActionDataType.URL:
                                    payment.details.lnurlSuccessAction = event.data.details.lnurlSuccessAction as UrlSuccessActionData
                                    break
                            }
                        }
                        break
                }

                return eventFn(EventType.PAYMENT_SUCCEED, payment)
            case EventType.SYNCED:
                return eventFn(EventType.SYNCED)
        }
    }
}

export async function addEventListener(eventFn: EventFn) {
    BreezSDKEmitter.addListener("breezSdkEvent", eventProcessor(eventFn))
}

export async function addLogListener(logEntryFn: LogEntryFn): Promise<void> {
    BreezSDKEmitter.addListener("breezSdkLog", logEntryFn)

    await BreezSDK.startLogStream()
}

export async function mnemonicToSeed(phrase: string): Promise<Uint8Array> {
    return BreezSDK.mnemonicToSeed(phrase)
}

export async function parseInput(
    input: string
): Promise<BitcoinAddressData | LnInvoice | LnUrlAuthRequestData | LnUrlErrorData | LnUrlPayRequestData | LnUrlWithdrawRequestData | NodeId | Url> {
    const response = await BreezSDK.parseInput(input)

    switch (response.type) {
        case InputType.BITCOIN_ADDRESS:
            return response.data as BitcoinAddressData
        case InputType.BOLT11:
            return response.data as LnInvoice
        case InputType.LNURL_AUTH:
            return response.data as LnUrlAuthRequestData
        case InputType.LNURL_ERROR:
            return response.data as LnUrlErrorData
        case InputType.LNURL_PAY:
            return response.data as LnUrlPayRequestData
        case InputType.LNURL_WITHDRAW:
            return response.data as LnUrlWithdrawRequestData
        case InputType.NODE_ID:
            return response.data as NodeId
        case InputType.URL:
            return response.data as Url
    }

    throw Error(`Unknown input type: ${response.type}`)
}

export async function parseInvoice(invoice: string): Promise<LnInvoice> {
    const response = await BreezSDK.parseInvoice(invoice)
    return response as LnInvoice
}

export async function registerNode(network: Network, seed: Uint8Array): Promise<GreenlightCredentials> {
    const response = await BreezSDK.registerNode(network, seed)
    return response as GreenlightCredentials
}

export async function recoverNode(network: Network, seed: Uint8Array): Promise<GreenlightCredentials> {
    const response = await BreezSDK.recoverNode(network, seed)
    return response as GreenlightCredentials
}

export async function initServices(apiKey: string, deviceKey: Uint8Array, deviceCert: Uint8Array, seed: Uint8Array): Promise<void> {
    await BreezSDK.initServices(apiKey, deviceKey, deviceCert, seed)
}

export async function start(): Promise<void> {
    await BreezSDK.start()
}

export async function sync(): Promise<void> {
    await BreezSDK.sync()
}

export async function stop(): Promise<void> {
    await BreezSDK.stop()
}

export async function sendPayment(bolt11: string, amountSats: number = 0): Promise<Payment> {
    const response = await BreezSDK.sendPayment(bolt11, amountSats)
    return response as Payment
}

export async function sendSpontaneousPayment(nodeId: string, amountSats: number): Promise<Payment> {
    const response = await BreezSDK.sendSpontaneousPayment(nodeId, amountSats)
    return response as Payment
}

export async function receivePayment(amountSats: number, description: string): Promise<LnInvoice> {
    const response = await BreezSDK.receivePayment(amountSats, description)
    return response as LnInvoice
}

export async function withdrawLnurl(
    reqData: LnUrlWithdrawRequestData,
    amountSats: number,
    description?: string
): Promise<LnUrlWithdrawCallbackStatus> {
    const response = await BreezSDK.withdrawLnurl(reqData, amountSats, description)
    return response as LnUrlWithdrawCallbackStatus
}

export async function lnurlAuth(
    reqData: LnUrlAuthRequestData
): Promise<LnUrlAuthCallbackStatus> {
    const response = await BreezSDK.lnurlAuth(reqData)
    return response as LnUrlAuthCallbackStatus
}

export async function payLnurl(
    reqData: LnUrlPayRequestData,
    amountSats: number,
    comment?: string
): Promise<EndpointSuccess | EndpointFailure> {
    const response = await BreezSDK.payLnurl(reqData, amountSats, comment)

    switch (response.type) {
        case LnUrlPayResult.ENDPOINT_SUCCESS:
            return response as EndpointSuccess
        case LnUrlPayResult.ENDPOINT_FAILURE:
            return response as EndpointFailure
    }

    throw Error(`Unknown lnurl pay result type: ${response.type}`)
}

export async function nodeInfo(): Promise<NodeState> {
    const response = await BreezSDK.nodeInfo()
    return response as NodeState
}

export async function listPayments(filter: PaymentTypeFilter, fromTimestamp: number = 0, toTimestamp: number = 0): Promise<Payment[]> {
    const response = await BreezSDK.listPayments(filter, fromTimestamp, toTimestamp)
    return response as Payment[]
}

export async function sweep(toAddress: string, feeRateSatsPerByte: number): Promise<void> {
    await BreezSDK.sweep(toAddress, feeRateSatsPerByte)
}

export async function fetchFiatRates(): Promise<Rate[]> {
    const response = await BreezSDK.fetchFiatRates()
    return response as Rate[]
}

export async function listFiatCurrencies(): Promise<FiatCurrency[]> {
    const response = await BreezSDK.listFiatCurrencies()
    return response as FiatCurrency[]
}

export async function listLsps(): Promise<LspInformation[]> {
    const response = await BreezSDK.listLsps()
    return response as LspInformation[]
}

export async function connectLsp(lspId: string): Promise<void> {
    await BreezSDK.connectLsp(lspId)
}

export async function fetchLspInfo(lspId: string): Promise<LspInformation> {
    const response = await BreezSDK.fetchLspInfo(lspId)
    return response as LspInformation
}

export async function lspId(): Promise<string> {
    const response = await BreezSDK.lspId(lspId)
    return response
}

export async function closeLspChannels(): Promise<void> {
    await BreezSDK.closeLspChannels()
}

export async function receiveOnchain(): Promise<SwapInfo> {
    const response = await BreezSDK.receiveOnchain()
    return response as SwapInfo
}

export async function inProgressSwap(): Promise<SwapInfo> {
    const response = await BreezSDK.inProgressSwap()
    return response as SwapInfo
}

export async function listRefundables(): Promise<SwapInfo[]> {
    const response = await BreezSDK.listRefundables()
    return response as SwapInfo[]
}

export async function refund(swapAddress: string, toAddress: string, satPerVbyte: number): Promise<string> {
    const response = await BreezSDK.refund(swapAddress, toAddress, satPerVbyte)
    return response
}

export async function executeDevCommand(command: string): Promise<string> {
    const response = await BreezSDK.executeDevCommand(command)
    return response
}

export async function recommendedFees(): Promise<RecommendedFees> {
    const response = await BreezSDK.recommendedFees()
    return response as RecommendedFees
}
