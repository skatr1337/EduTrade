//
//  TestData.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 01.02.2025.
//

import Foundation
@testable import EduTrade
import SwiftUI

protocol TestData {
    static var coinMarketBtc: CoinMarketsDTO { get }
    static var coinMarketEth: CoinMarketsDTO { get }
    static var coinMarketSol: CoinMarketsDTO { get }
    static var coinMarketBnb: CoinMarketsDTO { get }
    static var coinBtc: Coin { get }
    static var coinEth: Coin { get }
    static var coinSol: Coin { get }
    static var coinXrp: Coin { get }
    static func makeCrypto(_ coin: CoinMarketsDTO, amount: Double) -> AccountDTO.CryptoDTO
    static func makeCryptos(_ cryptos: [AccountDTO.CryptoDTO]) -> [String: AccountDTO.CryptoDTO]
    static func makeDefault(amount: Double) -> AccountDTO.CryptoDTO
    static func makeWalletCoin(_ coin: CoinMarketsDTO, amount: Double) -> WalletCoin
    static func makeDefaultWalletCoin(amount: Double) -> WalletCoin
    static func makeTransaction(_ from: AccountDTO.TransactionDTO) -> EduTrade.Transaction
    static func transactionPayment(date: Date) -> AccountDTO.TransactionDTO
    static func transactionExchangeBuy(date: Date) -> AccountDTO.TransactionDTO
    static func transactionExchangeSell(date: Date) -> AccountDTO.TransactionDTO
}

extension TestData {
    static func makeCrypto(_ coin: CoinMarketsDTO, amount: Double) -> AccountDTO.CryptoDTO {
        AccountDTO.CryptoDTO(
            id: coin.id,
            symbol: coin.symbol,
            amount: amount
        )
    }

    static func makeCryptos(_ cryptos: [AccountDTO.CryptoDTO]) -> [String: AccountDTO.CryptoDTO] {
        var result: [String: AccountDTO.CryptoDTO] = [:]
        cryptos.forEach { result[$0.id] = $0 }
        return result
    }

    static func makeDefault(amount: Double) -> AccountDTO.CryptoDTO {
        AccountDTO.CryptoDTO(
            id: WalletService(uid: "").defaultCoinId,
            symbol: WalletService(uid: "").defaultSymbol,
            amount: amount
        )
    }
}

