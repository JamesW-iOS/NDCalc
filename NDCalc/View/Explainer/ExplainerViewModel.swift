//
//  ExplainerViewModel.swift
//  NDCalc
//
//  Created by James Warren on 16/7/21.
//

import Foundation
import SwiftUI

struct ExplainerViewModel: Identifiable {
    // swiftlint:disable:next identifier_name
    var id: String { title + explanation }

    let title: String
    let explanation: String
}
