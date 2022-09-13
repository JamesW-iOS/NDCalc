//
//  NotificationController.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Combine
import Depends
import UserNotifications

/// An implementation of the `NotificationControllerProtocol`, an object that manages scheduling notification.
final class NotificationController: NotificationControllerProtocol, DependencyProvider {
    let dependencies: DependencyRegistry

//    /// The identifier of the currently scheduled notification if there is one.
//    private(set) var notificationIdentifier: String?

    /// A reference to an object that conforms to the `UserNotificationCenter` protocol
    ///
    /// This is almost always the system `UNUserNotificationCenter` except in the case of testing.
    @Dependency(.notificationCenter) private var centre
    @Dependency(.userDefaults) private var userDefaults

    /// A flag indicating if the controller currently has a notification scheduled.
    var hasNotificationScheduled = false

    private(set) var notificationIdentifier: String? {
        get {
            userDefaults.string(forKey: Self.savedNotifationIDKey)
        }

        set {
            userDefaults.set(newValue, forKey: Self.savedNotifationIDKey)
        }
    }

    /// Initialise a `NotificationController`, optionally with a `UserNotificationCenter` object
    /// - Parameter notificationCentre: An object that handles actually scheduling notifications, this is almost always
    /// the  system `UNUserNotificationCenter`, this should only be overridden for testing.
    init(dependancies: DependencyRegistry) {
        self.dependencies = dependancies
    }

    /// Schedule a notification to be delivered at a particular time.
    ///
    /// - Parameter for: The time at which the notification should be delivered.
    func scheduleNotification(for endDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = Self.notificationTitle
        content.body = Self.notificationBody
        content.sound = UNNotificationSound.defaultCritical

        if #available(iOS 15.0, *) {
            content.interruptionLevel = UNNotificationInterruptionLevel.critical
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: endDate.timeIntervalSinceNow, repeats: false)
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationIdentifier = identifier
        userDefaults.set(identifier, forKey: Self.savedNotifationIDKey)

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

        userDefaults.set(nil, forKey: Self.savedNotifationIDKey)

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

    func getNotificationPermission() async -> NotificationSettings {
        let settings = await centre.notificationSettings()

        return .init(
            timeSensitiveSetting: .init(setting: settings.timeSensitiveSetting),
            authorizationStatus: .init(status: settings.authorizationStatus),
            lockScreenSetting: .init(setting: settings.lockScreenSetting),
            soundSetting: .init(setting: settings.soundSetting)
        )
    }

    func clearAllDeliveredNotifications() {
        centre.removeAllDeliveredNotifications()
    }

    static let notificationTitle = "Exposure finished"
    static let notificationBody = "Your exposure has finished"

    static let savedNotifationIDKey = "notificationKey"
}
