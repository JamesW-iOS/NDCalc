//
//  HomeViewModelTests.swift
//  NDCalcTests
//
//  Created by Personal James on 3/6/2022.
//
import Combine
import CombineExpectations
import Depends
import XCTest
@testable import NDCalc

// swiftlint:disable force_cast

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var dependancies: DependencyRegistry!

    @MainActor
    override func setUp() {
        dependancies = DependencyRegistry()
        let notificationController = MockNotificationController()
        dependancies.register(notificationController, for: .notificationController)

        let countdownController = MockCountdownController()
        dependancies.register(countdownController, for: .countdownController)

        let preferenceStore = MockPreferenceController()
        dependancies.register(preferenceStore, for: .preferenceStore)

        // Reset UserDefaults, have to use standarn becuase of property wrapper
        UserDefaults.standard.set(nil, forKey: UserDefaultKeys.filterRepresentationKey)
        UserDefaults.standard.set(nil, forKey: UserDefaultKeys.selectedFilterKey)
        UserDefaults.standard.set(nil, forKey: UserDefaultKeys.selectedShutterSpeedKEy)
        UserDefaults.standard.set(nil, forKey: UserDefaultKeys.shutterGapKey)

        viewModel = HomeViewModel(dependencies: dependancies)
    }

    @MainActor
    override func tearDown() {
        viewModel = nil
        dependancies = nil
    }

    @MainActor
    func testFilterRepresentation_IsUpdated_WhenPreferenceStoreUpdates() throws {
        let objectWillChangeRecorder = viewModel.objectWillChange.record()
        let prefereanceStore = dependancies.dependency(for: .preferenceStore) as! MockPreferenceController
        let newNotationToSend = FilterStrengthRepresentation.decimal
        prefereanceStore.selectedFilterRepresentation.send(newNotationToSend)

        let values: [ObservableObjectPublisher.Output] = try wait(for: objectWillChangeRecorder.next(1), timeout: 0.1)

        XCTAssertEqual(values.count, 1)
        XCTAssertEqual(viewModel.filterNotation, newNotationToSend)
    }

    @MainActor
    func testShutterSpeeds_AreUpdated_WhenPreferenceStoreUpdates() throws {
        let objectWillChangeRecorder = viewModel.objectWillChange.record()
        let prefereanceStore = dependancies.dependency(for: .preferenceStore) as! MockPreferenceController
        let shutterSpeedGap = ShutterGap.halfStop
        prefereanceStore.selectedShutterSpeedGap.send(shutterSpeedGap)

        let values: [ObservableObjectPublisher.Output] = try wait(for: objectWillChangeRecorder.next(1), timeout: 0.1)

        XCTAssertEqual(values.count, 1)
        XCTAssertEqual(viewModel.shutterSpeeds, ShutterSpeed.speedsForGap(shutterSpeedGap))
    }

    @MainActor
    func testObjectWillChange_IsSent_WhenUpdatingSelectedFilter() throws {
        let objectWillChangeRecorder = viewModel.objectWillChange.record()

        viewModel.selectedFilter = Filter.filters[1]
        let values: [ObservableObjectPublisher.Output] = try wait(for: objectWillChangeRecorder.next(1), timeout: 0.1)

        XCTAssertEqual(values.count, 1)
    }

    @MainActor
    func testObjectWillChange_IsSent_WhenUpdatingSelectedShuterSpeed() throws {
        let objectWillChangeRecorder = viewModel.objectWillChange.record()

        viewModel.selectedShutterSpeed = .speedsForGap(.oneStop)[1]
        let values: [ObservableObjectPublisher.Output] = try wait(for: objectWillChangeRecorder.next(1), timeout: 0.1)

        XCTAssertEqual(values.count, 1)
    }

    @MainActor
    func testSelectedFilter_IsPersisted() throws {
        let newFilter = Filter.filters[1]
        viewModel.selectedFilter = newFilter

        let storedObject = UserDefaults.standard.data(
            forKey: UserDefaultKeys.selectedFilterKey
        )

        XCTAssertNotNil(storedObject)

        let storedFilter = try JSONDecoder().decode(Filter.self, from: storedObject!)

        XCTAssertEqual(storedFilter, newFilter)
    }

    @MainActor
    func testSelectedShutterSpeed_IsPersisted() throws {
        let newShutterSpeed = ShutterSpeed.speedsForGap(.halfStop)[1]
        viewModel.selectedShutterSpeed = newShutterSpeed

        let storedObject = UserDefaults.standard.data(
            forKey: UserDefaultKeys.selectedShutterSpeedKEy
        )

        XCTAssertNotNil(storedObject)

        let storedFilter = try JSONDecoder().decode(ShutterSpeed.self, from: storedObject!)

        XCTAssertEqual(storedFilter, newShutterSpeed)
    }

    @MainActor
    func testIsCurrentTimeValid() {
        viewModel.selectedFilter = Filter(strength: 1)

        viewModel.selectedShutterSpeed = ShutterSpeed(numerator: 1, denominator: 100)
        XCTAssertFalse(viewModel.isCurrentTimeValid)

        viewModel.selectedShutterSpeed = ShutterSpeed(numerator: 100, denominator: 1)
        XCTAssertTrue(viewModel.isCurrentTimeValid)

        viewModel.selectedShutterSpeed = ShutterSpeed(numerator: 1, denominator: 2)
        XCTAssertTrue(viewModel.isCurrentTimeValid)
    }

    @MainActor
    func testStartCountdown_StartsCountdown() throws {
        let countdownController = dependancies.dependency(for: .countdownController) as! MockCountdownController

        let filter = Filter(strength: 1)
        let shutterSpeed = ShutterSpeed(numerator: 10, denominator: 1)
        let calculatedShutterSpeed = ShutterSpeed(numerator: 20, denominator: 1)
        let endDate = Date(timeIntervalSinceNow: calculatedShutterSpeed.seconds)
        let predictedCountdown = try Countdown(endsAt: endDate)

        viewModel.selectedFilter = filter
        viewModel.selectedShutterSpeed = shutterSpeed

        viewModel.startCountdown()

        let publishedCountdown = countdownController.currentCountdownPublisher.value
        XCTAssertNotNil(publishedCountdown)

        XCTAssertEqual(predictedCountdown.secondsLeft, publishedCountdown!.secondsLeft, accuracy: 0.1)
    }

    @MainActor
    func testMovesToForeground_CallsClearDeliveredNotifications() {
        let notificationController = dependancies.dependency(
            for: .notificationController
        ) as! MockNotificationController

        viewModel.scenePhaseChanged(to: .active)

        XCTAssertTrue(notificationController.hasCalledRemovedAllDeliveredNotifications)
    }
}

// swiftlint:enable force_cast
