//
//  viewsTests.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 05/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest

@testable import certreminder

var TEST = "test"
var id1 = 1

class MockUserCertificationService: UserCertificationServiceProtocol {
    /*
     Mock UserCertificationService
    */
    func getUserCertification(completionHandler: @escaping RequestComplete) {
        let certification = Certification(id: id1, title: TEST, vendor: id1)
        completionHandler([UserCertification(id: id1, certification: certification, expirationDate: Date())] as AnyObject, nil)
    }
    
    func deleteUserCertification(userCertId: Int, completionHandler: @escaping RequestComplete) {
        completionHandler(true as AnyObject, nil)
    }
}

class MockCertService: CertificationServiceProtocol {
    /*
     Mock CertificationService
    */
    func downloadCertifications(vendor: Vendor?, completionHandler: @escaping ([Certification]?, NSError?) -> ()) {
        completionHandler([Certification(id: id1, title: TEST, vendor: id1)], nil)
    }
}

class MockExamSrv: ExamServiceProtocol {
    /*
     Mock ExamService
    */
    func getExams(certification: Certification?, completionHandler: @escaping ([Exam]?, NSError?) -> ()) {
        let certification = Certification(id: id1, title: TEST, vendor: id1)
        completionHandler([Exam(id: id1, title: TEST, certification: certification)], nil)
    }
}

class viewsTests: XCTestCase {
    var userCert: UserCertification!
    var certification: Certification!
    var vendor: Vendor!
    var date: Date!
    var exam: Exam!
    var mockUserCertSrv: UserCertificationServiceProtocol!
    var mockCertSrv: CertificationServiceProtocol!
    var mockExamSrv: ExamServiceProtocol!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        date = Date()
        certification = Certification(id: id1, title: TEST, vendor: id1)
        vendor = Vendor(id: id1, title: TEST)
        userCert = UserCertification(id: id1, certification: certification, expirationDate: date)
        exam = Exam(id: id1, title: TEST, certification: certification)
        mockUserCertSrv = MockUserCertificationService()
        mockCertSrv = MockCertService()
        mockExamSrv = MockExamSrv()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCertificationCell() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CertVC = storyboard.instantiateViewController(withIdentifier: "CertificationVC") as! CertificationVC
        CertVC.userCertificationService = mockUserCertSrv
        _ = CertVC.view
        let cell = CertVC.tableView(CertVC.certTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CertificationCell
        XCTAssertNotNil(cell)
        cell?.configureCell(userCert: userCert, vendors: [vendor])
        XCTAssertEqual(cell?.userCert.id, userCert.id)
        XCTAssertEqual(cell?.vendorLabel.text, TEST)
        XCTAssertEqual(cell?.certificationLabel.text, TEST)
        XCTAssertEqual(cell?.dateLabel.text, userCert.expirationDateAsString())
        XCTAssertNotNil(cell?.accessoryView)
    }
    
    func testChooseCertificationTableCellCell() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ChooseCertVC = storyboard.instantiateViewController(withIdentifier: "ChooseCertificationVC") as! ChooseCertificationVC
        ChooseCertVC.certificationService = mockCertSrv
        _ = ChooseCertVC.view
        let cell = ChooseCertVC.tableView(ChooseCertVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ChooseCertificationTableCellCell
        XCTAssertNotNil(cell)
        cell?.configureCell(cert: certification)
        XCTAssertEqual(cell?.certLabel.text, TEST)
        XCTAssertTrue((cell?.checkmarkImageView.isHidden)!)
        XCTAssertFalse((cell?.choosed)!)
        XCTAssertEqual(cell?.certification.id, id1)
        cell?.chooseCell(isChoosed: true)
        XCTAssertFalse((cell?.checkmarkImageView.isHidden)!)
        XCTAssertTrue((cell?.choosed)!)
    }
    
    func testChooseExamTableCell() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ExamsVC = storyboard.instantiateViewController(withIdentifier: "AddExamsVC") as! AddExamsVC
        ExamsVC.examService = mockExamSrv
        _ = ExamsVC.view
        let cell = ExamsVC.tableView(ExamsVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ChooseExamTableCell
        XCTAssertNotNil(cell)
        cell?.configureCell(exam: exam)
        XCTAssertEqual(cell?.examLabel.text, " \(TEST)")
        XCTAssertEqual(cell?.exam.id, exam.id)
    }
}
