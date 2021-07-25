//
//  NotificationController.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import UserNotifications

final class NotificationController: NotificationControllerProtocol {
    private(set) var notificationIdentifier: String?
    private let centre: UserNotificationCenter

    var hasNotificationScheduled = false

    init(notificationCentre: UserNotificationCenter = UNUserNotificationCenter.current()) {
        centre = notificationCentre
    }

    func scheduleNotification(for endDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = Self.notificationTitle
        content.body = Self.notificationBody
        content.sound = UNNotificationSound.defaultCritical

//        if #available(iOS 15.0, *) {
//            content.interruptionLevel = UNNotificationInterruptionLevel.critical
//        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: endDate.timeIntervalSinceNow, repeats: false)
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationIdentifier = identifier
        hasNotificationScheduled = true

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

        hasNotificationScheduled = false
        self.notificationIdentifier = nil
        centre.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }

    func requestNotificationPermission() {
        centre.requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error {
                fatalError("error while requesting notification: \(error.localizedDescription)")
            }
        }
    }

    static let notificationTitle = "Exposure finished"
    static let notificationBody = "Your exposure has finished"
}
