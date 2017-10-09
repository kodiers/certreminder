//
//  CertificationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 25/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class CertificationVC: UIViewController {

    @IBOutlet weak var certTableView: UITableView!
    var userCertifications = [UserCertification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func signOutBarItemTapped(_ sender: UIBarButtonItem) {
        WebRequestService.webservice.logoutUser()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func calendarBarItemTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func newSertificationButtonPressed(_ sender: UIButton) {
    }
}
