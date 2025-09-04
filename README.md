# 🌙 Luna AI - Asistente de Apoyo Emocional para Fertilidad

Una aplicación iOS avanzada que proporciona apoyo emocional personalizado durante el proceso de fertilidad, utilizando inteligencia artificial y análisis emocional sofisticado.

## ✨ Características Principales

### 🧠 Inteligencia Artificial Avanzada
- **Análisis Emocional con RegEx**: Detección precisa de emociones con manejo de negaciones
- **Adaptación de Personalidad**: La IA ajusta su personalidad basándose en las emociones detectadas
- **Respuestas Deterministas**: Algoritmo con semilla diaria para consistencia en las respuestas
- **Filtros de Seguridad**: Protección contra consejos médicos inadecuados

### 🏗️ Arquitectura Modular Enterprise
- **Inyección de Dependencias**: Arquitectura completamente modular y testeable
- **Protocolos Especializados**: `EmotionAnalyzing`, `SafetyFiltering`, `PersonalityAdapting`
- **Persistencia SwiftData**: Almacenamiento de conversaciones y analytics
- **Internacionalización Completa**: Soporte multi-idioma con String Catalogs

### 🛡️ Características de Seguridad
- **Filtros Clínicos**: Prevención automática de consejos médicos inappropriados
- **Disclaimer Integrado**: Información legal clara y no intrusiva
- **Rate Limiting**: Control de frecuencia de mensajes
- **Validación de Contenido**: Reemplazo automático de términos riesgosos

### 📊 Analytics y Observabilidad
- **Tracking Emocional**: Seguimiento de patrones emocionales del usuario
- **Métricas de Confianza**: Scoring de precisión en detección emocional
- **Logging Estructurado**: Sistema de logs con os.Logger
- **Resúmenes Automáticos**: Análisis de conversaciones largas

## 🔧 Tecnologías Utilizadas

- **Swift 5.9+**
- **SwiftUI**: Interfaz de usuario moderna y reactiva
- **SwiftData**: Persistencia de datos nativa
- **Combine**: Programación reactiva
- **XCTest**: Testing unitario y de integración
- **String Catalogs**: Localización avanzada

## 🏛️ Arquitectura del Sistema

```
┌─────────────────────┐
│   Presentation      │
│   - SwiftUI Views   │
│   - ViewModels      │
└─────────┬───────────┘
          │
┌─────────▼───────────┐
│   Domain Layer      │
│   - Use Cases       │
│   - Business Logic  │
│   - Protocols       │
└─────────┬───────────┘
          │
┌─────────▼───────────┐
│   Data Layer        │
│   - SwiftData       │
│   - Services        │
│   - Repositories    │
└─────────────────────┘
```

### Componentes Principales

#### 🎯 Análisis Emocional
```swift
RegexEmotionAnalyzer
├── Detección con regex avanzado
├── Manejo de negaciones (ventana de 3 palabras)
├── Scoring de confianza (0.0 - 1.0)
└── Folding de acentos
```

#### 🛡️ Sistema de Seguridad
```swift
SimpleSafetyFilter
├── Detección de términos médicos
├── Reemplazo contextual
├── Prevención de diagnósticos
└── Filtros educativos
```

#### 🧩 Adaptación de Personalidad
```swift
ClampedPersonalityAdapter
├── Ajuste dinámico de traits
├── Clamping de valores (0.0 - 1.0)
├── Regresión a baseline
└── Adaptación contextual
```

## 🚀 Instalación y Configuración

### Requisitos
- Xcode 15.0+
- iOS 17.0+
- macOS 14.0+ (para desarrollo)

### Configuración del Proyecto
```bash
git clone https://github.com/Minomoreno86/EMOCIONES.git
cd EMOCIONES
open "ASISTENTE APOYO EMOCIONAL FERTILIDAD.xcodeproj"
```

### Configuración de Localización
El proyecto utiliza String Catalogs para internacionalización:
- Archivo principal: `Resources/Localization/Localizable.xcstrings`
- Soporte para múltiples idiomas
- Localización automática de respuestas emocionales

## 🧪 Testing

### Estrategia de Testing
- **Unit Tests**: Tests para cada componente modular
- **Integration Tests**: Verificación de flujos completos
- **UI Tests**: Automatización de interfaz de usuario

### Ejecutar Tests
```bash
# Tests unitarios
xcodebuild test -project "ASISTENTE APOYO EMOCIONAL FERTILIDAD.xcodeproj" -scheme "ASISTENTE APOYO EMOCIONAL FERTILIDAD" -destination "platform=iOS Simulator,name=iPhone 15"

# Tests específicos de análisis emocional
# Ver: Tests/Unit/EmotionAnalysisTests.swift
```

### Cobertura de Testing
- ✅ Análisis emocional con negaciones
- ✅ Adaptación de personalidad
- ✅ Filtros de seguridad
- ✅ Persistencia de datos
- ✅ Generación determinista

## 📱 Características de la UI

### Interfaz Optimizada
- **Chat Responsivo**: Área de mensajes maximizada
- **Disclaimer Discreto**: Información legal no intrusiva
- **Header Compacto**: Avatar y estado emocional eficiente
- **Input Inteligente**: Campo de entrada adaptativo

### Componentes Reutilizables
- `MessageBubbleView`: Burbujas de chat con metadatos emocionales
- `PersonalityHeaderView`: Estado de IA compacto
- `DisclaimerBannerView`: Banner legal minimalista
- `MessageInputView`: Input con validación en tiempo real

## 🔮 Características Avanzadas

### Algoritmo Determinista
```swift
SeededGenerator
├── Semilla basada en día del año
├── Respuestas consistentes por día
├── Reproducibilidad para testing
└── Variación controlada
```

### Sistema de Analytics
```swift
ConversationAnalytics
├── Distribución emocional
├── Nivel de adaptación
├── Confianza promedio
└── Duración de conversación
```

### Configuración Avanzada
```swift
ResponseConfig
├── Temperature (0.0 - 1.0)
├── Rate limiting
├── Límites de mensajes
└── Configuración de resúmenes
```

## 🛠️ Desarrollo y Contribución

### Principios de Desarrollo
1. **Modularidad**: Cada funcionalidad en módulos independientes
2. **Testabilidad**: Todos los componentes deben ser testeable
3. **Seguridad**: Filtros y validaciones en todas las capas
4. **Performance**: Optimización de memoria y CPU
5. **Accessibility**: Soporte completo para accesibilidad

### Guías de Contribución
- Seguir los principios SOLID
- Implementar tests para nuevas funcionalidades
- Documentar APIs públicas
- Mantener cobertura de testing > 80%

## 📄 Licencia

Proyecto privado - Todos los derechos reservados

## 👥 Equipo de Desarrollo

Desarrollado con ❤️ para proporcionar apoyo emocional durante el proceso de fertilidad.

---

*Luna AI - Acompañándote en cada paso de tu viaje hacia la maternidad/paternidad* 🌙✨
