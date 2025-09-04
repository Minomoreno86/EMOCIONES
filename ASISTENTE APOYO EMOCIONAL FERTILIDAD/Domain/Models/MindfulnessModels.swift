import Foundation
import SwiftData

public enum SessionType: String, Codable, CaseIterable { case breathing, bodyScan, grounding, visualization }

@Model
public final class MindfulnessSessionEntity {
	@Attribute(.unique) public var id: UUID
	public var type: String
	public var titleKey: String
	public var durationMin: Int
	public var difficulty: String
	public var audioAsset: String?
	public init(id: UUID = .init(), type: SessionType, titleKey: String, durationMin: Int, difficulty: String = "beginner", audioAsset: String? = nil) {
		self.id = id; self.type = type.rawValue; self.titleKey = titleKey
		self.durationMin = durationMin; self.difficulty = difficulty; self.audioAsset = audioAsset
	}
}
