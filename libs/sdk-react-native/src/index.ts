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

export interface AesSuccessActionDataDecrypted {
    description: string
    plaintext: string
}

export interface BackupFailedData {
    error: string
}

export interface BackupStatus {
    backedUp: boolean
    lastBackupTime?: number
}

export interface BitcoinAddressData {
    address: string
    network: Network
    amountSat?: number
    label?: string
    message?: string
}

export interface BuyBitcoinRequest {
    provider: BuyBitcoinProvider
    openingFeeParams?: OpeningFeeParams
    redirectUrl?: string
}

export interface BuyBitcoinResponse {
    url: string
    openingFeeParams?: OpeningFeeParams
}

export interface CheckMessageRequest {
    message: string
    pubkey: string
    signature: string
}

export interface CheckMessageResponse {
    isValid: boolean
}

export interface ClosedChannelPaymentDetails {
    state: ChannelState
    fundingTxid: string
    shortChannelId?: string
    closingTxid?: string
}

export interface Config {
    breezserver: string
    chainnotifierUrl: string
    mempoolspaceUrl?: string
    workingDir: string
    network: Network
    paymentTimeoutSec: number
    defaultLspId?: string
    apiKey?: string
    maxfeePercent: number
    exemptfeeMsat: number
    nodeConfig: NodeConfig
}

export interface ConfigureNodeRequest {
    closeToAddress?: string
}

export interface ConnectRequest {
    config: Config
    seed: number[]
    restoreOnly?: boolean
}

export interface ConnectedPeer {
    id: string
    features: PeerFeatures
}

export interface CurrencyInfo {
    name: string
    fractionSize: number
    spacing?: number
    symbol?: SymbolType
    uniqSymbol?: SymbolType
    localizedName: LocalizedName[]
    localeOverrides: LocaleOverrides[]
}

export interface FiatCurrency {
    id: string
    info: CurrencyInfo
}

export interface GreenlightCredentials {
    developerKey: number[]
    developerCert: number[]
}

export interface GreenlightDeviceCredentials {
    device: number[]
}

export interface GreenlightNodeConfig {
    partnerCredentials?: GreenlightCredentials
    inviteCode?: string
}

export interface InvoicePaidDetails {
    paymentHash: string
    bolt11: string
    payment?: Payment
}

export interface LnInvoice {
    bolt11: string
    network: Network
    payeePubkey: string
    paymentHash: string
    description?: string
    descriptionHash?: string
    amountMsat?: number
    timestamp: number
    expiry: number
    routingHints: RouteHint[]
    paymentSecret: number[]
    minFinalCltvExpiryDelta: number
}

export interface ListPaymentsRequest {
    filters?: PaymentTypeFilter[]
    metadataFilters?: MetadataFilter[]
    fromTimestamp?: number
    toTimestamp?: number
    includeFailures?: boolean
    offset?: number
    limit?: number
}

export interface LnPaymentDetails {
    paymentHash: string
    label: string
    destinationPubkey: string
    paymentPreimage: string
    keysend: boolean
    bolt11: string
    openChannelBolt11?: string
    lnurlSuccessAction?: SuccessActionProcessed
    lnurlPayDomain?: string
    lnurlPayComment?: string
    lnurlMetadata?: string
    lnAddress?: string
    lnurlWithdrawEndpoint?: string
    swapInfo?: SwapInfo
    reverseSwapInfo?: ReverseSwapInfo
    pendingExpirationBlock?: number
}

export interface LnUrlAuthRequestData {
    k1: string
    domain: string
    url: string
    action?: string
}

export interface LnUrlErrorData {
    reason: string
}

export interface LnUrlPayErrorData {
    paymentHash: string
    reason: string
}

export interface LnUrlPayRequest {
    data: LnUrlPayRequestData
    amountMsat: number
    useTrampoline: boolean
    comment?: string
    paymentLabel?: string
    validateSuccessActionUrl?: boolean
}

