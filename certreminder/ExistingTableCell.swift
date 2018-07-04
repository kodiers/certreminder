//
//  ExistingTableCell.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 29/06/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ExistingTableCell: UITableViewCell {

    @IBOutlet weak var examNumberLbl: UILabel!
    @IBOutlet weak var examTitleLbl: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    var exam: Exam!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(exam: Exam) {
        self.exam = exam
        if let number = exam.number {
            examNumberLbl.isHidden = false
            examNumberLbl.text = number
        } else {
            examNumberLbl.isHidden = true
            examNumberLbl.text = ""
        }
        examTitleLbl.text = exam.title
    }

}
