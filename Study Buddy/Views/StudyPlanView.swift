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
    @State private var navigateToSummary = false

    private var notesRequest: FetchRequest<Note>
    private var notes: FetchedResults<Note> { notesRequest.wrappedValue }

    init() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)]
        request.predicate = NSPredicate(format: "userId == %@", UserDefaults.standard.string(forKey: "loggedInUserId") ?? "")
        
        self.notesRequest = FetchRequest<Note>(fetchRequest: request, animation: .default)
    }

    var body: some View {
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
                    VStack(alignment: .leading) {
                        Text(note.title ?? "Untitled")
                            .font(.system(size: 17, weight: .regular))
                    }
                }
            }
            .background(
                NavigationLink(
                    destination: Group {
                        if let note = selectedNote {
                            SummaryView(note: note, title: note.title ?? "Summary", summary: summaryResult)
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $navigateToSummary,
                    label: { EmptyView() }
                )
                .hidden()
            )
            .navigationTitle("Today's Study Plan")
            .navigationBarTitleDisplayMode(.large)
    }
}
