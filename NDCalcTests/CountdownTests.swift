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
}
