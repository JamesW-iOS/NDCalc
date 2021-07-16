//
//  NDButton.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import SwiftUI

struct NDButton: View {
    let color: Color
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
