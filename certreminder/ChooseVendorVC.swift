//
//  ChooseVendorVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 24/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ChooseVendorVC: UIViewController, SetVendorsProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var vendorPicker: UIPickerView!
    
    var vendors: [Vendor] = [Vendor]()
    var choosedVendor: Vendor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vendorPicker.delegate = self
        vendorPicker.dataSource = self
        VendorService.instance.setVendorsToVar(header: "HTTP Error", message: "Can't get vendors from server", viewController: self, setVendors, AlertService.showCancelAlert)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vendors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosedVendor = vendors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let vendorTitle = vendors[row].title
        let attributedString = NSAttributedString(string: vendorTitle, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(red: 219.0 / 255.0, green: 223.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)]))
        return attributedString
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if choosedVendor == nil {
            self.vendorPicker.selectRow(0, inComponent: 0, animated: false)
            choosedVendor = vendors[0]
        }
        if let vendor = choosedVendor {
            if let destination = self.presentingViewController as? AddCertificationVC {
                destination.vendor = vendor
                destination.vendorLabel.text = vendor.title
                if let savedVendor = ChoosedDataService.instance.vendor {
                    if savedVendor.id != vendor.id {
                        destination.choosedCert = nil
                        destination.examsWithDate.removeAll()
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setVendors(vendors: [Vendor]) {
        self.vendors = vendors
        self.vendorPicker.reloadAllComponents()
        if let vendor = choosedVendor {
            if let vendorIndex = self.vendors.index(where: { $0.id == vendor.id }) {
                self.vendorPicker.selectRow(vendorIndex, inComponent: 0, animated: false)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
