//
//  TransactionsViewTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 30.01.2025.
//

import Foundation
@testable import EduTrade
import Testing
import SwiftUI
import ViewInspector

struct TransactionsViewTests: BaseViewTest, TestData {
    typealias V = TransactionsView<TransactionsViewModelMock>
    let viewModel: TransactionsViewModelMock
    var transactionsView: TransactionsView<TransactionsViewModelMock>
    static let testDate = Date()

    @MainActor
    init() throws {
        viewModel = TransactionsViewModelMock()
        transactionsView = TransactionsView(viewModel: viewModel)
    }

    @Test(
        "Test transactionsView",
        arguments: zip(
            [
                [
                    makeTransaction(transactionPayment(date: testDate))
                ],
                [
                    makeTransaction(transactionPayment(date: testDate)),
                    makeTransaction(transactionExchangeBuy(date: testDate)),
                    makeTransaction(transactionExchangeSell(date: testDate))
                ]
            ] as [[EduTrade.Transaction]],
            [
                1,
                3
            ] as [Int]
        )
    )
    @MainActor
    func transactionsView(transactions: [EduTrade.Transaction], count: Int) async throws {
        // Given
        viewModel.transactions = transactions

        // When
        let view = try await setup(transactionsView)

        // Then
        let inspect = try view.inspect()
        let list = try inspect.find(viewWithAccessibilityIdentifier: "transactionsList")
        let items = list.findAll(TransactionsRowView.self)
        #expect(items.count == count)
        for (index, transaction) in transactions.enumerated() {
            let string = transaction.pair.uppercased()
            try #expect(items[index].find(text: string).string() == string)
        }
    }
}
