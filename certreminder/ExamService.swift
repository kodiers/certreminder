//
//  ExamService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 14/02/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Alamofire

class ExamService: RaiseErrorMixin {
    /*
     Service for manipulate exams
    */
    
    static let instance = ExamService()
    static var webservice: WebRequestProtocol = WebRequestService.webservice
    
    private let url = "certifications/exam/"
    
    func getExams(certification: Certification?, completionHandler: @escaping ([Exam]?, NSError?) -> ()) {
        // Get exams from API
        var data: Parameters? = nil
        if let cert = certification {
            data = ["certification": cert.id]
        }
        ExamService.webservice.get(url: url, data: data, completionHandler: {(result, error) in
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
    
    func createExam(title: String, certification: Certification, number: String?, completionHandler: @escaping (Exam?, Error?) -> ()) {
        // Send post request for create exam
        var data: Parameters = ["title": title, "description": NSNull(), "deprecated": false, "certification": certification.id]
        if let exNum = number {
            data["number"] = exNum
        } else {
            data["number"] = NSNull()
        }
        ExamService.webservice.post(url: url, params: data, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                if let dict = result as? Dictionary<String, AnyObject> {
                    if let exam = Exam.createExamFromDict(examDict: dict) {
                        completionHandler(exam, nil)
                    } else {
                        completionHandler(nil, self.raiseError(errorCode: ERROR_CODE_EXAM_EXISTS, message: "Could not create exam"))
                    }
                } else {
                    completionHandler(nil, self.raiseError(errorCode: ERROR_UNKNOWN, message: "Could not create exam"))
                }
            }
        })
    }
}
