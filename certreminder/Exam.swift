//
//  Exam.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 10/11/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

class Exam {
    /*
     Exam model
    */
    private var _id: Int
    private var _title: String
    private var _certification: Certification
    private var _deprecated: Bool
    private var _number: String?
    private var _description: String?
    
    static var certificationService: CertificationProtocol = CertificationService.instance
    
    var id: Int {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var title: String {
        get {
            return _title
        }
        set {
            _title = newValue
        }
    }
    
    var certification: Certification {
        get {
            return _certification
        }
        set {
            _certification = newValue
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
    
    var description: String? {
        get {
            if _description == nil {
                return ""
            }
            return _description!
        }
        set {
            if newValue == nil {
                _description = ""
            } else {
                _description = newValue
            }
        }
    }
    
    init(id: Int, title: String, certification: Certification, deprecated: Bool = false) {
        _id = id
        _title = title
        _certification = certification
        _deprecated = deprecated
    }
    
    class func createExamFromDict(examDict: Dictionary<String, AnyObject>, forCertification certification: Certification) -> Exam? {
        // Parse dictionary and create exam
        if let id = examDict["id"] as? Int {
            if let title = examDict["title"] as? String {
                if let deprecated = examDict["deprecated"] as? Bool {
                    let exam = Exam(id: id, title: title, certification: certification, deprecated: deprecated)
                    if let number = examDict["number"] as? String {
                        exam.number = number
                    }
                    return exam
                }
            }
        }
        return nil
    }
    
}
