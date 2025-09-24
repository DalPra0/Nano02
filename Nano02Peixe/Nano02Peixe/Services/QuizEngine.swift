import Foundation

class QuizEngine {
    
    static let shared = QuizEngine()
    private init() {}
    
    func calculateResult(questions: [Question], selectedAnswers: [String]) -> QuizResult? {
        var fishScores: [String: Int] = [:]
        
        for (questionIndex, answerId) in selectedAnswers.enumerated() {
            guard questionIndex < questions.count else { continue }
            
            let question = questions[questionIndex]
            if let answer = question.answers.first(where: { $0.id == answerId }) {
                for (fishName, score) in answer.fishScores {
                    fishScores[fishName, default: 0] += score
                }
            }
        }
        
        guard let winnerEntry = fishScores.max(by: { $0.value < $1.value }),
              let winnerFish = FishData.getFish(named: winnerEntry.key) else {
            print("❌ Erro ao calcular resultado do quiz")
            return nil
        }
        
        print("🎯 QuizEngine - Resultado: \(winnerFish.name) com \(winnerEntry.value) pontos")
        print("🏆 QuizEngine - Pontuações: \(fishScores)")
        
        return QuizResult(
            fish: winnerFish,
            totalScore: winnerEntry.value,
            answers: selectedAnswers
        )
    }
    
    func calculateResult(from answers: [Answer]) -> QuizResult? {
        var fishScores: [String: Int] = [:]
        
        for answer in answers {
            for (fishName, score) in answer.fishScores {
                fishScores[fishName, default: 0] += score
            }
        }
        
        guard let winnerEntry = fishScores.max(by: { $0.value < $1.value }),
              let winnerFish = FishData.getFish(named: winnerEntry.key) else {
            return nil
        }
        
        let answerIds = answers.map { $0.id }
        
        return QuizResult(
            fish: winnerFish,
            totalScore: winnerEntry.value,
            answers: answerIds
        )
    }
    
    var availableFish: [Fish] {
        return FishData.allFish
    }
}
