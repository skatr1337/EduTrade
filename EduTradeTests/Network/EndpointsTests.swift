//
//  EndpointsTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 18.01.2025.
//

@testable import EduTrade
import Testing

struct EndpointsTests {
    private static let endpoints: [Endpoints] = [
        .fetchList,
        .fetchCoin(id: "btc")
    ]
    
    @Test(
        "Test Endpoints url",
        arguments: zip(
            endpoints,
            [
                "https://api.coingecko.com/api/v3/coins/markets?order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24",
                "https://api.coingecko.com/api/v3/coins/markets"
            ] as [String]
        )
    )
    func getUrl(endpoint: Endpoints, url: String) throws {
        #expect(endpoint.url == url)
    }

    @Test(
        "Test Endpoints headers",
        arguments: zip(
            endpoints,
            [
                [
                    "accept": "application/json",
                    "x-cg-demo-api-key": "CG-v8YH8a7PgxV2vgeepejDANNF"
                ],
                [
                    "accept": "application/json",
                    "x-cg-demo-api-key": "CG-v8YH8a7PgxV2vgeepejDANNF"
                ]
            ] as [[String: String]]
        )
    )
    func getHeaders(endpoint: Endpoints, expected: [String: String]) throws {
        #expect(endpoint.headers == expected)
    }
    
    @Test(
        "Test Endpoints query",
        arguments: zip(
            endpoints,
            [
                [
                    "vs_currency": "usd"
                ],
                [
                    "vs_currency": "usd",
                    "ids": "btc"
                ]
            ] as [[String: String]]
        )
    )
    func getQuery(endpoint: Endpoints, expected: [String: String]) throws {
        #expect(endpoint.query == expected)
    }

    @Test(
        "Test Endpoints url",
        arguments: zip(
            endpoints,
            [
                .get,
                .get
            ] as [Method]
        )
    )
    func getUrl(endpoint: Endpoints, method: Method) throws {
        #expect(endpoint.method == method)
    }
}
