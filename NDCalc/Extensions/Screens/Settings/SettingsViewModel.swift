//
//  SettingsViewModel.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Combine
import Depends
import Foundation

/// A view model for the SettingsView view.
///
/// Preference is a generic parameter for an object adopting the PreferenceStoreProtocol
@MainActor
final class SettingsViewModel: ObservableObject, DependencyProvider {
    let dependencies: DependencyRegistry

    /// The store the settings will be saved into and retrieved from.
    @Dependency(.preferenceStore) private var userPreferenceStore

    /// Stores the currently shown ExplainerViewModel.
    @Published var currentExplainer: ExplainerViewModel?
    @Published var selectedShutterGap: ShutterGap
    @Published var selectedFilterRepresentation: FilterStrengthRepresentation

    private var cancelables = Set<AnyCancellable>()

    /// Initialises a SettingsViewModel, defaults to using the provided PreferenceStore object
    /// or defaulting to the one set in the DIContainer.
    /// - Parameter userPreferences: An object that conforms to the PreferenceStoreProtocol,
    /// defaults to the one set in the DIContainer.
    init(dependencies: DependencyRegistry) {
        self.dependencies = dependencies
        let preferences = dependencies.dependency(for: .preferenceStore)
        selectedFilterRepresentation = preferences.selectedFilterRepresentation.value
        selectedShutterGap = preferences.selectedShutterSpeedGap.value

        configureBindings()

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

    private func configureBindings() {
        userPreferenceStore.selectedShutterSpeedGap
            .sink { [unowned self] gap in
                selectedShutterGap = gap
            }
            .store(in: &cancelables)

        userPreferenceStore.selectedFilterRepresentation
            .sink { [unowned self] representation in
                selectedFilterRepresentation = representation
            }
            .store(in: &cancelables)

        $selectedShutterGap
            .removeDuplicates()
            .sink { [unowned self] gap in
                userPreferenceStore.setSelectedShutterSpeedGap(gap)
            }
            .store(in: &cancelables)

        $selectedFilterRepresentation
            .removeDuplicates()
            .sink { [unowned self] representation in
                userPreferenceStore.setSelectedFilterRepresentation(representation)
            }
            .store(in: &cancelables)
    }

    // MARK: - Explanations
    // swiftlint:disable:next line_length
    let shutterGapExplanation = ExplainerViewModel(title: "Shutter gap interval", explanation: "This is the number of intervals between stops in the shutter speed selection. For example if this is set to one stop it would be 1/60, 1/30, 1/15. At a third stop 1/60, 1/50, 1/40, 1/30, 1/25, 1/10. Each camera brand will vary but they all should generally fall into one of the three categories.")

    // swiftlint:disable:next line_length
    let filterRepresenation = ExplainerViewModel(title: "Filter Notation", explanation: "The strength of an ND filter can be represented in multiple ways, different companies will market the strength using different notations. Each one will be written differently, bellow is an example of the same strength filter with each of the different notations.\nND1 number notation: ND 104\n ND Decimal number notation: ND 1.2\nND number notation: ND16\nf-stop reduction: 4")
}
