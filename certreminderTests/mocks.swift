//
//  mocks.swift
//  certreminderTests
//
//  Created by Viktor Yamchinov on 10/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Alamofire

@testable import certreminder

let TEST = "test"
let id1 = 1


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
    
    func changeUserCertification(userCert: UserCertification, completionHandler: @escaping (Bool?, NSError?) -> ()) {
        completionHandler(true, nil)
    }
}

class MockCertService: CertificationServiceProtocol {
    /*
     Mock CertificationService
     */
    func downloadCertifications(vendor: Vendor?, completionHandler: @escaping ([Certification]?, NSError?) -> ()) {
        completionHandler([Certification(id: id1, title: TEST, vendor: id1)], nil)
    }
    
    func createCertification(title: String, vendor: Vendor, completionHandler: @escaping (Certification?, NSError?) -> ()) {
        completionHandler(Certification(id: id1, title: TEST, vendor: id1), nil)
    }
}

class MockExamSrv: ExamServiceProtocol {
    /*
     Mock ExamService
     */
    func getExamsFor(certification: Certification, completionHandler: @escaping ([Exam]?, NSError?) -> ()) {
        let certification = Certification(id: id1, title: TEST, vendor: id1)
        completionHandler([Exam(id: id1, title: TEST, certification: certification)], nil)
    }
    
    func createExam(title: String, certification: Certification, number: String?, completionHandler: @escaping (Exam?, Error?) -> ()) {
        let certification = Certification(id: id1, title: TEST, vendor: id1)
        completionHandler(Exam(id: id1, title: TEST, certification: certification), nil)
    }
    
    func getExamsForCertificationVendor(certification: Certification, completionHandler: @escaping ([Exam]?, NSError?) -> ()) {
        
    }
    
    func addCertificationToExam(exam: Exam, certification: Certification, completionHandler: @escaping (Exam?, NSError?) -> ()) {
        
    }
}

class MockUserService: UserServiceProtocol {
    /*
     Mock UserService
    */
    func registerUser(username: String, password: String, confirm_password: String, completionHandler: @escaping RequestComplete) {
        completionHandler(true as AnyObject, nil)
    }
    
    func loginUser(username: String, password: String, completionHandler: @escaping RequestComplete) {
        completionHandler(true as AnyObject, nil)
    }
    
    func refreshToken(completionHandler: @escaping RequestComplete) {
        completionHandler(true as AnyObject, nil)
    }
    
    func verifyToken(completionHandler: @escaping RequestComplete) {
        completionHandler(true as AnyObject, nil)
    }
}

class MockVendorService: VendorServiceProtocol {
    /*
     Mock VendorService
    */
    
    var _vendors: [Vendor]?
    
    var vendors: [Vendor]? {
        get {
            return _vendors
        }
    }
    
    func downloadVendors(completionHandler: @escaping ([Vendor]?, NSError?) -> ()) {
        completionHandler([Vendor(id: id1, title: TEST)], nil)
    }
    
    func getVendorByID(id: Int) -> Vendor? {
        return Vendor(id: id1, title: TEST)
    }
}

class MockUserExamService: UserExamServiceProtocol {
    /*
     Mock UserExamService
     */
    let certification: Certification
    let exam: Exam
    let userExam: UserExam
    
    init() {
        self.certification = Certification(id: 1, title: "test", vendor: 1)
        self.exam = Exam(id: 1, title: "test", certification: certification)
        self.userExam = UserExam(id: 1, userCertId: 1, exam: exam, dateOfPass: Date())
    }
    
    func createUserExams(certification: UserCertification, examsWithDate: [(Exam, Date)], completionHandler: @escaping RequestComplete) {
        completionHandler([userExam] as AnyObject, nil)
    }
    
    func changeUserExams(certification: UserCertification, userExams: [UserExam], completionHandler: @escaping RequestComplete) {
        completionHandler([userExam] as AnyObject, nil)
    }
    
    func getUserExamsForCertification(certification: UserCertification, completionHandler: @escaping ([UserExam]?, NSError?) -> ()) {
        completionHandler([userExam], nil)
    }
    
    func deleteUserExam(userExamId: Int, completionHandler: @escaping (Bool?, NSError?) -> ()) {
        completionHandler(true, nil)
    }
}

class MockChoosedDataService: ChoosedDataServiceProtocol {
    /*
     Mock choosed data service
    */
    var _userCertification: UserCertification?
    var _userExams: [UserExam]?
    var _examsWithDate: [(Exam, Date)]?
    var _isEditExistingUserCertification: Bool = false
    
    var userCertification: UserCertification? {
        get {
            return _userCertification
        }
        set {
           _userCertification = newValue
        }
    }
    
    var userExams: [UserExam]? {
        get {
            return _userExams
        }
        set {
            _userExams = newValue
        }
    }
    
    var examsWithDate: [(Exam, Date)]? {
        get {
            return _examsWithDate
        }
        set {
            _examsWithDate = newValue
        }
    }
    
    var isEditExistingUserCertification: Bool {
        get {
            return _isEditExistingUserCertification
        }
        set {
            _isEditExistingUserCertification = newValue
        }
    }
    
    func changeUserExam(userExam: UserExam) {
        // needed to conform protocol
    }
}

class MockViewController: CertificationDetailVC {
    /*
     Mock UIViewCOntroller class for test ChooseExamDateVC
    */
}
