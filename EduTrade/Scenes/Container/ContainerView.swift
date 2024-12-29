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
            navigation(screen: .home)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            coordinator.build(screen: .wallet)
                .tabItem {
                    Image(systemName: "bitcoinsign.circle.fill")
                    Text("Wallet")
                }
                .tag(1)
            coordinator.build(screen: .settings)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(2)
        }
        .onAppear(perform: {
            UITabBar.appearance().unselectedItemTintColor = .systemGray
            UITabBar.appearance().backgroundColor = .systemGray4.withAlphaComponent(0.4)
        })
    }

    @ViewBuilder
    private func navigation(screen: Screen) -> some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(screen: screen)
                .navigationDestination(for: Screen.self) {
                    coordinator.build(screen: $0)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) {
                    coordinator.build(cover: $0)
                }
        }
    }
}

#Preview {
    ContainerView()
        .environmentObject(MainCoordinator())
}
