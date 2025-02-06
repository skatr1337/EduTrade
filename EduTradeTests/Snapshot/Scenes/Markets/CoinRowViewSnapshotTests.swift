//
//  CoinRowViewSnapshotTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 05.02.2025.
//

@testable import EduTrade
import Testing
import SnapshotTesting

@Suite(.snapshots(record: .all, diffTool: .ksdiff))
struct CoinRowViewSnapshotTests: SnapshotTests, TestData {
    let coinRowView: CoinRowView

    @MainActor
    init() throws {
        coinRowView = CoinRowView(coin: Self.coinBtc)
    }

    @Test("Test marketsView")
    @MainActor
    func marketsView() async throws {
        // Then
        assertSnapshot(view: coinRowView)
    }
}
