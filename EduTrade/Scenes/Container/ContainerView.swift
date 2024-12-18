//
//  ContainerView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 13/11/2024.
//

import SwiftUI

struct ContainerView: View {
    @State private var selectedIndex: Int = 0
    @EnvironmentObject var coordinator: MainCoordinator

    var body: some View {
        TabView (selection: $selectedIndex) {
            coordinator.build(screen: .home)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            coordinator.build(screen: .trade)
                .tabItem {
                    Image(systemName: "bitcoinsign.circle.fill")
                    Text("Trade")
                }
            coordinator.build(screen: .settings)
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
    ContainerView()
        .environmentObject(MainCoordinator())
}
