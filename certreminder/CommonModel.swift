//
//  CommonModel.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 13/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

class CommonModel {
    /*
     Common model for classes with common fields
     */
    private var _id: Int!
    private var _title: String!
    private var _description: String?
    private var _image: String?
    
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
    
    init(id: Int, title: String) {
        _id = id
        _title = title
    }
}
