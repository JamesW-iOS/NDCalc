//
//  UserPreferanceController.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Combine

protocol PreferenceStoreProtocol: ObservableObject {
    var selectedShutterSpeedGap: ShutterGap { get set }
}

final class MockPreferenceController: PreferenceStoreProtocol {
    var selectedShutterSpeedGap: ShutterGap = ShutterGap.oneStop
}
