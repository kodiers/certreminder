//
//  servicesTests.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 29/03/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import XCTest
import Alamofire

@testable import certreminder

let USER = "user"
let TOKEN = "test"

class MockCommonWebrequest: WebRequestProtocol {
    func post(url: String, params: Parameters, completionHandler: @escaping RequestComplete) {
        completionHandler(nil, nil)
    }
    
    func get(url: String, data: Parameters?, completionHandler: @escaping RequestComplete) {
        completionHandler(nil, nil)
    }
    
    func delete(url: String, objectID: Int, completionHandler: @escaping RequestComplete) {
        completionHandler(nil, nil)
    }
    
    func patch(url: String, data: Parameters, completionHandler: @escaping RequestComplete) {
        completionHandler(nil, nil)
    }
}

class MockWebServiceVendors: MockCommonWebrequest {
    
    override func get(url: String, data: Parameters?, completionHandler: @escaping RequestComplete) {
        let response = ["count": 3, "results": [
            ["id": 1, "created": "2017-10-08T23:03:17.079890Z", "updated": "2017-10-08T23:03:17.079933Z",
             "title": "Microsoft", "image": nil, "description": ""] as [String : AnyObject],
            ["id": 2, "created": "2017-11-01T22:01:29.549536Z", "updated": "2017-11-01T22:01:29.549612Z", "title": "VMware", "image": nil, "description": ""] as [String : AnyObject]
            ]] as [String : AnyObject]
        completionHandler(response as AnyObject, nil)
    }
}

class MockWebServiceCertifications: MockCommonWebrequest {
    override func get(url: String, data: Parameters?, completionHandler: @escaping RequestComplete) {
        let response = ["count": 19, "next": nil, "previous": nil, "results": [
            ["id": 1, "created": "2017-10-08T23:03:52.524493Z", "updated": "2017-10-08T23:03:52.524563Z", "title": "MCSA Windows Server 2016 Virtualization and Cloud Platform", "number": "70-443", "image": nil, "description": "", "deprecated": false, "vendor": 1] as [String : AnyObject], ["id": 2, "created": "2017-11-07T22:42:10.036924Z", "updated": "2017-11-07T22:42:10.036971Z", "title": "MCSA Windows Server 2016 Security", "number": nil, "image": nil, "description": "", "deprecated": false, "vendor": 1] as [String : AnyObject]
            ]] as [String : AnyObject]
        completionHandler(response as AnyObject, nil)
    }
    
    override func post(url: String, params: Parameters, completionHandler: @escaping RequestComplete) {
        let response = ["id": 1, "created": "2017-10-08T23:03:52.524493Z", "updated": "2017-10-08T23:03:52.524563Z", "title": "MCSA Windows Server 2016 Virtualization and Cloud Platform", "number": "70-443", "image": nil, "description": "", "deprecated": false, "vendor": 1] as [String : AnyObject]
        completionHandler(response as AnyObject, nil)
    }
}

class MockWebServiceUser: MockCommonWebrequest {
    override func post(url: String, params: Parameters, completionHandler: @escaping RequestComplete) {
        let response = ["user": ["id": 1, "username": USER] as [String: AnyObject], "token": TOKEN] as [String: AnyObject]
        completionHandler(response as AnyObject, nil)
    }
}

class MockWebServiceUserCertification: MockCommonWebrequest {
    override func get(url: String, data: Parameters?, completionHandler: @escaping RequestComplete) {
        let response = ["count": 1, "next": nil, "previous": nil,"results": [
            ["id": 1,
             "user": ["id": 1, "username": "admin", "email": "kodiers@gmail.com", "first_name": "", "last_name": ""] as [String: AnyObject],
             "certification": ["id": 1, "created": "2017-10-08T23:03:52.524493Z", "updated": "2017-10-08T23:03:52.524563Z", "title": "MCSA Windows Server 2016 Virtualization and Cloud Platform", "number": "70-443", "image": nil, "description": "", "deprecated": false, "vendor": 1] as [String: AnyObject],
             "certification_id": 1,
             "created": "2018-02-13T23:19:19.427010Z",
             "updated": "2018-02-13T23:19:19.427064Z",
             "expiration_date": "2020-02-14",
            "remind_at_date": nil] as [String: AnyObject]
            ]
        ] as [String: AnyObject]
        completionHandler(response as AnyObject, nil)
    }
}

class VendorViewController: UIViewController, SetVendorsProtocol {
    
    var vendors: [Vendor]?
    
    func setVendors(vendors: [Vendor]) {
        self.vendors = vendors
    }
}

class servicesTests: XCTestCase {
    
