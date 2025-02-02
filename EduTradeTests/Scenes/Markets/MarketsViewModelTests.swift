//
//  MarketsViewModelTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 19.01.2025.
//

import Foundation
@testable import EduTrade
import Testing

struct MarketsViewModelTests: TestData {
    let viewModel: MarketsViewModel
    let cryptoServiceMock: CryptoServiceMock
    let walletServiceMock: WalletServiceMock
    static let encoder = JSONEncoder()

    init() {
        cryptoServiceMock = CryptoServiceMock()
        walletServiceMock = WalletServiceMock()
        self.viewModel = MarketsViewModel(
            cryptoService: cryptoServiceMock,
            walletService: walletServiceMock
        )
        Self.encoder.dateEncodingStrategy = .iso8601
    }

    @Test(
        "Test refresh",
        arguments: zip(
            [
                [coinMarketBtc],
                [coinMarketBtc, coinMarketEth],
                [coinMarketBtc, coinMarketEth, coinMarketSol, coinMarketBnb]
            ] as [[CoinMarketsDTO]],
            [
                makeCoins(coinMarkets: [coinMarketBtc]),
                makeCoins(coinMarkets: [coinMarketBtc, coinMarketEth]),
                makeCoins(coinMarkets: [coinMarketBtc, coinMarketEth, coinMarketSol, coinMarketBnb])
            ] as [[Coin]]
        )
    )
    func refresh(coins: [CoinMarketsDTO], result: [Coin]) async throws {
        // Given
        cryptoServiceMock.coins = coins

        // When
        try await viewModel.refresh()

        // Then
        await #expect(viewModel.coins == result)
        #expect(cryptoServiceMock.calledMethods.contains("fetchList()"))
    }

    private static func makeCoins(coinMarkets: [CoinMarketsDTO]) -> [Coin] {
        coinMarkets.compactMap { makeCoin(coinMarket: $0) }
    }

    private static func makeCoin(coinMarket: CoinMarketsDTO) -> Coin? {
        guard let image = URL(string: coinMarket.image) else { return nil }
        return Coin(
            id: coinMarket.id,
            rank: coinMarket.market_cap_rank,
            symbol: coinMarket.symbol,
            image: image,
            currentPrice: coinMarket.current_price,
            priceChangePercentage: coinMarket.price_change_percentage_24h,
            isPriceChangePosive: coinMarket.price_change_percentage_24h >= 0
        )
    }
}
