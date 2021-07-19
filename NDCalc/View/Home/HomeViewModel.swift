//
//  HomeViewModel.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Combine
import UserNotifications
import AVFoundation

final class HomeViewModel<Preference, CountdownCon>: HomeViewModelProtocol where Preference: PreferenceControllerProtocol, CountdownCon: CountdownControllerProtocol {
    @Published var selectedFilterIndex = 0
    @Published var selectedShutterSpeed: ShutterSpeed
    let userPreferences: Preference
    let countdownController: CountdownCon

    private var cancellables: Set<AnyCancellable> = []

//    var nextTimer: Double? {
//        didSet {
//            if nextTimer == nil {
//                timerViewActive = false
//            } else {
//                timerViewActive = true
//            }
//        }
//    }

    @Published var timerViewActive = false
    @Published var countdown: Countdown?

    private var notificationIdentifier: String?


    init(userPreferences: Preference = DIContainer.shared.resolve(type: Preference.self)!, countdownController: CountdownCon = DIContainer.shared.resolve(type: CountdownCon.self)!) {
        self.userPreferences = userPreferences
        self.countdownController = countdownController
        self.selectedShutterSpeed =  ShutterSpeed.speedsForGap(userPreferences.selectedShutterSpeedGap)[0]

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
        countdownController.hasActiveTimer
    }

    var shutterSpeeds: [ShutterSpeed] {
        ShutterSpeed.speedsForGap(userPreferences.selectedShutterSpeedGap)
    }

    var calculatedShutterSpeed: ShutterSpeed {
        //print("filter multiple \(filters[selectedFilterIndex].value)")
        //print("Numerator \(Self.shutterSpeeds[shutterIntervalIndex][selectedExposureIndex].numerator)")
        let newNumer = selectedShutterSpeed.numerator * Int((pow(2.0, Double(Filter.filters[selectedFilterIndex].value))))

        return  ShutterSpeed(numerator: newNumer, denominator: selectedShutterSpeed.denominator)
    }

    var calculatedShutterSpeedString: String {
        if calculatedShutterSpeed.seconds < 1 {
            return "Less than 1s"
        } else {
            if calculatedShutterSpeed.seconds > 60 {
                return "\(calculatedShutterSpeed.seconds / 60)m \(calculatedShutterSpeed.seconds % 60)s"
            }
            return "\(calculatedShutterSpeed.seconds)s"
        }

    }

    var isValidTime: Bool {
        calculatedShutterSpeed.seconds >= 1
    }

    var currentTimeInFuture: Bool {
        Date(timeIntervalSinceNow: Double(calculatedShutterSpeed.seconds)).isInFuture
    }



    func startTimer() {
        do {
            try countdownController.startCountdown(for: Date(timeIntervalSinceNow: Double(calculatedShutterSpeed.seconds)))
        } catch {
            //TODO: add error handling here
            return
        }
//        timerIsRunning = true
//
//        let centre = UNUserNotificationCenter.current()
//
//        let content = UNMutableNotificationContent()
//        content.title = "Exposure finished"
//        content.body = "Your exposure has finished"
//        content.sound = UNNotificationSound.defaultCritical
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(calculatedShutterSpeed.seconds), repeats: false)
//        let identifier = UUID().uuidString
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        notificationIdentifier = identifier
//
//        centre.add(request) { (error) in
//            if let error = error {
//                print("error while scheduling notification: \(error.localizedDescription)")
//            }
//        }
//        let timerAlertTime = Date(timeIntervalSinceNow: Double(calculatedShutterSpeed.seconds)).timeIntervalSince1970
//        self.nextTimer = timerAlertTime
//
//        timer = Timer.scheduledTimer(withTimeInterval: Double(calculatedShutterSpeed.seconds), repeats: false) { _ in
//            self.timerIsRunning = false
//            Vibration.error.vibrate()
//        }
    }

    func cancelTimer() {
//        nextTimer = nil
//        timerIsRunning = false
//        guard let timer = timer else {
//            return
//        }
//        timer.invalidate()
//        self.timer = nil

        countdownController.cancelCountdown()
    }

    func requestNotificationPermission() {
        NotificationController.requestNotificationPermission()
    }
}
