//
//  Date+Extensions.swift
//  EduTrade
//
//  Created by Filip Biegaj on 29/12/2024.
//

import Foundation

extension Date {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.locale = Locale()
        return formatter
    }()

    var toString: String {
        Date.dateFormatter.string(from: self)
    }
}
