//
//  HomeViewModelProtocol.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Combine
import Foundation

protocol HomeViewModelProtocol: ObservableObject {
    var selectedFilterIndex: Int { get set }
    var selectedShutterSpeed: ShutterSpeed { get set }
//    var nextTimer: Double? { get set }
    var timerViewActive: Bool { get set }
    var timerIsRunning: Bool { get }
    var isValidTime: Bool { get }
    var currentTimeInFuture: Bool { get }
    var calculatedShutterSpeed: ShutterSpeed { get }
    var calculatedShutterSpeedString: String { get }
    var shutterSpeeds: [ShutterSpeed] { get }
    var countdown: Countdown? { get }

    func startTimer()
    func cancelTimer()
    func requestNotificationPermission()
}

final class MockHomeViewModel: HomeViewModelProtocol {
    var selectedFilterIndex: Int
    var selectedShutterSpeed: ShutterSpeed
    var nextTimer: Double?
    var timerViewActive: Bool
    var isValidTime: Bool
    var currentTimeInFuture: Bool
    var calculatedShutterSpeed: ShutterSpeed
    var calculatedShutterSpeedString: String
    var timerIsRunning: Bool
    var shutterSpeeds: [ShutterSpeed]
    var countdown: Countdown?

    init(selectedFilterIndex: Int = 0,
         selectedShutterSpeed: ShutterSpeed = ShutterSpeed(numerator: 1, denominator: 30),
         hasTimerRunning: Bool = false,
         isValidTime: Bool = true,
         currentTimeInFuture: Bool = true,
         calculatedShutterSpeed: ShutterSpeed = ShutterSpeed(numerator: 2, denominator: 1),
         calculatedShutterSpeedString: String = "10s",
         timerIsRunning: Bool = false,
         shutterSpeeds: [ShutterSpeed] = [],
         // swiftlint:disable:next force_try
         countdown: Countdown? = try! Countdown(endsAt: Date(timeIntervalSinceNow: 10.0))) {
        self.selectedFilterIndex = selectedFilterIndex
        self.selectedShutterSpeed = selectedShutterSpeed
        self.timerViewActive = hasTimerRunning
        self.isValidTime = isValidTime
        self.currentTimeInFuture = currentTimeInFuture
        self.calculatedShutterSpeed = calculatedShutterSpeed
        self.calculatedShutterSpeedString = calculatedShutterSpeedString
        self.timerIsRunning = timerIsRunning
        self.shutterSpeeds = shutterSpeeds
        self.countdown = countdown
    }

    func startTimer() {
        print("Timer started")
    }

    func cancelTimer() {
        print("Timer stoped")
    }

    func requestNotificationPermission() {
    }
}
