//
//  NDCalcApp.swift
//  NDCalc
//
//  Created by James Warren on 3/4/21.
//

import Depends
import SwiftUI

@main
struct NDCalcApp: App {
    let dependancies = DependencyRegistry()

    init() {
        // The components need to be registered in this order since each one depends of the ones registered before it.
        let userPreferences = PreferenceStore()
        dependancies.register(userPreferences, for: .preferenceStore)

        let notificationController = NotificationController(dependancies: dependancies)
        dependancies.register(notificationController, for: .notificationController)

        let countdownController = CountdownController(dependancies: dependancies)
        dependancies.register(countdownController, for: .countdownController)

        let applicationStateStore = ApplicationStateStore()
        dependancies.register(applicationStateStore, for: .applicationState)
    }

    var body: some Scene {
        WindowGroup {
            OnboardingView(viewModel: OnboardingViewModel(dependencies: dependancies))
        }
    }
}
