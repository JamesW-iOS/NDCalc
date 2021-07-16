//
//  CountdownCircleView.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import SwiftUI
import Combine

struct CountdownCircleView: View {
    private static let updateFrequency = 0.1

    let totalRunLength: CGFloat
    let circleColor: Color

    @State private var currentRunLength: CGFloat = 0.0
    let timer = Timer.publish(every: Self.updateFrequency, on: .main, in: .common).autoconnect()

    private var completionAmount: CGFloat {
        currentRunLength / totalRunLength
    }

    private var secondsLeft: String {
        // Taking magnitude here since floating point rounding error can leave us with a slightly negative number that will cause the string to be -0 which look wrong
        String(format: "%.0f", (totalRunLength - currentRunLength).magnitude)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(circleColor)

            Circle()
                .trim(from: 0.0, to: completionAmount)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(circleColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text(secondsLeft)
                .font(.largeTitle)

        }
        .padding()
        .onReceive(timer) { time in
            if (currentRunLength - totalRunLength).magnitude < 0.001  {
                self.timer.upstream.connect().cancel()
            }
            currentRunLength += Self.updateFrequency

        }
    }
}

struct CountdownCircleView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownCircleView(totalRunLength: 5.0, circleColor: .blue)
    }
}
