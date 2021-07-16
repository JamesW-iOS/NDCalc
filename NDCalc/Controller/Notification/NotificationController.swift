//
//  NotificationController.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import UserNotifications

final class NotificationController {
    static func requestNotificationPermission() {
        let centre = UNUserNotificationCenter.current()

        centre.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                fatalError("error while requesting notification: \(error.localizedDescription)")
            }

            if result {
                print("can send notifications")
            } else {
                print("can't send notifications")
            }
        }
    }
}
