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
        VStack {
            currentPrice
            walletDestination
            walletSource
            tradeOptionPicker
            amountSlider
            tradeOptionButton
            Spacer()
        }
        .padding()
        .task {
            await viewModel.getCoin(id: coin.id)
        }
    }

    @ViewBuilder
    private var currentPrice: some View {
        if let coin = viewModel.exchangeCoin {
            let price = coin.current_price.asCurrencyWith6Decimals()
            HStack {
                Text("Price: \(price)")
                    .font(Font.system(size: 20, weight: .heavy, design: .default))
                Spacer()
            }
            .padding(.bottom)
        }
    }
    
    @ViewBuilder
    private var walletDestination: some View {
        HStack {
            if let coin = viewModel.walletDestinationCoin {
                Text("\(coin.symbol):")
                Text(coin.amount.as6Decimals())
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var walletSource: some View {
        HStack {
            if let coin = viewModel.walletSourceCoin {
                Text("\(coin.symbol):")
                Text(coin.amount.asCurrencyWith6Decimals())
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var tradeOptionPicker: some View {
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
    
    @ViewBuilder
    private var amountSlider: some View {
        Slider(
            value: $viewModel.currentValue,
            in: 0...viewModel.maxValue
        )

        TextField (
            "0.000000",
            value: $viewModel.currentValue,
            formatter: amountFormatter
        )
        .keyboardType(.decimalPad)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(maxWidth: 150)
        .font(Font.system(size: 20, design: .default))
        .padding()
        HStack {
            Text(viewModel.destinationValue.as6Decimals())
            Text("\(coin.symbol)")
        }
    }
    
    @ViewBuilder
    private var tradeOptionButton: some View {
        Button {
            
        } label: {
            Text(viewModel.tradeOption.description(symbol: coin.symbol))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
        }
        .buttonStyle(.borderedProminent)
        .tint(viewModel.tradeOption.color)
        .disabled(viewModel.maxValue == 0)
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
            walletService: WalletService(
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
