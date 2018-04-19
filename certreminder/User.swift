//
//  User.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 23/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation


class User {
    private var _id: Int!
    private var _username: String!
    private var _email: String?
    private var _firstName: String?
    private var _lastName: String?
    private var _token: String?
    private var _country: String?
    private var _dateOfBirth: Date?
    private var _description: String?
    private var _avatar: String?
    
    var id: Int {
        return self._id
    }
    
    var username: String {
        return self._username
    }
    
    var email: String {
        if self._email == nil {
            return ""
        }
        return self._email!
    }
    
    var firstName: String {
        if self._firstName == nil {
            return ""
        }
        return self._firstName!
    }
    
    var lastName: String {
        if self._lastName == nil {
            return ""
        }
        return self._lastName!
    }
    
    var token: String? {
        get {
            return self._token
        }
        set {
            self._token = newValue
        }
    }
    
    var country: String {
        if self._country == nil {
            return ""
        }
        return self._country!
    }
    
    var date_of_birth: Date? {
        return self._dateOfBirth
    }
    
    var description: String {
        if self._description == nil {
            return ""
        }
        return self._description!
    }
    
    var avatar: String {
        if self._avatar == nil {
            return ""
        }
        return self._avatar!
    }
    init(id: Int, username: String) {
        self._id = id
        self._username = username
    }
    
    init(id: Int, username: String, token: String) {
        self._id = id
        self._username = username
        self._token = token
    }
    
    class func createUserFromDict(userDict: Dictionary<String, AnyObject>) -> User? {
        // Parse dict and create user object
        if let id = userDict["id"] as? Int {
            if let username = userDict["username"] as? String {
                let user = User(id: id, username: username)
                if let first_name = userDict["first_name"] as? String {
                    user._firstName = first_name
                }
                if let last_name = userDict["last_name"] as? String {
                    user._lastName = last_name
                }
                if let email = userDict["email"] as? String {
                    user._email = email
                }
                return user
            }
        }
        return nil
    }
}
