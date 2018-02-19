//
//  UserExamService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 20/02/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Alamofire

class UserExamService {
    /*
     Service for manipulate user exams
    */
    
    static let instance = UserExamService()
    private let formatter = DateFormatter()
    
    func createUserExams(certification: UserCertification, examsWithDate: [(Exam, Date)], completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
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
        WebRequestService.webservice.post(url: "remainder/exam/bulk/create/", params: params, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                if let userExamsDict = result as? Dictionary<String, AnyObject> {
                    if let userExamsArray = userExamsDict["exams"] as? Array<AnyObject> {
                        if userExamsArray.count > 0 {
                            completionHandler(userExamsArray as AnyObject, nil)
                        }
                    }
                }
            }
        })
    }
}
