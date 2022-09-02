import XCTest

fileprivate let outputDirectory = URL(
  fileURLWithPath: "../Sources/WatchDatePicker/Documentation.docc/Resources",
  relativeTo: URL(fileURLWithPath: #filePath)
)

extension XCUIScreenshotProviding {
  func saveScreenshot(as name: String) {
    try! screenshot().pngRepresentation.write(to: outputDirectory.appendingPathComponent("\(name).png"))
  }
}

class DatePickerScreenshots: XCTestCase {
//  override class var runsForEachTargetApplicationUIConfiguration: Bool {
//    true
//  }
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  func testLaunch() throws {
    let app = XCUIApplication()
    app.launch()
    
    
    
    app.saveScreenshot(as: "__DatePicker~hourAndMinute")
    
//    print(app.debugDescription)
//    print(app.otherElements.count)
//    print(app.collectionViews.count)
//    print(app.otherElements.matching(identifier: "PageView").count)
//    print(app.otherElements.matching(identifier: "PageView"))
//
//    app.otherElements.matching(identifier: "PageView").firstMatch.swipeLeft(velocity: .fast)
//
//    sleep(1)
//
//    app.saveScreenshot(as: "__DatePicker~2")
//
//    app.otherElements.matching(identifier: "PageView").firstMatch.swipeRight(velocity: .fast)
//
//        sleep(1)
//
//    app.saveScreenshot(as: "__DatePicker~3")
  }
}
