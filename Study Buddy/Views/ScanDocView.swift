//
//  ScanDocView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-13.
//

import SwiftUI
import CoreData
import VisionKit

struct ScanDocView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""

    @State private var showScanner = false
    @State private var scannedText: String = ""
    @State private var showSaveAlert = false
    @State private var showTitlePrompt = false
    @State private var customTitle: String = ""

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Scan Notes")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top)
                    .padding(.horizontal)
                Spacer()

                if !showScanner {
                    Button(action: {
                        showScanner = true
                    }) {
                        HStack {
                            Image(systemName: "doc.text.viewfinder")
                            Text("Start Scan")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                if !scannedText.isEmpty {
                    let title = scannedText.components(separatedBy: .newlines).first ?? ""

                    VStack(alignment: .leading, spacing: 8) {
                        if !title.trimmingCharacters(in: .whitespaces).isEmpty {
                            Text("Title: \(title)")
                                .font(.headline)
                                .padding(.horizontal)
                        }

                        ScrollView {
                            Text(scannedText)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }

                        Button("Save Note") {
                            if scannedText.count < 5 {
                                return
                            }
                            if !title.trimmingCharacters(in: .whitespaces).isEmpty {
                                saveNote(title: title, content: scannedText)
                            } else {
                                showTitlePrompt = true
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Scan Document")
        .sheet(isPresented: $showScanner) {
            DocumentScannerView { text in
                self.scannedText = text
                self.showScanner = false
            }
        }
        .alert("Enter a title", isPresented: $showTitlePrompt, actions: {
            TextField("Title", text: $customTitle)
            Button("Save") {
                saveNote(title: customTitle, content: scannedText)
            }
            Button("Cancel", role: .cancel) {}
        })
    }

    private func saveNote(title: String, content: String) {
        let newNote = Note(context: viewContext)
        newNote.id = UUID()
        newNote.title = title
        newNote.content = content
        newNote.type = "scanned"
        newNote.timestamp = Date()
        newNote.userId = loggedInUserId

        do {
            try viewContext.save()
            print("Note saved successfully")
            scannedText = ""
            customTitle = ""
        } catch {
            print("Failed to save note: \(error.localizedDescription)")
        }
    }
}
