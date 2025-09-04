import Foundation

// Import all necessary types from AITypes
// UserInput, UserContext, AIResponse, EmotionalState, TimeOfDay, etc.

// MARK: - AI Personality Engine Core

/// Motor de personalidad de IA que crea conexión emocional profunda
public class AIPersonalityEngine: ObservableObject {
    
    // MARK: - Core Personality
    
    private let corePersonality = AICorePersonality(
        name: "Luna",
        role: .empathicCompanion,
        communicationStyle: .warmAndUnderstanding,
        emotionalIntelligence: .veryHigh,
        specializations: [.fertilitySupport, .emotionalRegulation, .relationshipGuidance]
    )
    
    // MARK: - Adaptive Personality
    
    @Published var currentPersonalityState: AIPersonalityState
    @Published var conversationContext: ConversationContext
    @Published var userRelationship: AIUserRelationship
    
    // MARK: - Emotional Intelligence
    
    private let emotionalProcessor: EmotionalProcessor
    private let contextAnalyzer: ContextAnalyzer
    private let responseGenerator: EmpathicResponseGenerator
    
    init() {
        self.currentPersonalityState = AIPersonalityState.default
        self.conversationContext = ConversationContext()
        self.userRelationship = AIUserRelationship()
        self.emotionalProcessor = EmotionalProcessor()
        self.contextAnalyzer = ContextAnalyzer()
        self.responseGenerator = EmpathicResponseGenerator()
    }
    
    // MARK: - Main AI Response Generation
    
    public func generateResponse(
        to userInput: UserInput,
        in context: UserContext
    ) async -> AIResponse {
        
        // 1. Analizar estado emocional del usuario
        let emotionalState = await emotionalProcessor.analyzeEmotionalState(
            input: userInput,
            context: context,
            history: userRelationship.conversationHistory
        )
        
        // 2. Adaptar personalidad al contexto
        await adaptPersonalityToContext(
            emotionalState: emotionalState,
            context: context
        )
        
        // 3. Generar respuesta empática
        let response = await responseGenerator.generateEmpathicResponse(
            userInput: userInput,
            emotionalState: emotionalState,
            personality: currentPersonalityState,
            relationship: userRelationship
        )
        
        // 4. Actualizar relación y memoria
        updateRelationshipMemory(input: userInput, response: response)
        
        return response
    }
    
    // MARK: - Personality Adaptation
    
