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
            objectWillChange.send()
        }
    }

    var selectedFilterRepresentation: FilterStrengthRepresentation {
        get {
            userPreferenceStore.selectedFilterRepresentation
        }
        set {
            userPreferenceStore.selectedFilterRepresentation = newValue
            objectWillChange.send()
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

    func selectedLearnMoreFilterRepresentation() {
        currentExplainer = filterRepresenation
    }

    // MARK: - Explanations
    // swiftlint:disable:next line_length
    let shutterGapExplanation = ExplainerViewModel(title: "Shutter gap interval", explanation: "This is the number of intervals between stops in the shutter speed selection. For example if this is set to one stop it would be 1/60, 1/30, 1/15. At a third stop 1/60, 1/50, 1/40, 1/30, 1/25, 1/10. Each camera brand will vary but they all should generally fall into one of the three categories.")

    // swiftlint:disable:next line_length
    let filterRepresenation = ExplainerViewModel(title: "Filter Notation", explanation: "The strength of an ND filter can be represented in multiple ways, different companies will market the strength using different notations. Each one will be written differently, bellow is an example of the same strength filter with each of the different notations.\nND1 number notation: ND 104\n ND Decimal number notation: ND 1.2\nND number notation: ND16\nf-stop reduction: 4")
}
