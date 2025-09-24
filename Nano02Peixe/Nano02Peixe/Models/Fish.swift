import Foundation

struct Fish: Codable, Identifiable {
    let name: String
    let title: String
    let description: String
    let traits: [String]
    let funFact: String
    
    var id: String { name }
    
    enum CodingKeys: String, CodingKey {
        case name, title, description, traits
        case funFact = "funFact"
    }
}

struct FishPersonality: Codable {
    let name: String
    let title: String
    let description: String
    let traits: [String]
    let funFact: String
    
    enum CodingKeys: String, CodingKey {
        case name, title, description, traits
        case funFact = "funFact"
    }
}