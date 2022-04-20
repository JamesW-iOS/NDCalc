//
//  HomeViewModel.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Combine
import UserNotifications
import AVFoundation
import Depends

@MainActor
final class HomeViewModel: ObservableObject, DependencyProvider {
    let dependencies: DependencyRegistry
    let settingsViewModel: SettingsViewModel
    let countdownViewModel: CountdownCircleViewModel

    /// The currently selected `Filter` in the picker.
    @UserDefault(key: UserDefaultKeys.selectedFilterKey,
                 defaultValue: Filter.filters[0])
    var selectedFilter: Filter {
        didSet {
            objectWillChange.send()
        }
    }
    /// The currently selected `ShutterSpeed` in the picker.
    @UserDefault(key: UserDefaultKeys.selectedShutterSpeedKEy,
                 defaultValue: ShutterSpeed.speedsForGap(.oneStop)[0])
    var selectedShutterSpeed: ShutterSpeed {
        didSet {
            objectWillChange.send()
        }
    }
    /// An array of `ShutterSpeed` to show in the picker, updates based on user preferences.
    @Published var shutterSpeeds = ShutterSpeed.speedsForGap(.oneStop)
    @Published var selectedFilterNotation: FilterStrengthRepresentation = .stopsReduced

    /// Flag to indicate if the Countdown view should be active.
    ///
    /// When true the Countdown view will be placed over the top of the main view.
    @Published var countdownViewActive = false
    /// The current countdown if there is one, `nil` if not.
    @Published var countdown: Countdown?

    /// A reference a PreferenceStore object.
    @Dependency(.preferenceStore) var userPreferences
    /// A reference to the controller for managing starting and stoping countdowns.
    @Dependency(.countdownController) var countdownController
    /// A reference to the notification controller object.
    ///
    /// We need this reference since we need to ask for notification permission.
    @Dependency(.notificationController) var notificationController

    /// Store publishers here.
    private var cancellables = Set<AnyCancellable>()

    /// A formatter for displaying numbers in a nice 'human' format.
    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.usesGroupingSeparator = false
        return formatter
    }()

    init(dependencies: DependencyRegistry) {
        self.dependencies = dependencies
        self.settingsViewModel = SettingsViewModel(dependencies: dependencies)
        self.countdownViewModel = CountdownCircleViewModel(dependencies: dependencies)

        userPreferences.selectedFilterRepresentation.sink { [unowned self] representation in
            selectedFilterNotation = representation
        }
        .store(in: &cancellables)

        userPreferences.selectedShutterSpeedGap.sink { [unowned self] gap in
            shutterSpeeds = ShutterSpeed.speedsForGap(gap)
        }
        .store(in: &cancellables)

        countdownController.currentCountdownPublisher.sink { countdown in
            self.countdown = countdown
            if countdown != nil {
                self.countdownViewActive = true
            }
        }
        .store(in: &cancellables)
    }

    /// Flag that indicates if a countdown is currently running.
    var countdownIsActive: Bool {
        countdownController.hasCountdownActive
    }

    /// A `ShutterSpeed` when the selected `Filter` is applied to the selected `ShutterSpeed`
    var calculatedShutterSpeed: ShutterSpeed {
        return ShutterSpeed.calculateShutterSpeedWithFilter(shutterSpeed: selectedShutterSpeed,
                                                            filter: selectedFilter)
    }

    /// A string representation of the `calculatedShutterSpeed`
    var calculatedShutterSpeedString: String {
        return calculatedShutterSpeed.stringRepresentation
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
