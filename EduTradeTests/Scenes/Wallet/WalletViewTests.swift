//
//  WalletViewTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 29.01.2025.
//

import Foundation
@testable import EduTrade
import Testing
import SwiftUI
import ViewInspector

struct WalletViewTests: BaseViewTest, TestData {
    typealias V = WalletView<WalletViewModelMock>
    let viewModel: WalletViewModelMock
    var walletView: WalletView<WalletViewModelMock>

    @MainActor
    init() throws {
        viewModel = WalletViewModelMock()
        walletView = WalletView(viewModel: viewModel)
    }

    @Test("Test walletView header")
    @MainActor
    mutating func walletViewHeader() async throws {
        // Given
        viewModel.totalValue = 123.7869
        
        // When
        let view = try await setup(walletView)

        // Then
        let inspect = try view.inspect()
        let header = try inspect.find(text: "Total value")
        try #expect(header.string() == "Total value")
        let totalValue = try inspect.find(viewWithAccessibilityIdentifier: "totalValue").text()
        try #expect(totalValue.string() == "123,79 $")
    }

    @Test(
        "Test walletView items",
        arguments: zip(
            [
                [
                    makeWalletCoin(coinMarketBtc, amount: 3.67),
                    makeWalletCoin(coinMarketSol, amount: 1234.89)
                ],
                [
                    makeWalletCoin(coinMarketBnb, amount: 12345),
                    makeWalletCoin(coinMarketEth, amount: 1234.88),
                    makeWalletCoin(coinMarketBtc, amount: 0.0459),
                    makeWalletCoin(coinMarketSol, amount: 11.5)
                ],
                [
                    makeDefaultWalletCoin(amount: 1000),
                    makeWalletCoin(coinMarketBtc, amount: 1),
                    makeWalletCoin(coinMarketSol, amount: 11.5)
                ]
            ] as [[WalletCoin]],
            [
                2,
                4,
                3
            ] as [Int]
        )
    )
    @MainActor
    mutating func walletViewItems(walletCoins: [WalletCoin], count: Int) async throws {
        // Given
        viewModel.walletCoins = walletCoins

        // When
        let view = try await setup(walletView)

        // Then
        let inspect = try view.inspect()
        let list = try inspect.find(viewWithAccessibilityIdentifier: "walletList")
        let items = list.findAll(WalletRowView.self)
        #expect(items.count == count)
        for (index, walletCoin) in walletCoins.enumerated() {
            let string = walletCoin.symbol.uppercased()
            try #expect(items[index].find(text: string).string() == string)
        }
    }
}
