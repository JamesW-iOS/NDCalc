//
//  NDButton.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import SwiftUI

/// This view is a standard button that is used in most places int the app.
struct NDButton: View {
    /// Background color of the button.
    let backgroundColor: Color
    let textColor: Color
    /// The text to be displayed in the button.
    let text: String

    init(backgroundColor: Color = .blue, textColor: Color = .white, text: String) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(10)
            .padding(25)
    }
}

struct NDButton_Previews: PreviewProvider {
    static var previews: some View {
        NDButton(backgroundColor: .blue, textColor: .white, text: "Test button")
    }
}
