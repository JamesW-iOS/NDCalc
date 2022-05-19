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

    @State private var result: Result<MFMailComposeResult, Error>? {
        didSet {
            if let result = result {
                switch result {
                case .failure(let error):
                    mailError = ErrorAlert(title: "Error occurred", body: error.localizedDescription)
                case .success:
                    mailError = nil
                }
            }
        }
    }

    var mailSubjectText: String {
        return "\(mailSubject.rawValue) - \(versionInfo)"
    }

    var versionInfo: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as? String ?? "Couldn't get version"
        let build = dictionary["CFBundleVersion"] as? String ?? "Couldn't get build number"
        return "\(version) build \(build)"
    }

    var shouldShowError: Bool {
        if let result = result {
            switch result {
            case .failure:
                return true
            case .success:
                return false
            }
        }

        return false
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
        .sheet(isPresented: $isShowingMailView, content: {
            MailView(result: $result, subject: mailSubject)
        })
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

    enum AboutCopy {
        static let aboutMe = "Developed by James, solo indie developer in Melbourne Australia."
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
