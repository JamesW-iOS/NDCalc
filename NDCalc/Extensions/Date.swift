//
//  Date.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Foundation

extension Date {
    var isInFuture: Bool {
        self > Date()
    }
}
