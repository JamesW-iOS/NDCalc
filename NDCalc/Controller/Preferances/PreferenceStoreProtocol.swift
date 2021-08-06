//
//  UserPreferanceController.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Combine

protocol PreferenceStoreProtocol: ObservableObject {
    var selectedShutterSpeedGap: ShutterGap { get set }
    var selectedFilterRepresentation: FilterStrengthRepresentation { get set }
}

final class MockPreferenceController: PreferenceStoreProtocol {
    var selectedFilterRepresentation: FilterStrengthRepresentation = .stopsReduced
    var selectedShutterSpeedGap: ShutterGap = ShutterGap.oneStop
}
