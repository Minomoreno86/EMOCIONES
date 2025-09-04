import Foundation

// MARK: - Supporting Types

enum MeditationType {
    case breathwork
    case bodyscan
    case loving_kindness
    case visualization
    case mindfulness
    case movement
}

enum PrivacyLevel {
    case anonymous
    case privateMode
    case community
    case publicMode
}

enum ChallengePreference {
    case solo
    case smallGroup
    case community
    case competitive
}

struct PersonalTheme {
    let colorScheme: String
    let fontScale: Float
    let animationLevel: String
}

enum SessionFrequency {
    case multiple_daily
    case daily
    case several_weekly
    case weekly
    case occasional
}

struct EmotionalState {
    let mood: Float // -1 to 1
    let energy: Float // 0 to 1
    let stress: Float // 0 to 1
    let anxiety: Float // 0 to 1
}

struct MoodPoint {
    let timestamp: Date
    let mood: Float
    let energy: Float
    let notes: String?
}

struct StressPattern {
    let averageLevel: Float
    let peakTimes: [Int] // hours of day
    let triggerEvents: [String]
    let reliefMethods: [String]
}

struct ImprovementMetrics {
    let anxietyReduction: Float // %
    let moodStability: Float // %
    let sleepQuality: Float // %
    let stressManagement: Float // %
}

struct EngagementPattern {
    let averageSessionTime: TimeInterval
    let dropOffPoints: [String]
    let highEngagementFeatures: [String]
    let preferredTimeSlots: [TimeInterval]
}

enum ArticleCategory {
    case fertilityEducation
    case mentalHealth
    case relationships
    case selfCare
    case nutrition
}

enum ExerciseType {
    case breathing
    case stretching
    case walking
    case yoga
    case journaling
}

struct CommunityActivity {
    let type: String
    let participants: Int
    let duration: TimeInterval
}

// MARK: - AI Personalization Engine

/// Motor de personalización que aprende del usuario y se adapta
struct PersonalizationEngine {
    let userId: String
    let learningData: UserLearningData
    let preferences: PersonalizedPreferences
    let behaviorPatterns: BehaviorPatterns
    let contentRecommendations: [ContentRecommendation]
}

struct UserLearningData {
    // Patrones temporales
    let mostActiveHours: [Int] // Horas del día más activo
    let preferredSessionLength: TimeInterval
    let optimalNotificationTimes: [Date]
    
    // Preferencias de contenido
    let preferredMeditationTypes: [MeditationType]
    let responsiveEmotions: [String] // Emociones que más registra
    let triggerPatterns: [TriggerPattern] // Qué lo afecta
    
    // Efectividad
    let mostEffectiveTechniques: [String]
    let improvementMetrics: ImprovementMetrics
}

struct PersonalizedPreferences {
    let communicationStyle: CommunicationStyle
    let motivationStyle: MotivationStyle
    let privacyLevel: PrivacyLevel
    let challengePreference: ChallengePreference
    let visualTheme: PersonalTheme
}

enum CommunicationStyle {
    case gentle          // "Cuando te sientas lista..."
    case direct          // "Es hora de tu check-in diario"
    case encouraging     // "¡Vas increíble! Sigamos..."
    case scientific      // "Los datos muestran que..."
    case friend          // "¿Cómo andas hoy, amiga?"
}

enum MotivationStyle {
    case achievement     // Logros y niveles
    case connection      // Comunidad y apoyo
    case knowledge       // Aprender y entender
    case progress        // Ver mejora personal
    case routine         // Hábitos y consistencia
}

struct BehaviorPatterns {
    let usagePatterns: UsagePattern
    let emotionalPatterns: EmotionalPattern
    let engagementPatterns: EngagementPattern
    let dropOffRisk: Float // 0-1, riesgo de abandonar la app
}

struct UsagePattern {
    let dailyUsageMinutes: [Int] // Por día de la semana
    let sessionFrequency: SessionFrequency
    let featureMostUsed: [String: Int] // Feature: times used
    let timeSpentPerFeature: [String: TimeInterval]
}

struct EmotionalPattern {
    let emotionalBaseline: EmotionalState
    let moodFluctuationPattern: [MoodPoint]
    let stressPatterns: StressPattern
    let improvementAreas: [String]
    let strengthAreas: [String]
}

struct TriggerPattern {
    let trigger: String // "trabajo", "familia", "hormonas"
    let frequency: Int
    let intensity: Float // 1-10
    let timeOfDay: [Int]
    let effectiveResponses: [String]
}

// MARK: - Contenido Dinámico y Adaptativo

struct ContentRecommendation {
    let id: String
    let type: ContentType
    let title: String
    let description: String
    let estimatedTime: TimeInterval
    let personalizedReason: String // "Porque te ayuda con el estrés laboral"
    let confidenceScore: Float // Qué tan seguro está el AI
    let urgency: ContentUrgency
}

enum ContentType {
    case meditation(MeditationType)
    case article(ArticleCategory)
    case exercise(ExerciseType)
    case chatTopic(String)
    case community(CommunityActivity)
    case insight(InsightType)
}

enum ContentUrgency {
    case immediate    // "Te ayudará ahora mismo"
    case today        // "Perfecto para hoy"
    case thisWeek     // "Cuando tengas tiempo"
    case discovery    // "Algo nuevo para explorar"
}

// MARK: - Sistema de Insights Predictivos

struct PredictiveInsight {
    let id: String
    let type: InsightType
    let prediction: String
    let confidence: Float
    let timeframe: InsightTimeframe
    let actionable: Bool
    let personalizedMessage: String
}

enum InsightType {
    case moodPrediction      // "Mañana podrías sentirte más ansiosa"
    case cycleInsight        // "Tu energía sube los miércoles"
    case triggerAlert        // "El estrés laboral está aumentando"
    case opportunityWindow   // "Ahora es buen momento para meditar"
    case progressCelebration // "Has mejorado 40% en manejo de ansiedad"
}

enum InsightTimeframe {
    case realTime     // Ahora mismo
    case today        // Hoy
    case tomorrow     // Mañana
    case thisWeek     // Esta semana
    case longTerm     // Tendencia a largo plazo
}
