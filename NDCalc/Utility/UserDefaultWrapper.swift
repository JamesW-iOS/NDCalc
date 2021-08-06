//
//  UserDefaultWrapper.swift
//  NDCalc
//
//  Created by James Warren on 30/7/21.
//  Based on tutorial from:
//  https://www.avanderlee.com/swift/property-wrappers/
//

import Combine
import Foundation

@propertyWrapper
struct UserDefault<Value: Codable> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    private let publisher = PassthroughSubject<Value, Never>()

    var wrappedValue: Value {
        get {
            if let data = container.data(forKey: key) {
                // Force trying here since we know newValue is Codable
                // swiftlint:disable:next force_try
                return try! JSONDecoder().decode(Value.self, from: data)
            } else {
                return defaultValue
            }
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                // Force trying here since we know newValue is Codable
                // swiftlint:disable:next force_try
                let data = try! JSONEncoder().encode(newValue)
                container.set(data, forKey: key)
            }

            publisher.send(newValue)
        }
    }

    var projectedValue: AnyPublisher<Value, Never> {
        return publisher.eraseToAnyPublisher()
    }
}

extension UserDefault where Value: ExpressibleByNilLiteral {
    /// Creates a new User Defaults property wrapper for the given key.
    /// - Parameters:
    ///   - key: The key to use with the user defaults store.
    init(key: String, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, container: container)
    }
}
