import SwiftUI
import SwiftData

@MainActor
final class ChatOrchestrator: ObservableObject {
    @Published var messages: [ChatMessageEntity] = []
    @Published var isLoading = false
    
    private let retriever: EducationRetriever
    private let advisor: MindfulnessAdvisor
    private let llmClient: LLMClient?
    private let modelContext: ModelContext
    
    init(
        retriever: EducationRetriever = LocalEducationRetriever(),
        advisor: MindfulnessAdvisor = MindfulnessAdvisorUseCase(),
        llmClient: LLMClient? = nil,
        modelContext: ModelContext
    ) {
        self.retriever = retriever
        self.advisor = advisor
        self.llmClient = llmClient
        self.modelContext = modelContext
    }
    
    func sendMessage(_ content: String, locale: String = "es") async {
        let userMessage = ChatMessageEntity(role: .user, content: content, locale: locale)
        modelContext.insert(userMessage)
        messages.append(userMessage)
        
        isLoading = true
        defer { isLoading = false }
        
        let response = await AssistantUseCase.askAssistant(
            messages: messages,
            locale: locale,
            retriever: retriever,
            advisor: advisor,
            llm: llmClient
        )
        
        let assistantMessage = ChatMessageEntity(role: .assistant, content: response, locale: locale)
        modelContext.insert(assistantMessage)
        messages.append(assistantMessage)
        
        try? modelContext.save()
    }
    
    func loadMessages() {
        let descriptor = FetchDescriptor<ChatMessageEntity>(sortBy: [SortDescriptor(\.createdAt)])
        messages = (try? modelContext.fetch(descriptor)) ?? []
    }
}
