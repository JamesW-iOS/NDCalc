//
//  HomeView.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var model: HomeViewModel
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        ZStack {
            if sizeCategory.isAccessibilityCategory {
                accessibilityMainView
                    .disabled(model.countdownViewActive)
                    .blur(radius: model.countdownViewActive ? 20 : 0)
            } else {
                mainView
                    .disabled(model.countdownViewActive)
                    .blur(radius: model.countdownViewActive ? 20 : 0)
            }

            timerRunningView()
                .opacity(model.countdownViewActive ? 1.0 : 0.0)
                .disabled(!model.countdownViewActive)
        }
        .toolbar {
            NavigationLink(destination: SettingsView(model: model.settingsViewModel)) {
                Image(systemName: "gear")
            }
        }
        .navigationBarBackButtonHidden(true)
        .animation(.linear, value: model.countdownViewActive)
    }

    var mainView: some View {
        GeometryReader { geometry in
            VStack {
                calculatedShutterSpeed

                Spacer()

                sideBySidePickers(fullWidth: geometry.size.width)

                Spacer()

                startTimerButton
                    .disabled(!model.isCurrentTimeValid)
            }
        }
    }

    var accessibilityMainView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    calculatedShutterSpeed

                    FilterPicker(
                        selectedFilter: $model.selectedFilter,
                        filterNotation: model.filterNotation,
                        shouldDisplayAcceccibiltyMode: true,
                        width: geometry.size.width
                    )

                    ShutterSpeedPicker(
                        shutterSpeeds: model.shutterSpeeds,
                        selectedShutterSpeed: $model.selectedShutterSpeed,
                        shouldDisplayAcceccibiltyMode: true,
                        width: geometry.size.width
                    )

                    startTimerButton
                        .disabled(!model.isCurrentTimeValid)
                }
            }
        }
    }

    @ViewBuilder
    func timerRunningView() -> some View {
        VStack {
            CountdownCircleView(viewModel: model.countdownViewModel, circleColor: .blue)
            Button {
                withAnimation {
                    model.countdownViewButtonTapped()
                }
            } label: {
                NDButton(text: model.countdownIsActive ? "Cancel" : "Done")
            }
        }
    }

    func sideBySidePickers(fullWidth: CGFloat) -> some View {
        NDPicker(filters: Filter.filters,
                 shutterSpeeds: model.shutterSpeeds,
                 selectedFilter: $model.selectedFilter,
                 selectedShutterSpeed: $model.selectedShutterSpeed,
                 filterNotation: model.filterNotation)
    }

    var calculatedShutterSpeed: some View {
        VStack {
            Text("Calculated Time:")
                .font(.title)
                .fixedSize(horizontal: false, vertical: true)
            Text(model.calculatedShutterSpeedString)
                .font(.system(.largeTitle, design: .monospaced))
                .bold()
                .multilineTextAlignment(.center)
                .scaledToFit()
                .minimumScaleFactor(0.4)
                .padding()
        }
    }

    var startTimerButton: some View {
        Button {
            withAnimation {
                model.startCountdown()
            }
        } label: {
            NDButton(text: "Start timer")
                .opacity(model.isCurrentTimeValid ? 1.0 : 0.5)
        }
    }
}
