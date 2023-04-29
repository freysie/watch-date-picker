import XCTest
import WatchKit

let watchDeviceSizes = [
  162.0: "40mm",
  176.0: "41mm",
  184.0: "44mm",
  198.0: "45mm",
  205.0: "49mm",
]

let outputDirectory = URL(fileURLWithPath: "../../watch-date-picker-qa", relativeTo: URL(fileURLWithPath: #filePath))

extension XCUIScreenshotProviding {
  func saveScreenshot(as name: String) {
    Thread.sleep(forTimeInterval: 0.2) // wait for crown indicator to disappear

    let outputPath = outputDirectory
      .appendingPathComponent(WKInterfaceDevice.current().systemVersion)
      .appendingPathComponent("\(name).png")

    try! screenshot().pngRepresentation.write(to: outputPath)
  }
}

class DatePickerScreenshots: XCTestCase {
  override class var runsForEachTargetApplicationUIConfiguration: Bool { true }
  //override func setUpWithError() throws { continueAfterFailure = false }
  override func setUpWithError() throws { continueAfterFailure = true }

  private func swipeForward(_ app: XCUIApplication) {
    let config = value(forKey: "testRunConfiguration") as! NSDictionary
    let locale = config["XCUIApplicationLocalization"] as? String ?? "en"
    if NSLocale.characterDirection(forLanguage: locale) == .rightToLeft {
      app.swipeRight()
    } else {
      app.swipeLeft()
    }
  }

//  private func saveScreenshot(of element: XCUIScreenshotProviding, as name: String) {
//    let config = value(forKey: "testRunConfiguration") as! NSDictionary
//    let locale = config["XCUIApplicationLocalization"] as? String ?? "en"
//    let version = WKInterfaceDevice.current().systemVersion
//    let filename = "\(name)@\(size)~\(locale)~\(version).png"
//
//    Thread.sleep(forTimeInterval: 0.2) // wait for crown indicator to disappear
//    try! screenshot().pngRepresentation.write(to: outputDirectory.appendingPathComponent(filename))
//  }

  let delay = 0.25

  func test() throws {
    let config = value(forKey: "testRunConfiguration") as! NSDictionary
    guard config["XCUIAppearanceMode"] as? Int != 2 else { return }

    let app = XCUIApplication()
    app.launchEnvironment = ["WDP_SCREENSHOTS": "1"]
    app.launch()

    let size = watchDeviceSizes[app.frame.width]!
    let locale = config["XCUIApplicationLocalization"] as? String ?? "en"

    app.buttons["System Time Input View"].tap()
    app.saveScreenshot(as: "TimeInputView@\(size)~\(locale)~system")

    app.buttons.matching(identifier: "CancelButton").element.tap()
    app.buttons.element(boundBy: 1).tap()

    app.saveScreenshot(as: "TimeInputView@\(size)~\(locale)")
    app.buttons.matching(identifier: "DoneButton").element.tap()

    for mode in ["", "_optional"] {
      swipeForward(app)
      app.saveScreenshot(as: "DatePicker\(mode)-1@\(size)~\(locale)")

      app.buttons.element(boundBy: 0).tap()
      Thread.sleep(forTimeInterval: delay) // wait for picker focus
      app.saveScreenshot(as: "DatePicker\(mode)-2@\(size)~\(locale)")

      app.buttons.matching(identifier: "DoneButton").element.tap()
      _ = app.buttons.matching(identifier: "TimeInputView").element.waitForExistence(timeout: 1)
      app.saveScreenshot(as: "DatePicker\(mode)-3@\(size)~\(locale)")
      app.buttons.element(boundBy: 1).tap()

      swipeForward(app)
      app.saveScreenshot(as: "DatePicker_date\(mode)-1@\(size)~\(locale)")

      app.buttons.element(boundBy: 0).tap()
      Thread.sleep(forTimeInterval: delay) // wait for picker focus
      app.saveScreenshot(as: "DatePicker_date\(mode)-2@\(size)~\(locale)")

      if mode != "_optional" {
        app.otherElements["DayPicker"].tap()
        Thread.sleep(forTimeInterval: delay) // wait for picker focus
        app.saveScreenshot(as: "DatePicker_date\(mode)-2-D@\(size)~\(locale)")

        app.otherElements["MonthPicker"].tap()
        Thread.sleep(forTimeInterval: delay) // wait for picker focus
        app.saveScreenshot(as: "DatePicker_date\(mode)-2-M@\(size)~\(locale)")

        app.otherElements["YearPicker"].tap()
        Thread.sleep(forTimeInterval: delay) // wait for picker focus
        app.saveScreenshot(as: "DatePicker_date\(mode)-2-Y@\(size)~\(locale)")
      }

      app.buttons.matching(identifier: "DoneButton").element.tap()
      swipeForward(app)
      app.saveScreenshot(as: "DatePicker_hourAndMinute\(mode)-1@\(size)~\(locale)")

      app.buttons.element(boundBy: 0).tap()
      app.saveScreenshot(as: "DatePicker_hourAndMinute\(mode)-2@\(size)~\(locale)")
      app.buttons.matching(identifier: "DoneButton").element.tap()
    }

    // guard locale == "en" else { return }

    swipeForward(app)
    Thread.sleep(forTimeInterval: delay)
    app.buttons["DateInputView"].saveScreenshot(as: "StandaloneDateInputView@\(size)~\(locale)")

    swipeForward(app)
    Thread.sleep(forTimeInterval: delay)
    app.buttons["TimeInputView"].saveScreenshot(as: "StandaloneTimeInputView@\(size)~\(locale)")

    swipeForward(app)
    Thread.sleep(forTimeInterval: delay)
    app.buttons["TimeInputView"].saveScreenshot(as: "StandaloneTimeInputView_24hr@\(size)~\(locale)")

    swipeForward(app)
    Thread.sleep(forTimeInterval: delay)
    app.buttons["TimeInputView"].saveScreenshot(as: "StandaloneTimeInputView_24hrHidden@\(size)~\(locale)")
  }
}
