//
//  NotificationController.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import ActivityKit
import Combine
import Depends
import UserNotifications

/// An implementation of the `NotificationControllerProtocol`, an object that manages scheduling notification.
final class NotificationController: NotificationControllerProtocol, DependencyProvider {
    let dependencies: DependencyRegistry

    /// A reference to an object that conforms to the `UserNotificationCenter` protocol
    ///
    /// This is almost always the system `UNUserNotificationCenter` except in the case of testing.
    @Dependency(.notificationCenter) private var centre
    @Dependency(.userDefaults) private var userDefaults

    /// A flag indicating if the controller currently has a notification scheduled.
    var hasNotificationScheduled = false

    private(set) var notificationIdentifier: String? {
        get {
            userDefaults.string(forKey: Self.savedNotifationIDKey)
        }

        set {
            userDefaults.set(newValue, forKey: Self.savedNotifationIDKey)
        }
    }

    private var timerActivity: Activity<TimerActivityAttributes>?
    private var endTimer: Timer?

    /// Initialise a `NotificationController`, optionally with a `UserNotificationCenter` object
    /// - Parameter notificationCentre: An object that handles actually scheduling notifications, this is almost always
    /// the  system `UNUserNotificationCenter`, this should only be overridden for testing.
    init(dependancies: DependencyRegistry) {
        self.dependencies = dependancies
    }

    /// Schedule a notification to be delivered at a particular time.
    ///
    /// - Parameter for: The time at which the notification should be delivered.
    func scheduleNotification(with attributes: TimerActivityAttributes) {
        let initialContentState = TimerActivityAttributes.ContentState(isRunning: true)

        do {
            Task {
                for activity in Activity<TimerActivityAttributes>.activities {
                    await activity.end(dismissalPolicy: .immediate)
                }
            }

            timerActivity = try Activity<TimerActivityAttributes>.request(
                attributes: attributes,
                contentState: initialContentState
            )

            let now = Date()

            endTimer = Timer.scheduledTimer(
                withTimeInterval: now.distance(to: attributes.timerEnd),
                repeats: false
            ) { [weak self] _ in
                guard let self else {
                    return
                }
                self.endTimer = nil
                Task {
                    guard let timerActivity = self.timerActivity else {
                        //                        assertionFailure("timer activity should still be active")
                        return
                    }

                    print("here")

                    let update = TimerActivityAttributes.ContentState(isRunning: false)
                    await timerActivity.end(using: update, dismissalPolicy: .after(Date().addingTimeInterval(60 * 5)))
                }
            }
        } catch {
            print("failed to schedule activity")
        }
    }

    /// Cancel the currently scheduled notification if there is one.
    func cancelNotification() {
        Task {
            for activity in Activity<TimerActivityAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }

            self.timerActivity = nil
            self.endTimer = nil
        }
    }

    /// Request notification permission from the `UserNotificationCenter`, usually the system.
    func requestNotificationPermission() {
        centre.requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error {
                fatalError("error while requesting notification: \(error.localizedDescription)")
            }
        }
    }

    func getNotificationPermission() async -> NotificationSettings {
        let settings = await centre.notificationSettings()

        return .init(
            timeSensitiveSetting: .init(setting: settings.timeSensitiveSetting),
            authorizationStatus: .init(status: settings.authorizationStatus),
            lockScreenSetting: .init(setting: settings.lockScreenSetting),
            soundSetting: .init(setting: settings.soundSetting)
        )
    }

    func clearAllDeliveredNotifications() {
        centre.removeAllDeliveredNotifications()
    }

    static let notificationTitle = "Exposure finished"
    static let notificationBody = "Your exposure has finished"

    static let savedNotifationIDKey = "notificationKey"
}
