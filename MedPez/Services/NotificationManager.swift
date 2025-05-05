//
//  NotificationManager.swift
//  MedPez
//
//  Created by Brian Lee on 5/4/25.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted.")
            } else if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
            } else {
                print("❌ Notification permission denied.")
            }
        }
    }

    static func scheduleNotification(for task: Task) {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "\(task.taskTitle) - \(task.dosage) mg"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.creationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("🔔 Notification scheduled for \(task.taskTitle) at \(task.creationDate)")
            }
        }
    }

    static func cancelNotification(for task: Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
        print("🗑️ Notification canceled for task: \(task.taskTitle)")
    }
    
    static func cancelAllScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🛑 All notifications cancelled.")
    }

    static func reschedulePendingTasks() {
        TaskManager.fetchPendingTasks { tasks in
            for task in tasks {
                scheduleNotification(for: task)
            }
        }
    }
}

