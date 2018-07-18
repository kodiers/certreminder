//
//  VendorServiceProtocol.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 12/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation

protocol VendorServiceProtocol {
    /*
     Protocol for VendorService
    */
    var vendors: [Vendor]? { get }
    
    func downloadVendors(completionHandler: @escaping ([Vendor]?, NSError?) -> ())
    
    func getVendorByID(id: Int) -> Vendor?
}
