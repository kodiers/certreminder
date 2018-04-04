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
    /*
     Base class for mocking services requests
    */
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
    /*
     Mock web requests for VendorService
    */
    
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
    /*
     Mock web requests for CertificationService
     */
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
    /*
     Mock web requests for UserService
     */
    override func post(url: String, params: Parameters, completionHandler: @escaping RequestComplete) {
        let response = ["user": ["id": 1, "username": USER] as [String: AnyObject], "token": TOKEN] as [String: AnyObject]
        completionHandler(response as AnyObject, nil)
    }
}

class MockWebServiceUserCertification: MockCommonWebrequest {
    /*
     Mock web requests for UserCertificationService
     */
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
    
    override func delete(url: String, objectID: Int, completionHandler: @escaping RequestComplete) {
        completionHandler(true as AnyObject, nil)
    }
    
    override func post(url: String, params: Parameters, completionHandler: @escaping RequestComplete) {
        let expDateStr = "2020-12-20"
        let remindDateStr = "2020-11-19"
        let userCertDict = ["id": 1, "expiration_date": expDateStr, "remind_at_date": remindDateStr, "certification": ["id": 1] as [String: AnyObject]] as [String : AnyObject]
        completionHandler(userCertDict as AnyObject, nil)
    }
    
    override func patch(url: String, data: Parameters, completionHandler: @escaping RequestComplete) {
        completionHandler(true as AnyObject, nil)
    }
}

class MockExamWebRequestService: MockCommonWebrequest {
    /*
     Mock web requests for ExamService
    */
    override func get(url: String, data: Parameters?, completionHandler: @escaping RequestComplete) {
        let response = ["count": 4, "next": nil, "previous": nil, "results": [
            ["id": 1, "created": "2017-10-08T23:04:12.085799Z", "updated": "2017-10-08T23:04:12.085845Z", "title": "MCSA Windows Server 2016 Virtualization", "number": "70-744", "description": "", "deprecated": false, "certification": 1] as [String: AnyObject],
            ["id": 2, "created": "2017-11-21T22:38:33.352833Z", "updated": "2017-11-21T22:38:33.352874Z", "title": "MCSA Windows Server 2016 Networking", "number": "70-333", "description": "", "deprecated": false, "certification": 1] as [String: AnyObject]
        ]] as [String: AnyObject]
        completionHandler(response as AnyObject, nil)
    }
    
    override func post(url: String, params: Parameters, completionHandler: @escaping RequestComplete) {
        let response = ["id": 1, "created": "2017-10-08T23:04:12.085799Z", "updated": "2017-10-08T23:04:12.085845Z", "title": "MCSA Windows Server 2016 Virtualization", "number": "70-744", "description": "", "deprecated": false, "certification": 1] as [String: AnyObject]
        completionHandler(response as AnyObject, nil)
    }
}

class MockCertSrv: CertificationProtocol {
    /*
     Mock CertificationService for UserCertificationService
    */
    
    func getCertificationById(id: Int) -> Certification? {
        let cert = Certification(id: 1, title: "test", vendor: 1)
        return cert
    }
}

class MockUserExamRequestService: MockCommonWebrequest {
    /*
     Mock web requests for UserExamService
    */
    override func post(url: String, params: Parameters, completionHandler: @escaping RequestComplete) {
        let response = ["exams": [
            ["id": 1, "certification_id": 1, "user_certification_id": 23, "exam_id": 1, "created": "2018-02-13T23:19:19.577904Z", "updated": "2018-02-13T23:19:19.577958Z", "date_of_pass": "2018-04-14", "remind_at_date": nil] as [String: AnyObject],
            ["id": 2, "certification_id": 1, "user_certification_id": 23, "exam_id": 2, "created": "2018-02-13T23:19:19.590649Z", "updated": "2018-02-13T23:19:19.590691Z", "date_of_pass": "2019-02-14", "remind_at_date": nil] as [String: AnyObject],
        ]] as [String: AnyObject]
        completionHandler(response as AnyObject, nil)
    }
    
