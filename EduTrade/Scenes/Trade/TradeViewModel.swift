//
//  TradeViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 26/12/2024.
//

import SwiftUI
protocol TradeViewModelProtocol: ObservableObject {
    var tradeOption: TradeViewModel.TradeOption { get set }
    var exchangeCoin: CoinMarketsDTO? { get }
    var walletSourceCoin: AccountDTO.CryptoDTO? { get }
    var walletDestinationCoin: AccountDTO.CryptoDTO? { get }
    var currentValue: Double { get set }
    var currentValueSlider: Double { get set }
    var destinationValue: Double { get }
    var maxValue: Double { get set }
    var maxValueSlider: Double { get }
    var percentageButtons: [Double] { get }
    func percentage(_ percentage: Double) async
    func getCoin(id: String) async throws
    func buy(id: String) async throws
}

class TradeViewModel: TradeViewModelProtocol {
    private let cryptoService: CryptoServiceProtocol
    private let walletService: WalletServiceProtocol
    private var destinationCoin: CoinMarketsDTO?
    private let sliderFactor = 1_000_000.0
    
    @MainActor @Published
    var tradeOption: TradeOption = .buy
    
    @MainActor @Published
    private(set) var exchangeCoin: CoinMarketsDTO?
    
    @MainActor @Published
    private(set) var walletSourceCoin: AccountDTO.CryptoDTO?
    
    @MainActor @Published
    private(set) var walletDestinationCoin: AccountDTO.CryptoDTO?
    
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
    private(set) var destinationValue: Double = 0

    @MainActor @Published
    var maxValue: Double = 0 {
        didSet {
            maxValueSlider = maxValue * sliderFactor
        }
    }

    @MainActor @Published
    private(set) var maxValueSlider: Double = 0

    let percentageButtons: [Double] = [0.25, 0.5, 0.75, 1.0]

    init(
        cryptoService: CryptoServiceProtocol,
        walletService: WalletServiceProtocol
    ) {
        self.cryptoService = cryptoService
        self.walletService = walletService
    }

    // MARK: Public interface

    @MainActor
    func percentage(_ percentage: Double) {
        currentValue = maxValue * percentage
    }

    @MainActor
    func getCoin(id: String) async throws {
        maxValue = 0
        exchangeCoin = try await cryptoService.fetchCoin(id: id)
        switch tradeOption {
        case .buy:
            try await getBuyCoin(id: id)
        case .sell:
            try await getSellCoin(id: id)
        }
        maxValue = walletSourceCoin?.amount ?? 0
    }

    @MainActor
    func buy(id: String) async throws {
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
            try await getCoin(id: walletDestinationCoin.id)
        case .sell:
            try await getCoin(id: walletSourceCoin.id)
        }
    }

    // MARK: Private interface

    @MainActor
    private func getBuyCoin(id: String) async throws {
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
    }
    
    @MainActor
    private func getSellCoin(id: String) async throws {
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
                Color.buy
            case .sell:
                Color.sell
            }
        }
    }
}
