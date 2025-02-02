//
//  WalletRowView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 23/12/2024.
//

import SwiftUI

struct WalletRowView: View {
    let walletCoin: WalletCoin
    
    var body: some View {
        HStack(spacing: 0) {
            crypto
            Spacer()
            amount
        }
    }
    
    @ViewBuilder
    private var crypto: some View {
        switch walletCoin.image {
            case let .image(image):
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 20)
            case let .imegeUrl(url):
            AsyncImageCached(url: url) { phase in
                if let image = phase.image {
                    image.resizable()
                } else if phase.error != nil {
                    EmptyView()
                } else {
                    ProgressView()
                }
            }
            .frame(width: 30, height: 30)
        }
        Text(walletCoin.symbol.uppercased())
            .font(.headline)
            .padding(.leading, 6)
    }
    
    @ViewBuilder
    private var amount: some View {
        VStack(alignment: .trailing) {
            Text(amountString)
                .font(.headline)
                .padding(.trailing, 6)
                .accessibilityIdentifier("amount")
            Text(walletCoin.value.asCurrencyWith2Decimals())
                .font(.headline)
                .padding(.trailing, 6)
                .accessibilityIdentifier("value")
        }
    }

    private var amountString: String {
        if walletCoin.isFiatCurrency {
            return walletCoin.amount.as2Decimals()
        } else {
            return walletCoin.amount.as6Decimals()
        }
    }
}
#Preview {
    let imageString = "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
    guard let url = URL(string: imageString) else { return EmptyView()
    }
    
    return WalletRowView(
        walletCoin: WalletCoin(
            symbol: "usdt",
            image: .imegeUrl(url),
            amount: 1000,
            value: 1000,
            isFiatCurrency: false
        )
    )
}

