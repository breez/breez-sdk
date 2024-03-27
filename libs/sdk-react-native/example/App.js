/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { useState } from "react"
import { SafeAreaView, ScrollView, StatusBar, Text, TouchableOpacity, View } from "react-native"
import {
    backup,
    backupStatus,
    buyBitcoin,
    BuyBitcoinProvider,
    checkMessage,
    connect,
    defaultConfig,
    EnvironmentType,
    fetchFiatRates,
    fetchReverseSwapFees,
    inProgressReverseSwaps,
    lspInfo,
    listFiatCurrencies,
    mnemonicToSeed,
    NodeConfigVariant,
    nodeInfo,
    openChannelFee,
    receivePayment,
    setLogStream,
    signMessage
} from "@breeztech/react-native-breez-sdk"
import BuildConfig from "react-native-build-config"
import { generateMnemonic } from "@dreson4/react-native-quick-bip39"
import { obfuscateString } from "./utils/security"
import { getSecureItem, setSecureItem } from "./utils/storage"

const MNEMONIC_STORE = "MNEMONIC_SECURE_STORE"

const DebugLine = ({ title, text }) => {
    return (
        <TouchableOpacity style={{ flex: 1 }}>
            <View style={{ margin: 5 }}>
                <Text style={{ fontWeight: "bold" }}>{title}</Text>
                {text && text.length > 0 ? <Text>{text}</Text> : <></>}
            </View>
        </TouchableOpacity>
    )
}

const App = () => {
    const [lines, setLines] = useState([])

    const addLine = (title, text) => {
        setLines((lines) => [{ at: new Date().getTime(), title, text }, ...lines])
        console.log(`${title}${text && text.length > 0 ? ": " + text : ""}`)
    }

    const logHandler = (logEntry) => {
        if (logEntry.level != "TRACE") {
            console.log(`[${logEntry.level}]: ${logEntry.line}`)
        }
    }

    const eventHandler = (breezEvent) => {
        addLine("event", JSON.stringify(breezEvent))
    }

    React.useEffect(() => {
        let logSubscription, eventSubscription

        const asyncFn = async () => {
            try {
                logSubscription = await setLogStream(logHandler, null)

                let mnemonic = await getSecureItem(MNEMONIC_STORE)

                if (mnemonic == null) {
                    mnemonic = generateMnemonic(256)
                    setSecureItem(MNEMONIC_STORE, mnemonic)
                }

                let seed = await mnemonicToSeed(mnemonic)
                addLine("mnemonicToSeed", obfuscateString(JSON.stringify(seed)))

                const nodeConfig = {
                    type: NodeConfigVariant.GREENLIGHT,
                    config: {}
                }

                const config = await defaultConfig(EnvironmentType.PRODUCTION, BuildConfig.BREEZ_API_KEY, nodeConfig)
                addLine("defaultConfig", JSON.stringify(config))

                eventSubscription = await connect({ config, seed }, eventHandler)
                addLine("connect", null)

                const nodeState = await nodeInfo()
                addLine("nodeInfo", JSON.stringify(nodeState))

                const lsp = await lspInfo()
                addLine("lspInfo", JSON.stringify(lsp))

                const fiatCurrencies = await listFiatCurrencies()
                addLine("listFiatCurrencies", JSON.stringify(fiatCurrencies))

                const fiatRates = await fetchFiatRates()
                addLine("fetchFiatRates", JSON.stringify(fiatRates))

                const revSwapFees = await fetchReverseSwapFees({ sendAmountSat: null })
                addLine("revSwapFees", JSON.stringify(revSwapFees))

                const inProgressRevSwaps = await inProgressReverseSwaps()
                addLine("inProgressRevSwaps", JSON.stringify(inProgressRevSwaps))

                const buyBitcoinResult = await buyBitcoin({
                    provider: BuyBitcoinProvider.MOONPAY,
                    openingFeeParams: null
                })
                addLine("buyBitcoin", JSON.stringify(buyBitcoinResult))

                const signMessageResult = await signMessage({ message: "Hello world" })
                addLine("signMessage: Hello World", JSON.stringify(signMessageResult))

                const verifyMessageResult = await checkMessage({
                    message: "Hello world",
                    pubkey: nodeState.id,
                    signature: signMessageResult.signature
                })
                addLine("verifyMessage:", JSON.stringify(verifyMessageResult))

                const openChannelFeeResult = await openChannelFee({
                    amountMsat: 100000000,
                    expiry: 3600
                })
                addLine("openChannelFee", JSON.stringify(openChannelFeeResult))

                const receivePaymentResult = await receivePayment({
                    amountMsat: 100000000,
                    description: "Hello world",
                    expiry: 3600,
                    cltv: 144,
                    useDescriptionHash: true,
                    openingFeeParams: openChannelFeeResult.usedFeeParams
                })
                addLine("receivePayment", JSON.stringify(receivePaymentResult))

                await backup()
                addLine("backupStatus", JSON.stringify(await backupStatus()))
            } catch (e) {
                addLine("error", e.toString())
                console.log(`Error: ${JSON.stringify(e)}`)
            }
        }

        asyncFn()

        return () => {
            logSubscription.remove()
            eventSubscription.remove()
        }
    }, [])

    return (
        <SafeAreaView>
            <StatusBar />
            <ScrollView style={{ padding: 5 }}>
                {lines.map((line) => (
                    <DebugLine key={line.at} title={line.title} text={line.text} />
                ))}
            </ScrollView>
        </SafeAreaView>
    )
}

export default App
