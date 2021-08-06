//
//  HomeView.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import SwiftUI

struct HomeView<Model: HomeViewModelProtocol, Preference: PreferenceStoreProtocol>: View {
    @ObservedObject var model: Model
    @StateObject var settingsViewModel: SettingsViewModel<Preference>

    var body: some View {
        NavigationView {
            ZStack {
                mainView
                    .disabled(model.countdownViewActive)
                    .blur(radius: model.countdownViewActive ? 20 : 0)

                if model.countdownViewActive {
                    timerRunningView()
                    Spacer()
                }
            }
            .toolbar {
                NavigationLink(destination: SettingsView<Preference>(model: settingsViewModel)) {
                    Image(systemName: "gear")
                }
            }
        }
        .animation(.linear)
        .onAppear {
            model.requestNotificationPermission()
        }
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

    @ViewBuilder
    func timerRunningView() -> some View {
        VStack {
            CountdownCircleView(countdown: model.countdown, circleColor: .blue)
            Button {
                withAnimation {
                    model.countdownViewButtonTapped()
                }
            } label: {
                NDButton(color: .blue, text: model.countdownIsActive ? "Cancel" : "Done")
            }
        }
        .animation(.default)
    }

    func sideBySidePickers(fullWidth: CGFloat) -> some View {
        HStack {
            FilterPicker(selectedFilter: $model.selectedFilter, filterNotation: model.filterNotation)

                .frame(maxWidth: fullWidth / 2)
                .clipped()

            ShutterSpeedPicker(shutterSpeeds: model.shutterSpeeds,
                                selectedShutterSpeed: $model.selectedShutterSpeed)
                .frame(maxWidth: fullWidth / 2)
                .clipped()
        }

        .animation(.none)
    }

    var calculatedShutterSpeed: some View {
        VStack {
            Text("Calculated Time:")
                .font(.title)
            Text(model.calculatedShutterSpeedString)
                .font(.system(size: 70))
                .bold()
                .padding(.top)
        }
    }

    var startTimerButton: some View {
        Button {
            withAnimation {
                model.startCountdown()
            }
        } label: {
            NDButton(color: .blue, text: "Start timer")
                .opacity(model.isCurrentTimeValid ? 1.0 : 0.5)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next line_length
        HomeView<MockHomeViewModel, MockPreferenceController>(model: MockHomeViewModel(), settingsViewModel: SettingsViewModel<MockPreferenceController>(userPreferences: MockPreferenceController()))
    }
}