    var id1: Int!
    var id2: Int!
    var title1: String!
    var title2: String!
    var MockVendorsRequestService: WebRequestProtocol!
    var vendorVC: VendorViewController!
    var MockCerticationRequestService: WebRequestProtocol!
    var MockUserRequestService: WebRequestProtocol!
    var MockUserCertificationRequestService: WebRequestProtocol!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        id1 = 1
        id2 = 2
        title1 = "title_1"
        title2 = "title_2"
        MockVendorsRequestService = MockWebServiceVendors()
        vendorVC = VendorViewController()
        MockCerticationRequestService = MockWebServiceCertifications()
        MockUserRequestService = MockWebServiceUser()
        MockUserCertificationRequestService = MockWebServiceUserCertification()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVendorService() {
        VendorService.webservice = MockVendorsRequestService
        var vendors = [Vendor]()
        var error: NSError?
        VendorService.instance.downloadVendors { (vens, err) in
            if err != nil {
                error = err!
            } else {
                if let vs = vens {
                    vendors = vs
                }
            }
        }
        XCTAssertNil(error)
        XCTAssertNotNil(vendors)
        XCTAssertNotEqual(vendors.count, 0)
        XCTAssertEqual(vendors[0].id, id1)
        XCTAssertNotNil(VendorService.instance.vendors)
        XCTAssertNotEqual(VendorService.instance.vendors?.count, 0)
        XCTAssertEqual(VendorService.instance.vendors![0].id, id1)
        let vendor1 = VendorService.instance.getVendorByID(id: id1)
        XCTAssertNotNil(vendor1)
        XCTAssertEqual(vendor1?.id, id1)
        VendorService.instance.setVendorsToVar(header: "TEST", message: "TEST", viewController: vendorVC, vendorVC.setVendors, AlertService.showCancelAlert)
        XCTAssertNotNil(vendorVC.vendors)
        XCTAssertNotEqual(vendorVC.vendors?.count, 0)
        XCTAssertEqual(vendorVC.vendors![0].id, id1)
    }
    
    func testCertificationService() {
        CertificationService.webservice = MockCerticationRequestService
        var certifications = [Certification]()
        var error: NSError?
        CertificationService.instance.downloadCertifications(vendor: nil) { (certs, err) in
            if err != nil {
                error = err!
            } else {
                if let certifs = certs {
                    certifications = certifs
                }
            }
        }
        XCTAssertNil(error)
        XCTAssertNotNil(certifications)
        XCTAssertNotEqual(certifications.count, 0)
        XCTAssertEqual(certifications[0].id, id1)
        XCTAssertNotNil(CertificationService.instance.certifications)
        XCTAssertNotEqual(CertificationService.instance.certifications?.count, 0)
        XCTAssertEqual(CertificationService.instance.certifications![0].id, id1)
        let certification = CertificationService.instance.getCertificationById(id: id1)
        XCTAssertNotNil(certification)
        XCTAssertEqual(certification?.id, id1)
        let vendor1 = Vendor(id: id1, title: title1)
        var newCertification: Certification? = nil
        CertificationService.instance.createCertification(title: title1, vendor: vendor1) { (cert, err) in
            if err != nil {
                error = err!
            } else {
                if let cr = cert {
                    newCertification = cr
                }
            }
        }
        XCTAssertNil(error)
        XCTAssertNotNil(newCertification)
        XCTAssertEqual(newCertification?.id, id1)
    }
    
    func testChoosedDataService() {
        let certificationExpireDate: Date = Date()
        let vendor: Vendor = Vendor(id: id1, title: title1)
        let choosedCert: Certification = Certification(id: id1, title: title1, vendor: vendor.id)
        let exam = Exam(id: id1, title: title1, certification: choosedCert)
        let isEditExistingUserCertification = false
        let userCert: UserCertification = UserCertification(id: id1, certification: choosedCert, expirationDate: certificationExpireDate)
        let userExam = UserExam(id: id1, userCertId: userCert.id, exam: exam, dateOfPass: certificationExpireDate)
        let userExams: [UserExam] = [userExam]
        ChoosedDataService.instance.saveData(vendor: vendor, certification: choosedCert, date: certificationExpireDate)
        XCTAssertEqual(ChoosedDataService.instance.vendor?.id, id1)
        XCTAssertEqual(ChoosedDataService.instance.choosedCert?.id, choosedCert.id)
        XCTAssertEqual(ChoosedDataService.instance.certificationExpireDate, certificationExpireDate)
        ChoosedDataService.instance.saveEditData(isEdit: isEditExistingUserCertification, userCert: userCert, userExams: userExams)
        XCTAssertEqual(ChoosedDataService.instance.isEditExistingUserCertification, isEditExistingUserCertification)
        XCTAssertEqual(ChoosedDataService.instance.userCertification?.id, userCert.id)
        XCTAssertEqual(ChoosedDataService.instance.userExams?[0].id, userExam.id)
        userExam.id = id2
        ChoosedDataService.instance.changeUserExam(userExam: userExam)
        XCTAssertEqual(ChoosedDataService.instance.userExams?[0].id, id2)
    }
    
    func testUserService() {
        UserService.webservice = MockUserRequestService
        var success: Bool = false
        var error: NSError?
        UserService.instance.registerUser(username: USER, password: title1, confirm_password: title1) { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertEqual(UserService.instance.user?.username, USER)
        success = false
        UserService.instance.loginUser(username: USER, password: USER) { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertEqual(UserService.instance.token, TOKEN)
        success = false
        UserService.instance.refreshToken { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertEqual(UserService.instance.token, TOKEN)
        success = false
        UserService.instance.verifyToken { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertEqual(UserService.instance.token, TOKEN)
        UserService.instance.logoutUser()
        XCTAssertNil(UserService.instance.user)
        XCTAssertNil(UserService.instance.token)
    }
    
    func testUserCertificationService() {
        UserCertificationService.webservice = MockUserCertificationRequestService
        var success: Bool = false
        var error: NSError?
        var userCetifications = [UserCertification]()
        UserCertificationService.instance.getUserCertification { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = true
                userCetifications = resp as! [UserCertification]
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertNotEqual(userCetifications.count, 0)
        XCTAssertEqual(userCetifications[0].id, id1)
        // TODO: Complete user certifications service test
    }
    
}
