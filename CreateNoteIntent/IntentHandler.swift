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
    func getUserIdFromKeychain() -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "group.com.note.temp",
            kSecAttrAccount as String: "loggedInUserId",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)
        
        if status == errSecSuccess, let data = item as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            print("Failed to get User ID from Keychain: \(status)")
            return nil
        }
    }

    func handle(intent: CreateNoteIntent, completion: @escaping (CreateNoteIntentResponse) -> Void) {
        let title = intent.title ?? "Untitled"
        let content = intent.content ?? ""
        
        guard let userId = getUserIdFromKeychain() else {
            print("Siri Extension - User Id: Not logged in")
            let response = CreateNoteIntentResponse(code: .failure, userActivity: nil)
            response.title = "User not logged in."
            completion(response)
            return
        }
        
        print("Siri Extension - User Id: \(userId)")

        if saveNote(title: title, content: content, userId: userId) {
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
    
    private func saveNote(title: String, content: String, userId: String) -> Bool {
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
            note.userId = userId
            
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
