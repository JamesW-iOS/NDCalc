//
//  Countdown.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Foundation

/// Errors that the Countdown model object might throw
enum CountdownError: Error, CustomStringConvertible, Equatable {
    /// This error is thrown in the case that the end time for a countdown is invalid,
    /// due to the end time being the current time or in the past.
    case invalidEndTime

    var description: String {
        switch self {
        case .invalidEndTime:
            return "End time must be in the future."
        }
    }
}

/// A model to store a Countdown to a particular time.
struct Countdown: Equatable {
    /// The time that `Countdown` will end.
    let finishTime: Date
    /// The time that the `Countdown` was started.
    private let startedAt = Date()

    /// The number of seconds left till the finish time of the `Countdown`.
    var secondsLeft: Double {
        Date().distance(to: finishTime)
    }

    /// The proportion of the Countdown that is finished, represented as a decimal number with 1.0 being
    /// complete and 0.0 being the very start
    var completionAmount: Double {
        let totalTime = startedAt.distance(to: finishTime)
        return secondsLeft / totalTime
    }

    /// If the current `Countdown` is complete, past the endTime
    var isComplete: Bool {
        !finishTime.isInFuture
    }

    /// Initiialises a `Countdown` to end at a particular time.
    /// - Parameter endsAt: The exact time at which the `Countdown` will end.
    init(endsAt: Date) throws {
        if endsAt <= Date() {
            throw CountdownError.invalidEndTime
        }

        finishTime = endsAt
    }

    static func == (lhs: Countdown, rhs: Countdown) -> Bool {
        return lhs.finishTime == rhs.finishTime
    }
}
