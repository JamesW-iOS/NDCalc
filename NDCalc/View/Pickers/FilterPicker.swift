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

    var body: some View {
        VStack {
            PickerHeading(heading: "Selected Filter")
            Picker(selection: $selectedFilter, label: Text("Selected Filter")) {
                ForEach(Filter.filters) { filter in
                    Text("\(filter.stringRepresentation(notation: filterNotation))")
                        .tag(filter)
                }
            }
        }
    }
}

struct FilterPicker_Previews: PreviewProvider {
    static var previews: some View {
        FilterPicker(selectedFilter: .constant(Filter(strength: 1)), filterNotation: .stopsReduced)
    }
}
