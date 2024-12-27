//
//  TradeView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 08.12.2024.
//

import SwiftUI

struct TradeView: View {
    @EnvironmentObject var coordinator: MainCoordinator
    @ObservedObject var viewModel: TradeViewModel
    let coin: Coin

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let sourceCoin = viewModel.sourceCoin {
                    Text("\(sourceCoin.symbol):")
                    Text(sourceCoin.amount.asCurrencyWith6Decimals())
                }
            }
            HStack {
                Text("\(coin.symbol):")
                Text(coin.currentPrice.asCurrencyWith6Decimals())
            }
            HStack {
                Picker("", selection: $viewModel.tradeOption) {
                    ForEach(TradeViewModel.TradeOption.allCases) {
                        Text(String(describing: $0))
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.tradeOption) { _, id in
                    Task {
                        await viewModel.getCoin(id: coin.id)
                    }
                }
                .padding()
            }
            Slider(
                value: $viewModel.currentValue,
                in: 0...viewModel.maxValue
            )
            TextField (
                "0.00",
                value: $viewModel.currentValue,
                formatter: amountFormatter
            )
            .keyboardType(.decimalPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(maxWidth: 100)
            Button {

            } label: {
                Text(viewModel.tradeOption.description)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
            }
            .buttonStyle(.borderedProminent)
            .tint(viewModel.tradeOption.color)
            Spacer()
        }
        .padding()
        .task {
            await viewModel.getCoin(id: coin.id)
        }
    }

    let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()
}

#Preview {
    let imageString = "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
    guard let image = URL(string: imageString) else { return EmptyView()
    }

    return TradeView(
        viewModel: TradeViewModel(
            cryptoService: CryptoService(),
            accountService: AccountService(
                uid: "C1CzQbWAdqR2obB2Nh9Cu9ACvof2"
            )
        ),
        coin: Coin(
            id: "bitcoin",
            rank: 1,
            symbol: "btc",
            image: image,
            currentPrice: 97000,
            priceChangePercentage: -1.39234,
            isPriceChangePosive: false
        )
    )
}
