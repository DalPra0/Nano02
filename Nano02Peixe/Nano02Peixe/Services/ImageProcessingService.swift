import Foundation
import UIKit
import CoreGraphics

class ImageProcessingService {
    
    // MARK: - Resultado do processamento
    struct ProcessedImageResult {
        let originalImage: UIImage      // Foto original da câmera
        let fishImage: UIImage          // Imagem do peixe usada
        let processedImage: UIImage     // Resultado final (rosto + peixe)
        let fishName: String
        let processingTime: TimeInterval
    }
    
    // MARK: - Singleton
    static let shared = ImageProcessingService()
    private init() {}
    
    // MARK: - Aplicar Filtro Principal
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
                // 1. Carregar imagem do peixe
                guard let fishImage = self.loadFishImage(for: fish) else {
                    throw ImageProcessingError.fishImageNotFound(fish.name)
                }
                
                // 2. Extrair rosto da foto
                let extractedFace = try self.extractFace(from: image, using: faceResult)
                
                // 3. Compor rosto + peixe
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
    
    // MARK: - 1. Carregar Imagem do Peixe
    private func loadFishImage(for fish: Fish) -> UIImage? {
        // Mapear nome do peixe para nome do arquivo CORRETO
        let imageName = fishNameToImageName(fish.name)
        
        print("🖼️ Carregando imagem: \(imageName)")
        
        // Tentar carregar do bundle
        if let image = UIImage(named: imageName) {
            print("✅ Imagem carregada: \(imageName)")
            return image
        }
        
        // Fallback: tentar sem caracteres especiais
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
        // Converter nome do peixe para nome do arquivo CORRETO
        // ESSES SÃO OS NOMES QUE VOCÊ VAI ADICIONAR
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
    
    // MARK: - 2. Extrair Rosto da Foto
    private func extractFace(
        from image: UIImage,
        using faceResult: FaceDetectionService.FaceDetectionResult
    ) throws -> UIImage {
        
        print("✂️ Extraindo rosto da foto...")
        
        guard let cgImage = image.cgImage else {
            throw ImageProcessingError.invalidImage
        }
        
        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        
        // Converter coordenadas normalizadas para pixels
        let boundingBox = CGRect(
            x: faceResult.boundingBox.minX * imageSize.width,
            y: (1 - faceResult.boundingBox.maxY) * imageSize.height,  // Inverter Y
            width: faceResult.boundingBox.width * imageSize.width,
            height: faceResult.boundingBox.height * imageSize.height
        )
        
        // Expandir um pouco a área para incluir mais contexto
        let expandedBox = boundingBox.insetBy(dx: -boundingBox.width * 0.2, dy: -boundingBox.height * 0.2)
        
        // Garantir que não saia dos limites da imagem
        let clampedBox = CGRect(
            x: max(0, expandedBox.minX),
            y: max(0, expandedBox.minY),
            width: min(imageSize.width - max(0, expandedBox.minX), expandedBox.width),
            height: min(imageSize.height - max(0, expandedBox.minY), expandedBox.height)
        )
        
        print("📐 Bounding box: \(boundingBox)")
        print("📐 Expanded box: \(expandedBox)")
        print("📐 Clamped box: \(clampedBox)")
        
        // Recortar rosto
        guard let croppedCGImage = cgImage.cropping(to: clampedBox) else {
            throw ImageProcessingError.faceExtractionFailed
        }
        
        let faceImage = UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        print("✅ Rosto extraído: \(faceImage.size)")
        return faceImage
    }
    
    // MARK: - 3. Compor Rosto + Peixe
    private func composeFaceWithFish(
        face: UIImage,
        fishImage: UIImage,
        fish: Fish
    ) throws -> UIImage {
        
        print("🎭 Compondo rosto + \(fish.name)...")
        
        // Usar o tamanho da imagem do peixe como base
        let canvasSize = fishImage.size
        print("🖼️ Canvas size: \(canvasSize)")
        
        // Criar contexto de desenho
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            throw ImageProcessingError.contextCreationFailed
        }
        
        // 1. Desenhar peixe como fundo
        fishImage.draw(at: .zero)
        
        // 2. Calcular posição e tamanho da cabeça do peixe
        let headPosition = calculateFishHeadPosition(for: fish, canvasSize: canvasSize)
        let headSize = calculateFishHeadSize(for: fish, canvasSize: canvasSize)
        
        print("👤 Head position: \(headPosition)")
        print("📏 Head size: \(headSize)")
        
        // 3. Redimensionar e desenhar o rosto
        let faceRect = CGRect(origin: headPosition, size: headSize)
        
        // Aplicar máscara circular para o rosto (opcional)
        if shouldApplyCircularMask(for: fish) {
            context.saveGState()
            
            // Criar máscara circular
            let maskPath = UIBezierPath(ovalIn: faceRect)
            context.addPath(maskPath.cgPath)
            context.clip()
            
            face.draw(in: faceRect)
            
            context.restoreGState()
        } else {
            // Desenhar rosto diretamente
            face.draw(in: faceRect)
        }
        
        // 4. Aplicar ajustes finais específicos do peixe
        try applyFishSpecificAdjustments(context: context, fish: fish, faceRect: faceRect, canvasSize: canvasSize)
        
        // 5. Capturar resultado
        guard let composedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            throw ImageProcessingError.imageCreationFailed
        }
        
