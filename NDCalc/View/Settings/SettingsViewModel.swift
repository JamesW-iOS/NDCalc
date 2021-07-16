//
//  SettingsViewModel.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Foundation

final class SettingsViewModel<Preference>: ObservableObject where Preference: PreferenceControllerProtocol {
    private var userPreferences: Preference

    @Published var shutterGapExplainer: ExplainerViewModel?

    var selectedShutterGap: ShutterGap {
        get {
            userPreferences.selectedShutterSpeedGap
        }
        set {
            userPreferences.selectedShutterSpeedGap = newValue
        }
    }

    init(userPreferences: Preference = DIContainer.shared.resolve(type: Preference.self)!) {
        self.userPreferences = userPreferences
    }

    func selectedLearnMoreShutterGap() {
        shutterGapExplainer = shutterGapExplanation
    }

    // MARK: - Explanations
    let shutterGapExplanation = ExplainerViewModel(title: "Shutter gap interval", explanation: "This is the number of intervals between stops in the shutter speed selection. For example if this is set to one stop it would be 1/60, 1/30, 1/15. At a third stop 1/60, 1/50, 1/40, 1/30, 1/25, 1/10. Each camera brand will vary but they all should generally fall into one of the three categories.")
}
