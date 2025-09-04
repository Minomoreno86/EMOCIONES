import Foundation
import SwiftData

public enum MoodTag: String, Codable, CaseIterable { case calm, anxious, sad, hopeful, neutral, stressed }

@Model
public final class MoodEntryEntity {
	@Attribute(.unique) public var id: UUID
	public var date: Date
	public var score: Int
	public var tagsJSON: String?
	public var note: String?
	public var breathMinutes: Int
	public var sleepHours: Double?
	public var cycleDay: Int?
	public init(id: UUID = .init(), date: Date = .init(), score: Int, tags: [MoodTag] = [], note: String? = nil, breathMinutes: Int = 0, sleepHours: Double? = nil, cycleDay: Int? = nil) {
		self.id = id; self.date = date; self.score = score; self.note = note
		self.breathMinutes = breathMinutes; self.sleepHours = sleepHours; self.cycleDay = cycleDay
		if !tags.isEmpty, let data = try? JSONEncoder().encode(tags) {
			self.tagsJSON = String(data: data, encoding: .utf8)
		}
	}
}
