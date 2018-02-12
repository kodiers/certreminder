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
    
    func getUserCertification(completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Get user certification from API
        WebRequestService.webservice.get(url: "remainder/certification/", data: nil, completionHandler: {(response, error) in
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
        WebRequestService.webservice.delete(url: "remainder/certification/", objectID: userCertId, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                completionHandler(result, nil)
            }
        })
    }
}
