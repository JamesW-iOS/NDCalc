//
//  MockNotificationController.swift
//  NDCalcTests
//
//  Created by James Warren on 22/7/21.
//

import Foundation
import NotificationCenter
@testable import NDCalc

final class MockNotificationController: NotificationControllerProtocol {
    var notificationIdentifier: String?
    var hasNotificationScheduled = false
    var scheduledNotificationDate: Date?
    var hasRequestedNotificationPermission = false
    // swiftlint:disable:next identifier_name
    var hasCalledRemovedAllDeliveredNotifications = false

    func scheduleNotification(for endDate: Date) {
        hasNotificationScheduled = true
        scheduledNotificationDate = endDate
    }

    func cancelNotification() {
        hasNotificationScheduled = false
        scheduledNotificationDate = nil
    }

    func requestNotificationPermission() {
        hasRequestedNotificationPermission = true
    }

    func clearAllDeliveredNotifications() {
        hasCalledRemovedAllDeliveredNotifications = true
    }

    func getNotificationPermission() async -> NotificationSettings {
        .init(
            timeSensitiveSetting: .notSupported,
            authorizationStatus: .ephemeral,
            lockScreenSetting: .notSupported,
            soundSetting: .notSupported
        )
    }
}
