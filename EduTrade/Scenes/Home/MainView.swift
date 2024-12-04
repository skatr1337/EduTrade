//
//  ContentView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 13/11/2024.
//

import SwiftUI

struct MainView: View {
    @State private var selectedIndex: Int = 0
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        if let user = viewModel.currentUser {
            TabView (selection: $selectedIndex) {
                HomeView(viewModel: HomeViewModel())
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                Text("Trade")
                    .tabItem {
                        Image(systemName: "bitcoinsign.circle.fill")
                        Text("Trade")
                    }

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
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign out", tintColor: .red)
                        }
                        Button {
                            print("Delete account")
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Delete account", tintColor: .red)
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            }
            .onAppear(perform: {
                UITabBar.appearance().unselectedItemTintColor = .systemGray
                UITabBar.appearance().backgroundColor = .systemGray4.withAlphaComponent(0.4)
            })
        }
    }
}

#Preview {
   MainView()
}
