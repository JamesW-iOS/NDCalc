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
    static let allDoneString = "All done"

    let dependencies: DependencyRegistry

    @Dependency(.countdownController) var countdownController: CountdownControllerProtocol

    @Published private(set) var completionAmount: Double
    @Published private(set) var circleReseting: Bool
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

        completionAmount = 1.0
        circleReseting = true
        secondsLeft = Self.allDoneString

        countdownController.currentCountdownPublisher
            .sink { [unowned self] countdown in
                if let countdown = countdown {
                    completionAmount = 0.0
                    circleReseting = false
                    secondsLeft = countdown.stringSecondsLeft
                    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                        guard let countdown = self?.countdownController.currentCountdownPublisher.value else {
                            assertionFailure("Should not fire without seconds left")
                            return
                        }

                        self?.secondsLeft = countdown.stringSecondsLeft
                    }
                } else {
                    circleReseting = true
                    completionAmount = 1.0

                    timer?.invalidate()
                    secondsLeft = Self.allDoneString
                }
            }
            .store(in: &cancellables)
    }
}
