import Foundation
import SwiftUI
import SwiftData
import os.log

// MARK: - Enhanced AI Message with Metadata

public struct AIMessage: Identifiable {
    public let id = UUID()
    public let content: String
    public let isFromUser: Bool
    public let timestamp: Date
    public let detectedEmotion: EmotionalState?
    public let confidence: Double
    public let rationale: String?
    
    public init(content: String, 
         isFromUser: Bool, 
         detectedEmotion: EmotionalState? = nil,
         confidence: Double = 0.0,
         rationale: String? = nil) {
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = Date()
        self.detectedEmotion = detectedEmotion
        self.confidence = confidence
        self.rationale = rationale
    }
}

// MARK: - Modular AI Luna Demo with Dependency Injection

@MainActor
final class AILunaDemo: ObservableObject {
    // MARK: - Dependencies (Injected)
    private let context: ModelContext
    private let analyzer: EmotionAnalyzing
    private let responseSelector: ResponseSelecting
    private var personalityAdapter: PersonalityAdapting
    private let safety: SafetyFiltering
    private let summarizer: Summarizing
    private let persistence: PersistenceGateway
    private let config: ResponseConfig
    
    // MARK: - State
    @Published var conversationHistory: [AIMessage] = []
    @Published var isTyping = false
    @Published var currentEmotionalState: EmotionalState = .neutral
    @Published var personalityTraits = PersonalityTraits()
    @Published var showEmergencyHelp = false
    
    // MARK: - Logging
    private let logger = Logger(subsystem: "com.gyneva.ai", category: "AILunaDemo")
    
    // MARK: - Internal State
    private var rng: SeededGenerator
    private var userEmotionalPattern: [EmotionalState] = []
    private var conversationCount = 0
    @Published public private(set) var adaptationLevel: Double = 0.0
    private var lastUserMessageAt: Date?
    private var currentConversation: ConversationEntity
    
    init(
        context: ModelContext,
        analyzer: EmotionAnalyzing = RegexEmotionAnalyzer(),
        responseSelector: ResponseSelecting = TemplateResponseSelector(),
        personalityAdapter: PersonalityAdapting = ClampedPersonalityAdapter(),
        safety: SafetyFiltering = SimpleSafetyFilter(),
        summarizer: Summarizing = EmotionalSummarizer(),
        config: ResponseConfig = ResponseConfig()
    ) {
        self.context = context
        self.analyzer = analyzer
        self.responseSelector = responseSelector
        self.personalityAdapter = personalityAdapter
        self.safety = safety
        self.summarizer = summarizer
        self.config = config
        self.persistence = SwiftDataPersistenceGateway(context: context)
        self.rng = SeededGenerator(seed: config.dailySeed)
        
        // Initialize conversation
        self.currentConversation = ConversationEntity()
        
        // Initialize with welcome message
        let welcomeMessage = AIMessage(
            content: String(localized: "welcome.message", 
                          defaultValue: "¡Hola! Soy Luna, tu compañera de apoyo emocional. Estoy aquí para escucharte y acompañarte en tu camino hacia la maternidad. ¿Cómo te sientes hoy?"),
            isFromUser: false,
            detectedEmotion: .hopeful,
            confidence: 1.0,
            rationale: "mensaje inicial"
        )
        
        conversationHistory = [welcomeMessage]
        appendMessageToConversation(welcomeMessage)
        loadLastConversation()
    }
    
    // MARK: - Core Message Handling
    
    func sendMessage(_ text: String) {
        // 1) Anti-spam/cooldown
        let now = Date()
        if let last = lastUserMessageAt, now.timeIntervalSince(last) < config.rateLimitSeconds { 
            print("[AI Luna] Message rate limited")
            return 
        }
        lastUserMessageAt = now

        // 2) Guardar mensaje usuario
        let userMsg = AIMessage(content: text, isFromUser: true)
        appendMessage(userMsg)
        print("[AI Luna] User message sent, length: \(text.count)")

        // 3) Detectar emoción con confianza
        let emo = analyzer.detect(in: text)
        currentEmotionalState = emo.state
        userEmotionalPattern.append(emo.state)
        print("[AI Luna] Emotion detected: \(emo.state.rawValue), confidence: \(emo.confidence)")

        // 4) Intervención breve si racha negativa
        let lastThree = Array(userEmotionalPattern.suffix(3))
        let isNegativeStreak = lastThree.count == 3 && lastThree.allSatisfy { emotion in
            emotion == .anxious || emotion == .sad
        }
        
        if isNegativeStreak {
            let brief = String(localized: "intervention.breathing.60s", 
                             defaultValue: "Pausa de 60s: inhala 4, sostén 7, exhala 8. ¿Seguimos cuando estés lista?")
            let ai = AIMessage(
                content: brief, 
                isFromUser: false, 
                detectedEmotion: emo.state, 
                confidence: emo.confidence, 
                rationale: emo.rationale
            )
            appendMessage(ai)
            conversationCount += 1
            updateAdaptationLevel()
            enforceCap()
            print("[AI Luna] Intervention triggered: breathing")
            return
        }

        // 5) Adaptar personalidad
        adaptPersonality(for: emo.state)

        // 6) Selección de respuesta
        var response = responseSelector.selectResponse(for: emo.state, using: &rng)
        response = personalize(response, emotion: emo.state)

        // 7) Safety filter
        response = safety.filter(response)

        // 8) Responder
        let ai = AIMessage(
            content: response, 
            isFromUser: false, 
            detectedEmotion: emo.state, 
            confidence: emo.confidence, 
            rationale: emo.rationale
        )
        appendMessage(ai)

        // 9) Mantenimiento
        conversationCount += 1
        updateAdaptationLevel()
        enforceCap()
        maybeSummarizeThread()
        print("[AI Luna] AI response sent for emotion: \(emo.state.rawValue)")
    }
    
