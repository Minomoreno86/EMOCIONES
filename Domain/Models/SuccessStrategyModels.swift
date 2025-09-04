import Foundation

// MARK: - Master Success Strategy Framework

/// Plan estratégico maestro para dominar el mercado de apps de fertilidad
struct MasterSuccessStrategy {
    let corePhilosophy: CorePhilosophy
    let userAcquisition: AcquisitionStrategy
    let productStrategy: ProductStrategy
    let monetizationStrategy: MonetizationStrategy
    let competitiveAdvantage: CompetitiveAdvantage
    let scaleStrategy: ScaleStrategy
}

// MARK: - Filosofía Central (Lo que nos diferencia)

struct CorePhilosophy {
    let mission: String = "Ser el compañero emocional más inteligente y empático para el journey de fertilidad"
    let visionStatement: String = "Un mundo donde nadie enfrente la fertilidad sola"
    let coreValues: [CoreValue]
    let uniqueValueProposition: UniqueValueProposition
}

struct CoreValue {
    let name: String
    let description: String
    let implementation: String
}

struct UniqueValueProposition {
    let primary: String = "La única app que combina IA emocional + comunidad real + gamificación positiva"
    let differentiators: [Differentiator]
    let emotionalBenefits: [EmotionalBenefit]
    let functionalBenefits: [FunctionalBenefit]
}

struct Differentiator {
    let feature: String
    let competitorComparison: String
    let userImpact: String
    let marketGap: String
}

struct EmotionalBenefit {
    let emotion: String
    let description: String
    let triggerMoments: [String]
}

struct FunctionalBenefit {
    let function: String
    let timesSaved: String
    let efficiencyGain: String
    let outcomeImprovement: String
}

// MARK: - Estrategia de Adquisición de Usuarios

struct AcquisitionStrategy {
    let targetAudiences: [TargetAudience]
    let channels: [AcquisitionChannel]
    let contentStrategy: ContentStrategy
    let influencerStrategy: InfluencerStrategy
    let partnershipStrategy: PartnershipStrategy
}

struct TargetAudience {
    let name: String
    let demographics: Demographics
    let psychographics: Psychographics
    let painPoints: [String]
    let motivations: [String]
    let preferredChannels: [String]
    let messagingStrategy: MessagingStrategy
}

struct Demographics {
    let ageRange: ClosedRange<Int>
    let income: IncomeRange
    let education: EducationLevel
    let location: [String]
    let relationshipStatus: [RelationshipStatus]
}

enum IncomeRange {
    case low
    case middle
    case high
    case premium
}

enum EducationLevel {
    case highSchool
    case college
    case graduate
    case professional
}

enum RelationshipStatus {
    case single
    case partnered
    case married
    case divorced
}

struct Psychographics {
    let values: [String]
    let interests: [String]
    let lifestyle: [String]
    let techSavviness: TechLevel
    let communicationStyle: String
}

enum TechLevel {
    case beginner
    case intermediate
    case advanced
    case expert
}

struct MessagingStrategy {
    let primaryMessage: String
    let tonality: String
    let keywords: [String]
    let emotionalTriggers: [String]
    let callsToAction: [String]
}

/// Canales de adquisición optimizados para fertilidad
enum AcquisitionChannel {
    case organicSocial(platform: SocialPlatform, strategy: SocialStrategy)
    case paidSocial(platform: SocialPlatform, targeting: TargetingStrategy)
    case contentMarketing(type: ContentType, distribution: DistributionStrategy)
    case influencerPartnership(tier: InfluencerTier, type: PartnershipType)
    case medicalPartnership(type: MedicalPartnerType)
    case appStoreOptimization(strategy: ASOStrategy)
    case referral(mechanism: ReferralMechanism)
    case pr(type: PRType)
}

enum SocialPlatform {
    case instagram
    case tiktok
    case facebook
    case youtube
    case pinterest
    case reddit
    case clubhouse
}

