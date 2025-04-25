//
//  FlashcardsView.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-24.
//

import SwiftUI

struct FlashcardsView: View {
    let questions: [QuizQuestion]
    @State private var flippedIndices: Set<Int> = []
    @EnvironmentObject var appNavigation: AppNavigation

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(0..<questions.count, id: \.self) { index in
                        flashcardView(index: index)
                            .frame(height: 200)
                    }
                }
                .padding()
            }
            Spacer()
        }
        .navigationTitle("Flashcards")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Done") {
                    appNavigation.path.append(NavigationRoute.studyPlan)
                }
            }
        }
    }

    // MARK: - Flashcard View
    @ViewBuilder
    private func flashcardView(index: Int) -> some View {
        let question = questions[index]
        let isFlipped = flippedIndices.contains(index)

        ZStack {
            // Front (Question)
            cardView(text: question.question, background: Color.blue)
                .opacity(isFlipped ? 0.0 : 1.0)

            // Back (Answer)
            cardView(text: question.correctAnswer, background: Color.indigo, flipped: true)
                .opacity(isFlipped ? 1.0 : 0.0)
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.5), value: isFlipped)
        .onTapGesture {
            withAnimation {
                if isFlipped {
                    flippedIndices.remove(index)
                } else {
                    flippedIndices.insert(index)
                }
            }
        }
    }

    // MARK: - Card View
    @ViewBuilder
    private func cardView(text: String, background: Color, flipped: Bool = false) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(background)
            .shadow(radius: 10)
            .overlay(
                Text(text)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .rotation3DEffect(
                        .degrees(flipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
            )
    }
}
