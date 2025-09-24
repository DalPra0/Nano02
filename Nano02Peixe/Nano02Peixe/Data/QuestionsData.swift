import Foundation

class QuestionsDataLoader {
    static let shared = QuestionsDataLoader()
    
    private var cachedData: QuizData?
    
    private init() {}
    
    func loadQuizData() -> QuizData? {
        if let cached = cachedData {
            return cached
        }
        
        guard let url = Bundle.main.url(forResource: "quiz_data", withExtension: "json") else {
            print("❌ Erro: Não foi possível encontrar quiz_data.json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let quizData = try decoder.decode(QuizData.self, from: data)
            
            cachedData = quizData
            print("✅ Quiz data carregado com sucesso: \(quizData.quiz.questions.count) perguntas")
            
            return quizData
        } catch {
            print("❌ Erro ao carregar quiz_data.json: \(error)")
            return nil
        }
    }
    
    var questions: [Question] {
        return loadQuizData()?.quiz.questions ?? []
    }
    
    var fishPersonalities: [String: FishPersonality] {
        return loadQuizData()?.fishPersonalities ?? [:]
    }
    
    var title: String {
        return loadQuizData()?.quiz.title ?? "Quiz dos Peixes"
    }
    
    var description: String {
        return loadQuizData()?.quiz.description ?? "Descubra qual peixe você é!"
    }
}

struct QuestionsData {
    static var questions: [Question] {
        return QuestionsDataLoader.shared.questions
    }
}
