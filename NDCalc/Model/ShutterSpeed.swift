//
//  ShutterSpeed.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Foundation

struct ShutterSpeed: Identifiable, Hashable, Codable {
    let numerator: Int
    let denominator: Int
    var id: String { "\(numerator) \\ \(denominator)" }

    private static let shutterSpeeds = Bundle.main.decode([[ShutterSpeed]].self, from: "shutterSpeeds.json")
    private static let oneStopSpeeds = shutterSpeeds[0]
    private static let halfStopSpeeds = shutterSpeeds[1]
    private static let thirdStopSpeeds = shutterSpeeds[2]

    var stringRepresentation: String {
        if Double(numerator) / Double(denominator) < 1 {
            return "\(numerator) / \(denominator)"
        } else {
            return "\(numerator)"
        }
    }

    var seconds: Int {
        numerator / denominator
    }

    enum CodingKeys: String, CodingKey {
        case numerator = "n"
        case denominator = "d"
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
