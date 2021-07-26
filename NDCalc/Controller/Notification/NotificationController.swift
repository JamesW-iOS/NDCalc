//
//  NotificationController.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import UserNotifications

/// An implementation of the `NotificationControllerProtocol`, an object that manages scheduling notification.
final class NotificationController: NotificationControllerProtocol {
    /// The identifier of the currently scheduled notification if there is one.
    private(set) var notificationIdentifier: String?
    /// A reference to an object that conforms to the `UserNotificationCenter` protocol
    ///
    /// This is almost always the system `UNUserNotificationCenter` except in the case of testing.
    private let centre: UserNotificationCenter

    /// A flag indicating if the controller currently has a notification scheduled.
    var hasNotificationScheduled = false

    /// Initialise a `NotificationController`, optionally with a `UserNotificationCenter` object
    /// - Parameter notificationCentre: An object that handles actually scheduling notifications, this is almost always
    /// the  system `UNUserNotificationCenter`, this should only be overridden for testing.
    init(notificationCentre: UserNotificationCenter = UNUserNotificationCenter.current()) {
        centre = notificationCentre
    }

    /// Schedule a notification to be delivered at a particular time.
    ///
    /// - Parameter for: The time at which the notification should be delivered.
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

    /// Cancel the currently scheduled notification if there is one.
    func cancelNotification() {
        guard let notificationIdentifier = notificationIdentifier else {
            assertionFailure("cancel notification called but no identifier saved.")
            return
        }

        hasNotificationScheduled = false
        self.notificationIdentifier = nil
        centre.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }

    /// Request notification permission from the `UserNotificationCenter`, usually the system.
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
