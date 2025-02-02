//
//  TradeViewModelTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 31.01.2025.
//

import Foundation
@testable import EduTrade
import SwiftUI
import Testing

struct TradeViewModelTests: TestData {
    let cryptoServiceMock: CryptoServiceMock
    let walletServiceMock: WalletServiceMock
    let tradeViewModel: TradeViewModel

    init() {
        cryptoServiceMock = CryptoServiceMock()
        walletServiceMock = WalletServiceMock()
        tradeViewModel = TradeViewModel(
            cryptoService: cryptoServiceMock,
            walletService: walletServiceMock
        )
    }

    @Test("Test percentageButtons")
    @MainActor
    func percentageButtons() {
        #expect(tradeViewModel.percentageButtons == [0.25, 0.5, 0.75, 1.0])
    }

    @Test(
        "Test percentage",
        arguments: zip(
            [
                (1000, 0.75),
                (0.2345, 0.9)
            ] as [(Double, Double)],
            [
                750,
                0.21105
            ] as [Double]
        )
    )
    @MainActor
    func percentage(input: (Double, Double), currentValue: Double) {
        // Given
        tradeViewModel.maxValue = input.0

        // When
        tradeViewModel.percentage(input.1)

        // Then
        #expect(tradeViewModel.currentValue == currentValue)
    }

    @Test(
        "Test currentValueSlider",
        arguments: zip(
            [
                1,
                345,
                12345,
                123456
            ] as [Double],
            [
                1,
                345,
                12345,
                123456
            ] as [Double]
        )
    )
    @MainActor
    func currentValueSlider(input: Double, output: Double) {
        // Given
        tradeViewModel.currentValueSlider = input

        // Then
        #expect(tradeViewModel.currentValueSlider == output)
    }

    @Test(
        "Test getCoin",
        arguments: zip(
            [
                // coin, trade option, wallet default coin, wallet coin to buy
                (coinMarketBtc, .buy, makeDefault(amount: 1000), makeCrypto(coinMarketBtc, amount: 0)),
                (coinMarketBtc, .buy, makeDefault(amount: 1000), nil),
                (coinMarketBtc, .buy, nil, nil),
                (coinMarketBtc, .sell, makeDefault(amount: 0), makeCrypto(coinMarketBtc, amount: 1.23)),
                (coinMarketBtc, .sell, nil, makeCrypto(coinMarketBtc, amount: 1.23)),
                (coinMarketBtc, .sell, nil, nil)
            ] as [(CoinMarketsDTO, TradeViewModel.TradeOption, AccountDTO.CryptoDTO?, AccountDTO.CryptoDTO?)],
            [
                // exchangeCoin, maxValue, currentValue, source coin, destination coin
                (coinMarketBtc, 1000, 0, makeDefault(amount: 1000), makeCrypto(coinMarketBtc, amount: 0)),
                (coinMarketBtc, 1000, 0, makeDefault(amount: 1000), makeCrypto(coinMarketBtc, amount: 0)),
                (coinMarketBtc, 0, 0, makeDefault(amount: 0), makeCrypto(coinMarketBtc, amount: 0)),
                (coinMarketBtc, 1.23, 0, makeCrypto(coinMarketBtc, amount: 1.23), makeDefault(amount: 0)),
                (coinMarketBtc, 1.23, 0, makeCrypto(coinMarketBtc, amount: 1.23), makeDefault(amount: 0)),
                (coinMarketBtc, 0, 0, makeCrypto(coinMarketBtc, amount: 0), makeDefault(amount: 0))
            ] as [(CoinMarketsDTO, Double, Double, AccountDTO.CryptoDTO, AccountDTO.CryptoDTO)]
        )
    )
    @MainActor
    func getCoin(
        input: (CoinMarketsDTO, TradeViewModel.TradeOption, AccountDTO.CryptoDTO?, AccountDTO.CryptoDTO?),
        output: (CoinMarketsDTO, Double, Double, AccountDTO.CryptoDTO, AccountDTO.CryptoDTO)
    ) async throws {
        // Given
        cryptoServiceMock.coin = input.0
        tradeViewModel.tradeOption = input.1
        if let defaultCoin = input.2 {
            walletServiceMock.defaultCrypto = defaultCoin
        }
        walletServiceMock.crypto = input.3
        
        // When
        try await tradeViewModel.getCoin(id: input.0.id)

        // Then
        #expect(tradeViewModel.exchangeCoin == output.0)
        #expect(tradeViewModel.maxValue == output.1)
        #expect(tradeViewModel.currentValue == output.2)
        #expect(tradeViewModel.walletSourceCoin == output.3)
        #expect(tradeViewModel.walletDestinationCoin == output.4)
        #expect(cryptoServiceMock.calledMethods.contains("fetchCoin(id:)"))
        if input.2 != nil {
            #expect(walletServiceMock.calledMethods.contains("getDefaultCoin()"))
        }
        #expect(walletServiceMock.calledMethods.contains("getCoin(id:)"))
    }

