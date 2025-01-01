//
//  View+Extension.swift
//  EduTrade
//
//  Created by Filip Biegaj on 01/01/2025.
//

import SwiftUI

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
