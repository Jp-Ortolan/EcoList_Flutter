# EcoList - Gerenciador Inteligente de Alimentos

Um aplicativo inteligente de gerenciamento de alimentos desenvolvido em Flutter, que combina controle de estoque doméstico com sugestões de receitas baseadas nos ingredientes disponíveis. O app integra com a API TheMealDB e implementa princípios avançados de UI/UX e responsividade.

## 🎯 Funcionalidades Principais

### 📦 Gerenciamento de Alimentos
- **Cadastro de alimentos** com informações detalhadas (nome, categoria, quantidade, unidade)
- **Controle de validade** com alertas de alimentos próximos do vencimento
- **Categorização inteligente** (Carne, Verdura, Fruta, Laticínios, Grãos, Temperos, Bebidas, Outros)
- **Múltiplas unidades** (Unidade, Kg, Gramas, Litros, Ml, Colheres, Xícaras, Latas, Pacotes)
- **Observações personalizadas** para cada alimento

### 🍳 Sistema de Receitas da API
- **Integração com TheMealDB** para receitas internacionais
- **Sugestões baseadas em ingredientes** disponíveis em casa
- **Tradução automática** para português brasileiro
- **Receitas favoritas** para acesso rápido
- **Detalhes completos** com ingredientes e instruções

### 📱 Interface Responsiva
- **Design adaptativo** para mobile, tablet e desktop
- **Atomic Design** com componentes reutilizáveis
- **Microinterações** suaves e profissionais
- **Acessibilidade completa** com suporte a leitores de tela
- **Tema consistente** com cores e tipografia otimizadas

## 🚀 Funcionalidades Técnicas

### Atomic Design
- **Átomos**: Widgets reutilizáveis (CustomButton, CustomTextField, FoodCard)
- **Moléculas**: Componentes compostos (RecipeCard, ResponsiveRecipeCard)
- **Organismos**: Telas completas usando os componentes atômicos

### Microinterações
- Animações suaves de entrada e saída
- Feedback visual em botões e cards
- Transições fluidas entre telas
- Animações escalonadas em listas

### Acessibilidade
- Uso de Semantics para leitores de tela
- Contraste adequado de cores
- Labels descritivos para elementos interativos
- Navegação por teclado suportada

### Consumo de API
- Integração completa com **TheMealDB**
- Busca de receitas por categoria
- Receitas aleatórias
- Busca por nome
- Tratamento de erros e loading states
- **Cache inteligente** para melhor performance

### Formulários e Validação
- Formulários completos para adicionar alimentos
- Validação em tempo real
- Múltiplos campos de entrada
- Feedback visual de erros
- Validação de datas e quantidades

### Responsividade
- **Layout adaptativo** baseado no tamanho da tela
- **Breakpoints**: Mobile (<600px), Tablet (600-1200px), Desktop (>1200px)
- **Espaçamentos dinâmicos** e fontes escaláveis
- **Grid layouts** para telas maiores
- **Lista vertical** para mobile

## 📊 Sistema de Alertas

### 🚨 Alimentos Próximos do Vencimento
- **Alertas automáticos** para alimentos que vencem em 3 dias
- **Aba dedicada** para visualização rápida
- **Sugestões de receitas** para usar ingredientes antes do vencimento
- **Status visual** com cores indicativas (Verde: Fresco, Laranja: Próximo, Vermelho: Vencido)

## 🌐 Tradução e Localização

### Português Brasileiro
- **Tradução automática** de categorias de receitas
- **Instruções traduzidas** com vocabulário culinário brasileiro
- **Nomes de ingredientes** em português
- **Interface completamente** em português

## 🏗️ Arquitetura

### Estrutura de Pastas
```
lib/
├── models/           # Modelos de dados
├── services/         # Serviços (API, Storage, Tradução)
├── screens/          # Telas da aplicação
├── widgets/          # Componentes reutilizáveis
│   ├── atoms/        # Componentes básicos
│   └── molecules/    # Componentes compostos
├── utils/            # Utilitários (Responsividade)
└── config/           # Configurações
```

### Tecnologias Utilizadas
- **Flutter** - Framework multiplataforma
- **Dart** - Linguagem de programação
- **SharedPreferences** - Armazenamento local
- **HTTP** - Consumo de APIs
- **Cached Network Image** - Cache de imagens
- **Flutter Staggered Animations** - Animações avançadas

## 🎨 Design System

### Cores
- **Primária**: Verde (Tema sustentável)
- **Status**: Verde (Fresco), Laranja (Próximo), Vermelho (Vencido)
- **Neutras**: Tons de cinza para textos e fundos

### Tipografia
- **Títulos**: FontWeight.bold
- **Corpo**: FontWeight.normal
- **Tamanhos**: Escaláveis baseados no dispositivo

### Espaçamentos
- **Mobile**: 8px base
- **Tablet**: 12px base  
- **Desktop**: 16px base

## 👥 Equipe

**Alunos**: João Pedro Ortolan, João Vitor Grando, Rafael Angelo Silva

## 📱 Como Usar

1. **Adicione alimentos** com suas informações e datas de validade
2. **Visualize alertas** de alimentos próximos do vencimento
3. **Explore receitas** da API TheMealDB 
4. **Organize favoritos** para acesso rápido às receitas preferidas
5. **Navegue pelas categorias** para descobrir novas receitas

## 🔮 Melhorias Futuras

### 🍽️ Sistema de Sugestões de Receitas
- **Integração avançada** com API de receitas baseada em ingredientes disponíveis
- **Algoritmo inteligente** para sugerir receitas com base em múltiplos ingredientes
- **Filtros personalizados** por tipo de dieta, tempo de preparo e dificuldade
- **Sugestões contextuais** baseadas em alimentos próximos do vencimento
- **Receba sugestões** de receitas baseadas nos ingredientes disponíveis 

### 🌍 Sistema de Tradução Completo
- **Tradução automática** de nomes de receitas da API TheMealDB
- **Tradução inteligente** de instruções de cozinha com contexto
- **Dicionário expandido** com mais de 500 termos culinários
- **Suporte multilíngue** para diferentes idiomas

## 🔮 Próximas Funcionalidades

- [ ] **Sistema de notificações** push para alertas de vencimento
- [ ] **Integração com câmera** para escaneamento de códigos de barras
- [ ] **Lista de compras** baseada em alimentos em falta
- [ ] **Modo offline** para consulta sem internet
- [ ] **Backup na nuvem** para sincronização entre dispositivos