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
        let examsWithDate: [(Exam, Date)] = [(exam, certificationExpireDate)]
        let isEditExistingUserCertification = false
        let userCert: UserCertification = UserCertification(id: id1, certification: choosedCert, expirationDate: certificationExpireDate)
        let userExam = UserExam(id: id1, userCertId: userCert.id, exam: exam, dateOfPass: certificationExpireDate)
        var userExams: [UserExam] = [userExam]
        // TODO: Complete tests for service
    }
    
}