export interface LnUrlPayRequestData {
    callback: string
    minSendable: number
    maxSendable: number
    metadataStr: string
    commentAllowed: number
    domain: string
    allowsNostr: boolean
    nostrPubkey?: string
    lnAddress?: string
}

export interface LnUrlPaySuccessData {
    successAction?: SuccessActionProcessed
    payment: Payment
}

export interface LnUrlWithdrawRequest {
    data: LnUrlWithdrawRequestData
    amountMsat: number
    description?: string
}

export interface LnUrlWithdrawRequestData {
    callback: string
    k1: string
    defaultDescription: string
    minWithdrawable: number
    maxWithdrawable: number
}

export interface LnUrlWithdrawSuccessData {
    invoice: LnInvoice
}

export interface LocaleOverrides {
    locale: string
    spacing?: number
    symbol: SymbolType
}

export interface LocalizedName {
    locale: string
    name: string
}

export interface LogEntry {
    line: string
    level: string
}

export interface LspInformation {
    id: string
    name: string
    widgetUrl: string
    pubkey: string
    host: string
    baseFeeMsat: number
    feeRate: number
    timeLockDelta: number
    minHtlcMsat: number
    lspPubkey: number[]
    openingFeeParamsList: OpeningFeeParamsMenu
}

export interface MaxReverseSwapAmountResponse {
    totalSat: number
}

export interface MessageSuccessActionData {
    message: string
}

export interface MetadataFilter {
    jsonPath: string
    jsonValue: string
}

export interface MetadataItem {
    key: string
    value: string
}

export interface NodeState {
    id: string
    blockHeight: number
    channelsBalanceMsat: number
    onchainBalanceMsat: number
    pendingOnchainBalanceMsat: number
    utxos: UnspentTransactionOutput[]
    maxPayableMsat: number
    maxReceivableMsat: number
    maxSinglePaymentAmountMsat: number
    maxChanReserveMsats: number
    connectedPeers: ConnectedPeer[]
    maxReceivableSinglePaymentAmountMsat: number
    totalInboundLiquidityMsats: number
}

export interface OnchainPaymentLimitsResponse {
    minSat: number
    maxSat: number
    maxPayableSat: number
}

export interface OpenChannelFeeRequest {
    amountMsat?: number
    expiry?: number
}

export interface OpenChannelFeeResponse {
    feeMsat?: number
    feeParams: OpeningFeeParams
}

export interface OpeningFeeParams {
    minMsat: number
    proportional: number
    validUntil: string
    maxIdleTime: number
    maxClientToSelfDelay: number
    promise: string
}

export interface OpeningFeeParamsMenu {
    values: OpeningFeeParams[]
}

export interface PayOnchainRequest {
    recipientAddress: string
    prepareRes: PrepareOnchainPaymentResponse
}

export interface PayOnchainResponse {
    reverseSwapInfo: ReverseSwapInfo
}

export interface Payment {
    id: string
    paymentType: PaymentType
    paymentTime: number
    amountMsat: number
    feeMsat: number
    status: PaymentStatus
    error?: string
    description?: string
    details: PaymentDetails
    metadata?: string
}

export interface PaymentFailedData {
    error: string
    nodeId: string
    invoice?: LnInvoice
    label?: string
}

export interface PeerFeatures {
    trampoline: boolean
}

export interface PrepareOnchainPaymentRequest {
    amountSat: number
    amountType: SwapAmountType
    claimTxFeerate: number
}

export interface PrepareOnchainPaymentResponse {
    feesHash: string
    feesPercentage: number
    feesLockup: number
    feesClaim: number
    senderAmountSat: number
    recipientAmountSat: number
    totalFees: number
}

export interface PrepareRedeemOnchainFundsRequest {
    toAddress: string
    satPerVbyte: number
}

export interface PrepareRedeemOnchainFundsResponse {
    txWeight: number
    txFeeSat: number
}

