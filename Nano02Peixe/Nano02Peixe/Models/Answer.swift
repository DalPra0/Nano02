import Foundation

struct Answer: Codable, Identifiable {
    let id: String
    let text: String
    let fishScores: [String: Int]
    
    var answerId: String { id } // Para compatibilidade com o protocolo Identifiable
}