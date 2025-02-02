//
//  TransactionsViewModelMock.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 30.01.2025.
//

@testable import EduTrade

class TransactionsViewModelMock: TransactionsViewModelProtocol {
    var calledMethods: [String] = []

    var transactions: [Transaction] = []
    
    func getTransactions() async throws {
        calledMethods.append(#function)
    }
}
