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
    var storyboard: UIStoryboard!
    var restorePasswordVC: RestorePasswordVC!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        restorePasswordVC = RestorePasswordVC()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRestorePasswordVC() {
//        _ = restorePasswordVC.view as? RestorePasswordView
//        XCTAssertEqual(restorePasswordVC.view.ema.text, "")
//        XCTAssertEqual(registrationVC.passwordField.text, "")
//        XCTAssertEqual(registrationVC.confirmPasswordField.text, "")
//        XCTAssertEqual(registrationVC.emailField.text, "")
//        XCTAssertNotNil(registrationVC.registerBtn)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
