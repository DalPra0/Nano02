import Foundation
import Combine
import AVFoundation
import UIKit

class CameraViewModel: NSObject, ObservableObject {
    // MARK: - Published Properties (Estado reativo)
    @Published var isAuthorized = false
    @Published var authorizationMessage = ""
    @Published var capturedImage: UIImage?
    @Published var isCapturing = false
    
    // MARK: - Camera Properties
    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    
    override init() {
        super.init()
        print("🎥 CameraViewModel: Inicializando...")
        checkAuthorization()
    }
    
    // MARK: - Authorization
    func checkAuthorization() {
        print("🔐 CameraViewModel: Verificando permissões de câmera...")
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("✅ Câmera: Permissão já concedida")
            isAuthorized = true
            authorizationMessage = "Câmera autorizada"
            
        case .notDetermined:
            print("❓ Câmera: Permissão não determinada, solicitando...")
            authorizationMessage = "Solicitando permissão..."
            requestPermission()
            
        case .denied, .restricted:
            print("❌ Câmera: Permissão negada")
            isAuthorized = false
            authorizationMessage = "Permissão de câmera negada. Vá em Configurações > Privacidade > Câmera para permitir."
            
        @unknown default:
            print("⚠️ Câmera: Status desconhecido")
            isAuthorized = false
            authorizationMessage = "Status de câmera desconhecido"
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    print("✅ Câmera: Permissão concedida pelo usuário")
                    self?.isAuthorized = true
                    self?.authorizationMessage = "Câmera autorizada"
                } else {
                    print("❌ Câmera: Permissão negada pelo usuário")
                    self?.isAuthorized = false
                    self?.authorizationMessage = "Permissão de câmera necessária para usar filtros"
                }
            }
        }
    }
    
    // MARK: - Session Management
    func startSession() {
        guard isAuthorized else {
            print("❌ CameraViewModel: Tentando iniciar sessão sem permissão")
            return
        }
        
        print("🎥 CameraViewModel: Configurando sessão da câmera...")
        
        // Configurar em background thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.configureSession()
        }
    }
    
    private func configureSession() {
        print("⚙️ CameraViewModel: Configurando capture session...")
        
        session.beginConfiguration()
        
        // Configurar qualidade
        if session.canSetSessionPreset(.photo) {
            session.sessionPreset = .photo
            print("📷 Session preset: .photo")
        }
        
        // Adicionar input da câmera
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("❌ Erro: Não foi possível acessar câmera frontal")
            session.commitConfiguration()
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
            print("✅ Input da câmera frontal adicionado")
        }
        
        // Adicionar output para fotos
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            print("✅ Photo output adicionado")
        }
        
        session.commitConfiguration()
        
        // Iniciar sessão
        DispatchQueue.main.async {
            self.session.startRunning()
            print("🎬 Sessão da câmera iniciada!")
        }
    }
    
    func stopSession() {
        print("🛑 CameraViewModel: Parando sessão da câmera...")
        session.stopRunning()
    }
    
    // MARK: - Photo Capture
    func capturePhoto() {
        guard !isCapturing else {
            print("⚠️ Já capturando foto, ignorando...")
            return
        }
        
        print("📸 CameraViewModel: Capturando foto...")
        isCapturing = true
        
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: - Public Properties
    var previewLayer: AVCaptureVideoPreviewLayer {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        return layer
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        isCapturing = false
        
        if let error = error {
            print("❌ Erro ao capturar foto: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("❌ Erro: Não foi possível converter foto em UIImage")
            return
        }
        
        print("✅ Foto capturada com sucesso!")
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}
