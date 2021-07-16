//
//  PreferenceController.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import Combine
import Foundation

final class PreferenceController: PreferenceControllerProtocol, ObservableObject {

    @Published var selectedShutterSpeedGap: ShutterGap {
        didSet {
            encodeAndStore(selectedShutterSpeedGap, key: UserDefaultKeys.shutterGapKey)
        }
    }

    init() {
        let defaults = UserDefaults.standard

        if let storedSelectedShutterSpeedGapData = defaults.data(forKey: UserDefaultKeys.shutterGapKey),
           let storedSelectedShutterSpeedGapValue = try? JSONDecoder().decode(ShutterGap.self, from: storedSelectedShutterSpeedGapData) {
            self.selectedShutterSpeedGap = storedSelectedShutterSpeedGapValue
        } else {
            self.selectedShutterSpeedGap = ShutterGap.halfStop
            guard let data = try? JSONEncoder().encode(selectedShutterSpeedGap) else {
                fatalError("TempUnit should be encodable")
            }
            defaults.set(data, forKey: UserDefaultKeys.shutterGapKey)
        }
    }

    private func encodeAndStore<T: Codable>(_ value: T, key: String) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(value) else {
            fatalError("\(value) should be encodable")
        }
        UserDefaults.standard.set(encoded, forKey: key)
    }

}
