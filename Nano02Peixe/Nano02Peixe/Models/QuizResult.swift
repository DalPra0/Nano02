import Foundation

struct QuizResult: Codable {
    let fish: Fish
    let totalScore: Int
    let answers: [String]
    
    var percentage: Int {
        let maxPossibleScore = 48
        return min(100, (totalScore * 100) / maxPossibleScore)
    }
}
