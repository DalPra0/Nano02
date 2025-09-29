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
    
    struct FishMapping {
        let headPosition: CGPoint // Percentual (0.0 - 1.0)
        let headSize: CGSize // Percentual (0.0 - 1.0)
        let isCircular: Bool
        let rotation: CGFloat // Em graus
        let opacity: CGFloat
    }
    
    static let shared = ImageProcessingService()
    private init() {}
    
    // MARK: - Configuração Específica para Cada Peixe
    private func getFishMapping(for fishName: String) -> FishMapping {
        switch fishName {
        case "Peixe-mão liso":
            return FishMapping(
                headPosition: CGPoint(x: 0.25, y: 0.2),
                headSize: CGSize(width: 0.25, height: 0.22),
                isCircular: false,
                rotation: 0,
                opacity: 0.95
            )
        case "Peixe-espátula-chinês":
            return FishMapping(
                headPosition: CGPoint(x: 0.18, y: 0.25),
                headSize: CGSize(width: 0.2, height: 0.18),
                isCircular: false,
                rotation: -5,
                opacity: 0.92
            )
        case "Peixe jacaré":
            return FishMapping(
                headPosition: CGPoint(x: 0.15, y: 0.28),
                headSize: CGSize(width: 0.18, height: 0.15),
                isCircular: false,
                rotation: 0,
                opacity: 0.9
            )
        case "Peixe dragão":
            return FishMapping(
                headPosition: CGPoint(x: 0.22, y: 0.18),
                headSize: CGSize(width: 0.24, height: 0.22),
                isCircular: false,
                rotation: 0,
                opacity: 0.88
            )
        case "Esturjão":
            return FishMapping(
                headPosition: CGPoint(x: 0.2, y: 0.3),
                headSize: CGSize(width: 0.22, height: 0.18),
                isCircular: false,
                rotation: 0,
                opacity: 0.9
            )
        case "Peixe palhaço":
            return FishMapping(
                headPosition: CGPoint(x: 0.28, y: 0.22),
                headSize: CGSize(width: 0.26, height: 0.24),
                isCircular: true,
                rotation: 0,
                opacity: 0.92
            )
        case "Peixe lua":
            return FishMapping(
                headPosition: CGPoint(x: 0.35, y: 0.3),
                headSize: CGSize(width: 0.35, height: 0.35),
                isCircular: true,
                rotation: 0,
                opacity: 0.85
            )
        case "Piranha":
            return FishMapping(
                headPosition: CGPoint(x: 0.25, y: 0.25),
                headSize: CGSize(width: 0.22, height: 0.2),
                isCircular: false,
                rotation: 0,
                opacity: 0.93
            )
        case "Peixe pedra":
            return FishMapping(
                headPosition: CGPoint(x: 0.3, y: 0.2),
                headSize: CGSize(width: 0.28, height: 0.24),
                isCircular: false,
                rotation: 0,
                opacity: 0.88
            )
        case "Peixe-víbora de Sloane":
            return FishMapping(
                headPosition: CGPoint(x: 0.18, y: 0.15),
                headSize: CGSize(width: 0.2, height: 0.18),
                isCircular: false,
                rotation: -8,
                opacity: 0.9
            )
        case "Peixe-pescador":
            return FishMapping(
                headPosition: CGPoint(x: 0.32, y: 0.28),
                headSize: CGSize(width: 0.3, height: 0.28),
                isCircular: true,
                rotation: 0,
                opacity: 0.87
            )
        case "Pirarucu":
            return FishMapping(
                headPosition: CGPoint(x: 0.15, y: 0.25),
                headSize: CGSize(width: 0.2, height: 0.16),
                isCircular: false,
                rotation: 0,
                opacity: 0.91
            )
        case "Peixe bolha":
            return FishMapping(
                headPosition: CGPoint(x: 0.35, y: 0.32),
                headSize: CGSize(width: 0.38, height: 0.35),
                isCircular: true,
                rotation: 0,
                opacity: 0.82
            )
        case "Pacu":
            return FishMapping(
                headPosition: CGPoint(x: 0.26, y: 0.24),
                headSize: CGSize(width: 0.24, height: 0.22),
                isCircular: false,
                rotation: 0,
                opacity: 0.92
            )
        case "Bagre":
            return FishMapping(
                headPosition: CGPoint(x: 0.22, y: 0.28),
                headSize: CGSize(width: 0.2, height: 0.16),
                isCircular: false,
                rotation: 0,
                opacity: 0.9
            )
        case "Tilápia":
            return FishMapping(
                headPosition: CGPoint(x: 0.27, y: 0.26),
                headSize: CGSize(width: 0.25, height: 0.22),
                isCircular: false,
                rotation: 0,
                opacity: 0.93
            )
        default:
            return FishMapping(
                headPosition: CGPoint(x: 0.25, y: 0.25),
                headSize: CGSize(width: 0.25, height: 0.25),
                isCircular: false,
                rotation: 0,
                opacity: 0.9
            )
        }
    }
    
    // MARK: - Função Principal
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
                
                let extractedFace = try self.extractAndPrepareFace(
                    from: image,
                    using: faceResult,
                    for: fish
                )
                
                let composedImage = try self.createAdvancedComposition(
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
    
    // MARK: - Extração e Preparação do Rosto
    private func extractAndPrepareFace(
        from image: UIImage,
        using faceResult: FaceDetectionService.FaceDetectionResult,
        for fish: Fish
    ) throws -> UIImage {
        
        print("✂️ Extraindo e preparando rosto...")
        
        guard let cgImage = image.cgImage else {
            throw ImageProcessingError.invalidImage
        }
        
        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        
        // Converter coordenadas do Vision para coordenadas da imagem
        let boundingBox = CGRect(
            x: faceResult.boundingBox.minX * imageSize.width,
            y: (1 - faceResult.boundingBox.maxY) * imageSize.height,
            width: faceResult.boundingBox.width * imageSize.width,
            height: faceResult.boundingBox.height * imageSize.height
        )
        
        // Expandir a área para incluir mais contexto (cabelo, etc)
        let expansionFactor = getFishMapping(for: fish.name).isCircular ? 0.3 : 0.2
        let expandedBox = boundingBox.insetBy(
            dx: -boundingBox.width * expansionFactor,
            dy: -boundingBox.height * expansionFactor
        )
        
        // Garantir que não ultrapassa os limites da imagem
        let clampedBox = CGRect(
            x: max(0, expandedBox.minX),
            y: max(0, expandedBox.minY),
            width: min(imageSize.width - max(0, expandedBox.minX), expandedBox.width),
            height: min(imageSize.height - max(0, expandedBox.minY), expandedBox.height)
        )
        
        guard let croppedCGImage = cgImage.cropping(to: clampedBox) else {
            throw ImageProcessingError.faceExtractionFailed
        }
        
        var faceImage = UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        // Aplicar melhorias na imagem do rosto
        faceImage = enhanceFaceImage(faceImage)
        
        print("✅ Rosto extraído e preparado: \(faceImage.size)")
        return faceImage
    }
    
    // MARK: - Melhoramento da Imagem do Rosto
    private func enhanceFaceImage(_ image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        
        let context = CIContext()
        var ciImage = CIImage(cgImage: cgImage)
        
        // Ajustar brilho e contraste levemente
        if let filter = CIFilter(name: "CIColorControls") {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            filter.setValue(0.05, forKey: kCIInputBrightnessKey)
            filter.setValue(1.1, forKey: kCIInputContrastKey)
            filter.setValue(1.0, forKey: kCIInputSaturationKey)
            
            if let output = filter.outputImage {
                ciImage = output
            }
        }
        
        // Converter de volta para UIImage
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        }
        
        return image
    }
    
    // MARK: - Composição Avançada
    private func createAdvancedComposition(
        face: UIImage,
        fishImage: UIImage,
        fish: Fish
    ) throws -> UIImage {
        
        print("🎭 Criando composição avançada para \(fish.name)...")
        
        let mapping = getFishMapping(for: fish.name)
        let canvasSize = fishImage.size
        
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            throw ImageProcessingError.contextCreationFailed
        }
        
        // Desenhar o peixe base
        fishImage.draw(at: .zero)
        
        // Calcular posição e tamanho do rosto
        let faceRect = CGRect(
            x: canvasSize.width * mapping.headPosition.x,
            y: canvasSize.height * mapping.headPosition.y,
            width: canvasSize.width * mapping.headSize.width,
            height: canvasSize.height * mapping.headSize.height
        )
        
        // Aplicar transformações
        context.saveGState()
        
        // Aplicar rotação se necessário
        if mapping.rotation != 0 {
            let centerX = faceRect.midX
            let centerY = faceRect.midY
            context.translateBy(x: centerX, y: centerY)
            context.rotate(by: mapping.rotation * .pi / 180)
            context.translateBy(x: -centerX, y: -centerY)
        }
        
        // Aplicar máscara circular se necessário
        if mapping.isCircular {
            let maskPath = UIBezierPath(ovalIn: faceRect)
            context.addPath(maskPath.cgPath)
            context.clip()
        }
        
        // Aplicar opacidade
        context.setAlpha(mapping.opacity)
        
        // Desenhar o rosto
        face.draw(in: faceRect)
        
        context.restoreGState()
        
        // Aplicar efeitos específicos do peixe
        try applyFishSpecificEffects(
            context: context,
            fish: fish,
            faceRect: faceRect,
            canvasSize: canvasSize
        )
        
        // Aplicar blend final para melhor integração
        applyFinalBlending(context: context, faceRect: faceRect, mapping: mapping)
        
        guard let composedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            throw ImageProcessingError.imageCreationFailed
        }
        
        print("✅ Composição avançada finalizada")
        return composedImage
    }
    
    // MARK: - Efeitos Específicos por Peixe
    private func applyFishSpecificEffects(
        context: CGContext,
        fish: Fish,
        faceRect: CGRect,
        canvasSize: CGSize
    ) throws {
        
        switch fish.name {
        case "Peixe palhaço":
            applyClownfishEffect(context: context, faceRect: faceRect)
        case "Piranha":
            applyPiranhaEffect(context: context, faceRect: faceRect)
        case "Peixe bolha":
            applyBlobEffect(context: context, faceRect: faceRect)
        case "Peixe lua":
            applySunfishEffect(context: context, faceRect: faceRect)
        case "Peixe dragão":
            applyDragonEffect(context: context, faceRect: faceRect)
        case "Peixe-víbora de Sloane":
            applyViperEffect(context: context, faceRect: faceRect)
        case "Peixe-pescador":
            applyAnglerEffect(context: context, faceRect: faceRect, canvasSize: canvasSize)
        default:
            break
        }
    }
    
    // Efeitos individuais
    private func applyClownfishEffect(context: CGContext, faceRect: CGRect) {
        // Adicionar listras sutis do peixe-palhaço
        context.setFillColor(UIColor.white.withAlphaComponent(0.15).cgColor)
        let stripeWidth = faceRect.width * 0.15
        
        for i in 0..<2 {
            let x = faceRect.minX - stripeWidth + CGFloat(i) * (faceRect.width + stripeWidth * 2) / 2
            let rect = CGRect(x: x, y: faceRect.minY, width: stripeWidth, height: faceRect.height)
            context.fill(rect)
        }
    }
    
    private func applyPiranhaEffect(context: CGContext, faceRect: CGRect) {
        // Adicionar dentes afiados
        context.setFillColor(UIColor.white.withAlphaComponent(0.9).cgColor)
        let teethCount = 5
        let toothWidth = faceRect.width / CGFloat(teethCount * 2)
        
        for i in 0..<teethCount {
            let x = faceRect.minX + CGFloat(i) * toothWidth * 2
            let y = faceRect.maxY - 5
            
            let triangle = UIBezierPath()
            triangle.move(to: CGPoint(x: x, y: y))
            triangle.addLine(to: CGPoint(x: x + toothWidth/2, y: y - 8))
            triangle.addLine(to: CGPoint(x: x + toothWidth, y: y))
            triangle.close()
            
            context.addPath(triangle.cgPath)
            context.fillPath()
        }
    }
    
    private func applyBlobEffect(context: CGContext, faceRect: CGRect) {
        // Adicionar efeito gelatinoso
        context.setFillColor(UIColor.systemPink.withAlphaComponent(0.08).cgColor)
        context.fillEllipse(in: faceRect.insetBy(dx: -10, dy: -10))
        
        context.setFillColor(UIColor.white.withAlphaComponent(0.12).cgColor)
        let highlightRect = CGRect(
            x: faceRect.minX + faceRect.width * 0.2,
            y: faceRect.minY + faceRect.height * 0.1,
            width: faceRect.width * 0.3,
            height: faceRect.height * 0.2
        )
        context.fillEllipse(in: highlightRect)
    }
    
    private func applySunfishEffect(context: CGContext, faceRect: CGRect) {
        // Adicionar brilho solar
        context.setFillColor(UIColor.yellow.withAlphaComponent(0.1).cgColor)
        context.fillEllipse(in: faceRect.insetBy(dx: -15, dy: -15))
        
        context.setFillColor(UIColor.white.withAlphaComponent(0.15).cgColor)
        context.fillEllipse(in: faceRect.insetBy(dx: -8, dy: -8))
    }
    
    private func applyDragonEffect(context: CGContext, faceRect: CGRect) {
        // Adicionar escamas místicas
        context.setFillColor(UIColor.purple.withAlphaComponent(0.1).cgColor)
        let scaleSize = CGSize(width: 15, height: 15)
        
        for row in 0..<3 {
            for col in 0..<4 {
                let x = faceRect.minX + CGFloat(col) * scaleSize.width * 1.5
                let y = faceRect.minY + CGFloat(row) * scaleSize.height * 1.5
                let rect = CGRect(origin: CGPoint(x: x, y: y), size: scaleSize)
                context.fillEllipse(in: rect)
            }
        }
    }
    
    private func applyViperEffect(context: CGContext, faceRect: CGRect) {
        // Adicionar presas venenosas
        context.setFillColor(UIColor.green.withAlphaComponent(0.3).cgColor)
        
        let fangSize = CGSize(width: 4, height: 12)
        let leftFang = CGRect(
            origin: CGPoint(
                x: faceRect.minX + faceRect.width * 0.3,
                y: faceRect.maxY - 10
            ),
            size: fangSize
        )
        let rightFang = CGRect(
            origin: CGPoint(
                x: faceRect.minX + faceRect.width * 0.7,
                y: faceRect.maxY - 10
            ),
            size: fangSize
        )
        
        context.fill(leftFang)
        context.fill(rightFang)
    }
    
    private func applyAnglerEffect(context: CGContext, faceRect: CGRect, canvasSize: CGSize) {
        // Adicionar isca luminosa
        context.setFillColor(UIColor.yellow.withAlphaComponent(0.8).cgColor)
        let lightRadius: CGFloat = 8
        let lightPosition = CGPoint(
            x: faceRect.midX,
            y: faceRect.minY - 20
        )
        
        context.fillEllipse(in: CGRect(
            x: lightPosition.x - lightRadius,
            y: lightPosition.y - lightRadius,
            width: lightRadius * 2,
            height: lightRadius * 2
        ))
        
        // Adicionar brilho ao redor
        context.setFillColor(UIColor.yellow.withAlphaComponent(0.2).cgColor)
        context.fillEllipse(in: CGRect(
            x: lightPosition.x - lightRadius * 2,
            y: lightPosition.y - lightRadius * 2,
            width: lightRadius * 4,
            height: lightRadius * 4
        ))
    }
    
    // MARK: - Blend Final
    private func applyFinalBlending(context: CGContext, faceRect: CGRect, mapping: FishMapping) {
        // Adicionar suavização nas bordas
        context.setFillColor(UIColor.clear.cgColor)
        context.setBlendMode(.destinationIn)
        
        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [
                UIColor.white.withAlphaComponent(1.0).cgColor,
                UIColor.white.withAlphaComponent(0.95).cgColor,
                UIColor.white.withAlphaComponent(0.8).cgColor
            ] as CFArray,
            locations: [0, 0.8, 1.0]
        )
        
        if let gradient = gradient {
            let center = CGPoint(x: faceRect.midX, y: faceRect.midY)
            let radius = min(faceRect.width, faceRect.height) / 2
            
            context.drawRadialGradient(
                gradient,
                startCenter: center,
                startRadius: radius * 0.7,
                endCenter: center,
                endRadius: radius,
                options: []
            )
        }
    }
    
    // MARK: - Helpers
    private func loadFishImage(for fish: Fish) -> UIImage? {
        let imageName = fishNameToImageName(fish.name)
        print("🖼️ Carregando imagem: \(imageName)")
        
        if let image = UIImage(named: imageName) {
            print("✅ Imagem carregada: \(imageName)")
            return image
        }
        
        print("❌ Imagem não encontrada: \(imageName)")
        return nil
    }
    
    private func fishNameToImageName(_ fishName: String) -> String {
        switch fishName {
        case "Peixe-mão liso": return "peixe-mao-liso"
        case "Peixe-espátula-chinês": return "peixe-espatula-chines"
        case "Peixe jacaré": return "peixe-jacare"
        case "Peixe dragão": return "peixe-dragao"
        case "Esturjão": return "esturjao"
        case "Peixe palhaço": return "peixe-palhaco"
        case "Peixe lua": return "peixe-lua"
        case "Piranha": return "piranha"
        case "Peixe pedra": return "peixe-pedra"
        case "Peixe-víbora de Sloane": return "peixe-vibora-sloane"
        case "Peixe-pescador": return "peixe-pescador"
        case "Pirarucu": return "pirarucu"
        case "Peixe bolha": return "peixe-bolha"
        case "Pacu": return "pacu"
        case "Bagre": return "bagre"
        case "Tilápia": return "tilapia"
        default: return fishName.lowercased().replacingOccurrences(of: " ", with: "-")
        }
    }
}

// MARK: - Errors
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
            return "Imagem do peixe '\(fishName)' não encontrada"
        case .faceExtractionFailed:
            return "Não foi possível extrair o rosto da foto"
        }
    }
}
