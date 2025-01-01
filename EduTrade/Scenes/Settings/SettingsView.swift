//
//  SettingsView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 08.12.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var coordinator: MainCoordinator

    var body: some View {
        if let user = coordinator.currentUser {
            List {
                Section {
                    HStack{
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing:4) {
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                }
                
                Section("Account") {
                    Button {
                        coordinator.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: String(localized: "Sign out"))
                    }
                    Button {
                        print("Delete account")
                    } label: {
                        SettingsRowView(imageName: "minus.circle.fill", title:
                            String(localized:"Delete account")
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
