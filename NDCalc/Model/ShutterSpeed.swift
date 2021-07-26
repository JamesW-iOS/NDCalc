//
//  ShutterSpeed.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Foundation

/// A model to store a particular shutter speed.
///
/// Shutter speeds are most often expressed as fractions of a second (1/100s for example),
/// this is why the `ShutterSpeed` model stores them in the same way.
struct ShutterSpeed: Identifiable, Hashable, Codable {
    /// The numerator when expressing a shutter speed
    let numerator: Double
    /// The denominator when expressing a shutter speed
    let denominator: Double
    // swiftlint:disable:next identifier_name
    var id: String { "\(numerator) \\ \(denominator)" }

    /// An array of shutter speeds, loaded from a JSON file in the bundle
    ///
    /// We store this as a JSON file rather than programatically generating it because the convention for what
    /// shutter speeds most cameras show doesn't exactly follow set rules, it almost does but with some of them
    /// rounding to 'nicer' values. Because of this it's simpler to hand-code the list in a JSON file.
    private static let shutterSpeeds = Bundle.main.decode([[ShutterSpeed]].self, from: "shutterSpeeds.json")
    /// Shutter speeds separated by one full stop
    private static let oneStopSpeeds = shutterSpeeds[0]
    /// Shutter speeds separated by half a stop
    private static let halfStopSpeeds = shutterSpeeds[1]
    /// Shutter speeds separated by a third of a stop
    private static let thirdStopSpeeds = shutterSpeeds[2]

    /// formatter for displaying the numbers in a nice way.
    private static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.usesGroupingSeparator = false
        return formatter
    }()

    /// A 'human' friendly representation of a shutter speed.
    ///
    /// The convention for how shutter speeds are displayed are not exact but in general any shutter speed
    /// that can be represented as 1/n seconds will be represented as a fraction (0.5 being an exception). all
    /// Others are represented as a decimal number.
    var stringRepresentation: String {
        if denominator == 1 {
            return numberToString(numerator)
        } else {
            return "\(numberToString(numerator))/\(numberToString(denominator))"
        }
    }

    /// The number of seconds of the shutter speed as a decimal number.
    var seconds: Double {
        numerator / denominator
    }

    enum CodingKeys: String, CodingKey {
        case numerator = "n"
        case denominator = "d"
    }

    /// A function that generates a 'human' formatted version of a number
    private func numberToString(_ number: Double) -> String {
        guard let string = Self.formatter.string(from: NSNumber(value: number)) else {
            assertionFailure("failed to convert numerator to string")
            return "Error"
        }

        return string
    }

    /// Gets the array of shutter speeds for a given Shutter gap
    static func speedsForGap(_ gap: ShutterGap) -> [ShutterSpeed] {
        switch gap {
        case .oneStop:
            return Self.oneStopSpeeds
        case .halfStop:
            return Self.halfStopSpeeds
        case .thirdStop:
            return Self.thirdStopSpeeds
        }
    }
}

/// Represents the different intervals between shutter speeds.
enum ShutterGap: String, Codable, CaseIterable, Identifiable {
    // swiftlint:disable:next identifier_name
    var id: Self { self }

    case oneStop = "One Stop"
    case halfStop = "Half Stop"
    case thirdStop = "Third Stop"
}
