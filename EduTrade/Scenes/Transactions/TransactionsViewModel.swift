//
//  TransactionsViewModel.swift
//  EduTrade
//
//  Created by Filip Biegaj on 29/12/2024.
//

import Foundation

class TransactionsViewModel: ObservableObject {
    let walletService: WalletServiceProtocol
    
    init(
        walletService: WalletServiceProtocol
    ) {
        self.walletService = walletService
    }
}
