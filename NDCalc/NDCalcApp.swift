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
    var model: HomeViewModel
    let dependancies = DependencyRegistry()

    init() {
        // The components need to be registered in this order since each one depends of the ones registered before it.
        let userPreferences = PreferenceStore()
        dependancies.register(userPreferences, for: .preferenceStore)

        let notificationController = NotificationController(dependancies: dependancies)
        dependancies.register(notificationController, for: .notificationController)

        let countdownController = CountdownController(dependancies: dependancies)
        dependancies.register(countdownController, for: .countdownController)

        model = HomeViewModel(dependencies: dependancies)
    }

    var body: some Scene {
        WindowGroup {
            HomeView(model: model)
        }
    }
}
