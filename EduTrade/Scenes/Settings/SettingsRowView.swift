//
//  SettingsRowView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 01/12/2024.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(.red)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign out")
}
