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

    @Dependency(.preferenceStore) private var userPreferenceStore

    @Published var currentExplainer: ExplainerViewModel?
    @Published var selectedShutterGap: ShutterGap
    @Published var selectedFilterRepresentation: FilterStrengthRepresentation

    private var cancelables = Set<AnyCancellable>()

    init(dependencies: DependencyRegistry) {
        self.dependencies = dependencies
        let preferences = dependencies.dependency(for: .preferenceStore)
        selectedFilterRepresentation = preferences.selectedFilterRepresentation.value
        selectedShutterGap = preferences.selectedShutterSpeedGap.value

        configureBindings()

    }

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
    let shutterGapExplanation = ExplainerViewModel(title: "Shutter gap interval", explanation: "This is how closely spaces the shutter speed options are. Different camera brands and models have different options, select the one that matches your camera.")

    // swiftlint:disable:next line_length
    let filterRepresenation = ExplainerViewModel(title: "Filter Notation", explanation: "The strength of an ND filter can be represented in multiple ways, different companies will market the strength using different measurements. Match this option with how your filters are marked. Some examples of the same strength filter with each of the different notations.\nND1 number notation: ND 104\nND Decimal number notation: ND 1.2\nND number notation: ND16\nf-stop reduction: 4")
}
