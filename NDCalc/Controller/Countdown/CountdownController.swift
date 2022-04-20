//
//  CountdownController.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Combine
import Foundation
import Depends

/// An object that controls starting and stopping countdowns and commutation to start and stop notifications.
///
/// It is intended that views will interact with this object to start and stop countdowns, this object will handle
/// side effects of timers like communicating with the a NotificationController and triggering vibration alerts.
final class CountdownController: CountdownControllerProtocol, DependencyProvider {
    static let storeCountdownKey = "countdownKey"

    let dependencies: DependencyRegistry

    /// A publisher for the currently running Countdown, nil if there is no running countdown.
    var currentCountdownPublisher = CurrentValueSubject<Countdown?, Never>(nil)

    /// A reference to an object that conforms to the NotificationControllerProtocol, used to schedule notifications.
    @Dependency(.notificationController)
    private var notificationController: NotificationControllerProtocol

    /// A timer that is set to finish when the countdown will finish, used to schedule a vibration to occur.
    /// `nil` if no Countdown running.
    ///
    /// We keep a reference to the `Timer` so that we can cancel it.
    private var timer: Timer?

    private let userDefaults: UserDefaults

    /// Initialises a `CountdownController`, optionally with a particular notification controller.
    /// - Parameter notificationController: An object that conforms to the `NotificationControllerProtocol`, used to
    /// schedule and cancel notifications
    ///
    /// `notificationController` has a default value of what the `DIContainer` has stored, overriding this default
    /// should only be used for testing purposes.
    init(dependancies: DependencyRegistry, userDefaults: UserDefaults = .standard) {
        self.dependencies = dependancies
        // Need to get things from user defaults

        self.userDefaults = userDefaults

        // Store things in user defaults here
        let storedCountdownEndTime = userDefaults.double(forKey: Self.storeCountdownKey)
        if storedCountdownEndTime != 0 {
            let date = Date(timeIntervalSince1970: storedCountdownEndTime)
            if let countdown = try? Countdown(endsAt: date) {
                currentCountdownPublisher.send(countdown)
            }

        }

    }

    /// A flag indicating if there is currently a `Countdown` running.
    var hasCountdownActive: Bool {
        if let countdown = currentCountdownPublisher.value {
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
        currentCountdownPublisher.send(countdown)
        userDefaults.set(endDate.timeIntervalSince1970, forKey: Self.storeCountdownKey)

        notificationController.scheduleNotification(for: endDate)
        timer = Timer.scheduledTimer(
            withTimeInterval: endDate.timeIntervalSinceNow,
            repeats: false
        ) { [unowned self] _ in
            Vibration.error.vibrate()
            currentCountdownPublisher.send(nil)
        }

    }

    /// Cancel the currently running countdown if there is one running.
    func cancelCountdown() {
        currentCountdownPublisher.send(nil)
        notificationController.cancelNotification()
        userDefaults.set(nil, forKey: Self.storeCountdownKey)

        guard let timer = timer else {
            assertionFailure("there should be a timer scheduled if countdown is being canceled")
            return
        }
        timer.invalidate()
        self.timer = nil
    }
}
