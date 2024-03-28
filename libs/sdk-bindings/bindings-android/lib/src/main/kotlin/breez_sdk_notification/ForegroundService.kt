package breez_sdk_notification

import android.app.Service
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import breez_sdk.BlockingBreezServices
import breez_sdk.ConnectRequest
import breez_sdk.LogStream
import breez_sdk_notification.BreezSdkConnector.Companion.connectSDK
import breez_sdk_notification.Constants.MESSAGE_TYPE_ADDRESS_TXS_CONFIRMED
import breez_sdk_notification.Constants.MESSAGE_TYPE_LNURL_PAY_INFO
import breez_sdk_notification.Constants.MESSAGE_TYPE_LNURL_PAY_INVOICE
import breez_sdk_notification.Constants.MESSAGE_TYPE_PAYMENT_RECEIVED
import breez_sdk_notification.Constants.NOTIFICATION_ID_FOREGROUND_SERVICE
import breez_sdk_notification.Constants.SHUTDOWN_DELAY_MS
import breez_sdk_notification.NotificationHelper.Companion.notifyForegroundService
import breez_sdk_notification.job.Job
import breez_sdk_notification.job.LnurlPayInfoJob
import breez_sdk_notification.job.LnurlPayInvoiceJob
import breez_sdk_notification.job.ReceivePaymentJob
import breez_sdk_notification.job.RedeemSwapJob
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

abstract class ForegroundService : SdkForegroundService, Service() {
    private var breezSDK: BlockingBreezServices? = null
    @Suppress("MemberVisibilityCanBePrivate")
    val serviceScope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())
    protected var logger: ServiceLogger = ServiceLogger()
    private var config: ServiceConfig = ServiceConfig.default()

    companion object {
        private const val TAG = "ForegroundService"
    }

    // =========================================================== //
    //                      SERVICE LIFECYCLE                      //
    // =========================================================== //

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    /** Stop the service */
    private val shutdownHandler = Handler(Looper.getMainLooper())
    private val shutdownRunnable: Runnable = Runnable {
        logger.log(TAG, "Reached scheduled shutdown...", "DEBUG")
        shutdown()
    }

    override fun pushbackShutdown() {
        shutdownHandler.removeCallbacksAndMessages(null)
        shutdownHandler.postDelayed(shutdownRunnable, SHUTDOWN_DELAY_MS)
    }

    override fun shutdown() {
        logger.log(TAG, "Shutting down foreground service", "DEBUG")
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    // =========================================================== //
    //                    START COMMAND HANDLER                    //
    // =========================================================== //

    /** Called when an intent is called for this service. */
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        val intentDetails = "[ intent=$intent, flag=$flags, startId=$startId ]"
        logger.log(TAG, "Start foreground service from intent $intentDetails", "DEBUG")

        // Display foreground service notification
        val notification = notifyForegroundService(applicationContext)
        startForeground(NOTIFICATION_ID_FOREGROUND_SERVICE, notification)

        // Set service configuration
        getServiceConfig()?.let { serviceConfig ->
            setConfig(serviceConfig)
        }

        // Connect to SDK if source intent has data message with valid payload
        getConnectRequest()?.let { connectRequest ->
            getJobFromIntent(intent)?.also { job ->
                launchSdkConnection(connectRequest, job)
            } ?: run {
                logger.log(TAG, "Received invalid data message", "WARN")
                shutdown()
            }
        } ?: run {
            logger.log(TAG, "Missing ConnectRequest", "WARN")
            shutdown()
        }

        return START_NOT_STICKY
    }

    /** To be implemented by the application foreground service.
     *  It should retrieve the Breez API key and node mnemonic then construct
     *  a ConnectRequest to be used to call the Breez SDK connect function. */
    abstract fun getConnectRequest(): ConnectRequest?

    /** To be implemented by the application foreground service.
     * Allows the user to override the default ServiceConfig. */
    abstract fun getServiceConfig(): ServiceConfig?

    /** Get the job to be executed from the Message data in the Intent.
     *  This can be overridden to handle custom jobs. */
    open fun getJobFromIntent(intent: Intent?): Job? {
        return Message.createFromIntent(intent)?.let { message ->
            message.payload?.let { payload ->
                when (message.type) {
                    MESSAGE_TYPE_ADDRESS_TXS_CONFIRMED -> RedeemSwapJob(
                        applicationContext,
                        this,
                        payload,
                        logger
                    )

                    MESSAGE_TYPE_LNURL_PAY_INFO -> LnurlPayInfoJob(
                        applicationContext,
                        this,
                        payload,
                        logger,
                        config
                    )

                    MESSAGE_TYPE_LNURL_PAY_INVOICE -> LnurlPayInvoiceJob(
                        applicationContext,
                        this,
                        payload,
                        logger,
                        config
                    )

                    MESSAGE_TYPE_PAYMENT_RECEIVED -> ReceivePaymentJob(
                        applicationContext,
                        this,
                        logger
                    )

                    else -> null
                }
            }
        }
    }

    private fun launchSdkConnection(connectRequest: ConnectRequest, job: Job) {
        serviceScope.launch(Dispatchers.IO + CoroutineExceptionHandler { _, e ->
            logger.log(TAG, "Breez SDK connection failed $e", "ERROR")
            shutdown()
        }) {
            breezSDK ?: run {
                breezSDK = connectSDK(connectRequest, job, logger)
            }

            breezSDK?.let {
                job.start(breezSDK!!)

                // Push back shutdown by SHUTDOWN_DELAY_MS
                pushbackShutdown()
            }
        }
    }

    @Suppress("unused")
    fun setLogger(logger: LogStream) {
        this.logger = ServiceLogger(logger)
    }

    private fun setConfig(config: ServiceConfig) {
        this.config = config
    }
}
