//
//  BundleItems.swift
//  NDCalc
//
//  Created by James Warren on 19/7/21.
//

import SwiftUI

enum BundleItems {
    static var versionNumber: String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            assertionFailure("Error occured while trying to get the version number")
            return ""
        }
        return appVersion
    }

    static var icon: Image? {
        Image("Icon", bundle: Bundle.main)
    }
}
