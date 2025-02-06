//
//  TransactionsRowViewSnapshotTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 05.02.2025.
//

import Foundation
@testable import EduTrade
import Testing
import SnapshotTesting

@Suite(.snapshots(record: .all, diffTool: .ksdiff))
struct TransactionsRowViewSnapshotTests: SnapshotTests, TestData {
    let transactionsRowView: TransactionsRowView

    @MainActor
    init() throws {
        let testDate = Date(timeIntervalSince1970: 1_738_774_873)
        transactionsRowView = TransactionsRowView(
            transaction: Self.makeTransaction(
                Self.transactionPayment(date: testDate)
            )
        )
    }

    @Test("Test transactionsRowView")
    @MainActor
    func transactionsRowView() async throws {
        // Then
        assertSnapshot(view: transactionsRowView)
    }
}
