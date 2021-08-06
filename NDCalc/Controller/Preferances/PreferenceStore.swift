//
//  PreferenceController.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Combine
import Foundation

final class PreferenceStore: PreferenceStoreProtocol, ObservableObject {
    @UserDefault(key: UserDefaultKeys.shutterGapKey,
                 defaultValue: ShutterGap.oneStop)
    var selectedShutterSpeedGap: ShutterGap {
        didSet {
            objectWillChange.send()
        }
    }

    @UserDefault(key: UserDefaultKeys.filterRepresentationKey,
                 defaultValue: FilterStrengthRepresentation.stopsReduced)
    var selectedFilterRepresentation: FilterStrengthRepresentation {
        didSet {
            objectWillChange.send()
        }
    }
}
