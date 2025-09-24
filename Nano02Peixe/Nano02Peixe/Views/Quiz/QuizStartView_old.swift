//
//  QuizStartView.swift
//  FishQuiz
//

import SwiftUI

struct QuizStartView: View {
    @StateObject private var quizViewModel = QuizViewModel()
    @State private var showQuiz = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                // Título
                VStack(spacing: 10) {
                    Text("🐟")
                        .font(.system(size: 80))
                    
                    Text("Qual Peixe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Você É?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                // Descrição
                Text("Descubra sua personalidade aquática respondendo algumas perguntas divertidas!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Botão começar
                Button {
                    showQuiz = true
                } label: {
                    Text("Começar Quiz")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationDestination(isPresented: $showQuiz) {
                QuestionView(quizViewModel: quizViewModel)
            }
        }
    }
}

#Preview {
    QuizStartView()
}
