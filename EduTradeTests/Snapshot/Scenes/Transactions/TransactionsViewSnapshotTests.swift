//
//  TransactionsViewSnapshotTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 05.02.2025.
//

import Foundation
@testable import EduTrade
import Testing
import SnapshotTesting

@Suite(.snapshots(record: .all, diffTool: .ksdiff))
struct TransactionsViewSnapshotTests: SnapshotTests, TestData {
    let viewModel: TransactionsViewModelMock
    let transactionsView: TransactionsView<TransactionsViewModelMock>

    @MainActor
    init() throws {
        viewModel = TransactionsViewModelMock()
        transactionsView = TransactionsView(viewModel: viewModel)
    }

    @Test("Test transactionsView")
    @MainActor
    func transactionsView() async throws {
        // Given
        let testDate = Date(timeIntervalSince1970: 1_738_774_873)
        let transations: [EduTrade.Transaction] = [
            Self.makeTransaction(Self.transactionPayment(date: testDate)),
            Self.makeTransaction(Self.transactionExchangeBuy(date: testDate)),
            Self.makeTransaction(Self.transactionExchangeSell(date: testDate))
        ]
        viewModel.transactions = transations
        let view = transactionsView.environmentObject(coordinator)

        // Then
        assertSnapshot(view: view)
    }
}
