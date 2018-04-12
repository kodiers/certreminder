//
//  UserExamServiceProtocol.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 12/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation

protocol UserExamServiceProtocol {
    /*
     Protocol for UserExamService
    */
    func createUserExams(certification: UserCertification, examsWithDate: [(Exam, Date)], completionHandler: @escaping RequestComplete)
    
    func changeUserExams(certification: UserCertification, userExams: [UserExam], completionHandler: @escaping RequestComplete)
    
    func getUserExamsForCertification(certification: UserCertification, completionHandler: @escaping ([UserExam]?, NSError?) -> ())
    
    func deleteUserExam(userExamId: Int, completionHandler: @escaping (Bool?, NSError?) -> ())
}
