//
//  MarketsView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import SwiftUI

struct MarketsView: View {
    @EnvironmentObject var coordinator: MainCoordinator
    @ObservedObject var viewModel: MarketsViewModel
    @State private var toast: Toast? = nil
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            VStack {
                header
                coins
            }
        }
        .task {
            toast = Toast(style: .success, message: "Saved.", width: 160)
            await viewModel.refresh()
        }
        .refreshable {
            await viewModel.refresh()
        }
        .toastView(toast: $toast)
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
    return MarketsView(
        viewModel: MarketsViewModel(
            cryptoService: CryptoService(),
            walletService: WalletService(
                uid: "C1CzQbWAdqR2obB2Nh9Cu9ACvof2"
            )
        )
    )
}

