//
//  RaiseErrorProtocol.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 07/03/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation

class RaiseErrorMixin {
    /*
     Mixin to implement method to raise error
     */
    func raiseError(errorCode: Int, message: String) -> NSError {
        let error = NSError(domain: CUSTOM_ERROR_DOMAIN, code: errorCode, userInfo: [NSLocalizedDescriptionKey: message])
        return error
    }
}
