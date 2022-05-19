//
//  ApplicationStateStore.swift
//  NDCalc
//
//  Created by Personal James on 14/5/2022.
//

import Combine
import Depends
import Foundation
import UIKit

final class ApplicationStateStore: ApplicationStateStoreProtocol {

    var applicationState: CurrentValueSubject<ApplicationState, Never>
    let notificationCenter: NotificationCenter

    private var cancelables = Set<AnyCancellable>()

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        applicationState = CurrentValueSubject(.foreground)

        setupObservers()
    }

    private func setupObservers() {
        notificationCenter.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [unowned self] _ in
                applicationState.send(.background)
            }
            .store(in: &cancelables)

        notificationCenter.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [unowned self] _ in
                applicationState.send(.foreground)
            }
            .store(in: &cancelables)
    }
}
