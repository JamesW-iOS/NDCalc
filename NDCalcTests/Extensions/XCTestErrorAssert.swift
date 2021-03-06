//
//  XCTestErrorAssert.swift
//  NDCalc
//
//  Created by James Warren on 23/7/21.
//

// This extension is taken from a Swift By Sundell article
// https://www.swiftbysundell.com/articles/testing-error-code-paths-in-swift/

import XCTest

extension XCTestCase {
    func assert<T, E: Error & Equatable>(_ expression: @autoclosure () throws -> T,
                                         throws error: E,
                                         in file: StaticString = #file,
                                         line: UInt = #line) {
        var thrownError: Error?

        XCTAssertThrowsError(try expression(),
                             file: file, line: line) {
            thrownError = $0
        }

        XCTAssertTrue(
            thrownError is E,
            "Unexpected error type: \(type(of: thrownError))",
            file: file, line: line
        )

        XCTAssertEqual(
            thrownError as? E, error,
            file: file, line: line
        )
    }
}
