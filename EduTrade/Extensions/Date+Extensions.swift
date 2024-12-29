//
//  Date+Extensions.swift
//  EduTrade
//
//  Created by Filip Biegaj on 29/12/2024.
//

import Foundation

extension Date {
    var toString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.locale = Locale()
        return formatter.string(from: self)
    }
}
