//
//  FilterPicker.swift
//  NDCalc
//
//  Created by James Warren on 26/7/21.
//

import SwiftUI

struct FilterPicker: View {
    @Binding var selectedFilter: Filter
    var body: some View {
        VStack {
            PickerHeading(heading: "Selected Filter")
            Picker(selection: $selectedFilter, label: Text("Selected Filter")) {
                ForEach(Filter.filters) { filter in
                    Text("\(filter.stopsReduced)")
                        .tag(filter)
                }
            }
        }
    }
}

struct FilterPicker_Previews: PreviewProvider {
    static var previews: some View {
        FilterPicker(selectedFilter: .constant(Filter(strength: 1)))
    }
}
