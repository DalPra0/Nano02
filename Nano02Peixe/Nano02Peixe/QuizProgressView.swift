//
//  QuizProgressView.swift
//  FishQuiz
//

import SwiftUI

struct QuizProgressView: View {
    let progress: Double
    let currentQuestion: Int
    let totalQuestions: Int
    
    var body: some View {
        VStack(spacing: 8) {
            // Texto do progresso
            HStack {
                Text("Pergunta \(currentQuestion + 1) de \(totalQuestions)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Barra de progresso
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    QuizProgressView(progress: 0.5, currentQuestion: 2, totalQuestions: 6)
}
