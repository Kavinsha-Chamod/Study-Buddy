//
//  SummaryView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-23.
//

import SwiftUI
import AVFoundation

struct SummaryView: View {
    var note: Note
    var title: String
    var summary: String

    @State private var synthesizer = AVSpeechSynthesizer()
    @State private var isSpeaking = false
    @State private var isPaused = false
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""

    @State private var navigateToQuiz = false
    @State private var quizQuestions: [QuizQuestion] = []

    var body: some View {
            VStack {
                ScrollView {
                    Text(summary)
                        .padding()
                }

                NavigationLink(
                    destination: QuizView(noteTitle: title,questions: quizQuestions),
                    isActive: $navigateToQuiz,
                    label: { EmptyView() }
                )
                .hidden()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        if isSpeaking {
                            stopSpeech()
                        } else {
                            speakSummary(summary)
                        }
                    }) {
                        Text(isSpeaking ? "Stop Reading" : "Read Summary")
                    }

                    Spacer()

                    Button("Next") {
                        QuizAPI.sendSummaryForQuiz(
                            noteId: note.id?.uuidString ?? "",
                            title: title,
                            content: summary,
                            userId: loggedInUserId
                        ) { result in
                            switch result {
                            case .success(let questions):
                                DispatchQueue.main.async {
                                    self.quizQuestions = self.mapToQuizQuestions(questions)
                                    self.navigateToQuiz = true
                                }
                            case .failure(let error):
                                print("Quiz API failed: \(error)")
                            }
                        }
                    }
                }
            }
        
        .onAppear {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try? AVAudioSession.sharedInstance().setActive(true)
        }
    }

    private func speakSummary(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
        isSpeaking = true
        isPaused = false
    }

    private func stopSpeech() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        isPaused = false
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