    override func get(url: String, data: Parameters?, completionHandler: @escaping RequestComplete) {
        let response = ["count": 2, "next": nil, "previous": nil, "results": [
            ["id": 1,
             "user": ["id": 1, "username": "admin", "email": "kodiers@gmail.com", "first_name": "", "last_name": ""] as [String: AnyObject],
             "user_certification": ["id": 1,
                                   "user": ["id": 1, "username": "admin", "email": "kodiers@gmail.com", "first_name": "", "last_name": ""] as [String: AnyObject],
                                   "certification": ["id": 1, "created": "2017-10-08T23:03:52.524493Z", "updated": "2017-10-08T23:03:52.524563Z",
                                                     "title": "MCSA Windows Server 2016 Virtualization and Cloud Platform", "number": "70-443",
                                    "image": nil, "description": "", "deprecated": false, "vendor": 1] as [String: AnyObject],
                                   "certification_id": 1,
                                   "created": "2018-02-13T23:19:19.427010Z",
                                   "updated": "2018-02-13T23:19:19.427064Z",
                                   "expiration_date": "2020-02-14",
                "remind_at_date": nil] as [String: AnyObject],
             "user_certification_id": 1,
             "exam": ["id": 1, "created": "2017-10-08T23:04:12.085799Z", "updated": "2017-10-08T23:04:12.085845Z", "title": "MCSA Windows Server 2016 Virtualization", "number": "70-744", "description": "", "deprecated": false, "certification": 1] as [String: AnyObject],
             "exam_id": 1,
             "created": "2018-02-13T23:19:19.577904Z",
             "updated": "2018-02-13T23:19:19.577958Z",
             "date_of_pass": "2018-04-14",
             "remind_at_date": nil
            ] as [String: AnyObject],
            ["id": 25,
             "user": ["id": 1, "username": "admin", "email": "kodiers@gmail.com", "first_name": "", "last_name": ""] as [String: AnyObject],
             "user_certification": ["id": 1,
                                    "user": ["id": 1, "username": "admin", "email": "kodiers@gmail.com", "first_name": "", "last_name": ""] as [String: AnyObject],
                                    "certification": ["id": 1, "created": "2017-10-08T23:03:52.524493Z", "updated": "2017-10-08T23:03:52.524563Z", "title": "MCSA Windows Server 2016 Virtualization and Cloud Platform", "number": "70-443", "image": nil,
                                        "description": "", "deprecated": false, "vendor": 1] as [String: AnyObject],
                                    "certification_id": 1,
                                    "created": "2018-02-13T23:19:19.427010Z",
                                    "updated": "2018-02-13T23:19:19.427064Z",
                                    "expiration_date": "2020-02-14", "remind_at_date": nil] as [String: AnyObject],
             "user_certification_id": 23,
             "exam": ["id": 2, "created": "2017-11-21T22:38:33.352833Z", "updated": "2017-11-21T22:38:33.352874Z", "title": "MCSA Windows Server 2016 Networking", "number": "70-333", "description": "", "deprecated": false, "certification": 1] as [String: AnyObject],
             "exam_id": 2,
             "created": "2018-02-13T23:19:19.590649Z",
             "updated": "2018-02-13T23:19:19.590691Z",
             "date_of_pass": "2019-02-14",
             "remind_at_date": nil
        ] as [String: AnyObject]]] as [String: AnyObject]
        completionHandler(response as AnyObject, nil)
    }
    
    override func delete(url: String, objectID: Int, completionHandler: @escaping RequestComplete) {
        completionHandler(true as AnyObject, nil)
    }
    
    override func patch(url: String, data: Parameters, completionHandler: @escaping RequestComplete) {
        let response = ["exams": [
            ["id": 1, "certification_id": 1, "user_certification_id": 23, "exam_id": 1, "created": "2018-02-13T23:19:19.577904Z", "updated": "2018-02-13T23:19:19.577958Z", "date_of_pass": "2018-04-14", "remind_at_date": nil] as [String: AnyObject],
            ["id": 2, "certification_id": 1, "user_certification_id": 23, "exam_id": 2, "created": "2018-02-13T23:19:19.590649Z", "updated": "2018-02-13T23:19:19.590691Z", "date_of_pass": "2019-02-14", "remind_at_date": nil] as [String: AnyObject],
            ]] as [String: AnyObject]
        completionHandler(response as AnyObject, nil)
    }
}

