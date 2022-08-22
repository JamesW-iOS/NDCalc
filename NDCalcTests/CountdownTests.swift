//
//  CountdownTests.swift
//  NDCalcTests
//
//  Created by James Warren on 23/7/21.
//

import XCTest
@testable import NDCalc

class CountdownTests: XCTestCase {
    func testInvalidDateThrows() {
        let invalidDate = Date(timeIntervalSinceNow: -60.0)
        assert(try Countdown(endsAt: invalidDate), throws: CountdownError.invalidEndTime)
    }

    func testFinishTimeSet() throws {
        let futureDate = Date(timeIntervalSinceNow: 60.0)
        let countdown = try Countdown(endsAt: futureDate)

        XCTAssertEqual(countdown.finishTime, futureDate, "futureDate should be set to what countdown was started with")
    }

    func testIsComplete() throws {
        let futureDate = Date(timeIntervalSinceNow: 0.1)
        let countdown = try Countdown(endsAt: futureDate)

        XCTAssertEqual(countdown.finishTime, futureDate, "futureDate should be set to what countdown was started with")
        XCTAssertFalse(countdown.isComplete)
    }

    func testEquality() throws {
        let oneSecond = Date(timeIntervalSinceNow: 1)
        let onePointOneSecond = Date(timeIntervalSinceNow: 1.1)
        let oneMinute = Date(timeIntervalSinceNow: 60)

        let oneSecondCountdown = try Countdown(endsAt: oneSecond)
        let onePointOneSecondCountdown = try Countdown(endsAt: onePointOneSecond)
        let oneMinuteCountdown = try Countdown(endsAt: oneMinute)

        XCTAssertEqual(oneSecondCountdown, oneSecondCountdown)
        XCTAssertEqual(oneMinuteCountdown, oneMinuteCountdown)

        XCTAssertEqual(onePointOneSecondCountdown, onePointOneSecondCountdown)
        XCTAssertNotEqual(oneSecondCountdown, onePointOneSecondCountdown)
        XCTAssertNotEqual(onePointOneSecondCountdown, oneSecondCountdown)

        XCTAssertNotEqual(oneSecondCountdown, oneMinuteCountdown)
        XCTAssertNotEqual(oneMinuteCountdown, oneSecondCountdown)
    }
}
