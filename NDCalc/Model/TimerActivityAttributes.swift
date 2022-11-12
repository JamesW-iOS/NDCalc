//
//  TimerActivityAttributes.swift
//  NDCalc
//
//  Created by Personal James on 22/9/2022.
//

import ActivityKit
import Foundation

struct TimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var isRunning: Bool
    }

    var timerStart: Date
    var timerEnd: Date
    var exposure: String
    var filter: String
}