struct SocialStrategy {
    let contentPillars: [ContentPillar]
    let postingSchedule: PostingSchedule
    let engagementStrategy: EngagementStrategy
    let communityBuilding: CommunityBuildingStrategy
}

struct ContentPillar {
    let theme: String
    let percentage: Float // % del contenido total
    let purpose: ContentPurpose
    let examples: [String]
}

enum ContentPurpose {
    case educate
    case inspire
    case entertain
    case convert
    case retain
    case advocate
}

// MARK: - Estrategia de Producto

struct ProductStrategy {
    let developmentPhases: [DevelopmentPhase]
    let featurePrioritization: FeaturePrioritization
    let userExperienceStrategy: UXStrategy
    let dataStrategy: DataStrategy
    let qualityAssurance: QualityStrategy
}

struct DevelopmentPhase {
    let name: String
    let duration: TimeInterval
    let objectives: [String]
    let features: [FeatureDevelopment]
    let successMetrics: [SuccessMetric]
    let resources: ResourceRequirement
}

struct FeatureDevelopment {
    let name: String
    let priority: FeaturePriority
    let effort: DevelopmentEffort
    let impact: BusinessImpact
    let dependencies: [String]
    let timeline: TimeInterval
}

enum FeaturePriority {
    case critical    // Must have para MVP
    case high        // Importante para diferenciación
    case medium      // Nice to have
    case low         // Future consideration
}

enum DevelopmentEffort {
    case minimal     // 1-3 días
    case small       // 1-2 semanas
    case medium      // 1-2 meses
    case large       // 3-6 meses
    case epic        // 6+ meses
}

enum BusinessImpact {
    case userAcquisition    // Atrae nuevos usuarios
    case userRetention      // Mantiene usuarios existentes
    case userEngagement     // Aumenta uso diario
    case monetization       // Genera ingresos
    case viralGrowth       // Aumenta compartir
    case brandDifferentiation // Nos diferencia
}

// MARK: - Estrategia de Monetización

struct MonetizationStrategy {
    let revenueStreams: [RevenueStream]
    let pricingStrategy: PricingStrategy
    let freemiumModel: FreemiumModel
    let premiumFeatures: [PremiumFeature]
    let partnershipRevenue: PartnershipRevenue
}

enum RevenueStream {
    case subscription(tier: SubscriptionTier)
    case onePurchase(type: PurchaseType)
    case marketplace(commission: Float)
    case partnership(type: PartnershipRevenueType)
    case advertising(type: AdType)
    case consultation(type: ConsultationType)
}

struct SubscriptionTier {
    let name: String
    let price: MonetaryValue
    let billingCycle: BillingCycle
    let features: [String]
    let limitations: [String]
    let targetUser: String
}

struct MonetaryValue {
    let amount: Float
    let currency: String
    let region: String
}

enum BillingCycle {
    case monthly
    case quarterly
    case semiAnnual
    case annual
    case lifetime
}

// MARK: - Estrategia de Escala

struct ScaleStrategy {
    let internationalExpansion: InternationalStrategy
    let teamGrowth: TeamGrowthStrategy
    let technologyScaling: TechScalingStrategy
    let operationalScaling: OperationalStrategy
    let fundingStrategy: FundingStrategy
}

struct InternationalStrategy {
    let priorityMarkets: [InternationalMarket]
    let localizationStrategy: LocalizationStrategy
    let regulatoryConsiderations: [RegulatoryRequirement]
    let culturalAdaptations: [CulturalAdaptation]
}

struct InternationalMarket {
    let country: String
    let marketSize: Float
    let competitionLevel: CompetitionLevel
    let regulatoryComplexity: ComplexityLevel
    let culturalDistance: Float // 0-1
    let entryStrategy: MarketEntryStrategy
}

enum CompetitionLevel {
    case low
    case medium
    case high
    case saturated
}

enum ComplexityLevel {
    case simple
    case moderate
    case complex
    case veryComplex
}

enum MarketEntryStrategy {
    case organicGrowth
    case paidAcquisition
    case partnership
    case acquisition
    case franchise
}
