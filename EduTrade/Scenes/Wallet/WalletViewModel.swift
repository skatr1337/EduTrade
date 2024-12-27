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
    
    init(
        cryptoService: CryptoServiceProtocol,
        walletService: WalletServiceProtocol
    ) {
        self.cryptoService = cryptoService
        self.walletService = walletService
    }
    
    @MainActor @Published
    var walletCoins: [WalletCoin] = []
    
    @MainActor
    func getAccount() async {
        guard
            let receivedCoins = try? await cryptoService.fetchList(),
            let recivedAccount = try? await walletService.getAccount()
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
            if walletService.defaultCoinId == $0.id {
                results.append(creteateDefautlCoin(crypto: $0))
                return
            }
            guard
                let price = getCurrentPrice(id: $0.id, coins: coins),
                let url = getImage(id: $0.id, coins: coins)
            else {
                return
            }
            results.append(
                WalletCoin(
                    symbol: $0.symbol,
                    image: .imegeUrl(url),
                    amount: $0.amount,
                    value: $0.amount * price
                )
            )
        }
        return results
    }

    private func creteateDefautlCoin(crypto: AccountDTO.CryptoDTO) -> WalletCoin {
        WalletCoin(
            symbol: crypto.id,
            image: .image(Image(systemName: "dollarsign")),
            amount: crypto.amount,
            value: crypto.amount
        )
    }
    
    func getCurrentPrice(id: String, coins: [CoinMarketsDTO]) -> Double? {
        return coins.first { $0.id == id }?.current_price
    }

    func getImage(id: String, coins: [CoinMarketsDTO]) -> URL? {
        let coin = coins.first { $0.id == id }
        guard let coin else { return nil }
        return URL(string: coin.image)
    }
}
