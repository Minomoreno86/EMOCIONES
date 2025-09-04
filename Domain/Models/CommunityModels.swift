import Foundation

// Note: CommunicationStyle is defined in PersonalizationModels.swift

// MARK: - Supporting Types

struct User {
    let id: String
    let username: String
    let isAnonymous: Bool
    let verificationStatus: UserVerification
}

enum UserVerification {
    case unverified
    case verified
    case professional
}

struct MeetingSchedule {
    let frequency: MeetingFrequency
    let dayOfWeek: Int
    let timeSlot: TimeSlot
    let duration: TimeInterval
}

enum MeetingFrequency {
    case weekly
    case biweekly
    case monthly
    case asNeeded
}

struct TimeSlot {
    let hour: Int
    let minute: Int
    let timezone: TimeZone
}

struct GroupDynamics {
    let cohesionScore: Float
    let participationBalance: Float
    let supportQuality: Float
    let conflictLevel: Float
}

enum MatchingAlgorithm {
    case similarity
    case complementary
    case situational
    case hybrid
}

enum PersonalityMatch {
    case introvert
    case extrovert
    case analytical
    case emotional
    case practical
    case creative
}

enum CommunicationStyle {
    case gentle
    case direct
    case encouraging
    case scientific
    case friend
}

struct TimeWindow {
    let startHour: Int
    let endHour: Int
    let days: [Weekday]
}

enum Weekday: Int, CaseIterable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
}

struct EmergencyContact {
    let name: String
    let relationship: String
    let phoneNumber: String
    let isAvailable24h: Bool
}

struct ProfessionalContact {
    let name: String
    let title: String
    let specialty: String
    let phoneNumber: String
    let availability: String
}

struct Comment {
    let id: String
    let author: User
    let content: String
    let timestamp: Date
    let replies: [Comment]
    let isHelpful: Bool
}

// MARK: - Community & Connection Models

/// Sistema de comunidad que crea conexiones reales y apoyo mutuo
struct CommunityHub {
    let id: String
    let name: String
    let description: String
    let memberCount: Int
    let type: CommunityType
    let moderators: [User]
    let supportGroups: [SupportGroup]
    let isPrivate: Bool
    let categories: [CommunityCategory]
}

enum CommunityType {
    case fertilityJourney    // Específico para fertilidad
    case mentalHealth        // Salud mental general
    case couples             // Para parejas
    case professionals       // Con profesionales verificados
    case peerSupport        // Solo personas con experiencias similares
    case anonymous          // Completamente anónimo
}

enum CommunityCategory {
    case shareExperience    // Compartir experiencias
    case askQuestions       // Hacer preguntas
    case celebration        // Celebrar logros
    case venting            // Desahogarse safely
    case resources          // Compartir recursos
    case dailyCheckin       // Check-ins diarios
}

/// Grupos de apoyo pequeños y íntimos (máximo 8 personas)
struct SupportGroup {
    let id: String
    let name: String
    let members: [GroupMember]
    let facilitator: User?
    let createdDate: Date
    let meetingSchedule: MeetingSchedule
    let focusArea: SupportFocus
    let isActive: Bool
    let groupDynamics: GroupDynamics
}

struct GroupMember {
    let user: User
    let joinDate: Date
    let participationLevel: ParticipationLevel
    let role: GroupRole
    let supportGiven: Int // Número de veces que ha ayudado
    let supportReceived: Int
}

enum ParticipationLevel {
    case observer     // Solo lee
    case occasional   // Participa de vez en cuando
    case regular      // Participa regularmente
    case active       // Muy activo
    case leader       // Lidera conversaciones
}

enum GroupRole {
    case member
    case supportBuddy    // Emparejado con alguien específico
    case facilitator
    case mentor         // Alguien más avanzado en el journey
}

enum SupportFocus {
    case earlyFertilityJourney
    case fertilityTreatments
    case pregnancy
    case loss
    case mentalHealthSupport
    case relationshipSupport
    case mixedSupport
}

/// Sistema de matching inteligente para emparejar personas compatibles
struct SupportMatching {
    let algorithm: MatchingAlgorithm
    let criteria: MatchingCriteria
    let compatibility: CompatibilityScore
}

