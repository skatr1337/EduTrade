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
        List(viewModel.walletCoins) { coin in
            WalletRowView(walletCoin: coin)
        }
        .task {
            await viewModel.getAccount()
        }
        .refreshable {
            await viewModel.getAccount()
        }
    }
}

#Preview {
    return WalletView(
        viewModel: WalletViewModel(
        cryptoService: CryptoService(),
        accountService: AccountService(uid: "")
    )
)
}

