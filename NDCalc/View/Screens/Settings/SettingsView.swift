//
//  SettingsView.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//

import SwiftUI

/// This view displays a list of settings where the user can configure preferences.
///
/// Preference is a generic parameter for an  object that stores and retrieves
struct SettingsView<Preference>: View where Preference: PreferenceStoreProtocol {
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

                showMoreButton(funcToCall: model.selectedLearnMoreShutterGap)
            }

            Section(header: Text("Filter strength notation")) {
                Picker("Filter strength notation", selection: $model.selectedFilterRepresentation) {
                    ForEach(FilterStrengthRepresentation.allCases) { notation in
                        Text(notation.rawValue)
                            .tag(notation)
                    }
                }
                showMoreButton(funcToCall: model.selectedLearnMoreFilterRepresentation)
            }
        }
        .sheet(item: $model.currentExplainer, onDismiss: nil) { explainerModel in
            Explainer(model: explainerModel)
        }
    }

    func showMoreButton(funcToCall: @escaping () -> Void) -> some View {
        Button {
            funcToCall()
        } label: {
            Text("What does this mean?")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: SettingsViewModel(userPreferences: MockPreferenceController()))
    }
}
