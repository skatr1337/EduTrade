//
//  WalletView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 22/12/2024.
//

import SwiftUI

struct WalletView: View {
    @EnvironmentObject var coordinator: MainCoordinator
    @ObservedObject var viewModel: WalletViewModel
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            VStack {
                header
                wallet
            }
            .task {
                await viewModel.getAccount()
            }
            .refreshable {
                await viewModel.getAccount()
            }
        }
    }
    
    @ViewBuilder
    private var header: some View {
        VStack {
            Text("Total value")
                .font(.headline)
                .fontWeight(.heavy)
        }
    }
    
    @ViewBuilder
    private var wallet: some View {
        List(viewModel.walletCoins) { coin in
            WalletRowView(walletCoin: coin)
        }
        .listStyle(PlainListStyle())
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

