//
//  DeviceStateProtocol.swift
//  NDCalc
//
//  Created by Personal James on 14/5/2022.
//

import Combine
import Depends

enum ApplicationState {
    case foreground, background
}

protocol ApplicationStateStoreProtocol {
    var applicationState: CurrentValueSubject<ApplicationState, Never> { get }
}

extension DependencyKey where DependencyType == ApplicationStateStoreProtocol {
    static let applicationState = DependencyKey(default: MockApplicationStateStore())
}

final class MockApplicationStateStore: ApplicationStateStoreProtocol {
    var applicationState = CurrentValueSubject<ApplicationState, Never>(.foreground)
}
