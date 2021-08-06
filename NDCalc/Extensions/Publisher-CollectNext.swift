//
//  Publisher-CollectNext.swift
//  NDCalc
//
//  Created by James Warren on 6/8/21.
//

import Combine

extension Published.Publisher {
    func collectNext(_ count: Int) -> AnyPublisher<[Output], Never> {
        self
            .collect(count)
            .first()
            .eraseToAnyPublisher()
    }
}
