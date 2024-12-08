//
//  ContentView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 13/11/2024.
//

import SwiftUI

struct MainView: View {
    @State private var selectedIndex: Int = 0

    var body: some View {
        TabView (selection: $selectedIndex) {
            HomeView(viewModel: HomeViewModel())
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            TradeView()
                .tabItem {
                    Image(systemName: "bitcoinsign.circle.fill")
                    Text("Trade")
                }
            SettingsView()
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
   MainView()
}
