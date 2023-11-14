package com.breezsdk

import breez_sdk.*
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import java.io.File
import java.util.*
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class BreezSDKModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    private lateinit var executor: ExecutorService
    private var breezServices: BlockingBreezServices? = null

    companion object {
        const val TAG = "RNBreezSDK"
    }

    override fun initialize() {
        super.initialize()

        executor = Executors.newFixedThreadPool(3)
    }

    override fun getName(): String {
        return TAG
    }

    @Throws(SdkException::class)
    fun getBreezServices(): BlockingBreezServices {
        if (breezServices != null) {
            return breezServices!!
        }

        throw SdkException.Generic("BreezServices not initialized")
    }

    @Throws(SdkException::class)
    private fun ensureWorkingDir(workingDir: String) {
        try {
            val workingDirFile = File(workingDir)

            if (!workingDirFile.exists() && !workingDirFile.mkdirs()) {
                throw SdkException.Generic("Mandatory field workingDir must contain a writable directory")
            }
        } catch (e: SecurityException) {
            throw SdkException.Generic("Mandatory field workingDir must contain a writable directory")
        }
    }

    @ReactMethod
    fun addListener(eventName: String) {}

    @ReactMethod
    fun removeListeners(count: Int) {}

    @ReactMethod
    fun parseInvoice(
        invoice: String,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val res = parseInvoice(invoice)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun parseInput(
        s: String,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val res = parseInput(s)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun mnemonicToSeed(
        phrase: String,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val res = mnemonicToSeed(phrase)
                promise.resolve(readableArrayOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun defaultConfig(
        envType: String,
        apiKey: String,
        nodeConfig: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val envTypeTmp = asEnvironmentType(envType)
                val nodeConfigTmp = asNodeConfig(nodeConfig) ?: run { throw SdkException.Generic("Missing mandatory field nodeConfig of type NodeConfig") }
                val res = defaultConfig(envTypeTmp, apiKey, nodeConfigTmp)
                val workingDir = File(reactApplicationContext.filesDir.toString() + "/breezSdk")

                res.workingDir = workingDir.absolutePath
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun staticBackup(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val staticBackupRequest =
                    asStaticBackupRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type StaticBackupRequest")
                    }
                val res = staticBackup(staticBackupRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun setLogStream(promise: Promise) {
        try {
            val emitter = reactApplicationContext.getJSModule(RCTDeviceEventEmitter::class.java)

            setLogStream(BreezSDKLogStream(emitter))
            promise.resolve(readableMapOf("status" to "ok"))
        } catch (e: Exception) {
            e.printStackTrace()
            promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
        }
    }

    @ReactMethod
    fun connect(
        config: ReadableMap,
        seed: ReadableArray,
        promise: Promise,
    ) {
        if (breezServices != null) {
            promise.reject("Generic", "BreezServices already initialized")
            return
        }

        try {
            val configTmp = asConfig(config) ?: run { throw SdkException.Generic("Missing mandatory field config of type Config") }
            val emitter = reactApplicationContext.getJSModule(RCTDeviceEventEmitter::class.java)

            ensureWorkingDir(configTmp.workingDir)

            breezServices = connect(configTmp, asUByteList(seed), BreezSDKListener(emitter))
            promise.resolve(readableMapOf("status" to "ok"))
        } catch (e: Exception) {
            e.printStackTrace()
            promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
        }
    }

    @ReactMethod
    fun disconnect(promise: Promise) {
        executor.execute {
            try {
                getBreezServices().disconnect()
                breezServices = null
                promise.resolve(readableMapOf("status" to "ok"))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun sendPayment(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val sendPaymentRequest =
                    asSendPaymentRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type SendPaymentRequest")
                    }
                val res = getBreezServices().sendPayment(sendPaymentRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun sendSpontaneousPayment(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val sendSpontaneousPaymentRequest =
                    asSendSpontaneousPaymentRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type SendSpontaneousPaymentRequest")
                    }
                val res = getBreezServices().sendSpontaneousPayment(sendSpontaneousPaymentRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun receivePayment(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val receivePaymentRequest =
                    asReceivePaymentRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type ReceivePaymentRequest")
                    }
                val res = getBreezServices().receivePayment(receivePaymentRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun payLnurl(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val lnUrlPayRequest = asLnUrlPayRequest(req) ?: run { throw SdkException.Generic("Missing mandatory field req of type LnUrlPayRequest") }
                val res = getBreezServices().payLnurl(lnUrlPayRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun withdrawLnurl(
        request: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val lnUrlWithdrawRequest =
                    asLnUrlWithdrawRequest(request) ?: run {
                        throw SdkException.Generic("Missing mandatory field request of type LnUrlWithdrawRequest")
                    }
                val res = getBreezServices().withdrawLnurl(lnUrlWithdrawRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun lnurlAuth(
        reqData: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val lnUrlAuthRequestData =
                    asLnUrlAuthRequestData(reqData) ?: run {
                        throw SdkException.Generic("Missing mandatory field reqData of type LnUrlAuthRequestData")
                    }
                val res = getBreezServices().lnurlAuth(lnUrlAuthRequestData)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun nodeInfo(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().nodeInfo()
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun signMessage(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val signMessageRequest =
                    asSignMessageRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type SignMessageRequest")
                    }
                val res = getBreezServices().signMessage(signMessageRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun checkMessage(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val checkMessageRequest =
                    asCheckMessageRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type CheckMessageRequest")
                    }
                val res = getBreezServices().checkMessage(checkMessageRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun backupStatus(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().backupStatus()
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun backup(promise: Promise) {
        executor.execute {
            try {
                getBreezServices().backup()
                promise.resolve(readableMapOf("status" to "ok"))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun paymentByHash(
        hash: String,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val res = getBreezServices().paymentByHash(hash)
                promise.resolve(res?.let { readableMapOf(res) })
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun listPayments(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val listPaymentsRequest =
                    asListPaymentsRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type ListPaymentsRequest")
                    }
                val res = getBreezServices().listPayments(listPaymentsRequest)
                promise.resolve(readableArrayOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun sweep(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val sweepRequest = asSweepRequest(req) ?: run { throw SdkException.Generic("Missing mandatory field req of type SweepRequest") }
                val res = getBreezServices().sweep(sweepRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun fetchFiatRates(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().fetchFiatRates()
                promise.resolve(readableArrayOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun listFiatCurrencies(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().listFiatCurrencies()
                promise.resolve(readableArrayOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun listLsps(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().listLsps()
                promise.resolve(readableArrayOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun connectLsp(
        lspId: String,
        promise: Promise,
    ) {
        executor.execute {
            try {
                getBreezServices().connectLsp(lspId)
                promise.resolve(readableMapOf("status" to "ok"))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun fetchLspInfo(
        lspId: String,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val res = getBreezServices().fetchLspInfo(lspId)
                promise.resolve(res?.let { readableMapOf(res) })
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun openChannelFee(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val openChannelFeeRequest =
                    asOpenChannelFeeRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type OpenChannelFeeRequest")
                    }
                val res = getBreezServices().openChannelFee(openChannelFeeRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun lspId(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().lspId()
                promise.resolve(res?.let { res })
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun lspInfo(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().lspInfo()
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun closeLspChannels(promise: Promise) {
        executor.execute {
            try {
                getBreezServices().closeLspChannels()
                promise.resolve(readableMapOf("status" to "ok"))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun receiveOnchain(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val receiveOnchainRequest =
                    asReceiveOnchainRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type ReceiveOnchainRequest")
                    }
                val res = getBreezServices().receiveOnchain(receiveOnchainRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun inProgressSwap(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().inProgressSwap()
                promise.resolve(res?.let { readableMapOf(res) })
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun listRefundables(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().listRefundables()
                promise.resolve(readableArrayOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun prepareRefund(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val prepareRefundRequest =
                    asPrepareRefundRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type PrepareRefundRequest")
                    }
                val res = getBreezServices().prepareRefund(prepareRefundRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun refund(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val refundRequest = asRefundRequest(req) ?: run { throw SdkException.Generic("Missing mandatory field req of type RefundRequest") }
                val res = getBreezServices().refund(refundRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun fetchReverseSwapFees(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val reverseSwapFeesRequest =
                    asReverseSwapFeesRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type ReverseSwapFeesRequest")
                    }
                val res = getBreezServices().fetchReverseSwapFees(reverseSwapFeesRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun inProgressReverseSwaps(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().inProgressReverseSwaps()
                promise.resolve(readableArrayOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun sendOnchain(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val sendOnchainRequest =
                    asSendOnchainRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type SendOnchainRequest")
                    }
                val res = getBreezServices().sendOnchain(sendOnchainRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun executeDevCommand(
        command: String,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val res = getBreezServices().executeDevCommand(command)
                promise.resolve(res)
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun sync(promise: Promise) {
        executor.execute {
            try {
                getBreezServices().sync()
                promise.resolve(readableMapOf("status" to "ok"))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun recommendedFees(promise: Promise) {
        executor.execute {
            try {
                val res = getBreezServices().recommendedFees()
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun buyBitcoin(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val buyBitcoinRequest =
                    asBuyBitcoinRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type BuyBitcoinRequest")
                    }
                val res = getBreezServices().buyBitcoin(buyBitcoinRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }

    @ReactMethod
    fun prepareSweep(
        req: ReadableMap,
        promise: Promise,
    ) {
        executor.execute {
            try {
                val prepareSweepRequest =
                    asPrepareSweepRequest(req) ?: run {
                        throw SdkException.Generic("Missing mandatory field req of type PrepareSweepRequest")
                    }
                val res = getBreezServices().prepareSweep(prepareSweepRequest)
                promise.resolve(readableMapOf(res))
            } catch (e: Exception) {
                promise.reject(e.javaClass.simpleName.replace("Exception", "Error"), e.message, e)
            }
        }
    }
}
