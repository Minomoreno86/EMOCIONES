import Foundation

// MARK: - Retention & Engagement Strategy Models

/// Motor de retención que predice y previene el abandono
struct RetentionEngine {
    let userId: String
    let riskLevel: ChurnRiskLevel
    let engagementMetrics: EngagementMetrics
    let interventionStrategies: [RetentionIntervention]
    let successPredictors: [SuccessPredictor]
}

enum ChurnRiskLevel {
    case low         // Usuario comprometido
    case medium      // Muestra señales de desinterés
    case high        // En riesgo de abandonar
    case critical    // Probablemente abandonará pronto
}

struct EngagementMetrics {
    let dailyActiveScore: Float
    let weeklyRetentionRate: Float
    let featureAdoptionRate: Float
    let socialEngagement: Float
    let contentConsumption: Float
    let progressMomentum: Float
}

/// Intervenciones inteligentes para reconectar usuarios
enum RetentionIntervention {
    case personalizedContent    // Contenido ultra-personalizado
    case communityInvitation   // Invitación a unirse a grupo
    case achievementCelebration // Recordar logros pasados
    case buddyMatch           // Emparejar con alguien compatible
    case expertSession        // Sesión gratuita con profesional
    case gamificationBoost    // Desafío especial o recompensa
    case temporaryFeature     // Acceso a función premium
    case emotionalCheck       // Check-in empático de IA
}

struct SuccessPredictor {
    let factor: String
    let impact: Float // -1 to 1
    let confidence: Float // 0 to 1
    let actionable: Bool
}

// MARK: - Habit Formation Psychology

/// Sistema basado en la ciencia de formación de hábitos
struct HabitFormationEngine {
    let targetHabits: [TargetHabit]
    let currentHabits: [UserHabit]
    let formationStrategy: HabitStrategy
    let progressTracking: HabitProgress
}

struct TargetHabit {
    let id: String
    let name: String
    let description: String
    let frequency: HabitFrequency
    let difficulty: HabitDifficulty
    let estimatedFormationTime: TimeInterval // días para formar el hábito
    let cueStrategy: CueStrategy
    let rewardStrategy: RewardStrategy
}

enum HabitFrequency {
    case daily
    case weekdays
    case threeTimesWeek
    case weekly
    case custom(Int) // veces por semana
}

enum HabitDifficulty {
    case micro       // 2 minutos - "Open the app"
    case easy        // 5 minutos - "Quick mood check"
    case moderate    // 15 minutos - "Daily meditation"
    case challenging // 30 minutos - "Deep journal session"
}

/// Estrategias de señales (cues) para desencadenar hábitos
struct CueStrategy {
    let type: CueType
    let timing: CueTiming
    let environmental: [EnvironmentalCue]
    let personalizedTriggers: [PersonalizedTrigger]
}

enum CueType {
    case timeBasedReminder    // A las 8am todos los días
    case locationBased       // Cuando llegue a casa
    case emotionTriggered    // Cuando se sienta estresada
    case activityLinked      // Después de desayunar
    case socialCue          // Cuando su buddy hace check-in
}

struct EnvironmentalCue {
    let description: String
    let setupInstructions: String
    let effectivenessScore: Float
}

struct PersonalizedTrigger {
    let trigger: String
    let personalizedMessage: String
    let effectiveness: Float
}

/// Sistema de recompensas variable (como slot machines)
struct RewardStrategy {
    let rewardSchedule: RewardSchedule
    let rewardTypes: [RewardType]
    let surpriseElements: [SurpriseReward]
    let socialRecognition: SocialReward
}

enum RewardSchedule {
    case immediate        // Siempre después de la acción
    case variable         // Aleatoriamente (más adictivo)
    case milestone        // Solo en logros importantes
    case progressive      // Recompensas crecientes
    case social          // Basado en comunidad
}

enum RewardType {
    case points(Int)
    case badge(String)
    case content(String)     // Unlock de contenido especial
    case social(String)      // Reconocimiento público
    case functional(String)  // Función nueva desbloqueada
    case surprise           // Recompensa inesperada
}

struct SurpriseReward {
    let type: SurpriseType
    let rarity: Float // 0-1
    let emotionalImpact: EmotionalImpact
    let description: String
}

enum SurpriseType {
    case personalizedMessage  // Mensaje especial del AI
    case unlockFeature       // Función premium temporal
    case expertContent       // Contenido exclusivo
    case communityRecognition // Reconocimiento especial
    case realWorldBenefit    // Descuento en servicios reales
}

enum EmotionalImpact {
    case delight    // 😍 "¡No puedo creer que pasó esto!"
    case pride      // 😤 "Me lo merecía"
    case gratitude  // 🙏 "Qué considerados"
    case surprise   // 😮 "¡Wow, inesperado!"
    case connection // 🤗 "Se preocupan por mí"
}

// MARK: - Momentum Psychology

