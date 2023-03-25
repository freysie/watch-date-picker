import XCTest

let watchDeviceSizes = [
  162.0: "40mm",
  176.0: "41mm",
  184.0: "44mm",
  198.0: "45mm",
  205.0: "49mm",
]

let outputDirectory = URL(fileURLWithPath: "../QA", relativeTo: URL(fileURLWithPath: #filePath))

extension XCUIScreenshotProviding {
  func saveScreenshot(as name: String) {
    Thread.sleep(forTimeInterval: 0.2) // wait for crown indicator to disappear
    try! screenshot().pngRepresentation.write(to: outputDirectory.appendingPathComponent("\(name).png"))
  }
}

class DatePickerScreenshots: XCTestCase {
  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  func testSystemTimeInputView() throws {
    let config = value(forKey: "testRunConfiguration") as! NSDictionary
    guard config["XCUIAppearanceMode"] as! Int == 1 else { return }

    let app = XCUIApplication()
    app.launch()
    app.buttons["System Time Input View"].tap()
    sleep(1)

    let size = watchDeviceSizes[app.frame.width]!
    let locale = config["XCUIApplicationLocalization"] as! String
    app.saveScreenshot(as: "DatePicker_hourAndMinute@\(size)~\(locale)~system")
  }
  
  func testDatePicker_hourAndMinute() throws {
    let config = value(forKey: "testRunConfiguration") as! NSDictionary
    guard config["XCUIAppearanceMode"] as! Int == 1 else { return }

    let app = XCUIApplication()
    app.launch()
    app.buttons.element(boundBy: 1).tap()
    sleep(2)

    let size = watchDeviceSizes[app.frame.width]!
    let locale = config["XCUIApplicationLocalization"] as! String
    app.saveScreenshot(as: "DatePicker_hourAndMinute@\(size)~\(locale)")
  }
  
//  func testMore() throws {
//    let app = XCUIApplication()
//    app.launch()
//
//    app.swipeLeft()
//    app.swipeLeft()
//    app.swipeLeft()
//    app.swipeLeft()
//    app.swipeLeft()
//
//    app.buttons["AM"].saveScreenshot(as: "__DatePicker_test")
//
//    app.saveScreenshot(as: "__DatePicker_test2")
//  }
}
