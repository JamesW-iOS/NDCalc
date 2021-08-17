//
//  AppInformation.swift
//  PWR
//
//  Created by James Warren on 6/8/21.
//

import Foundation

enum AppInformation {
    static var versionInfo: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as? String ?? "Couldn't get version"
        let build = dictionary["CFBundleVersion"] as? String ?? "Couldn't get build number"
        return "\(version) build \(build)"
    }
}
