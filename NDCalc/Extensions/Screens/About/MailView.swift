//
//  MailView.swift
//  NDCalc
//
//  Created by James Warren on 26/5/21.
//
// https://stackoverflow.com/questions/56784722/swiftui-send-email
import MessageUI
import SwiftUI

enum MailError: Error, Identifiable, Hashable, LocalizedError {
    var id: Self { self }
    case noMailAccount
    case unknownError(String)

    public var errorDescription: String? {
        switch self {
        case .noMailAccount:
            // swiftlint:disable:next line_length
            return "No mail account configured on your device, please set one up and try again or use the support link for my website"
        case .unknownError(let errorText):
            return errorText
        }
    }
}

public struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    let subject: MailSubject

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result

            super.init()

            if !MFMailComposeViewController.canSendMail() {
                self.result = .failure(MailError.noMailAccount)
                self.$presentation.wrappedValue.dismiss()
            }
        }

        public func mailComposeController(_ controller: MFMailComposeViewController,
                                          didFinishWith result: MFMailComposeResult,
                                          error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) ->
    MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        configureMailCompose(mailVC: viewController)
        return viewController
    }

    public func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>) {

    }

    func configureMailCompose(mailVC: MFMailComposeViewController) {
        mailVC.setSubject("\(subject.rawValue) - \(AppInformation.versionInfo)")
        mailVC.setToRecipients([StringConstants.feedbackEmail])
        mailVC.setMessageBody("Hi James,\n\n", isHTML: false)
    }
}
