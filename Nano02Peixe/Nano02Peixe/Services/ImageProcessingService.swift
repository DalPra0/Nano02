import Foundation
import UIKit
import CoreGraphics

class ImageProcessingService {
    
    // MARK: - Resultado do processamento
    struct ProcessedImageResult {
        let originalImage: UIImage
        let processedImage: UIImage
        let fishCharacteristics: [String]  // Lista do que foi aplicado
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
        print("🎨 ImageProcessingService: Aplicando filtro de \(fish.name)...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // Aplicar características baseadas no tipo de peixe
                let processedImage = try self.processImage(
                    original: image,
                    faceDetection: faceResult,
                    fish: fish
                )
                
                let processingTime = Date().timeIntervalSince(startTime)
                print("✅ Filtro aplicado em \(String(format: "%.2f", processingTime))s")
                
                let result = ProcessedImageResult(
                    originalImage: image,
                    processedImage: processedImage,
                    fishCharacteristics: self.getCharacteristicsForFish(fish),
                    processingTime: processingTime
                )
                
                DispatchQueue.main.async {
                    completion(.success(result))
                }
                
            } catch {
                print("❌ Erro ao processar imagem: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Processamento Principal da Imagem
    private func processImage(
        original: UIImage,
        faceDetection: FaceDetectionService.FaceDetectionResult,
        fish: Fish
    ) throws -> UIImage {
        
        guard let cgImage = original.cgImage else {
            throw ImageProcessingError.invalidImage
        }
        
        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        
        // Criar contexto de desenho
        UIGraphicsBeginImageContextWithOptions(imageSize, false, original.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            throw ImageProcessingError.contextCreationFailed
        }
        
        // Desenhar imagem original
        original.draw(at: .zero)
        
        // Aplicar características específicas do peixe
        try applyFishCharacteristics(
            context: context,
            imageSize: imageSize,
            faceDetection: faceDetection,
            fish: fish
        )
        
        // Capturar resultado
        guard let processedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            throw ImageProcessingError.imageCreationFailed
        }
        
        return processedImage
    }
    
    // MARK: - Aplicar Características Específicas
    private func applyFishCharacteristics(
        context: CGContext,
        imageSize: CGSize,
        faceDetection: FaceDetectionService.FaceDetectionResult,
        fish: Fish
    ) throws {
        
        print("🐟 Aplicando características de \(fish.name)...")
        
        // Converter coordenadas Vision para UIImage
        let face = convertFaceCoordinates(faceDetection, imageSize: imageSize)
        
        // Aplicar características baseadas no tipo de peixe
        switch fish.name {
        case "Peixe palhaço":
            try applyClownfishCharacteristics(context: context, face: face, imageSize: imageSize)
            
        case "Piranha":
            try applyPiranhaCharacteristics(context: context, face: face, imageSize: imageSize)
            
        case "Peixe bolha":
            try applyBlobfishCharacteristics(context: context, face: face, imageSize: imageSize)
            
        case "Peixe lua":
            try applySunfishCharacteristics(context: context, face: face, imageSize: imageSize)
            
        case "Peixe-víbora de Sloane":
            try applyViperCharacteristics(context: context, face: face, imageSize: imageSize)
            
        default:
            // Características genéricas para outros peixes
            try applyGenericFishCharacteristics(context: context, face: face, imageSize: imageSize)
        }
    }
    
    // MARK: - Características Específicas por Peixe
    
    private func applyClownfishCharacteristics(context: CGContext, face: ConvertedFaceCoordinates, imageSize: CGSize) throws {
        print("🤡 Aplicando características de peixe palhaço...")
        
        // Listras laranja e branca
        drawClownfishStripes(context: context, face: face)
        
        // Olhos grandes e expressivos
        drawLargeEyes(context: context, leftEye: face.leftEye, rightEye: face.rightEye, color: .black)
        
        // Barbatanas pequenas nas laterais
        drawSmallFins(context: context, face: face, color: UIColor.orange)
    }
    
    private func applyPiranhaCharacteristics(context: CGContext, face: ConvertedFaceCoordinates, imageSize: CGSize) throws {
        print("🦷 Aplicando características de piranha...")
        
        // Dentes afiados
        drawSharpTeeth(context: context, mouth: face.outerLips)
        
        // Olhos pequenos e intensos
        drawIntenseEyes(context: context, leftEye: face.leftEye, rightEye: face.rightEye)
        
        // Escamas cinzas
        drawScales(context: context, face: face, color: UIColor.darkGray.withAlphaComponent(0.3))
    }
    
    private func applyBlobfishCharacteristics(context: CGContext, face: ConvertedFaceCoordinates, imageSize: CGSize) throws {
        print("😅 Aplicando características de peixe bolha...")
        
        // Efeito gelatinoso/derretido
        drawBlobEffect(context: context, face: face)
        
        // Olhos caídos
        drawDroopyEyes(context: context, leftEye: face.leftEye, rightEye: face.rightEye)
        
        // Boca caída
        drawSadMouth(context: context, mouth: face.outerLips)
    }
    
    private func applySunfishCharacteristics(context: CGContext, face: ConvertedFaceCoordinates, imageSize: CGSize) throws {
        print("🌞 Aplicando características de peixe lua...")
        
        // Formato circular exagerado
        drawCircularFaceOutline(context: context, face: face)
        
        // Olhos pequenos relativos ao tamanho
        drawTinyEyes(context: context, leftEye: face.leftEye, rightEye: face.rightEye)
        
        // Textura prateada
        drawMetallicTexture(context: context, face: face, color: UIColor.lightGray.withAlphaComponent(0.4))
    }
    
    private func applyViperCharacteristics(context: CGContext, face: ConvertedFaceCoordinates, imageSize: CGSize) throws {
        print("🐍 Aplicando características de peixe-víbora...")
        
        // Dentes longos tipo vampiro
        drawVampireTeeth(context: context, mouth: face.outerLips)
        
        // Olhos luminosos/brilhantes
        drawGlowingEyes(context: context, leftEye: face.leftEye, rightEye: face.rightEye)
        
        // Textura escura/misteriosa
        drawDarkTexture(context: context, face: face)
    }
    
    private func applyGenericFishCharacteristics(context: CGContext, face: ConvertedFaceCoordinates, imageSize: CGSize) throws {
        print("🐟 Aplicando características genéricas de peixe...")
        
        // Escamas básicas
        drawScales(context: context, face: face, color: UIColor.blue.withAlphaComponent(0.2))
        
        // Olhos de peixe
        drawFishEyes(context: context, leftEye: face.leftEye, rightEye: face.rightEye)
        
        // Barbatanas laterais
        drawBasicFins(context: context, face: face)
    }
    
    // MARK: - Funções de Desenho Básicas
    
    private func drawClownfishStripes(context: CGContext, face: ConvertedFaceCoordinates) {
        context.setFillColor(UIColor.orange.withAlphaComponent(0.6).cgColor)
        
        // Desenhar listras horizontais
        let stripeHeight = face.boundingBox.height / 6
        for i in 0..<3 {
            let y = face.boundingBox.minY + CGFloat(i * 2) * stripeHeight
            let rect = CGRect(
                x: face.boundingBox.minX,
                y: y,
                width: face.boundingBox.width,
                height: stripeHeight
            )
            context.fill(rect)
        }
    }
    
    private func drawLargeEyes(context: CGContext, leftEye: [CGPoint], rightEye: [CGPoint], color: UIColor) {
        context.setFillColor(color.cgColor)
        
        // Desenhar círculos maiores sobre os olhos
        if let leftCenter = centerPoint(of: leftEye) {
            let radius = 15.0
            context.fillEllipse(in: CGRect(
                x: leftCenter.x - radius,
                y: leftCenter.y - radius,
                width: radius * 2,
                height: radius * 2
            ))
        }
        
        if let rightCenter = centerPoint(of: rightEye) {
            let radius = 15.0
            context.fillEllipse(in: CGRect(
                x: rightCenter.x - radius,
                y: rightCenter.y - radius,
                width: radius * 2,
                height: radius * 2
            ))
        }
    }
    
    private func drawSharpTeeth(context: CGContext, mouth: [CGPoint]) {
        guard mouth.count >= 3 else { return }
        
        context.setFillColor(UIColor.white.cgColor)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(1.0)
        
        // Desenhar triângulos como dentes
        let teethCount = 5
        let mouthWidth = mouth.max { $0.x < $1.x }!.x - mouth.min { $0.x < $1.x }!.x
        let toothWidth = mouthWidth / CGFloat(teethCount)
        
        if let mouthCenter = centerPoint(of: mouth) {
            for i in 0..<teethCount {
                let x = mouthCenter.x - mouthWidth/2 + CGFloat(i) * toothWidth
                let points = [
                    CGPoint(x: x, y: mouthCenter.y),
                    CGPoint(x: x + toothWidth/2, y: mouthCenter.y - 10),
                    CGPoint(x: x + toothWidth, y: mouthCenter.y)
                ]
                
                context.move(to: points[0])
                context.addLine(to: points[1])
                context.addLine(to: points[2])
                context.closePath()
                context.drawPath(using: .fillStroke)
            }
        }
    }
    
    private func drawScales(context: CGContext, face: ConvertedFaceCoordinates, color: UIColor) {
        context.setFillColor(color.cgColor)
        
        // Desenhar padrão de escamas como círculos sobrepostos
        let scaleSize: CGFloat = 8
        let spacing: CGFloat = 6
        
        let rows = Int(face.boundingBox.height / spacing)
        let cols = Int(face.boundingBox.width / spacing)
        
        for row in 0..<rows {
            for col in 0..<cols {
                let x = face.boundingBox.minX + CGFloat(col) * spacing
                let y = face.boundingBox.minY + CGFloat(row) * spacing
                
                // Verificar se está dentro do contorno do rosto
                if pointIsInFace(CGPoint(x: x, y: y), faceContour: face.faceContour) {
                    context.fillEllipse(in: CGRect(
                        x: x - scaleSize/2,
                        y: y - scaleSize/2,
                        width: scaleSize,
                        height: scaleSize
                    ))
                }
            }
        }
    }
    
    // MARK: - Funções Auxiliares
    
    private func convertFaceCoordinates(_ face: FaceDetectionService.FaceDetectionResult, imageSize: CGSize) -> ConvertedFaceCoordinates {
        
        // Converter bounding box
        let boundingBox = CGRect(
            x: face.boundingBox.minX * imageSize.width,
            y: (1 - face.boundingBox.maxY) * imageSize.height,  // Inverter Y
            width: face.boundingBox.width * imageSize.width,
            height: face.boundingBox.height * imageSize.height
        )
        
        // Converter pontos
        func convertPoints(_ points: [CGPoint]) -> [CGPoint] {
            return points.map { point in
                CGPoint(
                    x: point.x * imageSize.width,
                    y: (1 - point.y) * imageSize.height
                )
            }
        }
        
        return ConvertedFaceCoordinates(
            boundingBox: boundingBox,
            leftEye: convertPoints(face.leftEye),
            rightEye: convertPoints(face.rightEye),
            nose: convertPoints(face.nose),
            outerLips: convertPoints(face.outerLips),
            faceContour: convertPoints(face.faceContour)
        )
    }
    
    private func centerPoint(of points: [CGPoint]) -> CGPoint? {
        guard !points.isEmpty else { return nil }
        
        let sumX = points.reduce(0) { $0 + $1.x }
        let sumY = points.reduce(0) { $0 + $1.y }
        
        return CGPoint(
            x: sumX / CGFloat(points.count),
            y: sumY / CGFloat(points.count)
        )
    }
    
    private func pointIsInFace(_ point: CGPoint, faceContour: [CGPoint]) -> Bool {
        // Implementação simples: verificar se está dentro do bounding box
        // Em uma versão mais sofisticada, usaríamos o contorno real
        guard let minX = faceContour.min(by: { $0.x < $1.x })?.x,
              let maxX = faceContour.max(by: { $0.x < $1.x })?.x,
              let minY = faceContour.min(by: { $0.y < $1.y })?.y,
              let maxY = faceContour.max(by: { $0.y < $1.y })?.y else {
            return false
        }
        
        return point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY
    }
    
    private func getCharacteristicsForFish(_ fish: Fish) -> [String] {
        switch fish.name {
        case "Peixe palhaço":
            return ["Listras laranja", "Olhos grandes", "Barbatanas pequenas"]
        case "Piranha":
            return ["Dentes afiados", "Olhos intensos", "Escamas escuras"]
        case "Peixe bolha":
            return ["Efeito gelatinoso", "Olhos caídos", "Expressão melancólica"]
        case "Peixe lua":
            return ["Formato circular", "Olhos pequenos", "Textura prateada"]
        case "Peixe-víbora de Sloane":
            return ["Dentes vampiro", "Olhos brilhantes", "Textura misteriosa"]
        default:
            return ["Escamas", "Olhos de peixe", "Barbatanas"]
        }
    }
    
    // Adicionar implementações placeholder para as outras funções de desenho
    private func drawSmallFins(context: CGContext, face: ConvertedFaceCoordinates, color: UIColor) {
        // TODO: Implementar barbatanas pequenas
    }
    
    private func drawIntenseEyes(context: CGContext, leftEye: [CGPoint], rightEye: [CGPoint]) {
        // TODO: Implementar olhos intensos
    }
    
    private func drawBlobEffect(context: CGContext, face: ConvertedFaceCoordinates) {
        // TODO: Implementar efeito gelatinoso
    }
    
    private func drawDroopyEyes(context: CGContext, leftEye: [CGPoint], rightEye: [CGPoint]) {
        // TODO: Implementar olhos caídos
    }
    
    private func drawSadMouth(context: CGContext, mouth: [CGPoint]) {
        // TODO: Implementar boca triste
    }
    
    private func drawCircularFaceOutline(context: CGContext, face: ConvertedFaceCoordinates) {
        // TODO: Implementar contorno circular
    }
    
    private func drawTinyEyes(context: CGContext, leftEye: [CGPoint], rightEye: [CGPoint]) {
        // TODO: Implementar olhos pequenos
    }
    
    private func drawMetallicTexture(context: CGContext, face: ConvertedFaceCoordinates, color: UIColor) {
        // TODO: Implementar textura metálica
    }
    
    private func drawVampireTeeth(context: CGContext, mouth: [CGPoint]) {
        // TODO: Implementar dentes vampiro
    }
    
    private func drawGlowingEyes(context: CGContext, leftEye: [CGPoint], rightEye: [CGPoint]) {
        // TODO: Implementar olhos brilhantes
    }
    
    private func drawDarkTexture(context: CGContext, face: ConvertedFaceCoordinates) {
        // TODO: Implementar textura escura
    }
    
    private func drawFishEyes(context: CGContext, leftEye: [CGPoint], rightEye: [CGPoint]) {
        // TODO: Implementar olhos de peixe genéricos
    }
    
    private func drawBasicFins(context: CGContext, face: ConvertedFaceCoordinates) {
        // TODO: Implementar barbatanas básicas
    }
}

// MARK: - Estruturas Auxiliares

private struct ConvertedFaceCoordinates {
    let boundingBox: CGRect
    let leftEye: [CGPoint]
    let rightEye: [CGPoint]
    let nose: [CGPoint]
    let outerLips: [CGPoint]
    let faceContour: [CGPoint]
}

// MARK: - Erros
enum ImageProcessingError: LocalizedError {
    case invalidImage
    case contextCreationFailed
    case imageCreationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Imagem inválida para processamento"
        case .contextCreationFailed:
            return "Erro interno: não foi possível criar contexto de desenho"
        case .imageCreationFailed:
            return "Erro ao gerar imagem processada"
        }
    }
}
