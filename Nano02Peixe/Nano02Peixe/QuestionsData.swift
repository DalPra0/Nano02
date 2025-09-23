//
//  QuestionsData.swift
//  FishQuiz
//

import Foundation

struct QuestionsData {
    static let questions: [Question] = [
        Question(
            text: "Como você reage quando está estressado?",
            answers: [
                Answer(text: "Procuro meus amigos para conversar", fishScores: ["Peixe Palhaço": 3, "Tilápia": 1]),
                Answer(text: "Parto para cima do problema", fishScores: ["Piranha": 3, "Peixe Lua": 1]),
                Answer(text: "Fico na minha até passar", fishScores: ["Peixe Bolha": 3, "Bagre": 2]),
                Answer(text: "Me adapto à situação", fishScores: ["Tilápia": 3, "Bagre": 2])
            ]
        ),
        
        Question(
            text: "Qual seu ambiente ideal para relaxar?",
            answers: [
                Answer(text: "Uma festa com muita gente", fishScores: ["Peixe Palhaço": 3, "Piranha": 1]),
                Answer(text: "Um lugar selvagem e aventueiro", fishScores: ["Piranha": 2, "Peixe Lua": 3]),
                Answer(text: "Sozinho em casa, sem pressão", fishScores: ["Peixe Bolha": 3, "Bagre": 2]),
                Answer(text: "Qualquer lugar, me adapto fácil", fishScores: ["Tilápia": 3, "Bagre": 1])
            ]
        ),
        
        Question(
            text: "Como você escolhe sua comida?",
            answers: [
                Answer(text: "Gosto de comer em grupo, social", fishScores: ["Peixe Palhaço": 3, "Tilápia": 1]),
                Answer(text: "Vou direto no que quero, sem hesitar", fishScores: ["Piranha": 3, "Peixe Lua": 1]),
                Answer(text: "Como o que estiver disponível", fishScores: ["Peixe Bolha": 2, "Bagre": 3]),
                Answer(text: "Sou bem flexível com comida", fishScores: ["Tilápia": 3, "Bagre": 1])
            ]
        ),
        
        Question(
            text: "Qual sua reação a algo completamente novo?",
            answers: [
                Answer(text: "Chamo os amigos para explorar juntos", fishScores: ["Peixe Palhaço": 3, "Tilápia": 1]),
                Answer(text: "Mergulho de cabeça na aventura", fishScores: ["Peixe Lua": 3, "Piranha": 2]),
                Answer(text: "Observo de longe primeiro", fishScores: ["Bagre": 3, "Peixe Bolha": 2]),
                Answer(text: "Tento entender como posso me adaptar", fishScores: ["Tilápia": 3, "Bagre": 1])
            ]
        ),
        
        Question(
            text: "Como você lida com críticas?",
            answers: [
                Answer(text: "Converso com amigos para me sentir melhor", fishScores: ["Peixe Palhaço": 3, "Tilápia": 1]),
                Answer(text: "Defendo meu ponto de vista com força", fishScores: ["Piranha": 3, "Peixe Lua": 1]),
                Answer(text: "Não me importo, eu sou assim mesmo", fishScores: ["Peixe Bolha": 3, "Bagre": 1]),
                Answer(text: "Analiso se tem fundamento e me adapto", fishScores: ["Bagre": 3, "Tilápia": 2])
            ]
        ),
        
        Question(
            text: "Qual seu estilo de comunicação?",
            answers: [
                Answer(text: "Bem animado e expressivo", fishScores: ["Peixe Palhaço": 3, "Piranha": 1]),
                Answer(text: "Direto e intenso", fishScores: ["Piranha": 3, "Peixe Lua": 1]),
                Answer(text: "Calmo e no meu ritmo", fishScores: ["Peixe Bolha": 3, "Bagre": 2]),
                Answer(text: "Me adapto ao estilo da pessoa", fishScores: ["Tilápia": 3, "Bagre": 1])
            ]
        )
    ]
}
