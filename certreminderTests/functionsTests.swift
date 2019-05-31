//
//  functionsTests.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 18/05/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class functionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_isStringContainsOnlyNumbers() {
        let str1 = "123456"
        XCTAssertTrue(isStringContainsOnlyNumbers(string: str1))
        let str2 = "1234sdgfkhsj#"
        XCTAssertFalse(isStringContainsOnlyNumbers(string: str2))
    }
    
    func test_validatePassword() {
        XCTAssertFalse(validatePassword(username: TEST, password: "abc"))
        XCTAssertFalse(validatePassword(username: TEST, password: "test"))
        XCTAssertFalse(validatePassword(username: "test", password: "12345678790"))
        XCTAssertTrue(validatePassword(username: "test", password: "abc123456"))
    }
    
    func test_validateEmail() {
        XCTAssertFalse(validateEmail(str: TEST))
        XCTAssertFalse(validateEmail(str: "test@test"))
        XCTAssertFalse(validateEmail(str: "test.test"))
        XCTAssertTrue(validateEmail(str: "test@email.com"))
    }
}
