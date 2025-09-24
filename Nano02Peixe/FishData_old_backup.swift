//
//  FishData.swift
//  FishQuiz
//

import Foundation

struct FishData {
    static let fishes: [Fish] = [
        Fish(
            name: "Peixe Palhaço",
            description: "Você é sociável, colorido e adora viver em grupos! Sempre animado e otimista.",
            imageName: "clownfish",
            traits: ["sociável", "colorido", "otimista", "protetor"]
        ),
        Fish(
            name: "Piranha",
            description: "Você é intenso, determinado e não tem medo de ir atrás do que quer! Energia pura.",
            imageName: "piranha", 
            traits: ["intenso", "determinado", "agressivo", "corajoso"]
        ),
        Fish(
            name: "Peixe Bolha",
            description: "Você é único, relaxado e não se importa com a opinião dos outros. Autenticidade é seu forte!",
            imageName: "blobfish",
            traits: ["único", "relaxado", "autêntico", "tranquilo"]
        ),
        Fish(
            name: "Tilápia",
            description: "Você é adaptável, prático e se dá bem em qualquer ambiente. Super versátil!",
            imageName: "tilapia",
            traits: ["adaptável", "prático", "versátil", "resiliente"]
        ),
        Fish(
            name: "Peixe Lua",
            description: "Você é misterioso, grande em personalidade e adora explorar coisas novas!",
            imageName: "sunfish",
            traits: ["misterioso", "explorador", "grande", "curioso"]
        ),
        Fish(
            name: "Bagre",
            description: "Você é down-to-earth, sábio e sempre procura o que há de melhor em cada situação.",
            imageName: "catfish",
            traits: ["sábio", "prático", "observador", "persistente"]
        )
    ]
}
