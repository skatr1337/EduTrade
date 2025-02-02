//
//  WalletViewModelTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 28.01.2025.
//

import Foundation
@testable import EduTrade
import SwiftUI
import Testing

struct WalletViewModelTests: TestData {
    let cryptoServiceMock: CryptoServiceMock
    let walletServiceMock: WalletServiceMock
    let walletViewModel: WalletViewModel

    init() {
        cryptoServiceMock = CryptoServiceMock()
        walletServiceMock = WalletServiceMock()
        walletViewModel = WalletViewModel(
            cryptoService: cryptoServiceMock,
            walletService: walletServiceMock
        )
        cryptoServiceMock.coins = [
            Self.coinMarketBtc,
            Self.coinMarketEth,
            Self.coinMarketSol,
            Self.coinMarketBnb
        ]
    }

    @Test(
        "Test getAccount",
        arguments: zip(
            [
                makeCryptos(
                    [
                        makeCrypto(coinMarketBtc, amount: 3.67),
                        makeCrypto(coinMarketSol, amount: 1234.89)
                    ]
                ),
                makeCryptos(
                    [
                        makeCrypto(coinMarketBtc, amount: 0.0459),
                        makeCrypto(coinMarketEth, amount: 1234.88),
                        makeCrypto(coinMarketSol, amount: 11.5),
                        makeCrypto(coinMarketBnb, amount: 12345)
                    ]
                ),
                makeCryptos(
                    [
                        makeDefault(amount: 1000),
                        makeCrypto(coinMarketBtc, amount: 1)
                    ]
                )
            ] as [[String: AccountDTO.CryptoDTO]],
            [
                [
                    makeWalletCoin(coinMarketBtc, amount: 3.67),
                    makeWalletCoin(coinMarketSol, amount: 1234.89)
                ],
                [
                    makeWalletCoin(coinMarketBnb, amount: 12345),
                    makeWalletCoin(coinMarketEth, amount: 1234.88),
                    makeWalletCoin(coinMarketBtc, amount: 0.0459),
                    makeWalletCoin(coinMarketSol, amount: 11.5)
                ],
                [
                    makeDefaultWalletCoin(amount: 1000),
                    makeWalletCoin(coinMarketBtc, amount: 1)
                ],
            ]
            as [[WalletCoin]]
        )
    )
    func getAccount(
        cryptos: [String: AccountDTO.CryptoDTO],
        walletCoins: [WalletCoin]
    ) async throws {
        // Given
        walletServiceMock.account = AccountDTO(cryptos: cryptos, transactions: [])
        let total = walletCoins.reduce(0) { $0 + $1.value }

        // When
        try await walletViewModel.getAccount()

        // Then
        await #expect(walletViewModel.walletCoins == walletCoins)
        await #expect(walletViewModel.totalValue == total)
        #expect(cryptoServiceMock.calledMethods.contains("fetchList()"))
        #expect(walletServiceMock.calledMethods.contains("getAccount()"))
    }
}
