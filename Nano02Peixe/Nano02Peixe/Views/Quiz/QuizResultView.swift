import SwiftUI

struct QuizResultView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showCamera = false
    @State private var animateResult = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header com confete
                VStack(spacing: 15) {
                    Text("🎉")
                        .font(.system(size: 60))
                        .scaleEffect(animateResult ? 1.2 : 1.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: animateResult)
                    
                    Text("Resultado do Quiz!")
                        .font(.title)
                        .fontWeight(.bold)
                        .opacity(animateResult ? 1.0 : 0.0)
                        .animation(.easeInOut.delay(0.4), value: animateResult)
                }
                .padding(.top, 20)
                
                if let result = quizViewModel.quizResult {
                    // Card do peixe
                    VStack(spacing: 20) {
                        // Emoji/Imagem do peixe (grande)
                        Text("🐟")
                            .font(.system(size: 100))
                            .scaleEffect(animateResult ? 1.0 : 0.5)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6), value: animateResult)
                        
                        // Título da personalidade
                        VStack(spacing: 8) {
                            Text("Você é:")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text(result.fish.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .multilineTextAlignment(.center)
                            
                            Text(result.fish.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.teal)
                                .multilineTextAlignment(.center)
                        }
                        .opacity(animateResult ? 1.0 : 0.0)
                        .animation(.easeInOut.delay(0.8), value: animateResult)
                    }
                    .padding(25)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(radius: 10)
                    )
                    .padding(.horizontal)
                    
                    // Descrição
                    Text(result.fish.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .opacity(animateResult ? 1.0 : 0.0)
                        .animation(.easeInOut.delay(1.0), value: animateResult)
                    
                    // Características (traits)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("🌟 Suas Características:")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(Array(result.fish.traits.enumerated()), id: \.offset) { index, trait in
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(trait)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                }
                                .opacity(animateResult ? 1.0 : 0.0)
                                .animation(.easeInOut.delay(1.2 + Double(index) * 0.1), value: animateResult)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.systemGray6))
                    )
                    .padding(.horizontal)
                    
                    // Fun Fact
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🤓 Curiosidade:")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(result.fish.funFact)
                            .font(.body)
                            .italic()
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.systemBlue).opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.blue, lineWidth: 1)
                            )
                    )
                    .padding(.horizontal)
                    .opacity(animateResult ? 1.0 : 0.0)
                    .animation(.easeInOut.delay(1.6), value: animateResult)
                    
                    // Score info
                    HStack {
                        Text("Pontuação: \(result.totalScore) pontos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(result.percentage)% de compatibilidade")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .opacity(animateResult ? 1.0 : 0.0)
                    .animation(.easeInOut.delay(1.8), value: animateResult)
                }
                
                // Botões de ação
                VStack(spacing: 15) {
                    // Botão câmera - AGORA FUNCIONANDO!
                    Button {
                        showCamera = true
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                                .font(.title3)
                            Text("Criar Filtro de Peixe")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .pink]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                    .opacity(animateResult ? 1.0 : 0.0)
                    .animation(.easeInOut.delay(2.0), value: animateResult)
                    
                    // Botão refazer
                    Button {
                        quizViewModel.restartQuiz()
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .font(.title3)
                            Text("Refazer Quiz")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    .opacity(animateResult ? 1.0 : 0.0)
                    .animation(.easeInOut.delay(2.2), value: animateResult)
                }
                .padding(.top, 10)
            }
            .padding(.bottom, 50)
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .onAppear {
            animateResult = true
        }
        // ✅ AGORA INTEGRADO COM CAMERA VIEW!
        .fullScreenCover(isPresented: $showCamera) {
            if let result = quizViewModel.quizResult {
                CameraView(quizResult: result)
            }
        }
    }
}

#Preview {
    let viewModel = QuizViewModel()
    // Simulando um resultado
    if let fishPersonality = QuestionsDataLoader.shared.fishPersonalities["Peixe palhaço"] {
        let fish = Fish(
            name: fishPersonality.name,
            title: fishPersonality.title,
            description: fishPersonality.description,
            traits: fishPersonality.traits,
            funFact: fishPersonality.funFact
        )
        viewModel.quizResult = QuizResult(
            fish: fish,
            totalScore: 28,
            answers: ["A", "B", "C", "A", "B", "C"]
        )
    }
    return NavigationStack {
        QuizResultView(quizViewModel: viewModel)
    }
}
