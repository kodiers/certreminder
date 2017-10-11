//
//  UserCertification.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 10/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

class UserCertification {
    private var _id: Int!
    private var _certification: Certification!
    private var _expirationDate: Date!
    private var _remindAtDate: Date?
    private let formatter = DateFormatter()
    
    var id: Int {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
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
    
    init(id: Int, certification: Certification, expirationDate: Date) {
        _id = id
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
    
    class func createUserCertificationFromDict(userCertDict: Dictionary<String, AnyObject>, certification: Certification) -> UserCertification? {
        // Parse dictionary and create user certification
        if let id = userCertDict["id"] as? Int {
            if let expiration_date = userCertDict["expiration_date"] as? Date {
                let userCertification = UserCertification(id: id, certification: certification, expirationDate: expiration_date)
                if let remind_at_date = userCertDict["remind_at_date"] as? Date {
                    userCertification.remindAtDate = remind_at_date
                }
                return userCertification
            }
        }
        return nil
    }
    
}
