//
//  CryptoServiceTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 13.01.2025.
//

import Foundation
@testable import EduTrade
import Testing

struct CryptoServiceTests: TestData {
    let cryptoService: CryptoService
    let sessionMock: URLSessionMock
    static let encoder = JSONEncoder()

    init() {
        sessionMock = URLSessionMock()
        cryptoService = CryptoService(session: sessionMock)
        Self.encoder.dateEncodingStrategy = .iso8601
    }

    enum CryptoServiceError: Error, Equatable {
        case responseDefinition
    }

    static let testURL = URL(string: "http://test.pl")!
    static let successResponse = HTTPURLResponse(
        url: testURL,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )

    @Test(
        "Test fetchList error",
        arguments: [
            HTTPURLResponse(
                url: testURL,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            ),
            HTTPURLResponse(
                url: testURL,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            ),
            URLResponse(
                url: testURL,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            )
        ] as [URLResponse?]
    )
    func fetchList(response: URLResponse?) async throws {
        // Given
        guard let response else {
            throw CryptoServiceError.responseDefinition
        }
        sessionMock.resultResponse = response

        // When
        await #expect(throws: NetworkError.responseError) {
            try await cryptoService.fetchList()
        }
    }

    @Test("Test fetchList decoding error")
    func fetchListDecodingError() async throws {
        // Given
        guard let response = Self.successResponse else {
            throw CryptoServiceError.responseDefinition
        }
        sessionMock.resultResponse = response
        sessionMock.resultData = try Self.encoder.encode(["wrong data"])

        // When
        await #expect(throws: DecodingError.self) {
            try await cryptoService.fetchList()
        }
    }

    @Test(
        "Test fetchList success",
        arguments: zip(
            [
                try encoder.encode([coinMarketBtc]),
                try encoder.encode([coinMarketEth]),
                try encoder.encode([coinMarketBtc, coinMarketEth])
            ] as [Data],
            [
                [coinMarketBtc],
                [coinMarketEth],
                [coinMarketBtc, coinMarketEth]
            ] as [[CoinMarketsDTO]]
        )
    )
    func fetchListSuccess(data: Data, result: [CoinMarketsDTO]) async throws {
        // Given
        guard let response = Self.successResponse else {
            throw CryptoServiceError.responseDefinition
        }
        sessionMock.resultResponse = response
        sessionMock.resultData = data

        // When
        let resultCoins = try await cryptoService.fetchList()

        // Then
        #expect(resultCoins == result)
    }

    @Test("Test fetchCoin decoding error")
    func fetchCoinDecodingError() async throws {
        // Given
        guard let response = Self.successResponse else {
            throw CryptoServiceError.responseDefinition
        }
        sessionMock.resultResponse = response
        sessionMock.resultData = try Self.encoder.encode("Wrong data")

        // When
        await #expect(throws: DecodingError.self) {
            try await cryptoService.fetchCoin(id: "bitcoin")
        }
    }

    @Test(
        "Test fetchCoin success",
        arguments: zip(
            [
                try encoder.encode([coinMarketBtc]),
                try encoder.encode([coinMarketEth])
            ] as [Data],
            [
                coinMarketBtc,
                coinMarketEth,
            ] as [CoinMarketsDTO]
        )
    )
    func fetchCoinSuccess(data: Data, result: CoinMarketsDTO) async throws {
        // Given
        guard let response = Self.successResponse else {
            throw CryptoServiceError.responseDefinition
        }
        sessionMock.resultResponse = response
        sessionMock.resultData = data

        // When
        let resultCoin = try await cryptoService.fetchCoin(id: "bitcoin")

        // Then
        #expect(resultCoin == result)
    }
}
