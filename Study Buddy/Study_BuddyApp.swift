//
//  Study_BuddyApp.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI
import CoreData

@main
struct StudyBuddyApp: App {
    let persistenceController = PersistenceController.shared
    @State private var hasCompletedFocusSetup: Bool = false
    @StateObject var appNavigation = AppNavigation()

    var body: some Scene {
        WindowGroup {
            RootView(hasCompletedFocusSetup: $hasCompletedFocusSetup)
                .environmentObject(appNavigation)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    loadFocusSetupState()
                }
        }
    }

    private func loadFocusSetupState() {
        let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
        if let settings = try? persistenceController.container.viewContext.fetch(fetchRequest).first {
            hasCompletedFocusSetup = settings.hasCompletedFocusSetup
        }
    }
}
