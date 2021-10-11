//
//  NDPicker.swift
//  NDCalc
//
//  Created by James Warren on 23/9/21.
//

import SwiftUI

struct NDPicker: UIViewRepresentable {
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        if let firstItemIndex = filters.firstIndex(where: { $0 == selectedFilter }) {
            uiView.selectRow(firstItemIndex, inComponent: 0, animated: true)
        }

        if let secondItemIndex = shutterSpeeds.firstIndex(where: { $0 == selectedShutterSpeed }) {
            uiView.selectRow(secondItemIndex, inComponent: 1, animated: true)
        }

        context.coordinator.picker = self
        uiView.reloadAllComponents()
    }

    var filters: [Filter]
    @Binding var shutterSpeeds: [ShutterSpeed]
    @Binding var selectedFilter: Filter
    @Binding var selectedShutterSpeed: ShutterSpeed
    @Binding var filterNotation: FilterStrengthRepresentation

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator

        return picker
    }

    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var picker: NDPicker

        init(_ picker: NDPicker) {
            self.picker = picker
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            2
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return picker.filters.count
            }
            if component == 1 {
                return picker.shutterSpeeds.count
            }

            fatalError("Double column picker should never have more than two columns")
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return picker.filters[row].stringRepresentation(notation: picker.filterNotation)
            }

            if component == 1 {
                return picker.shutterSpeeds[row].stringFractionalRepresentation
            }

            fatalError("Double column picker should never have more than two columns")
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0:
                picker.selectedFilter = picker.filters[row]
            case 1:
                picker.selectedShutterSpeed = picker.shutterSpeeds[row]
            default:
                fatalError("Should never be more than two components")
            }
        }
    }

}
