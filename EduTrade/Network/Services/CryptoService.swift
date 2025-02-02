//
//  CryptoService.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//

import Foundation

protocol CryptoServiceProtocol {
    func fetchList() async throws -> [CoinMarketsDTO]
    func fetchCoin(id: String) async throws -> CoinMarketsDTO
}

class CryptoService: CryptoServiceProtocol {
    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchList() async throws -> [CoinMarketsDTO] {
        try await Endpoints.fetchList.fetch(session: session)
    }
    
    func fetchCoin(id: String) async throws -> CoinMarketsDTO {
        let coins: [CoinMarketsDTO] = try await Endpoints.fetchCoin(id: id).fetch(session: session)
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
