//
//  NotificationControllerProtocol.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Combine
import Depends
import Foundation
import UserNotifications

/// A protocol defining the requirements for a NotificationController.
///
/// Only a single notification can be scheduled to be delivered at once, this is intentional
/// since only a single countdown may be running at one time.
protocol NotificationControllerProtocol {
    /// A flag indicating if there is a notification currently scheduled.
    var hasNotificationScheduled: Bool { get }
    /// the identifier for the currently scheduled notification if one exists.
    var notificationIdentifier: String? { get }

    /// Schedule a notification to be sent at a particular time..
    ///
    /// - Parameter for: The time at which the notification should be delivered.
    func scheduleNotification(for endDate: Date)
    /// Cancel the currently scheduled notification if there is one
    func cancelNotification()
    /// Request notification permission from the system.
    func requestNotificationPermission()

    func getNotificationPermission() async -> NotificationSettings

    func clearAllDeliveredNotifications()
}

extension DependencyKey where DependencyType == NotificationControllerProtocol {
    static let notificationController = DependencyKey(default: MockNotificationController())
}

final class MockNotificationController: NotificationControllerProtocol {
    var notificationIdentifier: String?

    var hasNotificationScheduled: Bool = false

    func scheduleNotification(for endDate: Date) {
    }

    func cancelNotification() {
    }

    func requestNotificationPermission() {
    }

    func getNotificationPermission() async -> NotificationSettings {
        .init(
            timeSensitiveSetting: .notSupported,
            authorizationStatus: .provisional,
            lockScreenSetting: .notSupported,
            soundSetting: .notSupported
        )
    }

    func clearAllDeliveredNotifications() {}
}
