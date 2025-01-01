//
//  RootView.swift
//  EduTrade
//
//  Created by Filip Biegaj on 01/12/2024.
//

import SwiftUI

struct RootView: View {
    @StateObject var coordinator = MainCoordinator()

    var body: some View {
        Group {
            if coordinator.isLoading {
                ProgressView()
            } else {
                if coordinator.currentUser != nil {
                    coordinator.build(screen: .container)
                } else {
                    coordinator.build(screen: .login)
                }
            }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    RootView()
}
