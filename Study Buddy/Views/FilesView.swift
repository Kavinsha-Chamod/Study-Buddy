//
//  ScanDocView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI
import CoreData
import LocalAuthentication

struct FilesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var selectedNote: Note?
    @State private var searchText = ""
    @State private var filterOption = "All"
    @State private var showingEditor = false

    private var currentUserId: String
    private var fetchRequest: FetchRequest<Note>
    private var notes: FetchedResults<Note> { fetchRequest.wrappedValue }

    private let filterOptions = ["All", "Scanned", "Imported"]

    init(currentUserId: String) {
        self.currentUserId = currentUserId
        self.fetchRequest = FetchRequest<Note>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)],
            predicate: NSPredicate(format: "userId == %@", currentUserId),
            animation: .default
        )
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $filterOption) {
                    ForEach(filterOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    let filteredNotes = notes.filter { note in
                        (searchText.isEmpty || (note.title?.localizedCaseInsensitiveContains(searchText) ?? false)) &&
                        (filterOption == "All" ||
                         (filterOption == "Scanned" && note.isScanned) ||
                         (filterOption == "Imported" && note.isImported))
                    }

                    let pinnedNotes = filteredNotes.filter { $0.isPinned }
                    let regularNotes = filteredNotes.filter { !$0.isPinned }

                    if !pinnedNotes.isEmpty {
                        Section("Pinned") {
                            ForEach(pinnedNotes) { noteRow($0) }
                        }
                    }

                    Section("Notes") {
                        ForEach(regularNotes) { noteRow($0) }
                    }
                }
                .listStyle(.insetGrouped)
                .searchable(text: $searchText)
                .navigationTitle("Notes")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            selectedNote = nil
                            showingEditor = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingEditor) {
                NewNoteView(note: selectedNote, currentUserId: currentUserId)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    // MARK: - Individual Note Row
    @ViewBuilder
    private func noteRow(_ note: Note) -> some View {
        NavigationLink(destination: NoteDetailView(note: note)) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(note.title ?? "Untitled")
                        .font(.headline)
                    if note.isLocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.red)
                    }
                }
                Text(note.content ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .swipeActions(edge: .trailing) {
            Button {
                togglePin(note)
            } label: {
                Label("Pin", systemImage: note.isPinned ? "pin.slash" : "pin")
            }.tint(.yellow)

            Button(role: .destructive) {
                delete(note)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                toggleLock(note)
            } label: {
                Label("Lock", systemImage: note.isLocked ? "lock.open" : "lock")
            }.tint(.blue)
        }
    }

    // MARK: - Actions
    private func togglePin(_ note: Note) {
        note.isPinned.toggle()
        saveContext()
    }

    private func toggleLock(_ note: Note) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock note") { success, authError in
                if success {
                    DispatchQueue.main.async {
                        note.isLocked.toggle()
                        saveContext()
                    }
                }
            }
        }
    }

    private func delete(_ note: Note) {
        viewContext.delete(note)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
