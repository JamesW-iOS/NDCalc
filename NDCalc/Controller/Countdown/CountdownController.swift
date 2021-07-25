//
//  CountdownController.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Combine
import Foundation

final class CountdownController<Notification: NotificationControllerProtocol>: CountdownControllerProtocol {
    @Published var currentCountdown: Countdown?
    var currentCountdownPublisher: Published<Countdown?>.Publisher { $currentCountdown }

    var notificationController: Notification
    private var timer: Timer?

    init(notificationController: Notification = DIContainer.shared.resolve(type: Notification.self)!) {
        self.notificationController = notificationController
    }

    var hasActiveTimer: Bool {
        if let countdown = currentCountdown {
            return !countdown.isComplete
        } else {
            return false
        }
    }

    func startCountdown(for endDate: Date) throws {
        let countdown = try Countdown(endsAt: endDate)
        currentCountdown = countdown

        notificationController.scheduleNotification(for: endDate)
        timer = Timer.scheduledTimer(withTimeInterval: endDate.timeIntervalSinceNow, repeats: false) { _ in
            Vibration.error.vibrate()
        }

    }

    func cancelCountdown() {
        currentCountdown = nil
        notificationController.cancelNotification()

        guard let timer = timer else {
            assertionFailure("there should be a timer scheduled if countdown is being canceled")
            return
        }
        timer.invalidate()
        self.timer = nil
    }
}
