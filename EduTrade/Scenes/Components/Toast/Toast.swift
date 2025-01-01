//
//  Toast.swift
//  EduTrade
//
//  Created by Filip Biegaj on 01/01/2025.
//

import Foundation

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}
