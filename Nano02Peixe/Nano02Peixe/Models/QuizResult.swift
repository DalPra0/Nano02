import Foundation

struct QuizResult: Codable {
    let fish: Fish
    let totalScore: Int
    let answers: [String] // IDs das respostas selecionadas
    
    var percentage: Int {
        // Cálculo de porcentagem baseado no score máximo possível
        let maxPossibleScore = 48 // 12 perguntas x 4 pontos máximos
        return min(100, (totalScore * 100) / maxPossibleScore)
    }
}