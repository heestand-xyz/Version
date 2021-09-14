import XCTest
@testable import Version

final class VersionTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(Version("1.0.0"), Version(1, 0, 0))
        XCTAssertEqual(Version("1.0.0-beta"), Version(1, 0, 0, tag: "beta"))
        XCTAssertEqual("1.2.3", Version(1, 2, 3, tag: "beta").semantic)
        XCTAssertEqual("1.2.3-beta", Version(1, 2, 3, tag: "beta").semanticWithTag)
    }
}
