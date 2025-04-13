//
//  Study_BuddyApp.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI

@main
struct Study_BuddyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            OnBoardView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