/// Sistema que mantiene el momentum emocional y de progreso
struct MomentumEngine {
    let currentMomentum: MomentumLevel
    let momentumBuilders: [MomentumBuilder]
    let momentumProtectors: [MomentumProtector]
    let recoveryStrategies: [MomentumRecovery]
}

enum MomentumLevel {
    case stalled      // Usuario no progresa
    case building     // Empezando a crear momentum
    case flowing      // En buen ritmo
    case accelerating // Progreso rápido
    case peak         // En su mejor momento
}

/// Estrategias para construir momentum
enum MomentumBuilder {
    case quickWins           // Logros fáciles y rápidos
    case progressVisualization // Mostrar progreso claramente
    case streakGamification   // Sistema de rachas
    case socialMomentum      // Progreso grupal
    case personalBests       // Superar records personales
    case trendCelebration    // Celebrar tendencias positivas
}

/// Protecciones contra pérdida de momentum
enum MomentumProtector {
    case gracePeriod         // Días de gracia sin perder rachas
    case flexibleGoals       // Metas adaptables
    case encouragementBoosts // Mensajes motivacionales
    case communitySupport    // Apoyo de la comunidad
    case aiCoaching         // Coaching personalizado de IA
    case progressPreservation // Guardar progreso parcial
}

/// Estrategias de recuperación cuando se pierde momentum
enum MomentumRecovery {
    case gentleRestart       // Volver a empezar suavemente
    case motivationalInterview // Redescubrir motivaciones
    case goalReassessment    // Reevaluar objetivos
    case supportMobilization // Activar red de apoyo
    case successReminder     // Recordar éxitos pasados
    case freshStart         // Nuevo comienzo completo
}

// MARK: - Viral Growth Mechanisms

/// Sistema de crecimiento viral diseñado para compartir naturalmente
struct ViralGrowthEngine {
    let sharingTriggers: [SharingTrigger]
    let referralProgram: ReferralProgram
    let contentViralPotential: ContentViralityScore
    let socialProof: SocialProofMechanisms
}

enum SharingTrigger {
    case achievement         // "¡Completé 30 días!"
    case breakthrough        // "¡Tuve un gran avance!"
    case gratitude          // "Esta app me salvó"
    case milestone          // "6 meses en mi journey"
    case support            // "¿Alguien más pasa por esto?"
    case recommendation     // "Esto me está ayudando mucho"
    case celebration        // Buenas noticias para compartir
}

struct ReferralProgram {
    let incentiveStructure: IncentiveStructure
    let personalizedInvitations: [PersonalizedInvitation]
    let trackingMechanism: ReferralTracking
    let successMetrics: ReferralMetrics
}

struct IncentiveStructure {
    let referrerReward: Reward
    let refereeReward: Reward
    let mutualBenefits: [MutualBenefit]
    let tieredRewards: [TieredReward] // Más referencias = mejores recompensas
}

struct Reward {
    let type: RewardType
    let value: String
    let description: String
    let timeLimit: TimeInterval?
}

struct PersonalizedInvitation {
    let message: String
    let context: InvitationContext
    let channels: [InvitationChannel]
    let timing: OptimalTiming
}

enum InvitationContext {
    case successMoment      // Cuando está teniendo éxito
    case needSupport        // Cuando necesita apoyo
    case anniversary        // En fechas especiales
    case achievement        // Después de logros
}

enum InvitationChannel {
    case inApp
    case email
    case sms
    case social
    case personal
}

// MARK: - Additional Supporting Types

struct UserHabit {
    let id: String
    let name: String
    let currentStreak: Int
    let established: Bool
    let strength: Float // 0-1
}

enum HabitStrategy {
    case incremental
    case immersive
    case social
    case gamified
}

struct HabitProgress {
    let completionRate: Float
    let consistency: Float
    let trajectory: ProgressTrend
}

enum ProgressTrend {
    case improving
    case stable
    case declining
}

enum CueTiming {
    case immediate
    case delayed
    case optimal
    case userPreferred
}

struct SocialReward {
    let visibility: String
    let recognition: String
    let impact: Float
}

struct ContentViralityScore {
    let shareability: Float
    let emotionalResonance: Float
    let timingOptimal: Bool
}

struct SocialProofMechanisms {
    let testimonials: [String]
    let userCounts: [String: Int]
    let successStories: [String]
}

struct ReferralTracking {
    let conversionRate: Float
    let sourceAnalytics: [String: Int]
    let timeToConvert: TimeInterval
}

struct ReferralMetrics {
    let totalReferrals: Int
    let successfulConversions: Int
    let retentionRate: Float
}

struct MutualBenefit {
    let name: String
    let description: String
    let value: String
}

struct TieredReward {
    let tier: Int
    let requirement: Int
    let rewards: [Reward]
}

struct OptimalTiming {
    let dayOfWeek: Int
    let hourOfDay: Int
    let userContext: String
}
