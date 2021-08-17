//
//  FilterPicker.swift
//  NDCalc
//
//  Created by James Warren on 26/7/21.
//

import SwiftUI

struct FilterPicker: View {
    @Binding var selectedFilter: Filter
    let filterNotation: FilterStrengthRepresentation
    let shouldDisplayAcceccibiltyMode: Bool

    var selectedFilterString: String {
        selectedFilter.stringRepresentation(notation: filterNotation)
    }

    var body: some View {
        VStack {
            if shouldDisplayAcceccibiltyMode {
                PickerHeading(heading: "Filter")
                Picker(selection: $selectedFilter, label: Text(selectedFilterString)) {
                    ForEach(Filter.filters) { filter in
                        Text("\(filter.stringRepresentation(notation: filterNotation))")
                            .tag(filter)
                    }
                }
                .pickerStyle(.menu)
            } else {
                PickerHeading(heading: "Selected Filter")
                Picker(selection: $selectedFilter, label: Text(selectedFilterString)) {
                    ForEach(Filter.filters) { filter in
                        Text("\(filter.stringRepresentation(notation: filterNotation))")
                            .tag(filter)
                    }
                }
                .pickerStyle(.wheel)
            }
        }
    }
}

struct FilterPicker_Previews: PreviewProvider {
    static var previews: some View {
        FilterPicker(selectedFilter: .constant(Filter(strength: 1)),
                     filterNotation: .stopsReduced,
                     shouldDisplayAcceccibiltyMode: false)
    }
}
