//
//  testRestorePasswordVC.swift
//  certreminderUITests
//
//  Created by Viktor Yamchinov on 18/06/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testRestorePasswordVC: XCTestCase {
    /*
     Test user actions for RestorePasswordVC
    */

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let haveSignout = XCUIApplication().navigationBars["My certifications"].buttons["Sign out"]
        if (haveSignout.exists) {
            XCUIApplication().navigationBars["My certifications"].buttons["Sign out"].tap()
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRestorePasswordVCPresented() {
        let app = XCUIApplication()
        app.buttons["Restore password"].tap()
        let haveDescriptionLbl = app.staticTexts["Instructions for password recovery will be sent to your email"]
        XCTAssertTrue(haveDescriptionLbl.exists)
    }
    
    func testBackBtnPressed() {
        let app = XCUIApplication()
        app.buttons["Restore password"].tap()
        let haveDescriptionLbl = app.staticTexts["Instructions for password recovery will be sent to your email"]
        XCTAssertTrue(haveDescriptionLbl.exists)
        app.buttons["Back"].tap()
        let haveRegisterLbl = app.staticTexts["No account?"]
        XCTAssertTrue(haveRegisterLbl.exists)
    }
    
    func testRestoreBtnPressed() {
        let app = XCUIApplication()
        app.buttons["Restore password"].tap()
        let haveDescriptionLbl = app.staticTexts["Instructions for password recovery will be sent to your email"]
        XCTAssertTrue(haveDescriptionLbl.exists)
        app.buttons["Restore password"].tap()
        let alertLbl = app.staticTexts["Email is empty"]
        XCTAssertTrue(alertLbl.exists)
    }

}
