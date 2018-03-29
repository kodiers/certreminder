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

class MockWebServiceVendors: WebRequestProtocol {
    // TODO: Complete mock service for vendors
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

class servicesTests: XCTestCase {
    
    var id1: Int!
    var id2: Int!
    var title1: String!
    var title2: String!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        id1 = 1
        id2 = 2
        title1 = "title_1"
        title2 = "title_2"
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
        let vendor1 = Vendor(id: id1, title: title1)
        let vendor2 = Vendor(id: id2, title: title2)
    }
    
}
