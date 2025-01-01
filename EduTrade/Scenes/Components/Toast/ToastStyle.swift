//
//  ToastStyle.swift
//  EduTrade
//
//  Created by Filip Biegaj on 01/01/2025.
//

import SwiftUI

enum ToastStyle {
    case error
    case warning
    case success
    case info
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error:
            .red
        case .warning:
            .orange
        case .info:
            .blue
        case .success:
            .green
        }
    }
  
    var iconFileName: String {
        switch self {
        case .info:
            "info.circle.fill"
        case .warning:
            "exclamationmark.triangle.fill"
        case .success:
            "checkmark.circle.fill"
        case .error:
            "xmark.circle.fill"
        }
    }
}
