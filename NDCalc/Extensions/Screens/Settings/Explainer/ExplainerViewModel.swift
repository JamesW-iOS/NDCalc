//
//  ExplainerViewModel.swift
//  NDCalc
//
//  Created by James Warren on 16/7/21.
//

import Foundation
import SwiftUI

/// A struct to hold the data for an explanation, for passing to an ExplainerView.
struct ExplainerViewModel: Identifiable {
    var id: String { title + explanation }

    /// The title to be shown at the top of the view, should be the setting being explained
    let title: String
    /// The explanation of what the setting means
    let explanation: String
}
