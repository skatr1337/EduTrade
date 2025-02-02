//
//  WalletViewModelMock.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 29.01.2025.
//

@testable import EduTrade

class WalletViewModelMock: WalletViewModelProtocol {
    var calledMethods: [String] = []

    var walletCoins: [WalletCoin] = []
    var totalValue: Double = 0
    
    func getAccount() async throws {
        calledMethods.append(#function)
    }
}
