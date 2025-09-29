import SwiftUI

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Usa o asset fundoOpcoesRespostas como background
                Image("fundoOpcoesRespostas")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 65)
                    .opacity(isSelected ? 1.0 : 0.85)
                    .overlay(
                        // Overlay azul quando selecionado
                        isSelected ? Color.blue.opacity(0.25) : Color.clear
                    )
                
                HStack(spacing: 12) {
                    Circle()
                        .strokeBorder(isSelected ? .white : .white.opacity(0.6), lineWidth: 2)
                        .background(
                            Circle()
                                .fill(isSelected ? .white : .clear)
                        )
                        .frame(width: 20, height: 20)
                        .overlay {
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                    
                    Text(text)
                        .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(
                color: isSelected ? .blue.opacity(0.3) : .black.opacity(0.15),
                radius: isSelected ? 6 : 3,
                y: 2
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
    .background(Color.blue.opacity(0.3))
}