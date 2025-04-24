//
//  QuizView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-23.
//

import SwiftUI

struct QuizView: View {
    let noteTitle: String
    let questions: [QuizQuestion]

    @State private var selectedAnswers: [String: String] = [:]
    @State private var showResults = false
    @State private var score: Int = 0
    @State private var showCelebration = false
    @State private var navigateToFlashcards = false
    @EnvironmentObject var appNavigation: AppNavigation

    var allAnswered: Bool {
        selectedAnswers.count == questions.count
    }

    var body: some View {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        quizHeader

                        ForEach(Array(questions.enumerated()), id: \.1.id) { index, question in
                            quizQuestionView(index: index, question: question)
                        }

                        Spacer()
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                .navigationTitle(noteTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                                // 🆕 Flashcard Button on Left Side
                                ToolbarItem(placement: .bottomBar) {
                                    HStack {
                                        if showResults {
                                            Button("Review with Flashcards") {
                                                navigateToFlashcards = true
                                            }
                                        }

                                        Spacer()

                                        Button(showResults ? "Done" : "Check Answers") {
                                            handleButtonTap()
                                        }
                                        .disabled(!showResults && !allAnswered)
                                    }
                                }
                            }

                if showCelebration {
                    celebrationOverlay
                }
                NavigationLink(
                                destination: FlashcardsView(questions: questions),
                                isActive: $navigateToFlashcards
                            ) {
                                EmptyView()
                            }
                            .hidden()
            }
    }

    // MARK: - Components

    private var quizHeader: some View {
        HStack {
            Text(showResults ? "Answers" : "Practice Quiz")
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            if showResults {
                Text("Score: \(score)/\(questions.count)")
                    .fontWeight(.semibold)
            }
        }
        .padding(.top)
    }

    private func quizQuestionView(index: Int, question: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(index + 1). \(question.question)")
                .font(.headline)

            ForEach(question.options, id: \.self) { option in
                quizOptionRow(question: question, option: option)
            }
        }
    }

    private func quizOptionRow(question: QuizQuestion, option: String) -> some View {
        let selected = selectedAnswers[question.question]
        let isCorrect = option == question.correctAnswer
        let isSelected = selected == option
        let showCheck = showResults && isCorrect

        return HStack {
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .foregroundColor(.blue)

            Text(option)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(optionColor(isSelected: isSelected, isCorrect: isCorrect))

            if showCheck {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .onTapGesture {
            guard !showResults else { return }
            selectedAnswers[question.question] = option
        }
    }

    private func optionColor(isSelected: Bool, isCorrect: Bool) -> Color {
        if showResults {
            if isSelected {
                return isCorrect ? .green : .red
            } else {
                return isCorrect ? .green : .primary
            }
        }
        return .primary
    }

    private var celebrationOverlay: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .overlay(
                VStack(spacing: 16) {
                    Text("🎉")
                        .font(.system(size: 80))
                    Text("Perfect Score!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .transition(.scale)
            )
    }

    // MARK: - Logic

    private func handleButtonTap() {
        if showResults {
            appNavigation.path.append(NavigationRoute.studyPlan)

        } else {
            score = questions.reduce(0) { total, question in
                total + (selectedAnswers[question.question] == question.correctAnswer ? 1 : 0)
            }
            showResults = true

            if score == questions.count {
                withAnimation(.easeInOut(duration: 0.4)) {
                    showCelebration = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        showCelebration = false
                    }
                }
            }
        }
    }
}
