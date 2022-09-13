//
//  UserDefaults.swift
//  NDCalc
//
//  Created by Personal James on 1/9/2022.
//

import Foundation
import Depends

extension DependencyKey where DependencyType == UserDefaults {
    static let userDefaults = DependencyKey(default: UserDefaults.standard)
}
