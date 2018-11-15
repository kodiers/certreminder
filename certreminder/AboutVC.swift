//
//  AboutVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 15/11/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit
import MessageUI

class AboutVC: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emailBtnPressed(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([APP_EMAIL])
            mailVC.setSubject("Question from Re:Minder")
            present(mailVC, animated: true, completion: nil)
        } else {
            AlertService.showCancelAlert(header: "Cannot open Mail app", message: "Mail app was not configured on your device.", viewController: self)
        }
    }
    
    @IBAction func siteBtnPressed(_ sender: Any) {
        if let url = URL(string: APP_SITE) {
            UIApplication.shared.open(url, options: [:]) { (result) in
                if !result {
                    AlertService.showCancelAlert(header: "Cannot redirect to site", message: "Cannot redirect you to our site", viewController: self)
                }
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
