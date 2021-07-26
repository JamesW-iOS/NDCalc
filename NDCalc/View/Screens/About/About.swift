//
//  About.swift
//  NDCalc
//
//  Created by James Warren on 16/7/21.
//

import SwiftUI
import MessageUI

struct About: View {
    enum MailSubject { case feature, bug, feedback}

    @State var mailSubject = MailSubject.feedback
    @State private var result: Result<MFMailComposeResult, Error>?
    @State private var isShowingMailView = false

    var mailSubjectText: String {
        var mailSubjectString = ""
        switch mailSubject {
        case .bug:
            mailSubjectString = "ND [BUG]"
        case .feature:
            mailSubjectString = "ND [FEATURE]"
        case .feedback:
            mailSubjectString = "ND [FEEDBACK]"
        }

        return "\(mailSubjectString) - \(versionInfo)"
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
                        mailSubject = .feature
                        isShowingMailView = true
                    }
                    Button("Submit a bug") {
                        mailSubject = .bug
                        isShowingMailView = true
                    }
                    Button("General feedback") {
                        mailSubject = .feedback
                        isShowingMailView = true
                    }
                }

                Section(header: Text("Connect with me")) {
                    Link("Follow me on Twitter", destination: URL(string: "https://twitter.com/TheTRexDev")!)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .foregroundColor(.primary)

        }
    }

    var appInformation: some View {
        VStack {
            Text("The Photographers Weather Report")
                .font(.title3)
                .bold()
            Text("Version: \(BundleItems.versionNumber)")
                .font(.body)
            Text("Homegrown in the land down under")
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity)
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
