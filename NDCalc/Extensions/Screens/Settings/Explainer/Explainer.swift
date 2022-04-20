//
//  Explainer.swift
//  NDCalc
//
//  Created by James Warren on 16/7/21.
//

import SwiftUI

/// This view is intended to show some explanation text, it displays a title,
/// a paragraph of information, and a dismiss button.
struct Explainer: View {
    @Environment(\.presentationMode) var presentationMode

    let model: ExplainerViewModel

    var body: some View {
        VStack {
            Spacer()

            Text(model.title)
                .font(.title)
                .padding()
            ScrollView {
                Text(model.explanation)
                    .padding()
            }
            Spacer()

            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                NDButton(color: .blue, text: "Done")
            }
        }
    }
}

struct Explainer_Previews: PreviewProvider {
    static var previews: some View {
        Explainer(model: ExplainerViewModel(title: "Preview", explanation: "Some preview content"))
    }
}
