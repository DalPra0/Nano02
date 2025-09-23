# FishQuiz - Estrutura do Projeto

## 📁 Arquitetura MVVM Organizada

Este projeto segue uma arquitetura bem estruturada com separação clara de responsabilidades:

### 🏗️ Estrutura de Pastas

```
FishQuiz/
├── App/                          # Arquivos principais da aplicação
│   ├── Nano02PeixeApp.swift     # Entry point do app
│   └── ContentView.swift        # View principal
├── Models/                       # Modelos de dados
│   ├── Fish.swift               # Modelo do peixe
│   ├── Question.swift           # Modelo da pergunta
│   ├── Answer.swift             # Modelo da resposta
│   └── QuizResult.swift         # Modelo do resultado
├── ViewModels/                   # ViewModels (MVVM)
│   ├── QuizViewModel.swift      # ViewModel do quiz
│   └── CameraViewModel.swift    # ViewModel da câmera
├── Views/                        # Views organizadas por funcionalidade
│   ├── Quiz/                    # Views do quiz
│   │   ├── QuizStartView.swift
│   │   ├── QuestionView.swift
│   │   ├── QuizProgressView.swift
│   │   └── QuizResultView.swift
│   ├── Camera/                  # Views da câmera e Vision
│   │   ├── CameraView.swift
│   │   ├── FaceDetectionView.swift
│   │   └── FishFilterView.swift
│   └── Components/              # Componentes reutilizáveis
│       ├── AnswerButton.swift
│       ├── FishCard.swift
│       └── CustomButton.swift
├── Services/                     # Serviços e lógica de negócio
│   ├── QuizEngine.swift         # Engine de cálculo do quiz
│   ├── FaceDetectionService.swift # Serviço Vision Framework
│   └── ImageProcessingService.swift # Processamento de imagens
├── Data/                         # Dados e mock data
│   ├── QuestionsData.swift      # Dados das perguntas
│   └── FishData.swift           # Dados dos 16 peixes
├── Utils/                        # Utilitários e extensões
│   ├── Extensions.swift         # Extensões úteis
│   └── Constants.swift          # Constantes do projeto
└── Resources/                    # Recursos estáticos
    ├── Images/
    │   └── Fish/                # Imagens dos 16 peixes
    └── Sounds/                  # Sons (opcional)
```

## 🎯 Próximos Passos

1. **Pesquisar características dos 16 peixes**
2. **Criar perguntas engraçadas do quiz**
3. **Implementar models e ViewModels**
4. **Desenvolver Views do quiz**
5. **Integrar Vision Framework**
6. **Polir e testar**

## 🐠 Os 16 Peixes

1. Peixe-mão liso
2. Peixe-espátula-chinês
3. Peixe jacaré
4. Peixe dragão
5. Esturjão
6. Peixe palhaço
7. Peixe lua
8. Piranha
9. Peixe pedra
10. Peixe-víbora de Sloane
11. Peixe-pescador
12. Pirarucu
13. Peixe bolha
14. Pacu
15. Bagre
16. Tilápia

---

**Nota**: Todos os arquivos foram criados como placeholders e estão prontos para implementação!
