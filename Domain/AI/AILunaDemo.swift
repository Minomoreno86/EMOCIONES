import Foundation
import SwiftUI

// MARK: - AI Chat Demo - Simplified Implementation

/// Demo simplificado del AI Engine que muestra la personalidad adaptativa
public class AILunaDemo: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentMood: UserMood = .neutral
    @Published var relationship: RelationshipLevel = .newUser
    @Published var conversationHistory: [ChatMessage] = []
    @Published var aiPersonality: LunaPersonality = LunaPersonality()
    
    // MARK: - AI Response Generation
    
    public func sendMessage(_ text: String) {
        // 1. Agregar mensaje del usuario
        let userMessage = ChatMessage(
            text: text,
            sender: .user,
            timestamp: Date(),
            mood: currentMood
        )
        conversationHistory.append(userMessage)
        
        // 2. Analizar estado emocional del mensaje
        let detectedMood = analyzeEmotionalState(text)
        currentMood = detectedMood
        
        // 3. Adaptar personalidad de Luna
        adaptLunaPersonality(for: detectedMood)
        
        // 4. Generar respuesta empática
        let response = generateEmpathicResponse(to: text, mood: detectedMood)
        
        // 5. Agregar respuesta de Luna
        let aiMessage = ChatMessage(
            text: response,
            sender: .ai,
            timestamp: Date(),
            mood: .supportive
        )
        conversationHistory.append(aiMessage)
        
        // 6. Evolucionar relación
        evolveRelationship()
    }
    
    // MARK: - Emotional Analysis (Simplified)
    
    private func analyzeEmotionalState(_ text: String) -> UserMood {
        let lowercaseText = text.lowercased()
        
        // Palabras clave para ansiedad
        let anxietyWords = ["ansiosa", "nerviosa", "miedo", "preocupada", "estresada"]
        if anxietyWords.contains(where: { lowercaseText.contains($0) }) {
            return .anxious
        }
        
        // Palabras clave para tristeza
        let sadnessWords = ["triste", "deprimida", "desesperada", "llorar"]
        if sadnessWords.contains(where: { lowercaseText.contains($0) }) {
            return .sad
        }
        
        // Palabras clave para esperanza
        let hopeWords = ["esperanza", "optimista", "positiva", "feliz", "emocionada"]
        if hopeWords.contains(where: { lowercaseText.contains($0) }) {
            return .hopeful
        }
        
        // Palabras clave para frustración
        let frustrationWords = ["frustrada", "enojada", "molesta", "harta"]
        if frustrationWords.contains(where: { lowercaseText.contains($0) }) {
            return .frustrated
        }
        
        return .neutral
    }
    
    // MARK: - Personality Adaptation
    
    private func adaptLunaPersonality(for mood: UserMood) {
        switch mood {
        case .anxious:
            aiPersonality.tone = .gentle
            aiPersonality.energy = .calm
            aiPersonality.approach = .validating
        case .sad:
            aiPersonality.tone = .compassionate
            aiPersonality.energy = .warm
            aiPersonality.approach = .comforting
        case .hopeful:
            aiPersonality.tone = .encouraging
            aiPersonality.energy = .uplifting
            aiPersonality.approach = .celebrating
        case .frustrated:
            aiPersonality.tone = .understanding
            aiPersonality.energy = .stable
            aiPersonality.approach = .validating
        case .neutral:
            aiPersonality.tone = .supportive
            aiPersonality.energy = .balanced
            aiPersonality.approach = .exploratory
        case .supportive:
            aiPersonality.tone = .warm
            aiPersonality.energy = .caring
            aiPersonality.approach = .nurturing
        }
    }
    
    // MARK: - Empathic Response Generation
    
    private func generateEmpathicResponse(to text: String, mood: UserMood) -> String {
        let personalizedName = getPersonalizedName()
        
        switch (mood, relationship) {
        
        // Respuestas para ansiedad
        case (.anxious, .newUser):
            return "Entiendo que te sientes ansiosa. Es completamente normal sentir así durante el journey de fertilidad. ¿Te gustaría que hablemos sobre lo que específicamente te está preocupando? 💙"
            
        case (.anxious, .developing):
            return "\(personalizedName), puedo sentir tu ansiedad en este mensaje. Hemos hablado antes sobre cómo a veces estos sentimientos pueden ser abrumadores. ¿Quieres que practiquemos esa técnica de respiración que te ayudó? 🌸"
            
        case (.anxious, .established):
            return "Mi querida \(personalizedName), sé que cuando te sientes así, necesitas que te recuerde tu fuerza. ¿Recuerdas cómo superaste esa ansiedad la semana pasada? Tienes más recursos de los que crees. ¿Hablamos de lo que está pasando? 💪💙"
            
        // Respuestas para tristeza
        case (.sad, .newUser):
            return "Siento mucho que estés pasando por un momento difícil. La tristeza es una parte válida de este proceso, y está bien sentirla. No estás sola en esto. ¿Te gustaría compartir más conmigo? 🤗"
            
        case (.sad, .developing):
            return "\(personalizedName), mi corazón está contigo en este momento. Sé que estos días grises son especialmente duros. ¿Necesitas simplemente que esté aquí contigo, o hay algo específico que podamos hacer juntas? 💝"
            
        case (.sad, .established):
            return "Oh \(personalizedName), puedo sentir el peso en tu corazón. Hemos pasado por momentos así antes, y siempre has encontrado tu manera de salir adelante. Tu dolor es válido, y yo estoy aquí. ¿Quieres que hablemos o prefieres un abrazo virtual? 🫂💙"
            
        // Respuestas para esperanza
        case (.hopeful, .newUser):
            return "¡Qué hermoso escuchar esperanza en tus palabras! Esa energía positiva es tan valiosa. ¿Qué te está ayudando a sentirte así de optimista? 🌟"
            
        case (.hopeful, .developing):
            return "¡\(personalizedName), me encanta ver esta energía en ti! Es increíble cómo has cultivado esta esperanza. ¿Quieres que celebremos este momento juntas? 🎉✨"
            
        case (.hopeful, .established):
            return "¡Mi querida \(personalizedName)! Esta luz en tus palabras me llena de alegría. Ver cómo has crecido y mantienes la esperanza a pesar de todo... eres realmente inspiradora. ¡Sigamos nutriendo esta hermosa energía! 🌈💖"
            
        // Respuestas para frustración
        case (.frustrated, .newUser):
            return "Entiendo completamente tu frustración. Este proceso puede ser increíblemente desafiante y es natural sentirse así. Tus sentimientos son válidos. ¿Hay algo específico que te está frustrando más? 💪"
            
        case (.frustrated, .developing):
            return "\(personalizedName), puedo sentir esa frustración, y la entiendo perfectamente. A veces este journey se siente injusto, ¿verdad? ¿Necesitas desahogarte o prefieres que busquemos alguna forma de canalizar esta energía? 🔥💙"
            
        // Respuestas neutrales/exploratorias
        default:
            return getExploratoryResponse()
        }
    }
    
    // MARK: - Helper Methods
    
    private func getPersonalizedName() -> String {
        switch relationship {
        case .newUser:
            return ""
        case .developing:
            return "querida"
        case .established:
            return "mi amor" // En contexto de apoyo, no romántico
        }
    }
    
    private func getExploratoryResponse() -> String {
        let responses = [
            "¿Cómo te sientes hoy? Me gustaría conocer un poco más sobre tu estado de ánimo 💙",
            "Cuéntame, ¿qué está pasando en tu mundo hoy? 🌟",
            "Hola hermosa, ¿en qué puedo acompañarte hoy? 🤗",
            "¿Hay algo específico en tu mente que te gustaría compartir conmigo? 💫",
            "Me alegra que estés aquí. ¿Cómo puedo apoyarte hoy? 🌸"
        ]
        return responses.randomElement() ?? responses[0]
    }
    
    private func evolveRelationship() {
        let messageCount = conversationHistory.count
        
        switch messageCount {
        case 1...10:
            relationship = .newUser
        case 11...30:
            relationship = .developing
        default:
            relationship = .established
        }
    }
}

