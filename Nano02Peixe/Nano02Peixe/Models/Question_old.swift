//
//  Question.swift
//  FishQuiz
//

import Foundation

struct Question: Identifiable, Codable {
    var id = UUID()
    let text: String
    let answers: [Answer]
    
    init(text: String, answers: [Answer]) {
        self.text = text
        self.answers = answers
    }
}
