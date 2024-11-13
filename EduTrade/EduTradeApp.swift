//
//  EduTradeApp.swift
//  EduTrade
//
//  Created by Filip Biegaj on 13/11/2024.
//

import SwiftUI

@main
struct EduTradeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
