//
//  CountdownCircleView.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import SwiftUI
import Combine

struct CountdownCircleView: View {
//    let countdown: Countdown?
    @ObservedObject private var viewModel: CountdownCircleViewModel
    let circleColor: Color

//    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//    @State var completionAmount = 1.0
//
//    @State private var circleReseting = false

//    private var timerDone: Bool {
//        countdown?.isComplete ?? true
//    }

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

//struct CountdownCircleView_Previews: PreviewProvider {
//    static var previews: some View {
//        // swiftlint:disable:next force_try
//        CountdownCircleView(countdown: try! Countdown(endsAt: Date(timeIntervalSinceNow: 3.0)), circleColor: .blue)
//    }
//}
