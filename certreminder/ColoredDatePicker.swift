//
//  ColoredDatePicker.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 31/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ColoredDatePicker: UIDatePicker {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Change text color
        super.setValue(UIColor(red: 219.0 / 255.0, green: 223.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), forKey: "textColor")
    }
}
