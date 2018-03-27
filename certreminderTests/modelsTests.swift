//
//  modelsTests.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 23/03/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class MockCertificationService: CertificationProtocol {
    /*
     Mock Certification Service
    */
    var certification: Certification
    
    func getCertificationById(id: Int) -> Certification? {
        return certification
    }
    
    init(certification: Certification) {
        self.certification = certification
    }
}

class modelsTests: XCTestCase {
    /*
     Test models
    */
    
    var certification: Certification!
    var test: String!
    var id: Int!
    var mockCertService: MockCertificationService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        certification = Certification(id: 1, title: "test", vendor: 1, deprectated: false)
        test = "Test"
        id = 1
        mockCertService = MockCertificationService(certification: certification)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCommonModel() {
        let cm = CommonModel(id: id, title: test)
        cm.description = test
        cm.image = test
        XCTAssertEqual(cm.id, id)
        XCTAssertEqual(cm.title, test)
        XCTAssertEqual(cm.description, test)
        XCTAssertEqual(cm.image, test)
    }
    
    func testUserModel() {
        let username = "user"
        let token = "jsdgfjgdsjhfhjdfjhsdhjfdsf"
        let user = User(id: id, username: username, token: token)
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.username, username)
        XCTAssertEqual(user.token, token)
        let userDict = ["id": 1, "username": username, "first_name": "Test", "last_name": "Test", "email": "test@test.ru"] as [String : AnyObject]
        let user2 = User.createUserFromDict(userDict: userDict as Dictionary<String, AnyObject>)
        XCTAssertNotNil(user2)
        XCTAssertEqual(user2?.id, id)
        XCTAssertEqual(user2?.username, username)
        XCTAssertEqual(user2?.firstName, userDict["first_name"] as? String)
        XCTAssertEqual(user2?.lastName, userDict["last_name"] as? String)
        XCTAssertEqual(user2?.email, userDict["email"] as? String)
    }
    
    func testCertificationModel() {
        let vendor = 1
        let cert = Certification(id: id, title: test, vendor: vendor)
        XCTAssertEqual(cert.id, id)
        XCTAssertEqual(cert.title, test)
        XCTAssertEqual(cert.vendor, vendor)
        let certDict = ["id": 1, "title": test, "vendor": vendor, "deprecated": false, "number": "test-1", "image": "testimg", "description": "test description"] as [String : AnyObject]
        let cert2 = Certification.createCertificationFromDict(certDict: certDict)
        XCTAssertNotNil(cert2)
        XCTAssertEqual(cert2?.id, id)
        XCTAssertEqual(cert2?.title, test)
        XCTAssertEqual(cert2?.vendor, vendor)
        XCTAssertFalse((cert2?.deprecated)!)
        XCTAssertEqual(cert2?.number, certDict["number"] as? String)
        XCTAssertEqual(cert2?.image, certDict["image"] as? String)
        XCTAssertEqual(cert2?.description, certDict["description"] as? String)
    }
    
    func testUserCertificationModel() {
        let date = Date()
        let userCert = UserCertification(id: id, certification: certification, expirationDate: date)
        XCTAssertNotNil(userCert)
        XCTAssertEqual(userCert.expirationDate, date)
        XCTAssertEqual(userCert.id, id)
        XCTAssertEqual(userCert.certification.id, certification.id)
        XCTAssertNil(userCert.remindAtDate)
        userCert.remindAtDate = date
        XCTAssertEqual(userCert.remindAtDate, date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let dateStr = formatter.string(from: date)
        XCTAssertEqual(userCert.expirationDateAsString(), dateStr)
        XCTAssertEqual(userCert.remindAtDateAsString(), dateStr)
        let expDateStr = "2020-12-20"
        let remindDateStr = "2020-11-19"
        let userCertDict = ["id": 1, "expiration_date": expDateStr, "remind_at_date": remindDateStr] as [String : AnyObject]
        let userCert2 = UserCertification.createUserCertificationFromDict(userCertDict: userCertDict, certification: certification)
        XCTAssertNotNil(userCert2)
        XCTAssertEqual(userCert2?.expirationDateAsString(), "20-12-2020")
        XCTAssertEqual(userCert2?.remindAtDateAsString(), "19-11-2020")
        XCTAssertEqual(userCert2?.id, userCertDict["id"] as? Int)
        XCTAssertEqual(userCert2?.certification.id, certification.id)
        let userCerts: [UserCertification] = [userCert, userCert2!]
        XCTAssertNotNil(UserCertification.getCertificationByRemindDate(userCerts: userCerts, date: date))
        XCTAssertEqual(UserCertification.getCertificationByRemindDate(userCerts: userCerts, date: date)?.count, 1)
        XCTAssertNotNil(UserCertification.getCertificationByExpirationDate(userCerts: userCerts, date: date))
        XCTAssertEqual(UserCertification.getCertificationByExpirationDate(userCerts: userCerts, date: date)?.count, 1)
    }
    
    func testVendorModel() {
        let vendor1 = Vendor(id: id, title: test)
        vendor1.description = test
        vendor1.image = test
        XCTAssertEqual(vendor1.id, id)
        XCTAssertEqual(vendor1.title, test)
        XCTAssertEqual(vendor1.description, test)
        XCTAssertEqual(vendor1.image, test)
        let vendorDict = ["id": 2, "title": test, "image": "testimg", "description": "test description"] as [String : AnyObject]
        let vendor2 = Vendor.createVendorFromDict(vendorDict: vendorDict)
        XCTAssertNotNil(vendor2)
        XCTAssertEqual(vendor2!.id, vendorDict["id"] as? Int)
        XCTAssertEqual(vendor2!.title, vendorDict["title"] as? String)
        let vendors = [vendor1, vendor2!]
        XCTAssertNotNil(Vendor.getVendorById(id: id, vendors: vendors))
    }
    
    func testExamModel() {
        let exam = Exam(id: id, title: test, certification: certification)
        XCTAssertEqual(exam.id, id)
        XCTAssertEqual(exam.title, test)
        XCTAssertEqual(exam.certification.id, certification.id)
        XCTAssertFalse(exam.deprecated)
        Exam.certificationService = mockCertService
        let examDict = ["id": id, "title": test, "deprecated": false, "number": "test-1", "certification": certification.id] as [String : AnyObject]
        let exam2 = Exam.createExamFromDict(examDict: examDict)
        XCTAssertNotNil(exam2)
        XCTAssertEqual(exam2!.id, id)
        XCTAssertEqual(exam2!.title, test)
        XCTAssertFalse(exam2!.deprecated)
        XCTAssertEqual(exam2!.number, examDict["number"] as? String)
        XCTAssertEqual(exam2!.certification.id, certification.id)
    }
    
    func testUserExam() {
        let date = Date()
        let exam = Exam(id: id, title: test, certification: certification)
        let userExam = UserExam(id: id, userCertId: id, exam: exam, dateOfPass: date)
        let userCert = UserCertification(id: id, certification: certification, expirationDate: date)
        XCTAssertEqual(userExam.id, id)
        XCTAssertEqual(userExam.userCertificationId, id)
        XCTAssertEqual(userExam.exam.id, exam.id)
        XCTAssertEqual(userExam.dateOfPass, date)
        let userExamDict = ["id": id, "user_certification_id": userCert.id, "exam": ["id": id, "title": test, "deprecated": false, "number": "test-1", "certification": certification.id], "date_of_pass": "2020-10-10"] as [String : AnyObject]
        let userExam2 = UserExam.createUserExamFromDict(dict: userExamDict, userCertification: userCert)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let date2 = formatter.date(from: "2020-10-10")
        XCTAssertNotNil(userExam2)
        XCTAssertEqual(userExam2!.id, id)
        XCTAssertEqual(userExam2!.userCertificationId, userCert.id)
        XCTAssertEqual(userExam2!.exam.id, id)
        XCTAssertEqual(userExam2!.dateOfPass, date2)
    }
}
