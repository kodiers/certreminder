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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        certDetailVC = storyboard.instantiateViewController(withIdentifier: "CertificationDetailVC") as! CertificationDetailVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConfigureVC() {
        let mockVendorService = MockVendorService()
        mockVendorService._vendors = [Vendor(id: 1, title: "test")]
        certDetailVC.vendorService = mockVendorService
        let certification = Certification(id: 1, title: "test", vendor: 1)
        let date = Date()
        certDetailVC.userCerification = UserCertification(id: 1, certification: certification, expirationDate: date)
        // TODO: complete tests for CertificationDetailVC
    }
    
    
}
