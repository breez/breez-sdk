import { NativeModules, Platform, EmitterSubscription, NativeEventEmitter } from "react-native"

const LINKING_ERROR =
    `The package 'react-native-breez-sdk' doesn't seem to be linked. Make sure: \n\n` +
    Platform.select({ ios: "- You have run 'pod install'\n", default: "" }) +
    "- You rebuilt the app after installing the package\n" +
    "- You are not using Expo managed workflow\n"

const BreezSDK = NativeModules.RNBreezSDK
    ? NativeModules.RNBreezSDK
    : new Proxy(
          {},
          {
              get() {
                  throw new Error(LINKING_ERROR)
              }
          }
      )

const BreezSDKEmitter = new NativeEventEmitter(BreezSDK)

export type AesSuccessActionDataDecrypted = {
    description: string
    plaintext: string
}

export type BackupFailedData = {
    error: string
}

export type BackupStatus = {
    backedUp: boolean
    lastBackupTime?: number
}

export type BitcoinAddressData = {
    address: string
    network: Network
    amountSat?: number
    label?: string
    message?: string
}

export type BuyBitcoinRequest = {
    provider: BuyBitcoinProvider
    openingFeeParams?: OpeningFeeParams
}

export type BuyBitcoinResponse = {
    url: string
    openingFeeParams?: OpeningFeeParams
}

export type CheckMessageRequest = {
    message: string
    pubkey: string
    signature: string
}

export type CheckMessageResponse = {
    isValid: boolean
}

export type ClosedChannelPaymentDetails = {
    shortChannelId: string
    state: ChannelState
    fundingTxid: string
    closingTxid?: string
}

export type Config = {
    breezserver: string
    mempoolspaceUrl: string
    workingDir: string
    network: Network
    paymentTimeoutSec: number
    defaultLspId?: string
    apiKey?: string
    maxfeePercent: number
    exemptfeeMsat: number
    nodeConfig: NodeConfig
}

export type CurrencyInfo = {
    name: string
    fractionSize: number
    spacing?: number
    symbol?: SymbolType
    uniqSymbol?: SymbolType
    localizedName?: LocalizedName[]
    localeOverrides?: LocaleOverrides[]
}

export type FiatCurrency = {
    id: string
    info: CurrencyInfo
}

export type GreenlightCredentials = {
    deviceKey: number[]
    deviceCert: number[]
}

export type GreenlightNodeConfig = {
    partnerCredentials?: GreenlightCredentials
    inviteCode?: string
}

export type InvoicePaidDetails = {
    paymentHash: string
    bolt11: string
}

export type LnInvoice = {
    rawInvoice: string
    payeePubkey: string
    paymentHash: string
    description?: string
    descriptionHash?: string
    amountMsat?: number
    timestamp: number
    expiry: number
    routingHints: RouteHint[]
    paymentSecret: number[]
}

export type LnOffer = {
    bolt12: string
    chains: string[]
    description: string
    supportedQuantity: Quantity
    signingPubkey: string
    amount?: Amount
    absoluteExpiry?: number
    issuer?: string
    metadata?: number[]
}

export type ListPaymentsRequest = {
    filters?: PaymentTypeFilter[]
    fromTimestamp?: number
    toTimestamp?: number
    includeFailures?: boolean
    offset?: number
    limit?: number
}

