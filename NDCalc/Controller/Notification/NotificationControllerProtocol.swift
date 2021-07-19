//
//  NotificationControllerProtocol.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Foundation

protocol NotificationControllerProtocol {
    func scheduleNotification(for endDate: Date)
    func cancelNotification()
}
