//
//  WalletViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 23/12/2024.
//
import Foundation

struct WalletCoin: Identifiable {
    let id = UUID()
    let symbol: String
    let image: URL
    let amount: Double
    let value: Double
}

class WalletViewModel: ObservableObject {
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
    var walletCoins: [WalletCoin] = []
    
    @MainActor
    func getAccount() async {
        guard
            let receivedCoins = try? await cryptoService.fetchList(),
            let recivedAccount = try? await accountService.getAccount()
        else {
            walletCoins = []
            return
        }
        walletCoins = makeWalletCoins(account: recivedAccount, coins: receivedCoins)
    }
    
    private func makeWalletCoins(
        account: AccountDTO,
        coins: [CoinMarketsDTO]
    ) -> [WalletCoin] {
        var results: [WalletCoin] = []

        account.cryptos.forEach {
            guard
                let price = getCurrentPrice(id: $0.id, coins: coins),
                let url = getImage(id: $0.id, coins: coins)
            else {
                return
            }
            results.append(
                WalletCoin(
                    symbol: $0.symbol,
                    image: url,
                    amount: $0.amount,
                    value: $0.amount * price
                )
            )
        }
        return results
    }

    func getCurrentPrice(id: String, coins: [CoinMarketsDTO]) -> Double? {
        coins.first { $0.id == id }?.current_price
    }

    func getImage(id: String, coins: [CoinMarketsDTO]) -> URL? {
        let coin = coins.first { $0.id == id }
        guard let coin else { return nil }
        return URL(string: coin.image)
    }
}