    private func adaptPersonalityToContext(
        emotionalState: EmotionalState,
        context: UserContext
    ) async {
        
        var newState = currentPersonalityState
        
        // Adaptar tono según estado emocional
        newState.communicationTone = determineTone(for: emotionalState)
        
        // Adaptar nivel de energía
        newState.energyLevel = determineEnergyLevel(for: context)
        
        // Adaptar enfoque conversacional
        newState.conversationalFocus = determineFocus(for: emotionalState, context: context)
        
        // Adaptar nivel de directividad
        newState.directivenessLevel = determineDirectiveness(for: emotionalState)
        
        await MainActor.run {
            self.currentPersonalityState = newState
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateRelationshipMemory(input: UserInput, response: AIResponse) {
        let memory = ConversationMemory(
            date: Date(),
            summary: input.text,
            emotionalHighlight: response.text,
            keyInsights: [],
            followUpNeeded: false
        )
        userRelationship.conversationHistory.append(memory)
    }
    
    private func determineEnergyLevel(for context: UserContext) -> Float {
        // Adaptar energía según tiempo del día y estado del usuario
        let timeEnergy = determineTimeBasedEnergy(context.timeOfDay)
        let contextEnergy = determineContextBasedEnergy(context)
        
        return (timeEnergy + contextEnergy) / 2
    }
    
    private func determineTimeBasedEnergy(_ timeOfDay: TimeOfDay) -> Float {
        switch timeOfDay {
        case .earlyMorning: return 0.3
        case .morning: return 0.7
        case .afternoon: return 0.8
        case .evening: return 0.6
        case .night: return 0.4
        case .lateNight: return 0.2
        }
    }
    
    private func determineContextBasedEnergy(_ context: UserContext) -> Float {
        var energy: Float = 0.5
        
        if context.partnerPresent {
            energy += 0.1
        }
        
        if context.fertilityPhase == .treatment {
            energy -= 0.2 // Más calmado durante tratamiento
        }
        
        return max(0.1, min(1.0, energy))
    }
    
    private func determineFocus(
        for emotionalState: EmotionalState,
        context: UserContext
    ) -> String {
        
        if emotionalState.intensityLevel > 0.7 {
            return "immediateEmotionalSupport"
        }
        
        if context.fertilityPhase == .treatment && context.treatmentDay != nil {
            return "treatmentSpecificSupport"
        }
        
        if context.partnerPresent {
            return "relationshipSupport"
        }
        
        return "generalWellbeingSupport"
    }
    
    private func determineDirectiveness(for emotionalState: EmotionalState) -> String {
        switch emotionalState.intensityLevel {
        case 0.0...0.3:
            return "gentle"
        case 0.3...0.6:
            return "balanced"
        case 0.6...0.8:
            return "direct"
        case 0.8...1.0:
            return "assertive"
        default:
            return "gentle"
        }
    }
    
    // MARK: - Empathic Response Generation
    
    private func determineTone(for emotionalState: EmotionalState) -> CommunicationTone {
        switch emotionalState.primaryEmotion {
        case .anxiety, .fear:
            return .gentle
        case .sadness, .grief:
            return .compassionate
        case .anger, .frustration:
            return .validating
        case .hope, .joy:
            return .celebratory
        case .confusion, .overwhelm:
            return .clarifying
        default:
            return .supportive
        }
    }
}

// MARK: - AI Personality Models

struct AICorePersonality {
    let name: String
    let role: AIRole
    let communicationStyle: CommunicationStyle
    let emotionalIntelligence: EmotionalIntelligenceLevel
    let specializations: [AISpecialization]
}

enum AIRole {
    case empathicCompanion
    case wiseMentor
    case supportiveFriend
    case professionalGuide
    case playfulMotivator
}

enum CommunicationStyle {
    case warmAndUnderstanding
    case professionalEmpathetic
    case friendlyEncouraging
    case gentleGuiding
    case directlySupportive
}

enum EmotionalIntelligenceLevel {
    case high
    case veryHigh
    case exceptional
}

enum AISpecialization {
    case fertilitySupport
    case emotionalRegulation
    case relationshipGuidance
    case mindfulnessCoaching
    case motivationalSupport
    case crisisIntervention
}

// MARK: - Dynamic Personality State

struct AIPersonalityState {
    var communicationTone: CommunicationTone
    var energyLevel: EnergyLevel
    var conversationalFocus: ConversationalFocus
    var directivenessLevel: DirectivenessLevel
    var empathyIntensity: Float // 0.0 - 1.0
    var personalizedElements: [PersonalizedElement]
    
    static let `default` = AIPersonalityState(
        communicationTone: .supportive,
        energyLevel: .calm,
        conversationalFocus: .generalWellbeingSupport,
        directivenessLevel: .gentle,
        empathyIntensity: 0.8,
        personalizedElements: []
    )
}

enum CommunicationTone {
    case gentle
    case compassionate
    case validating
    case celebratory
    case clarifying
    case supportive
    case encouraging
    case understanding
}

enum EnergyLevel {
    case veryCalm
    case calm
    case balanced(Float, Float) // time-based, context-based
    case energetic
    case enthusiastic
    
    var value: Float {
        switch self {
        case .veryCalm: return 0.2
        case .calm: return 0.4
        case .balanced(let time, let context): return (time + context) / 2
        case .energetic: return 0.7
        case .enthusiastic: return 0.9
        }
    }
}

enum ConversationalFocus {
    case immediateEmotionalSupport
    case treatmentSpecificSupport
    case relationshipSupport
    case generalWellbeingSupport
    case motivationalGuidance
    case practicalAdvice
    case celebrationAndEncouragement
}

enum DirectivenessLevel {
    case veryGentle      // Sugerencias muy suaves
    case gentle          // Guía sutil
    case balanced        // Equilibrio entre guía y libertad
    case direct          // Consejos claros
    case assertive       // Recomendaciones firmes (para crisis)
}

struct PersonalizedElement {
    let type: PersonalizationType
    let value: String
    let context: String
}

enum PersonalizationType {
    case preferredName        // Cómo le gusta que la llamen
    case communicationStyle   // Su estilo preferido
    case culturalBackground   // Consideraciones culturales
    case relationshipDynamic  // Cómo habla de su pareja
    case copingMechanism     // Sus mecanismos de afrontamiento
    case triggerWords        // Palabras que evitar
    case comfortWords        // Palabras que tranquilizan
}

// MARK: - Conversation Context

struct ConversationContext {
    var currentTopic: ConversationTopic
    var emotionalTrajectory: [EmotionalPoint]
    var sessionGoals: [SessionGoal]
    var conversationFlow: ConversationFlow
    var userEngagementLevel: EngagementLevel
    
    init() {
        self.currentTopic = .general
        self.emotionalTrajectory = []
        self.sessionGoals = []
        self.conversationFlow = .naturalFlow
        self.userEngagementLevel = .moderate
    }
}

enum ConversationTopic {
    case general
    case fertility
    case emotions
    case relationships
    case treatment
    case mindfulness
    case crisis
    case celebration
}

struct EmotionalPoint {
    let timestamp: Date
    let emotion: Emotion
    let intensity: Float
    let context: String
}

enum SessionGoal {
    case emotionalSupport
    case practicalGuidance
    case skillBuilding
    case crisisResolution
    case celebration
    case education
}

enum ConversationFlow {
    case naturalFlow        // Conversación fluida
    case structuredGuidance // Guía estructurada
    case crisisIntervention // Intervención de crisis
    case celebrationMode   // Modo celebración
}

enum EngagementLevel {
    case low          // Respuestas cortas, desconectada
    case moderate     // Participación normal
    case high         // Muy involucrada
    case veryHigh     // Completamente comprometida
}

// MARK: - User Relationship Memory

struct AIUserRelationship {
    var relationshipDepth: RelationshipDepth
    var trustLevel: Float // 0.0 - 1.0
    var communicationPreferences: CommunicationPreferences
    var sharedMemories: [SharedMemory]
    var conversationHistory: [ConversationMemory]
    var personalInsights: [PersonalInsight]
    
    init() {
        self.relationshipDepth = .acquaintance
        self.trustLevel = 0.5
        self.communicationPreferences = CommunicationPreferences()
        self.sharedMemories = []
        self.conversationHistory = []
        self.personalInsights = []
    }
}

enum RelationshipDepth {
    case stranger       // Primera interacción
    case acquaintance   // Pocas conversaciones
    case familiar       // Conversaciones regulares
    case trusted        // Alta confianza
    case intimate       // Relación profunda y personal
}

struct CommunicationPreferences {
    var preferredTone: CommunicationTone = .supportive
    var preferredLength: ResponseLength = .medium
    var useEmojis: Bool = true
    var formalityLevel: FormalityLevel = .casual
    var encouragementStyle: EncouragementStyle = .gentle
}

enum ResponseLength {
    case brief      // 1-2 oraciones
    case medium     // 3-5 oraciones
    case detailed   // 6+ oraciones
    case adaptive   // Se adapta al contexto
}

enum FormalityLevel {
    case formal
    case casual
    case intimate
    case professional
}

enum EncouragementStyle {
    case gentle
    case enthusiastic
    case practical
    case inspirational
    case validating
}

struct SharedMemory {
    let id: String
    let description: String
    let emotionalSignificance: Float
    let date: Date
    let category: MemoryCategory
}

enum MemoryCategory {
    case milestone
    case breakthrough
    case challenge
    case celebration
    case learningMoment
    case vulnerableShare
}

struct ConversationMemory {
    let date: Date
    let summary: String
    let emotionalHighlight: String
    let keyInsights: [String]
    let followUpNeeded: Bool
}

struct PersonalInsight {
    let insight: String
    let confidence: Float
    let category: InsightCategory
    let actionable: Bool
}

enum InsightCategory {
    case personalityTrait
    case copingMechanism
    case trigger
    case strength
    case preference
    case pattern
}
