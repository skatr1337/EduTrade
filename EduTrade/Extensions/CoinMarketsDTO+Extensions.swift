//
//  CoinMarketsDTO+Extensions.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//

import Foundation

extension CoinMarketsDTO {
    func toCoin() -> Coin? {
        guard let image = URL(string: image) else { return nil }
        return Coin(
            rank: market_cap_rank,
            symbol: symbol,
            image: image,
            currentPrice: current_price,
            priceChangePercentage: price_change_percentage_24h,
            isPriceChangePosive: price_change_percentage_24h >= 0
        )
    }
}

extension [CoinMarketsDTO] {
    func toCoins() -> [Coin] {
        compactMap { $0.toCoin() }
    }
}
