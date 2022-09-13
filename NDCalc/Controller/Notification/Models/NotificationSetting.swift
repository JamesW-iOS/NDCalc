//
//  NotificationSetting.swift
//  NDCalc
//
//  Created by Personal James on 1/9/2022.
//

import UserNotifications

enum NotifationSetting {
    case notSupported, disabled, enabled

    init(setting: UNNotificationSetting) {
        switch setting {
        case .notSupported:
            self = .notSupported
        case .disabled:
            self = .disabled
        case .enabled:
            self = .enabled
        @unknown default:
            assertionFailure()
            self = .notSupported
        }
    }
}

enum NotificationAuthorizationStatus {
    case notDetermined, denied, authorized, provisional, ephemeral

    init(status: UNAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self = .notDetermined
        case .denied:
            self = .denied
        case .authorized:
            self = .authorized
        case .provisional:
            self = .provisional
        case .ephemeral:
            self = .ephemeral
        @unknown default:
            assertionFailure()
            self = .notDetermined
        }
    }
}

struct NotificationSettings {
    var timeSensitiveSetting: NotifationSetting
    var authorizationStatus: NotificationAuthorizationStatus
    var lockScreenSetting: NotifationSetting
    var soundSetting: NotifationSetting
}
