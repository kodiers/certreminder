//
//  ChooseCertificationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 24/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ChooseCertificationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var certifications = [Certification]()
    var choosedCert: Certification?
    var vendor: Vendor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        if let certs = CertificationService.instance.certifications {
            setCertifications(certifications: certs)
        } else {
            CertificationService.instance.downloadCertifications(vendor: vendor, completionHandler: {(certifications, error) in
                if error != nil {
                    AlertService.showCancelAlert(header: "HTTP Error", message: "Cannot get certifications from server", viewController: self)
                } else {
                    self.setCertifications(certifications: certifications!)
                }
            })
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: implement method
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: implement method
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: implement method
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: implement method
    }

    @IBAction func newCertBtnPressed(_ sender: Any) {
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
    }
    
    func setCertifications(certifications: [Certification]) {
        self.certifications = certifications
        self.tableView.reloadData()
    }
}
