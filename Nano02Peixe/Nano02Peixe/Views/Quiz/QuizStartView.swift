import SwiftUI

struct QuizStartView: View {
    @StateObject private var quizViewModel = QuizViewModel()
    @State private var showQuiz = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 10) {
                    Text("🐟")
                        .font(.system(size: 80))
                    
                    Text(quizViewModel.quizTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                
                Text(quizViewModel.quizDescription)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 8) {
                    Text("🎯 \(quizViewModel.questions.count) perguntas divertidas")
                    Text("🐠 16 personalidades diferentes")
                    Text("⏱️ ~3 minutos")
                }
                .font(.callout)
                .foregroundColor(.secondary)
                
                Spacer()
                
                Button {
                    showQuiz = true
                } label: {
                    HStack {
                        Text("Começar Quiz")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .teal]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationDestination(isPresented: $showQuiz) {
                QuestionView(quizViewModel: quizViewModel)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    QuizStartView()
}
