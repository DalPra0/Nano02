//
//  Answer.swift
//  FishQuiz
//

import Foundation

struct Answer: Identifiable, Codable {
    var id = UUID()
    let text: String
    let fishScores: [String: Int]
    
    init(text: String, fishScores: [String: Int]) {
        self.text = text
        self.fishScores = fishScores
    }
}
