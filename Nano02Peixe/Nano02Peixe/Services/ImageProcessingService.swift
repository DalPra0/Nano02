import Foundation
import UIKit
import CoreGraphics

class ImageProcessingService {
    
    struct ProcessedImageResult {
        let originalImage: UIImage
        let fishImage: UIImage
        let processedImage: UIImage
        let fishName: String
        let processingTime: TimeInterval
    }
    
    static let shared = ImageProcessingService()
    private init() {}
    
    func applyFishFilter(
        to image: UIImage,
        using faceResult: FaceDetectionService.FaceDetectionResult,
        for fish: Fish,
        completion: @escaping (Result<ProcessedImageResult, Error>) -> Void
    ) {
        
        let startTime = Date()
        print("🎨 ImageProcessingService: Criando composição \(fish.name) + rosto...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                guard let fishImage = self.loadFishImage(for: fish) else {
                    throw ImageProcessingError.fishImageNotFound(fish.name)
                }
                
                let extractedFace = try self.extractFace(from: image, using: faceResult)
                
                let composedImage = try self.composeFaceWithFish(
                    face: extractedFace,
                    fishImage: fishImage,
                    fish: fish
                )
                
                let processingTime = Date().timeIntervalSince(startTime)
                print("✅ Composição criada em \(String(format: "%.2f", processingTime))s")
                
                let result = ProcessedImageResult(
                    originalImage: image,
                    fishImage: fishImage,
                    processedImage: composedImage,
                    fishName: fish.name,
                    processingTime: processingTime
                )
                
                DispatchQueue.main.async {
                    completion(.success(result))
                }
                
            } catch {
                print("❌ Erro ao processar composição: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func loadFishImage(for fish: Fish) -> UIImage? {
        let imageName = fishNameToImageName(fish.name)
        
        print("🖼️ Carregando imagem: \(imageName)")
        
        if let image = UIImage(named: imageName) {
            print("✅ Imagem carregada: \(imageName)")
            return image
        }
        
        let fallbackName = imageName
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "ç", with: "c")
            .replacingOccurrences(of: "ã", with: "a")
            .replacingOccurrences(of: "õ", with: "o")
        
        if let image = UIImage(named: fallbackName) {
            print("✅ Imagem carregada (fallback): \(fallbackName)")
            return image
        }
        
        print("❌ Imagem não encontrada: \(imageName) ou \(fallbackName)")
        return nil
    }
    
    private func fishNameToImageName(_ fishName: String) -> String {
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
    
    private func extractFace(
        from image: UIImage,
        using faceResult: FaceDetectionService.FaceDetectionResult
    ) throws -> UIImage {
        
        print("✂️ Extraindo rosto da foto...")
        
        guard let cgImage = image.cgImage else {
            throw ImageProcessingError.invalidImage
        }
        
        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        
        let boundingBox = CGRect(
            x: faceResult.boundingBox.minX * imageSize.width,
            y: (1 - faceResult.boundingBox.maxY) * imageSize.height,
            width: faceResult.boundingBox.width * imageSize.width,
            height: faceResult.boundingBox.height * imageSize.height
        )
        
        let expandedBox = boundingBox.insetBy(dx: -boundingBox.width * 0.2, dy: -boundingBox.height * 0.2)
        
        let clampedBox = CGRect(
            x: max(0, expandedBox.minX),
            y: max(0, expandedBox.minY),
            width: min(imageSize.width - max(0, expandedBox.minX), expandedBox.width),
            height: min(imageSize.height - max(0, expandedBox.minY), expandedBox.height)
        )
        
        print("📐 Bounding box: \(boundingBox)")
        print("📐 Expanded box: \(expandedBox)")
        print("📐 Clamped box: \(clampedBox)")
        
        guard let croppedCGImage = cgImage.cropping(to: clampedBox) else {
            throw ImageProcessingError.faceExtractionFailed
        }
        
        let faceImage = UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        print("✅ Rosto extraído: \(faceImage.size)")
        return faceImage
    }
    
    private func composeFaceWithFish(
        face: UIImage,
        fishImage: UIImage,
        fish: Fish
    ) throws -> UIImage {
        
        print("🎭 Compondo rosto + \(fish.name)...")
        
        let canvasSize = fishImage.size
        print("🖼️ Canvas size: \(canvasSize)")
        
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            throw ImageProcessingError.contextCreationFailed
        }
        
        fishImage.draw(at: .zero)
        
        let headPosition = calculateFishHeadPosition(for: fish, canvasSize: canvasSize)
        let headSize = calculateFishHeadSize(for: fish, canvasSize: canvasSize)
        
        print("👤 Head position: \(headPosition)")
        print("📏 Head size: \(headSize)")
        
        let faceRect = CGRect(origin: headPosition, size: headSize)
        
        if shouldApplyCircularMask(for: fish) {
            context.saveGState()
            
            let maskPath = UIBezierPath(ovalIn: faceRect)
            context.addPath(maskPath.cgPath)
            context.clip()
            
            face.draw(in: faceRect)
            
            context.restoreGState()
        } else {
            face.draw(in: faceRect)
        }
        
        try applyFishSpecificAdjustments(context: context, fish: fish, faceRect: faceRect, canvasSize: canvasSize)
        
        guard let composedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            throw ImageProcessingError.imageCreationFailed
        }
        
