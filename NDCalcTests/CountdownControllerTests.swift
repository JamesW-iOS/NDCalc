//
//  CountdownControllerTests.swift
//  NDCalcTests
//
//  Created by James Warren on 22/7/21.
//

import Combine
import CombineExpectations
import Depends
import XCTest
@testable import NDCalc

class CountdownControllerTests: XCTestCase {
    var countdownController: CountdownController!
    var dependancies: DependencyRegistry!
    var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        dependancies = DependencyRegistry()
        let notificationController = MockNotificationController()
        dependancies.register(notificationController, for: .notificationController)
        let applicationStore = MockApplicationStateStore()
        dependancies.register(applicationStore, for: .applicationState)

        userDefaults = UserDefaults.init(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)

        countdownController = CountdownController(
            dependancies: dependancies,
            userDefaults: userDefaults
        )
    }

    override func tearDownWithError() throws {
        countdownController = nil
        dependancies = nil
    }

    func testHasCountdownActive_IsTrue_WhenCountdownActive() {
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        do {
            try countdownController.startCountdown(for: endDate)
        } catch {
            XCTFail("Threw while trying to start countdown")
        }

        XCTAssertTrue(countdownController.hasCountdownActive)
    }

    func testStartingCountdown_endDateIsPersisted() throws {
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        try countdownController.startCountdown(for: endDate)

        let persistedEndTime = userDefaults.double(forKey: CountdownController.storeCountdownKey)
        XCTAssertEqual(persistedEndTime, endDate.timeIntervalSince1970)
    }

    func testCountDown_IsPublished_WhenStarted() throws {
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let recorder = countdownController.currentCountdownPublisher.record()
        let expectedCountdown = try Countdown(endsAt: endDate)
        try countdownController.startCountdown(for: endDate)

        let elements = try wait(for: recorder.next(2), timeout: 0.1)
        XCTAssertEqual(elements, [nil, expectedCountdown])
    }

    func testNotification_IsScheduled_WhenCountdownIsStarted() throws {
        let notificationController = dependancies.dependency(
            for: .notificationController
        ) as! MockNotificationController // swiftlint:disable:this force_cast
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!

        try countdownController.startCountdown(for: endDate)

        XCTAssertTrue(notificationController.hasNotificationScheduled)
        XCTAssertEqual(notificationController.scheduledNotificationDate, endDate)
    }

    func testHasCountdownActive_IsFalse_WhenCountdownNotActive() {
        XCTAssertFalse(countdownController.hasCountdownActive)
    }

    func testCurrentCountdown_IsNil_InitiallyWithNothingPersisted() {
        XCTAssertNil(countdownController.currentCountdownPublisher.value)
    }

    func testCountdown_IsPublished_WhenStartWithSomethingPersisted() throws {
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        userDefaults.set(endDate.timeIntervalSince1970, forKey: CountdownController.storeCountdownKey)

        let expectedCountdown = try Countdown(endsAt: endDate)

        countdownController = CountdownController(dependancies: dependancies, userDefaults: userDefaults)

        XCTAssertEqual(expectedCountdown, countdownController.currentCountdownPublisher.value)
    }

    func testHasCountdownActive_IsFalse_WhenCancelCountdown() throws {
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!

        try countdownController.startCountdown(for: endDate)
        countdownController.cancelCountdown()

        XCTAssertFalse(countdownController.hasCountdownActive)
    }

    func testNil_IsPublished_WhenCancelCountdown() throws {
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let expectedCountdown = try Countdown(endsAt: endDate)
        let recorder = countdownController.currentCountdownPublisher.record()

        try countdownController.startCountdown(for: endDate)
        countdownController.cancelCountdown()

        let elements = try wait(for: recorder.next(3), timeout: 0.1)
        XCTAssertEqual(elements, [nil, expectedCountdown, nil])
    }

    func testNotification_IsCanceled_WhenCountdownCanceled() throws {
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let notificationController = dependancies.dependency(
            for: .notificationController
        ) as! MockNotificationController // swiftlint:disable:this force_cast

        try countdownController.startCountdown(for: endDate)
        countdownController.cancelCountdown()

        XCTAssertFalse(notificationController.hasNotificationScheduled)
        XCTAssertNil(notificationController.scheduledNotificationDate)
    }

    func testUserDefaultsValue_IsCleared_WhenCountdownCanceled() throws {
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!

        try countdownController.startCountdown(for: endDate)
        countdownController.cancelCountdown()

        let userDefaultsValue = userDefaults.double(forKey: CountdownController.storeCountdownKey)

        XCTAssertEqual(0, userDefaultsValue)
    }

    func testStartingCountdown_WithPastDate_Throws() {
        let endDate = Calendar.current.date(byAdding: .minute, value: -1, to: Date())!
        XCTAssertThrowsError(try countdownController.startCountdown(for: endDate))
    }

}
