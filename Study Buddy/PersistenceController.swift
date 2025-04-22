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
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed: \(error.localizedDescription)")
            }
        }
    }
    func markFocusSetupComplete(context: NSManagedObjectContext) {
            let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
            let settings = try? context.fetch(fetchRequest).first ?? Settings(context: context)
            settings?.hasCompletedFocusSetup = true
            try? context.save()
        }
}
