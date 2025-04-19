//
//  Study_BuddyApp.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI

@main
struct StudyBuddyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
