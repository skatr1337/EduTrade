//
//  HomeViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import Foundation

struct Coin: Identifiable {
    let id = UUID()
    let name: String
    let current_price: Double
}

class HomeViewModel: ObservableObject {
    let requests = Requests()
    
    @MainActor @Published
    var coins: [Coin] = []

    @MainActor
    func refresh() async {
        guard let receivedCoins = try? await requests.fetchCryptoCurrencies() else {
            coins = []
            return
        }
        coins = receivedCoins.toCoins()
    }
}

