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
    
    private var _user: User?
    private var _token: String?
    
    var user: User? {
        set {
            self._user = newValue
        }
        get {
            return self._user
        }
    }
    
    var token: String? {
        get {
            if self._token == nil {
                return ""
            }
            return self._token!
        }
        set {
            self._token = newValue
            if self._user != nil {
                self._user?.token = newValue
            }
        }
    }
    
    func createHeaders() -> Dictionary<String, String> {
        // Create headers
        var headers = ["Accept": "application/json", "Content-Type": "application/json"]
        if self._user == nil {
            if let token = KeychainWrapper.standard.string(forKey: KEY_UID) {
                headers["Authorization"] = "Token \(token)"
            }
        } else {
            if let token = self._user?.token {
                headers["Authorization"] = "Token \(token)"
            }
        }
        return headers
    }
    
    func registerUser(username: String, password: String, confirm_password: String, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // handle register user requests
        let data: Parameters = ["username": username, "password": password, "confirm_password": confirm_password]
        let headers = self.createHeaders()
        let url = WebRequestService.WEB_API_URL + "people/register/"
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    if let userDict = dict["user"] as? Dictionary<String, AnyObject> {
                        let user = User(id: userDict["id"] as! Int, username: userDict["username"] as! String)
                        WebRequestService.webservice.user = user
                        completionHandler(result.value as AnyObject, nil)
                    }
                }
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func loginUser(username: String, password: String, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Login user function
        let data: Parameters = ["username": username, "password": password]
        let headers = self.createHeaders()
        let url = WebRequestService.WEB_API_URL + "people/api-token-auth/"
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                if let tokenDict = result.value as? Dictionary<String, AnyObject> {
                    let token = tokenDict["token"] as! String
                    let _ = KeychainWrapper.standard.set(token, forKey: KEY_UID)
                    WebRequestService.webservice.token = token
                    completionHandler(result.value as AnyObject, nil)
                }
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
            
        }
    }
    
    func logoutUser() {
        // Delete stored user credintial and data
        if self.user != nil {
            self.user = nil
            self.user?.token = nil
        }
        if self._token != nil {
            self._token = nil
        }
        let _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
    }
    
    func refreshToken(completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Refresh token function
        let headers = ["Accept": "application/json"]
        let url = WebRequestService.WEB_API_URL + "people/api-token-refresh/"
        if let token = KeychainWrapper.standard.string(forKey: KEY_UID) {
            let data: Parameters = ["token": token]
            Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
                let result = response.result
                if result.isSuccess {
                    if let tokenDict = result.value as? Dictionary<String, AnyObject> {
                        let token = tokenDict["token"] as! String
                        let _ = KeychainWrapper.standard.set(token, forKey: KEY_UID)
                        WebRequestService.webservice.token = token
                        completionHandler(result.value as AnyObject, nil)
                    }
                } else {
                    print(result.error!)
                    completionHandler(nil, result.error! as NSError)
                }
            }
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Token does not exist in keychain"])
            completionHandler(nil, error)
        }
    }
    
    func verifyToken(completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Verify token function
        let headers = ["Accept": "application/json"]
        let url = WebRequestService.WEB_API_URL + "people/api-token-verify/"
        if let token = KeychainWrapper.standard.string(forKey: KEY_UID) {
            let data: Parameters = ["token": token]
            Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
                let result = response.result
                if result.isSuccess {
                    if let tokenDict = result.value as? Dictionary<String, AnyObject> {
                        let token = tokenDict["token"] as! String
                        let _ = KeychainWrapper.standard.set(token, forKey: KEY_UID)
                        WebRequestService.webservice.token = token
                        completionHandler(result.value as AnyObject, nil)
                    }
                } else {
                    // if error try refresh token
                    self.refreshToken(completionHandler: {(value, error) in
                        if error != nil {
                            // if error logut user
                            self.logoutUser()
                            print(result.error!)
                            completionHandler(nil, result.error! as NSError)
                        } else {
                            completionHandler(value, nil)
                        }
                    })
                }
            }
        }
    }
    
    func getUserCertification(completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Get user certification from API
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "remainder/certification/"
        Alamofire.request(url, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let result = response.result
            if result.isSuccess {
                var userCertArr = [UserCertification]()
                if let responseDict = result.value as? Dictionary<String, AnyObject> {
                    // Parse user certification
                    if let resultsArr = responseDict["results"] as? Array<AnyObject> {
                        // Return User's certification array
                        if self.user == nil && responseDict["count"] as? Int != 0 {
                            let firstElem = resultsArr[0] as? Dictionary<String, AnyObject>
                            let userDict = firstElem!["user"]
                            let user = User.createUserFromDict(userDict: userDict as! Dictionary<String, AnyObject>)
                            if user != nil {
                                self.user = user
                                self.user?.token = self.token
                            }
                        }
                        for arr in resultsArr {
                            if let certDict = arr["certification"] as? Dictionary<String, AnyObject> {
                                if let certification = Certification.createCertificationFromDict(certDict: certDict) {
                                    let userCertification = UserCertification.createUserCertificationFromDict(userCertDict: arr as! Dictionary<String, AnyObject>, certification: certification)
                                    if userCertification != nil {
                                        userCertArr.append(userCertification!)
                                    }
                                }
                            }
                        }
                    }
                }
                completionHandler(userCertArr as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func getVendors(completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Get vendors from API
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "certifications/vendor/"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                var vendorsArr = [Vendor]()
                if let responseDict = result.value as? Dictionary<String, AnyObject> {
                    // Parse user certification
                    if let resultsArr = responseDict["results"] as? Array<AnyObject> {
                        for arr in resultsArr {
                            if let vendor = Vendor.createVendorFromDict(vendorDict: arr as! Dictionary<String, AnyObject>) {
                                vendorsArr.append(vendor)
                            }
                        }
                    }
                }
                completionHandler(vendorsArr as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func deleteUserCertification(userCertId: Int, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Delete user certification
        let headers = createHeaders()
        let url = WebRequestService.WEB_API_URL + "remainder/certification/\(userCertId)/"
        Alamofire.request(url, method: .delete, headers: headers).responseJSON {response in
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
    
}
