//
//  testCertificationDetailVC.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 12/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class testCertificationDetailVC: XCTestCase {
    var storyboard: UIStoryboard!
    var certDetailVC: CertificationDetailVC!
    var mockVendorService: MockVendorService!
    var mockUserExamService: MockUserExamService!
    var mockUserCertificationService: MockUserCertificationService!
    var certification: Certification!
    var date: Date!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        certDetailVC = storyboard.instantiateViewController(withIdentifier: "CertificationDetailVC") as! CertificationDetailVC
        mockVendorService = MockVendorService()
        mockUserExamService = MockUserExamService()
        mockUserCertificationService = MockUserCertificationService()
        mockVendorService._vendors = [Vendor(id: 1, title: "test")]
        certDetailVC.vendorService = mockVendorService
        certDetailVC.userExamService = mockUserExamService
        certDetailVC.userCertificationService = mockUserCertificationService
        certification = Certification(id: 1, title: "test", vendor: 1)
        date = Date()
        certDetailVC.userCerification = UserCertification(id: 1, certification: certification, expirationDate: date)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConfigureVC() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let dateStr = formatter.string(from: date)
        _ = certDetailVC.view
        certDetailVC.configureVC()
        XCTAssertEqual(certDetailVC.vendorLabel.text, "test")
        XCTAssertEqual(certDetailVC.dateLabel.text, dateStr)
        XCTAssertEqual(certDetailVC.usersExams.count, 1)
    }
    
    func testDeleteUserExam() {
        _ = certDetailVC.view
        XCTAssertEqual(certDetailVC.usersExams.count, 1)
        certDetailVC.deleteUserExam(userExam: certDetailVC.usersExams[0], index: 0)
        XCTAssertEqual(certDetailVC.usersExams.count, 0)
    }
    
    func testDeleteUserExamFromArray() {
        _ = certDetailVC.view
        XCTAssertEqual(certDetailVC.usersExams.count, 1)
        certDetailVC.deleteUserExamFromArray(index: 0)
        XCTAssertEqual(certDetailVC.usersExams.count, 0)
    }
    
    func testGetNewUsersExams() {
        let exam = Exam(id: NEW_OBJECT_ID, title: "test", certification: certification)
        let newUserExam = UserExam(id: NEW_OBJECT_ID, userCertId: 1, exam: exam, dateOfPass: date)
        _ = certDetailVC.view
        certDetailVC.usersExams.append(newUserExam)
        let newExams = certDetailVC.getNewUsersExams()
        XCTAssertEqual(newExams.count, 1)
        XCTAssertEqual(newExams[0].0.id, NEW_OBJECT_ID)
    }
    
    func testGetExamsForUpdate() {
        _ = certDetailVC.view
        let exams = certDetailVC.getExamsForUpdate()
        XCTAssertEqual(exams.count, 1)
        XCTAssertEqual(exams[0].id, 1)
    }
    
    func testActions() {
        _ = certDetailVC.view
        let actions = certDetailVC.addExamBtn.actions(forTarget: certDetailVC, forControlEvent: .touchUpInside)
        XCTAssertTrue((actions?.contains("addExamButtonPressed:"))!)
    }
}
