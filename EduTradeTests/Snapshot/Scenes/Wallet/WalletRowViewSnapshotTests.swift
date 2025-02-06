//
//  WalletRowViewSnapshotTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 05.02.2025.
//

import Foundation
@testable import EduTrade
import Testing
import SnapshotTesting

@Suite(.snapshots(record: .all, diffTool: .ksdiff))
struct WalletRowViewSnapshotTests: SnapshotTests, TestData {
    let walletRowView: WalletRowView

    @MainActor
    init() throws {
        walletRowView = WalletRowView(
            walletCoin: Self.makeWalletCoin(Self.coinMarketBnb, amount: 12345)
        )
    }

    @Test("Test walletRowView")
    @MainActor
    func walletRowView() async throws {
        // Then
        assertSnapshot(view: walletRowView)
    }
}
