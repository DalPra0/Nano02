//
//  Constants.swift
//  FishQuiz
//
//  Constantes utilizadas no projeto
//

import Foundation
import SwiftUI

struct Constants {
    
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color(.systemGray6)
        static let accent = Color.green
        static let background = Color(.systemBackground)
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
    }
    
    struct Sizes {
        static let buttonHeight: CGFloat = 50
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let iconSize: CGFloat = 24
    }
    
    struct Texts {
        static let appTitle = "Qual Peixe Você É?"
        static let startButtonTitle = "Começar Quiz"
        static let nextButtonTitle = "Próxima"
        static let resultButtonTitle = "Ver Resultado"
        static let restartButtonTitle = "🔄 Refazer Quiz"
        static let cameraButtonTitle = "📷 Criar Foto com Filtro"
        static let resultTitle = "Seu Resultado"
        static let youAreText = "Você é um"
        static let traitsTitle = "Suas características:"
    }
    
    struct Quiz {
        static let totalQuestions = 6 // Será atualizado quando todos os arquivos estiverem no target
        // static let availableFishes = FishData.fishes // Comentado temporariamente
    }
}
