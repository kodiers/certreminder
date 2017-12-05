//
//  CertificationDetailVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 17/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class CertificationDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var certificationTitleLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var examTableView: UITableView!
    
    private var formatter = DateFormatter()
    
    var userCerification: UserCertification!
    var vendor: Vendor?
    var usersExams = [UserExam]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        examTableView.delegate = self
        examTableView.dataSource = self
        certificationTitleLabel.text = userCerification.certification.title
        if let vendors = VendorService.instance.vendors {
            vendor = Vendor.getVendorById(id: userCerification.certification.vendor, vendors: vendors)
            if let ven = vendor {
                vendorLabel.text = ven.title
            } else {
                vendorLabel.text = "N/A"
                AlertService.showCancelAlert(header: "Vendor not found", message: "Vendor not found in database", viewController: self)
            }
        } else {
            vendorLabel.text = "N/A"
            AlertService.showCancelAlert(header: "Vendor not found", message: "Vendor not found in database", viewController: self)
        }
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let dateStr = formatter.string(from: userCerification.expirationDate)
        dateLabel.text = dateStr
        WebRequestService.webservice.getUserExamsForCertification(certification: userCerification, completionHandler: {(exams, error) in
            if error != nil {
                AlertService.showCancelAlert(header: "HTTP Error", message: "Could not download user's exams", viewController: self)
            } else {
                self.usersExams = exams as! [UserExam]
                self.examTableView.reloadData()
            }
        })
        
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
        return usersExams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userExam = usersExams[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosedExamsWithDateTableViewCellDetail") as? ChoosedExamsWithDateTableViewCell {
            cell.configureCell(exam: userExam.exam, date: userExam.dateOfPass)
            return cell
        }
        return ChoosedExamsWithDateTableViewCell()
    }
    
    @IBAction func addExamButtonPressed(_ sender: Any) {
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
}
