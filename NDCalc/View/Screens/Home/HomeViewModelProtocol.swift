//
//  HomeViewModelProtocol.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Combine
import Foundation

protocol HomeViewModelProtocol: ObservableObject {
    var selectedFilter: Filter { get set }
    var selectedShutterSpeed: ShutterSpeed { get set }
    var countdownViewActive: Bool { get set }
    var countdownIsActive: Bool { get }
    var isCurrentTimeValid: Bool { get }
    var calculatedShutterSpeed: ShutterSpeed { get }
    var calculatedShutterSpeedString: String { get }
    var shutterSpeeds: [ShutterSpeed] { get }
    var filterNotation: FilterStrengthRepresentation { get }
    var countdown: Countdown? { get }

    func startCountdown()
    func countdownViewButtonTapped()
    func requestNotificationPermission()
}

final class MockHomeViewModel: HomeViewModelProtocol {
    var selectedFilter: Filter
    var selectedShutterSpeed: ShutterSpeed
    var nextTimer: Double?
    var countdownViewActive: Bool
    var isCurrentTimeValid: Bool
    var calculatedShutterSpeed: ShutterSpeed
    var calculatedShutterSpeedString: String
    var countdownIsActive: Bool
    var shutterSpeeds: [ShutterSpeed]
    var filterNotation: FilterStrengthRepresentation
    var countdown: Countdown?

    static var defaultShutterSpeeds = ShutterSpeed.speedsForGap(.oneStop)

    init(selectedFilter: Filter = Filter(strength: 1),
         selectedShutterSpeed: ShutterSpeed = defaultShutterSpeeds[0],
         hasTimerRunning: Bool = false,
         isValidTime: Bool = true,
         calculatedShutterSpeed: ShutterSpeed =
            ShutterSpeed.calculateShutterSpeedWithFilter(shutterSpeed: defaultShutterSpeeds[0],
                                                      filter: Filter(strength: 1)),
         calculatedShutterSpeedString: String = "10s",
         timerIsRunning: Bool = false,
         shutterSpeeds: [ShutterSpeed] = defaultShutterSpeeds,
         // swiftlint:disable:next force_try
         countdown: Countdown? = try! Countdown(endsAt: Date(timeIntervalSinceNow: 10.0))) {
        self.selectedFilter = selectedFilter
        self.selectedShutterSpeed = selectedShutterSpeed
        self.countdownViewActive = hasTimerRunning
        self.isCurrentTimeValid = isValidTime
        self.calculatedShutterSpeed = calculatedShutterSpeed
        self.calculatedShutterSpeedString = calculatedShutterSpeedString
        self.countdownIsActive = timerIsRunning
        self.shutterSpeeds = shutterSpeeds
        self.countdown = countdown
        self.filterNotation = .stopsReduced
    }

    func startCountdown() {
        print("Timer started")
    }

    func countdownViewButtonTapped() {
        print("Timer stoped")
    }

    func requestNotificationPermission() {
    }
}
