//
//  TradeView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 08.12.2024.
//

import SwiftUI

struct TradeView<ViewModel: TradeViewModelProtocol>: View, InspectableView {
    @ObservedObject var viewModel: ViewModel
    @State var inProgress = false
    @State private var toast: Toast?

    let coin: Coin
    var didAppear: ((Self) -> Void)?

    var body: some View {
        VStack {
            currentPrice
            walletSource
            walletDestination
            tradeOptionPicker
            amountSlider
            amountButtons
            textField
            tradeOptionButton
            Spacer()
        }
        .padding()
        .task {
            await getCoin()
        }
        .onAppear {
            didAppear?(self)
        }
        .toastView(toast: $toast)
    }

    func getCoin() async {
        do {
            try await viewModel.getCoin(id: coin.id)
            toast = nil
        } catch {
            toast = Toast(style: .error, message: error.localizedDescription)
        }
    }
    
    @ViewBuilder
    private var currentPrice: some View {
        if let coin = viewModel.exchangeCoin {
            let price = coin.current_price.asCurrencyWith6Decimals()
            HStack {
                Text("Price: \(price)")
                    .font(Font.system(size: 20, weight: .heavy, design: .default))
                    .accessibilityIdentifier("currentPrice")
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
                    .accessibilityIdentifier("from")
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var walletDestination: some View {
        HStack {
            if let coin = viewModel.walletDestinationCoin {
                Text("To \(coin.symbol.uppercased()): \(coin.amount.as6Decimals())")
                    .accessibilityIdentifier("to")
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
                await getCoin()
            }
        }
        .accessibilityIdentifier("picker")
        .padding()
    }
    
    @ViewBuilder
    private var amountSlider: some View {
        Slider(
            value: $viewModel.currentValueSlider,
            in: 0...viewModel.maxValueSlider
        )
        .accessibilityIdentifier("slider")
        .disabled(inProgress)
    }

    @ViewBuilder
    private var amountButtons: some View {
        HStack {
            ForEach(viewModel.percentageButtons, id: \.self) { percentage in
                Button("\(Int(percentage * 100))%") {
                    Task {
                        await viewModel.percentage(percentage)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .foregroundColor(Color.black)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .accessibilityIdentifier("\(Int(percentage * 100))%")
                .disabled(inProgress)
            }
        }
    }
    
    @ViewBuilder
    private var textField: some View {
        TextField(
            "0.000000",
            value: $viewModel.currentValue,
            format: .number
        )
        .onChange(of: viewModel.currentValue, initial: false) {
            if viewModel.currentValue > viewModel.maxValue {
                viewModel.currentValue = viewModel.maxValue
            }
        }
        .disabled(inProgress)
        .keyboardType(.decimalPad)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(maxWidth: 150)
        .font(Font.system(size: 20, design: .default))
        .accessibilityIdentifier("textField")
        .padding()
        HStack {
            if let symbol = viewModel.walletDestinationCoin?.symbol.uppercased() {
                Text("\(viewModel.destinationValue.as6Decimals()) \(symbol)")
                    .accessibilityIdentifier("amount")
            }
        }
    }
    
    @ViewBuilder
    private var tradeOptionButton: some View {
        let color = inProgress ? .black : viewModel.tradeOption.color
        Button {
            Task {
                inProgress = true
                let value = viewModel.tradeOption == .buy ? viewModel.destinationValue : viewModel.currentValue
                do {
                    try await viewModel.buy(id: coin.id)
                    showSuccess(value: value)
                } catch {
                    toast = Toast(style: .error, message: error.localizedDescription)
                }
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
        .accessibilityIdentifier("tradeButton")
        .disabled(
            viewModel.maxValue.isZero ||
            viewModel.currentValue.isZero ||
            inProgress
        )
    }

    func showSuccess(value: Double) {
        switch viewModel.tradeOption {
        case .buy:
            toast = Toast(style: .success, message: "You have bought \(value.as6Decimals()) \(coin.symbol.uppercased()) !!!")
        case .sell:
            toast = Toast(style: .success, message: "You have sold \(value.as6Decimals()) \(coin.symbol.uppercased()) !!!")
        }
    }
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
