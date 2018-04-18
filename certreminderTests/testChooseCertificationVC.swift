//
//  testChooseCertificationVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 17/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testChooseCertificationVC: XCTestCase {
    var storyboard: UIStoryboard!
    var chooseCertVC: ChooseCertificationVC!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        chooseCertVC = storyboard.instantiateViewController(withIdentifier: "ChooseCertificationVC") as! ChooseCertificationVC
        chooseCertVC.certificationService = MockCertService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetCertifications() {
        let certifications = [Certification(id: 1, title: "test", vendor: 1)]
        _ = chooseCertVC.view
        chooseCertVC.setCertifications(certifications: certifications)
        XCTAssertEqual(chooseCertVC.certifications.count, 1)
        XCTAssertEqual(chooseCertVC.certifications[0].title, certifications[0].title)
    }
    
    func testGetCertifications() {
        _ = chooseCertVC.view
        chooseCertVC.getCertifications()
        XCTAssertEqual(chooseCertVC.certifications.count, 1)
        XCTAssertEqual(chooseCertVC.certifications[0].title, TEST)
        let rowCount = chooseCertVC.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(rowCount, 1)
    }
    
}
