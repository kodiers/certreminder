//
//  WebRequestService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 23/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

typealias RequestComplete = () -> ()

class WebRequestService {
    /*
     Web request service
    */

    
    static let WEB_API_URL = "http://certapp.techforline.com/api/"
    static let webservice = WebRequestService()
    
    private let formatter = DateFormatter()
    
    func createHeaders() -> Dictionary<String, String> {
        // Create headers
        var headers = ["Accept": "application/json", "Content-Type": "application/json"]
        if let token = UserService.instance.token {
            headers["Authorization"] = "Token \(token)"
        }
        return headers
    }
    
    func post(url: String, params: Parameters, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Send post request
        let headers = self.createHeaders()
        let fullUrl = WebRequestService.WEB_API_URL + url
        Alamofire.request(fullUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                completionHandler(result.value as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func get(url: String, data: Parameters?, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Send get request
        let headers = self.createHeaders()
        let fullUrl = WebRequestService.WEB_API_URL + url
        Alamofire.request(fullUrl, method: .get, parameters: data, encoding: URLEncoding.queryString, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                completionHandler(result.value as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func delete(url: String, objectID: Int, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Send delete request
        let headers = self.createHeaders()
        let fullUrl = WebRequestService.WEB_API_URL + url + "\(objectID)/"
        Alamofire.request(fullUrl, method: .delete, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                // Return if deletion success, because no content
                completionHandler(true as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func patch(url: String, objectID: Int, data: Parameters, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Send patch request
        let headers = self.createHeaders()
        let fullUrl = WebRequestService.WEB_API_URL + url + "\(objectID)/"
        Alamofire.request(fullUrl, method: .patch, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                completionHandler(result.value as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func changeUserExams(certification: UserCertification, userExams: [UserExam], completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Bulk change users exams
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "remainder/exam/bulk/update/"
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        var data = Array<Dictionary<String, AnyObject>>()
        for uexam in userExams {
            let examDateStr = formatter.string(from: uexam.dateOfPass)
            let userExam = ["user_certification_id": certification.id, "id": uexam.id, "exam_id": uexam.exam.id, "date_of_pass": examDateStr, "remind_at_date": NSNull()] as [String : AnyObject]
            data.append(userExam)
        }
        let params: Parameters = ["exams": data]
        Alamofire.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                if let userExamsDict = result.value as? Dictionary<String, AnyObject> {
                    if let userExamsArray = userExamsDict["exams"] as? Array<AnyObject> {
                        if userExamsArray.count > 0 {
                            completionHandler(userExamsArray as AnyObject, nil)
                        }
                    }
                }
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func createCertification(title: String, vendor: Vendor, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Send post request for create certification
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "certifications/certification/"
        let parameters: Parameters = ["title": title, "number": NSNull(), "image": NSNull(), "description": NSNull(), "deprecated": false, "vendor": vendor.id]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    if let certification = Certification.createCertificationFromDict(certDict: dict) {
                        completionHandler(certification, nil)
                    }
                }
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func createExam(title: String, certification: Certification, number: String?, completionHandler: @escaping (AnyObject?, Error?) -> ()) {
        // Send post request for create exam
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "certifications/exam/"
        var parameters: Parameters = ["title": title, "description": NSNull(), "deprecated": false, "certification": certification.id]
        if let exNum = number {
            parameters["number"] = exNum
        } else {
            parameters["number"] = NSNull()
        }
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    if let exam = Exam.createExamFromDict(examDict: dict) {
                        completionHandler(exam, nil)
                    } else {
                        let error = NSError(domain: CUSTOM_ERROR_DOMAIN, code: ERROR_CODE_EXAM_EXISTS, userInfo: [NSLocalizedDescriptionKey: "Could not create exam"])
                        completionHandler(nil, error)
                    }
                }
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
}
