//
//  SettingsViewModel.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Foundation

/// A view model for the SettingsView view.
///
/// Preference is a generic parameter for an object adopting the PreferenceStoreProtocol
final class SettingsViewModel<PreferenceStore>: ObservableObject where PreferenceStore: PreferenceStoreProtocol {
    /// The store the settings will be saved into and retrieved from.
    private var userPreferenceStore: PreferenceStore

    /// Stores the currently shown ExplainerViewModel.
    @Published var currentExplainer: ExplainerViewModel?

    /// This is the currently set ShutterGap for the app.
    var selectedShutterGap: ShutterGap {
        get {
            userPreferenceStore.selectedShutterSpeedGap
        }
        set {
            userPreferenceStore.selectedShutterSpeedGap = newValue
        }
    }

    /// Initialises a SettingsViewModel, defaults to using the provided PreferenceStore object
    /// or defaulting to the one set in the DIContainer.
    /// - Parameter userPreferences: An object that conforms to the PreferenceStoreProtocol,
    /// defaults to the one set in the DIContainer.
    init(userPreferences: PreferenceStore = DIContainer.shared.resolve(type: PreferenceStore.self)!) {
        self.userPreferenceStore = userPreferences
    }

    /// To be called when the user selects learn more on the ShutterSpeedGap setting.
    ///
    /// This will set the currentExplainer to the Explanation for the shutter gap,
    /// this will cause a modal popover with an Explainer View to popover.
    func selectedLearnMoreShutterGap() {
        currentExplainer = shutterGapExplanation
    }

    // MARK: - Explanations
    // swiftlint:disable:next line_length
    let shutterGapExplanation = ExplainerViewModel(title: "Shutter gap interval", explanation: "This is the number of intervals between stops in the shutter speed selection. For example if this is set to one stop it would be 1/60, 1/30, 1/15. At a third stop 1/60, 1/50, 1/40, 1/30, 1/25, 1/10. Each camera brand will vary but they all should generally fall into one of the three categories.")
}
