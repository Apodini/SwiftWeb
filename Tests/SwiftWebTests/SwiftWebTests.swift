import XCTest
@testable import SwiftWeb

final class SwiftWebTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftWeb().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
