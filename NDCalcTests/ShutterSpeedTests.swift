//
//  ShutterSpeedTests.swift
//  NDCalcTests
//
//  Created by James Warren on 23/7/21.
//

import XCTest
@testable import NDCalc

class ShutterSpeedTests: XCTestCase {
    func testStringRepresentationCorrect() {
        let cases = [(ShutterSpeed(numerator: 1, denominator: 30), "1/30"),
                     (ShutterSpeed(numerator: 30, denominator: 1), "30"),
                     (ShutterSpeed(numerator: 0.7, denominator: 1), "0.7"),
                     (ShutterSpeed(numerator: 1.5, denominator: 1), "1.5")]

        for shutterSpeedCase in cases {
            XCTAssertEqual(shutterSpeedCase.0.stringRepresentation,
                           shutterSpeedCase.1,
                           "string representation of shutter speed: \(shutterSpeedCase.0.stringRepresentation) does not match expected: \(shutterSpeedCase.1)")
                           // swiftlint:disable:previous line_length
        }
    }

    func testShutterSpeedsForGap() {
        let shutterSpeeds = Bundle.main.decode([[ShutterSpeed]].self, from: "shutterSpeeds.json")
        let oneStopSpeeds = shutterSpeeds[0]
        let halfStopSpeeds = shutterSpeeds[1]
        let thirdStopSpeeds = shutterSpeeds[2]

        XCTAssertEqual(oneStopSpeeds, ShutterSpeed.speedsForGap(.oneStop))
        XCTAssertEqual(halfStopSpeeds, ShutterSpeed.speedsForGap(.halfStop))
        XCTAssertEqual(thirdStopSpeeds, ShutterSpeed.speedsForGap(.thirdStop))
    }

    func testShutterGapStringRepresentation() {
        XCTAssertEqual(ShutterGap.oneStop.rawValue, "One Stop")
        XCTAssertEqual(ShutterGap.halfStop.rawValue, "Half Stop")
        XCTAssertEqual(ShutterGap.thirdStop.rawValue, "Third Stop")
    }
}
