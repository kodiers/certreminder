//
//  Vendor.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 13/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

class Vendor: CommonModel {
    /*
     Vendor model
     */
    class func createVendorFromDict(vendorDict: Dictionary<String, AnyObject>) -> Vendor? {
        // Parse dictionary and create vendor
        if let id = vendorDict["id"] as? Int {
            if let title = vendorDict["title"] as? String {
                let vendor = Vendor(id: id, title: title)
                if let image = vendorDict["image"] as? String {
                    vendor.image = image
                }
                if let description = vendorDict["description"] as? String {
                    vendor.description = description
                }
                return vendor
            }
        }
        return nil
    }
    
    class func getVendorById(id: Int, vendors: [Vendor]) -> Vendor? {
        for vendor in vendors {
            if id == vendor.id {
                return vendor
            }
        }
        return nil
    }
}
