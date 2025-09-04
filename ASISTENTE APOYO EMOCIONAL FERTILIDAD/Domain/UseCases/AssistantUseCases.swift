import Foundation

public enum AssistantUseCase {
	public static func askAssistant(messages: [ChatMessageEntity], locale: String, retriever: EducationRetriever, advisor: MindfulnessAdvisor, llm: LLMClient?) async -> String {
		let last = messages.last?.content ?? ""
		let topic = last.lowercased()
		let safePrefix = locale == "es" ? "Este asistente no ofrece diagnósticos. " : "This assistant does not provide diagnoses. "
		let edu = retriever.lookup(topic: topic, locale: locale)
		if let llm {
			let turns = messages.map { ChatTurn(role: $0.role, content: $0.content) }
			let sys = locale == "es" ? "Eres un asistente empático y educativo. No diagnostiques." : "You are an empathetic educational assistant. Do not diagnose."
			if let reply = try? await llm.complete(messages: turns, systemPrompt: sys) {
				return safePrefix + reply
			}
		}
		return safePrefix + edu
	}
}
