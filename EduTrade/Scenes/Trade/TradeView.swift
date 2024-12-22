//
//  TradeView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 08.12.2024.
//

import SwiftUI

struct TradeView: View {
    @EnvironmentObject var coordinator: MainCoordinator
    let coin: Coin

    var body: some View {
        Text("Trade \(coin.symbol)")
    }
}

#Preview {
    let imageString = "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
    guard let image = URL(string: imageString) else { return EmptyView()
    }

    return TradeView(
        coin: Coin(
            rank: 1,
            symbol: "btc",
            image: image,
            currentPrice: 97000,
            priceChangePercentage: -1.39234,
            isPriceChangePosive: false
        )
    )
}
