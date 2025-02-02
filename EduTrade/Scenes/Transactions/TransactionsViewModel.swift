//
//  TransactionsViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 29/12/2024.
//

import Foundation

struct Transaction: Identifiable {
    let id = UUID()
    let timeStamp: Date
    let pair: String
    let operation: TransactionOperation
    let sourceAmount: Double?
    let destinationAmount: Double
    let price: Double?
}

extension Transaction: Equatable {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.timeStamp == rhs.timeStamp &&
        lhs.pair == rhs.pair &&
        lhs.operation == rhs.operation &&
        lhs.sourceAmount == rhs.sourceAmount &&
        lhs.destinationAmount == rhs.destinationAmount &&
        lhs.price == rhs.price
    }
}

enum TransactionOperation: String {
    case buy = "Buy"
    case sell = "Sell"
    case payment = "Payment"
}

extension AccountDTO.Operation {
    var toTransactionOperation: TransactionOperation {
        switch self {
        case .buy:
            .buy
        case .sell:
            .sell
        }
    }
}

protocol TransactionsViewModelProtocol: ObservableObject {
    var transactions: [Transaction] { get }
    func getTransactions() async throws
}

class TransactionsViewModel: TransactionsViewModelProtocol {
    private let walletService: WalletServiceProtocol
    
    @MainActor @Published
    private(set) var transactions: [Transaction] = []
    
    init(walletService: WalletServiceProtocol) {
        self.walletService = walletService
    }

    @MainActor
    func getTransactions() async throws {
        let recivedAccount = try await walletService.getAccount()
        transactions = makeTransactions(transactions: recivedAccount.transactions)
    }

    @MainActor
    private func makeTransactions(transactions: [AccountDTO.TransactionDTO]) -> [Transaction] {
        let array = transactions.map {
            switch $0 {
            case let .payment(transaction):
                return Transaction(
                    timeStamp: transaction.timeStamp,
                    pair: transaction.destinationCoinId,
                    operation: .payment,
                    sourceAmount: nil,
                    destinationAmount: transaction.destinationAmount,
                    price: nil
                )
            case let .exchange(transaction):
                return Transaction(
                    timeStamp: transaction.timeStamp,
                    pair: "\(transaction.sourceCoinId)/\(transaction.destinationCoinId)",
                    operation: transaction.operation.toTransactionOperation,
                    sourceAmount: transaction.sourceAmount,
                    destinationAmount: transaction.destinationAmount,
                    price: transaction.price
                )
            }
        }
        return array.sorted { $0.timeStamp > $1.timeStamp }
    }
}
