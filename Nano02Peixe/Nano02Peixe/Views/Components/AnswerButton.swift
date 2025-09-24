import SwiftUI

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                // Círculo de seleção
                Circle()
                    .strokeBorder(isSelected ? .clear : .gray, lineWidth: 2)
                    .background(
                        Circle()
                            .fill(isSelected ? .blue : .clear)
                    )
                    .frame(width: 20, height: 20)
                    .overlay {
                        if isSelected {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                    }
                
                // Texto da resposta
                Text(text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected ? 
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .teal]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [Color(.systemGray6)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .clear : Color(.systemGray4), lineWidth: 1)
            )
            .shadow(
                color: isSelected ? .blue.opacity(0.3) : .clear,
                radius: isSelected ? 8 : 0
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
    }
}

#Preview {
    VStack(spacing: 15) {
        AnswerButton(text: "Esta é uma resposta de exemplo bem longa que vai quebrar em várias linhas para testar o layout", isSelected: false) {}
        AnswerButton(text: "Esta resposta está selecionada", isSelected: true) {}
        AnswerButton(text: "Resposta normal", isSelected: false) {}
    }
    .padding()
    .preferredColorScheme(.dark)
}