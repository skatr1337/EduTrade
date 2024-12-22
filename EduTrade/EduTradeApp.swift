//
//  EduTradeApp.swift
//  EduTrade
//
//  Created by Filip Biegaj on 13/11/2024.
//

import SwiftUI
import Firebase

@main
struct EduTradeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
