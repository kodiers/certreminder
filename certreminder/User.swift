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
    private var _first_name: String?
    private var _last_name: String?
    private var _token: String!
    private var _country: String?
    private var _date_of_birth: Date?
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
    
    var first_name: String {
        if self._first_name == nil {
            return ""
        }
        return self._first_name!
    }
    
    var last_name: String {
        if self._last_name == nil {
            return ""
        }
        return self._last_name!
    }
    
    var token: String {
        return self._token
    }
    
    var country: String {
        if self._country == nil {
            return ""
        }
        return self._country!
    }
    
    var date_of_birth: Date? {
        return self._date_of_birth
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
    
    init(id: Int, username: String, token: String) {
        self._id = id
        self._username = username
        self._token = token
    }
}
