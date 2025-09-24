import Foundation
import Combine

class QuizViewModel: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswers: [String] = []
    @Published var quizResult: QuizResult?
    @Published var isQuizCompleted = false
    @Published var isLoading = false
    
    let questions: [Question]
    private let dataLoader = QuestionsDataLoader.shared
    
    init() {
        self.questions = dataLoader.questions
        print("✅ QuizViewModel inicializado com \(questions.count) perguntas")
    }
    
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex) / Double(questions.count)
    }
    
    var quizTitle: String {
        return dataLoader.title
    }
    
    var quizDescription: String {
        return dataLoader.description
    }
    
    func selectAnswer(_ answerId: String) {
        if selectedAnswers.count <= currentQuestionIndex {
            selectedAnswers.append(answerId)
        } else {
            selectedAnswers[currentQuestionIndex] = answerId
        }
        
        print("📝 Resposta selecionada: \(answerId) para pergunta \(currentQuestionIndex + 1)")
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            completeQuiz()
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    private func completeQuiz() {
        isLoading = true
        
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
        
        let winnerFish = fishScores.max(by: { $0.value < $1.value })
        
        guard let winner = winnerFish,
              let fish = FishData.getFish(named: winner.key) else {
            print("❌ Erro ao calcular resultado do quiz")
            isLoading = false
            return
        }
        
        print("🎯 Resultado: \(fish.name) com \(winner.value) pontos")
        print("🏆 Pontuações finais: \(fishScores)")
        
        self.quizResult = QuizResult(
            fish: fish,
            totalScore: winner.value,
            answers: selectedAnswers
        )
        
        self.isQuizCompleted = true
        self.isLoading = false
    }
    
    func restartQuiz() {
        currentQuestionIndex = 0
        selectedAnswers.removeAll()
        quizResult = nil
        isQuizCompleted = false
        isLoading = false
        print("🔄 Quiz reiniciado")
    }
}
