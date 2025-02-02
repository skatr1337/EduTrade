//
//  WalletServiceMock.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 18.01.2025.
//

@testable import EduTrade

class WalletServiceMock: WalletServiceProtocol {
    var calledMethods: [String] = []

    var defaultCoinId: String = "dollar"
    
    func makeInitialCryptos() async throws {
        calledMethods.append(#function)
    }
    
    func makeExchange(operation: WalletService.ExchangeOpetation) async throws {
        calledMethods.append(#function)
        switch operation.operation {
        case .buy:
            updateDefaultCrypto(amount: defaultCrypto.amount - operation.sourceAmount)
            updateCrypto(
                amount: (crypto?.amount ?? 0) + operation.destinationAmount,
                base: operation.destinationCoin
            )
        case .sell:
            updateDefaultCrypto(amount: defaultCrypto.amount + operation.destinationAmount)
            updateCrypto(
                amount: (crypto?.amount ?? 0) - operation.sourceAmount,
                base: operation.sourceCoin
            )
        }
    }

    var account = AccountDTO(cryptos: [:], transactions: [])
    func getAccount() async throws -> AccountDTO {
        calledMethods.append(#function)
        return account
    }

    var defaultCrypto = AccountDTO.CryptoDTO(id: "dollar", symbol: "usd", amount: 0.0)
    func getDefaultCoin() async throws -> AccountDTO.CryptoDTO {
        calledMethods.append(#function)
        return defaultCrypto
    }

    var crypto: AccountDTO.CryptoDTO? = AccountDTO.CryptoDTO(id: "bitcoin", symbol: "btc", amount: 0.0)
    func getCoin(id: String) async throws -> AccountDTO.CryptoDTO? {
        calledMethods.append(#function)
        return crypto
    }

    private func updateDefaultCrypto(amount: Double) {
        defaultCrypto = AccountDTO.CryptoDTO(
            id: defaultCrypto.id,
            symbol: defaultCrypto.symbol,
            amount: amount
        )
    }

    private func updateCrypto(amount: Double, base: AccountDTO.CryptoDTO) {
        crypto = AccountDTO.CryptoDTO(
            id: crypto?.id ?? base.id,
            symbol: crypto?.symbol ?? base.symbol,
            amount: amount
        )
    }
}
