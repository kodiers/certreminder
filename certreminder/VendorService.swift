//
//  VendorService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 01/11/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class VendorService {
    static let instance = VendorService()
    
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
        WebRequestService.webservice.getVendors(completionHandler: {(response, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                self._vendors = response as? [Vendor]
                completionHandler(self._vendors, nil)
            }
        })
    }
    
    func setVendorsToVar(header: String, message: String, viewController: UIViewController, _ setVendors: @escaping ([Vendor]) -> Void, _ showAlert:@escaping (String, String, UIViewController) -> ()) {
        /*
         Get vendors from vendor service (if nul - downloading it). Else call AlertService.showHttpAlert method
         */
        if let vendors = VendorService.instance.vendors {
            setVendors(vendors)
        } else {
            VendorService.instance.downloadVendors(completionHandler: {(vendors, error) in
                if error != nil {
                    showAlert(header, message, viewController)
                } else {
                    setVendors(vendors!)
                }
            })
        }
    }
    
}
