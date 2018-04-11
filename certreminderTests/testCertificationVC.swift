//
//  testCertificationVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 12/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testCertificationVC: XCTestCase {
    var storyboard: UIStoryboard!
    var certVC: CertificationVC!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        certVC = storyboard.instantiateViewController(withIdentifier: "CertificationVC") as! CertificationVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCertificationVC() {
        _ = certVC.view
        XCTAssertNotNil(certVC.certTableView)
        XCTAssertNotNil(certVC.newCertBtn)
    }
    
    func testSetVendorsToVar() {
        _ = certVC.view
        let vendor = Vendor(id: 1, title: "test")
        certVC.setVendors(vendors: [vendor])
        XCTAssertEqual(certVC.vendors.count, 1)
    }
    
    func testTableView() {
        certVC.userCertificationService = MockUserCertificationService()
        _ = certVC.view
        let countRows = certVC.certTableView.numberOfRows(inSection: 0)
        XCTAssertEqual(countRows, 1)
    }
    
}
