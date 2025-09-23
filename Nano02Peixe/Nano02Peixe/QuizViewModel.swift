//
//  QuizViewModel.swift
//  FishQuiz
//

import Foundation
import SwiftUI
import Combine

@MainActor
class QuizViewModel: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswerIndex: Int? = nil
    @Published var hasAnswered = false
    @Published var quizResult: QuizResult? = nil
    @Published var fishScores: [String: Int] = [:]
    
    let questions = QuestionsData.questions
    let fishes = FishData.fishes
    
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }
    
    var progress: Double {
        Double(currentQuestionIndex + 1) / Double(questions.count)
    }
    
    // MARK: - Quiz Actions
    
    func selectAnswer(at index: Int) {
        selectedAnswerIndex = index
        hasAnswered = true
    }
    
    func nextQuestion() {
        guard let answerIndex = selectedAnswerIndex else { return }
        
        // Adicionar pontos baseado na resposta
        let answer = currentQuestion.answers[answerIndex]
        for (fishName, points) in answer.fishScores {
            fishScores[fishName, default: 0] += points
        }
        
        // Resetar seleção
        selectedAnswerIndex = nil
        hasAnswered = false
        
        // Ir para próxima pergunta ou finalizar
        if isLastQuestion {
            calculateResult()
        } else {
            currentQuestionIndex += 1
        }
    }
    
    func calculateResult() {
        // Encontrar o peixe com maior pontuação
        let winningFishName = fishScores.max(by: { $0.value < $1.value })?.key ?? "Peixe Palhaço"
        let winningFish = fishes.first { $0.name == winningFishName } ?? fishes[0]
        let totalScore = fishScores.values.reduce(0, +)
        
        quizResult = QuizResult(
            fish: winningFish,
            totalScore: totalScore,
            answeredQuestions: questions.count
        )
    }
    
    func restartQuiz() {
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        hasAnswered = false
        quizResult = nil
        fishScores = [:]
    }
}
