//
//  UserNotificationCenter.swift
//  NDCalc
//
//  Created by James Warren on 23/7/21.
//

import UserNotifications

protocol UserNotificationCenter {
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
}

extension UNUserNotificationCenter: UserNotificationCenter {}