export type LnPaymentDetails = {
    paymentHash: string
    label: string
    destinationPubkey: string
    paymentPreimage: string
    keysend: boolean
    bolt11: string
    lnurlSuccessAction?: SuccessActionProcessed
    lnurlMetadata?: string
    lnAddress?: string
    lnurlWithdrawEndpoint?: string
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

export type LnUrlPayErrorData = {
    paymentHash: string
    reason: string
}

export type LnUrlPayRequest = {
    data: LnUrlPayRequestData
    amountMsat: number
    comment?: string
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

export type LnUrlPaySuccessData = {
    successAction?: SuccessActionProcessed
    paymentHash: string
}

export type LnUrlWithdrawRequest = {
    data: LnUrlWithdrawRequestData
    amountMsat: number
    description?: string
}

export type LnUrlWithdrawRequestData = {
    callback: string
    k1: string
    defaultDescription: string
    minWithdrawable: number
    maxWithdrawable: number
}

export type LnUrlWithdrawSuccessData = {
    invoice: LnInvoice
}

export type LocaleOverrides = {
    locale: string
    spacing?: number
    symbol: SymbolType
}

export type LocalizedName = {
    locale: string
    name: string
}

export type LogEntry = {
    line: string
    level: string
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
    lspPubkey: number[]
    openingFeeParamsList: OpeningFeeParamsMenu
}

export type MessageSuccessActionData = {
    message: string
}

export type MetadataItem = {
    key: string
    value: string
}

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

export type OpenChannelFeeRequest = {
    amountMsat: number
    expiry?: number
}

export type OpenChannelFeeResponse = {
    feeMsat: number
    usedFeeParams?: OpeningFeeParams
}

export type OpeningFeeParams = {
    minMsat: number
    proportional: number
    validUntil: string
    maxIdleTime: number
    maxClientToSelfDelay: number
    promise: string
}

export type OpeningFeeParamsMenu = {
    values: OpeningFeeParams[]
}

export type Payment = {
    id: string
    paymentType: PaymentType
    paymentTime: number
    amountMsat: number
    feeMsat: number
    status: PaymentStatus
    description?: string
    details: PaymentDetails
}

export type PaymentFailedData = {
    error: string
    nodeId: string
    invoice?: LnInvoice
}

export type PrepareRefundRequest = {
    swapAddress: string
    toAddress: string
    satPerVbyte: number
}

export type PrepareRefundResponse = {
    refundTxWeight: number
    refundTxFeeSat: number
}

export type PrepareSweepRequest = {
    toAddress: string
    satsPerVbyte: number
}

export type PrepareSweepResponse = {
    sweepTxWeight: number
    sweepTxFeeSat: number
}

export type Rate = {
    coin: string
    value: number
}

export type ReceiveOnchainRequest = {
    openingFeeParams?: OpeningFeeParams
}

export type ReceivePaymentRequest = {
    amountMsat: number
    description: string
    preimage?: number[]
    openingFeeParams?: OpeningFeeParams
    useDescriptionHash?: boolean
    expiry?: number
    cltv?: number
}

export type ReceivePaymentResponse = {
    lnInvoice: LnInvoice
    openingFeeParams?: OpeningFeeParams
    openingFeeMsat?: number
}

export type RecommendedFees = {
    fastestFee: number
    halfHourFee: number
    hourFee: number
    economyFee: number
    minimumFee: number
}

export type RefundRequest = {
    swapAddress: string
    toAddress: string
    satPerVbyte: number
}

export type RefundResponse = {
    refundTxId: string
}

export type ReverseSwapFeesRequest = {
    sendAmountSat?: number
}

export type ReverseSwapInfo = {
    id: string
    claimPubkey: string
    lockupTxid?: string
    claimTxid?: string
    onchainAmountSat: number
    status: ReverseSwapStatus
}

export type ReverseSwapPairInfo = {
    min: number
    max: number
    feesHash: string
    feesPercentage: number
    feesLockup: number
    feesClaim: number
    totalEstimatedFees?: number
}

export type RouteHint = {
    hops: RouteHintHop[]
}

export type RouteHintHop = {
    srcNodeId: string
    shortChannelId: number
    feesBaseMsat: number
    feesProportionalMillionths: number
    cltvExpiryDelta: number
    htlcMinimumMsat?: number
    htlcMaximumMsat?: number
}

export type SendOnchainRequest = {
    amountSat: number
    onchainRecipientAddress: string
    pairHash: string
    satPerVbyte: number
}

export type SendOnchainResponse = {
    reverseSwapInfo: ReverseSwapInfo
}

export type SendPaymentRequest = {
    invoice: string
    amountMsat?: number
}

export type SendPaymentResponse = {
    payment: Payment
}

export type SendSpontaneousPaymentRequest = {
    nodeId: string
    amountMsat: number
}

export type SignMessageRequest = {
    message: string
}

export type SignMessageResponse = {
    signature: string
}

export type StaticBackupRequest = {
    workingDir: string
}

export type StaticBackupResponse = {
    backup?: string[]
}

export type SwapInfo = {
    bitcoinAddress: string
    createdAt: number
    lockHeight: number
    paymentHash: number[]
    preimage: number[]
    privateKey: number[]
    publicKey: number[]
    swapperPublicKey: number[]
    script: number[]
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
    channelOpeningFees?: OpeningFeeParams
}

export type SweepRequest = {
    toAddress: string
    feeRateSatsPerVbyte: number
}

export type SweepResponse = {
    txid: number[]
}

export type SymbolType = {
    grapheme?: string
    template?: string
    rtl?: boolean
    position?: number
}

export type UnspentTransactionOutput = {
    txid: number[]
    outnum: number
    amountMillisatoshi: number
    address: string
    reserved: boolean
}

export type UrlSuccessActionData = {
    description: string
    url: string
}

export enum AmountVariant {
    BITCOIN = "bitcoin",
    CURRENCY = "currency"
}

export type Amount = {
    type: AmountVariant.BITCOIN,
    amountMsat: number
} | {
    type: AmountVariant.CURRENCY,
    iso4217Code: string
    fractionalAmount: number
}

export enum BreezEventVariant {
    NEW_BLOCK = "newBlock",
    INVOICE_PAID = "invoicePaid",
    SYNCED = "synced",
    PAYMENT_SUCCEED = "paymentSucceed",
    PAYMENT_FAILED = "paymentFailed",
    BACKUP_STARTED = "backupStarted",
    BACKUP_SUCCEEDED = "backupSucceeded",
    BACKUP_FAILED = "backupFailed"
}

export type BreezEvent = {
    type: BreezEventVariant.NEW_BLOCK,
    block: number
} | {
    type: BreezEventVariant.INVOICE_PAID,
    details: InvoicePaidDetails
} | {
    type: BreezEventVariant.SYNCED
} | {
    type: BreezEventVariant.PAYMENT_SUCCEED,
    details: Payment
} | {
    type: BreezEventVariant.PAYMENT_FAILED,
    details: PaymentFailedData
} | {
    type: BreezEventVariant.BACKUP_STARTED
} | {
    type: BreezEventVariant.BACKUP_SUCCEEDED
} | {
    type: BreezEventVariant.BACKUP_FAILED,
    details: BackupFailedData
}

export enum BuyBitcoinProvider {
    MOONPAY = "moonpay"
}

export enum ChannelState {
    PENDING_OPEN = "pendingOpen",
    OPENED = "opened",
    PENDING_CLOSE = "pendingClose",
    CLOSED = "closed"
}

export enum EnvironmentType {
    PRODUCTION = "production",
    STAGING = "staging"
}

export enum FeeratePreset {
    REGULAR = "regular",
    ECONOMY = "economy",
    PRIORITY = "priority"
}

export enum InputTypeVariant {
    BITCOIN_ADDRESS = "bitcoinAddress",
    BOLT11 = "bolt11",
    BOLT12_OFFER = "bolt12Offer",
    NODE_ID = "nodeId",
    URL = "url",
    LN_URL_PAY = "lnUrlPay",
    LN_URL_WITHDRAW = "lnUrlWithdraw",
    LN_URL_AUTH = "lnUrlAuth",
    LN_URL_ERROR = "lnUrlError"
}

export type InputType = {
    type: InputTypeVariant.BITCOIN_ADDRESS,
    address: BitcoinAddressData
} | {
    type: InputTypeVariant.BOLT11,
    invoice: LnInvoice
} | {
    type: InputTypeVariant.BOLT12_OFFER,
    offer: LnOffer
} | {
    type: InputTypeVariant.NODE_ID,
    nodeId: string
} | {
    type: InputTypeVariant.URL,
    url: string
} | {
    type: InputTypeVariant.LN_URL_PAY,
    data: LnUrlPayRequestData
} | {
    type: InputTypeVariant.LN_URL_WITHDRAW,
    data: LnUrlWithdrawRequestData
} | {
    type: InputTypeVariant.LN_URL_AUTH,
    data: LnUrlAuthRequestData
} | {
    type: InputTypeVariant.LN_URL_ERROR,
    data: LnUrlErrorData
}

export enum LnUrlCallbackStatusVariant {
    OK = "ok",
    ERROR_STATUS = "errorStatus"
}

export type LnUrlCallbackStatus = {
    type: LnUrlCallbackStatusVariant.OK
} | {
    type: LnUrlCallbackStatusVariant.ERROR_STATUS,
    data: LnUrlErrorData
}

export enum LnUrlPayResultVariant {
    ENDPOINT_SUCCESS = "endpointSuccess",
    ENDPOINT_ERROR = "endpointError",
    PAY_ERROR = "payError"
}

export type LnUrlPayResult = {
    type: LnUrlPayResultVariant.ENDPOINT_SUCCESS,
    data: LnUrlPaySuccessData
} | {
    type: LnUrlPayResultVariant.ENDPOINT_ERROR,
    data: LnUrlErrorData
} | {
    type: LnUrlPayResultVariant.PAY_ERROR,
    data: LnUrlPayErrorData
}

export enum LnUrlWithdrawResultVariant {
    OK = "ok",
    ERROR_STATUS = "errorStatus"
}

export type LnUrlWithdrawResult = {
    type: LnUrlWithdrawResultVariant.OK,
    data: LnUrlWithdrawSuccessData
} | {
    type: LnUrlWithdrawResultVariant.ERROR_STATUS,
    data: LnUrlErrorData
}

export enum Network {
    BITCOIN = "bitcoin",
    TESTNET = "testnet",
    SIGNET = "signet",
    REGTEST = "regtest"
}

export enum NodeConfigVariant {
    GREENLIGHT = "greenlight"
}

export type NodeConfig = {
    type: NodeConfigVariant.GREENLIGHT,
    config: GreenlightNodeConfig
}

export enum PaymentDetailsVariant {
    LN = "ln",
    CLOSED_CHANNEL = "closedChannel"
}

export type PaymentDetails = {
    type: PaymentDetailsVariant.LN,
    data: LnPaymentDetails
} | {
    type: PaymentDetailsVariant.CLOSED_CHANNEL,
    data: ClosedChannelPaymentDetails
}

export enum PaymentStatus {
    PENDING = "pending",
    COMPLETE = "complete",
    FAILED = "failed"
}

export enum PaymentType {
    SENT = "sent",
    RECEIVED = "received",
    CLOSED_CHANNEL = "closedChannel"
}

export enum PaymentTypeFilter {
    SENT = "sent",
    RECEIVED = "received",
    CLOSED_CHANNEL = "closedChannel"
}

export enum QuantityVariant {
    BOUNDED = "bounded",
    UNBOUNDED = "unbounded",
    ONE = "one"
}

export type Quantity = {
    type: QuantityVariant.BOUNDED,
    amount: number
} | {
    type: QuantityVariant.UNBOUNDED
} | {
    type: QuantityVariant.ONE
}

export enum ReverseSwapStatus {
    INITIAL = "initial",
    IN_PROGRESS = "inProgress",
    CANCELLED = "cancelled",
    COMPLETED_SEEN = "completedSeen",
    COMPLETED_CONFIRMED = "completedConfirmed"
}

export enum SuccessActionProcessedVariant {
    AES = "aes",
    MESSAGE = "message",
    URL = "url"
}

export type SuccessActionProcessed = {
    type: SuccessActionProcessedVariant.AES,
    data: AesSuccessActionDataDecrypted
} | {
    type: SuccessActionProcessedVariant.MESSAGE,
    data: MessageSuccessActionData
} | {
    type: SuccessActionProcessedVariant.URL,
    data: UrlSuccessActionData
}

export enum SwapStatus {
    INITIAL = "initial",
    EXPIRED = "expired"
}
export type EventListener = (breezEvent: BreezEvent) => void

export type LogStream = (logEntry: LogEntry) => void

export const connect = async (config: Config, seed: number[], listener: EventListener): Promise<EmitterSubscription> => {
    const subscription = BreezSDKEmitter.addListener("breezSdkEvent", listener)
    
    await BreezSDK.connect(config, seed)

    return subscription
}

export const setLogStream = async (logStream: LogStream): Promise<EmitterSubscription> => {
    const subscription = BreezSDKEmitter.addListener("breezSdkLog", logStream)

    await BreezSDK.setLogStream()

    return subscription
}

export const parseInvoice = async (invoice: string): Promise<LnInvoice> => {
    const response = await BreezSDK.parseInvoice(invoice)
    return response
}

export const parseInput = async (s: string): Promise<InputType> => {
    const response = await BreezSDK.parseInput(s)
    return response
}

export const mnemonicToSeed = async (phrase: string): Promise<number[]> => {
    const response = await BreezSDK.mnemonicToSeed(phrase)
    return response
}

export const defaultConfig = async (envType: EnvironmentType, apiKey: string, nodeConfig: NodeConfig): Promise<Config> => {
    const response = await BreezSDK.defaultConfig(envType, apiKey, nodeConfig)
    return response
}

export const staticBackup = async (req: StaticBackupRequest): Promise<StaticBackupResponse> => {
    const response = await BreezSDK.staticBackup(req)
    return response
}


export const disconnect = async (): Promise<void> => {
    await BreezSDK.disconnect()
}

export const sendPayment = async (req: SendPaymentRequest): Promise<SendPaymentResponse> => {
    const response = await BreezSDK.sendPayment(req)
    return response
}

export const sendSpontaneousPayment = async (req: SendSpontaneousPaymentRequest): Promise<SendPaymentResponse> => {
    const response = await BreezSDK.sendSpontaneousPayment(req)
    return response
}

export const receivePayment = async (req: ReceivePaymentRequest): Promise<ReceivePaymentResponse> => {
    const response = await BreezSDK.receivePayment(req)
    return response
}

export const payLnurl = async (req: LnUrlPayRequest): Promise<LnUrlPayResult> => {
    const response = await BreezSDK.payLnurl(req)
    return response
}

export const withdrawLnurl = async (request: LnUrlWithdrawRequest): Promise<LnUrlWithdrawResult> => {
    const response = await BreezSDK.withdrawLnurl(request)
    return response
}

export const lnurlAuth = async (reqData: LnUrlAuthRequestData): Promise<LnUrlCallbackStatus> => {
    const response = await BreezSDK.lnurlAuth(reqData)
    return response
}

export const nodeInfo = async (): Promise<NodeState> => {
    const response = await BreezSDK.nodeInfo()
    return response
}

export const signMessage = async (req: SignMessageRequest): Promise<SignMessageResponse> => {
    const response = await BreezSDK.signMessage(req)
    return response
}

export const checkMessage = async (req: CheckMessageRequest): Promise<CheckMessageResponse> => {
    const response = await BreezSDK.checkMessage(req)
    return response
}

export const backupStatus = async (): Promise<BackupStatus> => {
    const response = await BreezSDK.backupStatus()
    return response
}

export const backup = async (): Promise<void> => {
    await BreezSDK.backup()
}

export const paymentByHash = async (hash: string): Promise<Payment | null> => {
    const response = await BreezSDK.paymentByHash(hash)
    return response
}

export const listPayments = async (req: ListPaymentsRequest): Promise<Payment[]> => {
    const response = await BreezSDK.listPayments(req)
    return response
}

export const sweep = async (req: SweepRequest): Promise<SweepResponse> => {
    const response = await BreezSDK.sweep(req)
    return response
}

export const fetchFiatRates = async (): Promise<Rate[]> => {
    const response = await BreezSDK.fetchFiatRates()
    return response
}

export const listFiatCurrencies = async (): Promise<FiatCurrency[]> => {
    const response = await BreezSDK.listFiatCurrencies()
    return response
}

export const listLsps = async (): Promise<LspInformation[]> => {
    const response = await BreezSDK.listLsps()
    return response
}

export const connectLsp = async (lspId: string): Promise<void> => {
    await BreezSDK.connectLsp(lspId)
}

export const fetchLspInfo = async (lspId: string): Promise<LspInformation | null> => {
    const response = await BreezSDK.fetchLspInfo(lspId)
    return response
}

export const openChannelFee = async (req: OpenChannelFeeRequest): Promise<OpenChannelFeeResponse> => {
    const response = await BreezSDK.openChannelFee(req)
    return response
}

export const lspId = async (): Promise<string | null> => {
    const response = await BreezSDK.lspId()
    return response
}

export const lspInfo = async (): Promise<LspInformation> => {
    const response = await BreezSDK.lspInfo()
    return response
}

export const closeLspChannels = async (): Promise<void> => {
    await BreezSDK.closeLspChannels()
}

export const receiveOnchain = async (req: ReceiveOnchainRequest): Promise<SwapInfo> => {
    const response = await BreezSDK.receiveOnchain(req)
    return response
}

export const inProgressSwap = async (): Promise<SwapInfo | null> => {
    const response = await BreezSDK.inProgressSwap()
    return response
}

export const listRefundables = async (): Promise<SwapInfo[]> => {
    const response = await BreezSDK.listRefundables()
    return response
}

export const prepareRefund = async (req: PrepareRefundRequest): Promise<PrepareRefundResponse> => {
    const response = await BreezSDK.prepareRefund(req)
    return response
}

export const refund = async (req: RefundRequest): Promise<RefundResponse> => {
    const response = await BreezSDK.refund(req)
    return response
}

export const fetchReverseSwapFees = async (req: ReverseSwapFeesRequest): Promise<ReverseSwapPairInfo> => {
    const response = await BreezSDK.fetchReverseSwapFees(req)
    return response
}

export const inProgressReverseSwaps = async (): Promise<ReverseSwapInfo[]> => {
    const response = await BreezSDK.inProgressReverseSwaps()
    return response
}

export const sendOnchain = async (req: SendOnchainRequest): Promise<SendOnchainResponse> => {
    const response = await BreezSDK.sendOnchain(req)
    return response
}

export const executeDevCommand = async (command: string): Promise<string> => {
    const response = await BreezSDK.executeDevCommand(command)
    return response
}

export const sync = async (): Promise<void> => {
    await BreezSDK.sync()
}

export const recommendedFees = async (): Promise<RecommendedFees> => {
    const response = await BreezSDK.recommendedFees()
    return response
}

export const buyBitcoin = async (req: BuyBitcoinRequest): Promise<BuyBitcoinResponse> => {
    const response = await BreezSDK.buyBitcoin(req)
    return response
}

export const prepareSweep = async (req: PrepareSweepRequest): Promise<PrepareSweepResponse> => {
    const response = await BreezSDK.prepareSweep(req)
    return response
}
