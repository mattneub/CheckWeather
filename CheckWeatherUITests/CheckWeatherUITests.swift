

import XCTest

class CheckWeatherUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testEndToEndInterface() {
        let app = XCUIApplication()
        app.launch()
        
        let text = app.staticTexts["Enter five-digit zip code:"]
        if !text.waitForExistence(timeout: 5) {
            let button = app.buttons["square.and.pencil"]
            XCTAssert(button.exists)
            button.tap()
        }
        let ok = text.waitForExistence(timeout: 5)
        XCTAssert(ok)
        let textField = app.textFields.firstMatch
        textField.typeText("93023")
        let okButton = app.buttons["   OK"] // really should be using better identifier here
        okButton.tap()
        
        // we should now be seeing the display for Ojai
        let ojai = app.staticTexts["Ojai"]
        let ok2 = ojai.waitForExistence(timeout: 60)
        XCTAssert(ok2)
        
        let cell = app.cells.element(boundBy: 0)
        cell.tap()
        
        // we should now be seeing the detail view
        let temp = app.staticTexts["Temperature"]
        let ok3 = temp.waitForExistence(timeout: 5)
        XCTAssert(ok3)
        
        let backButton = app.buttons["Five Days"]
        XCTAssert(backButton.exists)
        backButton.tap()
        
        _ = ojai.waitForExistence(timeout: 10)
        XCTAssert(ojai.exists)
    }

}
