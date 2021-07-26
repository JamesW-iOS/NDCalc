//
//  CountdownController.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Combine
import Foundation

/// An object that controls starting and stopping countdowns and commutation to start and stop notifications.
///
/// It is intended that views will interact with this object to start and stop countdowns, this object will handle
/// side effects of timers like communicating with the a NotificationController and triggering vibration alerts.
final class CountdownController<Notification: NotificationControllerProtocol>: CountdownControllerProtocol {
    /// The currently running countdown.
    ///
    /// Because of not allowing property wrappers in protocols this is kept as a private variable, we then
    /// set the protocol requirement for a publisher to this variables publisher.
    @Published private var currentCountdown: Countdown?

    /// A publisher for the currently running Countdown, nil if there is no running countdown.
    var currentCountdownPublisher: Published<Countdown?>.Publisher { $currentCountdown }

    /// A reference to an object that conforms to the NotificationControllerProtocol, used to schedule notifications.
    private var notificationController: Notification

    /// A timer that is set to finish when the countdown will finish, used to schedule a vibration to occur.
    /// `nil` if no Countdown running.
    ///
    /// We keep a reference to the `Timer` so that we can cancel it.
    private var timer: Timer?

    /// Initialises a `CountdownController`, optionally with a particular notification controller.
    /// - Parameter notificationController: An object that conforms to the `NotificationControllerProtocol`, used to
    /// schedule and cancel notifications
    ///
    /// `notificationController` has a default value of what the `DIContainer` has stored, overriding this default
    /// should only be used for testing purposes.
    init(notificationController: Notification = DIContainer.shared.resolve(type: Notification.self)!) {
        self.notificationController = notificationController
    }

    /// A flag indicating if there is currently a `Countdown` running.
    var hasCountdownActive: Bool {
        if let countdown = currentCountdown {
            return !countdown.isComplete
        } else {
            return false
        }
    }

    /// Start a countdown for a particular end time.
    /// - Parameter endDate: The time at which the countdown should end.
    ///
    /// - Throws: `CountdownError.invalidEndTime`
    /// if the `endDate` given is either the current time or in the past.
    func startCountdown(for endDate: Date) throws {
        let countdown = try Countdown(endsAt: endDate)
        currentCountdown = countdown

        notificationController.scheduleNotification(for: endDate)
        timer = Timer.scheduledTimer(withTimeInterval: endDate.timeIntervalSinceNow, repeats: false) { _ in
            Vibration.error.vibrate()
            self.currentCountdown = nil
        }

    }

    /// Cancel the currently running countdown if there is one running.
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
