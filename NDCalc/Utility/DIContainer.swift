//
//  DIContainer.swift
//  NDCalc
//
//  Created by James Warren on 14/7/21.
//  Taken from a Rey Wenderlich tutorial on dependency injection
//  https://www.raywenderlich.com/14223279-dependency-injection-tutorial-for-ios-getting-started
//

import Foundation

/// Defines the requirements for a DIContainer.
protocol DIContainerProtocol {
    func register<Component>(type: Component.Type, component: Any)
    func resolve<Component>(type: Component.Type) -> Component?
}

/// An implementation of the `DIContainerProtocol`
///
/// This object is implemented as a singleton via a private initialiser. It is intended that the dependancies that are
/// in the app will be registered with the `DIContainer` at the root of the app, in the case of `SwiftUI` at the
/// `@Main` entry point.
///
/// Only a single object of a particular type may be stored in the container at any one time.
final class DIContainer: DIContainerProtocol {

    /// The shared instance of `DIContainer` that everyone access
    static let shared = DIContainer()

    /// Private initialiser for the singleton pattern.
    private init() {}

    /// A Dictionary to store the components that are registered with the `DIContainer`.
    ///
    /// The key is a string representation of the Type being registered and the Value is the object of that type.
    private var components: [String: Any] = [:]

    /// Register an object with the `DIContainer`
    ///
    /// - Parameter type: The type of the object being registered
    /// - Parameter component: The object being registered in the container
    ///
    /// Only a single object of a particular type may be stored in the `DIContainer` at any one time. Trying
    /// to store another one will overwrite the one currently stored in the container.
    func register<Component>(type: Component.Type, component: Any) {
        components["\(type)"] = component
    }

    /// Try to get an object of a particular type from the `DIContainer` if there is no object of that type
    /// stored in the container `nil` will be returned
    ///
    /// - Parameter type: The type of the object trying to be retrieved
    ///
    /// - Returns: The object stored in the container of that type if it exists or `nil` if there is no
    /// object of that type stored in the container.
    func resolve<Component>(type: Component.Type) -> Component? {
        return components["\(type)"] as? Component
    }
}
