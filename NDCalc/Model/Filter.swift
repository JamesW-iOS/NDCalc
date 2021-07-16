//
//  Filter.swift
//  NDCalc
//
//  Created by James Warren on 2/7/21.
//

import Foundation

struct Filter: Identifiable, Hashable {
    let value: Int
    var id: Int { value }

    static let filters = [
        Filter(value: 1),
        Filter(value: 2),
        Filter(value: 3),
        Filter(value: 4),
        Filter(value: 5),
        Filter(value: 6),
        Filter(value: 7),
        Filter(value: 8),
        Filter(value: 9),
        Filter(value: 10),
        Filter(value: 11),
        Filter(value: 12),
        Filter(value: 13),
        Filter(value: 14)
    ]
}
