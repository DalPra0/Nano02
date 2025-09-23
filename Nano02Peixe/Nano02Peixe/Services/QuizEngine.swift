//
//  QuizEngine.swift
//  FishQuiz
//
//  Serviço responsável pela lógica de cálculo do resultado do quiz
//

import Foundation

class QuizEngine {
    
    static let shared = QuizEngine()
    private init() {}
    
    func calculateResult(from answers: [Answer]) -> QuizResult? {
        var fishScores: [String: Int] = [:]
        
        // Soma pontuações de todas as respostas
        for answer in answers {
            for (fishName, score) in answer.fishScores {
                fishScores[fishName, default: 0] += score
            }
        }
        
        // Encontra o peixe com maior pontuação
        guard let winnerFishName = fishScores.max(by: { $0.value < $1.value })?.key,
              let winnerFish = FishData.fishes.first(where: { $0.name == winnerFishName }),
              let totalScore = fishScores[winnerFishName] else {
            return nil
        }
        
        return QuizResult(
            fish: winnerFish,
            totalScore: totalScore,
            answeredQuestions: answers.count  // ✅ Corrigido para Int
        )
    }
}