export interface PrepareRefundRequest {
    swapAddress: string
    toAddress: string
    satPerVbyte: number
}

export interface PrepareRefundResponse {
    refundTxWeight: number
    refundTxFeeSat: number
}

export interface Rate {
    coin: string
    value: number
}

export interface ReceiveOnchainRequest {
    openingFeeParams?: OpeningFeeParams
}

export interface ReceivePaymentRequest {
    amountMsat: number
    description: string
    preimage?: number[]
    openingFeeParams?: OpeningFeeParams
    useDescriptionHash?: boolean
    expiry?: number
    cltv?: number
}

export interface ReceivePaymentResponse {
    lnInvoice: LnInvoice
    openingFeeParams?: OpeningFeeParams
    openingFeeMsat?: number
}

export interface RecommendedFees {
    fastestFee: number
    halfHourFee: number
    hourFee: number
    economyFee: number
    minimumFee: number
}

export interface RedeemOnchainFundsRequest {
    toAddress: string
    satPerVbyte: number
}

export interface RedeemOnchainFundsResponse {
    txid: number[]
}

export interface RefundRequest {
    swapAddress: string
    toAddress: string
    satPerVbyte: number
}

export interface RefundResponse {
    refundTxId: string
}

export interface ReportPaymentFailureDetails {
    paymentHash: string
    comment?: string
}

export interface ReverseSwapFeesRequest {
    sendAmountSat?: number
    claimTxFeerate?: number
}

export interface ReverseSwapInfo {
    id: string
    claimPubkey: string
    lockupTxid?: string
    claimTxid?: string
    onchainAmountSat: number
    status: ReverseSwapStatus
}

export interface ReverseSwapPairInfo {
    min: number
    max: number
    feesHash: string
    feesPercentage: number
    feesLockup: number
    feesClaim: number
    totalFees?: number
}

export interface RouteHint {
    hops: RouteHintHop[]
}

export interface RouteHintHop {
    srcNodeId: string
    shortChannelId: number
    feesBaseMsat: number
    feesProportionalMillionths: number
    cltvExpiryDelta: number
    htlcMinimumMsat?: number
    htlcMaximumMsat?: number
}

export interface SendOnchainRequest {
    amountSat: number
    onchainRecipientAddress: string
    pairHash: string
    satPerVbyte: number
}

export interface SendOnchainResponse {
    reverseSwapInfo: ReverseSwapInfo
}

export interface SendPaymentRequest {
    bolt11: string
    useTrampoline: boolean
    amountMsat?: number
    label?: string
}

export interface SendPaymentResponse {
    payment: Payment
}

export interface SendSpontaneousPaymentRequest {
    nodeId: string
    amountMsat: number
    extraTlvs?: TlvEntry[]
    label?: string
}

export interface ServiceHealthCheckResponse {
    status: HealthCheckStatus
}

export interface SignMessageRequest {
    message: string
}

export interface SignMessageResponse {
    signature: string
}

export interface StaticBackupRequest {
    workingDir: string
}

export interface StaticBackupResponse {
    backup?: string[]
}

export interface SwapInfo {
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
    paidMsat: number
    unconfirmedSats: number
    confirmedSats: number
    totalIncomingTxs: number
    status: SwapStatus
    refundTxIds: string[]
    unconfirmedTxIds: string[]
    confirmedTxIds: string[]
    minAllowedDeposit: number
    maxAllowedDeposit: number
    maxSwapperPayable: number
    lastRedeemError?: string
    channelOpeningFees?: OpeningFeeParams
    confirmedAt?: number
}

export interface SymbolType {
    grapheme?: string
    template?: string
    rtl?: boolean
    position?: number
}

export interface TlvEntry {
    fieldNumber: number
    value: number[]
}

export interface UnspentTransactionOutput {
    txid: number[]
    outnum: number
    amountMillisatoshi: number
    address: string
    reserved: boolean
}

export interface UrlSuccessActionData {
    description: string
    url: string
    matchesCallbackDomain: boolean
}

