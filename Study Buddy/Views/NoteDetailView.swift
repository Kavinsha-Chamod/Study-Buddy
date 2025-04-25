//
//  NoteDetailView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-15.
//

import SwiftUI

struct NoteDetailView: View {
    @ObservedObject var note: Note
    @Environment(\.managedObjectContext) private var viewContext
    @FocusState private var isFocused: Bool

    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isEditing {
                TextEditor(text: Binding(
                    get: { note.content ?? "" },
                    set: { note.content = $0 }
                ))
                .font(.body)
                .focused($isFocused)
                .onDisappear {
                    saveNote()
                }
                .onSubmit {
                    saveNote()
                }
            } else {
                Text(note.content ?? "")
                    .font(.body)
                    .onTapGesture {
                        isEditing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isFocused = true
                        }
                    }
            }

            Divider()

            if let timestamp = note.timestamp {
                Text("Last edited: \(formattedDate(timestamp))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .navigationTitle(note.title ?? "Untitled")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveNote() {
        note.timestamp = Date()
        do {
            try viewContext.save()
            print("Note updated.")
        } catch {
            print("Failed to save note: \(error.localizedDescription)")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
