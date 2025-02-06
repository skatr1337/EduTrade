//
//  MarketsViewTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 26.01.2025.
//

import Foundation
@testable import EduTrade
import Testing
import ViewInspector
import SwiftUICore

struct MarketsViewTests: BaseViewTest, TestData {
    typealias V = MarketsView<MarketsViewModelMock>
    let viewModel: MarketsViewModelMock
    let marketsView: MarketsView<MarketsViewModelMock>

    @MainActor
    init() throws {
        viewModel = MarketsViewModelMock()
        marketsView = MarketsView(viewModel: viewModel)
    }

    @Test("Test walletView header")
    @MainActor
    mutating func marketsViewHeader() async throws {
        // When
        let view = marketsView.environmentObject(coordinator)

        // Then
        let inspect = try view.inspect()
        let header = try inspect.find(text: "Live prices")
        try #expect(header.string() == "Live prices")
        try #expect(header.attributes().font() == Font.headline)
    }

    @Test(
        "Test MarketsView items",
        arguments: zip(
            [
                [coinBtc, coinEth, coinXrp],
                [coinBtc, coinEth]
            ] as [[Coin]],
            [
                3,
                2
            ]
            as [Int]
        )
    )
    @MainActor
    mutating func marketsViewItems(coins: [Coin], count: Int) async throws {
        // Given
        viewModel.coins = coins
        
        // When
        let view = marketsView.environmentObject(coordinator)

        // Then
        let inspect = try view.inspect()
        let list = try inspect.find(viewWithAccessibilityIdentifier: "coinsList")
        let items = list.findAll(CoinRowView.self)
        #expect(items.count == count)
        for (index, coin) in coins.enumerated() {
            let string = coin.symbol.uppercased()
            try #expect(items[index].find(text: string).string() == string)
        }
    }
}
