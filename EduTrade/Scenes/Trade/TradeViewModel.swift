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
    var exchangeCoin: CoinMarketsDTO?
    @MainActor @Published
    var walletDestinationCoin: AccountDTO.CryptoDTO?
    @MainActor @Published
    var walletSourceCoin: AccountDTO.CryptoDTO?
    @MainActor @Published
    var currentValue: Double = 0 {
        didSet {
            if let exchangeCoin {
                destinationValue = currentValue / exchangeCoin.current_price
            }
        }
    }
    @MainActor @Published
    var destinationValue: Double = 0
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
        maxValue = 0
        exchangeCoin = try? await cryptoService.fetchCoin(id: id)
        if let walletCoin = await walletService.getCoin(id: id) {
            walletDestinationCoin = walletCoin
        } else if let exchangeCoin {
            walletDestinationCoin = AccountDTO.CryptoDTO(
                id: id,
                symbol: exchangeCoin.symbol,
                amount: 0
            )
        }
        walletSourceCoin = await walletService.getDefaultCoin()
        currentValue = 0
        if tradeOption == .buy {
            maxValue = walletSourceCoin?.amount ?? 0
        } else {
            maxValue = walletDestinationCoin?.amount ?? 0
        }
    }

    @MainActor
    func buy() async {
        
    }

    @MainActor
    func sell() async {
        
    }
}

extension TradeViewModel {
    enum TradeOption: CaseIterable, Identifiable {
        case buy
        case sell

        var id: Self { self }

        func description(symbol: String) -> String {
            switch self {
            case .buy:
                "Buy \(symbol)"
            case .sell:
                "Sell \(symbol)"
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
