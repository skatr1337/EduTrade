//
//  MarketsViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import Foundation

struct Coin: Identifiable, Equatable {
    let id: String
    let rank: Int
    let symbol: String
    let image: URL
    let currentPrice: Double
    let priceChangePercentage: Double
    let isPriceChangePosive: Bool
}

protocol MarketsViewModelProtocol: ObservableObject {
    var coins: [Coin] { get }
    func refresh() async throws
}

class MarketsViewModel: MarketsViewModelProtocol {
    let cryptoService: CryptoServiceProtocol
    let walletService: WalletServiceProtocol

    init(
        cryptoService: CryptoServiceProtocol,
        walletService: WalletServiceProtocol
    ) {
        self.cryptoService = cryptoService
        self.walletService = walletService
    }
    
    @MainActor @Published
    var coins: [Coin] = []

    @MainActor
    func refresh() async throws {
        let receivedCoins = try await cryptoService.fetchList()
        coins = makeCoins(coinMarkets: receivedCoins)
    }

    private func makeCoins(coinMarkets: [CoinMarketsDTO]) -> [Coin] {
        coinMarkets.compactMap { makeCoin(coinMarket: $0) }
    }

    private func makeCoin(coinMarket: CoinMarketsDTO) -> Coin? {
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

