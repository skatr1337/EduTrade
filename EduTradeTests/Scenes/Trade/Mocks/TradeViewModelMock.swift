//
//  TradeViewModelMock.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 01.02.2025.
//

@testable import EduTrade

class TradeViewModelMock: TradeViewModelProtocol {
    var calledMethods: [String] = []

    var tradeOption: TradeViewModel.TradeOption = .buy
    var exchangeCoin: CoinMarketsDTO?
    var walletSourceCoin: AccountDTO.CryptoDTO?
    var walletDestinationCoin: AccountDTO.CryptoDTO?
    var currentValue = 0.0
    var currentValueSlider = 0.0
    var destinationValue = 0.0
    var maxValue = 0.0
    var maxValueSlider = 0.0
    var percentageButtons: [Double] = []

    func percentage(_ percentage: Double) async {
        calledMethods.append(#function)
    }

    var getCoinResult: CoinMarketsDTO?
    func getCoin(id: String) async throws {
        exchangeCoin = getCoinResult
        calledMethods.append(#function)
    }
    
    func buy(id: String) async throws {
        calledMethods.append(#function)
    }
}
