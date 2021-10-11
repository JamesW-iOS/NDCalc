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
    var shutterSpeeds: [ShutterSpeed] { get set }
    var filterNotation: FilterStrengthRepresentation { get }
    var countdown: Countdown? { get }
    var selectedFilterNotation: FilterStrengthRepresentation { get set }

    func startCountdown()
    func countdownViewButtonTapped()
    func requestNotificationPermission()
}

final class MockHomeViewModel: HomeViewModelProtocol {
    var selectedFilterNotation: FilterStrengthRepresentation
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
    static var defaultSelectedFilter = Filter(strength: 3.0)
    static var defaultShutterSpeed = defaultShutterSpeeds[18]
    static var defaultCalculatedShutterSpeed =
        ShutterSpeed.calculateShutterSpeedWithFilter(shutterSpeed: defaultShutterSpeed,
                                                     filter: defaultSelectedFilter)

    init(selectedFilter: Filter = defaultSelectedFilter,
         selectedShutterSpeed: ShutterSpeed = defaultShutterSpeed,
         hasTimerRunning: Bool = false,
         isValidTime: Bool = true,
         calculatedShutterSpeed: ShutterSpeed = defaultCalculatedShutterSpeed,
         calculatedShutterSpeedString: String = defaultCalculatedShutterSpeed.stringRepresentation,
         timerIsRunning: Bool = false,
         shutterSpeeds: [ShutterSpeed] = defaultShutterSpeeds,
         // swiftlint:disable:next force_try
         countdown: Countdown? = try! Countdown(endsAt: Date(timeIntervalSinceNow: 10.0)),
         selectedFilterNotation: FilterStrengthRepresentation = .stopsReduced) {
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
        self.selectedFilterNotation = selectedFilterNotation
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
