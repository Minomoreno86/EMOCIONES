import Foundation
import SwiftUI

// MARK: - AI Supporting Types & Processors

// Import types from AIPersonalityEngine
// CommunicationTone, AIPersonalityState, AIUserRelationship, ConversationMemory

// MARK: - Communication Tone (duplicated to avoid circular dependency)
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

// MARK: - User Input & Context Models

struct UserInput {
    let text: String
    let timestamp: Date
    let inputType: InputType
    let emotionalContext: InputEmotionalContext?
    let metadata: InputMetadata
}

enum InputType {
    case text
    case voice
    case emoji
    case selection
    case gesture
}

struct InputEmotionalContext {
    let detectedEmotion: Emotion
    let confidence: Float
    let intensity: Float
}

struct InputMetadata {
    let sessionId: String
    let deviceInfo: DeviceInfo
    let environmentalFactors: EnvironmentalFactors
}

struct DeviceInfo {
    let platform: String
    let appVersion: String
    let batteryLevel: Float?
}

struct EnvironmentalFactors {
    let timeOfDay: TimeOfDay
    let location: LocationContext?
    let noise: NoiseLevel
}

enum TimeOfDay {
    case earlyMorning    // 5-8am
    case morning         // 8-12pm
    case afternoon       // 12-5pm
    case evening         // 5-8pm
    case night           // 8pm-12am
    case lateNight       // 12-5am
}

enum LocationContext {
    case home
    case work
    case medical
    case travel
    case unknown
}

enum NoiseLevel {
    case quiet
    case normal
    case noisy
    case veryNoisy
}

// MARK: - User Context

struct UserContext {
    let userId: String
    let timeOfDay: TimeOfDay
    let fertilityPhase: FertilityPhase
    let treatmentDay: Int?
    let partnerPresent: Bool
    let emotionalBaseline: EmotionalBaseline
    let recentEvents: [RecentEvent]
    let currentGoals: [UserGoal]
    let sessionContext: SessionContext
}

enum FertilityPhase {
    case trying
    case treatment
    case twoWeekWait
    case pregnant
    case postLoss
    case breakPeriod
    case exploring
}

struct EmotionalBaseline {
    let mood: Float        // -1 to 1
    let energy: Float      // 0 to 1
    let stress: Float      // 0 to 1
    let hopefulness: Float // 0 to 1
}

struct RecentEvent {
    let type: EventType
    let impact: EmotionalImpact
    let timestamp: Date
    let description: String
}

enum EventType {
    case medical
    case emotional
    case relational
    case external
    case milestone
}

enum EmotionalImpact {
    case veryPositive
    case positive
    case neutral
    case negative
    case veryNegative
}

struct UserGoal {
    let id: String
    let description: String
    let category: GoalCategory
    let priority: GoalPriority
    let progress: Float // 0 to 1
}

enum GoalCategory {
    case emotional
    case physical
    case relational
    case medical
    case personal
}

enum GoalPriority {
    case low
    case medium
    case high
    case urgent
}

struct SessionContext {
    let sessionId: String
    let startTime: Date
    let sessionType: SessionType
    let userInitiated: Bool
    let previousSessions: [SessionSummary]
}

enum SessionType {
    case checkin
    case crisis
    case celebration
    case support
    case education
    case planning
}

struct SessionSummary {
    let date: Date
    let type: SessionType
    let outcome: SessionOutcome
    let keyInsights: [String]
}

enum SessionOutcome {
    case positive
    case neutral
    case concerning
    case crisis
}

// MARK: - Emotional Processing

struct EmotionalState {
    let primaryEmotion: Emotion
    let secondaryEmotions: [Emotion]
    let intensityLevel: Float // 0 to 1
    let stability: EmotionalStability
    let triggers: [EmotionalTrigger]
    let timeline: EmotionalTimeline
}

enum Emotion {
    case joy, happiness, contentment, excitement, hope
    case sadness, grief, disappointment, despair
    case anxiety, fear, worry, panic, nervousness
    case anger, frustration, irritation, rage
    case love, affection, tenderness, compassion
    case shame, guilt, embarrassment
    case surprise, curiosity, wonder
    case acceptance, peace, calm
    case confusion, overwhelm, uncertainty
    case determination, courage, strength
    case loneliness, isolation, disconnect
    case gratitude, appreciation, thankfulness
}

enum EmotionalStability {
    case veryStable
    case stable
    case fluctuating
    case unstable
    case volatile
}

struct EmotionalTrigger {
    let trigger: String
    let severity: TriggerSeverity
    let category: TriggerCategory
}

enum TriggerSeverity {
    case mild
    case moderate
    case severe
    case crisis
}

enum TriggerCategory {
    case medical
    case social
    case environmental
    case cognitive
    case physical
}

enum EmotionalTimeline {
    case immediate      // Feeling this right now
    case recent         // Past few hours
    case today          // Today
    case ongoing        // Persistent feeling
    case cyclical       // Comes and goes
}

// MARK: - AI Response

struct AIResponse {
    let text: String
    let emotionalTone: CommunicationTone
    let personalizedElements: [AIPersonalizedElement]
    let actionSuggestions: [ActionSuggestion]
    let followUpQuestions: [FollowUpQuestion]
    let supportResources: [SupportResource]
    let conversationContinuation: ConversationContinuation
}

