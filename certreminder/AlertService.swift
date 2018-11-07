//
//  AlertService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 20/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit


class AlertService {
    static func showCancelAlert(header: String, message: String, viewController: UIViewController) {
        // Show alert message on view controller
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showDeleteAlert(header: String, message: String, viewController: UIViewController, handler: @escaping (UIAlertAction) -> ()) {
        // Show delete alert message on view controller and do deletion
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showSuccessAlert(title: String, message: String, viewController: UIViewController) {
        // Show success alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let successAction = UIAlertAction(title: "OK!", style: .default, handler: {(UIAlertAction) in
            viewController.dismiss(animated: true, completion: nil)
        })
        alert.addAction(successAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
