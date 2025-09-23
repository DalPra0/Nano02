//
//  Fish.swift
//  FishQuiz
//

import Foundation

struct Fish: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
    let traits: [String]
    
    init(name: String, description: String, imageName: String, traits: [String]) {
        self.name = name
        self.description = description
        self.imageName = imageName
        self.traits = traits
    }
}
