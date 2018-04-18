//
//  testLoginVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 10/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder


class testLoginVC: XCTestCase {
    var storyboard: UIStoryboard!
    var loginVC: LoginVC!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        UserService.instance.logoutUser()
        loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginVC() {
        _ = loginVC.view
        XCTAssertEqual(loginVC.loginField.text, "")
        XCTAssertEqual(loginVC.passwordField.text, "")
        XCTAssertNotNil(loginVC.loginBtn)
    }
    
    func testLoginBtnTapped() {
        _ = loginVC.view
        loginVC.userService = MockUserService()
        let actions = loginVC.loginBtn.actions(forTarget: loginVC, forControlEvent: .touchUpInside)
        XCTAssertTrue((actions?.contains("loginBtnTapped:"))!)
    }
}
