//
//  CryptoService.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//

protocol CryptoServiceProtocol {
    func fetchCryptoCurrencies() async throws -> [CoinMarketsDTO]
}

class CryptoService: CryptoServiceProtocol {
    func fetchCryptoCurrencies() async throws -> [CoinMarketsDTO] {
        try await Endpoints.fetchCrypto.fetch()
    }
}
