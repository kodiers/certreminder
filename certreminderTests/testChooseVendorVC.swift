//
//  testChooseVendorVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 17/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testChooseVendorVC: XCTestCase {
    var storyboard: UIStoryboard!
    var chooseVendorVC: ChooseVendorVC!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        chooseVendorVC = storyboard.instantiateViewController(withIdentifier: "ChooseVendorVC") as! ChooseVendorVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetVendors() {
        _ = chooseVendorVC.view
        let vendors = [Vendor(id: 1, title: "test")]
        chooseVendorVC.setVendors(vendors: vendors)
        XCTAssertEqual(chooseVendorVC.vendors.count, 1)
        XCTAssertEqual(chooseVendorVC.vendors[0].id, 1)
    }
    
    
}
