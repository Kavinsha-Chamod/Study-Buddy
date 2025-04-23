//
//  StudyPlanView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-15.
//

import SwiftUI
import CoreData

struct StudyPlanView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedNote: Note?
    @State private var summaryResult: String = ""
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""
    
    @State private var today: Date = Date()
    @State private var yesterday: Date = Date()
    @State private var notes: [Note] = []

    @State private var navigateToSummary = false
    private func calculateDates() {
        let calendar = Calendar.current
        self.today = calendar.startOfDay(for: Date())
        self.yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
    }

    var body: some View {
        NavigationView {
            List(notes) { note in
                Button {
                    selectedNote = note
                    sendNoteToAPI(note: note, userId: loggedInUserId) { summary in
                        DispatchQueue.main.async {
                            if let summary = summary {
                                self.summaryResult = summary
                                self.navigateToSummary = true
                            }
                        }
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text((note.title ?? "Untitled") + " Study Plan")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .padding(5)
                }
            }
            .background(
                NavigationLink(
                    destination: Group {
                        if let note = selectedNote {
                            SummaryView(title: note.title ?? "Summary", summary: summaryResult)
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $navigateToSummary,
                    label: { EmptyView() }
                )
                .hidden()
            )
            .onAppear {
                calculateDates()
                fetchNotes()
            }
            .navigationTitle("Today's Study Plan")
        }
    }

    private func fetchNotes() {
        let calendar = Calendar.current
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "(timestamp >= %@) AND (timestamp < %@) AND (userId == %@)", argumentArray: [yesterday, today.addingTimeInterval(86400), loggedInUserId])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)]

        do {
            notes = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch notes: \(error.localizedDescription)")
        }
    }
}

#Preview {
    StudyPlanView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