    // MARK: - Persistence Methods
    
    private func appendMessage(_ message: AIMessage) {
        conversationHistory.append(message)
        appendMessageToConversation(message)
        
        Task {
            do {
                try persistence.save(currentConversation)
            } catch {
                logger.error("Failed to save conversation: \(error)")
            }
        }
    }
    
    private func appendMessageToConversation(_ message: AIMessage) {
        let messageEntity = MessageEntity(
            content: message.content,
            isFromUser: message.isFromUser,
            timestamp: message.timestamp,
            detectedEmotion: message.detectedEmotion?.rawValue,
            confidence: message.confidence,
            rationale: message.rationale
        )
        currentConversation.messages.append(messageEntity)
    }
    
    private func loadLastConversation() {
        Task {
            do {
                let conversations = try persistence.loadConversations()
                if let lastConversation = conversations.first {
                    self.currentConversation = lastConversation
                    self.conversationHistory = lastConversation.messages.map { entity in
                        AIMessage(
                            content: entity.content,
                            isFromUser: entity.isFromUser,
                            detectedEmotion: EmotionalState(rawValue: entity.detectedEmotion ?? "neutral"),
                            confidence: entity.confidence,
                            rationale: entity.rationale
                        )
                    }
                }
            } catch {
                logger.error("Failed to load conversations: \(error)")
            }
        }
    }
    
    // MARK: - Personality Adaptation
    
    private func adaptPersonality(for emotion: EmotionalState) {
        personalityAdapter.adapt(to: emotion, traits: &personalityTraits)
        print("[AI Luna] Personality adapted for \(emotion.rawValue)")
    }
    
    private func personalize(_ response: String, emotion: EmotionalState) -> String {
        let empathyLevel = personalityTraits.empathy
        let supportLevel = personalityTraits.supportiveness
        
        if empathyLevel > 0.8 && (emotion == .sad || emotion == .anxious) {
            return response + String(localized: "personalization.high_empathy", 
                                   defaultValue: " Estoy aquí contigo en este momento.")
        }
        
        if supportLevel > 0.8 && emotion == .hopeful {
            return response + String(localized: "personalization.high_support", 
                                   defaultValue: " Tu fortaleza me inspira.")
        }
        
        return response
    }
    
    // MARK: - Maintenance & Analytics
    
    private func maybeSummarizeThread() {
        guard conversationHistory.count % config.maxMessagesBeforeSummary == 0 else { return }
        
        let summary = summarizer.summarize(conversationHistory)
        let summaryMessage = AIMessage(
            content: summary,
            isFromUser: false,
            detectedEmotion: .neutral,
            confidence: 1.0,
            rationale: "summary"
        )
        
        appendMessage(summaryMessage)
        print("[AI Luna] Summary created for \(conversationHistory.count) messages")
    }
    
    private func enforceCap() {
        guard conversationHistory.count > config.maxConversationMessages else { return }
        
        // Keep last 100 messages + summary
        let keepCount = 100
        let removed = conversationHistory.count - keepCount
        conversationHistory = Array(conversationHistory.suffix(keepCount))
        
        print("[AI Luna] Conversation capped: removed \(removed), kept \(keepCount)")
    }
    
    private func updateAdaptationLevel() {
        let recentEmotions = Array(userEmotionalPattern.suffix(10))
        let positiveEmotions: [EmotionalState] = [.hopeful, .excited, .grateful]
        let positiveCount = recentEmotions.filter { emotion in
            positiveEmotions.contains(emotion)
        }.count
        
        adaptationLevel = Double(positiveCount) / Double(max(recentEmotions.count, 1))
    }
    
    // MARK: - Analytics
    
    func getConversationAnalytics() -> ConversationAnalytics {
        let emotionDistribution = Dictionary(grouping: userEmotionalPattern) { $0 }
            .mapValues { $0.count }
        
        let avgConfidence = conversationHistory
            .compactMap { $0.confidence }
            .reduce(0, +) / Double(max(conversationHistory.count, 1))
        
        let duration = conversationHistory.last?.timestamp.timeIntervalSince(
            conversationHistory.first?.timestamp ?? Date()
        ) ?? 0
        
        return ConversationAnalytics(
            totalMessages: conversationHistory.count,
            emotionDistribution: emotionDistribution,
            adaptationLevel: adaptationLevel,
            averageConfidence: avgConfidence,
            conversationDuration: duration
        )
    }
}

// MARK: - Analytics Model

struct ConversationAnalytics: Codable, Sendable {
    let totalMessages: Int
    let emotionDistribution: [EmotionalState: Int]
    let adaptationLevel: Double
    let averageConfidence: Double
    let conversationDuration: TimeInterval
}
