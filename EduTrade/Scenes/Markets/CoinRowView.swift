//
//  CoinRowView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 21/12/2024.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    
    var body: some View {
        HStack(spacing: 0) {
            crypto
            Spacer()
            price
        }
    }
    
    @ViewBuilder
    private var crypto: some View {
        Text("\(coin.rank)")
            .font(.caption)
            .frame(minWidth: 30)
            .accessibilityIdentifier("rank")
        AsyncImageCached(url: coin.image) { phase in
            if let image = phase.image {
                image.resizable()
            } else if phase.error != nil {
                EmptyView()
            } else {
                ProgressView()
            }
        }
            .frame(width: 30, height: 30)
        Text(coin.symbol.uppercased())
            .font(.headline)
            .padding(.leading, 6)
    }

    @ViewBuilder
    private var price: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
            Text(coin.priceChangePercentage.asPercentString())
                .foregroundColor(coin.isPriceChangePosive ? Color.green : Color.red)
        }
    }
}

#Preview {
    let imageString = "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
    guard let image = URL(string: imageString) else { return EmptyView()
    }

    return CoinRowView(
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
