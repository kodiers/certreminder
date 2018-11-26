//
//  ChoosedDataServiceProtocol.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 18/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation

protocol ChoosedDataServiceProtocol {
    /*
     Protocol for ChoosedDataService
    */
    
    var userCertification: UserCertification? { get set }
    
    var userExams: [UserExam]? { get set }
    
    var examsWithDate: [(Exam, Date)]? { get set }
    
    var isEditExistingUserCertification: Bool { get set }
    
    func changeUserExam(userExam: UserExam)
    
    func getIndexInExamsWithDateFor(exam: Exam) -> Int?
    
    func getIndexInUsersExam(exam: Exam) -> Int?
}
