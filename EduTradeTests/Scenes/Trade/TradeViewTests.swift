//
//  TradeViewTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 01.02.2025.
//

import Foundation
@testable import EduTrade
import Testing
import SwiftUI
import ViewInspector

struct TradeViewTests: BaseViewTest, TestData {
    typealias V = TradeView<TradeViewModelMock>
    let viewModel: TradeViewModelMock

    @MainActor
    init() throws {
        viewModel = TradeViewModelMock()
    }

    @MainActor
    @Test(
        "Test prices",
        arguments: zip(
            [
                (coinBtc, coinMarketBtc, makeDefault(amount: 1000), makeCrypto(coinMarketBtc, amount: 0)),
                (coinEth, coinMarketEth, makeDefault(amount: 876), makeCrypto(coinMarketEth, amount: 11.2)),
                (coinSol, coinMarketSol, makeDefault(amount: 0), makeCrypto(coinMarketSol, amount: 12345))
            ] as [(Coin, CoinMarketsDTO, AccountDTO.CryptoDTO, AccountDTO.CryptoDTO)],
            [
                ("Price: 104 205,00 $", "From USD: 1 000,00", "To BTC: 0,00"),
                ("Price: 3 265,89 $", "From USD: 876,00", "To ETH: 11,20"),
                ("Price: 266,96 $", "From USD: 0,00", "To SOL: 12 345,00")
            ] as [(String, String, String)]
        )
    )
    func prices(
        input: (Coin, CoinMarketsDTO, AccountDTO.CryptoDTO, AccountDTO.CryptoDTO),
        output: (String, String, String)
    ) async throws {
        // Given
        let tradeView = TradeView(viewModel: viewModel, coin: input.0)
        viewModel.tradeOption = .buy
        viewModel.getCoinResult = input.1
        viewModel.walletSourceCoin = input.2
        viewModel.walletDestinationCoin = input.3

        // When
        let view = try await setup(tradeView)

        // Then
        let inspect = try view.inspect()
        let currentPrice = try inspect.find(viewWithAccessibilityIdentifier: "currentPrice").text()
        try #expect(currentPrice.string() == output.0)
        let from = try inspect.find(viewWithAccessibilityIdentifier: "from").text()
        try #expect(from.string() == output.1)
        let to = try inspect.find(viewWithAccessibilityIdentifier: "to").text()
        try #expect(to.string() == output.2)
    }
}
