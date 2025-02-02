//
//  TransactionsViewModelTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 30.01.2025.
//

import Foundation
@testable import EduTrade
import Testing

struct TransactionsViewModelTests: TestData {
    let walletServiceMock: WalletServiceMock
    let transactionsViewModel: TransactionsViewModel
    static let testDate = Date()

    init() {
        walletServiceMock = WalletServiceMock()
        transactionsViewModel = TransactionsViewModel(walletService: walletServiceMock)
    }

    @Test(
        "Test getTransactions",
        arguments: zip(
            [
                [transactionPayment(date: testDate)],
                [
                    transactionPayment(date: testDate),
                    transactionExchangeBuy(date: testDate),
                    transactionExchangeSell(date: testDate)
                ]
            ] as [[AccountDTO.TransactionDTO]],
            [
                [
                    makeTransaction(transactionPayment(date: testDate))
                ],
                [
                    makeTransaction(transactionPayment(date: testDate)),
                    makeTransaction(transactionExchangeBuy(date: testDate)),
                    makeTransaction(transactionExchangeSell(date: testDate))
                ]
            ]
            as [[Transaction]]
        )
    )
    @MainActor
    func getTransactions(
        transactionsDto: [AccountDTO.TransactionDTO],
        transactions: [Transaction]
    ) async throws {
        // Given
        walletServiceMock.account = AccountDTO(cryptos: [:], transactions: transactionsDto)

        // When
        try await transactionsViewModel.getTransactions()

        // then
        #expect(transactionsViewModel.transactions == transactions)
    }
}
