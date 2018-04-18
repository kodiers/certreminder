//
//  UserExamService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 20/02/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Alamofire

class UserExamService: RaiseErrorMixin, UserExamServiceProtocol {
    /*
     Service for manipulate user exams
    */
    
    static let instance = UserExamService()
    static var webservice: WebRequestProtocol = WebRequestService.webservice
    
    private let formatter = DateFormatter()
    private let url = "remainder/exam/"
    
    func createUserExams(certification: UserCertification, examsWithDate: [(Exam, Date)], completionHandler: @escaping RequestComplete) {
        // Add exams to user certification
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        var data = Array<Dictionary<String, AnyObject>>()
        for examWithDate in examsWithDate {
            let examDateStr = formatter.string(from: examWithDate.1)
            let userExam = ["user_certification_id": certification.id, "exam_id": examWithDate.0.id, "date_of_pass": examDateStr, "remind_at_date": NSNull()] as [String : AnyObject]
            data.append(userExam)
        }
        let params: Parameters = ["exams": data]
        let bulkUrl = url + "bulk/create/"
        UserExamService.webservice.post(url: bulkUrl, params: params, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                if let userExamsDict = result as? Dictionary<String, AnyObject> {
                    if let userExamsArray = userExamsDict["exams"] as? Array<AnyObject> {
                        if userExamsArray.count > 0 {
                            completionHandler(userExamsArray as AnyObject, nil)
                        } else {
                            completionHandler(nil, self.raiseError(errorCode: ERROR_UNKNOWN, message: "Could not create exams"))
                        }
                    } else {
                        completionHandler(nil, self.raiseError(errorCode: ERROR_UNKNOWN, message: "Could not create exams"))
                    }
                } else {
                    completionHandler(nil, self.raiseError(errorCode: ERROR_UNKNOWN, message: "Could not create exams"))
                }
            }
        })
    }
    
    func getUserExamsForCertification(certification: UserCertification, completionHandler: @escaping ([UserExam]?, NSError?) -> ()) {
        // Get user exams for certification
        let data: Parameters = ["user_certification": certification.id]
        UserExamService.webservice.get(url: url, data: data, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                var examsArr = [UserExam]()
                if let responseDict = result as? Dictionary<String, AnyObject> {
                    if let resultsArr = responseDict["results"] as? Array<AnyObject> {
                        for res in resultsArr {
                            if let userExam = UserExam.createUserExamFromDict(dict: res as! Dictionary<String, AnyObject>, userCertification: certification) {
                                examsArr.append(userExam)
                            }
                        }
                    }
                }
                completionHandler(examsArr, nil)
            }
        })
    }
    
    func deleteUserExam(userExamId: Int, completionHandler: @escaping (Bool?, NSError?) -> ()) {
        // Delete user exam
        UserExamService.webservice.delete(url: url, objectID: userExamId, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                completionHandler(true, nil)
            }
        })
    }
    
    func changeUserExams(certification: UserCertification, userExams: [UserExam], completionHandler: @escaping RequestComplete) {
        // Bulk change users exams
        let changeUrl = url + "bulk/update/"
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        var examData = Array<Dictionary<String, AnyObject>>()
        for uexam in userExams {
            let examDateStr = formatter.string(from: uexam.dateOfPass)
            let userExam = ["user_certification_id": certification.id, "id": uexam.id, "exam_id": uexam.exam.id, "date_of_pass": examDateStr, "remind_at_date": NSNull()] as [String : AnyObject]
            examData.append(userExam)
        }
        let data: Parameters = ["exams": examData]
        UserExamService.webservice.patch(url: changeUrl, data: data, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                if let userExamsDict = result as? Dictionary<String, AnyObject> {
                    if let userExamsArray = userExamsDict["exams"] as? Array<AnyObject> {
                        if userExamsArray.count > 0 {
                            completionHandler(userExamsArray as AnyObject, nil)
                        } else {
                            completionHandler(nil, self.raiseError(errorCode: ERROR_UNKNOWN, message: "Could not change exams"))
                        }
                    } else {
                        completionHandler(nil, self.raiseError(errorCode: ERROR_UNKNOWN, message: "Could not change exams"))
                    }
                } else {
                    completionHandler(nil, self.raiseError(errorCode: ERROR_UNKNOWN, message: "Could not change exams"))
                }
            }
        })
    }
}
