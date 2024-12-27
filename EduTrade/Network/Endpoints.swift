//
//  Endpoints.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import Foundation

enum Endpoints: NetworkEndpointProtocol {
    case fetchList
    case fetchCoin(id: String)

    var url: String {
        switch self {
        case .fetchList:
            "https://api.coingecko.com/api/v3/coins/markets?order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24"
        case .fetchCoin:
            "https://api.coingecko.com/api/v3/coins/markets"
        }
    }
    
    var headers: [String: String] {
        [
            "accept": "application/json",
            "x-cg-demo-api-key": "CG-v8YH8a7PgxV2vgeepejDANNF"
        ]
    }

    var query: [String: String] {
        switch self {
        case .fetchList:
            [
                "vs_currency": "usd"
            ]
        case let .fetchCoin(id):
            [
                "vs_currency": "usd",
                "ids": id
            ]
        }
    }
}

