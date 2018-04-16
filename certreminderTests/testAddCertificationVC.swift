//
//  testAddCertificationVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 17/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testAddCertificationVC: XCTestCase {
    var storyboard: UIStoryboard!
    var addCertVC: AddCertificationVC!
    let formatter = DateFormatter()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        addCertVC = storyboard.instantiateViewController(withIdentifier: "AddCertificationVC") as! AddCertificationVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConfigureVCNoData() {
        _ = addCertVC.view
        XCTAssertEqual(addCertVC.dateLabel.text, "Choose date")
        XCTAssertEqual(addCertVC.vendorLabel.text, "Choose vendor")
        XCTAssertEqual(addCertVC.certificationLabel.text, "Choose certification")
        let countRows = addCertVC.examsTableView.numberOfRows(inSection: 0)
        XCTAssertEqual(countRows, 0)
    }
    
    func testConfigureVCInitialData() {
        let date = Date()
        addCertVC.certificationExpireDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let dateStr = formatter.string(from: date)
        _ = addCertVC.view
        addCertVC.configureVC()
        XCTAssertEqual(addCertVC.dateLabel.text, dateStr)
    }
    
}