class VendorViewController: UIViewController, SetVendorsProtocol {
    /*
     Mock for UIViewController
    */
    
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
    var mockCertService: CertificationProtocol!
    var MockExamRequests: WebRequestProtocol!
    var MockUserExamRequest: WebRequestProtocol!
    
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
        mockCertService = MockCertSrv()
        MockExamRequests = MockExamWebRequestService()
        MockUserExamRequest = MockUserExamRequestService()
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
        success = false
        UserCertificationService.instance.deleteUserCertification(userCertId: id1) { (result, err) in
            if err != nil {
                error = err!
            } else {
                success = (result as? Bool)!
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        UserCertificationService.certificationService = mockCertService
        success = false
        var userCertification: UserCertification?
        let cert = Certification(id: 1, title: "test", vendor: 1)
        UserCertificationService.instance.createUserCertification(cert: cert, expireDate: Date()) { (userCert, err) in
            if err != nil {
                error = err!
            } else {
                userCertification = userCert
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertNotNil(userCertification)
        XCTAssertEqual(userCertification?.id, 1)
        success = false
        UserCertificationService.instance.changeUserCertification(userCert: userCertification!) { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = resp!
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
    }
    
    func testExamService() {
        ExamService.webservice = MockExamRequests
        var success: Bool = false
        var error: NSError?
        var exams = [Exam]()
        Exam.certificationService = mockCertService
        ExamService.instance.getExams(certification: nil) { (exms, err) in
            if err != nil {
                error = err
            } else {
                success = true
                exams = exms!
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertNotEqual(exams.count, 0)
        XCTAssertEqual(exams[0].id, 1)
        success = false
        var exam: Exam?
        let cert = Certification(id: 1, title: "test", vendor: 1)
        ExamService.instance.createExam(title: "test", certification: cert, number: nil) { (resp, err) in
            if err != nil {
                error = (err! as NSError)
            } else {
                success = true
                exam = resp!
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertNotNil(exam)
        XCTAssertEqual(exam?.id, 1)
    }
    
    func testUserExamService () {
        let date: Date = Date()
        let vendor: Vendor = Vendor(id: id1, title: title1)
        let choosedCert: Certification = Certification(id: id1, title: title1, vendor: vendor.id)
        let exam = Exam(id: id1, title: title1, certification: choosedCert)
        let userCert: UserCertification = UserCertification(id: id1, certification: choosedCert, expirationDate: date)
        let examsWithDate = [(exam, date)]
        UserExamService.webservice = MockUserExamRequest
        var success: Bool = false
        var error: NSError?
        UserExamService.instance.createUserExams(certification: userCert, examsWithDate: examsWithDate) { (resp, err) in
            if err != nil {
                error = err!
            } else {
                if let _ = resp as? Array<AnyObject> {
                    success = true
                }
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        success = false
        var usersExams = [UserExam]()
        UserExamService.instance.getUserExamsForCertification(certification: userCert) { (exams, err) in
            if err != nil {
                error = err!
            } else {
                usersExams = exams!
                success = true
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        XCTAssertNotEqual(usersExams.count, 0)
        XCTAssertEqual(usersExams[0].id, id1)
        success = false
        UserExamService.instance.deleteUserExam(userExamId: 1) { (resp, err) in
            if err != nil {
                error = err
            } else {
                success = resp!
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
        success = false
        UserExamService.instance.changeUserExams(certification: userCert, userExams: usersExams) { (resp, err) in
            if err != nil {
                error = err!
            } else {
                if let _ = resp as? Array<AnyObject> {
                    success = true
                }
            }
        }
        XCTAssertNil(error)
        XCTAssertTrue(success)
    }
    
}
