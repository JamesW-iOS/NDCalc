//
//  MockUserNotificationCentre.swift
//  NDCalcTests
//
//  Created by James Warren on 23/7/21.
//

import UserNotifications
@testable import NDCalc

final class MockUserNotificationCentre: UserNotificationCenter {
    var hasAuthorizationStatus = false
    var request: UNNotificationRequest?


    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        hasAuthorizationStatus = true
        completionHandler(true, nil)
    }

    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
        self.request = request
        if let completionHandler = completionHandler {
            completionHandler(nil)
        }
    }

    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        request = nil
    }
}
