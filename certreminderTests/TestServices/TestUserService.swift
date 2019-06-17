//
//  TestUserService.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 14/06/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class TestUserService: XCTestCase {
    
    var MockUserRequestService: WebRequestProtocol!
    let email = "test@test.com"
    let password = "p@ssw0rd"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        MockUserRequestService = MockWebServiceUser()
        UserService.webservice = MockUserRequestService
        UserService.instance.token = TOKEN
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegisterUser() {
        var success: Bool = false
        var error: NSError?
        UserService.instance.registerUser(username: USER, email: email, password: password, confirm_password: password) { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertEqual(UserService.instance.user?.username, USER)
    }
    
    func testLoginUser() {
        var success = false
        var error: NSError?
        UserService.instance.token = nil
        UserService.instance.loginUser(username: USER, password: password) { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertEqual(UserService.instance.token, TOKEN)
    }
    
    func testRefreshToken() {
        var success = false
        var error: NSError?
        UserService.instance.refreshToken { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertEqual(UserService.instance.token, TOKEN)
    }
    
    func testVerifyToken() {
        var success = false
        var error: NSError?
        UserService.instance.verifyToken { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertEqual(UserService.instance.token, TOKEN)
    }
        
    func testLogoutUser() {
        UserService.instance.logoutUser()
        XCTAssertNil(UserService.instance.user)
        XCTAssertNil(UserService.instance.token)
    }
    
    func testRestorePassword() {
        var success = false
        var error: NSError?
        UserService.instance.restorePassword(for: email) { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
    }

}
