//
//  NotificationControllerProtocol.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Foundation

protocol NotificationControllerProtocol {
    var hasNotificationScheduled: Bool { get }
    var notificationIdentifier: String? { get }

    func scheduleNotification(for endDate: Date)
    func cancelNotification()
    func requestNotificationPermission()
}
