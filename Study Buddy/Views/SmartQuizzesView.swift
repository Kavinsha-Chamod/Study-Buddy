//
//  SmartQuizzesView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-24.
//

import SwiftUI
import CoreData

struct SmartQuizzesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedNote: Note?
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""
    
    @State private var quizQuestions: [QuizQuestion] = []
    @State private var navigateToQuiz = false

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
                generateQuiz(for: note)
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
                        QuizView(noteTitle: note.title ?? "Quiz", questions: quizQuestions)
                    } else {
                        EmptyView()
                    }
                },
                isActive: $navigateToQuiz,
                label: { EmptyView() }
            )
            .hidden()
        )
        .navigationTitle("Smart Quizzes")
        .navigationBarTitleDisplayMode(.large)
    }

    private func generateQuiz(for note: Note) {
        QuizAPI.sendSummaryForQuiz(
            noteId: note.id?.uuidString ?? "",
            title: note.title ?? "",
            content: note.content ?? "",
            userId: loggedInUserId
        ) { result in
            switch result {
            case .success(let questions):
                DispatchQueue.main.async {
                    self.quizQuestions = self.mapToQuizQuestions(questions)
                    self.navigateToQuiz = true
                }
            case .failure(let error):
                print("Quiz generation failed: \(error)")
            }
        }
    }

    private func mapToQuizQuestions(_ questions: [[String: Any]]) -> [QuizQuestion] {
        return questions.compactMap { questionDict in
            if let question = questionDict["question"] as? String,
               let options = questionDict["options"] as? [String],
               let correctAnswer = questionDict["correctAnswer"] as? String {
                return QuizQuestion(question: question, options: options, correctAnswer: correctAnswer)
            } else {
                return nil
            }
        }
    }
}
