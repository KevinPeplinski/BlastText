import XCTest
@testable import BlastText

final class BlastTextTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(BlastText().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
