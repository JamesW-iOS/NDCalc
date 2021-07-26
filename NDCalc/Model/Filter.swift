//
//  Filter.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Foundation

/// A struct to model different strengths of ND filters
///
/// The struct has a private initialiser since the only filters accessible in the app should be the ones
/// in the static `filters` property.
struct Filter: Identifiable, Hashable {
    /// The strength of the ND filter, represented as how many stops of light the filter darkens the image by.
    let strength: Int
    // swiftlint:disable:next identifier_name
    var id: Int { strength }

    /// initialiser for an NDFilter of a particular strength,
    /// - Parameter strength: The number of stops of light that the filter will darken the image by.
    init(strength: Int) {
        self.strength = strength
    }

    /// The filters accessible to the rest of the app.
    static let filters = [
        Filter(strength: 1),
        Filter(strength: 2),
        Filter(strength: 3),
        Filter(strength: 4),
        Filter(strength: 5),
        Filter(strength: 6),
        Filter(strength: 7),
        Filter(strength: 8),
        Filter(strength: 9),
        Filter(strength: 10),
        Filter(strength: 11),
        Filter(strength: 12),
        Filter(strength: 13),
        Filter(strength: 14)
    ]
}
