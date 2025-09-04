import Foundation
import SwiftData

public enum CorrelationMethod: String, Codable { case pearson }

public struct CorrelationResult: Sendable, Codable {
	public let variable: String
	public let coefficient: Double
}

public enum MoodUseCases {
	public static func recordMoodEntry(context: ModelContext, score: Int, note: String? = nil) {
		let entry = MoodEntryEntity(score: score, note: note)
		context.insert(entry)
	}

	public static func listMoodHistory(modelContext: ModelContext, range: DateInterval? = nil) -> [MoodEntryEntity] {
		let descriptor = FetchDescriptor<MoodEntryEntity>(sortBy: [SortDescriptor(\.date, order: .reverse)])
		let all = (try? modelContext.fetch(descriptor)) ?? []
		guard let r = range else { return all }
		return all.filter { r.contains($0.date) }
	}
}

public enum CorrelationsUseCase {
	public static func compute(entries: [MoodEntryEntity]) -> [CorrelationResult] {
		let pairs: [(String, [Double], [Double])] = [
			("sleepHours", entries.compactMap { $0.sleepHours }, entries.map { Double($0.score) }),
			("breathMinutes", entries.map { Double($0.breathMinutes) }, entries.map { Double($0.score) }),
			("cycleDay", entries.compactMap { $0.cycleDay }.map(Double.init), entries.map { Double($0.score) })
		]
		return pairs.compactMap { name, x, y in
			guard x.count == y.count, x.count >= 3 else { return nil }
			let coef = pearson(x: x, y: y)
			return CorrelationResult(variable: name, coefficient: coef)
		}
	}

	private static func pearson(x: [Double], y: [Double]) -> Double {
		let n = Double(x.count)
		let sumX = x.reduce(0, +), sumY = y.reduce(0, +)
		let sumXY = zip(x, y).reduce(0) { $0 + $1.0 * $1.1 }
		let sumX2 = x.reduce(0) { $0 + $1 * $1 }
		let sumY2 = y.reduce(0) { $0 + $1 * $1 }
		let numerator = n * sumXY - sumX * sumY
		let denominator = sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY))
		guard denominator != 0 else { return 0 }
		return max(-1, min(1, numerator / denominator))
	}
}
