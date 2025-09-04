import Foundation
import BackgroundTasks

public final class BackgroundTasksService {
    public static let shared = BackgroundTasksService()
    private init() {}
    
    public func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.gynevia.mood-reminder", using: nil) { task in
            self.handleMoodReminder(task: task as! BGAppRefreshTask)
        }
    }
    
    public func scheduleMoodReminder() {
        let request = BGAppRefreshTaskRequest(identifier: "com.gynevia.mood-reminder")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * 60 * 60) // 24 hours
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule mood reminder: \(error)")
        }
    }
    
    private func handleMoodReminder(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        // Schedule next reminder
        scheduleMoodReminder()
        
        task.setTaskCompleted(success: true)
    }
}
