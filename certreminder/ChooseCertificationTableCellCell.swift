//
//  ChooseCertificationTableCellCell.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 26/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ChooseCertificationTableCellCell: UITableViewCell {

    @IBOutlet weak var certLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    var certification: Certification!
    var choosed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(cert: Certification, isChoosed: Bool = false) {
        certification = cert
        choosed = isChoosed
        certLabel.text = certification.title
        if choosed {
            checkmarkImageView.isHidden = false
        }
    }

}
