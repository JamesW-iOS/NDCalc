////
////  ContentView.swift
////  NDCalc
////
////  Created by James Warren on 3/4/21.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                VStack {
//                    Text("Calculated Time:")
//                        .font(.title)
//                    Text(calculatedShutterSpeedString)
//                        .font(.largeTitle)
//
//                    Spacer()
//
//                    HStack {
//                        VStack {
//                            Text("Selected filter")
//
//                            Picker(selection: $selectedFilterIndex, label: Text("Selected Filter")) {
//                                ForEach(0..<filters.count) { filterIndex in
//                                    Text("\(filters[filterIndex].value)")
//                                        .tag(filterIndex)
//                                }
//                            }
//                            .frame(maxWidth: geometry.size.width / 2)
//                            .clipped()
//                        }
//                        VStack {
//                            Text("Selected exposure time")
//                            Picker(selection: $selectedExposureIndex, label: Text("Selected exposure")) {
//                                ForEach(0..<Self.shutterSpeeds[shutterIntervalIndex].count) { exposureIndex in
//                                        Text(Self.shutterSpeeds[shutterIntervalIndex][exposureIndex].stringRepresentation)
//                                            .tag(exposureIndex)
//                                    }
//                                }
//                                .frame(maxWidth: geometry.size.width / 2)
//                                .clipped()
//                            }
//                        }
//
//                    Spacer()
//
//                    startTimerButton
//                        .disabled(!isValidTime)
//
//                    Spacer()
//                }
//                .disabled(hasTimeRunning)
//                .blur(radius: hasTimeRunning ? 20 : 0)
//
//                if let nextTimer = nextTimer {
//                    if timeInFuture(nextTimer) {
//                        VStack {
//                            CountdownCircleView(totalRunLength: CGFloat(calculatedShutterSpeed.seconds), circleColor: .blue)
//                            Button {
//
//                            } label: {
//                                NDButton(color: .blue, text: "Cancel")
//                            }
//                        }
//                    } else {
//                        VStack {
//                            Text("Exposure complete")
//
//                            Button {
//                                withAnimation {
//                                    self.nextTimer = nil
//                                }
//                            } label: {
//                                NDButton(color: .blue, text: "Done")
//                            }
//                        }
//
//                    }
//                }
//
//            }
//            .onAppear(perform: requestNotificationPermission)
//            .animation(.default)
//        }
//    }
//
//    var startTimerButton: some View {
//        Button {
//            withAnimation {
//                startTimer()
//            }
//        } label: {
//            NDButton(color: .blue, text: "Start timer")
//                .opacity(isValidTime ? 1.0 : 0.5)
//        }
//    }
//
//
//    private func startTimer() {
//        let centre = UNUserNotificationCenter.current()
//
//        let content = UNMutableNotificationContent()
//        content.title = "Exposure finished"
//        content.body = "Your exposure has finished"
//        content.sound = UNNotificationSound.defaultCritical
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(calculatedShutterSpeed.seconds), repeats: false)
//        let identifier = UUID().uuidString
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        notificationIdentifier = identifier
//
//        centre.add(request) { (error) in
//            if let error = error {
//                print("error while scheduling notification: \(error.localizedDescription)")
//            }
//        }
//        let timerAlertTime = Date(timeIntervalSinceNow: Double(calculatedShutterSpeed.seconds)).timeIntervalSince1970
//        self.nextTimer = timerAlertTime
//    }
//
//    private func cancelTimer() {
//        nextTimer = nil
//    }
//
//    private func timeInFuture(_ seconds: Double) -> Bool {
//        let date = Date(timeIntervalSince1970: seconds)
//
//
//        return date > Date()
//    }
//
//    private func requestNotificationPermission() {
//        let centre = UNUserNotificationCenter.current()
//
//        centre.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
//            if let error = error {
//                fatalError("error while requesting notification: \(error.localizedDescription)")
//            }
//
//            if result {
//                print("can send notifications")
//            } else {
//                print("can't send notifications")
//            }
//        }
//    }
//
//
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
