//
//  UserExam.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 05/12/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

class UserExam {
    /*
     User exam model
     */
    private var _id: Int!
    private var _userCertificationId: Int!
    private var _exam: Exam!
    private var _dateOfPass: Date!
    private var _remindAtDate: Date?
    
    var id: Int {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var userCertificationId: Int {
        get {
            return _userCertificationId
        }
        set {
            _userCertificationId = newValue
        }
    }
    
    var exam: Exam {
        get {
            return _exam
        }
        set {
            _exam = newValue
        }
    }
    
    var dateOfPass: Date {
        get {
            return _dateOfPass
        }
        set {
            _dateOfPass = newValue
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
    
    init(id: Int, userCertId: Int, exam: Exam, dateOfPass: Date) {
        self._id = id
        self._userCertificationId = userCertId
        self._exam = exam
        self._dateOfPass = dateOfPass
    }
    
    class func createUserExamFromDict(dict: Dictionary<String, AnyObject>) -> UserExam? {
        // Parse dict and create user exam
        if let id = dict["id"] as? Int {
            if let userCertificationId = dict["user_certification_id"] as? Int {
                if let exam = Exam.createExamFromDict(examDict: dict["exam"] as! Dictionary<String, AnyObject>) {
                    if let dateStr = dict["date_of_pass"] as? String {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        formatter.timeZone = Calendar.current.timeZone
                        formatter.locale = Calendar.current.locale
                        let dateOfPass = formatter.date(from: dateStr)
                        let userExam = UserExam(id: id, userCertId: userCertificationId, exam: exam, dateOfPass: dateOfPass!)
                        return userExam
                    }
                }
            }
        }
        return nil
    }
}
