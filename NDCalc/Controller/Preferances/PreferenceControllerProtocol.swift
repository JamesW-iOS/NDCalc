//
//  UserPreferanceController.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Combine

protocol PreferenceControllerProtocol: ObservableObject {
    var selectedShutterSpeedGap: ShutterGap { get set }
}

final class MockPreferenceController: PreferenceControllerProtocol {
    var selectedShutterSpeedGap: ShutterGap = ShutterGap.oneStop
}
