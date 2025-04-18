//
//  MemoireApp.swift
//  Memoire
//
//  Created by Misha Kandaurov on 18.04.2025.
//

import SwiftUI

@main
struct MemoireApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
