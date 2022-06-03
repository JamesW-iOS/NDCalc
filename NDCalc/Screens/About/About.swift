//
//  About.swift
//  NDCalc
//
//  Created by James Warren on 16/7/21.
//

import SwiftUI
import MessageUI

enum MailSubject: String {
    case feature = "[FEATURE]"
    case bug = "[BUG]"
    case feedback = "[FEEDBACK]"

}

struct About: View {
    @State var mailSubject = MailSubject.feedback
    @State private var isShowingMailView = false
    @State private var mailError: ErrorAlert?

    var mailSubjectText: String {
        return "\(mailSubject.rawValue) - \(versionInfo)"
    }

    var versionInfo: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as? String ?? "Couldn't get version"
        let build = dictionary["CFBundleVersion"] as? String ?? "Couldn't get build number"
        return "\(version) build \(build)"
    }

    var body: some View {
        VStack {
            if BundleItems.icon != nil {
                BundleItems.icon!
                    .resizable()
                    .scaledToFit()
                    .frame(width: 114, height: 114)
                    .cornerRadius(18)
                    .frame(maxWidth: .infinity)
            }
            appInformation

            List {
                Section(header: Text("Email me")) {
                    Button("Request a feature") {
                        openMailApp(for: .feature)
                    }
                    Button("Submit a bug") {
                        openMailApp(for: .bug)
                    }
                    Button("General feedback") {
                        openMailApp(for: .feedback)
                    }
                }

                Section(header: Text("Connect with me")) {
                    Link("Follow me on Twitter", destination: URL(string: "https://twitter.com/JamesW-tech")!)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .foregroundColor(.primary)
        }
        .alert(item: $mailError) { mailError in
            mailError.alert
        }
    }

    var appInformation: some View {
        VStack {
            Text("NDCalc")
                .font(.title3)
                .bold()
            Text("Version: \(BundleItems.versionNumber)")
                .font(.body)
            Text(AboutCopy.aboutMe)
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }

    private func openMailApp(for mailType: MailSubject) {
        let address = StringConstants.feedbackEmail
        let subject = "\(mailType.rawValue) - \(AppInformation.versionInfo)"

        let body = "Hi James\n\n"

        var components = URLComponents()
        components.scheme = "mailto"
        components.path = address
        components.queryItems = [
              URLQueryItem(name: "subject", value: subject),
              URLQueryItem(name: "body", value: body)
        ]

        guard let url = components.url else {
            assertionFailure("Failed to make url for mail view")
            showMailError()
            return
        }

        UIApplication.shared.open(url) { success in
            if success == false {
                showMailError()
            }
        }
    }

    private func showMailError() {
        mailError = ErrorAlert(
            title: "Failed to open mail",
            body: "Unable to open a mail app to submit report, check you have a mail app or feel free to reach out on Twitter."
            // swiftlint:disable:previous line_length
        )
    }

    enum AboutCopy {
        static let aboutMe = "Developed by James, solo indie developer in Melbourne Australia."
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
