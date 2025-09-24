import SwiftUI

struct QuestionView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    @State private var selectedAnswerId: String? = nil
    @State private var showResult = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            QuizProgressView(
                progress: quizViewModel.progress,
                currentQuestion: quizViewModel.currentQuestionIndex + 1,
                totalQuestions: quizViewModel.questions.count
            )
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Pergunta
                    if let currentQuestion = quizViewModel.currentQuestion {
                        VStack(spacing: 20) {
                            Text("Pergunta \(quizViewModel.currentQuestionIndex + 1)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(currentQuestion.text)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 40)
                        
                        // Respostas
                        VStack(spacing: 12) {
                            ForEach(currentQuestion.answers) { answer in
                                AnswerButton(
                                    text: answer.text,
                                    isSelected: selectedAnswerId == answer.id
                                ) {
                                    selectedAnswerId = answer.id
                                    quizViewModel.selectAnswer(answer.id)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Botão próxima
                        if selectedAnswerId != nil {
                            Button {
                                if quizViewModel.currentQuestionIndex == quizViewModel.questions.count - 1 {
                                    // Última pergunta - mostrar resultado
                                    quizViewModel.nextQuestion()
                                    showResult = true
                                } else {
                                    // Próxima pergunta
                                    quizViewModel.nextQuestion()
                                    selectedAnswerId = nil
                                }
                            } label: {
                                HStack {
                                    Text(quizViewModel.currentQuestionIndex == quizViewModel.questions.count - 1 ? "Ver Resultado" : "Próxima")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: quizViewModel.currentQuestionIndex == quizViewModel.questions.count - 1 ? "star.fill" : "arrow.right")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.green, .blue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(radius: 3)
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                            .animation(.easeInOut, value: selectedAnswerId)
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showResult) {
            QuizResultView(quizViewModel: quizViewModel)
        }
        .onChange(of: quizViewModel.currentQuestionIndex) { _, _ in
            // Reset seleção quando muda pergunta
            selectedAnswerId = nil
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        QuestionView(quizViewModel: QuizViewModel())
    }
}