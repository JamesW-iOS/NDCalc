//
//  ShutterSpeedPicker.swift
//  NDCalc
//
//  Created by James Warren on 26/7/21.
//

import SwiftUI

struct ShutterSpeedPicker: View {
    let shutterSpeeds: [ShutterSpeed]
    @Binding var selectedShutterSpeed: ShutterSpeed
    let shouldDisplayAcceccibiltyMode: Bool

    var body: some View {
        VStack {
            if shouldDisplayAcceccibiltyMode {
                PickerHeading(heading: "Exposure")
                Picker(selection: $selectedShutterSpeed,
                       label: Text(selectedShutterSpeed.stringFractionalRepresentation)) {
                    ForEach(shutterSpeeds) { shutterSpeed in
                        Text(shutterSpeed.stringFractionalRepresentation)
                            .tag(shutterSpeed)

                    }
                }
                .pickerStyle(.menu)
            } else {
                PickerHeading(heading: "Selected Exposure")
                Picker(selection: $selectedShutterSpeed,
                       label: Text(selectedShutterSpeed.stringFractionalRepresentation)) {
                    ForEach(shutterSpeeds) { shutterSpeed in
                        Text(shutterSpeed.stringFractionalRepresentation)
                            .tag(shutterSpeed)

                    }
                }
                .pickerStyle(.wheel)
            }
        }
    }
}

struct ShutterSpeedPicker_Previews: PreviewProvider {
    static let shutterSpeeds = ShutterSpeed.speedsForGap(.oneStop)

    static var previews: some View {
        ShutterSpeedPicker(shutterSpeeds: shutterSpeeds,
                           selectedShutterSpeed: .constant(shutterSpeeds[0]),
                           shouldDisplayAcceccibiltyMode: false)
    }
}
