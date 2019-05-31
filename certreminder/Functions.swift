//
//  Functions.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 18/05/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation

func isStringContainsOnlyNumbers(string: String) -> Bool {
    // Check that string contains only numbers
    return string.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) == nil
}

func validatePassword(username: String, password: String) -> Bool {
    /*
     Validate that password isn't same as username, less then MIN_PASSWORD_LENGTH and not contains only numbers
    */
    if password.count < MIN_PASSWORD_LENGTH {
        return false
    }
    if isStringContainsOnlyNumbers(string: password) {
        return false
    }
    if password.lowercased() == username.lowercased() {
        return false
    }
    return true
}

func validateEmail(str: String) -> Bool {
    /*
     Check that str is valid email address
    */
    let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*)@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    let matches = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
    return matches.evaluate(with: str)
}
