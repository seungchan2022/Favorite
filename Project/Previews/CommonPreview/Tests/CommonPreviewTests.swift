import XCTest
@testable import CommonPreview

final class CommonPreviewTests: XCTestCase {
  func testExample() throws {
    XCTAssertEqual(echo(), "Hello, World!!")
  }

  func echo() -> String {
    "Hello, World!!"
  }
}
