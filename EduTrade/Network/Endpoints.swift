//
//  Endpoints.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import Foundation

enum Endpoints: NetworkEndpointProtocol {
    case fetchCrypto

    var url: String {
        switch self {
        case .fetchCrypto:
            "https://api.coingecko.com/api/v3/coins/markets"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .fetchCrypto:
            [
                "accept": "application/json",
                "x-cg-demo-api-key": "CG-v8YH8a7PgxV2vgeepejDANNF"
            ]
        }
    }

    var query: [String: String] {
        switch self {
        case .fetchCrypto:
            [
                "vs_currency" : "usd"
            ]
        }
    }
}

