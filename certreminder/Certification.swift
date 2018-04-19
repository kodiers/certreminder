//
//  File.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 09/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

class Certification: CommonModel {
    /*
     Certification model
     */
    private var _vendor: Int!
    private var _number: String?
    private var _deprecated: Bool
    
    var vendor: Int {
        get {
            return _vendor
        }
        set {
            _vendor = newValue
        }
    }
    
    var number: String? {
        get {
            if _number == nil {
                return ""
            }
            return _number!
        }
        set {
            if newValue == nil {
                _number = ""
            } else {
                _number = newValue
            }
        }
    }
    
    var deprecated: Bool {
        get {
            return _deprecated
        }
        set {
            _deprecated = newValue
        }
    }
    
    init(id: Int, title: String, vendor: Int, deprectated: Bool = false) {
        _vendor = vendor
        _deprecated = deprectated
        super.init(id: id, title: title)
    }
    
    class func createCertificationFromDict(certDict: Dictionary<String, AnyObject>) -> Certification? {
        // Parse dictionary and create certification
        if let id = certDict["id"] as? Int {
            if let title = certDict["title"] as? String {
                if let vendor = certDict["vendor"] as? Int  {
                    if let deprecated = certDict["deprecated"] as? Bool {
                        let certification = Certification(id: id, title: title, vendor: vendor, deprectated: deprecated)
                        if let number = certDict["number"] as? String {
                            certification.number = number
                        }
                        if let image = certDict["image"] as? String {
                            certification.image = image
                        }
                        if let description = certDict["description"] as? String {
                            certification.description = description
                        }
                        return certification
                    }
                }
            }
        }
        return nil
    }
}
