//
//  OnboardingView.swift
//  NDCalc
//
//  Created by Personal James on 14/5/2022.
//

import Depends
import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.dynamicTypeSize) var textSize

    var body: some View {
        VStack {
            ScrollView {
                Text("Welcome!")
                    .font(.system(size: 50))
                    .bold()
                    .padding(.bottom)

                onboardingItem(
                    iconName: "camera.fill",
                    title: "Customize",
                    body: "Customise how filter strength and shutter speeds are displayed in the settings screen."
                )

                onboardingItem(
                    iconName: "clock.badge.exclamationmark.fill",
                    title: "Notifications",
                    body: "NDCalc works best when we have notification permission so you can be alerted when timers finish."
                )
            }

            Spacer()

            NavigationLink(destination: HomeView(
                model: HomeViewModel(dependencies: viewModel.dependencies)
            ), isActive: $viewModel.isShowingHomeView) { EmptyView() }

            Button {
                viewModel.tappedRequestNotificationPermission()
            } label: {
                NDButton(backgroundColor: .white, textColor: .blue, text: "Activate notifications")
            }

            NavigationLink(destination: HomeView(
                model: HomeViewModel(dependencies: viewModel.dependencies)
            ), isActive: $viewModel.isShowingHomeView) { EmptyView() }

            Button {
                viewModel.tappedNoNotification()
            } label: {
                Text("I'd rather not")
                    .bold()
            }
        }

        .foregroundColor(.white)
        .background(Color.blue)
    }

    @ViewBuilder
    private func onboardingItem(iconName: String, title: String, body: String) -> some View {
        if textSize.isAccessibilitySize {
            VStack {
                Image(systemName: iconName)
                    .font(.largeTitle)
                    .padding()
                VStack(alignment: .center) {
                    Text(title)
                        .font(.headline)
                    Text(body)
                }
                .multilineTextAlignment(.center)
            }
            .padding()
        } else {
            HStack {
                Image(systemName: iconName)
                    .font(.largeTitle)
                    .padding()
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(body)
                }

            }
            .padding()
        }

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static let dependancies = DependencyRegistry()

    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel(dependencies: dependancies))

        OnboardingView(viewModel: OnboardingViewModel(dependencies: dependancies))
            .environment(\.sizeCategory, .accessibilityLarge)
    }
}
