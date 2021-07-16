//
//  HomeView.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import SwiftUI

struct HomeView<Model: HomeViewModelProtocol, Preference: PreferenceControllerProtocol>: View {
    @ObservedObject var model: Model
    @StateObject private var settingsViewModel = SettingsViewModel<Preference>()

    var body: some View {
        NavigationView {
            ZStack {
                mainView
                    .disabled(model.timerViewActive)
                    .blur(radius: model.timerViewActive ? 20 : 0)

                if model.timerViewActive {
                    timerRunningView
                }
            }
            .toolbar {
                NavigationLink(destination: SettingsView<Preference>(model: settingsViewModel)) {
                    Image(systemName: "gear")
                }
        }
        }
    }

    var mainView: some View {
        GeometryReader { geometry in
            VStack {
                Text("Calculated Time:")
                    .font(.title)
                Text(model.calculatedShutterSpeedString)
                    .font(.largeTitle)

                Spacer()

                HStack {
                    VStack {
                        Text("Selected filter")

                        Picker(selection: $model.selectedFilterIndex, label: Text("Selected Filter")) {
                            ForEach(0..<Filter.filters.count) { filterIndex in
                                Text("\(Filter.filters[filterIndex].value)")
                                    .tag(filterIndex)
                            }
                        }
                        .frame(maxWidth: geometry.size.width / 2)
                        .clipped()
                    }
                    VStack {
                        Text("Selected exposure time")
                        Picker(selection: $model.selectedShutterSpeed, label: Text("Selected exposure")) {
                            ForEach(model.shutterSpeeds) { shutterSpeed in
                                Text(shutterSpeed.stringRepresentation)
                                    .tag(shutterSpeed)

                            }
                        }
                        .frame(maxWidth: geometry.size.width / 2)
                        .clipped()
                    }
                }

                Spacer()

                startTimerButton
                    .disabled(!model.isValidTime)

                Spacer()
            }
        }
    }

    var timerRunningView: some View {
        VStack {
            CountdownCircleView(totalRunLength: CGFloat(model.calculatedShutterSpeed.seconds), circleColor: .blue)
            Button {
                withAnimation {
                    model.cancelTimer()
                }
            } label: {
                NDButton(color: .blue, text: model.timerIsRunning ? "Cancel" : "Done")
            }
        }
        .animation(.default)
    }

    var startTimerButton: some View {
        Button {
            withAnimation {
                model.startTimer()
            }
        } label: {
            NDButton(color: .blue, text: "Start timer")
                .opacity(model.isValidTime ? 1.0 : 0.5)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView<MockHomeViewModel, MockPreferenceController>(model: MockHomeViewModel())
    }
}
