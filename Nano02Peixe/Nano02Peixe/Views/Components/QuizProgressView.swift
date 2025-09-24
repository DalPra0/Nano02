import SwiftUI

struct QuizProgressView: View {
    let progress: Double
    let currentQuestion: Int
    let totalQuestions: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Pergunta \(currentQuestion) de \(totalQuestions)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .teal]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: CGFloat(progress) * UIScreen.main.bounds.width * 0.85, height: 8)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
            
            HStack(spacing: 4) {
                ForEach(0..<totalQuestions, id: \.self) { index in
                    Circle()
                        .fill(index < currentQuestion ? .blue : .gray.opacity(0.3))
                        .frame(width: 6, height: 6)
                        .scaleEffect(index == currentQuestion - 1 ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3), value: currentQuestion)
                }
            }
            .padding(.top, 4)
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 30) {
        QuizProgressView(progress: 0.25, currentQuestion: 3, totalQuestions: 12)
        QuizProgressView(progress: 0.5, currentQuestion: 6, totalQuestions: 12)
        QuizProgressView(progress: 0.83, currentQuestion: 10, totalQuestions: 12)
    }
    .padding()
    .preferredColorScheme(.dark)
}
