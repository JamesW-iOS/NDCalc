//
//  ReviewController.swift
//  NDCalc
//
//  Created by Personal James on 13/11/2022.
//

import Combine
import Depends
import Foundation
import Network
import StoreKit

final class ReviewController: DependencyProvider {
    static let totalCountdownsKey = "totalCountdowns"
    static let lastShownReviewPromptKey = "lastShownReviewKey"

    @Dependency(.userDefaults) private var userDefaults
    @Dependency(.countdownController) private var countdownController

    var dependencies: DependencyRegistry
    let monitor = NWPathMonitor()

    private var cancelables = Set<AnyCancellable>()
    private var hasConnection = false

    init(dependancies: DependencyRegistry) {
        self.dependencies = dependancies

        monitor.pathUpdateHandler = { [weak self] path in
            self?.hasConnection = path.status == .satisfied
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)

        countdownController.currentCountdownPublisher
            .dropFirst()
            .filter { $0 == nil }
            .sink { [unowned self] _ in countdownComplete() }
            .store(in: &cancelables)
    }

    private func countdownComplete() {
        let minimumCountdowns = 5
        let lastVersionPromptedForReview = userDefaults.string(forKey: Self.lastShownReviewPromptKey)
        let infoDictionaryKey = kCFBundleVersionKey as String
        // swiftlint:disable:next force_cast
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as! String

        var total = userDefaults.integer(forKey: Self.totalCountdownsKey)
        total += 1
        userDefaults.set(total, forKey: Self.totalCountdownsKey)

        guard total > minimumCountdowns, currentVersion != lastVersionPromptedForReview, hasConnection else {
            return
        }

        userDefaults.set(currentVersion, forKey: Self.lastShownReviewPromptKey)
        SKStoreReviewController.requestReview()
    }
}
