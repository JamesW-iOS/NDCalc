//
//  NDCalcApp.swift
//  NDCalc
//
//  Created by James Warren on 3/4/21.
//

import SwiftUI
import os

@main
struct NDCalcApp: App {
    var model: HomeViewModel<PreferenceController, CountdownController<NotificationController>, NotificationController>

    init() {
        let userPreferences = PreferenceController()
        DIContainer.shared.register(type: PreferenceController.self, component: userPreferences)

        let notificationController = NotificationController()
        DIContainer.shared.register(type: NotificationController.self, component: notificationController)

        let countdownController = CountdownController<NotificationController>()
        DIContainer.shared.register(type: CountdownController<NotificationController>.self, component: countdownController)
        
        model = HomeViewModel()
    }

    var body: some Scene {
        WindowGroup {
            HomeView<HomeViewModel, PreferenceController>(model: model)
        }
    }
}
