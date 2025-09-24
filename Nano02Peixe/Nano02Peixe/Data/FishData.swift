import Foundation

struct FishData {
    static func getFish(named fishName: String) -> Fish? {
        let personalities = QuestionsDataLoader.shared.fishPersonalities
        
        guard let personality = personalities[fishName] else {
            print("❌ Peixe não encontrado: \(fishName)")
            return nil
        }
        
        return Fish(
            name: personality.name,
            title: personality.title, 
            description: personality.description,
            traits: personality.traits,
            funFact: personality.funFact
        )
    }
    
    static var allFishNames: [String] {
        return Array(QuestionsDataLoader.shared.fishPersonalities.keys).sorted()
    }
    
    static var allFish: [Fish] {
        return allFishNames.compactMap { getFish(named: $0) }
    }
}