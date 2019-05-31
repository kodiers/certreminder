//
//  ChoosedDataService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 16/11/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

class ChoosedDataService: ChoosedDataServiceProtocol {
    /*
     Service for temporary store choosed data
     */
    static let instance = ChoosedDataService()
    
    private var _certificationExpireDate: Date?
    private var _vendor: Vendor?
    private var _choosedCert: Certification?
    private var _examsWithDate: [(Exam, Date)]?
    private var _isEditExistingUserCertification = false
    private var _userCert: UserCertification?
    private var _userExams: [UserExam]?
    
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
    
    var examsWithDate: [(Exam, Date)]? {
        get {
            return _examsWithDate
        }
        set {
            _examsWithDate = newValue
        }
    }
    
    var isEditExistingUserCertification: Bool {
        get {
            return _isEditExistingUserCertification
        }
        set {
            _isEditExistingUserCertification = newValue
        }
    }
    
    var userCertification: UserCertification? {
        get {
            return _userCert
        }
        set {
            _userCert = newValue
        }
    }
    
    var userExams: [UserExam]? {
        get {
            return _userExams
        }
        set {
            _userExams = newValue
        }
    }
    
    func saveData(vendor: Vendor?, certification: Certification?, date: Date?) {
        _vendor = vendor
        _choosedCert = certification
        _certificationExpireDate = date
    }
    
    func saveEditData(isEdit: Bool, userCert: UserCertification, userExams: [UserExam]) {
        _isEditExistingUserCertification = isEdit
        _userCert = userCert
        _userExams = userExams
    }
    
    func changeUserExam(userExam: UserExam) {
        // Change saved user exam
        if let usrExams = userExams {
            if let uExamIndex = usrExams.firstIndex(where: {$0.id == userExam.id && $0.exam.id == userExam.exam.id}) {
                userExams![uExamIndex] = userExam
            }
        }
    }
    
    func getIndexInExamsWithDateFor(exam: Exam) -> Int? {
        // Check if exam in examsWithDate
        if let examsTuple = examsWithDate, let examIndex = examsTuple.firstIndex(where: { ( arg0) -> Bool in
            let (examItem, _) = arg0
            return examItem.id == exam.id
        }) {
            return examIndex
        }
        return nil
    }
    
    func getIndexInUsersExam(exam: Exam) -> Int? {
        // Check if exam in userExams
        if let usrExams = userExams, let examIndex = usrExams.firstIndex(where: { (userExam) -> Bool in
            return userExam.exam.id == exam.id
        }) {
            return examIndex
        }
        return nil
    }
}
