//
//  CountdownCircleView.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import SwiftUI
import Combine

struct CountdownCircleView: View {
    private static let updateFrequency = 0.005

    let countdown: Countdown
    let circleColor: Color

    let timer = Timer.publish(every: Self.updateFrequency, on: .main, in: .common).autoconnect()
    @State var completionAmount = 1.0

    private var secondsLeft: String {
        // Taking magnitude here since floating point rounding error can leave us with a slightly negative number that will cause the string to be -0 which look wrong
        String(format: "%.0f", countdown.secondsLeft.magnitude)
    }

    private var timerDone: Bool {
        countdown.isComplete
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(circleColor)

            Circle()
                .trim(from: 0.0, to: CGFloat(completionAmount))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(circleColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            if timerDone {
                Text("Complete")
                    .font(.largeTitle)
            } else {
                VStack {
                    Text(secondsLeft)
                        .font(.largeTitle)
                    Text("Seconds left")
                }
            }


        }
        .padding()
        .onReceive(timer) { time in
            completionAmount = countdown.completionAmount
            if completionAmount < 0 {
                timer.upstream.connect().cancel()
            }
        }
    }
}

struct CountdownCircleView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownCircleView(countdown: try! Countdown(endsAt: Date(timeIntervalSinceNow: 3.0)), circleColor: .blue)
    }
}
