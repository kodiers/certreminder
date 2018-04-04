//
//  viewsTests.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 05/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest

@testable import certreminder

class viewsTests: XCTestCase {
    var userCert: UserCertification!
    var certification: Certification!
    var vendor: Vendor!
    var date: Date!
    var TEST = "test"
    var id1 = 1
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        date = Date()
        certification = Certification(id: id1, title: TEST, vendor: id1)
        vendor = Vendor(id: id1, title: TEST)
        userCert = UserCertification(id: id1, certification: certification, expirationDate: date)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCertificationCell() {
        // TODO: resoleve unit test for cell
//        let controller = CertificationVC()
//        let cell = controller.tableView(controller.certTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CertificationCell
//        cell?.configureCell(userCert: userCert, vendors: [vendor])
//        XCTAssertEqual(cell?.userCert.id, userCert.id)
//        XCTAssertEqual(cell?.vendorLabel.text, TEST)
//        XCTAssertEqual(cell?.certificationLabel.text, TEST)
//        XCTAssertEqual(cell?.dateLabel.text, userCert.expirationDateAsString())
//        XCTAssertNotNil(cell?.accessoryView)
        
    }
}
