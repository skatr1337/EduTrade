//
//  WalletViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 23/12/2024.
//
import SwiftUI

struct WalletCoin: Identifiable {
    let id = UUID()
    let symbol: String
    let image: SymbolImage
    let amount: Double
    let value: Double

    enum SymbolImage {
        case imegeUrl(URL)
        case image(Image)
    }
}

class WalletViewModel: ObservableObject {
    let cryptoService: CryptoServiceProtocol
    let walletService: WalletServiceProtocol
    
    @MainActor @Published
    var walletCoins: [WalletCoin] = []
    
    @MainActor @Published
    var totalValue: Double = 0
    
    init(
        cryptoService: CryptoServiceProtocol,
        walletService: WalletServiceProtocol
    ) {
        self.cryptoService = cryptoService
        self.walletService = walletService
    }

    @MainActor
    func getAccount() async throws {
        let receivedCoins = try await cryptoService.fetchList()
        let recivedAccount = try await walletService.getAccount()
        walletCoins = makeWalletCoins(account: recivedAccount, coins: receivedCoins)
        totalValue = makeTotalValue()
    }
    
    private func makeWalletCoins(
        account: AccountDTO,
        coins: [CoinMarketsDTO]
    ) -> [WalletCoin] {
        var defaultCoins: [WalletCoin] = []
        var results: [WalletCoin] = []

        account.cryptos.forEach {
            if walletService.defaultCoinId == $0.key {
                defaultCoins = [creteateDefautlCoin(crypto: $0.value)]
                return
            }
            guard
                let price = getCurrentPrice(id: $0.key, coins: coins),
                let url = getImage(id: $0.key, coins: coins)
            else {
                return
            }
            results.append(
                WalletCoin(
                    symbol: $0.value.symbol,
                    image: .imegeUrl(url),
                    amount: $0.value.amount,
                    value: $0.value.amount * price
                )
            )
        }
        return defaultCoins + results.sorted { $0.value > $1.value }
    }

    private func creteateDefautlCoin(crypto: AccountDTO.CryptoDTO) -> WalletCoin {
        WalletCoin(
            symbol: crypto.id,
            image: .image(Image(systemName: "dollarsign")),
            amount: crypto.amount,
            value: crypto.amount
        )
    }
    
    private func getCurrentPrice(id: String, coins: [CoinMarketsDTO]) -> Double? {
        return coins.first { $0.id == id }?.current_price
    }

    private func getImage(id: String, coins: [CoinMarketsDTO]) -> URL? {
        let coin = coins.first { $0.id == id }
        guard let coin else { return nil }
        return URL(string: coin.image)
    }

    @MainActor
    private func makeTotalValue() -> Double {
        walletCoins.reduce(0) { $0 + $1.value }
    }
}
