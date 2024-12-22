//
//  HomeViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import Foundation

struct Coin: Identifiable {
    let id = UUID()
    let rank: Int
    let symbol: String
    let image: URL
    let currentPrice: Double
    let priceChangePercentage: Double
    let isPriceChangePosive: Bool
}

class HomeViewModel: ObservableObject {
    let cryptoService: CryptoServiceProtocol
    let accountService: AccountServiceProtocol

    init(
        cryptoService: CryptoServiceProtocol,
        accountService: AccountServiceProtocol

    ) {
        self.cryptoService = cryptoService
        self.accountService = accountService
    }
    
    @MainActor @Published
    var coins: [Coin] = []

    @MainActor
    func refresh() async {
        guard let receivedCoins = try? await cryptoService.fetchCryptoCurrencies() else {
            coins = []
            return
        }
        coins = receivedCoins.toCoins()
    }
}

