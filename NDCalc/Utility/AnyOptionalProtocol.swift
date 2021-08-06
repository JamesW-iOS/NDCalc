//
//  AnyOptionalProtocol.swift
//  NDCalc
//
//  Created by James Warren on 30/7/21.
//  Based on tutorial from:
//  https://www.avanderlee.com/swift/property-wrappers/
//

import Foundation

/// Allows to match for optionals with generics that are defined as non-optional.
public protocol AnyOptional {
    /// Returns `true` if `nil`, otherwise `false`.
    var isNil: Bool { get }
}
extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}
