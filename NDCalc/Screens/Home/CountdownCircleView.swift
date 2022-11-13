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

    @State private var circleCompletion: CGFloat = 1

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
                    .trim(from: 0.0, to: circleCompletion)
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(circleColor)
                    .rotationEffect(Angle(degrees: 270.0))
            }
//            .animation(.linear(duration: viewModel.animationDuration), value: viewModel.completionAmount)
            Text(viewModel.secondsLeft)
                .font(.system(.largeTitle, design: .monospaced))
                .animation(.none)
        }
        .padding()
        .onChange(of: viewModel.circleAnimation) { animation in
            if let animation = animation {
                if animation.reseting {
                    withAnimation(.linear(duration: animation.over)) {
                        circleCompletion = 1
                    }
                } else {
                    circleCompletion = animation.from
                    withAnimation(.linear(duration: animation.over)) {
                        circleCompletion = 0
                    }
                }
            } else {
                circleCompletion = 0
                withAnimation(.linear(duration: 0.7)) {
                    circleCompletion = 1
                }
            }
        }
    }
}
