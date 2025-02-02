//
//  MarketsViewModelMock.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 26.01.2025.
//

@testable import EduTrade

class MarketsViewModelMock: MarketsViewModelProtocol {
    var calledMethods: [String] = []

    var coins: [Coin] = []
    
    func refresh() async throws {
        calledMethods.append(#function)
    }
}
