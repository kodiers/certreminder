//
//  ExamServiceProtocol.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 06/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation

protocol ExamServiceProtocol {
    /*
     Protocol for ExamService
    */
    func getExams(certification: Certification?, completionHandler: @escaping ([Exam]?, NSError?) -> ())
}
