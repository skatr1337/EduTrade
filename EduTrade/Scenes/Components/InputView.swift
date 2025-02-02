//
//  InputView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 01/12/2024.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
                .accessibilityIdentifier("text")
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .accessibilityIdentifier("secureField")
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .accessibilityIdentifier("textField")
            }
            
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
