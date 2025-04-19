//
//  ScanDocView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI
import CoreData

struct NewNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
        @Environment(\.dismiss) var dismiss

        @State private var title: String = ""
        @State private var content: String = ""

        var note: Note?
        var currentUserId: String

    var body: some View {
        NavigationView {
                    Form {
                        TextField("Title", text: $title)
                        TextEditor(text: $content)
                            .frame(height: 300)
                    }
                    .navigationTitle(note == nil ? "New Note" : "Edit Note")
                    
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                saveNote(for: currentUserId)
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", role: .cancel) {
                                dismiss()
                            }
                        }
                    }
                    .onAppear {
                        if let note = note {
                            title = note.title ?? ""
                            content = note.content ?? ""
                        }
                    }
                }
            }

    private func saveNote(for userID: String) {
        let noteToSave = note ?? Note(context: viewContext)
        noteToSave.id = noteToSave.id ?? UUID()
        noteToSave.title = title
        noteToSave.content = content
        noteToSave.timestamp = Date()
        noteToSave.userId = userID

        do {
            try viewContext.save()
            print("Note saved successfully")
            print("• Title: \(noteToSave.title)")
            print("• Content: \(noteToSave.content)")
            print("• Timestamp: \(noteToSave.timestamp ?? Date())")
            print("• User ID: \(noteToSave.userId ?? "No User ID")")
        } catch {
            print("Failed to save note: \(error.localizedDescription)")
        }
    }

}
