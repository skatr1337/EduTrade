//
//  HomeView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: MainCoordinator
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            VStack {
                header
                coins
            }
        }
        .task {
            await viewModel.refresh()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    @ViewBuilder
    private var header: some View {
        VStack {
            Text("Live prices")
                .font(.headline)
                .fontWeight(.heavy)
        }
    }

    @ViewBuilder
    private var coins: some View {
        List(viewModel.coins) { coin in
            Button {
                Task {
                    coordinator.push(screen: .trade(coin: coin))
                }
            } label: {
                CoinRowView(coin: coin)
            }
        }
        .listStyle(PlainListStyle())
    }
}

#Preview {
    return HomeView(
        viewModel: HomeViewModel(
            cryptoService: CryptoService(),
            walletService: WalletService(
                uid: "C1CzQbWAdqR2obB2Nh9Cu9ACvof2"
            )
        )
    )
}

