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
            "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24"
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

