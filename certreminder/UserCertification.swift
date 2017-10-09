//
//  UserCertification.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 10/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

class UserCertification {
    private var _certification: Certification!
    private var _expirationDate: Date!
    private var _remindAtDate: Date?
    private let formatter = DateFormatter()
    
    var certification: Certification! {
        get {
            return _certification
        }
        set {
            _certification = newValue
        }
    }
    
    var expirationDate: Date {
        get {
            return _expirationDate
        }
        set {
            _expirationDate = newValue
        }
    }
    
    var remindAtDate: Date? {
        get {
            return _remindAtDate
        }
        set {
            _remindAtDate = newValue
        }
    }
    
    init(certification: Certification, expirationDate: Date) {
        _certification = certification
        _expirationDate = expirationDate
    }
    
    private func configureFormatter() {
        formatter.dateFormat = "dd MM yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
    }
    
    func expirationDateAsString() -> String {
        configureFormatter()
        let expirationDateAsStr = formatter.string(from: _expirationDate)
        return expirationDateAsStr
    }
    
    func remindAtDateAsString() -> String {
        configureFormatter()
        if _remindAtDate == nil {
            return ""
        }
        let remindAtDateAsStr = formatter.string(from: _remindAtDate!)
        return remindAtDateAsStr
    }
    
}
