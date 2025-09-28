import SwiftUI

struct FishFilterView: View {
    let capturedImage: UIImage
    let quizResult: QuizResult
    
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var processedResult: ImageProcessingService.ProcessedImageResult?
    @State private var errorMessage: String?
    @State private var showShareSheet = false
    @State private var processingStep = "Preparando..."
    
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
    
    
    private var processingView: some View {
        VStack(spacing: 30) {
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
                Text("Criando Filtro")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Transformando você em \(quizResult.fish.name)...")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Text(processingStep)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .animation(.easeInOut, value: processingStep)
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
            HStack {
                Button("Fechar") {
                    dismiss()
                }
                .foregroundColor(.white)
                .padding()
                
                Spacer()
                
                VStack {
                    Text("Filtro Criado!")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(result.fishName)
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
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 15) {
                        Text("🎉 Resultado Final")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Image(uiImage: result.processedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .shadow(radius: 15)
                            )
                    }
                    .padding()
                    
                    HStack(spacing: 15) {
                        VStack(spacing: 8) {
                            Text("📸 Sua Foto")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Image(uiImage: result.originalImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        
                        Text("+")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.6))
                        
                        VStack(spacing: 8) {
                            Text("🐟 \(result.fishName)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                            
                            Image(uiImage: result.fishImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.green)
                            Text("Processado em \(String(format: "%.2f", result.processingTime))s")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Spacer()
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Sucesso")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Text("Seu rosto foi aplicado sobre o corpo do \(result.fishName)!")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
            }
            
            VStack(spacing: 15) {
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
            
            VStack(alignment: .leading, spacing: 8) {
                Text("💡 Dicas:")
                    .font(.headline)
                    .foregroundColor(.yellow)
                
                Text("• Certifique-se que há boa iluminação")
                Text("• Posicione o rosto de frente para a câmera")
                Text("• Verifique se as imagens dos peixes estão no projeto")
                
            }
            .font(.caption)
            .foregroundColor(.white.opacity(0.7))
            .padding()
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
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
    
    
    private func startProcessing() {
        isProcessing = true
        errorMessage = nil
        processedResult = nil
        processingStep = "Preparando análise..."
        
        print("🚀 FishFilterView: Iniciando processamento de filtro...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.processingStep = "Detectando rosto na foto..."
        }
        
        FaceDetectionService.shared.detectFace(in: capturedImage) { result in
            switch result {
            case .success(let faceResult):
                print("✅ Rosto detectado, aplicando filtro...")
                
                DispatchQueue.main.async {
                    self.processingStep = "Verificando qualidade da detecção..."
                }
                
                guard FaceDetectionService.shared.isDetectionQualityGood(faceResult) else {
                    self.isProcessing = false
                    self.errorMessage = "Qualidade da detecção muito baixa. Tente uma foto com melhor iluminação e posicionamento frontal."
                    return
                }
                
                DispatchQueue.main.async {
                    self.processingStep = "Carregando imagem do \(self.quizResult.fish.name)..."
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.processingStep = "Extraindo seu rosto..."
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.processingStep = "Criando composição final..."
                }
                
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
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

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
    
    let mockImage = UIImage(systemName: "person.crop.circle.fill") ?? UIImage()
    
    FishFilterView(capturedImage: mockImage, quizResult: mockResult)
}
