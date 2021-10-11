//
//  Filter.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Foundation

/// Enum representing the different ways ND filter strengths can be represented.
///
/// The names make no real sense, based on historical names from the photography community.
enum FilterStrengthRepresentation: String, Codable, CaseIterable, RawRepresentable, Identifiable {
    // swiftlint:disable:next identifier_name
    var id: Self { self }

    case stopsReduced = "Stops Reduced",
         oneNumber = "ND One Number",
         decimal = "ND Decimal Number",
         number = "ND Number"
}

/// A struct to model different strengths of ND filters
///
/// The struct has a private initialiser since the only filters accessible in the app should be the ones
/// in the static `filters` property.
struct Filter: Identifiable, Hashable, Codable, Equatable {
    /// The strength of the ND filter, represented as how many stops of light the filter darkens the image by.
    let stopsReduced: Float
    // swiftlint:disable:next identifier_name
    var id: Float { stopsReduced }

    /// String representation for number of stops reduced
    private var NDStopsReduced: String {
        "\(String(format: "%.0f", stopsReduced))-Stop"
    }

    /// String representation in the ND 1 number notation
    private var NDOneNumberNotation: String {
        "ND 1" + String(format: "%2.0f", stopsReduced)
    }

    /// String representation in the ND Decimal notation
    private var NDDecimalNotation: String {
        let decimal = 0.3 * stopsReduced
        return "ND " + String(format: "%.1f", decimal)
    }

    /// String representation in the ND Number notation
    private var NDNumberNotation: String {
        let power = pow(2.0, stopsReduced)
        return "ND " + String(format: "%.0f", power)
    }

    /// initialiser for an NDFilter of a particular strength,
    /// - Parameter strength: The number of stops of light that the filter will darken the image by.
    init(strength: Float) {
        self.stopsReduced = strength
    }

    func stringRepresentation(notation: FilterStrengthRepresentation) -> String {
        switch notation {
        case .stopsReduced:
            return NDStopsReduced
        case .oneNumber:
            return NDOneNumberNotation
        case .decimal:
            return NDDecimalNotation
        case .number:
            return NDNumberNotation
        }
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
