//
//  Date.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Foundation

extension Date {
    /// A convience calculated property for is the `Date` is in the future
    var isInFuture: Bool {
        self > Date()
    }
}
