//
//  CountdownControllerTests.swift
//  NDCalcTests
//
//  Created by James Warren on 22/7/21.
//

import XCTest
@testable import NDCalc

class CountdownControllerTests: XCTestCase {
    var sut: CountdownController<MockNotificationController>!
    var notificationController: MockNotificationController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        notificationController = MockNotificationController()
        sut = CountdownController(notificationController: notificationController!)
    }

    override func tearDownWithError() throws {
        notificationController = nil
        sut = nil
    }

    func testStartCountdown() throws {
        let endDate = Date(timeIntervalSinceNow: 60.0)
        let countdown = try Countdown(endsAt: endDate)

        try startCountdown(for: endDate)

        XCTAssertTrue(sut.hasCountdownActive)
        // XCTAssertEqual(countdown, sut.currentCountdown)
    }

    func testStartingCountdownSetsNotification() throws {
        XCTAssertFalse(notificationController.hasNotificationScheduled,
                       "notification controller should not start with notification scheduled.")

        let endDate = Date(timeIntervalSinceNow: 60.0)
        let countdown = try Countdown(endsAt: endDate)

        try startCountdown(for: endDate)

        XCTAssertTrue(sut.hasCountdownActive, "hasActiveTimer should be true after starting a countdown.")
        // XCTAssertEqual(countdown, sut.currentCountdown, "currentCountdown should be equal to the one started.")
        XCTAssertTrue(notificationController.hasNotificationScheduled,
                      "notification controller should have notification started.")
        XCTAssertEqual(notificationController.scheduledNotificationDate, endDate,
                       "scheduled notification should be for the same time as the countdown end time.")
    }

    func testCancelingCountdown() throws {
        try testStartCountdown()
        sut.cancelCountdown()

        XCTAssertFalse(sut.hasCountdownActive, "countdownController should not have timer running after canceling.")
        //XCTAssertNil(sut.currentCountdown, "countdownController should not have a Countdown object after canceling.")
    }

    func testCancelingCountdownCancelsNotification() throws {
        try testCancelingCountdown()
        XCTAssertFalse(notificationController.hasNotificationScheduled, "notification should be canceled.")
        XCTAssertNil(notificationController.scheduledNotificationDate,
                     "there should be no notification date when countdown is cancelled.")
    }

    private func startCountdown(for endDate: Date) throws {
        XCTAssertFalse(sut.hasCountdownActive, "countdownController should start without a timer started.")
        //XCTAssertNil(sut.currentCountdown, "countdownController should not start with a Countdown object.")

        try sut.startCountdown(for: endDate)
    }
}
