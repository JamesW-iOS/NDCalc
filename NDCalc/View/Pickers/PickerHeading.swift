//
//  PickerHeading.swift
//  NDCalc
//
//  Created by James Warren on 30/7/21.
//

import SwiftUI

struct PickerHeading: View {
    let heading: String
    var body: some View {
        Text(heading)
            .bold()
    }
}

struct PickerHeading_Previews: PreviewProvider {
    static var previews: some View {
        PickerHeading(heading: "Test Heading")
    }
}
