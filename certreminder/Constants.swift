//
//  Constants.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 24/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation

let KEY_UID = "id"
let NEW_OBJECT_ID = 0

let MIN_PASSWORD_LENGTH = 9

let APP_EMAIL = "support@techforline.com"
let APP_SITE = "http://reminder.techforline.com"
let APP_API_URL = "http://api-reminder.techforline.com"

let CUSTOM_ERROR_DOMAIN = "api-reminder.techforline.com"
let ERROR_CODE_EXAM_EXISTS = 200
let ERROR_CODE_LOGIN = 100
let ERROR_CODE_HTTP_ERROR = 10
let ERROR_UNKNOWN = 0

typealias RequestComplete = (AnyObject?, NSError?) -> ()
