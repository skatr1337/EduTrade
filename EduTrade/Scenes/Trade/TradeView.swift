//
//  TradeView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 08.12.2024.
//

import SwiftUI

struct TradeView: View {
    @ObservedObject var viewModel: TradeViewModel
    @State var inProgress = false
    @State private var toast: Toast? = nil

    let coin: Coin

    var body: some View {
        VStack {
            currentPrice
            walletSource
            walletDestination
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
    private var walletSource: some View {
        HStack {
            if let coin = viewModel.walletSourceCoin {
                Text("From \(coin.symbol.uppercased()): \(coin.amount.as6Decimals())")
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var walletDestination: some View {
        HStack {
            if let coin = viewModel.walletDestinationCoin {
                Text("To \(coin.symbol.uppercased()): \(coin.amount.as6Decimals())")
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var tradeOptionPicker: some View {
        Picker("", selection: $viewModel.tradeOption) {
            ForEach(TradeViewModel.TradeOption.allCases) {
                Text($0.description)
            }
        }
        .disabled(inProgress)
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
            value: $viewModel.currentValueSlider,
            in: 0...viewModel.maxValueSlider
        )
        .disabled(inProgress)
        
        HStack {
            ForEach([0.25, 0.5, 0.75, 1.0], id: \.self) { percentage in
                Button("\(Int(percentage * 100))%") {
                    viewModel.percentage(percentage)
                }
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .foregroundColor(Color.black)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .disabled(inProgress
                )
            }
        }

        TextField (
            "0.000000",
            value: $viewModel.currentValue,
            format: .number
//            formatter: amountFormatter
        )
        .disabled(inProgress)
        .keyboardType(.decimalPad)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(maxWidth: 150)
        .font(Font.system(size: 20, design: .default))
        .padding()
        HStack {
            if let symbol = viewModel.walletDestinationCoin?.symbol.uppercased() {
                Text("\(viewModel.destinationValue.as6Decimals()) \(symbol)")
            }
        }
    }
    
    @ViewBuilder
    private var tradeOptionButton: some View {
        let color = inProgress ? .black : viewModel.tradeOption.color
        Button {
            Task {
                inProgress = true
                await viewModel.buy(id: coin.id)
                inProgress = false
            }
        } label: {
            if inProgress {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
            } else {
                Text(viewModel.tradeOption.description(symbol: coin.symbol.uppercased()))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(color)
        .disabled(
            viewModel.maxValue.isZero ||
            viewModel.currentValue.isZero ||
            inProgress
        )
    }

//    var amountFormatter: NumberFormatter {
//        let formatter = NumberFormatter()
//        formatter.zeroSymbol = ""
//        formatter.maximum = NSNumber(value: viewModel.maxValue)
//        formatter.locale = Locale()
//        return formatter
//    }
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
