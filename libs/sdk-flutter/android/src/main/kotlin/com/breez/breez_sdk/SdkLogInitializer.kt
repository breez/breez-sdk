package com.breez.breez_sdk

import breez_sdk.setLogStream
import breez_sdk.LevelFilter
import kotlinx.coroutines.CoroutineScope

object SdkLogInitializer {
    private var nodeLogStream: SdkLogListener? = null

    fun initializeNodeLogStream(filterLevel: LevelFilter?): SdkLogListener {
        if (nodeLogStream == null) {
            try {
                nodeLogStream = SdkLogListener()
                setLogStream(nodeLogStream!!, filterLevel)
            } catch (e: Throwable) {
                // Reset nodeLogStream if setting log stream fails
                e.printStackTrace()
                nodeLogStream = null
                throw e
            }
        }
        return nodeLogStream!!
    }

    fun unsubscribeNodeLogStream(scope: CoroutineScope) {
        nodeLogStream?.unsubscribe(scope)
    }
}