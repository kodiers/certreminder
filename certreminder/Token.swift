//
//  Token.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 23/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation


class Token {
    private var _userId: Int!
    private var _token: String!
    
    var userId: Int {
        get {
            return self._userId
        }
        set {
            self._userId = newValue
        }
    }
    
    var token: String {
        get {
            return self._token
        }
        set {
            self._token = newValue
        }
    }
    
    init(userId: Int, token: String) {
        self._userId = userId
        self._token = token
    }
}
