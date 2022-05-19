//
//  NotificationControllerTests.swift
//  NDCalcTests
//
//  Created by James Warren on 23/7/21.
//

import Depends
import XCTest
@testable import NDCalc

class NotificationControllerTests: XCTestCase {
    var dependency: DependencyRegistry!
    var sut: NotificationController!
    var mockNotificationCentre: MockUserNotificationCentre!

    override func setUpWithError() throws {
        dependency = DependencyRegistry()
        mockNotificationCentre = MockUserNotificationCentre()
        dependency.register(mockNotificationCentre, for: .notificationCenter)
        sut = NotificationController(dependancies: dependency)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockNotificationCentre = nil
        dependency = nil
    }

    func testRequestPermission() {
        XCTAssertFalse(mockNotificationCentre.hasAuthorizationStatus)

        sut.requestNotificationPermission()

        XCTAssertTrue(mockNotificationCentre.hasAuthorizationStatus)
    }

    func testScheduleNotification() {
        XCTAssertFalse(sut.hasNotificationScheduled,
                       "notification controller should not start with notification scheduled.")
        XCTAssertNil(sut.notificationIdentifier, "notification controller should not start with identifier.")

        let endDate = Date(timeIntervalSinceNow: 60.0)
        sut.scheduleNotification(for: endDate)

        XCTAssertTrue(sut.hasNotificationScheduled,
                      "notifcationController should have hasNotificationScheduled true after scheduling notification.")
        XCTAssertNotNil(sut.notificationIdentifier,
                        "notification identifier should not be nil after scheduling notification.")
    }

    func testScheduledNotificationHasCorrectData() {
        let endDate = Date(timeIntervalSinceNow: 60.0)
        sut.scheduleNotification(for: endDate)
        let correctTrigger = UNTimeIntervalNotificationTrigger(timeInterval: endDate.timeIntervalSinceNow,
                                                               repeats: false)

        let request = mockNotificationCentre.request
        // guard unwrapping the request causes the compiler to crash, no idea why,
        // force unwrapping here since it's just a test.
//        guard let request = request else {
//            XCTFail("Unable to unwrap the request")
//            return
//        }

        guard let trigger = request!.trigger as? UNTimeIntervalNotificationTrigger else {
            XCTFail("trigger should be a time interval trigger")
            return
        }

        let timeDifferance = trigger.timeInterval - correctTrigger.timeInterval
        XCTAssertTrue(timeDifferance.magnitude < 0.01, "notification should have the time finish time aproximately")
        XCTAssertEqual(request!.identifier, sut.notificationIdentifier, "request identifiers should be the same.")
        XCTAssertEqual(request!.content.body, NotificationController.notificationBody,
                       "body of notification should be set.")
        XCTAssertEqual(request!.content.title, NotificationController.notificationTitle,
                       "title of notification should be set.")
    }

    func testCancelingNotification() {
        testScheduleNotification()
        sut.cancelNotification()

        XCTAssertFalse(sut.hasNotificationScheduled, "after canceling hasNotification should be false.")
        XCTAssertNil(sut.notificationIdentifier, "notification identifier should be nil after canceling.")
    }

    func testNotificationCorrectText() {
        XCTAssertEqual(NotificationController.notificationTitle, "Exposure finished")
        XCTAssertEqual(NotificationController.notificationBody, "Your exposure has finished")
    }
}
