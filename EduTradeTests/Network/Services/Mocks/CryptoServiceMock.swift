//
//  CryptoServiceMock.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 18.01.2025.
//

@testable import EduTrade

class CryptoServiceMock: CryptoServiceProtocol {
    var calledMethods: [String] = []

    var coins: [CoinMarketsDTO] = []
    func fetchList() async throws -> [CoinMarketsDTO] {
        calledMethods.append(#function)
        return coins
    }

    var coin = CoinMarketsDTO(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        current_price: 104205.0,
        market_cap: 2063735165533.0,
        market_cap_rank: 1,
        fully_diluted_valuation: 2063735165533.0,
        total_volume: 61542351305.0,
        high_24h: 105850.0,
        low_24h: 102214.0,
        price_change_24h: 1639.63,
        price_change_percentage_24h: 1.59862,
        market_cap_change_24h: 31779390904.0,
        market_cap_change_percentage_24h: 1.56398,
        circulating_supply: 19811812.0,
        total_supply: 19811812.0,
        ath: 108135.0,
        ath_change_percentage: -3.49059,
        ath_date: "2024-12-17T15:02:41.429Z",
        atl: 67.81,
        atl_change_percentage: 153803.12494,
        atl_date: "2013-07-06T00:00:00.000Z",
        last_updated: "2025-01-18T14:14:32.003Z"
    )
    func fetchCoin(id: String) async throws -> CoinMarketsDTO {
        calledMethods.append(#function)
        return coin
    }
}
