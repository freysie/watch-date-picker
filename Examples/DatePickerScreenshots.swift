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

  private func swipeForward(_ app: XCUIApplication) {
    let config = value(forKey: "testRunConfiguration") as! NSDictionary
    let locale = config["XCUIApplicationLocalization"] as? String ?? "en"
    if NSLocale.characterDirection(forLanguage: locale) == .rightToLeft {
      app.swipeRight()
    } else {
      app.swipeLeft()
    }
  }
  
  func testSystemTimeInputViewComparison() throws {
    let config = value(forKey: "testRunConfiguration") as! NSDictionary
    guard config["XCUIAppearanceMode"] as? Int != 2 else { return }

    let app = XCUIApplication()
    app.launch()

    let size = watchDeviceSizes[app.frame.width]!
    let locale = config["XCUIApplicationLocalization"] as? String ?? "en"

    app.buttons["System Time Input View"].tap()
    app.saveScreenshot(as: "DatePicker_hourAndMinute@\(size)~\(locale)~system")

    app.buttons.matching(identifier: "CancelButton").element.tap()
    app.buttons.element(boundBy: 1).tap()

    app.saveScreenshot(as: "DatePicker_hourAndMinute@\(size)~\(locale)")
  }

  func testDatePicker() throws {
    let config = value(forKey: "testRunConfiguration") as! NSDictionary
    guard config["XCUIAppearanceMode"] as? Int != 2 else { return }

    let app = XCUIApplication()
    app.launch()

    let size = watchDeviceSizes[app.frame.width]!
    let locale = config["XCUIApplicationLocalization"] as? String ?? "en"

    swipeForward(app)
    app.saveScreenshot(as: "DatePicker-1@\(size)~\(locale)")

    app.buttons.element(boundBy: 0).tap()
    app.saveScreenshot(as: "DatePicker-2@\(size)~\(locale)")

    app.buttons.matching(identifier: "ContinueButton").element.tap()
    _ = app.buttons.matching(identifier: "DoneButton").element.waitForExistence(timeout: 1)
    app.saveScreenshot(as: "DatePicker-3@\(size)~\(locale)")
  }

  func testDatePicker_date() throws {
    let config = value(forKey: "testRunConfiguration") as! NSDictionary
    guard config["XCUIAppearanceMode"] as? Int != 2 else { return }

    let app = XCUIApplication()
    app.launch()

    let size = watchDeviceSizes[app.frame.width]!
    let locale = config["XCUIApplicationLocalization"] as? String ?? "en"

    swipeForward(app)
    swipeForward(app)
    app.saveScreenshot(as: "DatePicker_date-1@\(size)~\(locale)")

    app.buttons.element(boundBy: 0).tap()
    app.saveScreenshot(as: "DatePicker_date-2@\(size)~\(locale)")
  }

  func testDatePicker_hourAndMinute() throws {
    let config = value(forKey: "testRunConfiguration") as! NSDictionary
    guard config["XCUIAppearanceMode"] as? Int != 2 else { return }

    let app = XCUIApplication()
    app.launch()

    let size = watchDeviceSizes[app.frame.width]!
    let locale = config["XCUIApplicationLocalization"] as? String ?? "en"

    swipeForward(app)
    swipeForward(app)
    swipeForward(app)
    app.saveScreenshot(as: "DatePicker_hourAndMinute-1@\(size)~\(locale)")

    app.buttons.element(boundBy: 0).tap()
    app.saveScreenshot(as: "DatePicker_hourAndMinute-2@\(size)~\(locale)")
  }
}
