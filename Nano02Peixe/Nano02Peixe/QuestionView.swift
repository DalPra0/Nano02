//
//  QuestionView.swift
//  FishQuiz
//

import SwiftUI

struct QuestionView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    @State private var showResult = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            QuizProgressView(
                progress: quizViewModel.progress,
                currentQuestion: quizViewModel.currentQuestionIndex,
                totalQuestions: quizViewModel.questions.count
            )
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Pergunta
                    VStack(spacing: 20) {
                        Text(quizViewModel.currentQuestion.text)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 40)
                    
                    // Respostas
                    VStack(spacing: 12) {
                        ForEach(0..<quizViewModel.currentQuestion.answers.count, id: \.self) { index in
                            AnswerButton(
                                text: quizViewModel.currentQuestion.answers[index].text,
                                isSelected: quizViewModel.selectedAnswerIndex == index
                            ) {
                                quizViewModel.selectAnswer(at: index)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Botão próxima
                    if quizViewModel.hasAnswered {
                        Button {
                            if quizViewModel.isLastQuestion {
                                quizViewModel.nextQuestion()
                                showResult = true
                            } else {
                                quizViewModel.nextQuestion()
                            }
                        } label: {
                            Text(quizViewModel.isLastQuestion ? "Ver Resultado" : "Próxima")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showResult) {
            QuizResultView(quizViewModel: quizViewModel)
        }
    }
}

#Preview {
    QuestionView(quizViewModel: QuizViewModel())
}
