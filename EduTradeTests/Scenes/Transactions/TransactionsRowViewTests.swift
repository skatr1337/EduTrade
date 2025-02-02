//
//  TransactionsRowViewTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 30.01.2025.
//

import Foundation
@testable import EduTrade
import Testing
import ViewInspector
import SwiftUICore

struct TransactionsRowViewTests: TestData {
    static let testDate = Date()

    @Test(
        "Test WalletRowView",
        arguments: zip(
            [
                makeTransaction(transactionPayment(date: testDate)),
                makeTransaction(transactionExchangeBuy(date: testDate)),
                makeTransaction(transactionExchangeSell(date: testDate))
            ] as [EduTrade.Transaction],
            [
                (
                    makeTransaction(transactionPayment(date: testDate)).timeStamp.toString,
                    "DOLLAR",
                    "Payment"
                ),
                (
                    makeTransaction(transactionPayment(date: testDate)).timeStamp.toString,
                    "DOLLAR/BITCOIN",
                    "Buy"
                ),
                (
                    makeTransaction(transactionPayment(date: testDate)).timeStamp.toString,
                    "BITCOIN/DOLLAR",
                    "Sell"
                )
            ] as [(String, String, String)]
        )
    )
    @MainActor
    func walletRowView(transaction: EduTrade.Transaction, result: (String, String, String)) async throws {
        // When
        let walletRowView = TransactionsRowView(transaction: transaction)

        // Then
        let inspect = try walletRowView.inspect()
        let date = try inspect.find(text: transaction.timeStamp.toString.uppercased())
        let symbol = try inspect.find(text: transaction.pair.uppercased())
        let operation = try inspect.find(text: transaction.operation.rawValue)
        try #expect(date.string() == result.0)
        try #expect(symbol.string() == result.1)
        try #expect(operation.string() == result.2)
    }
}
