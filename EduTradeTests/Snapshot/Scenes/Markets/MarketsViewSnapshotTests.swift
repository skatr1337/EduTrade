//
//  MarketsViewSnapshotTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 03.02.2025.
//

@testable import EduTrade
import Testing
import SnapshotTesting

@Suite(.snapshots(record: .all, diffTool: .ksdiff))
struct MarketsViewSnapshotTests: SnapshotTests, TestData {
    let viewModel: MarketsViewModelMock
    let marketsView: MarketsView<MarketsViewModelMock>

    @MainActor
    init() throws {
        viewModel = MarketsViewModelMock()
        marketsView = MarketsView(viewModel: viewModel)
    }

    @Test("Test marketsView")
    @MainActor
    func marketsView() async throws {
        // Given
        viewModel.coins = [Self.coinBtc, Self.coinEth, Self.coinSol]
        let view = marketsView.environmentObject(coordinator)

        // Then
        assertSnapshot(view: view)
    }
}
