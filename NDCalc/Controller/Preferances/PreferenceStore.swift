//
//  PreferenceController.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Combine
import Foundation

final class PreferenceStore: PreferenceStoreProtocol, ObservableObject {
    static let selectedShutterKey = "selectedShutterGap"
    static let selectedFilterRepresentationKey = "selectedFilterRepresentation"
    static let defaultSelectedShutterGap = ShutterGap.oneStop
    static let defaultSelectedFilterRepresentation = FilterStrengthRepresentation.stopsReduced

    private let userDefaults: UserDefaults

    var selectedShutterSpeedGap: CurrentValueSubject<ShutterGap, Never>
    var selectedFilterRepresentation: CurrentValueSubject<FilterStrengthRepresentation, Never>

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        if let selectedShutterString = userDefaults.string(forKey: Self.selectedShutterKey),
            let selectedShutter = ShutterGap(rawValue: selectedShutterString) {
            selectedShutterSpeedGap = CurrentValueSubject(selectedShutter)
        } else {
            selectedShutterSpeedGap = CurrentValueSubject(Self.defaultSelectedShutterGap)
        }

        if let selectedFilterString = userDefaults.string(forKey: Self.selectedFilterRepresentationKey),
            let selectedFilter = FilterStrengthRepresentation(rawValue: selectedFilterString) {
            selectedFilterRepresentation = CurrentValueSubject(selectedFilter)
        } else {
            selectedFilterRepresentation = CurrentValueSubject(Self.defaultSelectedFilterRepresentation)
        }
    }

    func setSelectedShutterSpeedGap(_ gap: ShutterGap) {
        userDefaults.set(gap.rawValue, forKey: Self.selectedShutterKey)
        selectedShutterSpeedGap.send(gap)
    }

    func setSelectedFilterRepresentation(_ filterStrength: FilterStrengthRepresentation) {
        userDefaults.set(filterStrength.rawValue, forKey: Self.selectedFilterRepresentationKey)
        selectedFilterRepresentation.send(filterStrength)
    }
}
