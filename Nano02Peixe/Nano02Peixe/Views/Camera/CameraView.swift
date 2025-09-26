import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // Recebe o resultado do quiz para aplicar o filtro
    let quizResult: QuizResult
    
    var body: some View {
        ZStack {
            // Background preto para câmera
            Color.black.ignoresSafeArea()
            
            if cameraViewModel.isAuthorized {
                // Preview da câmera
                CameraPreviewView(previewLayer: cameraViewModel.previewLayer)
                    .ignoresSafeArea()
                
                // Overlay com controles
                VStack {
                    // Header com título e botão fechar
                    HStack {
                        Button("Voltar") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                        .padding()
                        
                        Spacer()
                        
                        VStack {
                            Text("Filtro de Peixe")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(quizResult.fish.name)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        // Espaço para balancear o layout
                        Color.clear
                            .frame(width: 60, height: 44)
                    }
                    .background(
                        LinearGradient(
                            colors: [.black.opacity(0.7), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    Spacer()
                    
                    // Área de captura na parte inferior
                    VStack(spacing: 20) {
                        // Instruções
                        VStack {
                            Text("Posicione seu rosto na câmera")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("O filtro de \(quizResult.fish.name) será aplicado")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        
                        // Botão de captura
                        Button {
                            cameraViewModel.capturePhoto()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 80, height: 80)
                                
                                if cameraViewModel.isCapturing {
                                    ProgressView()
                                        .tint(.black)
                                } else {
                                    Circle()
                                        .stroke(.black, lineWidth: 4)
                                        .frame(width: 70, height: 70)
                                }
                            }
                        }
                        .disabled(cameraViewModel.isCapturing)
                        .scaleEffect(cameraViewModel.isCapturing ? 0.9 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: cameraViewModel.isCapturing)
                    }
                    .padding(.bottom, 50)
                    .background(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                
            } else {
                // Estado sem permissão
                VStack(spacing: 30) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.6))
                    
                    VStack(spacing: 15) {
                        Text("Câmera Necessária")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(cameraViewModel.authorizationMessage)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Button("Configurações") {
                        // Abrir configurações do app
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(25)
                }
            }
        }
        .onAppear {
            print("📱 CameraView: Apareceu na tela")
            if cameraViewModel.isAuthorized {
                cameraViewModel.startSession()
            }
        }
        .onDisappear {
            print("📱 CameraView: Saiu da tela")
            cameraViewModel.stopSession()
        }
        // Navegar para resultado quando foto for capturada
        .fullScreenCover(item: Binding<IdentifiableImage?>(
            get: { 
                if let image = cameraViewModel.capturedImage {
                    return IdentifiableImage(image: image)
                }
                return nil
            },
            set: { _ in 
                cameraViewModel.capturedImage = nil
            }
        )) { identifiableImage in
            // Aqui vamos implementar a view de aplicação do filtro
            FishFilterView(
                capturedImage: identifiableImage.image,
                quizResult: quizResult
            )
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Camera Preview (UIKit bridge)
struct CameraPreviewView: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        // Configurar layer
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Atualizar bounds quando view mudar de tamanho
        DispatchQueue.main.async {
            self.previewLayer.frame = uiView.bounds
        }
    }
}

// MARK: - Helper para binding da imagem
struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

// MARK: - Preview
#Preview {
    // Preview com resultado mockado
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
    
    CameraView(quizResult: mockResult)
}