export enum AesSuccessActionDataResultVariant {
    DECRYPTED = "decrypted",
    ERROR_STATUS = "errorStatus"
}

export type AesSuccessActionDataResult = {
    type: AesSuccessActionDataResultVariant.DECRYPTED,
    data: AesSuccessActionDataDecrypted
} | {
    type: AesSuccessActionDataResultVariant.ERROR_STATUS,
    reason: string
}

export enum BreezEventVariant {
    NEW_BLOCK = "newBlock",
    INVOICE_PAID = "invoicePaid",
    SYNCED = "synced",
    PAYMENT_SUCCEED = "paymentSucceed",
    PAYMENT_FAILED = "paymentFailed",
    BACKUP_STARTED = "backupStarted",
    BACKUP_SUCCEEDED = "backupSucceeded",
    BACKUP_FAILED = "backupFailed",
    REVERSE_SWAP_UPDATED = "reverseSwapUpdated",
    SWAP_UPDATED = "swapUpdated"
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
} | {
    type: BreezEventVariant.REVERSE_SWAP_UPDATED,
    details: ReverseSwapInfo
} | {
    type: BreezEventVariant.SWAP_UPDATED,
    details: SwapInfo
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

export enum HealthCheckStatus {
    OPERATIONAL = "operational",
    MAINTENANCE = "maintenance",
    SERVICE_DISRUPTION = "serviceDisruption"
}

export enum InputTypeVariant {
    BITCOIN_ADDRESS = "bitcoinAddress",
    BOLT11 = "bolt11",
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
    TIMEOUT = "timeout",
    ERROR_STATUS = "errorStatus"
}

export type LnUrlWithdrawResult = {
    type: LnUrlWithdrawResultVariant.OK,
    data: LnUrlWithdrawSuccessData
} | {
    type: LnUrlWithdrawResultVariant.TIMEOUT,
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

export interface NodeConfig {
    type: NodeConfigVariant.GREENLIGHT,
    config: GreenlightNodeConfig
}

export enum NodeCredentialsVariant {
    GREENLIGHT = "greenlight"
}

export interface NodeCredentials {
    type: NodeCredentialsVariant.GREENLIGHT,
    credentials: GreenlightDeviceCredentials
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

export enum ReportIssueRequestVariant {
    PAYMENT_FAILURE = "paymentFailure"
}

export interface ReportIssueRequest {
    type: ReportIssueRequestVariant.PAYMENT_FAILURE,
    data: ReportPaymentFailureDetails
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
    result: AesSuccessActionDataResult
} | {
    type: SuccessActionProcessedVariant.MESSAGE,
    data: MessageSuccessActionData
} | {
    type: SuccessActionProcessedVariant.URL,
    data: UrlSuccessActionData
}

export enum SwapAmountType {
    SEND = "send",
    RECEIVE = "receive"
}

export enum SwapStatus {
    INITIAL = "initial",
    WAITING_CONFIRMATION = "waitingConfirmation",
    REDEEMABLE = "redeemable",
    REDEEMED = "redeemed",
    REFUNDABLE = "refundable",
    COMPLETED = "completed"
}
export type EventListener = (breezEvent: BreezEvent) => void

export type LogStream = (logEntry: LogEntry) => void

export const connect = async (req: ConnectRequest, listener: EventListener): Promise<EmitterSubscription> => {
    const subscription = BreezSDKEmitter.addListener("breezSdkEvent", listener)

    await BreezSDK.connect(req)

    return subscription
}

export const setLogStream = async (logStream: LogStream): Promise<EmitterSubscription> => {
    const subscription = BreezSDKEmitter.addListener("breezSdkLog", logStream)

    try {
        await BreezSDK.setLogStream()
    } catch {}

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

export const serviceHealthCheck = async (apiKey: string): Promise<ServiceHealthCheckResponse> => {
    const response = await BreezSDK.serviceHealthCheck(apiKey)
    return response
}


export const disconnect = async (): Promise<void> => {
    await BreezSDK.disconnect()
}

export const configureNode = async (req: ConfigureNodeRequest): Promise<void> => {
    await BreezSDK.configureNode(req)
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

export const reportIssue = async (req: ReportIssueRequest): Promise<void> => {
    await BreezSDK.reportIssue(req)
}

export const nodeCredentials = async (): Promise<NodeCredentials | null> => {
    const response = await BreezSDK.nodeCredentials()
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

export const listPayments = async (req: ListPaymentsRequest): Promise<Payment[]> => {
    const response = await BreezSDK.listPayments(req)
    return response
}

export const paymentByHash = async (hash: string): Promise<Payment | null> => {
    const response = await BreezSDK.paymentByHash(hash)
    return response
}

export const setPaymentMetadata = async (hash: string, metadata: string): Promise<void> => {
    await BreezSDK.setPaymentMetadata(hash, metadata)
}

export const redeemOnchainFunds = async (req: RedeemOnchainFundsRequest): Promise<RedeemOnchainFundsResponse> => {
    const response = await BreezSDK.redeemOnchainFunds(req)
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

export const registerWebhook = async (webhookUrl: string): Promise<void> => {
    await BreezSDK.registerWebhook(webhookUrl)
}

export const unregisterWebhook = async (webhookUrl: string): Promise<void> => {
    await BreezSDK.unregisterWebhook(webhookUrl)
}

export const receiveOnchain = async (req: ReceiveOnchainRequest): Promise<SwapInfo> => {
    const response = await BreezSDK.receiveOnchain(req)
    return response
}

export const inProgressSwap = async (): Promise<SwapInfo | null> => {
    const response = await BreezSDK.inProgressSwap()
    return response
}

export const rescanSwaps = async (): Promise<void> => {
    await BreezSDK.rescanSwaps()
}

export const redeemSwap = async (swapAddress: string): Promise<void> => {
    await BreezSDK.redeemSwap(swapAddress)
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

export const onchainPaymentLimits = async (): Promise<OnchainPaymentLimitsResponse> => {
    const response = await BreezSDK.onchainPaymentLimits()
    return response
}

export const prepareOnchainPayment = async (req: PrepareOnchainPaymentRequest): Promise<PrepareOnchainPaymentResponse> => {
    const response = await BreezSDK.prepareOnchainPayment(req)
    return response
}

export const inProgressOnchainPayments = async (): Promise<ReverseSwapInfo[]> => {
    const response = await BreezSDK.inProgressOnchainPayments()
    return response
}

export const inProgressReverseSwaps = async (): Promise<ReverseSwapInfo[]> => {
    const response = await BreezSDK.inProgressReverseSwaps()
    return response
}

export const claimReverseSwap = async (lockupAddress: string): Promise<void> => {
    await BreezSDK.claimReverseSwap(lockupAddress)
}

export const maxReverseSwapAmount = async (): Promise<MaxReverseSwapAmountResponse> => {
    const response = await BreezSDK.maxReverseSwapAmount()
    return response
}

export const sendOnchain = async (req: SendOnchainRequest): Promise<SendOnchainResponse> => {
    const response = await BreezSDK.sendOnchain(req)
    return response
}

export const payOnchain = async (req: PayOnchainRequest): Promise<PayOnchainResponse> => {
    const response = await BreezSDK.payOnchain(req)
    return response
}

export const executeDevCommand = async (command: string): Promise<string> => {
    const response = await BreezSDK.executeDevCommand(command)
    return response
}

export const generateDiagnosticData = async (): Promise<string> => {
    const response = await BreezSDK.generateDiagnosticData()
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

export const prepareRedeemOnchainFunds = async (req: PrepareRedeemOnchainFundsRequest): Promise<PrepareRedeemOnchainFundsResponse> => {
    const response = await BreezSDK.prepareRedeemOnchainFunds(req)
    return response
}
