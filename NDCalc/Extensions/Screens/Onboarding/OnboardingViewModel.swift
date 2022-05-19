//
//  OnboardingViewModel.swift
//  NDCalc
//
//  Created by Personal James on 14/5/2022.
//

import Foundation
import Depends

final class OnboardingViewModel: DependencyProvider, ObservableObject {
    static let SeenOnboardingScreenKey = "SeenOnboardingScreen"

    var dependencies: DependencyRegistry

    @Dependency(.notificationController) private var notificationController
    private let userDefaults: UserDefaults

    @Published var isShowingHomeView: Bool

    init(dependencies: DependencyRegistry, userDefaults: UserDefaults = .standard) {
        self.dependencies = dependencies
        self.userDefaults = userDefaults

        isShowingHomeView = userDefaults.bool(forKey: OnboardingViewModel.SeenOnboardingScreenKey)
    }

    func tappedRequestNotificationPermission() {
        notificationController.requestNotificationPermission()
        setSeenOnboarding()
        isShowingHomeView = true
    }

    func tappedNoNotification() {
        setSeenOnboarding()
        isShowingHomeView = true
    }

    private func setSeenOnboarding() {
        userDefaults.set(true, forKey: OnboardingViewModel.SeenOnboardingScreenKey)
    }
}
