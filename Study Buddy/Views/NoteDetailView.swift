//
//  NoteDetailView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-15.
//

import SwiftUI

struct NoteDetailView: View {
    let note: Note

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(note.content ?? "")
                    .font(.body)
                    .padding(.bottom)
                Divider()
                if let timestamp = note.timestamp {
                    Text("Last edited: \(formattedDate(timestamp))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(note.title ?? "Untitled")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
