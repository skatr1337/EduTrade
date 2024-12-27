//
//  CryptoService.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//

protocol CryptoServiceProtocol {
    func fetchList() async throws -> [CoinMarketsDTO]
    func fetchCoin(id: String) async throws -> CoinMarketsDTO
}

class CryptoService: CryptoServiceProtocol {
    func fetchList() async throws -> [CoinMarketsDTO] {
        try await Endpoints.fetchList.fetch()
    }
    
    func fetchCoin(id: String) async throws -> CoinMarketsDTO {
        let coins: [CoinMarketsDTO] = try await Endpoints.fetchCoin(id: id).fetch()
        if let coin = coins.first {
            return coin
        }
        throw error.notFound
    }
}

extension CryptoService {
    enum error: Error {
        case notFound
    }
}
