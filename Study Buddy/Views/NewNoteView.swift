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
    @State private var navigateToFiles = false
    @State private var showAlert = false
    @FocusState private var isTextEditorFocused: Bool

    var note: Note?
    var currentUserId: String

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Title", text: $title)
                        .focused($isTextEditorFocused)
                    TextEditor(text: $content)
                        .frame(height: 300)
                        .focused($isTextEditorFocused)
                }
                .onTapGesture {
                    hideKeyboard()
                }

                NavigationLink(
                    destination: FilesView(currentUserId: currentUserId),
                    isActive: $navigateToFiles
                ) {
                    EmptyView()
                }.hidden()
            }
            .navigationTitle(note == nil ? "New Note" : "Edit Note")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if title.trimmingCharacters(in: .whitespaces).isEmpty ||
                            content.trimmingCharacters(in: .whitespaces).isEmpty {
                            showAlert = true
                        } else {
                            saveNote(for: currentUserId)
                        }
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
            .alert("Title and content cannot be empty.", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
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
            title = ""
            content = ""
            dismiss()
        } catch {
            print("Failed to save note: \(error.localizedDescription)")
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
