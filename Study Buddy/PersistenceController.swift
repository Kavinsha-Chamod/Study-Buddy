//
//  PersistenceController.swift.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Study_Buddy")

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        } else if let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.note.temp") {
            let storeURL = appGroupURL.appendingPathComponent("StudyBuddy.sqlite")
            let description = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [description]
        } else {
            fatalError("Failed to access App Group container. Check your App Group ID.")
        }

        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent store: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Custom Utilities

    func markFocusSetupComplete(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
        do {
            let settings = try context.fetch(fetchRequest).first ?? Settings(context: context)
            settings.hasCompletedFocusSetup = true
            try context.save()
        } catch {
            print("Failed to update focus setup: \(error)")
        }
    }
}
