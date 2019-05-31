//
//  CertificationService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 03/11/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit
import Alamofire

class CertificationService: RaiseErrorMixin, CertificationProtocol, CertificationServiceProtocol {
    static let instance = CertificationService()
    static var webservice: WebRequestProtocol = WebRequestService.webservice
    
    private let url = "certifications/certification/"
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
        var data: Parameters? = nil
        if let ven = vendor {
            data = ["vendor": ven.id]
        }
        CertificationService.webservice.get(url: url, data: data, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                var certificationsArr = [Certification]()
                if let responseDict = result as? Dictionary<String, AnyObject> {
                    // Parse certification
                    if let resultsArr = responseDict["results"] as? Array<AnyObject> {
                        for arr in resultsArr {
                            if let certification = Certification.createCertificationFromDict(certDict: arr as! Dictionary<String, AnyObject>) {
                                certificationsArr.append(certification)
                            }
                        }
                    }
                }
                self._certifications = certificationsArr
                completionHandler(self._certifications, nil)
            }
        })
    }
    
    func getCertificationById(id: Int) -> Certification? {
        /*
         Get certification by id
         */
        var certification: Certification? = nil
        if let certs = certifications {
            if let certIndex = certs.firstIndex(where: { $0.id == id }) {
                certification = certs[certIndex]
            }
        }
        return certification
    }
    
    func createCertification(title: String, vendor: Vendor, completionHandler: @escaping (Certification?, NSError?) -> ()) {
        /*
         Create certification and append it to memory stored certifications
        */
        let data: Parameters = ["title": title, "number": NSNull(), "image": NSNull(), "description": NSNull(), "deprecated": false, "vendor": vendor.id]
        CertificationService.webservice.post(url: url, params: data, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                if let dict = result as? Dictionary<String, AnyObject> {
                    if let certification = Certification.createCertificationFromDict(certDict: dict) {
                        if self._certifications == nil {
                            self._certifications = [Certification]()
                        }
                        self._certifications?.append(certification)
                        completionHandler(certification, nil)
                    } else {
                        completionHandler(nil, self.raiseError(errorCode: ERROR_UNKNOWN, message: "Could not create certification"))
                    }
                } else {
                    completionHandler(nil, self.raiseError(errorCode: ERROR_UNKNOWN, message: "Could not create certification"))
                }
            }
        })
    }
    
}
