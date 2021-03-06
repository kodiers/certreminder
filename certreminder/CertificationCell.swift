//
//  CertificationCell.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 03/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class CertificationCell: UITableViewCell {

    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var certificationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var userCert: UserCertification!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(userCert: UserCertification, vendors: [Vendor]) {
        self.userCert = userCert
        if let vendor = Vendor.getVendorById(id: userCert.certification.vendor, vendors: vendors) {
            vendorLabel.text = vendor.title
        } else {
            vendorLabel.text = ""
        }
        certificationLabel.text = userCert.certification.title
        dateLabel.text = userCert.expirationDateAsString()
        // Add custom detail button
        self.accessoryType = .disclosureIndicator
        let image = UIImage(named:"Shevron")?.withRenderingMode(.alwaysTemplate)
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:((image?.size.width)! / 2), height:((image?.size.height)! / 2)));
        checkmark.image = image
        self.accessoryView = checkmark
    }

}