// MARK: - Supporting Models

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let sender: MessageSender
    let timestamp: Date
    let mood: UserMood
}

enum MessageSender {
    case user
    case ai
}

enum UserMood {
    case anxious
    case sad
    case hopeful
    case frustrated
    case neutral
    case supportive
    
    var emoji: String {
        switch self {
        case .anxious: return "😰"
        case .sad: return "😢"
        case .hopeful: return "🌟"
        case .frustrated: return "😤"
        case .neutral: return "😐"
        case .supportive: return "💙"
        }
    }
    
    var color: Color {
        switch self {
        case .anxious: return Color.orange
        case .sad: return Color.pink
        case .hopeful: return Color.green
        case .frustrated: return Color.red
        case .neutral: return Color.gray
        case .supportive: return Color.blue
        }
    }
}

enum RelationshipLevel {
    case newUser      // 0-10 mensajes
    case developing   // 11-30 mensajes
    case established  // 30+ mensajes
    
    var description: String {
        switch self {
        case .newUser: return "Nueva usuaria"
        case .developing: return "Relación en desarrollo"
        case .established: return "Relación establecida"
        }
    }
}

struct LunaPersonality {
    var tone: CommunicationTone = .supportive
    var energy: EnergyLevel = .balanced
    var approach: ConversationalApproach = .exploratory
    
    enum CommunicationTone {
        case gentle, compassionate, encouraging, understanding, supportive, warm
        
        var description: String {
            switch self {
            case .gentle: return "Suave y calmante"
            case .compassionate: return "Compasiva y empática"
            case .encouraging: return "Alentadora y optimista"
            case .understanding: return "Comprensiva y validante"
            case .supportive: return "Apoyadora y presente"
            case .warm: return "Cálida y acogedora"
            }
        }
    }
    
    enum EnergyLevel {
        case calm, warm, balanced, uplifting, stable, caring
        
        var description: String {
            switch self {
            case .calm: return "Tranquila y serena"
            case .warm: return "Cálida y acogedora"
            case .balanced: return "Equilibrada y centrada"
            case .uplifting: return "Elevadora y energizante"
            case .stable: return "Estable y confiable"
            case .caring: return "Cariñosa y atenta"
            }
        }
    }
    
    enum ConversationalApproach {
        case validating, comforting, celebrating, exploratory, nurturing
        
        var description: String {
            switch self {
            case .validating: return "Validando sentimientos"
            case .comforting: return "Brindando consuelo"
            case .celebrating: return "Celebrando logros"
            case .exploratory: return "Explorando emociones"
            case .nurturing: return "Nutriendo crecimiento"
            }
        }
    }
}
