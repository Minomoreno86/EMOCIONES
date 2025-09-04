import Foundation

public final class LocalEducationRetriever: EducationRetriever {
	private let index: [String: [String: String]]
	public init(bundle: Bundle = .main) {
		if let url = bundle.url(forResource: "education", withExtension: "json"),
			let data = try? Data(contentsOf: url),
			let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String: String]] {
			self.index = json
		} else { self.index = [:] }
	}
	public func lookup(topic: String, locale: String) -> String {
		let key = topic.trimmingCharacters(in: .whitespacesAndNewlines)
		return index[key]?[locale] ?? index["default"]?[locale] ?? ""
	}
}
