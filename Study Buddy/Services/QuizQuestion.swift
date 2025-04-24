//
//  QuizQuestion.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-23.
//

import Foundation

struct QuizQuestion: Identifiable {
    var id: String { question }
    let question: String
    let options: [String]
    let correctAnswer: String
}

