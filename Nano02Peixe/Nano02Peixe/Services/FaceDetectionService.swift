import Foundation
import Vision
import UIKit
import CoreGraphics

class FaceDetectionService {
    
    struct FaceDetectionResult {
        let boundingBox: CGRect
        let landmarks: VNFaceLandmarks2D
        let confidence: Float
        
        let leftEye: [CGPoint]
        let rightEye: [CGPoint] 
        let nose: [CGPoint]
        let outerLips: [CGPoint]
        let faceContour: [CGPoint]
    }
    
    static let shared = FaceDetectionService()
    private init() {}
    
    func detectFace(in image: UIImage, completion: @escaping (Result<FaceDetectionResult, Error>) -> Void) {
        
        print("👁️ FaceDetectionService: Iniciando detecção facial...")
        
        guard let cgImage = image.cgImage else {
            print("❌ Erro: Não foi possível converter UIImage para CGImage")
            completion(.failure(FaceDetectionError.imageConversionFailed))
            return
        }
        
        let request = VNDetectFaceLandmarksRequest { request, error in
            self.handleFaceDetectionResult(request: request, error: error, completion: completion)
        }
        
        request.revision = VNDetectFaceLandmarksRequestRevision3
        
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
    
    private func handleFaceDetectionResult(
        request: VNRequest,
        error: Error?,
        completion: @escaping (Result<FaceDetectionResult, Error>) -> Void
    ) {
        if let error = error {
            print("❌ Erro na detecção facial: \(error)")
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        guard let results = request.results as? [VNFaceObservation] else {
            print("❌ Nenhum resultado de detecção facial")
            DispatchQueue.main.async {
                completion(.failure(FaceDetectionError.noFaceDetected))
            }
            return
        }
        
        guard let faceObservation = results.first else {
            print("❌ Nenhum rosto detectado")
            DispatchQueue.main.async {
                completion(.failure(FaceDetectionError.noFaceDetected))
            }
            return
        }
        
        print("✅ Rosto detectado com confiança: \(faceObservation.confidence)")
        
        guard let landmarks = faceObservation.landmarks else {
            print("❌ Landmarks não disponíveis")
            DispatchQueue.main.async {
                completion(.failure(FaceDetectionError.landmarksNotAvailable))
            }
            return
        }
        
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
    
    private func extractLandmarkPoints(
        from landmarks: VNFaceLandmarks2D,
        boundingBox: CGRect,
        confidence: Float
    ) -> FaceDetectionResult {
        
        func normalizedToPoints(_ region: VNFaceLandmarkRegion2D?) -> [CGPoint] {
            guard let region = region else { return [] }
            
            return region.normalizedPoints.map { point in
                CGPoint(
                    x: point.x * boundingBox.width + boundingBox.minX,
                    y: point.y * boundingBox.height + boundingBox.minY
                )
            }
        }
        
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
    
    
    func convertVisionToImageCoordinates(
        _ point: CGPoint,
        imageSize: CGSize
    ) -> CGPoint {
        return CGPoint(
            x: point.x * imageSize.width,
            y: (1 - point.y) * imageSize.height
        )
    }
    
    func isDetectionQualityGood(_ result: FaceDetectionResult) -> Bool {
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
