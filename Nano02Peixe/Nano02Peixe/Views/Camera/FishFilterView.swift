import SwiftUI

struct FishFilterView: View {
    let capturedImage: UIImage
    let quizResult: QuizResult
    
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var processedResult: ImageProcessingService.ProcessedImageResult?
    @State private var errorMessage: String?
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if isProcessing {
                processingView
            } else if let result = processedResult {
                resultView(result)
            } else if let error = errorMessage {
                errorView(error)
            } else {
                initialView
            }
        }
        .onAppear {
            startProcessing()
        }
        .sheet(isPresented: $showShareSheet) {
            if let result = processedResult {
                ShareSheet(items: [result.processedImage])
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Views
    
    private var processingView: some View {
        VStack(spacing: 30) {
            // Animação de processamento
            VStack(spacing: 20) {
                Text("🐟")
                    .font(.system(size: 60))
                    .scaleEffect(isProcessing ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isProcessing)
                
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            }
            
            VStack(spacing: 15) {
                Text("Aplicando Filtro")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Transformando você em \(quizResult.fish.name)...")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Text("Detectando características faciais...")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal)
        }
    }
    
    private var initialView: some View {
        VStack(spacing: 30) {
            Text("Preparando Filtro")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(quizResult.fish.name)
                .font(.title3)
                .foregroundColor(.blue)
        }
    }
    
    private func resultView(_ result: ImageProcessingService.ProcessedImageResult) -> some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Fechar") {
                    dismiss()
                }
                .foregroundColor(.white)
                .padding()
                
                Spacer()
                
                VStack {
                    Text("Filtro Aplicado!")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(quizResult.fish.name)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button("Compartilhar") {
                    showShareSheet = true
                }
                .foregroundColor(.white)
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [.black.opacity(0.8), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Imagem processada
            ScrollView {
                VStack(spacing: 20) {
                    // Imagem principal
                    Image(uiImage: result.processedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding()
                    
                    // Informações do processamento
                    VStack(spacing: 15) {
                        Text("✨ Características Aplicadas:")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                            ForEach(result.fishCharacteristics, id: \.self) { characteristic in
                                Text(characteristic)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(15)
                            }
                        }
                        
                        // Info técnica
                        Text("Processado em \(String(format: "%.2f", result.processingTime))s")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
            }
            
            // Botões de ação
            VStack(spacing: 15) {
                // Compartilhar (principal)
                Button {
                    showShareSheet = true
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3)
                        Text("Compartilhar Resultado")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                
                // Tentar novamente
                Button {
                    resetAndRetry()
                } label: {
                    HStack {
                        Image(systemName: "camera.rotate")
                        Text("Tirar Nova Foto")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                }
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [.clear, .black.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
    
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 30) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            VStack(spacing: 15) {
                Text("Ops! Algo deu errado")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(error)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 15) {
                Button("Tentar Novamente") {
                    startProcessing()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(15)
                
                Button("Voltar") {
                    dismiss()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Actions
    
    private func startProcessing() {
        isProcessing = true
        errorMessage = nil
        processedResult = nil
        
        print("🚀 FishFilterView: Iniciando processamento de filtro...")
        
        // Passo 1: Detectar rosto
        FaceDetectionService.shared.detectFace(in: capturedImage) { result in
            switch result {
            case .success(let faceResult):
                print("✅ Rosto detectado, aplicando filtro...")
                
                // Verificar qualidade da detecção
                guard FaceDetectionService.shared.isDetectionQualityGood(faceResult) else {
                    self.isProcessing = false
                    self.errorMessage = "Qualidade da detecção muito baixa. Tente uma foto com melhor iluminação e posicionamento frontal."
                    return
                }
                
                // Passo 2: Aplicar filtro
                ImageProcessingService.shared.applyFishFilter(
                    to: self.capturedImage,
                    using: faceResult,
                    for: self.quizResult.fish
                ) { filterResult in
                    self.isProcessing = false
                    
                    switch filterResult {
                    case .success(let processedResult):
                        print("🎉 Filtro aplicado com sucesso!")
                        self.processedResult = processedResult
                        
                    case .failure(let error):
                        print("❌ Erro ao aplicar filtro: \(error)")
                        self.errorMessage = error.localizedDescription
                    }
                }
                
            case .failure(let error):
                print("❌ Erro na detecção facial: \(error)")
                self.isProcessing = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func resetAndRetry() {
        dismiss()
        // Volta para câmera - será implementado na navegação
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview
#Preview {
    let mockResult = QuizResult(
        fish: Fish(
            name: "Peixe palhaço",
            title: "O Sociável Protetor",
            description: "Você é a pessoa que todo mundo quer ter por perto!",
            traits: ["Sociável", "Leal", "Divertido"],
            funFact: "Como o peixe palhaço, você é super leal aos amigos!"
        ),
        totalScore: 28,
        answers: ["A", "B", "C"]
    )
    
    // Criar uma imagem mock para preview
    let mockImage = UIImage(systemName: "person.crop.circle.fill") ?? UIImage()
    
    FishFilterView(capturedImage: mockImage, quizResult: mockResult)
}
