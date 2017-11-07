//
//  AddCertificationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 17/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class AddCertificationVC: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var certificationLabel: UILabel!
    @IBOutlet weak var examsTableView: UITableView!
    
    private let formatter = DateFormatter()
    var certificationExpireDateStr: String?
    var vendor: Vendor?
    var choosedCert: Certification?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if certificationExpireDateStr == nil {
            dateLabel.text = "Choose date"
        }
        if vendor == nil {
            vendorLabel.text = "Choose vendor"
        }
        if choosedCert == nil {
            certificationLabel.text = "Choose certification"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseDateVC" {
            if let destination = segue.destination as? ChooseDateVC {
                if let certDateStr = certificationExpireDateStr {
                    formatter.dateFormat = "dd.MM.yyyy"
                    formatter.timeZone = Calendar.current.timeZone
                    formatter.locale = Calendar.current.locale
                    let certDate = formatter.date(from: certDateStr)
                    destination.choosedDate = certDate
                }
            }
        }
        if segue.identifier == "ChooseVendorVC" {
            if let destination = segue.destination as? ChooseVendorVC {
                if let vendor = vendor {
                    destination.choosedVendor = vendor
                }
            }
        }
        if segue.identifier == "ChooseCertificationVC" {
            if let destination = segue.destination as? ChooseCertificationVC {
                if let vendor = vendor {
                    destination.vendor = vendor
                }
                if let cert = choosedCert {
                    destination.choosedCert = cert
                }
            }
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
    }
    
    @IBAction func addExamBtnPressed(_ sender: Any) {
    }
    
    @IBAction func chooseCertificationBtnPressed(_ sender: Any) {
        if vendor != nil {
            performSegue(withIdentifier: "ChooseCertificationVC", sender: self)
        } else {
            AlertService.showCancelAlert(header: "Vendor not choosed", message: "You should select vendor before", viewController: self)
        }
    }
}
