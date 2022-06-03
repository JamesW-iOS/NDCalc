//
//  CountdownControllerProtocol.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Foundation
import Combine
import Depends

/// A protocol that defines the requirements for a Countdown controller object,
/// an object that can start and stop countdowns
protocol CountdownControllerProtocol {
    /// A publisher for the current countdown that is running, nil if no countdown is running.
    ///
    /// This would ordinarily be an `@Published` marked variable but protocols don't allow for
    /// property wrappers. A useful technique would be to have the following:
    ///
    ///     @Published var currentCountdown: Countdown?
    ///     var currentCountdownPublisher: Published<Countdown?>.Publisher { $currentCountdown }
    var currentCountdownPublisher: CurrentValueSubject<Countdown?, Never> { get }
    /// If there is currently a countdown running
    var hasCountdownActive: Bool { get }

    /// Start a countdown to end at a specific time.
    /// - Parameter for: The time at which the countdown will end.
    /// - Throws: `CountdownError.invalidEndTime`
    ///            if `for` is the current time or in the past.
    func startCountdown(for endDate: Date) throws
    /// Cancel the current countdown.
    func cancelCountdown()
}

extension DependencyKey where DependencyType == CountdownControllerProtocol {
    static let countdownController = DependencyKey(default: MockCountdownController())
}

/// A mock version of a CountdownController, useful for previews, conforms to the
/// `CountdownControllerProtocol`.
public final class MockCountdownController: CountdownControllerProtocol, ObservableObject {
    var currentCountdownPublisher: CurrentValueSubject<Countdown?, Never>

    /// Initialises a `MockCountdownController`, optionally with a specific Countdown
    /// - Parameter countdown: An optional `Countdown` to create the `MockCountdownController` with.
    init(countdown: Countdown? = nil) {
//        currentCountdown = countdown
        currentCountdownPublisher = CurrentValueSubject(nil)
    }

    /// If there is currently a Countdown running
    var hasCountdownActive: Bool {
        if let countdown = currentCountdownPublisher.value {
            return !countdown.isComplete
        } else {
            return false
        }
    }

    /// Empty implementation, here just for protocol conformance
    func startCountdown(for endDate: Date) throws {
        let countDown = try Countdown(endsAt: endDate)
        currentCountdownPublisher.send(countDown)
    }

    /// Empty implementation, here just for protocol conformance
    func cancelCountdown() {
        currentCountdownPublisher.send(nil)
    }
}
