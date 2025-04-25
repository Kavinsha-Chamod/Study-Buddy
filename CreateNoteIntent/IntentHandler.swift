//
//  IntentHandler.swift
//  CreateNoteIntent
//
//  Created by Kavinsha Chamod on 2025-04-19.
//

import Intents
import CoreData

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        if intent is CreateNoteIntent {
            return CreateNoteIntentHandler()
        }
        return self
    }
}

class CreateNoteIntentHandler: NSObject, CreateNoteIntentHandling {

    func handle(intent: CreateNoteIntent, completion: @escaping (CreateNoteIntentResponse) -> Void) {
        let title = intent.title ?? "Untitled"
        let content = intent.content ?? ""
        
        let userDefaults = UserDefaults(suiteName: "group.com.note.temp")
        let userId = userDefaults?.string(forKey: "loggedInUserId")
        print("Siri Extension - User Id: \(userId ?? "Not logged in")")

        if saveNote(title: title, content: content) {
            let response = CreateNoteIntentResponse(code: .success, userActivity: nil)
            response.title = "Note saved: \(title)"
            completion(response)
        } else {
            let response = CreateNoteIntentResponse(code: .failure, userActivity: nil)
            response.title = "Failed to save note."
            completion(response)
        }
    }
    
    func resolveTitle(for intent: CreateNoteIntent) async -> CreateNoteTitleResolutionResult {
        if let title = intent.title, !title.isEmpty {
            return .success(with: title)
        }
        return .needsValue()
    }

    func resolveContent(for intent: CreateNoteIntent) async -> CreateNoteContentResolutionResult {
        if let content = intent.content, !content.isEmpty {
            return .success(with: content)
        }
        return .needsValue()
    }
    
    private func saveNote(title: String, content: String) -> Bool {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.note.temp") else {
            return false
        }
        
        let storeURL = containerURL.appendingPathComponent("StudyBuddy.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: "Study_Buddy")
        container.persistentStoreDescriptions = [description]
        
        var saveSuccess = false
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load store: \(error)")
                saveSuccess = false
                return
            }
            
            let context = container.viewContext
            let note = Note(context: context)
            note.title = title
            note.content = content
            note.timestamp = Date()
            
            do {
                try context.save()
                saveSuccess = true
                print("Success saved note")
            } catch {
                print("Core Data error: \(error)")
                saveSuccess = false
            }
        }
        
        return saveSuccess
    }
}
