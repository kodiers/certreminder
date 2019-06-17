//
//  testRestorePasswordVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 14/06/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testRestorePasswordVC: XCTestCase {
    /*
     Test RestorePasswordVC
    */
    
    var storyboard: UIStoryboard!
    var restorePasswordVC: RestorePasswordVC!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        restorePasswordVC = RestorePasswordVC()
        restorePasswordVC.userService = MockUserService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRestorePasswordVC() {
        restorePasswordVC.loadView()
        let view = restorePasswordVC.view as? RestorePasswordView
        XCTAssertEqual(view?.emailField.text, "")
        XCTAssertNotNil(view?.restoreButton)
        XCTAssertNotNil(view?.backButton)
    }
    
    func testRestoreBtnPressed() {
        UIApplication.shared.keyWindow?.rootViewController = restorePasswordVC
        let view = restorePasswordVC.view as? RestorePasswordView
        view?.emailField.text = "test@test.com"
        restorePasswordVC.restorePasswordBtnPressed()
        let alert = restorePasswordVC.presentedViewController as? UIAlertController
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Email was successfully sent.")
    }
    
    func testRestoreBtnPressedEmptyEmail() {
        UIApplication.shared.keyWindow?.rootViewController = restorePasswordVC
        restorePasswordVC.restorePasswordBtnPressed()
        let alert = restorePasswordVC.presentedViewController as? UIAlertController
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Email is empty")
    }
    
    func testRestoreBtnPressedInvalidEmail() {
        UIApplication.shared.keyWindow?.rootViewController = restorePasswordVC
        let view = restorePasswordVC.view as? RestorePasswordView
        view?.emailField.text = "testtest.com"
        restorePasswordVC.restorePasswordBtnPressed()
        let alert = restorePasswordVC.presentedViewController as? UIAlertController
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Email is invalid")
    }
    
    func testRestoreBtnPressedBadResponse() {
        restorePasswordVC.userService = MockUserServiceErrors()
        UIApplication.shared.keyWindow?.rootViewController = restorePasswordVC
        let view = restorePasswordVC.view as? RestorePasswordView
        view?.emailField.text = "test@test.com"
        restorePasswordVC.restorePasswordBtnPressed()
        let alert = restorePasswordVC.presentedViewController as? UIAlertController
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Email is invalid.")
    }
    
    func testTextFieldShouldReturn() {
        restorePasswordVC.userService = MockUserServiceErrors()
        UIApplication.shared.keyWindow?.rootViewController = restorePasswordVC
        let view = restorePasswordVC.view as? RestorePasswordView
        XCTAssertTrue(restorePasswordVC.textFieldShouldReturn(view!.emailField))
    }

}
