# 🐟 IMAGENS DOS PEIXES - NECESSÁRIAS PARA O PROJETO

## 📋 **LISTA DE IMAGENS NECESSÁRIAS:**

Você precisa adicionar **16 imagens** dos peixes nesta pasta, com os seguintes nomes:

### **Formato:** `nome-do-peixe.png` ou `.jpg`

1. `peixe-mao-liso.png`
2. `peixe-espatula-chines.png`
3. `peixe-jacare.png`
4. `peixe-dragao.png`
5. `esturjao.png`
6. `peixe-palhaco.png`
7. `peixe-lua.png`
8. `piranha.png`
9. `peixe-pedra.png`
10. `peixe-vibora-sloane.png`
11. `peixe-pescador.png`
12. `pirarucu.png`
13. `peixe-bolha.png`
14. `pacu.png`
15. `bagre.png`
16. `tilapia.png`   

## 🎨 **ESPECIFICAÇÕES DAS IMAGENS:**

### **Opção 1: Fotos Reais**
- **Resolução:** 1024x1024px mínimo
- **Formato:** PNG com transparência ou JPG
- **Orientação:** Peixe virado para frente/lado
- **Área da cabeça:** Clara e visível para sobrepor rosto

### **Opção 2: Renders 3D/Ilustrações**
- **Estilo:** Cartoon, 3D render, ou realista
- **Background:** Transparente (PNG) preferível
- **Composição:** Corpo completo do peixe
- **Cabeça:** Proporcional para receber rosto humano

### **Opção 3: AI Generated** 
- **Prompt sugerido:** "High quality 3D render of [FISH NAME], front view, clean background, detailed, professional lighting"
- **Tools:** Midjourney, DALL-E, Stable Diffusion

## 📁 **COMO ADICIONAR NO XCODE:**

1. **Arraste as imagens** para a pasta `Resources/Images/Fish/` no Finder
2. **No Xcode:** Clique com botão direito na pasta Fish
3. **"Add Files to Nano02Peixe"**
4. **Selecione todas as 16 imagens**
5. **Marque "Copy items if needed"**
6. **Target:** Certifique-se que está marcado "Nano02Peixe"

## 🔗 **INTEGRAÇÃO NO CÓDIGO:**

As imagens serão carregadas automaticamente usando:
```swift
UIImage(named: "peixe-palhaco") // Para Peixe palhaço
UIImage(named: "piranha")       // Para Piranha
// etc...
```

## 🎯 **COMO SERÁ USADO:**

1. **Usuário faz quiz** → "Você é Peixe palhaço"
2. **Tira foto** → Vision detecta rosto
3. **Processamento:** Recorta rosto + carrega `peixe-palhaco.png`
4. **Resultado:** Rosto da pessoa NO CORPO do peixe palhaço

---

**⚠️ IMPORTANTE:** Sem essas imagens, o filtro não funcionará!

**Status:** 🔴 PENDENTE - Imagens precisam ser adicionadas
