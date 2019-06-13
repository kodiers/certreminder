//
//  testNewExamVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 19/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testNewExamVC: XCTestCase {
    var storyboard: UIStoryboard!
    var newExamVC: NewExamVC!
    var vendor: Vendor!
    var certification: Certification!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        newExamVC = storyboard.instantiateViewController(withIdentifier: "NewExamVC") as! NewExamVC
        newExamVC.examService = MockExamSrv()
        vendor = Vendor(id: id1, title: TEST)
        certification = Certification(id: id1, title: TEST, vendor: vendor.id)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExamVCLoad() {
        newExamVC.vendor = vendor
        newExamVC.certification = certification
        _ = newExamVC.view
        XCTAssertEqual(newExamVC.certificationLbl.text, certification.title)
        XCTAssertEqual(newExamVC.vendorLbl.text, vendor.title)
    }
    
    func testActions() {
        newExamVC.vendor = vendor
        newExamVC.certification = certification
        _ = newExamVC.view
        let actions = newExamVC.saveBtn.actions(forTarget: newExamVC, forControlEvent: .touchUpInside)
        XCTAssertTrue((actions?.contains("saveBtnPressed:"))!)
    }
    
}
