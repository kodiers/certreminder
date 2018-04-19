//
//  checkFieldExtension.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 28/02/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit

extension UIViewController {
    func checkField(field: UITextField, header: String, message: String) -> String? {
        // Check that field not blank and not equal empty string
        guard let txt = field.text, txt != "" else {
            AlertService.showCancelAlert(header: header, message: message, viewController: self)
            return nil
        }
        return txt
    }
    
    func showSpinner(spinner: UIActivityIndicatorView) {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func hideSpinner(spinner: UIActivityIndicatorView) {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
}
