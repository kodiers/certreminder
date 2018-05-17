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
