//
//  NotificationController.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import UserNotifications

final class NotificationController: NotificationControllerProtocol {
    var notificationIdentifier: String?
    let centre = UNUserNotificationCenter.current()

    func scheduleNotification(for endDate: Date) {
        let centre = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Exposure finished"
        content.body = "Your exposure has finished"
        content.sound = UNNotificationSound.defaultCritical

//        if #available(iOS 15.0, *) {
//            content.interruptionLevel = UNNotificationInterruptionLevel.critical
//        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: endDate.timeIntervalSinceNow, repeats: false)
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationIdentifier = identifier

        centre.add(request) { (error) in
            if let error = error {
                print("error while scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    func cancelNotification() {
        guard let notificationIdentifier = notificationIdentifier else {
            assertionFailure("cancel notification called but no identifier saved.")
            return
        }

        centre.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }

    static func requestNotificationPermission() {
        let centre = UNUserNotificationCenter.current()

        centre.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                fatalError("error while requesting notification: \(error.localizedDescription)")
            }
        }
    }
}
