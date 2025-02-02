//
//  WalletRowViewTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 29.01.2025.
//

import Foundation
@testable import EduTrade
import Testing
import ViewInspector
import SwiftUICore

struct WalletRowViewTests: TestData {
    @Test(
        "Test WalletRowView",
        arguments: zip(
            [
                makeWalletCoin(coinMarketBtc, amount: 1.234),
                makeWalletCoin(coinMarketEth, amount: 123.94),
                makeWalletCoin(coinMarketSol, amount: 882.987),
                makeDefaultWalletCoin(amount: 12345.99)
            ] as [WalletCoin],
            [
                (
                    "BTC",
                    makeWalletCoin(coinMarketBtc, amount: 1.234).amount.as6Decimals(),
                    makeWalletCoin(coinMarketBtc, amount: 1.234).value.asCurrencyWith2Decimals()
                ),
                (
                    "ETH",
                    makeWalletCoin(coinMarketEth, amount: 123.94).amount.as6Decimals(),
                    makeWalletCoin(coinMarketEth, amount: 123.94).value.asCurrencyWith2Decimals()
                ),
                (
                    "SOL",
                    makeWalletCoin(coinMarketSol, amount: 882.987).amount.as6Decimals(),
                    makeWalletCoin(coinMarketSol, amount: 882.987).value.asCurrencyWith2Decimals()
                ),
                (
                    "USD",
                    makeDefaultWalletCoin(amount: 12345.99).amount.as2Decimals(),
                    makeDefaultWalletCoin(amount: 12345.99).value.asCurrencyWith2Decimals()
                )
            ] as [(String, String, String)]
        )
    )
    @MainActor
    func walletRowView(walletCoin: WalletCoin, result: (String, String, String)) async throws {
        // When
        let walletRowView = WalletRowView(walletCoin: walletCoin)

        // Then
        let inspect = try walletRowView.inspect()
        let symbol = try inspect.find(text: walletCoin.symbol.uppercased())
        let amount = try inspect.find(viewWithAccessibilityIdentifier: "amount").text()
        let value = try inspect.find(viewWithAccessibilityIdentifier: "value").text()
        try #expect(symbol.string() == result.0)
        try #expect(amount.string() == result.1)
        try #expect(value.string() == result.2)
    }
}
