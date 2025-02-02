//
//  WalletService.swift
//  EduTrade
//
//  Created by Filip Biegaj on 14.12.2024.
//

import FirebaseFirestore

protocol WalletServiceProtocol {
    var defaultCoinId: String { get }
    func makeInitialCryptos() async throws
    func makeExchange(operation: WalletService.ExchangeOpetation) async throws
    func getAccount() async throws -> AccountDTO
    func getDefaultCoin() async throws -> AccountDTO.CryptoDTO
    func getCoin(id: String) async throws -> AccountDTO.CryptoDTO?
}

protocol CollectionReferenceProtocol {
    func document (_ id: String) -> DocumentReference
}

class WalletService: WalletServiceProtocol {
    private let uid: String
    private let accountsCollection: CollectionReferenceProtocol
    private var currentAccount: AccountDTO?

    let defaultCoinId = "dollar"
    let defaultSymbol = "usd"
    private let defaultAmount: Double = 1000

    init(
        uid: String,
        accountsCollection: CollectionReferenceProtocol = Firestore.firestore().collection("accounts")
    ) {
        self.uid = uid
        self.accountsCollection = accountsCollection
    }

    func makeInitialCryptos() async throws {
        let cryptos: [String: AccountDTO.CryptoDTO] = [
            defaultCoinId:
                AccountDTO.CryptoDTO(
                    id: defaultCoinId,
                    symbol: defaultSymbol,
                    amount: defaultAmount
                )
        ]
        let transation = AccountDTO.TransactionDTO.payment(
            AccountDTO.PaymentTransactionDTO(
                timeStamp: Date(),
                destinationAmount: defaultAmount,
                destinationCoinId: defaultCoinId
            )
        )
        try await updateInitialCryptos(cryptos: cryptos, transaction: transation)
    }
    
    func makeExchange(
        operation: ExchangeOpetation
    ) async throws {
        let transation = AccountDTO.TransactionDTO.exchange(
            AccountDTO.ExchangeTransactionDTO(
                timeStamp: Date(),
                sourceAmount: operation.sourceAmount,
                destinationAmount: operation.destinationAmount,
                sourceCoinId: operation.sourceCoin.id,
                destinationCoinId: operation.destinationCoin.id,
                price: operation.sourceAmount / operation.destinationAmount,
                operation: operation.operation
            )
        )
        try await updateCryptos(operation: operation, transaction: transation)
    }

    private func updateCryptos(
        operation: ExchangeOpetation,
        transaction: AccountDTO.TransactionDTO
    ) async throws {
        let currentAccount = try await getAccount()
        var cryptos = currentAccount.cryptos
        
        if let sourceAmount = cryptos[operation.sourceCoin.id]?.amount {
            let total = sourceAmount - operation.sourceAmount
            updateCryptos(cryptos: &cryptos, key: operation.sourceCoin.id, value: total)
        } else {
            throw WalletServiceError.coinNotFound
        }
        
        if let destinationAmount = cryptos[operation.destinationCoin.id]?.amount {
            let total = destinationAmount + operation.destinationAmount
            updateCryptos(cryptos: &cryptos, key: operation.destinationCoin.id, value: total)
        } else {
            cryptos[operation.destinationCoin.id] = AccountDTO.CryptoDTO(
                id: operation.destinationCoin.id,
                symbol: operation.destinationCoin.symbol,
                amount: operation.destinationAmount
            )
        }

        let encodedAccount = try makeAccount(
            cryptos: cryptos,
            transactions: currentAccount.transactions + [transaction]
        )
        try await accountsCollection.document(uid).updateData(encodedAccount)
    }

    private func updateCryptos(
        cryptos: inout [String : AccountDTO.CryptoDTO],
        key: String,
        value: Double
    ) {
        if value == 0 && key != defaultCoinId {
            cryptos.removeValue(forKey: key)
        } else {
            cryptos[key]?.amount = value
        }
    }
    
    private func updateInitialCryptos(
        cryptos: [String: AccountDTO.CryptoDTO],
        transaction: AccountDTO.TransactionDTO
    ) async throws {
        let encodedAccount = try makeAccount(
            cryptos: cryptos,
            transactions: [transaction]
        )
        try await accountsCollection.document(uid).setData(encodedAccount)
    }

    func makeAccount(
        cryptos: [String: AccountDTO.CryptoDTO],
        transactions: [AccountDTO.TransactionDTO]
    ) throws -> [String: Any] {
        let account = AccountDTO(
            cryptos: cryptos,
            transactions: transactions
        )
        return try Firestore.Encoder().encode(account)
    }
    
    func getAccount() async throws -> AccountDTO {
        let snapshot = try await snapshot()
        let account = try snapshot.data(as: AccountDTO.self)
        currentAccount = account
        return account
    }

    func getCoin(id: String) async throws -> AccountDTO.CryptoDTO? {
        guard let crypto = try await getAccount().cryptos[id] else {
            return nil
        }
        return crypto
    }

    func getDefaultCoin() async throws -> AccountDTO.CryptoDTO {
        guard let crypto = try await getAccount().cryptos[defaultCoinId] else {
            throw WalletServiceError.defaultCoinNotFound
        }
        return crypto
    }
    
    private func snapshot() async throws -> DocumentSnapshot {
        try await accountsCollection.document(uid).getDocument()
    }
}

extension WalletService {
    struct ExchangeOpetation {
        let sourceCoin: AccountDTO.CryptoDTO
        let sourceAmount: Double
        let destinationCoin: AccountDTO.CryptoDTO
        let destinationAmount: Double
        let operation: AccountDTO.Operation
    }
}

extension WalletService {
    enum WalletServiceError: Error {
        case coinNotFound
        case defaultCoinNotFound
    }

    func localizeddDscription(error: Error) -> String {
        switch error {
        case WalletServiceError.coinNotFound:
            "Coin not found"
        case WalletServiceError.defaultCoinNotFound:
            "Default coin not found"
        default:
            "Unknown error"
        }
    }
}

extension CollectionReference: CollectionReferenceProtocol {}
