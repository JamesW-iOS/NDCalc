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

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)

                // swiftlint:disable:next line_length
                Text("You can customise how filter strength and shutter speeds are represented in the settings screen. Choose the setting that best matches your camera.")
                    .padding(.bottom)

                // swiftlint:disable:next line_length
                Text("NDCalc works best when we have notification permission. That way you can be notifified when your timer ends even if you lock your phone.")

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
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let dependancies = DependencyRegistry()

        return OnboardingView(viewModel: OnboardingViewModel(dependencies: dependancies))
    }
}
