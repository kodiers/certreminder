//
//  CertificationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 25/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class CertificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SetVendorsProtocol {

    @IBOutlet weak var certTableView: UITableView!
    @IBOutlet weak var newCertBtn: RoundedBorderButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var userCertifications = [UserCertification]()
    var vendors = [Vendor]()
    var choosedCert: UserCertification?
    var userCertificationService: UserCertificationServiceProtocol = UserCertificationService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        certTableView.delegate = self
        certTableView.dataSource = self
        certTableView.estimatedRowHeight = 100
        certTableView.rowHeight = UITableView.automaticDimension
        
        showSpinner(spinner: spinner)
        
        // Get user certification
        userCertificationService.getUserCertification(completionHandler: {(response, error) in
            self.hideSpinner(spinner: self.spinner)
            if error != nil {
                // Show alert
                AlertService.showCancelAlert(header: "HTTP Error", message: "Can't get certifications from server", viewController: self)
            } else {
                self.userCertifications = response as! [UserCertification]
                self.certTableView.reloadData()
            }
        })
        // Get vendors
        VendorService.instance.setVendorsToVar(header: "HTTP Error", message: "Can't get vendors from server", viewController: self, setVendors, AlertService.showCancelAlert)
        // Get certifications
        CertificationService.instance.downloadCertifications(vendor: nil, completionHandler: {(certifications, error) in
            if error != nil {
                AlertService.showCancelAlert(header: "HTTP Error", message: "Could not load certifications", viewController: self)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let userCert = userCertifications[indexPath.row]
            showSpinner(spinner: spinner)
            userCertificationService.deleteUserCertification(userCertId: userCert.id, completionHandler: {(response, error) in
                self.hideSpinner(spinner: self.spinner)
                if error != nil {
                    AlertService.showCancelAlert(header: "HTTP Error", message: "Can't delete certification from server", viewController: self)
                } else {
                    self.userCertifications.remove(at: indexPath.row)
                    self.certTableView.reloadData()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosedCert = userCertifications[indexPath.row]
        performSegue(withIdentifier: "CertificationDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CertificationDetailVC" {
            if let cert = choosedCert {
                if let destination = segue.destination as? CertificationDetailVC {
                    destination.userCerification = cert
                }
            }
        }
    }

    @IBAction func signOutBarItemTapped(_ sender: UIBarButtonItem) {
        UserService.instance.logoutUser()
        performSegue(withIdentifier: "GoToLoginVC", sender: nil)
    }
    
    @IBAction func aboutBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "MyCertAboutVC", sender: nil)
    }
    
    func setVendors(vendors: [Vendor]) {
        self.vendors = vendors
        self.certTableView.reloadData()
    }

}