struct MatchingCriteria {
    let ageRange: ClosedRange<Int>
    let location: LocationPreference
    let fertilitySituation: FertilitySituation
    let personalityType: PersonalityMatch
    let communicationStyle: CommunicationStyle
    let availabilityWindow: TimeWindow
    let languagePreference: [String]
}

enum LocationPreference {
    case sameCity
    case sameCountry
    case sameTimezone
    case anyLocation
}

enum FertilitySituation {
    case trying
    case undergoingTreatment
    case pregnant
    case newMom
    case experiencingLoss
    case longTermJourney
    case partner
}

struct CompatibilityScore {
    let overall: Float // 0-100
    let personalityMatch: Float
    let situationMatch: Float
    let communicationMatch: Float
    let goalAlignment: Float
    let timeZoneCompatibility: Float
}

// MARK: - Peer Support Features

/// Sistema de "Buddy" - emparejamiento uno-a-uno
struct SupportBuddy {
    let id: String
    let user1: User
    let user2: User
    let matchedDate: Date
    let connectionStrength: Float // 0-1
    let interactions: [BuddyInteraction]
    let status: BuddyStatus
    let checkInReminders: [Date]
}

enum BuddyStatus {
    case newMatch
    case developing
    case strong
    case needsSupport    // Uno de los dos está pasando por algo difícil
    case inactive
}

struct BuddyInteraction {
    let timestamp: Date
    let type: InteractionType
    let duration: TimeInterval
    let satisfactionScore: Float?
}

enum InteractionType {
    case textMessage
    case voiceCall
    case videoCall
    case sharedActivity    // Meditación juntas, etc.
    case checkIn
}

/// Sistema de apoyo en crisis
struct CrisisSupport {
    let id: String
    let triggerLevel: CrisisLevel
    let availableSupport: [CrisisSupportOption]
    let emergencyContacts: [EmergencyContact]
    let professionalBackup: [ProfessionalContact]
}

enum CrisisLevel {
    case mild           // Día difícil
    case moderate       // Necesita hablar con alguien
    case significant    // Crisis emocional
    case emergency      // Necesita intervención profesional
}

enum CrisisSupportOption {
    case peerSupport        // Comunidad disponible 24/7
    case aiChatbot         // Chat inmediato con IA
    case professionalChat   // Chat con profesional
    case hotline           // Línea de crisis
    case emergencyServices // Servicios de emergencia
}

// MARK: - Contenido Generado por la Comunidad

/// Historias y experiencias compartidas
struct CommunityStory {
    let id: String
    let author: User
    let title: String
    let content: String
    let category: StoryCategory
    let tags: [String]
    let reactions: [Reaction]
    let comments: [Comment]
    let isAnonymous: Bool
    let helpfulVotes: Int
    let createdDate: Date
}

enum StoryCategory {
    case success        // Historias de éxito
    case struggle       // Luchas y desafíos
    case tips           // Consejos útiles
    case loss           // Experiencias de pérdida
    case humor          // Momentos ligeros
    case medical        // Información médica (verificada)
    case relationship   // Dinámicas de pareja
}

struct Reaction {
    let type: ReactionType
    let count: Int
    let userReacted: Bool
}

enum ReactionType {
    case heart      // ❤️ Apoyo
    case hug        // 🤗 Abrazo virtual
    case strength   // 💪 Fuerza
    case gratitude  // 🙏 Gratitud
    case relate     // 👥 Me identifico
    case celebrate  // 🎉 Celebración
}

/// Q&A verificado por profesionales
struct VerifiedQA {
    let id: String
    let question: String
    let answer: String
    let expert: VerifiedExpert
    let category: MedicalCategory
    let upvotes: Int
    let isBookmarked: Bool
    let relatedQuestions: [String]
}

struct VerifiedExpert {
    let id: String
    let name: String
    let credentials: [String]
    let specialization: [String]
    let verificationBadge: ExpertBadge
}

enum ExpertBadge {
    case fertilitySpecialist
    case psychologist
    case nutritionist
    case reproductive_endocrinologist
    case counselor
    case nurse
}

enum MedicalCategory {
    case fertility_basics
    case treatments
    case nutrition
    case mental_health
    case relationships
    case pregnancy
    case loss_support
}
