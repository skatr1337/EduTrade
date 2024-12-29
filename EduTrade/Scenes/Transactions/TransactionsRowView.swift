//
//  TransactionsRowView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 29/12/2024.
//

import SwiftUI

struct TransactionsRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(transaction.timeStamp.toString)")
                .font(.system(size: 10))
                .padding()
            Text(transaction.pair.uppercased())
                .font(.system(size: 10))
                .padding()
            Spacer()
            Text(transaction.operation.rawValue)
                .font(.system(size: 10))
                .padding()
            VStack {
                Text(" \(transaction.destinationAmount.as6Decimals())")
                    .font(.system(size: 10))
                if let price = transaction.price {
                    Text("Price  \(price.as6Decimals())")
                        .font(.system(size: 10))
                }
            }
            .padding()
        }
    }
}

#Preview {
    TransactionsRowView(transaction: Transaction(
        timeStamp: Date(),
        pair: "usd",
        operation: .buy,
        sourceAmount: 1000,
        destinationAmount: 1000,
        price: 1000))
}
