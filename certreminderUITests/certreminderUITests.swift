//
//  certreminderUITests.swift
//  certreminderUITests
//
//  Created by Viktor Yamchinov on 10/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder


class certreminderUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
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
        super.tearDown()
    }
    
    func testLoginVCPresented() {
        let haveRegisterLbl = XCUIApplication().staticTexts["No account?"]
        XCTAssertTrue(haveRegisterLbl.exists)
    }
    
    func testRegistrationVCPresented() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIApplication().buttons["Register"].tap()
        let haveLoginLbl = XCUIApplication().staticTexts["Have account?"]
        XCTAssertTrue(haveLoginLbl.exists)
    }
    
    
    func testRegisterTermsOfUseVCPresented() {
        let app = XCUIApplication()
        app.buttons["Register"].tap()
        app.buttons["Terms of Use"].tap()
        let haveTermsLbl = XCUIApplication().staticTexts["Terms and Conditions"]
        XCTAssertTrue(haveTermsLbl.exists)
    }
    
    func testLoginTermsOfUseVCPresented() {
        let app = XCUIApplication()
        app.buttons["Terms of Use"].tap()
        let haveTermsLbl = XCUIApplication().staticTexts["Terms and Conditions"]
        XCTAssertTrue(haveTermsLbl.exists)
    }
    
}
