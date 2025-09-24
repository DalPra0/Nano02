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
        
        static let primaryGradient = LinearGradient(
            gradient: Gradient(colors: [.blue, .teal]),
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let successGradient = LinearGradient(
            gradient: Gradient(colors: [.green, .blue]),
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let cameraGradient = LinearGradient(
            gradient: Gradient(colors: [.purple, .pink]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    struct Sizes {
        static let buttonHeight: CGFloat = 50
        static let cornerRadius: CGFloat = 12
        static let largecornerRadius: CGFloat = 16
        static let padding: CGFloat = 16
        static let iconSize: CGFloat = 24
        static let fishEmojiSize: CGFloat = 100
    }
    
    struct Texts {
        static let appTitle = "Qual Peixe Você É?"
        static let appDescription = "Descubra qual dos 16 peixes representa melhor sua personalidade!"
        static let startButtonTitle = "Começar Quiz"
        static let nextButtonTitle = "Próxima"
        static let resultButtonTitle = "Ver Resultado"
        static let restartButtonTitle = "Refazer Quiz"
        static let cameraButtonTitle = "Criar Filtro de Peixe"
        static let resultTitle = "Resultado do Quiz!"
        static let youAreText = "Você é:"
        static let traitsTitle = "🌟 Suas Características:"
        static let funFactTitle = "🤓 Curiosidade:"
    }
    
    struct Quiz {
        static let totalQuestions = 12
        static let totalFishes = 16
        static let maxScorePerQuestion = 4
        static let maxPossibleScore = totalQuestions * maxScorePerQuestion // 48
    }
    
    struct Animations {
        static let springResponse: Double = 0.3
        static let springDamping: Double = 0.8
        static let easeInOutDuration: Double = 0.5
        static let resultAnimationDelay: Double = 0.2
        static let traitAnimationDelay: Double = 0.1
    }
}
