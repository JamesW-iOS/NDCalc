//
//  NSCalcWidget.swift
//  NSCalcWidget
//
//  Created by Personal James on 22/9/2022.
//

import WidgetKit
import SwiftUI

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeWidth = 25.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

@main
struct Widgets: WidgetBundle {
    var body: some Widget {
        TimerActivityWidget()
    }
}

struct TimerRunningView: View {
    var timer: TimerActivityAttributes

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "timer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .padding(.trailing, 4)

            VStack {
                Text(timer.exposure)
                Text(timer.filter)
            }
            .font(.headline.monospaced())
            .padding(.trailing)

            Spacer()

            VStack(alignment: .leading) {
                Text(timerInterval: timer.timerStart...timer.timerEnd, countsDown: true)
                    .font(.largeTitle.monospaced())

                Text("Time remaining")
                    .font(.footnote.monospaced())
            }
        }
        .padding()
    }
}

struct TimerActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            if context.state.isRunning {
                TimerRunningView(timer: context.attributes)
            } else {
                Text("Exposure finished")
                    .font(.headline)
                    .padding()
            }

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "timer")
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    ProgressView(
                        timerInterval: context.attributes.timerStart...context.attributes.timerEnd,
                        countsDown: true
                    )
                    .foregroundColor(.white)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text("Exposure: \(context.attributes.exposure)s")
                        Text("Filter: \(context.attributes.filter)")
                    }
                    .font(.headline.monospaced())
                }
                DynamicIslandExpandedRegion(.center) {
                }
            } compactLeading: {
                HStack {
                    Image(systemName: "timer")

                    VStack {
                        Text("\(context.attributes.exposure)s")
                        Text(context.attributes.filter)
                    }
                    .font(.system(size: 12).monospaced())
                    .padding(.leading, 2)
                }
            } compactTrailing: {
                ProgressView(
                    timerInterval: context.attributes.timerStart...context.attributes.timerEnd,
                    countsDown: true
                )
                .padding(.trailing, 2)
                .foregroundColor(.white)
            } minimal: {
                ProgressView(
                    timerInterval: context.attributes.timerStart...context.attributes.timerEnd,
                    countsDown: true
                )
                .progressViewStyle(.circular)
            }
        }
    }
}
