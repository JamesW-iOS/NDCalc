//
//  UserNotificationCenter.swift
//  NDCalc
//
//  Created by James Warren on 23/7/21.
//

import UserNotifications
import Depends

/// A protocol that defines the requirements for a `UserNotificationCenter`
///
/// This is intended to be a subset of the capabilities of the `UNUserNotificationCenter`, we have a seperate protocol
/// can mock the interactions with the system for better testing.
protocol UserNotificationCenter {
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
    func notificationSettings() async -> UNNotificationSettings
    func removeAllDeliveredNotifications()
}

extension UNUserNotificationCenter: UserNotificationCenter {}

extension DependencyKey where DependencyType == UserNotificationCenter {
    static let notificationCenter = DependencyKey(default: UNUserNotificationCenter.current())
}
