//
//  SettingsViewModel.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Combine
import Depends
import Foundation
import SwiftUI

/// A view model for the SettingsView view.
///
/// Preference is a generic parameter for an object adopting the PreferenceStoreProtocol
@MainActor
final class SettingsViewModel: ObservableObject, DependencyProvider {
    enum NotificationProblem: String, Identifiable {
        case timeSensitive, enabled, sound, lockScreen

        var id: String {
            self.rawValue
        }

        var description: String {
            switch self {
            case .timeSensitive:
                return "Time Senesitive notifications disabled"
            case .enabled:
                return "Notifications disabled"
            case .sound:
                return "Notifcation sound disabled"
            case .lockScreen:
                return "Lock screen notifications disabled"
            }
        }
    }

    let dependencies: DependencyRegistry

    @Dependency(.preferenceStore) private var userPreferenceStore
    @Dependency(.notificationController) private var notificationController

    @Published var currentExplainer: ExplainerViewModel?
    @Published var selectedShutterGap: ShutterGap
    @Published var selectedFilterRepresentation: FilterStrengthRepresentation
    @Published var notificationProblems = [NotificationProblem]()

    private var cancelables = Set<AnyCancellable>()
    private var notificationSettingTask: Task<(), Never>?

    var shouldShowNotificationSection: Bool {
        !notificationProblems.isEmpty
    }

    init(dependencies: DependencyRegistry) {
        self.dependencies = dependencies
        let preferences = dependencies.dependency(for: .preferenceStore)
        selectedFilterRepresentation = preferences.selectedFilterRepresentation.value
        selectedShutterGap = preferences.selectedShutterSpeedGap.value

        configureBindings()

        notificationSettingTask = Task {
            await updateNotificationSettings()
        }
    }

    func selectedLearnMoreShutterGap() {
        currentExplainer = shutterGapExplanation
    }

    func selectedLearnMoreFilterRepresentation() {
        currentExplainer = filterRepresenation
    }

    func scenePhaseChanged(to phase: ScenePhase) {
        switch phase {
        case .background, .inactive:
            if let notificationSettingTask = notificationSettingTask {
                notificationSettingTask.cancel()
                self.notificationSettingTask = nil
            }
        case .active:
            notificationSettingTask = Task {
                await updateNotificationSettings()
            }
        @unknown default:
            assertionFailure()
        }
    }

    func viewDidAppear() async {
        await updateNotificationSettings()
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

    private func updateNotificationSettings() async {
        let settings = await notificationController.getNotificationPermission()

        var problems = [NotificationProblem]()

        switch settings.timeSensitiveSetting {
        case .disabled:
            problems.append(.timeSensitive)
        case .enabled, .notSupported:
            break
        }

        switch settings.authorizationStatus {
        case .authorized:
            break
        case .denied, .notDetermined, .ephemeral, .provisional:
            problems.append(.enabled)
        }

        switch settings.lockScreenSetting {
        case .enabled:
            break
        case .disabled, .notSupported:
            problems.append(.lockScreen)
        }

        switch settings.soundSetting {
        case .enabled:
            break
        case .disabled, .notSupported:
            problems.append(.sound)
        }

        notificationProblems = problems
    }

    // MARK: - Explanations
    // swiftlint:disable:next line_length
    let shutterGapExplanation = ExplainerViewModel(title: "Shutter gap interval", explanation: "This is how closely spaces the shutter speed options are. Different camera brands and models have different options, select the one that matches your camera.")

    // swiftlint:disable:next line_length
    let filterRepresenation = ExplainerViewModel(title: "Filter Notation", explanation: "The strength of an ND filter can be represented in multiple ways, different companies will market the strength using different measurements. Match this option with how your filters are marked. Some examples of the same strength filter with each of the different notations.\nND1 number notation: ND 104\nND Decimal number notation: ND 1.2\nND number notation: ND16\nf-stop reduction: 4")
}
