//
//  UserPreferanceController.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Combine
import Depends

protocol PreferenceStoreProtocol {
    var selectedShutterSpeedGap: CurrentValueSubject<ShutterGap, Never> { get }
    var selectedFilterRepresentation: CurrentValueSubject<FilterStrengthRepresentation, Never> { get }

    func setSelectedShutterSpeedGap(_ gap: ShutterGap)
    func setSelectedFilterRepresentation(_ filterStrength: FilterStrengthRepresentation)
}

extension DependencyKey where DependencyType == PreferenceStoreProtocol {
    static let preferenceStore = DependencyKey(default: MockPreferenceController())
}

final class MockPreferenceController: PreferenceStoreProtocol, ObservableObject {
    var selectedShutterSpeedGap: CurrentValueSubject<ShutterGap, Never>
    var selectedFilterRepresentation: CurrentValueSubject<FilterStrengthRepresentation, Never>

    init(
        selectedShutterSpeedGap: ShutterGap = .oneStop,
        selectedFilterRepresentation: FilterStrengthRepresentation = .stopsReduced
    ) {
        self.selectedFilterRepresentation = CurrentValueSubject(selectedFilterRepresentation)
        self.selectedShutterSpeedGap = CurrentValueSubject(selectedShutterSpeedGap)
    }

    func setSelectedShutterSpeedGap(_ gap: ShutterGap) {
        selectedShutterSpeedGap.send(gap)
    }

    func setSelectedFilterRepresentation(_ filterStrength: FilterStrengthRepresentation) {
        selectedFilterRepresentation.send(filterStrength)
    }
}
