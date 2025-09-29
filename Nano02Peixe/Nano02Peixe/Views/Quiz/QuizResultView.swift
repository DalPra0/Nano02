import SwiftUI

struct QuizResultView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showCamera = false
    @State private var animateResult = false
    
    // Animações dos wallpapers (IGUAL QuizStartView)
    @State private var wallpaperClaroOffset: CGFloat = 0
    @State private var wallpaperEscuroOffset: CGFloat = 0
    
    // Animações dos peixes decorativos (IGUAL QuizStartView)
    @State private var peixeDouradoOffset: CGFloat = 0
    @State private var tubaraoOffset: CGFloat = 0
    @State private var carangueijoOffset: CGFloat = 0
    @State private var estrelaRotation: Double = 0
    @State private var exclamacaoScale: Double = 1.0
    @State private var resultFloat: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // WALLPAPERS - EXATAMENTE IGUAL QuizStartView
                Image("wallpaperAzulClaro")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 1.1)
                    .ignoresSafeArea()
                
                Image("wallpaperAzulClaro")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 1.1)
                    .offset(x: wallpaperClaroOffset, y: wallpaperClaroOffset * 0.5)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image("wallpaperAzulEscuro")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: geometry.size.width * 1.1,
                            height: geometry.size.height * 0.5
                        )
                        .ignoresSafeArea()
                }
                .offset(y: 0)
                .offset(x: wallpaperEscuroOffset * 0.7, y: wallpaperEscuroOffset * 0.3)
                
                let scaleX = geometry.size.width / 393
                let scaleY = geometry.size.height / 852
                
                // PEIXES DECORATIVOS - IGUAL QuizStartView
                Image("peixeDourado")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 170 * scaleX, height: 170 * scaleY)
                    .position(
                        x: 300 * scaleX,
                        y: 100 * scaleY
                    )
                    .offset(x: peixeDouradoOffset, y: peixeDouradoOffset * 0.5)
                    .opacity(0.6)
                
                Image("tubarao")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250 * scaleX, height: 160 * scaleY)
                    .rotationEffect(.degrees(-55))
                    .position(
                        x: 90 * scaleX,
                        y: 300 * scaleY
                    )
                    .offset(x: tubaraoOffset * 0.7, y: -tubaraoOffset * 0.3)
                    .opacity(0.6)
                
                // CONTEÚDO PRINCIPAL DO RESULTADO
                ScrollView {
                    VStack(spacing: 25) {
                        // Título
                        VStack(spacing: 10) {
                            Text("🎉 RESULTADO 🎉")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                                .scaleEffect(animateResult ? 1.1 : 1.0)
                                .offset(y: resultFloat)
                        }
                        .padding(.top, 60)
                        
                        if let result = quizViewModel.quizResult {
                            // CARD DO PEIXE RESULTADO
                            ZStack {
                                // Fundo do card
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .frame(width: geometry.size.width * 0.9, height: 300)
                                    .shadow(radius: 10)
                                
                                VStack(spacing: 15) {
                                    Text("Você é:")
                                        .font(.title2)
                                        .foregroundColor(.white.opacity(0.9))
                                    
                                    // FOTO DO PEIXE RESULTADO (não emoji)
                                    Image(getFishImageName(for: result.fish.name))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(.white, lineWidth: 3)
                                        )
                                        .shadow(radius: 5)
                                        .scaleEffect(animateResult ? 1.0 : 0.5)
                                    
                                    Text(result.fish.name)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    
                                    Text(result.fish.title)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.teal)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.horizontal, 20)
                            .opacity(animateResult ? 1.0 : 0.0)
                            
                            // DESCRIÇÃO
                            Text(result.fish.description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .shadow(color: .black.opacity(0.2), radius: 1)
                                .opacity(animateResult ? 1.0 : 0.0)
                                .animation(.easeInOut.delay(0.5), value: animateResult)
                            
                            // CARACTERÍSTICAS
                            VStack(alignment: .leading, spacing: 15) {
                                Text("🌟 Características")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                ForEach(Array(result.fish.traits.enumerated()), id: \.offset) { _, trait in
                                    HStack(spacing: 10) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.caption)
                                        
                                        Text(trait)
                                            .font(.body)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(20)
                            .frame(width: geometry.size.width * 0.9)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.ultraThinMaterial)
                            )
                            .opacity(animateResult ? 1.0 : 0.0)
                            .animation(.easeInOut.delay(0.8), value: animateResult)
                            
                            // CURIOSIDADE
                            VStack(spacing: 10) {
                                Text("🤓 Curiosidade")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text(result.fish.funFact)
                                    .font(.body)
                                    .italic()
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(20)
                            .frame(width: geometry.size.width * 0.9)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.blue.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(.blue, lineWidth: 1)
                                    )
                            )
                            .opacity(animateResult ? 1.0 : 0.0)
                            .animation(.easeInOut.delay(1.0), value: animateResult)
                            
                            // BOTÕES
                            VStack(spacing: 15) {
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
                                    .frame(width: geometry.size.width * 0.8)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.purple, .pink]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(25)
                                    .shadow(radius: 5)
                                }
                                
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
                                    .frame(width: geometry.size.width * 0.8)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(.blue, lineWidth: 2)
                                    )
                                    .cornerRadius(25)
                                }
                            }
                            .padding(.top, 20)
                            .opacity(animateResult ? 1.0 : 0.0)
                            .animation(.easeInOut.delay(1.2), value: animateResult)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
                
                // CARANGUEJO EMBAIXO - IGUAL QuizStartView
                Image("carangueijoSegurandoPeixe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300 * scaleX, height: 240 * scaleY)
                    .position(
                        x: 200 * scaleX,
                        y: geometry.size.height - 25
                    )
                    .offset(x: carangueijoOffset * 0.3)
                
                // ASSETS DECORATIVOS - IGUAL QuizStartView
                Image("assetEstrela")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60 * scaleX, height: 60 * scaleY)
                    .position(
                        x: 80 * scaleX,
                        y: geometry.size.height - 80
                    )
                    .rotationEffect(.degrees(estrelaRotation))
                
                Image("assetExclamacao")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50 * scaleX, height: 50 * scaleY)
                    .position(
                        x: 340 * scaleX,
                        y: geometry.size.height - 80
                    )
                    .scaleEffect(exclamacaoScale)
            }
            .onAppear {
                startUnderwaterAnimations()
                animateResult = true
            }
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.light) // IGUAL QuizStartView
        .fullScreenCover(isPresented: $showCamera) {
            if let result = quizViewModel.quizResult {
                CameraView(quizResult: result)
            }
        }
    }
    
    // Função para pegar o nome correto da imagem
    private func getFishImageName(for fishName: String) -> String {
        switch fishName {
        case "Peixe-mão liso":
            return "peixe-mao-liso"
        case "Peixe-espátula-chinês":
            return "peixe-espatula-chines"
        case "Peixe jacaré":
            return "peixe-jacare"
        case "Peixe dragão":
            return "peixe-dragao"
        case "Esturjão":
            return "esturjao"
        case "Peixe palhaço":
            return "peixe-palhaco"
        case "Peixe lua":
            return "peixe-lua"
        case "Piranha":
            return "piranha"
        case "Peixe pedra":
            return "peixe-pedra"
        case "Peixe-víbora de Sloane":
            return "peixe-vibora-sloane"
        case "Peixe-pescador":
            return "peixe-pescador"
        case "Pirarucu":
            return "pirarucu"
        case "Peixe bolha":
            return "peixe-bolha"
        case "Pacu":
            return "pacu"
        case "Bagre":
            return "bagre"
        case "Tilápia":
            return "tilapia"
        default:
            return fishName.lowercased().replacingOccurrences(of: " ", with: "-")
        }
    }
    
    private func startUnderwaterAnimations() {
        // EXATAMENTE IGUAL QuizStartView
        withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
            wallpaperClaroOffset = 8
        }
        
        withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
            wallpaperEscuroOffset = 12
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            peixeDouradoOffset = 12
        }
        
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            tubaraoOffset = 20
        }
        
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            carangueijoOffset = 8
        }
        
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            estrelaRotation = 8
        }
        
        withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
            exclamacaoScale = 1.05
        }
        
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            resultFloat = 3
        }
    }
}

#Preview {
    let viewModel = QuizViewModel()
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