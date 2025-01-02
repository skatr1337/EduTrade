//
//  TransactionsView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 29/12/2024.
//

import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject var coordinator: MainCoordinator
    @ObservedObject var viewModel: TransactionsViewModel
    @State private var toast: Toast?
    
    var body: some View {
        Button {
            Task {
                coordinator.dismissFullScreenCover()
            }
        } label: {
           Image(systemName: "xmark")
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
        Spacer()
        List(viewModel.transactions) { transaction in TransactionsRowView(transaction: transaction)
        }
        
        .task {
            await getTransactions()
        }
        .refreshable {
            await getTransactions()
        }
        .toastView(toast: $toast)
    }

    private func getTransactions() async {
        do {
            try await viewModel.getTransactions()
            toast = nil
        } catch {
            toast = Toast(style: .error, message: error.localizedDescription)
        }
    }
}

#Preview {
    TransactionsView(viewModel: TransactionsViewModel(
            walletService: WalletService(
                uid: "C1CzQbWAdqR2obB2Nh9Cu9ACvof2"
            )
        )
    )
}
