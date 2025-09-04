import Foundation
import SwiftData

// MARK: - EmotionResult Definition

public struct EmotionResult: Sendable, Codable {
    public let state: EmotionalState
    public let confidence: Double  // 0...1
    public let rationale: String
    
    public init(state: EmotionalState, confidence: Double, rationale: String) {
        self.state = state
        self.confidence = confidence
        self.rationale = rationale
    }
}

// MARK: - Advanced Emotion Analyzer with Negation and Confidence

public struct RegexEmotionAnalyzer: EmotionAnalyzing {
    // Palabras raíz sin diacríticos (límites de palabra)
    private let dict: [EmotionalState: [String]] = [
        .anxious:    ["preocup", "ansi", "mied", "nerv", "estres", "inquiet", "temor", "panic"],
        .sad:        ["trist", "dolor", "llor", "deprim", "desanim", "perdid", "melancol", "lament"],
        .hopeful:    ["esper", "optim", "positiv", "confianz", "fe", "mejor", "esperanz"],
        .excited:    ["emoc", "feliz", "alegr", "content", "genial", "fantast", "maravill", "increibl"],
        .frustrated: ["frustr", "rab", "ira", "enoj", "molest", "hart", "cansad", "agot"],
        .grateful:   ["agradec", "gracias", "apreci", "reconoc", "valor", "bendic", "afortunad"]
    ]

    // Negaciones simples (antes de la palabra clave, ventana de 3 palabras)
    private let negations = ["no", "nunca", "jamás", "ya no"]

    public init() {}

    public func detect(in text: String) -> EmotionResult {
        let normalized = text.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        let tokens = normalized
            .replacingOccurrences(of: "[^\\p{L}\\p{N}\\s]", with: " ", options: .regularExpression)
            .split(separator: " ")
            .map(String.init)

        // Scoring
        var scores: [EmotionalState: Int] = [:]
        var hits: [EmotionalState: [String]] = [:]

        for (emotion, roots) in dict {
            var localHits: [String] = []
            var score = 0
            for (idx, tok) in tokens.enumerated() {
                guard roots.contains(where: { tok.hasPrefix($0) }) else { continue }
                // Negation window: up to 3 tokens back
                let neg = (max(0, idx-3)...max(0, idx-1)).contains { i in
                    negations.contains(tokens[i])
                }
                if neg {
                    score -= 1
                    localHits.append("¬" + tok)
                } else {
                    score += 2
                    localHits.append(tok)
                }
            }
            if score != 0 {
                scores[emotion] = score
                hits[emotion] = localHits
            }
        }

        // Empate → priorizar emociones negativas (anxious, sad, frustrated), luego grateful, excited, hopeful; neutral por defecto
        let priority: [EmotionalState] = [.anxious, .sad, .frustrated, .grateful, .excited, .hopeful]

        let best = scores.max { a, b in
            if a.value == b.value {
                return priority.firstIndex(of: a.key)! > priority.firstIndex(of: b.key)!
            }
            return a.value < b.value
        }

        if let (state, raw) = best {
            let maxPossible = 12 // heurístico: 6 tokens * 2
            let conf = min(1.0, max(0.1, Double(raw) / Double(maxPossible)))
            let why = (hits[state] ?? []).joined(separator: ", ")
            return EmotionResult(state: state, confidence: conf, rationale: "coincidencias: \(why); score=\(raw)")
        } else {
            return EmotionResult(state: .neutral, confidence: 0.2, rationale: "sin coincidencias fuertes")
        }
    }
}

// MARK: - Safety Filter

public struct SimpleSafetyFilter: SafetyFiltering {
    // Tono educativo, evitar imperativos médicos/diagnósticos
    private let risky = [
        "debes ", "tienes que ", "diagnóstico", "ajusta dosis", "receta", "medicación"
    ]
    
    public init() {}
    
    public func filter(_ candidate: String) -> String {
        var s = candidate
        for r in risky { 
            s = s.replacingOccurrences(of: r, with: "podrías considerar ", options: .caseInsensitive) 
        }
        // Disclaimer removido - ahora se muestra en la UI fija
        return s
    }
}

