//
//  WalletViewSnapshotTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 05.02.2025.
//

import Foundation
@testable import EduTrade
import Testing
import SnapshotTesting

@Suite(.snapshots(record: .all, diffTool: .ksdiff))
struct WalletViewSnapshotTests: SnapshotTests, TestData {
    let viewModel: WalletViewModelMock
    let walletView: WalletView<WalletViewModelMock>

    @MainActor
    init() throws {
        viewModel = WalletViewModelMock()
        walletView = WalletView(viewModel: viewModel)
    }

    let walletCoins: [WalletCoin] = [
        makeWalletCoin(coinMarketBnb, amount: 12345),
        makeWalletCoin(coinMarketEth, amount: 1234.88),
        makeWalletCoin(coinMarketBtc, amount: 0.0459),
        makeWalletCoin(coinMarketSol, amount: 11.5)
    ]
    
    @Test("Test walletView")
    @MainActor
    func walletView() async throws {
        // Given
        viewModel.totalValue = 123.7869
        viewModel.walletCoins = walletCoins
        let view = walletView.environmentObject(coordinator)

        // Then
        assertSnapshot(view: view)
    }
}
