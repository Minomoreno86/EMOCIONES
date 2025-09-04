import Foundation
import SwiftData

// MARK: - Core Types

public enum EmotionalState: String, CaseIterable, Codable, Sendable {
    case neutral = "neutral"
    case anxious = "anxious"
    case hopeful = "hopeful"
    case sad = "sad"
    case excited = "excited"
    case frustrated = "frustrated"
    case grateful = "grateful"
}

public struct PersonalityTraits: Codable, Sendable {
    public var empathy: Double = 0.8
    public var supportiveness: Double = 0.7
    public var intuition: Double = 0.6
    public var hopefulness: Double = 0.9
    
    public init() {}
}

// MARK: - SwiftData Models for Persistence

@Model
public final class ConversationEntity {
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date
    public var messages: [MessageEntity]
    
    public init(id: UUID = UUID(), createdAt: Date = Date(), messages: [MessageEntity] = []) {
        self.id = id
        self.createdAt = createdAt
        self.messages = messages
    }
}

@Model
public final class MessageEntity {
    @Attribute(.unique) public var id: UUID
    public var content: String
    public var isFromUser: Bool
    public var timestamp: Date
    public var detectedEmotion: String?
    public var confidence: Double
    public var rationale: String?
    
    public init(id: UUID = UUID(), 
         content: String, 
         isFromUser: Bool, 
         timestamp: Date = Date(), 
         detectedEmotion: String? = nil, 
         confidence: Double = 0.0,
         rationale: String? = nil) {
        self.id = id
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = timestamp
        self.detectedEmotion = detectedEmotion
        self.confidence = confidence
        self.rationale = rationale
    }
}

// MARK: - Protocol Definitions (No duplicate EmotionResult)

public protocol EmotionAnalyzing: Sendable {
    func detect(in text: String) -> EmotionResult
}

// MARK: - Response Configuration

public struct ResponseConfig: Codable, Sendable {
    public var temperature: Double = 0.25  // 0: determinista, 1: variado
    public var dailySeed: UInt64 = UInt64(Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1)
    public var rateLimitSeconds: Double = 1.0
    public var maxMessagesBeforeSummary: Int = 100
    public var maxConversationMessages: Int = 300
    
    public init() {}
}

// MARK: - Seeded Random Number Generator

public struct SeededGenerator: RandomNumberGenerator, Sendable {
    private var state: UInt64
    
    public init(seed: UInt64) { 
        self.state = seed &* 6364136223846793005 &+ 1 
    }
    
    public mutating func next() -> UInt64 { 
        state &+= 0x9E3779B97F4A7C15
        return state 
    }
}

// MARK: - Response Templates Protocol

public protocol ResponseTemplating: Sendable {
    func templates(for emotion: EmotionalState) -> [String]
}

// MARK: - Personality Adaptation Protocol

protocol PersonalityAdapting: Sendable {
    mutating func adapt(to emotion: EmotionalState, traits: inout PersonalityTraits)
}

// MARK: - Safety Filter Protocol

protocol SafetyFiltering: Sendable {
    func filter(_ candidate: String) -> String
}
