//
//  ChoosedDataService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 16/11/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

class ChoosedDataService {
    /*
     Service for temporary store choosed data
     */
    static let instance = ChoosedDataService()
    
    private var _certificationExpireDateStr: String?
    private var _vendor: Vendor?
    private var _choosedCert: Certification?
    private var _examsWithDate: [(Exam, String)]?
    
    var certificationExpireDateStr: String? {
        get {
            return _certificationExpireDateStr
        }
        set {
            _certificationExpireDateStr = newValue
        }
    }
    
    var vendor: Vendor? {
        get {
            return _vendor
        }
        set {
            _vendor = newValue
        }
    }
    
    var choosedCert: Certification? {
        get {
            return _choosedCert
        }
        set {
            _choosedCert = newValue
        }
    }
    
    var examsWithDate: [(Exam, String)]? {
        get {
            return _examsWithDate
        }
        set {
            _examsWithDate = newValue
        }
    }
    
    func saveData(vendor: Vendor?, certification: Certification?, dateStr: String?) {
        _vendor = vendor
        _choosedCert = certification
        _certificationExpireDateStr = dateStr
    }
}
