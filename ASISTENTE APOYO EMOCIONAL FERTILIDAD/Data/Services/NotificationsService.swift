import Foundation
import UserNotifications

public final class NotificationsService: Sendable {
	public init() {}
	public func requestAuthorization() async throws -> Bool {
		try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
	}
	public func scheduleDaily(id: String, titleKey: String, bodyKey: String, hour: Int, minute: Int) async throws {
		let content = UNMutableNotificationContent()
		content.title = NSLocalizedString(titleKey, comment: "")
		content.body = NSLocalizedString(bodyKey, comment: "")
		var date = DateComponents(); date.hour = hour; date.minute = minute
		let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
		let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
		try await UNUserNotificationCenter.current().add(request)
	}
}
