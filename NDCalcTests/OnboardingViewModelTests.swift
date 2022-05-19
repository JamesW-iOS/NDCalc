//
//  OnboardingViewModelTests.swift
//  NDCalcTests
//
//  Created by Personal James on 19/5/2022.
//

import Combine
import CombineExpectations
import Depends
import XCTest
@testable import NDCalc

class OnboardingViewModelTests: XCTestCase {
    var onboardingViewModel: OnboardingViewModel!
    var dependancies: DependencyRegistry!
    var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        dependancies = DependencyRegistry()
        let notificationController = MockNotificationController()
        dependancies.register(notificationController, for: .notificationController)

        userDefaults = UserDefaults.init(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)

        onboardingViewModel = OnboardingViewModel(
            dependencies: dependancies,
            userDefaults: userDefaults
        )
    }

    override func tearDownWithError() throws {
        onboardingViewModel = nil
        dependancies = nil
    }

    func testIsShowingHomeView_IsFalse_WhenNoValueInUserDefaults() {
        XCTAssertFalse(onboardingViewModel.isShowingHomeView)
    }

    func testIsShowingHomeView_IsTrue_WhenValueTrueInUserDefaults() {
        userDefaults.set(true, forKey: OnboardingViewModel.SeenOnboardingScreenKey)

        onboardingViewModel = OnboardingViewModel(dependencies: dependancies, userDefaults: userDefaults)

        XCTAssertTrue(onboardingViewModel.isShowingHomeView)
    }

    func testSeenOnboarding_IsPersisted_WhenTapRequestNotification() {
        onboardingViewModel.tappedRequestNotificationPermission()

        let userDefaultsValue = userDefaults.bool(forKey: OnboardingViewModel.SeenOnboardingScreenKey)
        XCTAssertTrue(userDefaultsValue)
    }

    func testSeenOnboarding_IsPersisted_WhenTapNoNotification() {
        onboardingViewModel.tappedNoNotification()
        let userDefaultsValue = userDefaults.bool(forKey: OnboardingViewModel.SeenOnboardingScreenKey)
        XCTAssertTrue(userDefaultsValue)
    }

    func testIsShowingHomeView_GoesToTrue_WhenTapRequestNotification() throws {
        let recorder = onboardingViewModel.$isShowingHomeView.record()

        onboardingViewModel.tappedRequestNotificationPermission()

        let showingStates = try wait(for: recorder.next(2), timeout: 0.1)

        XCTAssertEqual(showingStates, [false, true])
    }

    func testIsShowingHomeView_GoesToTrue_WhenTapRequestNoNotification() throws {
        let recorder = onboardingViewModel.$isShowingHomeView.record()

        onboardingViewModel.tappedNoNotification()

        let showingStates = try wait(for: recorder.next(2), timeout: 0.1)

        XCTAssertEqual(showingStates, [false, true])
    }

    func testNotificationPermission_IsRequested_WhenTapRequestNotification() {
        let notificationController = dependancies.dependency(
            for: .notificationController
        ) as! MockNotificationController // swiftlint:disable:this force_cast

        onboardingViewModel.tappedRequestNotificationPermission()

        XCTAssertTrue(notificationController.hasRequestedNotificationPermission)
    }
}
