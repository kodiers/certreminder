//
//  RoundedBorderTextView.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 13/11/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedBorderTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

}
