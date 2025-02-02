//
//  CoinRowViewTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 27.01.2025.
//

import Foundation
@testable import EduTrade
import Testing
import ViewInspector
import SwiftUICore

struct CoinRowViewTests: TestData {
    @Test(
        "Test CoinRowView",
        arguments: zip(
            [
                coinBtc,
                coinEth,
                coinXrp
            ] as [Coin],
            [
                (1, "BTC", "104 976,00 $"),
                (2, "ETH", "3 327,34 $"),
                (3, "XRP", "3,11 $")
            ] as [(Int, String, String)]
        )
    )
    @MainActor
    func coinRowView(coin: Coin, result: (Int, String, String)) async throws {
        // When
        let coinRowView = CoinRowView(coin: coin)

        // Then
        let inspect = try coinRowView.inspect()
        let symbol = try inspect.find(text: coin.symbol.uppercased())
        let currentPrice = try inspect.find(text: coin.currentPrice.asCurrencyWith6Decimals())
        let rank = try inspect.find(viewWithAccessibilityIdentifier: "rank").text()
        try #expect(rank.string() == String(result.0))
        try #expect(symbol.string() == result.1)
        try #expect(currentPrice.string() == result.2)
    }
}
