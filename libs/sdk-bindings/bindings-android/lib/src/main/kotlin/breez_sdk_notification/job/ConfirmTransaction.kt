package breez_sdk_notification.job

import android.content.Context
import breez_sdk.BlockingBreezServices
import breez_sdk.BreezEvent
import breez_sdk.ReverseSwapStatus
import breez_sdk_notification.Constants.DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TEXT
import breez_sdk_notification.Constants.DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TITLE
import breez_sdk_notification.Constants.DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_TITLE
import breez_sdk_notification.Constants.NOTIFICATION_CHANNEL_ADDRESS_TXS_CONFIRMED
import breez_sdk_notification.Constants.SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TEXT
import breez_sdk_notification.Constants.SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TITLE
import breez_sdk_notification.Constants.SWAP_TX_CONFIRMED_NOTIFICATION_TITLE
import breez_sdk_notification.NotificationHelper.Companion.notifyChannel
import breez_sdk_notification.ResourceHelper.Companion.getString
import breez_sdk_notification.SdkForegroundService
import breez_sdk_notification.ServiceLogger
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

@Serializable
data class AddressTxsConfirmedRequest(
    val address: String,
)

class ConfirmTransactionJob(
    private val context: Context,
    private val fgService: SdkForegroundService,
    private val payload: String,
    private val logger: ServiceLogger,
    private var bitcoinAddress: String? = null,
) : Job {
    companion object {
        private const val TAG = "ConfirmTransactionJob"
    }

    override fun start(breezSDK: BlockingBreezServices) {
        try {
            val request = Json.decodeFromString(AddressTxsConfirmedRequest.serializer(), payload)
            this.bitcoinAddress = request.address
        } catch (e: Exception) {
            logger.log(TAG, "Failed to decode payload: ${e.message}", "WARN")
        }

        this.bitcoinAddress?.let {address ->
            try {
                breezSDK.redeemSwap(address)
                logger.log(TAG, "Found swap for $address", "INFO")
                return
            } catch (e: Exception) {
                logger.log(TAG, "Failed to redeem swap: ${e.message}", "WARN")
            }

            try {
                breezSDK.processReverseSwap(address)
                logger.log(TAG, "Found reverse swap for $address", "INFO")
                return
            } catch (e: Exception) {
                logger.log(TAG, "Failed to process reverse swap: ${e.message}", "WARN")
            }
        }

        fgService.onFinished(this)
    }

    override fun onEvent(e: BreezEvent) {
        this.bitcoinAddress?.let {address ->
            when (e) {
                is BreezEvent.ReverseSwapUpdated -> {
                    val revSwapInfo = e.details
                    logger.log(TAG, "Received reverse swap updated event: ${revSwapInfo.id} current address: $address status: ${revSwapInfo.status}", "TRACE")
                    if (revSwapInfo.status == ReverseSwapStatus.COMPLETED_SEEN || revSwapInfo.status == ReverseSwapStatus.COMPLETED_CONFIRMED) {
                        notifySuccess(address)
                    }
                }

                is BreezEvent.SwapUpdated -> {
                    val swapInfo = e.details
                    logger.log(TAG, "Received swap updated event: ${swapInfo.bitcoinAddress} current address: $address status: ${swapInfo.status}", "TRACE")
                    if (swapInfo.bitcoinAddress == address) {
                        if (swapInfo.paidMsat.toLong() > 0) {
                            notifySuccess(address)
                        }
                    }
                }

                else -> {}
            }
        }
    }

    override fun onShutdown() {
        notifyFailure()
    }

    private fun notifySuccess(address: String) {
        logger.log(TAG, "Address $address processed successfully", "INFO")
        notifyChannel(
            context,
            NOTIFICATION_CHANNEL_ADDRESS_TXS_CONFIRMED,
            getString(
                context,
                SWAP_TX_CONFIRMED_NOTIFICATION_TITLE,
                DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_TITLE
            ),
        )
        fgService.onFinished(this)
    }

    private fun notifyFailure() {
        this.bitcoinAddress?.let{address -> 
            logger.log(TAG, "Address $address processing failed", "INFO")
            notifyChannel(
                context,
                NOTIFICATION_CHANNEL_ADDRESS_TXS_CONFIRMED,
                getString(
                    context,
                    SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TITLE,
                    DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TITLE
                ),
                getString(
                    context,
                    SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TEXT,
                    DEFAULT_SWAP_TX_CONFIRMED_NOTIFICATION_FAILURE_TEXT
                ),
            )
        }
    }
}