        print("✅ Composição finalizada: \(composedImage.size)")
        return composedImage
    }
    
    // MARK: - Cálculos de Posicionamento
    
    private func calculateFishHeadPosition(for fish: Fish, canvasSize: CGSize) -> CGPoint {
        // Posição da cabeça baseada no tipo de peixe
        // Valores são percentuais da imagem (0.0 a 1.0)
        
        let (xPercent, yPercent) = fishHeadPositionPercent(for: fish)
        
        return CGPoint(
            x: canvasSize.width * xPercent,
            y: canvasSize.height * yPercent
        )
    }
    
    private func calculateFishHeadSize(for fish: Fish, canvasSize: CGSize) -> CGSize {
        // Tamanho da cabeça baseado no tipo de peixe
        // Valores são percentuais da imagem (0.0 a 1.0)
        
        let (widthPercent, heightPercent) = fishHeadSizePercent(for: fish)
        
        return CGSize(
            width: canvasSize.width * widthPercent,
            height: canvasSize.height * heightPercent
        )
    }
    
    private func fishHeadPositionPercent(for fish: Fish) -> (x: Double, y: Double) {
        // Retorna posição da cabeça como percentual da imagem
        // (0,0) = top-left, (1,1) = bottom-right
        
        switch fish.name {
        case "Peixe palhaço":
            return (0.2, 0.15)  // Cabeça mais à esquerda, no topo
        case "Piranha":
            return (0.25, 0.2)  // Cabeça central-esquerda
        case "Peixe lua":
            return (0.3, 0.1)   // Cabeça mais central, no topo
        case "Pirarucu":
            return (0.15, 0.25) // Cabeça à esquerda, mais para baixo
        case "Peixe bolha":
            return (0.3, 0.3)   // Centro, mais para baixo (corpo gelatinoso)
        default:
            return (0.25, 0.2)  // Posição padrão
        }
    }
    
    private func fishHeadSizePercent(for fish: Fish) -> (width: Double, height: Double) {
        // Retorna tamanho da cabeça como percentual da imagem
        
        switch fish.name {
        case "Peixe lua":
            return (0.4, 0.4)   // Cabeça grande (peixe lua é redondo)
        case "Peixe bolha":
            return (0.45, 0.4)  // Cabeça maior (corpo gelatinoso)
        case "Piranha":
            return (0.3, 0.25)  // Cabeça média
        case "Pirarucu":
            return (0.35, 0.3)  // Cabeça grande (peixe grande)
        case "Peixe palhaço":
            return (0.25, 0.2)  // Cabeça pequena
        default:
            return (0.3, 0.25)  // Tamanho padrão
        }
    }
    
    private func shouldApplyCircularMask(for fish: Fish) -> Bool {
        // Alguns peixes ficam melhor com máscara circular
        switch fish.name {
        case "Peixe lua", "Peixe bolha":
            return true
        default:
            return false
        }
    }
    
    // MARK: - Ajustes Específicos por Peixe
    
    private func applyFishSpecificAdjustments(
        context: CGContext,
        fish: Fish,
        faceRect: CGRect,
        canvasSize: CGSize
    ) throws {
        
        print("🎨 Aplicando ajustes para \(fish.name)...")
        
        switch fish.name {
        case "Peixe palhaço":
            // Adicionar pequenas listras laranja ao redor do rosto
            drawClownfishStripes(context: context, faceRect: faceRect)
            
        case "Piranha":
            // Adicionar dentes pequenos ao redor da boca (se detectada)
            drawPiranhaTeeth(context: context, faceRect: faceRect)
            
        case "Peixe bolha":
            // Adicionar efeito gelatinoso/transparente
            drawBlobEffect(context: context, faceRect: faceRect)
            
        case "Peixe lua":
            // Adicionar brilho prateado
            drawSunfishGlow(context: context, faceRect: faceRect)
            
        default:
            // Ajustes genéricos ou nenhum ajuste especial
            break
        }
    }
    
    // MARK: - Efeitos Específicos (Simplificados)
    
    private func drawClownfishStripes(context: CGContext, faceRect: CGRect) {
        context.setFillColor(UIColor.orange.withAlphaComponent(0.3).cgColor)
        
        // Desenhar algumas listras finas
        let stripeHeight: CGFloat = 3
        for i in 0..<3 {
            let y = faceRect.minY + CGFloat(i) * faceRect.height / 3
            let rect = CGRect(x: faceRect.minX, y: y, width: faceRect.width, height: stripeHeight)
            context.fill(rect)
        }
    }
    
    private func drawPiranhaTeeth(context: CGContext, faceRect: CGRect) {
        context.setFillColor(UIColor.white.withAlphaComponent(0.8).cgColor)
        
        // Desenhar pequenos triângulos como dentes
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
        // Adicionar overlay semi-transparente para efeito gelatinoso
        context.setFillColor(UIColor.blue.withAlphaComponent(0.1).cgColor)
        context.fillEllipse(in: faceRect)
    }
    
    private func drawSunfishGlow(context: CGContext, faceRect: CGRect) {
        // Adicionar brilho prateado
        context.setFillColor(UIColor.white.withAlphaComponent(0.2).cgColor)
        context.fillEllipse(in: faceRect.insetBy(dx: -5, dy: -5))
    }
}

// MARK: - Erros
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
