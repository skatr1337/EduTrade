//
//  URLSessionMock.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 18.01.2025.
//

import Foundation
@testable import EduTrade

class URLSessionMock: URLSessionProtocol {
    var calledMethods: [String] = []

    var resultData: Data = Data()
    var resultResponse = URLResponse()
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        calledMethods.append(#function)
        return (resultData, resultResponse)
    }
}
