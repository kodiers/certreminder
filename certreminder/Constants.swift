//
//  Constants.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 24/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

let KEY_UID = "id"
let NEW_OBJECT_ID = 0

let MIN_PASSWORD_LENGTH = 9

let APP_EMAIL = "support@techforline.com"
let APP_SITE = "http://reminder.techforline.com"
let APP_API_URL = "http://certapp.techforline.com"

let CUSTOM_ERROR_DOMAIN = "certapp.techforline.com"
let ERROR_CODE_EXAM_EXISTS = 200
let ERROR_CODE_LOGIN = 100
let ERROR_CODE_HTTP_ERROR = 10
let ERROR_UNKNOWN = 0

let MAIN_COLOR = #colorLiteral(red: 0.1098039216, green: 0.1921568627, blue: 0.2156862745, alpha: 1)
let YELLOW_COLOR = #colorLiteral(red: 0.8588235294, green: 0.8745098039, blue: 0.4470588235, alpha: 1)

typealias RequestComplete = (AnyObject?, NSError?) -> ()
