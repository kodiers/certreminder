//
//  VendorService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 01/11/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class VendorService: VendorServiceProtocol {
    static let instance = VendorService()
    static var webservice: WebRequestProtocol = WebRequestService.webservice
    
    private var _vendors: [Vendor]?
    
    var vendors: [Vendor]? {
        get {
            return _vendors
        }
    }
    
    func downloadVendors(completionHandler: @escaping ([Vendor]?, NSError?) -> ()) {
        /*
         Download vendors and store its in memory
         */
        VendorService.webservice.get(url: "certifications/vendor/", data: nil, completionHandler: {(response, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                var vendorsArr = [Vendor]()
                if let responseDict = response as? Dictionary<String, AnyObject> {
                    // Parse user certification
                    if let resultsArr = responseDict["results"] as? Array<AnyObject> {
                        for arr in resultsArr {
                            if let vendor = Vendor.createVendorFromDict(vendorDict: arr as! Dictionary<String, AnyObject>) {
                                vendorsArr.append(vendor)
                            }
                        }
                    }
                }
                self._vendors = vendorsArr
                completionHandler(self.vendors, nil)
            }
        })
    }
    
    func setVendorsToVar(header: String, message: String, viewController: UIViewController, _ setVendors: @escaping ([Vendor]) -> Void, _ showAlert:@escaping (String, String, UIViewController) -> ()) {
        /*
         Get vendors from vendor service (if nul - downloading it). Else call AlertService.showHttpAlert method
         */
        if let vendors = vendors {
            setVendors(vendors)
        } else {
            downloadVendors(completionHandler: {(vendors, error) in
                if error != nil {
                    showAlert(header, message, viewController)
                } else {
                    setVendors(vendors!)
                }
            })
        }
    }
    
    func getVendorByID(id: Int) -> Vendor? {
        /*
         Get vendor by it's id
        */
        var vendor: Vendor? = nil
        if let vndrs = vendors {
            if let index = vndrs.firstIndex(where: { $0.id == id }) {
                vendor = vndrs[index]
            }
        }
        return vendor
    }
    
}
