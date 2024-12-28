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
    func getAccount() async throws -> AccountDTO?
    func getDefaultCoin() async -> AccountDTO.CryptoDTO?
    func getCoin(id: String) async -> AccountDTO.CryptoDTO?
}

class WalletService: WalletServiceProtocol {
    private let uid: String
    private let accountsCollection: CollectionReference
    private var currentAccount: AccountDTO?

    var defaultCoinId = "dollar"
    var defaultSymbol = "usd"
    private let defaultAmount: Double = 1000

    init(uid: String) {
        self.uid = uid
        self.accountsCollection = Firestore.firestore().collection("accounts")
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
        if let currentAccount = await getAccount() {
            var cryptos = currentAccount.cryptos
            
            if let sourceAmount = cryptos[operation.sourceCoin.id]?.amount {
                cryptos[operation.sourceCoin.id]?.amount = sourceAmount - operation.sourceAmount
            } else {
                throw OperationError.sourceCoinNotFound
            }
            
            if let destinationAmount = cryptos[operation.destinationCoin.id]?.amount {
                cryptos[operation.destinationCoin.id]?.amount = destinationAmount + operation.destinationAmount
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
    
    func getAccount() async -> AccountDTO? {
        guard let snapshot = try? await snapshot() else {
            return nil
        }
        
        let account = try? snapshot.data(as: AccountDTO.self)
        currentAccount = account
        return account
    }

    func getCoin(id: String) async -> AccountDTO.CryptoDTO? {
        await getAccount()?.cryptos[id]
    }

    func getDefaultCoin() async -> AccountDTO.CryptoDTO? {
        await getAccount()?.cryptos[defaultCoinId]
    }
    
    private func snapshot() async throws -> DocumentSnapshot? {
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

    enum OperationError: Error {
        case sourceCoinNotFound
        case destinationCoinNotFound
    }
}
