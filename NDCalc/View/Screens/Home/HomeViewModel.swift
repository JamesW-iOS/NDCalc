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

    @Published var selectedFilter: Filter
    @Published var selectedShutterSpeed: ShutterSpeed
    @Published var timerViewActive = false
    @Published var countdown: Countdown?

    let userPreferences: Preference
    let countdownController: CountdownCon
    let notificationController: NotificationCon

    private var cancellables: Set<AnyCancellable> = []
    private var notificationIdentifier: String?

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
        self.selectedShutterSpeed =  ShutterSpeed.speedsForGap(userPreferences.selectedShutterSpeedGap)[0]
        self.selectedFilter = Filter.filters[0]

        userPreferences.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
        .store(in: &cancellables)

        countdownController.currentCountdownPublisher.sink { countdown in
            self.countdown = countdown
            if countdown == nil {
                self.timerViewActive = false
            } else {
                self.timerViewActive = true
            }
        }
        .store(in: &cancellables)
    }

    var timerIsRunning: Bool {
        countdownController.hasCountdownActive
    }

    var shutterSpeeds: [ShutterSpeed] {
        ShutterSpeed.speedsForGap(userPreferences.selectedShutterSpeedGap)
    }

    var calculatedShutterSpeed: ShutterSpeed {
        return ShutterSpeed.calculateShutterSpeedWithFilter(shutterSpeed: selectedShutterSpeed,
                                                            filter: selectedFilter)
    }

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

    var isCurrentTimeValid: Bool {
        calculatedShutterSpeed.seconds >= 1
    }

    var currentTimeInFuture: Bool {
        Date(timeIntervalSinceNow: Double(calculatedShutterSpeed.seconds)).isInFuture
    }

    func startCountdown() {
        do {
            let timerEndDate = Date(timeIntervalSinceNow: Double(calculatedShutterSpeed.seconds))
            try countdownController.startCountdown(for: timerEndDate)
        } catch {
            return
        }
    }

    func cancelCountdown() {
        countdownController.cancelCountdown()
    }

    func requestNotificationPermission() {
        notificationController.requestNotificationPermission()
    }

    private func numberToString(_ number: Double) -> String {
        guard let string = formatter.string(from: NSNumber(value: number)) else {
            assertionFailure("failed to convert numerator to string")
            return "Error"
        }

        return string
    }
}
