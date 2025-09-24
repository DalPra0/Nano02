//
//  QuizResult.swift
//  FishQuiz
//

import Foundation

struct QuizResult: Identifiable {
    let id = UUID()
    let fish: Fish
    let totalScore: Int
    let answeredQuestions: Int
    
    init(fish: Fish, totalScore: Int, answeredQuestions: Int) {
        self.fish = fish
        self.totalScore = totalScore
        self.answeredQuestions = answeredQuestions
    }
}
