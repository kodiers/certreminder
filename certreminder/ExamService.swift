//
//  ExamService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 14/02/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Alamofire

class ExamService {
    /*
     Service for manipulate exams
    */
    
    static let instance = ExamService()
    
    func getExams(certification: Certification?, completionHandler: @escaping ([Exam]?, NSError?) -> ()) {
        // Get exams from API
        var data: Parameters? = nil
        if let cert = certification {
            data = ["certification": cert.id]
        }
        WebRequestService.webservice.get(url: "certifications/exam/", data: data, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                var examsArr = [Exam]()
                if let responseDict = result as? Dictionary<String, AnyObject> {
                    // Parse exams
                    if let resultsArr = responseDict["results"] as? Array<AnyObject> {
                        for ex_response in resultsArr {
                            if let exam = Exam.createExamFromDict(examDict: ex_response as! Dictionary<String, AnyObject>) {
                                examsArr.append(exam)
                            }
                        }
                    }
                }
                completionHandler(examsArr, nil)
            }
        })
    }
}
