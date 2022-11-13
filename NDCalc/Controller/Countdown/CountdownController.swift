//
//  CountdownController.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import AVKit
import Combine
import Foundation
import Depends
import UIKit

/// An object that controls starting and stopping countdowns and commutation to start and stop notifications.
///
/// It is intended that views will interact with this object to start and stop countdowns, this object will handle
/// side effects of timers like communicating with the a NotificationController and triggering vibration alerts.
final class CountdownController: CountdownControllerProtocol, DependencyProvider {
    static let storeCountdownKey = "countdownKey"
    static let storedCountdownFilterKey = "storeFilterKey"
    static let storedCountdownShutterKey = "storeShutterKey"

    let dependencies: DependencyRegistry

    /// A publisher for the currently running Countdown, nil if there is no running countdown.
    var currentCountdownPublisher = CurrentValueSubject<Countdown?, Never>(nil)

    /// A reference to an object that conforms to the NotificationControllerProtocol, used to schedule notifications.
    @Dependency(.notificationController)
    private var notificationController: NotificationControllerProtocol

    @Dependency(.applicationState)
    private var applicationStateStore: ApplicationStateStoreProtocol

    /// The currently selected `Filter` in the picker.
    @UserDefault(key: storedCountdownFilterKey,
                 defaultValue: "")
    private var storedFilter: String
    /// The currently selected `ShutterSpeed` in the picker.
    @UserDefault(key: storedCountdownShutterKey,
                 defaultValue: "")
    private var storesdShutterSpeed: String

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
            assert(!storesdShutterSpeed.isEmpty, "Should have stored shutter speed if stored countdown")
            assert(!storedFilter.isEmpty, "Should have stored filter if stored countdown")
            try? startCountdown(for: date, properties: (filter: storedFilter, shutter: storesdShutterSpeed))
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
    /// - Parameter properties: The properties of the timer, `nil` if no activity should be scheduled.
    ///
    /// - Throws: `CountdownError.invalidEndTime`
    /// if the `endDate` given is either the current time or in the past.
    func startCountdown(for endDate: Date, properties: TimerProperties) throws {
        let countdown = try Countdown(endsAt: endDate, shutterSpeed: properties.shutter, filter: properties.filter)
        currentCountdownPublisher.send(countdown)
        userDefaults.set(endDate.timeIntervalSince1970, forKey: Self.storeCountdownKey)
        storesdShutterSpeed = properties.shutter
        storedFilter = properties.filter

        let attributes = TimerActivityAttributes(
            timerStart: Date(),
            timerEnd: endDate,
            exposure: properties.shutter,
            filter: properties.filter
        )

        notificationController.scheduleNotification(with: attributes)
        timer = Timer.scheduledTimer(
            withTimeInterval: endDate.timeIntervalSinceNow,
            repeats: false
        ) { [unowned self] _ in
            Vibration.error.vibrate()
            currentCountdownPublisher.send(nil)
            if applicationStateStore.applicationState.value == .foreground {
                AudioServicesPlayAlertSound(1005)
            }
        }
    }

    /// Cancel the currently running countdown if there is one running.
    func cancelCountdown() {
        currentCountdownPublisher.send(nil)
        notificationController.cancelNotification()
        userDefaults.set(nil, forKey: Self.storeCountdownKey)

        guard let timer = timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
    }
}
