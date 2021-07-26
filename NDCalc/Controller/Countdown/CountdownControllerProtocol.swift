//
//  CountdownControllerProtocol.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Foundation
import Combine

/// A protocol that defines the requirements for a Countdown controller object,
/// an object that can start and stop countdowns
protocol CountdownControllerProtocol: ObservableObject {
    /// A publisher for the current countdown that is running, nil if no countdown is running.
    ///
    /// This would ordinarily be an `@Published` marked variable but protocols don't allow for
    /// property wrappers. A useful technique would be to have the following:
    ///
    ///     @Published var currentCountdown: Countdown?
    ///     var currentCountdownPublisher: Published<Countdown?>.Publisher { $currentCountdown }
    var currentCountdownPublisher: Published<Countdown?>.Publisher { get }
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

/// A mock version of a CountdownController, useful for previews, conforms to the
/// `CountdownControllerProtocol`.
final class MockCountdownController: CountdownControllerProtocol {
    /// The currently running countdown.
    ///
    /// Because of not allowing property wrappers in protocols this is kept as a private variable, we then
    /// set the protocol requirement for a publisher to this variables publisher.
    @Published private var currentCountdown: Countdown?

    /// A publisher for the current countdown
    var currentCountdownPublisher: Published<Countdown?>.Publisher { $currentCountdown }

    /// Initialises a `MockCountdownController`, optionally with a specific Countdown
    /// - Parameter countdown: An optional `Countdown` to create the `MockCountdownController` with.
    init(countdown: Countdown?) {
        currentCountdown = countdown
    }

    /// If there is currently a Countdown running
    var hasCountdownActive: Bool {
        if let countdown = currentCountdown {
            return !countdown.isComplete
        } else {
            return false
        }
    }

    /// Empty implementation, here just for protocol conformance
    func startCountdown(for endDate: Date) throws {}

    /// Empty implementation, here just for protocol conformance
    func cancelCountdown() {}
}
