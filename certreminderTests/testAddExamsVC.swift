//
//  testAddExamsVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 17/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testAddExamsVC: XCTestCase {
    var storyboard: UIStoryboard!
    var addExamsVC: AddExamsVC!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        addExamsVC = storyboard.instantiateViewController(withIdentifier: "AddExamsVC") as! AddExamsVC
        addExamsVC.examService = MockExamSrv()
        addExamsVC.certification = Certification(id: id1, title: TEST, vendor: id1)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDownloadExams() {
        _ = addExamsVC.view
        XCTAssertEqual(addExamsVC.certification.title, TEST)
        XCTAssertEqual(addExamsVC.exams.count, 1)
        XCTAssertEqual(addExamsVC.exams[0].id, id1)
        let rowCount = addExamsVC.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(rowCount, 1)
    }
    
}
