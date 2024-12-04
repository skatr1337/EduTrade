//
//  CoinMarketsDTO+Extensions.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
extension CoinMarketsDTO {
    func toCoin() -> Coin {
        Coin(
            name: name,
            current_price: current_price
        )
    }
}

extension [CoinMarketsDTO] {
    func toCoins() -> [Coin] {
        map { $0.toCoin() }
    }
}
