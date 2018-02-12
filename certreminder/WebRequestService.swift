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
    
    func getCertifications(vendor: Vendor?, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Get certifications from API
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "certifications/certification/"
        var parameters: Parameters? = nil
        if let ven = vendor {
            parameters = ["vendor": ven.id]
        }
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                var certificationsArr = [Certification]()
                if let responseDict = result.value as? Dictionary<String, AnyObject> {
                    // Parse certification
                    if let resultsArr = responseDict["results"] as? Array<AnyObject> {
                        for arr in resultsArr {
                            if let certification = Certification.createCertificationFromDict(certDict: arr as! Dictionary<String, AnyObject>) {
                                certificationsArr.append(certification)
                            }
                        }
                    }
                }
                completionHandler(certificationsArr as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func getExams(certification: Certification?, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Get exams from API
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "certifications/exam/"
        var parameters: Parameters? = nil
        if let cert = certification {
            parameters = ["certification": cert.id]
        }
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                var examsArr = [Exam]()
                if let responseDict = result.value as? Dictionary<String, AnyObject> {
                    // Parse exams
                    if let resultsArr = responseDict["results"] as? Array<AnyObject> {
                        for ex_response in resultsArr {
                            if let exam = Exam.createExamFromDict(examDict: ex_response as! Dictionary<String, AnyObject>) {
                                examsArr.append(exam)
                            }
                        }
                    }
                }
                completionHandler(examsArr as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func createUserCertification(cert: Certification, expireDate: Date, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Create user certifcation
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "remainder/certification/"
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let certExpireDateStr = formatter.string(from: expireDate)
        let data: Parameters = ["certification_id": cert.id, "expiration_date": certExpireDateStr, "remind_at_date": NSNull()]
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                if let userCertDict = result.value as? Dictionary<String, AnyObject> {
                    if let certificationDict = userCertDict["certification"] as? Dictionary<String, AnyObject> {
                        if let certification = CertificationService.instance.getCertificationById(id: certificationDict["id"] as! Int) {
                            let userCertification = UserCertification.createUserCertificationFromDict(userCertDict: userCertDict, certification: certification)
                            completionHandler(userCertification, nil)
                        }
                    }
                }
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func createUserExams(certification: UserCertification, examsWithDate: [(Exam, Date)], completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Add exams to user certification
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "remainder/exam/bulk/create/"
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
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                if let userExamsDict = result.value as? Dictionary<String, AnyObject> {
                    if let userExamsArray = userExamsDict["exams"] as? Array<AnyObject> {
                        if userExamsArray.count > 0 {
                            completionHandler(userExamsArray as AnyObject, nil)
                        }
                    }
                }
            }
            else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func getUserExamsForCertification(certification: UserCertification, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Get user exams for certification
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "remainder/exam/"
        let parameters: Parameters = ["user_certification": certification.id]
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                var examsArr = [UserExam]()
                if let responseDict = result.value as? Dictionary<String, AnyObject> {
                    if let resultsArr = responseDict["results"] as? Array<AnyObject> {
                        for res in resultsArr {
                            if let userExam = UserExam.createUserExamFromDict(dict: res as! Dictionary<String, AnyObject>, userCertification: certification) {
                                examsArr.append(userExam)
                            }
                        }
                    }
                }
                completionHandler(examsArr as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func deleteUserExam(userExamId: Int, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Delete user exam
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "remainder/exam/\(userExamId)/"
        Alamofire.request(url, method: .delete, headers: headers).responseJSON{response in
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
    
    func changeUserCertification(userCert: UserCertification, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Change user certification
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "remainder/certification/\(userCert.id)/"
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let expDate = formatter.string(from: userCert.expirationDate)
        var parameters: Parameters = [ "certification_id": userCert.certification.id, "expiration_date": expDate]
        var remindDateStr: String?
        if let remindDate = userCert.remindAtDate {
            remindDateStr = formatter.string(from: remindDate)
            parameters["remind_at_date"] = remindDateStr
        } else {
            parameters["remind_at_date"] = NSNull()
        }
        Alamofire.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                completionHandler(true as AnyObject, nil)
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
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
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