// MARK: - Conversation Summarizer

public protocol Summarizing {
    func summarize(_ messages: [AIMessage]) -> String
}

public struct EmotionalSummarizer: Summarizing {
    public init() {}
    
    public func summarize(_ messages: [AIMessage]) -> String {
        let userMessages = messages.filter { $0.isFromUser && $0.detectedEmotion != nil }
        
        let emotionCounts = Dictionary(grouping: userMessages) { message in
            message.detectedEmotion?.rawValue ?? "neutral"
        }.mapValues { $0.count }
        
        let totalMessages = userMessages.count
        
        if totalMessages == 0 {
            return String(localized: "summary.no_emotions", defaultValue: "Sin emociones detectadas")
        }
        
        let dominantEmotion = emotionCounts.max(by: { $0.value < $1.value })?.key ?? "neutral"
        let avgConfidence = userMessages.compactMap { $0.confidence }.reduce(0, +) / Double(max(userMessages.count, 1))
        
        let emotionBreakdown = emotionCounts
            .sorted(by: { $0.value > $1.value })
            .prefix(3)
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: ", ")
        
        return String(localized: "summary.template", 
                     defaultValue: "Resumen emocional (\(totalMessages) mensajes): \(emotionBreakdown). Emoción dominante: \(dominantEmotion) (confianza promedio: \(String(format: "%.1f", avgConfidence * 100))%)")
    }
}

// MARK: - Persistence Gateway

public protocol PersistenceGateway {
    func save(_ conversation: ConversationEntity) throws
    func loadConversations() throws -> [ConversationEntity]
    func deleteOldConversations(olderThan date: Date) throws
}

public class SwiftDataPersistenceGateway: PersistenceGateway {
    private let context: ModelContext
    
    public init(context: ModelContext) {
        self.context = context
    }
    
    public func save(_ conversation: ConversationEntity) throws {
        context.insert(conversation)
        try context.save()
    }
    
    public func loadConversations() throws -> [ConversationEntity] {
        let descriptor = FetchDescriptor<ConversationEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    public func deleteOldConversations(olderThan date: Date) throws {
        let descriptor = FetchDescriptor<ConversationEntity>(
            predicate: #Predicate { $0.createdAt < date }
        )
        let oldConversations = try context.fetch(descriptor)
        
        for conversation in oldConversations {
            context.delete(conversation)
        }
        
        try context.save()
    }
}

// MARK: - Response Selector

public protocol ResponseSelecting {
    func selectResponse(for emotion: EmotionalState, using generator: inout SeededGenerator) -> String
}

public struct TemplateResponseSelector: ResponseSelecting {
    private let templates: ResponseTemplating
    
    public init(templates: ResponseTemplating = StaticResponseTemplates()) {
        self.templates = templates
    }
    
    public func selectResponse(for emotion: EmotionalState, using generator: inout SeededGenerator) -> String {
        let candidates = templates.templates(for: emotion)
        return candidates.randomElement(using: &generator) ?? String(localized: "responses.fallback", defaultValue: "Te escucho. Estoy aquí para apoyarte.")
    }
}

// MARK: - Static Response Templates (Enhanced)

public struct StaticResponseTemplates: ResponseTemplating {
    public init() {}
    
