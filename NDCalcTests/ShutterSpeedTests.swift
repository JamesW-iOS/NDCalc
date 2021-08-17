//
//  ShutterSpeedTests.swift
//  NDCalcTests
//
//  Created by James Warren on 23/7/21.
//

import XCTest
@testable import NDCalc

class ShutterSpeedTests: XCTestCase {
    func testFractionalStringRepresentationCorrect() {
        let cases = [(ShutterSpeed(numerator: 1, denominator: 30), "1/30"),
                     (ShutterSpeed(numerator: 30, denominator: 1), "30"),
                     (ShutterSpeed(numerator: 0.7, denominator: 1), "0.7"),
                     (ShutterSpeed(numerator: 1.5, denominator: 1), "1.5")]

        for shutterSpeedCase in cases {
            XCTAssertEqual(shutterSpeedCase.0.stringFractionalRepresentation,
                           shutterSpeedCase.1,
                           "string representation of shutter speed: \(shutterSpeedCase.0.stringFractionalRepresentation) does not match expected: \(shutterSpeedCase.1)")
                           // swiftlint:disable:previous line_length
        }
    }

    func testPropertiesSet() {
        let numerator = 1.0
        let denominator = 30.0
        let shutterSpeed = ShutterSpeed(numerator: numerator, denominator: denominator)

        XCTAssertEqual(shutterSpeed.denominator, denominator)
        XCTAssertEqual(shutterSpeed.numerator, numerator)
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

    /// `ShutterSpeed` uses a number formatter to get it's strings and therefore the output can change depending
    /// on the locale This test may fail if the simulator it is being run on is not the same one the test is meant for.
    func testStringRepresentationCorrect() {
        let cases = [(ShutterSpeed(numerator: 1, denominator: 30), "Less than one second"),
                     (ShutterSpeed(numerator: 30, denominator: 1), "30s"),
                     (ShutterSpeed(numerator: 64, denominator: 1), "1m 4s"),
                     (ShutterSpeed(numerator: 65535, denominator: 1), "18h 12m 15s")]

        for shutterSpeedCase in cases {
            XCTAssertEqual(shutterSpeedCase.0.stringRepresentation,
                           shutterSpeedCase.1,
                           "string representation of shutter speed: \(shutterSpeedCase.0.stringRepresentation) does not match expected: \(shutterSpeedCase.1)")
            // swiftlint:disable:previous line_length
        }
    }
}
