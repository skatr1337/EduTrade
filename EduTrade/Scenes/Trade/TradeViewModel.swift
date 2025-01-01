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

    let sliderFactor = 1_000_000.0

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
                switch tradeOption {
                case .buy:
                    destinationValue = currentValue / exchangeCoin.current_price
                case .sell:
                    destinationValue = currentValue * exchangeCoin.current_price
                }
            }
        }
    }
    
    @MainActor
    var currentValueSlider: Double {
        get {
            currentValue * sliderFactor
        }
        set {
            currentValue = newValue / sliderFactor
        }
    }
    @MainActor @Published
    var destinationValue: Double = 0
    @MainActor @Published
    var maxValue: Double = 0 {
        didSet {
            maxValueSlider = maxValue * sliderFactor
        }
    }
    @MainActor @Published
    var maxValueSlider: Double = 0

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
        do {
            exchangeCoin = try await cryptoService.fetchCoin(id: id)
            switch tradeOption {
            case .buy:
                await getBuyCoin(id: id)
            case .sell:
                await getSellCoin(id: id)
            }
            maxValue = walletSourceCoin?.amount ?? 0
        } catch {
            print(error)
        }
    }

    @MainActor
    func getBuyCoin(id: String) async {
        do {
            if let walletCoin = try await walletService.getCoin(id: id) {
                walletDestinationCoin = walletCoin
            } else if let exchangeCoin {
                walletDestinationCoin = AccountDTO.CryptoDTO(
                    id: id,
                    symbol: exchangeCoin.symbol,
                    amount: 0
                )
            }
            walletSourceCoin = try await walletService.getDefaultCoin()
            currentValue = 0
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func getSellCoin(id: String) async {
        do {
            if let walletCoin = try await walletService.getCoin(id: id) {
                walletSourceCoin = walletCoin
            } else if let exchangeCoin {
                walletSourceCoin = AccountDTO.CryptoDTO(
                    id: id,
                    symbol: exchangeCoin.symbol,
                    amount: 0
                )
            }
            walletDestinationCoin = try await walletService.getDefaultCoin()
            currentValue = 0
        } catch {
            print(error)
        }
    }

    @MainActor
    func buy(id: String) async {
        do {
            exchangeCoin = try await cryptoService.fetchCoin(id: id)
            guard
                let walletSourceCoin,
                let walletDestinationCoin
            else {
                return
            }
            try await walletService.makeExchange(
                operation: WalletService.ExchangeOpetation(
                    sourceCoin: walletSourceCoin,
                    sourceAmount: currentValue,
                    destinationCoin: walletDestinationCoin,
                    destinationAmount: destinationValue,
                    operation: tradeOption == .buy ? .buy : .sell
                )
            )
            // refresh data
            switch tradeOption {
            case .buy:
                await getCoin(id: walletDestinationCoin.id)
            case .sell:
                await getCoin(id: walletSourceCoin.id)
            }
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func percentage(_ percentage: Double) {
        currentValue = maxValue * percentage
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
                String(localized: "Buy \(symbol)")
            case .sell:
                String(localized: "Sell \(symbol)")
            }
        }

        var description: String {
            switch self {
            case .buy:
                String(localized: "Buy")
            case .sell:
                String(localized: "Sell")
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
