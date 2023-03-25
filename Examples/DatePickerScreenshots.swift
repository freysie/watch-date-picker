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

  func test() throws {
    let config = value(forKey: "testRunConfiguration") as! NSDictionary
    guard config["XCUIAppearanceMode"] as? Int != 2 else { return }

    let app = XCUIApplication()
    app.launch()

    let size = watchDeviceSizes[app.frame.width]!
    let locale = config["XCUIApplicationLocalization"] as? String ?? "en"

    app.buttons["System Time Input View"].tap()
    app.saveScreenshot(as: "TimeInputView@\(size)~\(locale)~system")

    app.buttons.matching(identifier: "CancelButton").element.tap()
    app.buttons.element(boundBy: 1).tap()

    app.saveScreenshot(as: "TimeInputView@\(size)~\(locale)")
    app.buttons.matching(identifier: "DoneButton").element.tap()

    swipeForward(app)
    app.saveScreenshot(as: "DatePicker-1@\(size)~\(locale)")

    app.buttons.element(boundBy: 0).tap()
    Thread.sleep(forTimeInterval: 0.5) // wait for picker focus
    app.saveScreenshot(as: "DatePicker-2@\(size)~\(locale)")

    app.buttons.matching(identifier: "ContinueButton").element.tap()
    _ = app.buttons.matching(identifier: "DoneButton").element.waitForExistence(timeout: 1)
    app.saveScreenshot(as: "DatePicker-3@\(size)~\(locale)")
    // app.buttons.matching(identifier: "BackButton").element.tap()
    // app.buttons.element(boundBy: 0).tap()
    app.buttons.element(boundBy: 1).tap()

    swipeForward(app)
    app.saveScreenshot(as: "DatePicker_date-1@\(size)~\(locale)")

    app.buttons.element(boundBy: 0).tap()
    Thread.sleep(forTimeInterval: 0.5) // wait for picker focus
    app.saveScreenshot(as: "DatePicker_date-2@\(size)~\(locale)")

    // for e in app.otherElements.allElementsBoundByIndex {
    //   print((e.identifier, e.hasFocus, e.isSelected))
    // }

    app.otherElements["DayPicker"].tap()
    Thread.sleep(forTimeInterval: 0.5) // wait for picker focus
    app.saveScreenshot(as: "DatePicker_date-2-D@\(size)~\(locale)")

    app.otherElements["MonthPicker"].tap()
    Thread.sleep(forTimeInterval: 0.5) // wait for picker focus
    app.saveScreenshot(as: "DatePicker_date-2-M@\(size)~\(locale)")

    app.otherElements["YearPicker"].tap()
    Thread.sleep(forTimeInterval: 0.5) // wait for picker focus
    app.saveScreenshot(as: "DatePicker_date-2-Y@\(size)~\(locale)")
    app.buttons.matching(identifier: "DoneButton").element.tap()

    swipeForward(app)
    app.saveScreenshot(as: "DatePicker_hourAndMinute-1@\(size)~\(locale)")

    app.buttons.element(boundBy: 0).tap()
    app.saveScreenshot(as: "DatePicker_hourAndMinute-2@\(size)~\(locale)")
    app.buttons.matching(identifier: "DoneButton").element.tap()

    swipeForward(app)
    Thread.sleep(forTimeInterval: 0.5)
    app.buttons["DateInputView"].saveScreenshot(as: "StandaloneDateInputView@\(size)~\(locale)")

    swipeForward(app)
    Thread.sleep(forTimeInterval: 0.5)
    app.buttons["TimeInputView"].saveScreenshot(as: "StandaloneTimeInputView@\(size)~\(locale)")

    swipeForward(app)
    Thread.sleep(forTimeInterval: 0.5)
    app.buttons["TimeInputView"].saveScreenshot(as: "StandaloneTimeInputView_24hr@\(size)~\(locale)")

    swipeForward(app)
    Thread.sleep(forTimeInterval: 0.5)
    app.buttons["TimeInputView"].saveScreenshot(as: "StandaloneTimeInputView_24hrHidden@\(size)~\(locale)")
  }
}
