import Foundation
import UserNotifications

public final class AppConfiguration {
    public static let shared = AppConfiguration()
    private init() {}
    
    public func configureApp() async {
        await requestNotificationPermissions()
        BackgroundTasksService.shared.registerBackgroundTasks()
    }
    
    private func requestNotificationPermissions() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            if granted {
                print("Notification permissions granted")
            }
        } catch {
            print("Failed to request notification permissions: \(error)")
        }
    }
}
