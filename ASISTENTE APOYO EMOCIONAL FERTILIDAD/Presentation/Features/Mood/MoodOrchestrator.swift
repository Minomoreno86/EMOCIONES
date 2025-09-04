import SwiftUI
import SwiftData

@MainActor
final class MoodOrchestrator: ObservableObject {
    @Published var entries: [MoodEntryEntity] = []
    @Published var correlations: [CorrelationResult] = []
    
    private let modelContext: ModelContext
    private let advisor: MindfulnessAdvisor
    
    init(modelContext: ModelContext, advisor: MindfulnessAdvisor = MindfulnessAdvisorUseCase()) {
        self.modelContext = modelContext
        self.advisor = advisor
    }
    
    func recordMood(score: Int, note: String? = nil, tags: [MoodTag] = []) {
        let entry = MoodEntryEntity(score: score, tags: tags, note: note)
        modelContext.insert(entry)
        entries.append(entry)
        
        // Compute correlations
        correlations = CorrelationsUseCase.compute(entries: entries)
        
        try? modelContext.save()
    }
    
    func loadEntries() {
        let descriptor = FetchDescriptor<MoodEntryEntity>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        entries = (try? modelContext.fetch(descriptor)) ?? []
        correlations = CorrelationsUseCase.compute(entries: entries)
    }
    
    func getMindfulnessSuggestion(for entry: MoodEntryEntity) -> String {
        return advisor.suggest(from: entry)
    }
}
