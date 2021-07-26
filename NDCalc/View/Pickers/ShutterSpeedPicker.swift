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

    var body: some View {
        VStack {
            Text("Selected exposure")
            Picker(selection: $selectedShutterSpeed, label: Text("Selected exposure")) {
                ForEach(shutterSpeeds) { shutterSpeed in
                    Text(shutterSpeed.stringRepresentation)
                        .tag(shutterSpeed)

                }
            }
        }
    }
}

struct ShutterSpeedPicker_Previews: PreviewProvider {
    static let shutterSpeeds = ShutterSpeed.speedsForGap(.oneStop)

    static var previews: some View {
        ShutterSpeedPicker(shutterSpeeds: shutterSpeeds, selectedShutterSpeed: .constant(shutterSpeeds[0]))
    }
}
