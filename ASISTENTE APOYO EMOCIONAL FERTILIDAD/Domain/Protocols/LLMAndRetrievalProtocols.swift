import Foundation

public struct ChatTurn: Codable, Sendable {
	public let role: String
	public let content: String
	public init(role: String, content: String) { self.role = role; self.content = content }
}

public protocol LLMClient {
	func complete(messages: [ChatTurn], systemPrompt: String) async throws -> String
}

public protocol EducationRetriever {
	func lookup(topic: String, locale: String) -> String
}

public protocol MindfulnessAdvisor {
	func suggest(from mood: MoodEntryEntity) -> String
}