        print("✅ Composição finalizada: \(composedImage.size)")
        return composedImage
    }
    
    
    private func calculateFishHeadPosition(for fish: Fish, canvasSize: CGSize) -> CGPoint {
        
        let (xPercent, yPercent) = fishHeadPositionPercent(for: fish)
        
        return CGPoint(
            x: canvasSize.width * xPercent,
            y: canvasSize.height * yPercent
        )
    }
    
    private func calculateFishHeadSize(for fish: Fish, canvasSize: CGSize) -> CGSize {
        
        let (widthPercent, heightPercent) = fishHeadSizePercent(for: fish)
        
        return CGSize(
            width: canvasSize.width * widthPercent,
            height: canvasSize.height * heightPercent
        )
    }
    
    private func fishHeadPositionPercent(for fish: Fish) -> (x: Double, y: Double) {
        
        switch fish.name {
        case "Peixe palhaço":
            return (0.2, 0.15)
        case "Piranha":
            return (0.25, 0.2)
        case "Peixe lua":
            return (0.3, 0.1)
        case "Pirarucu":
            return (0.15, 0.25)
        case "Peixe bolha":
            return (0.3, 0.3)
        default:
            return (0.25, 0.2)
        }
    }
    
    private func fishHeadSizePercent(for fish: Fish) -> (width: Double, height: Double) {
        
        switch fish.name {
        case "Peixe lua":
            return (0.4, 0.4)
        case "Peixe bolha":
            return (0.45, 0.4)
        case "Piranha":
            return (0.3, 0.25)
        case "Pirarucu":
            return (0.35, 0.3)
        case "Peixe palhaço":
            return (0.25, 0.2)
        default:
            return (0.3, 0.25)
        }
    }
    
    private func shouldApplyCircularMask(for fish: Fish) -> Bool {
        switch fish.name {
        case "Peixe lua", "Peixe bolha":
            return true
        default:
            return false
        }
    }
    
    
    private func applyFishSpecificAdjustments(
        context: CGContext,
        fish: Fish,
        faceRect: CGRect,
        canvasSize: CGSize
    ) throws {
        
        print("🎨 Aplicando ajustes para \(fish.name)...")
        
        switch fish.name {
        case "Peixe palhaço":
            drawClownfishStripes(context: context, faceRect: faceRect)
            
        case "Piranha":
            drawPiranhaTeeth(context: context, faceRect: faceRect)
            
        case "Peixe bolha":
            drawBlobEffect(context: context, faceRect: faceRect)
            
        case "Peixe lua":
            drawSunfishGlow(context: context, faceRect: faceRect)
            
        default:
            break
        }
    }
    
    
    private func drawClownfishStripes(context: CGContext, faceRect: CGRect) {
        context.setFillColor(UIColor.orange.withAlphaComponent(0.3).cgColor)
        
        let stripeHeight: CGFloat = 3
        for i in 0..<3 {
            let y = faceRect.minY + CGFloat(i) * faceRect.height / 3
            let rect = CGRect(x: faceRect.minX, y: y, width: faceRect.width, height: stripeHeight)
            context.fill(rect)
        }
    }
    
    private func drawPiranhaTeeth(context: CGContext, faceRect: CGRect) {
        context.setFillColor(UIColor.white.withAlphaComponent(0.8).cgColor)
        
        let teethCount = 4
        let toothWidth = faceRect.width / CGFloat(teethCount * 2)
        
        for i in 0..<teethCount {
            let x = faceRect.minX + CGFloat(i) * toothWidth * 2
            let y = faceRect.maxY - 10
            
            let triangle = UIBezierPath()
            triangle.move(to: CGPoint(x: x, y: y))
            triangle.addLine(to: CGPoint(x: x + toothWidth/2, y: y - 5))
            triangle.addLine(to: CGPoint(x: x + toothWidth, y: y))
            triangle.close()
            
            context.addPath(triangle.cgPath)
            context.fillPath()
        }
    }
    
    private func drawBlobEffect(context: CGContext, faceRect: CGRect) {
        context.setFillColor(UIColor.blue.withAlphaComponent(0.1).cgColor)
        context.fillEllipse(in: faceRect)
    }
    
    private func drawSunfishGlow(context: CGContext, faceRect: CGRect) {
        context.setFillColor(UIColor.white.withAlphaComponent(0.2).cgColor)
        context.fillEllipse(in: faceRect.insetBy(dx: -5, dy: -5))
    }
}

enum ImageProcessingError: LocalizedError {
    case invalidImage
    case contextCreationFailed
    case imageCreationFailed
    case fishImageNotFound(String)
    case faceExtractionFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Imagem inválida para processamento"
        case .contextCreationFailed:
            return "Erro interno: não foi possível criar contexto de desenho"
        case .imageCreationFailed:
            return "Erro ao gerar imagem processada"
        case .fishImageNotFound(let fishName):
            return "Imagem do peixe '\(fishName)' não encontrada. Adicione a imagem na pasta Resources/Images/Fish/"
        case .faceExtractionFailed:
            return "Não foi possível extrair o rosto da foto"
        }
    }
}
