import XCTest
@testable import SwiftWeb

final class SwiftWebTests: XCTestCase {
    func testHTMLTemplateContent() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssert(HTMLTemplate.withContent("testcontent").contains("testcontent"),
                  "HTML template doesn't render supplied content")
    }

    static var allTests = [
        ("testHTMLTemplateContent", testHTMLTemplateContent)
    ]
}
