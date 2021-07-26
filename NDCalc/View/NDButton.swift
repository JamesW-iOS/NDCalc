//
//  NDButton.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import SwiftUI

/// This view is a standard button that is used in most places int the app.
struct NDButton: View {
    /// Initialises a new NDButton with specified label and background color
    /// - Parameters:
    ///   - color: Background color of the button
    ///   - text: The text to be shown in the button
    init(color: Color, text: String) {
        self.color = color
        self.text = text
    }

    /// Background color of the button.
    let color: Color
    /// The text to be displayed in the button.
    let text: String

    var body: some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(25)
    }
}

struct NDButton_Previews: PreviewProvider {
    static var previews: some View {
        NDButton(color: .red, text: "Test button")
    }
}