    @Test(
        "Test buy",
        arguments: zip(
            [
                // coin, trade option, wallet source coin, wallet destination coin, value
                (
                    coinMarketBtc,
                    .buy, makeDefault(amount: 1000),
                    makeCrypto(coinMarketBtc, amount: 0),
                    400
                ),
                (
                    coinMarketBtc,
                    .sell,
                    makeDefault(amount: 0),
                    makeCrypto(coinMarketBtc, amount: 0.00383858739983686),
                    0.00383858739983686
                ),
            ] as [(CoinMarketsDTO, TradeViewModel.TradeOption, AccountDTO.CryptoDTO, AccountDTO.CryptoDTO, Double)],
            [
                // default amount, crypto amount
                (600, 0.00383858739983686),
                (400, 0)
            ] as [(Double, Double)]
        )
    )
    @MainActor
    func buy(
        input: (CoinMarketsDTO, TradeViewModel.TradeOption, AccountDTO.CryptoDTO, AccountDTO.CryptoDTO, Double),
        output: (Double, Double)
    ) async throws {
        // Given
        cryptoServiceMock.coin = input.0
        tradeViewModel.tradeOption = input.1
        walletServiceMock.defaultCrypto = input.2
        walletServiceMock.crypto = input.3
        try await tradeViewModel.getCoin(id: input.0.id)
        tradeViewModel.currentValue = input.4

        // When
        try await tradeViewModel.buy(id: input.0.id)

        // Then
        #expect(walletServiceMock.defaultCrypto.amount == output.0)
        #expect(walletServiceMock.crypto?.amount == output.1)
        #expect(cryptoServiceMock.calledMethods.contains("fetchCoin(id:)"))
        #expect(walletServiceMock.calledMethods.contains("getDefaultCoin()"))
        #expect(walletServiceMock.calledMethods.contains("getCoin(id:)"))
        #expect(walletServiceMock.calledMethods.contains("makeExchange(operation:)"))
    }
    
    @Test(
        "Test tradeOption",
        arguments: zip(
            [
                (TradeViewModel.TradeOption.buy, "BTC"),
                (TradeViewModel.TradeOption.sell, "BTC")
            ] as [(TradeViewModel.TradeOption, String)],
            [
                ("Buy BTC", "Buy", .green),
                ("Sell BTC", "Sell", .red)
            ] as [(String, String, Color)]
        )
    )
    @MainActor
    func tradeOption(
        tradeOption: (TradeViewModel.TradeOption, String),
        output: (String, String, Color)
    ) {
        // Then
        #expect(tradeOption.0.description(symbol: tradeOption.1) == output.0)
        #expect(tradeOption.0.description == output.1)
        #expect(tradeOption.0.color == output.2)
        #expect(tradeOption.0.id == tradeOption.0)
    }
}
