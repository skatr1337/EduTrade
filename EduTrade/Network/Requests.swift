//
//  Requests.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import Foundation

class Requests {
    func fetchCryptoCurrencies() async throws -> [CoinMarketsDTO] {
        try await Endpoints.fetchCrypto.fetch()
    }
}
