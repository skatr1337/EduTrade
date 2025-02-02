//
//  Double+Extensions.swift
//  EduTrade
//
//  Created by Filip Biegaj on 22/12/2024.
//

import Foundation

extension Double {
    private static let currencyCode = "usd"
    private static let currencySymbol = "$"
    
    private static let currencyFormatter2: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = currencyCode
        formatter.currencySymbol = currencySymbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private static let formatter6: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }()

    private static let formatter2: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private static let currencyFormatter6: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.currencySymbol = currencySymbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }()

    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return Double.currencyFormatter2.string(
            from: number
        ) ?? "\(Double.currencySymbol)0.00"
    }

    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return Double.currencyFormatter6.string(
            from: number
        ) ?? "\(Double.currencySymbol)0.00"
    }

    func as6Decimals() -> String {
        let number = NSNumber(value: self)
        return Double.formatter6.string(
            from: number
        ) ?? "\(Double.currencySymbol)0.00"
    }

    func as2Decimals() -> String {
        let number = NSNumber(value: self)
        return Double.formatter2.string(
            from: number
        ) ?? "\(Double.currencySymbol)0.00"
    }

    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }

    func asPercentString() -> String {
        return asNumberString() + "%"
    }
}
