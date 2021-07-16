//
//  SettingsView.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import SwiftUI

struct SettingsView<Preference>: View where Preference: PreferenceControllerProtocol {
    @ObservedObject var model: SettingsViewModel<Preference>

    var body: some View {
        Form {
            Section {
                NavigationLink(destination: About()) {
                    Text("About this app")
                }
            }

            Section(header: Text("Shutter Speed interval")) {
                Picker("Shutter speeds gaps", selection: $model.selectedShutterGap) {
                    ForEach(ShutterGap.allCases) { shutterGap in
                        Text(shutterGap.rawValue)
                            .tag(shutterGap)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                Button {
                    model.selectedLearnMoreShutterGap()
                } label: {
                    Text("What does this mean?")
                }
            }
        }
        .sheet(item: $model.shutterGapExplainer, onDismiss: nil) { explainerModel in
            Explainer(model: explainerModel)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: SettingsViewModel(userPreferences: MockPreferenceController()))
    }
}
