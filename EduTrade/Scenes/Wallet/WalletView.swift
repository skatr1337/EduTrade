//
//  WalletView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 22/12/2024.
//

import SwiftUI

struct WalletView<ViewModel: WalletViewModelProtocol>: View {
    @EnvironmentObject var coordinator: MainCoordinator
    @ObservedObject var viewModel: ViewModel
    @State private var toast: Toast?

    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            VStack {
                header
                wallet
            }
            .task {
                await getAccount()
            }
            .refreshable {
                await getAccount()
            }
            .toastView(toast: $toast)
        }
    }

    private func getAccount() async {
        do {
            try await viewModel.getAccount()
        } catch {
            toast = Toast(style: .error, message: error.localizedDescription)
        }
    }

    @ViewBuilder
    private var header: some View {
        ZStack {
            VStack {
                Text("Total value")
                    .font(.headline)
                    .fontWeight(.heavy)
                Text(viewModel.totalValue.asCurrencyWith2Decimals())
                    .font(.headline)
                    .fontWeight(.heavy)
                    .accessibilityIdentifier("totalValue")
            }
            Button {
                Task {
                    coordinator.presentFullScreenCover(.transations)
                }
            } label: {
                Image(systemName: "list.bullet.clipboard")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
        }
       
    }
    
    @ViewBuilder
    private var wallet: some View {
        List(viewModel.walletCoins) { coin in
            WalletRowView(walletCoin: coin)
        }
        .listStyle(PlainListStyle())
        .accessibilityIdentifier("walletList")
    }
}
#Preview {
    return WalletView(
        viewModel: WalletViewModel(
        cryptoService: CryptoService(),
        walletService: WalletService(
            uid: "C1CzQbWAdqR2obB2Nh9Cu9ACvof2"
            )
        )
    )
}

