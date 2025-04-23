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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)],
        animation: .default
    )
    private var notes: FetchedResults<Note>

    @State private var navigateToSummary = false

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
            .navigationTitle("Today's Study Plan")
        }
    }
}

#Preview {
    StudyPlanView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
