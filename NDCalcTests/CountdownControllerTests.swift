//
//  CountdownControllerTests.swift
//  NDCalcTests
//
//  Created by James Warren on 22/7/21.
//

import Combine
import XCTest
@testable import NDCalc

class CountdownControllerTests: XCTestCase {
    var sut: CountdownController<MockNotificationController>!
    var notificationController: MockNotificationController!
    private var cancellables: Set<AnyCancellable> = []

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
        XCTAssertFalse(sut.hasCountdownActive)

        let endDate = Date(timeIntervalSinceNow: 60.0)
        let countdown = try Countdown(endsAt: endDate)

        let countdownArrayPublisher = sut.currentCountdownPublisher.collectNext(1)
        try sut.startCountdown(for: endDate)
        let countdownArray = try awaitPublisher(countdownArrayPublisher)

        XCTAssertEqual(countdownArray[0], countdown)
        XCTAssertTrue(sut.hasCountdownActive)
    }

    func testStartingCountdownSetsNotification() throws {
        XCTAssertFalse(notificationController.hasNotificationScheduled,
                       "notification controller should not start with notification scheduled.")

        let endDate = Date(timeIntervalSinceNow: 60.0)
        try sut.startCountdown(for: endDate)

        XCTAssertTrue(notificationController.hasNotificationScheduled,
                      "notification controller should have notification started.")
        XCTAssertEqual(notificationController.scheduledNotificationDate, endDate,
                       "scheduled notification should be for the same time as the countdown end time.")
    }

    func testCancelingCountdown() throws {
        let endDate = Date(timeIntervalSinceNow: 60.0)
        let countdown = try Countdown(endsAt: endDate)
        XCTAssertFalse(sut.hasCountdownActive, "countdownController should start without a timer started.")

        let expectation = expectation(description: "receive values")
        var values = [Countdown?]()
        let countdownArrayPublisher = sut.currentCountdownPublisher.dropFirst().collect(2).first()
        countdownArrayPublisher.sink { pub in
            values = pub
            expectation.fulfill()
            print("here with value: \(pub)")
        }
        .store(in: &cancellables)
        try sut.startCountdown(for: endDate)
        XCTAssertTrue(sut.hasCountdownActive)

        sut.cancelCountdown()
        XCTAssertFalse(sut.hasCountdownActive)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(values, [countdown, nil])
    }

    func testCancelingCountdownCancelsNotification() throws {
        try testCancelingCountdown()
        XCTAssertFalse(notificationController.hasNotificationScheduled, "notification should be canceled.")
        XCTAssertNil(notificationController.scheduledNotificationDate,
                     "there should be no notification date when countdown is cancelled.")
    }
}
