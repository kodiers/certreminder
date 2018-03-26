//
//  modelsTests.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 23/03/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
@testable import certreminder

class modelsTests: XCTestCase {
    
    var certification: Certification!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        certification = Certification(id: 1, title: "test", vendor: 1, deprectated: false)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCommonModel() {
        let test = "Test"
        let id = 1
        let cm = CommonModel(id: id, title: test)
        cm.description = test
        cm.image = test
        XCTAssertTrue(cm.id == id)
        XCTAssertTrue(cm.title == test)
        XCTAssertTrue(cm.description == test)
        XCTAssertTrue(cm.image == test)
    }
    
    func testUserModel() {
        let id = 1
        let username = "user"
        let token = "jsdgfjgdsjhfhjdfjhsdhjfdsf"
        let user = User(id: id, username: username, token: token)
        XCTAssertTrue(user.id == id)
        XCTAssertTrue(user.username == username)
        XCTAssertTrue(user.token == token)
        let userDict = ["id": 1, "username": username, "first_name": "Test", "last_name": "Test", "email": "test@test.ru"] as [String : AnyObject]
        let user2 = User.createUserFromDict(userDict: userDict as Dictionary<String, AnyObject>)
        XCTAssertNotNil(user2)
        XCTAssertTrue(user2?.id == id)
        XCTAssertTrue(user2?.username == username)
        XCTAssertTrue(user2?.firstName == userDict["first_name"] as? String)
        XCTAssertTrue(user2?.lastName == userDict["last_name"] as? String)
        XCTAssertTrue(user2?.email == userDict["email"] as? String)
    }
    
    func testCertificationModel() {
        let id = 1
        let title = "test"
        let vendor = 1
        let cert = Certification(id: id, title: title, vendor: vendor)
        XCTAssertTrue(cert.id == id)
        XCTAssertTrue(cert.title == title)
        XCTAssertTrue(cert.vendor == vendor)
        let certDict = ["id": 1, "title": title, "vendor": vendor, "deprecated": false, "number": "test-1", "image": "testimg", "description": "test description"] as [String : AnyObject]
        let cert2 = Certification.createCertificationFromDict(certDict: certDict)
        XCTAssertNotNil(cert2)
        XCTAssertTrue(cert2?.id == id)
        XCTAssertTrue(cert2?.title == title)
        XCTAssertTrue(cert2?.vendor == vendor)
        XCTAssertFalse((cert2?.deprecated)!)
        XCTAssertTrue(cert2?.number == certDict["number"] as? String)
        XCTAssertTrue(cert2?.image == certDict["image"] as? String)
        XCTAssertTrue(cert2?.description == certDict["description"] as? String)
    }
    
    func testUserCertificationModel() {
        let date = Date()
        let id = 1
        let userCert = UserCertification(id: id, certification: certification, expirationDate: date)
        XCTAssertNotNil(userCert)
        XCTAssertTrue(userCert.expirationDate == date)
        XCTAssertTrue(userCert.id == id)
        XCTAssertTrue(userCert.certification === certification)
        XCTAssertNil(userCert.remindAtDate)
        userCert.remindAtDate = date
        XCTAssertTrue(userCert.remindAtDate == date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let dateStr = formatter.string(from: date)
        XCTAssertTrue(userCert.expirationDateAsString() == dateStr)
        XCTAssertTrue(userCert.remindAtDateAsString() == dateStr)
        let expDateStr = "2020-12-20"
        let remindDateStr = "2020-11-19"
        let userCertDict = ["id": 1, "expiration_date": expDateStr, "remind_at_date": remindDateStr] as [String : AnyObject]
        let userCert2 = UserCertification.createUserCertificationFromDict(userCertDict: userCertDict, certification: certification)
        XCTAssertNotNil(userCert2)
        XCTAssertTrue(userCert2?.expirationDateAsString() == "20-12-2020")
        XCTAssertTrue(userCert2?.remindAtDateAsString() == "19-11-2020")
        XCTAssertTrue(userCert2?.id == userCertDict["id"] as? Int)
        XCTAssertTrue(userCert2?.certification.id == certification.id)
        let userCerts: [UserCertification] = [userCert, userCert2!]
        XCTAssertNotNil(UserCertification.getCertificationByRemindDate(userCerts: userCerts, date: date))
        XCTAssertTrue(UserCertification.getCertificationByRemindDate(userCerts: userCerts, date: date)?.count == 1)
        XCTAssertNotNil(UserCertification.getCertificationByExpirationDate(userCerts: userCerts, date: date))
        XCTAssertTrue(UserCertification.getCertificationByExpirationDate(userCerts: userCerts, date: date)?.count == 1)
    }
    
    func testVendorModel() {
        let test = "Test"
        let id = 1
        let ven = Vendor(id: id, title: test)
        ven.description = test
        ven.image = test
        XCTAssertTrue(ven.id == id)
        XCTAssertTrue(ven.title == test)
        XCTAssertTrue(ven.description == test)
        XCTAssertTrue(ven.image == test)
        let vendorDict = ["id": 1, "title": test, "number": "test-1", "image": "testimg", "description": "test description"] as [String : AnyObject]
        let vendor2 = Vendor.createVendorFromDict(vendorDict: vendorDict)
        XCTAssertNotNil(vendor2)
        // TODO: Complete vendor tests
    }
    
    
    
    
}
