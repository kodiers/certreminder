//
//  AlertService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 20/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit


class AlertService {
    static func showHttpAlert(header: String, message: String, viewController: UIViewController) {
        // Show alert message on view controller
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
