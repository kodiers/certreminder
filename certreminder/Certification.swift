//
//  File.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 09/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

class Certification {
    private var _id: Int!
    private var _title: String!
    private var _vendor: Int!
    private var _number: String?
    private var _description: String?
    private var _image: String?
    private var _deprecated: Bool
    
    var id: Int {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var title: String {
        get {
            return _title
        }
        set {
            _title = newValue
        }
    }
    
    var vendor: Int {
        get {
            return _vendor
        }
        set {
            _vendor = newValue
        }
    }
    
    var number: String? {
        get {
            if _number == nil {
                return ""
            }
            return _number!
        }
        set {
            if newValue == nil {
                _number = ""
            } else {
                _number = newValue
            }
        }
    }
    
    var description: String? {
        get {
            if _description == nil {
                return ""
            }
            return _description!
        }
        set {
            if newValue == nil {
                _description = ""
            } else {
                _description = newValue
            }
        }
    }
    
    var image: String? {
        get {
            if _image == nil {
                return ""
            }
            return _image!
        }
        set {
            if newValue == nil {
                _image = ""
            } else {
                _image = newValue
            }
        }
    }
    
    var deprecated: Bool {
        get {
            return _deprecated
        }
        set {
            _deprecated = newValue
        }
    }
    
    init(id: Int, title: String, vendor: Int, deprectated: Bool = false) {
        _id = id
        _title = title
        _vendor = vendor
        _deprecated = deprectated
    }
}
