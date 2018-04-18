//
//  testNewCertificationVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 18/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testNewCertificationVC: XCTestCase {
    var storyboard: UIStoryboard!
    var newCertVC: NewCertificationVC!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        newCertVC = storyboard.instantiateViewController(withIdentifier: "NewCertificationVC") as! NewCertificationVC
        newCertVC.certService = MockCertService()
        newCertVC.vendor = Vendor(id: id1, title: TEST)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testActions() {
        _ = newCertVC.view
        let actions = newCertVC.saveBtn.actions(forTarget: newCertVC, forControlEvent: .touchUpInside)
        XCTAssertTrue((actions?.contains("saveBtnPressed:"))!)
    }
    
}
