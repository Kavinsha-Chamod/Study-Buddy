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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }

        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
