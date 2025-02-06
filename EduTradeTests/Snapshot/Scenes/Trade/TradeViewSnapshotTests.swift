//
//  TradeViewSnapshotTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 05.02.2025.
//

@testable import EduTrade
import Testing
import SnapshotTesting

@Suite(.snapshots(record: .all, diffTool: .ksdiff))
struct TradeViewSnapshotTests: SnapshotTests, TestData {
    let viewModel: TradeViewModelMock
    let tradeView: TradeView<TradeViewModelMock>

    @MainActor
    init() throws {
        viewModel = TradeViewModelMock()
        tradeView = TradeView(viewModel: viewModel, coin: Self.coinBtc)
    }

    @Test("Test tradeView")
    @MainActor
    func tradeView() async throws {
        // Given
        viewModel.tradeOption = .buy
        viewModel.getCoinResult = Self.coinMarketBtc
        viewModel.walletSourceCoin = Self.makeDefault(amount: 1000)
        viewModel.walletDestinationCoin = Self.makeCrypto(Self.coinMarketBtc, amount: 0)
        let view = tradeView.environmentObject(coordinator)

        // Then
        assertSnapshot(view: view)
    }
}
