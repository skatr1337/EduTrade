//
//  ContentView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 13/11/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedIndex: Int = 0

    var body: some View {
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
                        Text("MB")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing:4) {
                            Text("Michael Bagietson")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text("test@gmail.com")
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                }
                
                Section("Account") {
                    Button {
                        print("Sign out")
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

#Preview {
    ContentView()
}
