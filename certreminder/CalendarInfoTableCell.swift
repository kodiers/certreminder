//
//  CalendarInfoTableCell.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 06/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class CalendarInfoTableCell: UITableViewCell {

    @IBOutlet weak var certificationMessage: UILabel!
    @IBOutlet weak var certificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(userCert: UserCertification) {
        let certDate = userCert.expirationDateAsString()
        self.certificationMessage.text = "Your certification will expire at this date: \(certDate)"
        self.certificationLabel.text = userCert.certification.title
    }

}
