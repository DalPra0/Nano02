//
//  QuizResultView.swift
//  FishQuiz
//

import SwiftUI

struct QuizResultView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Título
                Text("Seu Resultado")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                if let result = quizViewModel.quizResult {
                    // Imagem do peixe (placeholder)
                    Image(systemName: "fish.fill")
                        .font(.system(size: 120))
                        .foregroundColor(.blue)
                    
                    // Nome do peixe
                    Text("Você é um")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text(result.fish.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    // Descrição
                    Text(result.fish.description)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Características
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Suas características:")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(result.fish.traits, id: \.self) { trait in
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                Text(trait.capitalized)
                                    .font(.body)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Botões
                VStack(spacing: 15) {
                    // Botão câmera (placeholder)
                    Button {
                        // TODO: Abrir câmera
                    } label: {
                        Text("📷 Criar Foto com Filtro")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Botão refazer quiz
                    Button {
                        quizViewModel.restartQuiz()
                        dismiss()
                    } label: {
                        Text("🔄 Refazer Quiz")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20)
            }
            .padding(.bottom, 50)
        }
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    let viewModel = QuizViewModel()
//    viewModel.quizResult = QuizResult(
//        fish: FishData.fishes[0],
//        totalScore: 15,
//        answeredQuestions: 6
//    )
//    QuizResultView(quizViewModel: viewModel)
//}