extension TestData {
    static var coinMarketBtc: CoinMarketsDTO {
        CoinMarketsDTO(
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
    }

    static var coinMarketEth: CoinMarketsDTO {
        CoinMarketsDTO(
            id: "ethereum",
            symbol: "eth",
            name: "Ethereum",
            image: "https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628",
            current_price: 3265.89,
            market_cap: 393410038518.0,
            market_cap_rank: 2,
            fully_diluted_valuation: 393410038518.0,
            total_volume: 34549173536.0,
            high_24h: 3517.47,
            low_24h: 3238.04,
            price_change_24h: -159.82320825802753,
            price_change_percentage_24h: -4.6654,
            market_cap_change_24h: -18706421085.460327,
            market_cap_change_percentage_24h: -4.53911,
            circulating_supply: 120502277.5509541,
            total_supply: 120502277.5509541,
            ath: 4878.26,
            ath_change_percentage: -33.02902,
            ath_date: "2021-11-10T14:24:19.604Z",
            atl: 0.432979,
            atl_change_percentage: 754444.60583,
            atl_date: "2015-10-20T00:00:00.000Z",
            last_updated: "2025-01-18T14:14:32.003Z"
        )
    }

    static var coinMarketSol: CoinMarketsDTO {
        CoinMarketsDTO(
            id: "solana",
            symbol: "sol",
            name: "Solana",
            image: "https://coin-images.coingecko.com/coins/images/4128/large/solana.png?1718769756",
            current_price: 266.96,
            market_cap: 129941385458.0,
            market_cap_rank: 5,
            fully_diluted_valuation: 158207159475.0,
            total_volume: 30161163156.0,
            high_24h: 293.31,
            low_24h: 248.16,
            price_change_24h: 18.65,
            price_change_percentage_24h: 7.50882,
            market_cap_change_24h: 10215232745.0,
            market_cap_change_percentage_24h: 8.53216,
            circulating_supply: 486651567.1875936,
            total_supply: 592511476.0623337,
            ath: 293.31,
            ath_change_percentage: -8.67752,
            ath_date: "2025-01-19T11:15:27.957Z",
            atl: 0.500801,
            atl_change_percentage: 53386.2421,
            atl_date: "2020-05-11T19:35:23.449Z",
            last_updated: "2025-01-18T14:14:32.003Z"
        )
    }

    static var coinMarketBnb: CoinMarketsDTO {
        CoinMarketsDTO(
            id: "binancecoin",
            symbol: "bnb",
            name: "BNB",
            image: "https://coin-images.coingecko.com/coins/images/825/large/bnb-icon2_2x.png?1696501970",
            current_price: 697.33,
            market_cap: 101685714458.0,
            market_cap_rank: 6,
            fully_diluted_valuation: 101685714458.0,
            total_volume: 1706117086.0,
            high_24h: 714.62,
            low_24h: 681.44,
            price_change_24h: 1.029,
            price_change_percentage_24h: 0.14775,
            market_cap_change_24h: 110793364.0,
            market_cap_change_percentage_24h: 0.10908,
            circulating_supply: 145887575.79,
            total_supply: 145887575.79,
            ath: 788.84,
            ath_change_percentage: -11.7265,
            ath_date: "2024-12-04T10:35:25.220Z",
            atl: 0.0398177,
            atl_change_percentage: 1748719.97514,
            atl_date: "2017-10-19T00:00:00.000Z",
            last_updated: "2025-01-18T14:14:32.003Z"
        )
    }

}

extension TestData {
    static var coinBtc: Coin {
        Coin(
            id: "bitcoin",
            rank: 1,
            symbol: "btc",
            image: URL(string: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")!,
            currentPrice: 104976.0,
            priceChangePercentage: 0.34825,
            isPriceChangePosive : true
        )
    }

    static var coinEth: Coin {
        Coin(
            id: "ethereum",
            rank: 2,
            symbol: "eth",
            image: URL(string: "https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628")!,
            currentPrice: 3327.34,
            priceChangePercentage: -0.18042,
            isPriceChangePosive : false
        )
    }

    static var coinSol: Coin {
        Coin(
            id: "solana",
            rank: 5,
            symbol: "sol",
            image: URL(string: "https://coin-images.coingecko.com/coins/images/4128/large/solana.png?1718769756")!,
            currentPrice: 266.96,
            priceChangePercentage: 7.50882,
            isPriceChangePosive : true
        )
    }
    
    static var coinXrp: Coin {
        Coin(
            id: "ripple",
            rank: 3,
            symbol: "xrp",
            image: URL(string: "https://coin-images.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png?1696501442")!,
            currentPrice: 3.11,
            priceChangePercentage: 0.03051,
            isPriceChangePosive : true
        )
    }
}

extension TestData {
    static func makeTransaction(_ from: AccountDTO.TransactionDTO) -> EduTrade.Transaction {
        switch from {
        case let .payment(transaction):
            return Transaction(
                timeStamp: transaction.timeStamp,
                pair: transaction.destinationCoinId,
                operation: .payment,
                sourceAmount: nil,
                destinationAmount: transaction.destinationAmount,
                price: nil
            )
        case let .exchange(transaction):
            return Transaction(
                timeStamp: transaction.timeStamp,
                pair: "\(transaction.sourceCoinId)/\(transaction.destinationCoinId)",
                operation: transaction.operation.toTransactionOperation,
                sourceAmount: transaction.sourceAmount,
                destinationAmount: transaction.destinationAmount,
                price: transaction.price
            )
        }
    }

    static func transactionPayment(date: Date) -> AccountDTO.TransactionDTO {
        AccountDTO.TransactionDTO.payment(
            AccountDTO.PaymentTransactionDTO(
                timeStamp: date,
                destinationAmount: 1000,
                destinationCoinId: "dollar"
            )
        )
    }

    static func transactionExchangeBuy(date: Date) -> AccountDTO.TransactionDTO {
        AccountDTO.TransactionDTO.exchange(
            AccountDTO.ExchangeTransactionDTO(
                timeStamp: date,
                sourceAmount: 100000,
                destinationAmount: 1,
                sourceCoinId: "dollar",
                destinationCoinId: "bitcoin",
                price: 100000,
                operation: AccountDTO.Operation.buy
            )
        )
    }

    static func transactionExchangeSell(date: Date) -> AccountDTO.TransactionDTO {
        AccountDTO.TransactionDTO.exchange(
            AccountDTO.ExchangeTransactionDTO(
                timeStamp: date,
                sourceAmount: 1,
                destinationAmount: 100000,
                sourceCoinId: "bitcoin",
                destinationCoinId: "dollar",
                price: 100000,
                operation: AccountDTO.Operation.sell
            )
        )
    }
}

extension TestData {
    static func makeWalletCoin(_ coin: CoinMarketsDTO, amount: Double) -> WalletCoin {
        WalletCoin(
            symbol: coin.symbol,
            image: .imegeUrl(URL(string: coin.image)!),
            amount: amount,
            value: amount * coin.current_price,
            isFiatCurrency: false
        )
    }

    static func makeDefaultWalletCoin(amount: Double) -> WalletCoin {
        WalletCoin(
            symbol: WalletService(uid: "").defaultSymbol,
            image: .image(Image(systemName: "dollarsign")),
            amount: amount,
            value: amount,
            isFiatCurrency: true
        )
    }
}
