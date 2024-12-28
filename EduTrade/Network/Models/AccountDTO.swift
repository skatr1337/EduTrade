//
//  AccountDTO.swift
//  EduTrade
//
//  Created by Filip Biegaj on 14.12.2024.
//

import Foundation

struct AccountDTO: Codable {
    var cryptos: [String: CryptoDTO]
    var transactions: [TransactionDTO]

    struct CryptoDTO: Codable, Hashable {
        let id: String
        let symbol: String
        var amount: Double
    }

    enum TransactionDTO: Codable {
        case payment(PaymentTransactionDTO)
        case exchange(ExchangeTransactionDTO)
    }
    
    struct PaymentTransactionDTO: Codable {
        let timeStamp: Date
        let destinationAmount: Double
        let destinationCoinId: String
    }

    struct ExchangeTransactionDTO: Codable {
        let timeStamp: Date
        let sourceAmount: Double
        let destinationAmount: Double
        let sourceCoinId: String
        let destinationCoinId: String
        let price: Double
        let operation: Operation
    }

    enum Operation: Codable {
        case buy
        case sell
    }
}
