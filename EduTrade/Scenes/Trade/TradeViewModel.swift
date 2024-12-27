//
//  TradeViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 26/12/2024.
//

import SwiftUI

class TradeViewModel: ObservableObject {
    private let cryptoService: CryptoServiceProtocol
    private let walletService: WalletServiceProtocol
    private var destinationCoin: CoinMarketsDTO?
    
    @MainActor @Published
    var tradeOption: TradeOption = .buy

    @MainActor @Published
    var sourceCoin: AccountDTO.CryptoDTO?
    @MainActor @Published
    var currentValue: Double = 0
    @MainActor @Published
    var maxValue: Double = 0

    init(
        cryptoService: CryptoServiceProtocol,
        walletService: WalletServiceProtocol
    ) {
        self.cryptoService = cryptoService
        self.walletService = walletService
    }

    @MainActor
    func getCoin(id: String) async {
        destinationCoin = try? await cryptoService.fetchCoin(id: id)
        sourceCoin = await walletService.getDefaultCoin()
        maxValue = sourceCoin?.amount ?? 0
    }
}

extension TradeViewModel {
    enum TradeOption: CaseIterable, Identifiable, CustomStringConvertible {
        case buy
        case sell

        var id: Self { self }

        var description: String {
            switch self {
            case .buy:
                "Buy"
            case .sell:
                "Sell"
            }
        }

        var color: Color {
            switch self {
            case .buy:
                Color.green
            case .sell:
                Color.red
            }
        }
    }
}
