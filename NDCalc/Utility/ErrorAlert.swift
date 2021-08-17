//
//  ErrorAlert.swift
//  PWR
//
//  Created by James Warren on 2/6/21.
//

import SwiftUI

struct ErrorAlert: Identifiable {

    // swiftlint:disable:next identifier_name
    var id: String { "\(title)\(body)" }

    let title: String
    let body: String

    var alert: Alert {
        Alert(title: Text(title), message: Text(body), dismissButton: .default(Text("Dismiss")))
    }

}
