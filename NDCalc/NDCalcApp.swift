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
    var model: HomeViewModel<PreferenceStore, CountdownController<NotificationController>, NotificationController>

    init() {
        // The components need to be registered in this order since each one depends of the ones registered before it.
        let userPreferences = PreferenceStore()
        DIContainer.shared.register(type: PreferenceStore.self, component: userPreferences)

        let notificationController = NotificationController()
        DIContainer.shared.register(type: NotificationController.self, component: notificationController)

        let countdownController = CountdownController<NotificationController>()
        DIContainer.shared.register(type: CountdownController<NotificationController>.self,
                                    component: countdownController)

        model = HomeViewModel()
    }

    var body: some Scene {
        WindowGroup {
            HomeView<HomeViewModel, PreferenceStore>(model: model, settingsViewModel: SettingsViewModel())
        }
    }
}
