import XCTest

fileprivate let watchDeviceSizes = [
  162.0: "40mm",
  176.0: "41mm",
  184.0: "44mm",
  198.0: "45mm",
  205.0: "49mm",
]

fileprivate let outputDirectory = URL(
  fileURLWithPath: "../Sources/WatchDatePicker/Documentation.docc/Resources",
  relativeTo: URL(fileURLWithPath: #filePath)
)

fileprivate extension XCUIScreenshotProviding {
  func saveScreenshot(as name: String) {
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
    let app = XCUIApplication()
    let size = watchDeviceSizes[app.frame.width]!
    app.launch()
    
    app.buttons["System Time Input View"].tap()
    sleep(1)
    app.saveScreenshot(as: "__DatePicker_hourAndMinute@\(size)~system")
  }
  
  func testDatePicker_hourAndMinute() throws {
    let app = XCUIApplication()
    let size = watchDeviceSizes[app.frame.width]!
    app.launch()
    
    
    app.buttons["Time (Pink), 10:09 AM"].tap()
    sleep(2)
    app.saveScreenshot(as: "__DatePicker_hourAndMinute@\(size)")
  }
  
  func testMore() throws {
    let app = XCUIApplication()
    //let size = watchDeviceSizes[app.frame.width]!
    app.launch()
    
    app.swipeLeft()
    app.swipeLeft()
    app.swipeLeft()
    app.swipeLeft()
    app.swipeLeft()
    
    app.buttons["AM"].saveScreenshot(as: "__DatePicker_test")
    
//    print(app.otherElements.firstMatch)
//    print(app.children(matching: .window).element(boundBy: 0).children(matching: .other).element)
//    print(app.collectionViews.firstMatch)
    
    app.saveScreenshot(as: "__DatePicker_test2")
    
//    XCUIApplication().collectionViews["PUICPageViewController_collectionView"].cells.collectionViews.containing(.cell, identifier:"Date & Time, 9/27/22, 10:09 AM").element.swipeLeft()
//
//    // let app = XCUIApplication()
//    let puicpageviewcontrollerCollectionviewCollectionView = app.collectionViews["PUICPageViewController_collectionView"]
//    puicpageviewcontrollerCollectionviewCollectionView/*@START_MENU_TOKEN@*/.collectionViews.buttons["Time (Pink), 10:09 AM"]/*[[".cells.collectionViews",".cells[\"Time (Pink), 10:09 AM\"].buttons[\"Time (Pink), 10:09 AM\"]",".buttons[\"Time (Pink), 10:09 AM\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
//    app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
//
//    let cellsQuery = puicpageviewcontrollerCollectionviewCollectionView.cells
//    cellsQuery/*@START_MENU_TOKEN@*/.collectionViews.containing(.cell, identifier:"System Time Input View").element/*[[".collectionViews.containing(.cell, identifier:\"Date, Sep 27, 2022\").element",".collectionViews.containing(.cell, identifier:\"Date & Time, 9\/27\/22, 10:09 AM\").element",".collectionViews.containing(.cell, identifier:\"Time (Pink), 10:09 AM\").element",".collectionViews.containing(.cell, identifier:\"System Time Input View\").element"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
//
//    let element = puicpageviewcontrollerCollectionviewCollectionView/*@START_MENU_TOKEN@*/.collectionViews/*[[".cells.collectionViews",".collectionViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.cells["Time (Pink), 10:09 AM"].children(matching: .other).element(boundBy: 1).children(matching: .other).element
//    element.swipeLeft()
//    element.swipeLeft()
//    cellsQuery.collectionViews.containing(.cell, identifier:"Date & Time, 9/27/22, 10:09 AM").element.swipeLeft()
//    cellsQuery.collectionViews.containing(.cell, identifier:"Date, Sep 27, 2022").element.swipeLeft()
//
//    let element2 = cellsQuery.children(matching: .other).element.children(matching: .other).element
//    element2.swipeLeft()
//    element2.swipeLeft()
//
//    app.otherElements.firstMatch.saveScreenshot(as: "__DatePicker_test3")
//    app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.saveScreenshot(as: "__DatePicker_test4")
//    app.collectionViews.firstMatch.saveScreenshot(as: "__DatePicker_test5")
//
//    sleep(2)
    
//    //let app = XCUIApplication()
//    app.navigationBars["_TtGC7SwiftUI19UIHosting"].children(matching: .other).element(boundBy: 1).tap()
//
//    let puicpageviewcontrollerCollectionviewCollectionView = app.collectionViews["PUICPageViewController_collectionView"]
//    let dateSep272022Button = puicpageviewcontrollerCollectionviewCollectionView/*@START_MENU_TOKEN@*/.collectionViews.buttons["Date, Sep 27, 2022"]/*[[".cells.collectionViews",".cells[\"Date, Sep 27, 2022\"].buttons[\"Date, Sep 27, 2022\"]",".buttons[\"Date, Sep 27, 2022\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
//    dateSep272022Button.tap()
//    dateSep272022Button.tap()
//    app.buttons["Close"].tap()
//
//    let element = puicpageviewcontrollerCollectionviewCollectionView/*@START_MENU_TOKEN@*/.collectionViews/*[[".cells.collectionViews",".collectionViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.cells["Time (Pink), 10:09 AM"].children(matching: .other).element(boundBy: 1).children(matching: .other).element
//    element.tap()
//    app.buttons["09"].tap()
//
//    let button = app.buttons["10"]
//    button.tap()
//
//    let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
//    element2.tap()
//    button.tap()
//
//    let amButton = app.buttons["AM"]
//    amButton.tap()
//    element2.tap()
//    amButton.tap()
//    app.buttons["PM"].tap()
//    amButton.tap()
//    element2.tap()
//    element2.tap()
//    element2.tap()
//    element2.tap()
//    element2.tap()
//    element2.tap()
//    element2.tap()
//    element2.tap()
//    element2.tap()
//    app.buttons["Selected"].tap()
//    element.swipeLeft()
//
//    let cellsQuery = puicpageviewcontrollerCollectionviewCollectionView.cells
//    cellsQuery.collectionViews.containing(.cell, identifier:"Date & Time, 9/27/22, 10:09 AM").element.swipeLeft()
//    puicpageviewcontrollerCollectionviewCollectionView/*@START_MENU_TOKEN@*/.collectionViews.buttons["Time (Pink), 10:09 AM"]/*[[".cells.collectionViews",".cells[\"Time (Pink), 10:09 AM\"].buttons[\"Time (Pink), 10:09 AM\"]",".buttons[\"Time (Pink), 10:09 AM\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.swipeLeft()
//    cellsQuery/*@START_MENU_TOKEN@*/.collectionViews.containing(.cell, identifier:"Time, 10:09 AM").element/*[[".collectionViews.containing(.cell, identifier:\"Time (Pink), 10:09 AM\").element",".collectionViews.containing(.cell, identifier:\"Time, 10:09 AM\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
            
//    let pageView = app.otherElements.matching(identifier: "PageView").firstMatch
//
//    pageView.swipeLeft(velocity: .fast)
//    app.saveScreenshot(as: "__DatePicker_more")
//
//    pageView.swipeLeft(velocity: .fast)
//    app.saveScreenshot(as: "__DatePicker_more2")
//
//    pageView.swipeLeft(velocity: .fast)
//    app.saveScreenshot(as: "__DatePicker_more3")
  }
    
//    app.buttons["Time (Pink), 10:09 AM"].tap()
//    sleep(1)
//    app.saveScreenshot(as: "__DatePicker~hourAndMinute")
//    sleep(1)
//    app.buttons["Selected"].tap()
    
    // sleep(1)
    // _ = app.buttons["System Time Input View"].waitForExistence(timeout: 5)
    // app.buttons["System Time Input View"].tap()
    // app.saveScreenshot(as: "__DatePicker~system")
    
    //let collectionView = app.collectionViews["PUICPageViewController_collectionView"].collectionViews
    //collectionView.buttons["System Time Input View"].tap()
    
//    let app = XCUIApplication()
//    app.collectionViews["PUICPageViewController_collectionView"]/*@START_MENU_TOKEN@*/.collectionViews.buttons["Time (Pink), 10:09 AM"]/*[[".cells.collectionViews",".cells[\"Time (Pink), 10:09 AM\"].buttons[\"Time (Pink), 10:09 AM\"]",".buttons[\"Time (Pink), 10:09 AM\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
//    app.buttons["09"].tap()
//    app.buttons["10"].tap()
//    app.buttons["Selected"].tap()

//    app.staticTexts[":"].tap()
//    app.buttons["Selected"].tap()
//
//    let puicpageviewcontrollerCollectionviewCollectionView2 = app.collectionViews["PUICPageViewController_collectionView"]
//    let puicpageviewcontrollerCollectionviewCollectionView = puicpageviewcontrollerCollectionviewCollectionView2
//    puicpageviewcontrollerCollectionviewCollectionView/*@START_MENU_TOKEN@*/.collectionViews.buttons["Time (Pink), 10:09 AM"].press(forDuration: 0.7);/*[[".cells.collectionViews",".cells[\"Time (Pink), 10:09 AM\"].buttons[\"Time (Pink), 10:09 AM\"]",".tap()",".press(forDuration: 0.7);",".buttons[\"Time (Pink), 10:09 AM\"]",".collectionViews"],[[[-1,5,1],[-1,0,1]],[[-1,4,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0,0]]@END_MENU_TOKEN@*/
//    app.buttons["AM"].tap()
//    app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
//
//    let collectionViewsQuery = puicpageviewcontrollerCollectionviewCollectionView/*@START_MENU_TOKEN@*/.collectionViews/*[[".cells.collectionViews",".collectionViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//    let element = collectionViewsQuery.cells["Time (Pink), 10:09 AM"].children(matching: .other).element(boundBy: 1).children(matching: .other).element
//    element.swipeLeft()
//    collectionViewsQuery.cells["Date & Time, 9/18/22, 10:09 AM"].children(matching: .other).element(boundBy: 1).children(matching: .other).element.swipeLeft()
//
//    let cellsQuery = puicpageviewcontrollerCollectionviewCollectionView2.cells
//    cellsQuery.collectionViews.containing(.cell, identifier:"Date, Sep 18, 2022").element.swipeLeft()
//
//    let element2 = cellsQuery.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
//    element2.swipeRight()
//    element2.children(matching: .staticText)["Sep"].swipeRight()
//
//    let element3 = element.children(matching: .other).element
//    element3.swipeRight()
//    cellsQuery.collectionViews.containing(.cell, identifier:"Date & Time, 9/18/22, 10:09 AM").element.swipeRight()
//    element3.swipeRight()
//    collectionViewsQuery.cells["System Time Input View"].children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
    
    
    // app.saveScreenshot(as: "__DatePicker~hourAndMinute")
    
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
//  }
}
