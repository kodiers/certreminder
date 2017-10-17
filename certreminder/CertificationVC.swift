//
//  CertificationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 25/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class CertificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var certTableView: UITableView!
    
    var userCertifications = [UserCertification]()
    var vendors = [Vendor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        certTableView.delegate = self
        certTableView.dataSource = self
        
        // Get user certification
        WebRequestService.webservice.getUserCertification(completionHandler: {(response, error) in
            if error != nil {
                // Show alert
                self.showHttpAlert(message: "Can't get certifications from server")
            } else {
                self.userCertifications = response as! [UserCertification]
                self.certTableView.reloadData()
            }
        })
        WebRequestService.webservice.getVendors(completionHandler: {(response, error) in
            if error != nil {
                self.showHttpAlert(message: "Can't get vendors from server")
            } else {
                self.vendors = response as! [Vendor]
                self.certTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCertifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCert = userCertifications[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CertificationCell") as? CertificationCell {
            cell.configureCell(userCert: userCert, vendors: vendors)
            return cell
        }
        return CertificationCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let userCert = userCertifications[indexPath.row]
            WebRequestService.webservice.deleteUserCertification(userCertId: userCert.id, completionHandler: {(response, error) in
                if error != nil {
                    self.showHttpAlert(message: "Can't delete certification from server")
                } else {
                    self.userCertifications.remove(at: indexPath.row)
                    self.certTableView.reloadData()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CertificationDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CalendarCertificationVC" {
            if let destination = segue.destination as? CalendarCertfifcationVC {
//                if let items = sender as? [UserCertification] {
//                    print(items)
                destination.userCertifications = userCertifications
//                }
            }
        }
    }

    @IBAction func signOutBarItemTapped(_ sender: UIBarButtonItem) {
        WebRequestService.webservice.logoutUser()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func calendarBarItemTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "CalendarCertificationVC", sender: userCertifications)
    }
    
    @IBAction func newSertificationButtonPressed(_ sender: UIButton) {
    }
    
    func showHttpAlert(message: String) {
        let alert = UIAlertController(title: "HTTP Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