    public func templates(for emotion: EmotionalState) -> [String] {
        switch emotion {
        case .anxious:
            return [
                String(localized: "responses.anxious.1", defaultValue: "Entiendo que te sientes ansiosa. Respiremos juntas por un momento."),
                String(localized: "responses.anxious.2", defaultValue: "La ansiedad es natural en este proceso. ¿Qué te ayudaría a sentirte más tranquila?"), 
                String(localized: "responses.anxious.3", defaultValue: "Estoy aquí contigo. Vamos paso a paso, sin prisa.")
            ]
        case .sad:
            return [
                String(localized: "responses.sad.1", defaultValue: "Siento que estés pasando por este momento difícil."),
                String(localized: "responses.sad.2", defaultValue: "Está bien sentir tristeza. Es parte del proceso y eres muy valiente."),
                String(localized: "responses.sad.3", defaultValue: "No estás sola en esto. Permítete sentir, yo estaré aquí.")
            ]
        case .hopeful:
            return [
                String(localized: "responses.hopeful.1", defaultValue: "Me alegra sentir tu esperanza. Es una fuerza hermosa."),
                String(localized: "responses.hopeful.2", defaultValue: "Esa esperanza que tienes es el motor de todo lo bueno que viene."),
                String(localized: "responses.hopeful.3", defaultValue: "Tu optimismo es contagioso y me inspira.")
            ]
        case .excited:
            return [
                String(localized: "responses.excited.1", defaultValue: "¡Qué hermoso verte tan emocionada! Comparto tu alegría."),
                String(localized: "responses.excited.2", defaultValue: "Tu emoción me llena de felicidad. ¡Celebremos juntas!"),
                String(localized: "responses.excited.3", defaultValue: "Es maravilloso verte brillar así. Mereces toda esta felicidad.")
            ]
        case .frustrated:
            return [
                String(localized: "responses.frustrated.1", defaultValue: "Comprendo tu frustración. A veces el camino se siente muy difícil."),
                String(localized: "responses.frustrated.2", defaultValue: "Es válido sentirse frustrada. ¿Qué necesitas para sentirte mejor?"),
                String(localized: "responses.frustrated.3", defaultValue: "Tu frustración habla de lo mucho que deseas esto. Eso es fortaleza.")
            ]
        case .grateful:
            return [
                String(localized: "responses.grateful.1", defaultValue: "Tu gratitud es hermosa y se siente en cada palabra."),
                String(localized: "responses.grateful.2", defaultValue: "Qué bonito es compartir este momento de agradecimiento contigo."),
                String(localized: "responses.grateful.3", defaultValue: "La gratitud que sientes ilumina todo a tu alrededor.")
            ]
        case .neutral:
            return [
                String(localized: "responses.neutral.1", defaultValue: "Te escucho. Estoy aquí para acompañarte en lo que necesites."),
                String(localized: "responses.neutral.2", defaultValue: "¿Cómo puedo apoyarte mejor en este momento?"),
                String(localized: "responses.neutral.3", defaultValue: "Estoy contigo. Cuéntame lo que sientes.")
            ]
        }
    }
}

// MARK: - Personality Adapter with Clamping

public struct ClampedPersonalityAdapter: PersonalityAdapting {
    public init() {}
    
    public mutating func adapt(to emotion: EmotionalState, traits: inout PersonalityTraits) {
        let delta = 0.05
        
        switch emotion {
        case .anxious, .sad:
            traits.empathy = clamp(traits.empathy + delta, 0.0, 1.0)
            traits.supportiveness = clamp(traits.supportiveness + delta, 0.0, 1.0)
        case .frustrated:
            traits.intuition = clamp(traits.intuition + delta, 0.0, 1.0)
            traits.empathy = clamp(traits.empathy + delta * 0.5, 0.0, 1.0)
        case .hopeful, .excited:
            traits.hopefulness = clamp(traits.hopefulness + delta, 0.0, 1.0)
        case .grateful:
            traits.supportiveness = clamp(traits.supportiveness + delta, 0.0, 1.0)
        case .neutral:
            // Gradual regression to baseline
            traits.empathy = clamp(traits.empathy + (0.8 - traits.empathy) * 0.1, 0.0, 1.0)
            traits.supportiveness = clamp(traits.supportiveness + (0.7 - traits.supportiveness) * 0.1, 0.0, 1.0)
            traits.intuition = clamp(traits.intuition + (0.6 - traits.intuition) * 0.1, 0.0, 1.0)
            traits.hopefulness = clamp(traits.hopefulness + (0.9 - traits.hopefulness) * 0.1, 0.0, 1.0)
        }
    }
    
    private func clamp(_ value: Double, _ min: Double, _ max: Double) -> Double {
        return Swift.max(min, Swift.min(max, value))
    }
}
