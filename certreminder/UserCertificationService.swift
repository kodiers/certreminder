//
//  UserCertificationService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 13/02/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Alamofire

class UserCertificationService {
    /*
     Service for manipulate user certifications
    */
    static let instance = UserCertificationService()
    private let url = "remainder/certification/"
    private let formatter = DateFormatter()
    
    func getUserCertification(completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Get user certification from API
        WebRequestService.webservice.get(url: url, data: nil, completionHandler: {(response, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                var userCertArr = [UserCertification]()
                if let responseDict = response as? Dictionary<String, AnyObject> {
                    // Parse user certification
                    if let resultsArr = responseDict["results"] as? Array<AnyObject> {
                        // Return User's certification array
                        if UserService.instance.user == nil && responseDict["count"] as? Int != 0 {
                            let firstElem = resultsArr[0] as? Dictionary<String, AnyObject>
                            let userDict = firstElem!["user"]
                            let user = User.createUserFromDict(userDict: userDict as! Dictionary<String, AnyObject>)
                            if user != nil {
                                UserService.instance.user = user
                                UserService.instance.user?.token = UserService.instance.token
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
            }
        })
    }
    
    func deleteUserCertification(userCertId: Int, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Delete user certification
        WebRequestService.webservice.delete(url: url, objectID: userCertId, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                completionHandler(result, nil)
            }
        })
    }
    
    func createUserCertification(cert: Certification, expireDate: Date, completionHandler: @escaping (UserCertification?, NSError?) -> ()) {
        // Create user certifcation
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let certExpireDateStr = formatter.string(from: expireDate)
        let data: Parameters = ["certification_id": cert.id, "expiration_date": certExpireDateStr, "remind_at_date": NSNull()]
        WebRequestService.webservice.post(url: url, params: data, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                if let userCertDict = result as? Dictionary<String, AnyObject> {
                    if let certificationDict = userCertDict["certification"] as? Dictionary<String, AnyObject> {
                        if let certification = CertificationService.instance.getCertificationById(id: certificationDict["id"] as! Int) {
                            let userCertification = UserCertification.createUserCertificationFromDict(userCertDict: userCertDict, certification: certification)
                            completionHandler(userCertification, nil)
                        }
                    }
                }
            }
        })
    }
    
    func changeUserCertification(userCert: UserCertification, completionHandler: @escaping (Bool?, NSError?) -> ()) {
        // Change user certification
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let expDate = formatter.string(from: userCert.expirationDate)
        var data: Parameters = [ "certification_id": userCert.certification.id, "expiration_date": expDate]
        var remindDateStr: String?
        if let remindDate = userCert.remindAtDate {
            remindDateStr = formatter.string(from: remindDate)
            data["remind_at_date"] = remindDateStr
        } else {
            data["remind_at_date"] = NSNull()
        }
        WebRequestService.webservice.patch(url: url, objectID: userCert.id, data: data, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                completionHandler(true, nil)
            }
        })
    }
}
