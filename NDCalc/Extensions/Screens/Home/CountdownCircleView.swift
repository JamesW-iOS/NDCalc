//
//  CountdownCircleView.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import SwiftUI
import Combine

struct CountdownCircleView: View {
    @ObservedObject private var viewModel: CountdownCircleViewModel
    let circleColor: Color

    init(viewModel: CountdownCircleViewModel, circleColor: Color) {
        self.viewModel = viewModel
        self.circleColor = circleColor
    }

    var body: some View {
        ZStack {
            Group {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.3)
                    .foregroundColor(circleColor)

                Circle()
                    .trim(from: 0.0, to: CGFloat(viewModel.completionAmount))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(circleColor)
                    .rotationEffect(Angle(degrees: 270.0))
            }
            .animation(.linear(duration: viewModel.animationDuration), value: viewModel.completionAmount)
            Text(viewModel.secondsLeft)
                .font(.largeTitle)
                .animation(.none)
        }
        .padding()
    }
}
