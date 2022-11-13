//
//  CountdownCircleViewModel.swift
//  NDCalc
//
//  Created by Personal James on 10/4/2022.
//

import AVKit
import Combine
import Depends
import Foundation

final class CountdownCircleViewModel: ObservableObject, DependencyProvider {
    struct CircleAnimation: Equatable {
        let from: Double
        let over: TimeInterval
        let reseting: Bool
    }

    static let allDoneString = "All done"

    let dependencies: DependencyRegistry

    @Dependency(.countdownController) var countdownController: CountdownControllerProtocol

    @Published private(set) var circleAnimation: CircleAnimation?

//    @Published private(set) var completionAmount: Double
//    @Published private(set) var circleReseting: Bool
    @Published private(set) var secondsLeft: String
    private var cancellables = Set<AnyCancellable>()

    var timer: Timer?

    var animationDuration: Double {
        if let countdown = countdownController.currentCountdownPublisher.value {
            return countdown.secondsLeft
        } else {
            // Reseting circle duration
            return 0.7
        }
    }

    init(dependencies: DependencyRegistry) {
        self.dependencies = dependencies

//        completionAmount = 1.0
//        circleReseting = true
        secondsLeft = Self.allDoneString

        Task {
            try? await Task.sleep(nanoseconds: 1_000_000)
            proccesCountdown(countdownController.currentCountdownPublisher.value)
        }


        countdownController.currentCountdownPublisher
            .dropFirst()
            .print()
            .sink { [unowned self] in proccesCountdown($0) }
            .store(in: &cancellables)
    }

    private func proccesCountdown(_ countdown: Countdown?) {
        print("Proccessing countdown: \(countdown)")

        if let countdown = countdown {
            print("New animation")
            circleAnimation = .init(from: countdown.completionAmount, over: countdown.secondsLeft, reseting: false)
            secondsLeft = countdown.stringSecondsLeft
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let countdown = self?.countdownController.currentCountdownPublisher.value else {
                    assertionFailure("Should not fire without seconds left")
                    return
                }

                self?.secondsLeft = countdown.stringSecondsLeft
            }
        } else {
            //                    circleReseting = true
            //                    completionAmount = 1.0
            circleAnimation = .init(from: 0, over: 0.7, reseting: true)

            timer?.invalidate()
            secondsLeft = Self.allDoneString
        }
    }
}
