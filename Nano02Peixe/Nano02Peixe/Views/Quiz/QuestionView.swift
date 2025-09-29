import SwiftUI

struct QuestionView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    @State private var selectedAnswerId: String? = nil
    @State private var showResult = false
    
    // Animações dos wallpapers (igual QuizStartView)
    @State private var wallpaperClaroOffset: CGFloat = 0
    @State private var wallpaperEscuroOffset: CGFloat = 0
    
    // Peixes em posições específicas
    @State private var peixeEsquerda: String = ""
    @State private var peixeDireita: String = ""
    @State private var peixeBaixo: String = ""
    @State private var animacaoPeixe1: CGFloat = 0
    @State private var animacaoPeixe2: CGFloat = 0
    @State private var animacaoPeixe3: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundView(geometry: geometry)
                mainContentView(geometry: geometry)
                bottomFishView(geometry: geometry)
            }
            .onAppear {
                startAnimations()
                randomizePeixes()
            }
            .onChange(of: quizViewModel.currentQuestionIndex) { _, _ in
                selectedAnswerId = nil
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showResult) {
            QuizResultView(quizViewModel: quizViewModel)
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Background View
    @ViewBuilder
    private func backgroundView(geometry: GeometryProxy) -> some View {
        // WALLPAPER AZUL CLARO - Base
        Image("wallpaperAzulClaro")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .ignoresSafeArea()
        
        Image("wallpaperAzulClaro")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .offset(x: wallpaperClaroOffset, y: wallpaperClaroOffset * 0.5)
            .ignoresSafeArea()
        
        // WALLPAPER AZUL ESCURO - Parte de baixo
        VStack {
            Spacer()
            
            Image("wallpaperAzulEscuro")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                .ignoresSafeArea()
        }
        .offset(x: wallpaperEscuroOffset * 0.7, y: wallpaperEscuroOffset * 0.3)
    }
    
    // MARK: - Main Content View
    @ViewBuilder
    private func mainContentView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Progress Bar
            QuizProgressView(
                progress: quizViewModel.progress,
                currentQuestion: quizViewModel.currentQuestionIndex + 1,
                totalQuestions: quizViewModel.questions.count
            )
            .padding(.top, 50)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    if let currentQuestion = quizViewModel.currentQuestion {
                        questionSection(currentQuestion: currentQuestion, geometry: geometry)
                        answersSection(currentQuestion: currentQuestion, geometry: geometry)
                        nextButtonSection()
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    // MARK: - Question Section
    @ViewBuilder
    private func questionSection(currentQuestion: Question, geometry: GeometryProxy) -> some View {
        ZStack {
            // Peixe à esquerda da pergunta
            if !peixeEsquerda.isEmpty {
                Image(peixeEsquerda)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .position(x: 40, y: 50)
                    .offset(y: animacaoPeixe1)
                    .opacity(0.7)
            }
            
            // Asset de fundo para a pergunta
            Image("fundoPergunta")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width * 0.85)
                .overlay(
                    VStack(spacing: 8) {
                        Text("Pergunta \(quizViewModel.currentQuestionIndex + 1)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text(currentQuestion.text)
                            .font(.system(size: 18, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .lineLimit(5)
                            .minimumScaleFactor(0.7)
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 10)
                )
        }
        .frame(height: 150)
        .padding(.top, 10)
    }
    
    // MARK: - Answers Section
    @ViewBuilder
    private func answersSection(currentQuestion: Question, geometry: GeometryProxy) -> some View {
        ZStack {
            // Peixe atrás das respostas (direita)
            if !peixeDireita.isEmpty {
                Image(peixeDireita)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .position(
                        x: geometry.size.width - 50,
                        y: 120
                    )
                    .offset(x: animacaoPeixe2)
                    .opacity(0.5)
            }
            
            // Respostas
            VStack(spacing: 12) {
                ForEach(currentQuestion.answers) { answer in
                    answerButton(answer: answer)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Answer Button
    @ViewBuilder
    private func answerButton(answer: Answer) -> some View {
        Button {
            selectedAnswerId = answer.id
            quizViewModel.selectAnswer(answer.id)
        } label: {
            ZStack {
                // Fundo da resposta
                Image("fundoOpcoesRespostas")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 65)
                    .frame(maxWidth: .infinity)
                    .opacity(selectedAnswerId == answer.id ? 1.0 : 0.85)
                    .overlay(
                        selectedAnswerId == answer.id ?
                        Color.blue.opacity(0.25) : Color.clear
                    )
                
                HStack(spacing: 12) {
                    // Círculo de seleção
                    Circle()
                        .strokeBorder(
                            selectedAnswerId == answer.id ? .white : .white.opacity(0.6),
                            lineWidth: 2
                        )
                        .background(
                            Circle().fill(
                                selectedAnswerId == answer.id ? .white : .clear
                            )
                        )
                        .frame(width: 20, height: 20)
                        .overlay {
                            if selectedAnswerId == answer.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                    
                    Text(answer.text)
                        .font(.system(size: 15))
                        .fontWeight(selectedAnswerId == answer.id ? .semibold : .regular)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 65)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(
                color: selectedAnswerId == answer.id ? .blue.opacity(0.3) : .black.opacity(0.15),
                radius: selectedAnswerId == answer.id ? 6 : 3,
                y: 2
            )
            .scaleEffect(selectedAnswerId == answer.id ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedAnswerId)
    }
    
    // MARK: - Next Button Section
    @ViewBuilder
    private func nextButtonSection() -> some View {
        if selectedAnswerId != nil {
            Button {
                if quizViewModel.currentQuestionIndex == quizViewModel.questions.count - 1 {
                    quizViewModel.nextQuestion()
                    showResult = true
                } else {
                    quizViewModel.nextQuestion()
                    selectedAnswerId = nil
                    randomizePeixes()
                }
            } label: {
                HStack {
                    Text(quizViewModel.currentQuestionIndex == quizViewModel.questions.count - 1 ? "Ver Resultado" : "Próxima")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Image(systemName: quizViewModel.currentQuestionIndex == quizViewModel.questions.count - 1 ? "star.fill" : "arrow.right")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "00B4D8"), Color(hex: "0077B6")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 5, y: 3)
            }
            .padding(.horizontal, 25)
            .padding(.top, 15)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedAnswerId)
        }
    }
    
    // MARK: - Bottom Fish View
    @ViewBuilder
    private func bottomFishView(geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            
            if peixeBaixo == "carangueijoSegurandoPeixe" {
                Image("carangueijoSegurandoPeixe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 200)
                    .offset(x: animacaoPeixe3)
            } else if !peixeBaixo.isEmpty {
                Image(peixeBaixo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 120)
                    .offset(x: animacaoPeixe3 * 0.5, y: -20)
                    .opacity(0.6)
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Helper Functions
    private func randomizePeixes() {
        let peixesDisponiveis = ["axlote", "baiacu", "dory", "fihh", "peixeDourado", "peixeFeio", "tubarao", "tubaraobobo"]
        
        // Decide se vai ter caranguejo embaixo
        let temCaranguejo = Bool.random()
        
        if temCaranguejo {
            peixeBaixo = Bool.random() ? "carangueijoSegurandoPeixe" : "carangueijo"
            
            // Escolhe 2 peixes aleatórios para os lados
            let shuffled = peixesDisponiveis.shuffled()
            peixeEsquerda = shuffled[0]
            peixeDireita = shuffled[1]
        } else {
            // Escolhe 3 peixes aleatórios
            let shuffled = peixesDisponiveis.shuffled()
            peixeEsquerda = shuffled[0]
            peixeDireita = shuffled[1]
            peixeBaixo = shuffled[2]
        }
    }
    
    private func startAnimations() {
        // Animações dos wallpapers
        withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
            wallpaperClaroOffset = 8
        }
        
        withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
            wallpaperEscuroOffset = 12
        }
        
        // Animações dos peixes
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            animacaoPeixe1 = 10
        }
        
        withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
            animacaoPeixe2 = -12
        }
        
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            animacaoPeixe3 = 8
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    NavigationStack {
        QuestionView(quizViewModel: QuizViewModel())
    }
}
