//
//  testRegistrationVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 12/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testRegistrationVC: XCTestCase {
    var storyboard: UIStoryboard!
    var registrationVC: RegistrationVC!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        registrationVC = storyboard.instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRegistrationVC() {
        _ = registrationVC.view
        XCTAssertEqual(registrationVC.loginField.text, "")
        XCTAssertEqual(registrationVC.passwordField.text, "")
        XCTAssertEqual(registrationVC.confirmPasswordField.text, "")
        XCTAssertEqual(registrationVC.emailField.text, "")
        XCTAssertNotNil(registrationVC.registerBtn)
    }
    
    func testRegisterButtonTapped() {
        _ = registrationVC.view
        registrationVC.userService = MockUserService()
        let actions = registrationVC.registerBtn.actions(forTarget: registrationVC, forControlEvent: .touchUpInside)
        XCTAssertTrue((actions?.contains("registerBtnTapped:"))!)
    }
    
    
}
