import Foundation
import Vision
import UIKit
import CoreGraphics

class FaceDetectionService {
    
    // MARK: - Resultado da detecção
    struct FaceDetectionResult {
        let boundingBox: CGRect           // Retângulo do rosto
        let landmarks: VNFaceLandmarks2D  // Pontos específicos (olhos, boca, etc.)
        let confidence: Float             // Confiança da detecção (0-1)
        
        // Pontos específicos extraídos
        let leftEye: [CGPoint]
        let rightEye: [CGPoint] 
        let nose: [CGPoint]
        let outerLips: [CGPoint]
        let faceContour: [CGPoint]
    }
    
    // MARK: - Singleton
    static let shared = FaceDetectionService()
    private init() {}
    
    // MARK: - Detecção Principal
    func detectFace(in image: UIImage, completion: @escaping (Result<FaceDetectionResult, Error>) -> Void) {
        
        print("👁️ FaceDetectionService: Iniciando detecção facial...")
        
        // Converter UIImage para formato que Vision entende
        guard let cgImage = image.cgImage else {
            print("❌ Erro: Não foi possível converter UIImage para CGImage")
            completion(.failure(FaceDetectionError.imageConversionFailed))
            return
        }
        
        // Criar request de detecção de landmarks faciais
        let request = VNDetectFaceLandmarksRequest { request, error in
            self.handleFaceDetectionResult(request: request, error: error, completion: completion)
        }
        
        // Configurar request para máxima precisão
        request.revision = VNDetectFaceLandmarksRequestRevision3
        
        // Executar análise em background
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform([request])
                print("✅ Request de detecção facial executado")
            } catch {
                print("❌ Erro ao executar request: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Processar Resultado da Detecção
    private func handleFaceDetectionResult(
        request: VNRequest,
        error: Error?,
        completion: @escaping (Result<FaceDetectionResult, Error>) -> Void
    ) {
        // Verificar se houve erro
        if let error = error {
            print("❌ Erro na detecção facial: \(error)")
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        // Verificar se encontrou resultados
        guard let results = request.results as? [VNFaceObservation] else {
            print("❌ Nenhum resultado de detecção facial")
            DispatchQueue.main.async {
                completion(.failure(FaceDetectionError.noFaceDetected))
            }
            return
        }
        
        // Pegar o primeiro rosto (mais confiável)
        guard let faceObservation = results.first else {
            print("❌ Nenhum rosto detectado")
            DispatchQueue.main.async {
                completion(.failure(FaceDetectionError.noFaceDetected))
            }
            return
        }
        
        print("✅ Rosto detectado com confiança: \(faceObservation.confidence)")
        
        // Verificar se temos landmarks
        guard let landmarks = faceObservation.landmarks else {
            print("❌ Landmarks não disponíveis")
            DispatchQueue.main.async {
                completion(.failure(FaceDetectionError.landmarksNotAvailable))
            }
            return
        }
        
        // Extrair pontos específicos
        let result = self.extractLandmarkPoints(
            from: landmarks,
            boundingBox: faceObservation.boundingBox,
            confidence: faceObservation.confidence
        )
        
        print("🎯 Landmarks extraídos:")
        print("   • Olho esquerdo: \(result.leftEye.count) pontos")
        print("   • Olho direito: \(result.rightEye.count) pontos")
        print("   • Nariz: \(result.nose.count) pontos")
        print("   • Lábios: \(result.outerLips.count) pontos")
        print("   • Contorno: \(result.faceContour.count) pontos")
        
        DispatchQueue.main.async {
            completion(.success(result))
        }
    }
    
    // MARK: - Extrair Pontos Específicos
    private func extractLandmarkPoints(
        from landmarks: VNFaceLandmarks2D,
        boundingBox: CGRect,
        confidence: Float
    ) -> FaceDetectionResult {
        
        // Função helper para converter pontos normalizados
        func normalizedToPoints(_ region: VNFaceLandmarkRegion2D?) -> [CGPoint] {
            guard let region = region else { return [] }
            
            return region.normalizedPoints.map { point in
                CGPoint(
                    x: point.x * boundingBox.width + boundingBox.minX,
                    y: point.y * boundingBox.height + boundingBox.minY
                )
            }
        }
        
        // Extrair cada região de interesse
        let leftEye = normalizedToPoints(landmarks.leftEye)
        let rightEye = normalizedToPoints(landmarks.rightEye)
        let nose = normalizedToPoints(landmarks.nose)
        let outerLips = normalizedToPoints(landmarks.outerLips)
        let faceContour = normalizedToPoints(landmarks.faceContour)
        
        return FaceDetectionResult(
            boundingBox: boundingBox,
            landmarks: landmarks,
            confidence: confidence,
            leftEye: leftEye,
            rightEye: rightEye,
            nose: nose,
            outerLips: outerLips,
            faceContour: faceContour
        )
    }
    
    // MARK: - Utilidades para UI
    
    /// Converte coordenadas normalizadas do Vision para coordenadas de UIImage
    func convertVisionToImageCoordinates(
        _ point: CGPoint,
        imageSize: CGSize
    ) -> CGPoint {
        return CGPoint(
            x: point.x * imageSize.width,
            y: (1 - point.y) * imageSize.height  // Vision usa origem bottom-left
        )
    }
    
    /// Verifica se a detecção tem qualidade suficiente para aplicar filtro
    func isDetectionQualityGood(_ result: FaceDetectionResult) -> Bool {
        // Critérios de qualidade:
        let hasGoodConfidence = result.confidence > 0.7
        let hasEssentialLandmarks = !result.leftEye.isEmpty && 
                                   !result.rightEye.isEmpty && 
                                   !result.nose.isEmpty
        
        print("🎯 Qualidade da detecção:")
        print("   • Confiança: \(result.confidence) (>\(0.7) = \(hasGoodConfidence))")
        print("   • Landmarks essenciais: \(hasEssentialLandmarks)")
        
        return hasGoodConfidence && hasEssentialLandmarks
    }
}

// MARK: - Erros Customizados
enum FaceDetectionError: LocalizedError {
    case imageConversionFailed
    case noFaceDetected
    case landmarksNotAvailable
    case lowQualityDetection
    
    var errorDescription: String? {
        switch self {
        case .imageConversionFailed:
            return "Não foi possível processar a imagem"
        case .noFaceDetected:
            return "Nenhum rosto foi detectado na foto"
        case .landmarksNotAvailable:
            return "Não foi possível detectar características faciais"
        case .lowQualityDetection:
            return "Qualidade da detecção muito baixa. Tente uma foto com melhor iluminação"
        }
    }
}
