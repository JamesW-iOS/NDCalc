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
    let width: CGFloat

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
                .pickerStyle(MenuPickerStyle())
            } else {
                PickerHeading(heading: "Selected Filter")
                Picker(selection: $selectedFilter, label: Text(selectedFilterString)) {
                    ForEach(Filter.filters) { filter in
                        Text("\(filter.stringRepresentation(notation: filterNotation))")
                            .tag(filter)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: width)
                .clipped()
                .border(Color.red)
            }
        }
    }
}

struct FilterPicker_Previews: PreviewProvider {
    static var previews: some View {
        FilterPicker(selectedFilter: .constant(Filter(strength: 1)),
                     filterNotation: .stopsReduced,
                     shouldDisplayAcceccibiltyMode: false,
                     width: 300)
    }
}
