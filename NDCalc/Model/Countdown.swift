//
//  Countdown.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import Foundation

enum CountdownError: Error, CustomStringConvertible {
    case invalidEndTime

    var description: String {
        switch self {
        case .invalidEndTime:
            return "End time must be in the future."
        }
    }
}

struct Countdown {
    let finishTime: Date
    private let startedAt = Date()

    var secondsLeft: Double {
        Date().distance(to: finishTime)
    }

    var completionAmount: Double {
        let totalTime = startedAt.distance(to: finishTime)
        return secondsLeft / totalTime
    }

    var isComplete: Bool {
        !finishTime.isInFuture
    }

    init(endsAt: Date) throws {
        if endsAt <= Date() {
            throw CountdownError.invalidEndTime
        }

        finishTime = endsAt
    }
}
