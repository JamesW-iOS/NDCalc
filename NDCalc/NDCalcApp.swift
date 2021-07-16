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
    var model: HomeViewModel<PreferenceController>

    init() {
        let userPreferences = PreferenceController()
        DIContainer.shared.register(type: PreferenceController.self, component: userPreferences)
        model = HomeViewModel()
    }

    var body: some Scene {
        WindowGroup {
            HomeView<HomeViewModel, PreferenceController>(model: model)
        }
    }
}
