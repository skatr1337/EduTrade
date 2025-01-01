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
        guard let coin = coins.first else {
            throw CryptoServiceError.coinNotFound
        }
        return coin
    }
}

extension CryptoService {
    enum CryptoServiceError: Error {
        case coinNotFound
    }

    func localizeddDscription(error: Error) -> String {
        switch error {
        case CryptoServiceError.coinNotFound:
            "Coin not found"
        default:
            "Unknown error"
        }
    }
}
