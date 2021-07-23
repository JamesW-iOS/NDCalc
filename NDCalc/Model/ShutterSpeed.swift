//
//  ShutterSpeed.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Foundation

struct ShutterSpeed: Identifiable, Hashable, Codable {
    let numerator: Double
    let denominator: Double
    var id: String { "\(numerator) \\ \(denominator)" }

    private static let shutterSpeeds = Bundle.main.decode([[ShutterSpeed]].self, from: "shutterSpeeds.json")
    private static let oneStopSpeeds = shutterSpeeds[0]
    private static let halfStopSpeeds = shutterSpeeds[1]
    private static let thirdStopSpeeds = shutterSpeeds[2]

    private static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.usesGroupingSeparator = false
        return formatter
    }()

    var stringRepresentation: String {
        if denominator == 1 {
            return numberToString(numerator)
        } else {
            return "\(numberToString(numerator))/\(numberToString(denominator))"
        }
    }

    var seconds: Double {
        numerator / denominator
    }

    enum CodingKeys: String, CodingKey {
        case numerator = "n"
        case denominator = "d"
    }

    private func numberToString(_ number: Double) -> String {
        guard let string = Self.formatter.string(from: NSNumber(value: number)) else {
            assertionFailure("failed to convert numerator to string")
            return "Error"
        }

        return string
    }

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

enum ShutterGap: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }

    case oneStop = "One Stop"
    case halfStop = "Half Stop"
    case thirdStop = "Third Stop"
}
