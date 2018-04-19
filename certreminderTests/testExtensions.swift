//
//  testExtensions.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 20/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testExtensions: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHideSpinner() {
        let vc = UIViewController()
        let spinner = UIActivityIndicatorView()
        spinner.isHidden = false
        vc.hideSpinner(spinner: spinner)
        XCTAssertTrue(spinner.isHidden)
    }
    
    func testShowSpinner() {
        let vc = UIViewController()
        let spinner = UIActivityIndicatorView()
        spinner.isHidden = true
        vc.showSpinner(spinner: spinner)
        XCTAssertFalse(spinner.isHidden)
    }
    
}
