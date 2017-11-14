//
//  AddCertificationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 17/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class AddCertificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var certificationLabel: UILabel!
    @IBOutlet weak var examsTableView: UITableView!
    
    private let formatter = DateFormatter()
    var certificationExpireDateStr: String?
    var vendor: Vendor?
    var choosedCert: Certification?
    var examsWithDate = [(Exam, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        examsTableView.delegate = self
        examsTableView.dataSource = self
        
        if certificationExpireDateStr == nil {
            dateLabel.text = "Choose date"
        }
        if vendor == nil {
            vendorLabel.text = "Choose vendor"
        }
        if choosedCert == nil {
            certificationLabel.text = "Choose certification"
        }
        examsTableView.reloadData()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examsWithDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let examWithDate = examsWithDate[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosedExamsWithDateTableViewCell") as? ChoosedExamsWithDateTableViewCell {
            print(examWithDate)
            cell.configureCell(exam: examWithDate.0, dateStr: examWithDate.1)
            return cell
        }
        return ChoosedExamsWithDateTableViewCell()
    }
    
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
        if segue.identifier == "AddExamsVC" {
            if let destination = segue.destination as? AddExamsVC {
                if let cert = choosedCert {
                    destination.certification = cert
                } else {
                    AlertService.showCancelAlert(header: "Certification not choosed", message: "You should select certification before", viewController: self)
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
        if choosedCert != nil {
            performSegue(withIdentifier: "AddExamsVC", sender: self)
        } else {
            AlertService.showCancelAlert(header: "Certification not choosed", message: "You should select certification before", viewController: self)
        }
    }
    
    @IBAction func chooseCertificationBtnPressed(_ sender: Any) {
        if vendor != nil {
            performSegue(withIdentifier: "ChooseCertificationVC", sender: self)
        } else {
            AlertService.showCancelAlert(header: "Vendor not choosed", message: "You should select vendor before", viewController: self)
        }
    }
}
