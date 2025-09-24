import Foundation

struct Question: Codable, Identifiable {
    let id: Int
    let text: String
    let answers: [Answer]
}

struct QuizData: Codable {
    let quiz: Quiz
    let fishPersonalities: [String: FishPersonality]
    
    enum CodingKeys: String, CodingKey {
        case quiz
        case fishPersonalities = "fish_personalities"
    }
}

struct Quiz: Codable {
    let title: String
    let description: String
    let questions: [Question]
}