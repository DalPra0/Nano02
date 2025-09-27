import SwiftUI

struct QuizStartView: View {
    @StateObject private var quizViewModel = QuizViewModel()
    @State private var showQuiz = false
    
    // Estados para animações
    @State private var peixeDouradoOffset: CGFloat = 0
    @State private var tubaraoOffset: CGFloat = 0
    @State private var carangueijoOffset: CGFloat = 0
    @State private var estrelaRotation: Double = 0
    @State private var exclamacaoScale: Double = 1.0
    @State private var tituloFloat: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Image("wallpaperAzulClaro")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 1.1)
                        .clipped()
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
                            .clipped()
                    }
                    .offset(y: 0)
                    
                    let scaleX = geometry.size.width / 393
                    let scaleY = geometry.size.height / 852
                    
                    
                    Image("tituloPeixe")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.9)
                        .position(
                            x: geometry.size.width / 2,
                            y: 200 * scaleY
                        )
                        .offset(y: tituloFloat)
                    
                    Image("peixeDourado")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                            .frame(width: 170 * scaleX, height: 170 * scaleY)
                        .position(
                            x: 300 * scaleX,
                            y: 330 * scaleY
                        )
                        .offset(x: peixeDouradoOffset, y: peixeDouradoOffset * 0.5)
                    
                    Image("tubarao")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250 * scaleX, height: 160 * scaleY)
                        .rotationEffect(.degrees(-55))
                        .position(
                            x: 90 * scaleX,
                            y: 480 * scaleY
                        )
                        .offset(x: tubaraoOffset * 0.7, y: -tubaraoOffset * 0.3)
                    
                    Button {
                        showQuiz = true
                    } label: {
                        Image("botaoStart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.7)
                    }
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height - 160
                    )
                    
                    Image("carangueijoSegurandoPeixe")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300 * scaleX, height: 240 * scaleY)
                        .position(
                            x: 200 * scaleX,
                            y: geometry.size.height - 25
                        )
                        .offset(x: carangueijoOffset * 0.3)
                    
                    // Estrela - à esquerda do caranguejo
                    Image("assetEstrela")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60 * scaleX, height: 60 * scaleY)
                        .position(
                            x: 80 * scaleX,
                            y: geometry.size.height - 80
                        )
                        .rotationEffect(.degrees(estrelaRotation))
                    
                    // Raios amarelos - à direita do caranguejo, em cima dele
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
                }
            }
            .navigationDestination(isPresented: $showQuiz) {
                QuestionView(quizViewModel: quizViewModel)
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
    }
    
    private func startUnderwaterAnimations() {
        
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
    }
}

#Preview {
    QuizStartView()
}
