//
//  AccountDTO.swift
//  EduTrade
//
//  Created by Filip Biegaj on 14.12.2024.
//

import Foundation

struct AccountDTO: Codable {
    var cryptos: [CryptoDTO]

    struct CryptoDTO: Codable, Hashable {
        let id: String
        let symbol: String
        let amount: Double
    }
}
