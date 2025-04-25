//
//  Study_BuddyTests.swift
//  Study BuddyTests
//
//  Created by Kavinsha Chamod on 2025-04-26.
//

import Testing
import CoreData
import SwiftUI
import UserNotifications
@testable import Study_Buddy

// MARK: - Test Protocols

protocol FocusModeViewTesting {
    var totalDuration: Int { get set }
    var isCounting: Bool { get set }
    var timeRemaining: Int { get set }
    func startTimer(duration: Int)
    func extendTime(by minutes: Int)
    func stopTimer()
}

protocol ScanDocViewTesting {
    var showScanner: Bool { get set }
    var scannedText: String { get set }
}

// MARK: - Mock Objects

class MockFocusModeViewModel: FocusModeViewTesting {
    var totalDuration: Int = 0
    var isCounting: Bool = false
    var timeRemaining: Int = 0
    
    func startTimer(duration: Int) {
        self.totalDuration = duration * 60
        self.timeRemaining = duration * 60
        self.isCounting = true
    }
    
    func extendTime(by minutes: Int) {
        self.timeRemaining += minutes * 60
    }
    
    func stopTimer() {
        self.isCounting = false
    }
}

class MockScanDocViewModel: ScanDocViewTesting {
    var showScanner: Bool = false
    var scannedText: String = ""
}

// MARK: - Test Cases

struct Study_BuddyTests {
    
    // MARK: - Focus Mode Tests
    
    @Test func testFocusModeTimer() async throws {
        let viewModel = MockFocusModeViewModel()
        let initialDuration = viewModel.totalDuration
        
        // Test timer initialization
        #expect(initialDuration == 0)
        
        // Test timer start
        viewModel.startTimer(duration: 30)
        #expect(viewModel.isCounting == true)
        #expect(viewModel.timeRemaining == 30 * 60)
        
        // Test timer extension
        viewModel.extendTime(by: 15)
        #expect(viewModel.timeRemaining == 45 * 60)
        
        // Test timer stop
        viewModel.stopTimer()
        #expect(viewModel.isCounting == false)
    }
    
    @Test func testFocusModeNotifications() async throws {
        let center = UNUserNotificationCenter.current()
        
        // Test notification permission request
        let granted = try await center.requestAuthorization(options: [.alert, .sound])
        #expect(granted)
        
        // Test notification scheduling
        let content = UNMutableNotificationContent()
        content.title = "Focus Session Complete"
        content.body = "Your focus session has ended"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "testFocusComplete", content: content, trigger: trigger)
        
        try await center.add(request)
        let pending = try await center.pendingNotificationRequests()
        #expect(pending.contains { $0.identifier == "testFocusComplete" })
    }
    
    // MARK: - Note Management Tests
    
    @Test func testNoteCreation() async throws {
        let container = NSPersistentContainer(name: "Study_Buddy")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        
        let context = container.viewContext
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        note.title = "Test Note"
        note.content = "Test Content"
        note.timestamp = Date()
        note.userId = "testUser"
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", "Test Note")
        let notes = try context.fetch(fetchRequest)
        
        #expect(notes.count == 1)
        #expect(notes.first?.content == "Test Content")
    }
    
    @Test func testNoteLocking() async throws {
        let container = NSPersistentContainer(name: "Study_Buddy")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        
        let context = container.viewContext
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        note.isLocked = true
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLocked == true")
        let lockedNotes = try context.fetch(fetchRequest)
        
        #expect(lockedNotes.count == 1)
    }
    
    // MARK: - Study Plan Tests
    
    @Test func testStudyPlanAPI() async throws {
        let container = NSPersistentContainer(name: "Study_Buddy")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        
        let context = container.viewContext
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        note.title = "Test Note"
        note.content = "Test content for summarization"
        note.id = UUID()
        
        var summaryReceived = false
        sendNoteToAPI(note: note, userId: "testUser") { summary in
            summaryReceived = summary != nil
        }
        
        // Wait for API response
        try await Task.sleep(nanoseconds: 5_000_000_000)
        #expect(summaryReceived)
    }
    
    // MARK: - Document Scanning Tests
    
    @Test func testDocumentScanner() async throws {
        let viewModel = MockScanDocViewModel()
        
        // Test scanner initialization
        #expect(viewModel.showScanner == false)
        
        // Test scanner activation
        viewModel.showScanner = true
        #expect(viewModel.showScanner == true)
        
        // Test scanned text handling
        viewModel.scannedText = "Test scanned content"
        #expect(viewModel.scannedText == "Test scanned content")
    }
    
    // MARK: - User Settings Tests
    
    @Test func testUserSettings() async throws {
        let container = NSPersistentContainer(name: "Study_Buddy")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        
        let context = container.viewContext
        let settings = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: context) as! Settings
        settings.hasCompletedFocusSetup = true
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
        let savedSettings = try context.fetch(fetchRequest).first
        
        #expect(savedSettings?.hasCompletedFocusSetup == true)
    }
    
    // MARK: - Authentication Tests
    
    @Test func testUserAuthentication() async throws {
        let userId = "testUser123"
        
        // Test user ID storage
        UserDefaults.standard.set(userId, forKey: "loggedInUserId")
        let retrievedUserId = UserDefaults.standard.string(forKey: "loggedInUserId")
        
        #expect(retrievedUserId == userId)
    }
}
