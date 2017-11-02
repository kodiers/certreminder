//
//  CertificationService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 03/11/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class CertificationService {
    static let instance = CertificationService()
    
    private var _certifications: [Certification]?
    
    var certifications: [Certification]? {
        get {
            return _certifications
        }
    }
    
    func downloadCertifications(vendor: Vendor?, completionHandler: @escaping ([Certification]?, NSError?) -> ()) {
        /*
         Download certifications and store its in memory
         */
        WebRequestService.webservice.getCertifications(vendor: vendor, completionHandler: {(response, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                self._certifications = response as? [Certification]
                completionHandler(self._certifications, nil)
            }
        })
    }
    
}