struct AIPersonalizedElement {
    let type: PersonalizationElementType
    let content: String
    let reasoning: String
}

enum PersonalizationElementType {
    case nameUsage
    case culturalReference
    case personalMemory
    case sharedExperience
    case preferredLanguage
    case emotionalMirroring
}

struct ActionSuggestion {
    let id: String
    let title: String
    let description: String
    let category: ActionCategory
    let difficulty: ActionDifficulty
    let estimatedTime: TimeInterval
    let personalizedReason: String
}

enum ActionCategory {
    case immediate      // Do right now
    case today          // Do today
    case ongoing        // Continuous practice
    case professional   // Seek professional help
    case social         // Connect with others
}

enum ActionDifficulty {
    case veryEasy       // 1-2 minutes
    case easy           // 5-10 minutes
    case moderate       // 15-30 minutes
    case challenging    // 30+ minutes
}

struct FollowUpQuestion {
    let question: String
    let purpose: QuestionPurpose
    let timing: QuestionTiming
}

enum QuestionPurpose {
    case clarification
    case deepening
    case support
    case assessment
    case relationship
}

enum QuestionTiming {
    case immediate
    case endOfSession
    case nextSession
    case whenReady
}

struct SupportResource {
    let title: String
    let description: String
    let type: ResourceType
    let urgency: ResourceUrgency
    let accessMethod: AccessMethod
}

enum ResourceType {
    case article
    case video
    case meditation
    case exercise
    case community
    case professional
    case emergency
}

enum ResourceUrgency {
    case immediate
    case high
    case medium
    case low
}

enum AccessMethod {
    case inApp
    case external
    case contactRequired
}

enum ConversationContinuation {
    case natural        // Continue naturally
    case structured     // Follow specific path
    case checkIn        // Schedule check-in
    case crisis         // Crisis intervention needed
    case celebrate      // Celebration mode
    case conclude       // Natural conclusion
}

// MARK: - AI Processors (Mock implementations for now)

class EmotionalProcessor {
    func analyzeEmotionalState(
        input: UserInput,
        context: UserContext,
        history: [ConversationMemory]
    ) async -> EmotionalState {
        // Mock implementation - en producción usaría ML/NLP
        return EmotionalState(
            primaryEmotion: .anxiety,
            secondaryEmotions: [.hope, .frustration],
            intensityLevel: 0.6,
            stability: .fluctuating,
            triggers: [],
            timeline: .immediate
        )
    }
}

class ContextAnalyzer {
    func analyzeContext(_ context: UserContext) -> ContextInsights {
        return ContextInsights(
            significantFactors: [],
            recommendations: [],
            riskAssessment: .low
        )
    }
}

struct ContextInsights {
    let significantFactors: [String]
    let recommendations: [String]
    let riskAssessment: RiskLevel
}

enum RiskLevel {
    case low
    case medium
    case high
    case crisis
}

class EmpathicResponseGenerator {
    func generateEmpathicResponse(
        userInput: UserInput,
        emotionalState: EmotionalState,
        personality: AIPersonalityState,
        relationship: AIUserRelationship
    ) async -> AIResponse {
        // Mock implementation - en producción usaría GPT/Claude API
        return AIResponse(
            text: generatePersonalizedText(for: emotionalState, relationship: relationship),
            emotionalTone: personality.communicationTone,
            personalizedElements: [],
            actionSuggestions: [],
            followUpQuestions: [],
            supportResources: [],
            conversationContinuation: .natural
        )
    }
    
    private func generatePersonalizedText(
        for emotionalState: EmotionalState,
        relationship: AIUserRelationship
    ) -> String {
        // Mock personalizado basado en la relación y estado emocional
        switch (emotionalState.primaryEmotion, relationship.relationshipDepth) {
        case (.anxiety, .trusted):
            return "Siento que estás pasando por un momento difícil. Hemos hablado antes sobre cómo la ansiedad puede ser abrumadora, especialmente en tu journey de fertilidad. ¿Quieres que practiquemos esa técnica de respiración que te ayudó la semana pasada?"
        case (.anxiety, .familiar):
            return "Noto algo de ansiedad en tu mensaje. Es completamente normal sentirse así durante este proceso. ¿Te gustaría que hablemos sobre lo que está en tu mente ahora mismo?"
        case (.hope, .trusted):
            return "¡Puedo sentir la esperanza en tus palabras! Me alegra mucho ver cómo has crecido emocionalmente desde que empezamos a hablar. ¿Qué te está ayudando a mantener esa perspectiva positiva?"
        default:
            return "Gracias por compartir conmigo. ¿Cómo te sientes en este momento?"
        }
    }
}

// MARK: - Temporary Type Definitions (to avoid circular dependencies)

struct ConversationMemory {
    let date: Date
    let summary: String
    let emotionalHighlight: String
    let keyInsights: [String]
    let followUpNeeded: Bool
}

struct AIPersonalityState {
    var communicationTone: CommunicationTone
    var energyLevel: Float
    var conversationalFocus: String
    var directivenessLevel: String
    var empathyIntensity: Float
    var personalizedElements: [String]
}

struct AIUserRelationship {
    var relationshipDepth: RelationshipDepth
    var trustLevel: Float
    var communicationPreferences: String
    var conversationHistory: [ConversationMemory]
}

enum RelationshipDepth {
    case stranger
    case acquaintance
    case familiar
    case trusted
    case intimate
}
