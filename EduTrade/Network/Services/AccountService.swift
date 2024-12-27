//
//  AccountService.swift
//  EduTrade
//
//  Created by Filip Biegaj on 14.12.2024.
//

import FirebaseFirestore

protocol AccountServiceProtocol {
    func updateInitialCryptos() async throws
    func updateCryptos(cryptos: Set<AccountDTO.CryptoDTO>) async throws
    func getAccount() async throws -> AccountDTO?
    func getDefaultCoin() async -> AccountDTO.CryptoDTO?
    func getCoin(id: String) async -> AccountDTO.CryptoDTO?
}

class AccountService: AccountServiceProtocol {
    private let uid: String
    private let accountsCollection: CollectionReference
    private var defaultCoinId = "tether"
    private var currentAccount: AccountDTO?

    init(uid: String) {
        self.uid = uid
        self.accountsCollection = Firestore.firestore().collection("accounts")
    }

    func updateInitialCryptos() async throws {
        let cryptos: Set<AccountDTO.CryptoDTO> = [
            AccountDTO.CryptoDTO(
                id: defaultCoinId,
                symbol: "usdt",
                amount: 1000
            )
        ]
        try await updateCryptos(cryptos: cryptos)
    }

    func updateCryptos(cryptos: Set<AccountDTO.CryptoDTO>) async throws {
        let account = AccountDTO(cryptos: Array(cryptos))
        let encodedAccount = try Firestore.Encoder().encode(account)
        if await getAccount() != nil {
            // account already created
            try await accountsCollection.document(uid).updateData(encodedAccount)
        } else {
            // new account
            try await accountsCollection.document(uid).setData(encodedAccount)
        }
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
        var current: AccountDTO?
        if let currentAccount {
            current = currentAccount
        } else {
            current = await getAccount()
        }
        return current?.cryptos.first { $0.id == id }
    }

    func getDefaultCoin() async -> AccountDTO.CryptoDTO? {
        await getAccount()?.cryptos.first { $0.id == defaultCoinId }
    }
    
    private func snapshot() async throws -> DocumentSnapshot? {
        try await accountsCollection.document(uid).getDocument()
    }
}
