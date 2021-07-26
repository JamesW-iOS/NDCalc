//
//  HomeViewModel.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Combine
import UserNotifications
import AVFoundation

final class HomeViewModel<Preference, CountdownCon, NotificationCon>: HomeViewModelProtocol where
    Preference: PreferenceStoreProtocol,
    CountdownCon: CountdownControllerProtocol,
    NotificationCon: NotificationControllerProtocol {

    /// The currently selected `Filter` in the picker.
    @Published var selectedFilter: Filter
    /// The currently selected `ShutterSpeed` in the picker.
    @Published var selectedShutterSpeed: ShutterSpeed
    /// Flag to indicate if the Countdown view should be active.
    ///
    /// When true the Countdown view will be placed over the top of the main view.
    @Published var countdownViewActive = false
    /// The current countdown if there is one, `nil` if not.
    @Published var countdown: Countdown?

    /// A reference a PreferenceStore object.
    let userPreferences: Preference
    /// A reference to the controller for managing starting and stoping countdowns.
    let countdownController: CountdownCon
    /// A reference to the notification controller object.
    ///
    /// We need this reference since we need to ask for notification permission.
    let notificationController: NotificationCon

    /// Store publishers here.
    private var cancellables: Set<AnyCancellable> = []

    /// A formatter for displaying numbers in a nice 'human' format.
    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.usesGroupingSeparator = false
        return formatter
    }()

    init(userPreferences: Preference = DIContainer.shared.resolve(type: Preference.self)!,
         countdownController: CountdownCon = DIContainer.shared.resolve(type: CountdownCon.self)!,
         notificationController: NotificationCon = DIContainer.shared.resolve(type: NotificationCon.self)!) {
        self.userPreferences = userPreferences
        self.countdownController = countdownController
        self.notificationController = notificationController
        self.selectedShutterSpeed = ShutterSpeed.speedsForGap(userPreferences.selectedShutterSpeedGap)[0]
        self.selectedFilter = Filter.filters[0]

        /// When the PreferenceStore changes we need to update our view, lookout for changes and send an update here.
        userPreferences.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
        .store(in: &cancellables)

        countdownController.currentCountdownPublisher.sink { countdown in
            self.countdown = countdown
            if countdown == nil {
                // self.countdownViewActive = false
            } else {
                self.countdownViewActive = true
            }
        }
        .store(in: &cancellables)
    }

    /// Flag that indicates if a countdown is currently running.
    var countdownIsActive: Bool {
        countdownController.hasCountdownActive
    }

    /// An array of `ShutterSpeed` to show in the picker, updates based on user preferences.
    var shutterSpeeds: [ShutterSpeed] {
        ShutterSpeed.speedsForGap(userPreferences.selectedShutterSpeedGap)
    }

    /// A `ShutterSpeed` when the selected `Filter` is applied to the selected `ShutterSpeed`
    var calculatedShutterSpeed: ShutterSpeed {
        return ShutterSpeed.calculateShutterSpeedWithFilter(shutterSpeed: selectedShutterSpeed,
                                                            filter: selectedFilter)
    }

    /// A string representation of the `calculatedShutterSpeed`
    var calculatedShutterSpeedString: String {
        if calculatedShutterSpeed.seconds < 1 {
            return "Less than 1s"
        } else {
            if calculatedShutterSpeed.seconds > 60 {
                let minutes = numberToString(calculatedShutterSpeed.seconds / 60)
                let seconds = numberToString(calculatedShutterSpeed.seconds.remainder(dividingBy: 60.0))
                return "\(minutes)m \(seconds)s"
            }
            return "\(numberToString(calculatedShutterSpeed.seconds))s"
        }

    }

    /// A flag that shows if the currently selected `ShutterSpeed` is a valid one to start a timer with
    ///
    /// A `ShutterSpeed` is determined to be valid if the calculated exposure will be longer than one second when
    /// applying the selected `Filter`
    var isCurrentTimeValid: Bool {
        calculatedShutterSpeed.seconds >= 1
    }

    /// Start a countdown to finish after the `calculatedShutterSpeed` has finished.
    func startCountdown() {
        do {
            let timerEndDate = Date(timeIntervalSinceNow: Double(calculatedShutterSpeed.seconds))
            try countdownController.startCountdown(for: timerEndDate)
        } catch {
            return
        }
    }

    /// Cancel the current countdown if there is one running.
    func countdownViewButtonTapped() {
        if countdown != nil {
            countdown = nil
            countdownController.cancelCountdown()
        }
        countdownViewActive = false
    }

    ///  Request notification permission.
    func requestNotificationPermission() {
        notificationController.requestNotificationPermission()
    }

    /// Convert a number to a nice 'human' representation.
    private func numberToString(_ number: Double) -> String {
        guard let string = formatter.string(from: NSNumber(value: number)) else {
            assertionFailure("failed to convert numerator to string")
            return "Error"
        }

        return string
    }
}
