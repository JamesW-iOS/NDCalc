//
//  CountdownControllerProtocol.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Foundation
import Combine

protocol CountdownControllerProtocol: ObservableObject {
    var currentCountdownPublisher: Published<Countdown?>.Publisher { get }
    var hasActiveTimer: Bool { get }

    func startCountdown(for endDate: Date) throws
    func cancelCountdown()
}

final class MockCountdownController: CountdownControllerProtocol {
    @Published var currentCountdown: Countdown?

    var currentCountdownPublisher: Published<Countdown?>.Publisher { $currentCountdown }

    init(countdown: Countdown?) {
        currentCountdown = countdown
    }

    var hasActiveTimer: Bool {
        if let countdown = currentCountdown {
            return !countdown.isComplete
        } else {
            return false
        }
    }


    func startCountdown(for endDate: Date) throws {
    }

    func cancelCountdown() {
    }


}
