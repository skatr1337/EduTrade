//
//  CoinsMarketsDTO.swift
//  EduTrade
//
//  Created by Filip Biegaj on 28/11/2024.
//
import Foundation

struct PingDTO: Codable, Equatable {
    let gecko_says: String
}

struct CoinMarketsDTO: Codable, Equatable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let market_cap: Double
    let market_cap_rank: Int
    let fully_diluted_valuation: Double
    let total_volume: Double
    let high_24h: Double
    let low_24h: Double
    let price_change_24h: Double
    let price_change_percentage_24h: Double
    let market_cap_change_24h: Double
    let market_cap_change_percentage_24h: Double
    let circulating_supply: Double
    let total_supply: Double
    let ath: Double
    let ath_change_percentage: Double
    let ath_date: String
    let atl: Double
    let atl_change_percentage: Double
    let atl_date: String
    let last_updated: String
}

