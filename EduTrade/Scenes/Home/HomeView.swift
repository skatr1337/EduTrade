//
//  HomeView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            contentView
        }
        .task {
            await viewModel.refresh()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        List(viewModel.coins) { coin in
            HStack {
                Text(coin.name)
                Spacer()
                Text(coin.current_price.formatted())
            }
        }
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(
            cryptoService: CryptoService(), accountService: AccountService(uid: "")
        )
    )
}

