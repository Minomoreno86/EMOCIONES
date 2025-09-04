import Foundation
import SwiftData

public enum ChatRole: String, Codable, CaseIterable { case system, assistant, user, tool }

@Model
public final class ChatMessageEntity {
	@Attribute(.unique) public var id: UUID
	public var role: String
	public var content: String
	public var createdAt: Date
	public var locale: String
	public var safetyTagsJSON: String?
	public init(id: UUID = .init(), role: ChatRole, content: String, createdAt: Date = .init(), locale: String = "es", safetyTags: [String] = []) {
		self.id = id
		self.role = role.rawValue
		self.content = content
		self.createdAt = createdAt
		self.locale = locale
		if !safetyTags.isEmpty, let data = try? JSONEncoder().encode(safetyTags) {
			self.safetyTagsJSON = String(data: data, encoding: .utf8)
		}
	}
}
