//
//  testAddExistingExamVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 19/07/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testAddExistingExamVC: XCTestCase {
    var storyboard: UIStoryboard!
    var addExistingExamVC: AddExistingExamVC!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        addExistingExamVC = storyboard.instantiateViewController(withIdentifier: "AddExistingExamVC") as! AddExistingExamVC
        addExistingExamVC.examService = MockExamSrv()
        addExistingExamVC.vendorService = MockVendorService()
        addExistingExamVC.certification = Certification(id: id1, title: TEST, vendor: id1)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDownloadExams() {
        _ = addExistingExamVC.view
        XCTAssertEqual(addExistingExamVC.certification.title, TEST)
        XCTAssertEqual(addExistingExamVC.exams.count, 1)
        XCTAssertEqual(addExistingExamVC.exams[0].id, id1)
        let rowCount = addExistingExamVC.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(rowCount, 1)
    }
    
    func testAddBtnPressed() {
        _ = addExistingExamVC.view
        let actions = addExistingExamVC.addExamBtn.actions(forTarget: addExistingExamVC, forControlEvent: .touchUpInside)
        XCTAssertTrue((actions?.contains("addExistingBtnPressed:"))!)
    }
    
}
