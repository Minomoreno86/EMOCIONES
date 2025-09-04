import Foundation

// MARK: - Gamification Models para crear adicción positiva

/// Sistema de logros que crea dopamina y engagement
struct Achievement {
    let id: String
    let title: String
    let description: String
    let icon: String
    let points: Int
    let rarity: AchievementRarity
    let unlockedDate: Date?
    let progress: Float // 0.0 - 1.0
    let category: AchievementCategory
}

enum AchievementRarity {
    case common      // 🥉 Bronze - fácil de conseguir
    case rare        // 🥈 Silver - moderado
    case epic        // 🥇 Gold - difícil
    case legendary   // 💎 Diamond - muy raro
    case mythic      // 👑 Crown - extremadamente raro
}

enum AchievementCategory {
    case dailyStreak     // "7 días seguidos"
    case emotional       // "Compartiste 50 emociones"
    case mindfulness     // "100 minutos de meditación"
    case community       // "Ayudaste a 10 personas"
    case milestone       // "6 meses en el journey"
    case special         // Eventos especiales
}

/// Sistema de rachas (streaks) - el elemento más adictivo
struct Streak {
    let id: String
    let type: StreakType
    let currentCount: Int
    let bestCount: Int
    let lastUpdated: Date
    let isActive: Bool
    let nextMilestone: Int
}

enum StreakType {
    case dailyCheckin    // Check-in diario
    case moodTracking    // Registrar estado de ánimo
    case meditation      // Sesiones de mindfulness
    case journaling      // Escribir en diario
    case community       // Participar en comunidad
}

/// Sistema de niveles y experiencia
struct UserLevel {
    let currentLevel: Int
    let currentXP: Int
    let xpToNextLevel: Int
    let totalXP: Int
    let levelName: String
    let perks: [LevelPerk]
}

struct LevelPerk {
    let id: String
    let name: String
    let description: String
    let icon: String
    let isUnlocked: Bool
}

/// Challenges que mantienen engagement
struct Challenge {
    let id: String
    let title: String
    let description: String
    let duration: TimeInterval // en segundos
    let startDate: Date
    let endDate: Date
    let participants: Int
    let reward: ChallengeReward
    let progress: Float
    let isCompleted: Bool
    let difficulty: ChallengeDifficulty
}

enum ChallengeDifficulty {
    case beginner    // 3 días
    case intermediate // 1 semana
    case advanced    // 1 mes
    case expert      // 3 meses
}

struct ChallengeReward {
    let xp: Int
    let achievement: Achievement?
    let specialContent: String?
    let badgeIcon: String
}

// MARK: - Notificación Inteligente Models

/// Sistema de notificaciones que NO molestan pero SÍ enganchan
struct SmartNotification {
    let id: String
    let type: NotificationType
    let title: String
    let body: String
    let scheduledTime: Date
    let personalizationScore: Float // Qué tan relevante es para este usuario
    let emotionalTone: EmotionalTone
    let actionRequired: Bool
}

enum NotificationType {
    case gentleReminder      // "¿Cómo te sientes hoy? 💙"
    case achievement         // "¡Desbloqueaste algo nuevo! 🎉"
    case streak              // "Tu racha de 7 días está en riesgo 🔥"
    case community           // "Alguien necesita tu apoyo 🤝"
    case insights            // "Descubrimos algo sobre tu bienestar 📊"
    case encouragement       // "Has progresado mucho esta semana 💪"
    case curiosity           // "¿Sabías que...? 🤔"
}

enum EmotionalTone {
    case encouraging
    case curious
    case supportive
    case celebratory
    case gentle
    case motivational
}
