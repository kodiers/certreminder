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
    
    private var _certificationExpireDate: Date?
    private var _vendor: Vendor?
    private var _choosedCert: Certification?
    private var _examsWithDate: [(Exam, String)]?
    
    var certificationExpireDate: Date? {
        get {
            return _certificationExpireDate
        }
        set {
            _certificationExpireDate = newValue
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
    
    func saveData(vendor: Vendor?, certification: Certification?, date: Date?) {
        _vendor = vendor
        _choosedCert = certification
        _certificationExpireDate = date
    }
}
