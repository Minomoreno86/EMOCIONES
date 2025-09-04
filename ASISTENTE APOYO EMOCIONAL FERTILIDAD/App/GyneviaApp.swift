import SwiftUI
import SwiftData

@main
struct GyneviaApp: App {
	var sharedModelContainer: ModelContainer = {
		let schema = Schema([
			ChatMessageEntity.self,
			MoodEntryEntity.self,
			MindfulnessSessionEntity.self
		])
		let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
		do { return try ModelContainer(for: schema, configurations: [configuration]) }
		catch { fatalError("ModelContainer error: \(error)") }
	}()

	var body: some Scene {
		WindowGroup { 
			AppRouter()
				.task {
					await AppConfiguration.shared.configureApp()
				}
		}
		.modelContainer(sharedModelContainer)
	}
}
