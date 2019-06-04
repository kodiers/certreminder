//
//  CityImageView.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 04/06/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import UIKit

class CityImageView: UIImageView {
    /*
     Image view with city background
    */
    
    static let viewHeight: CGFloat = 200    // Usual height of this view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        // Setup ImageView
        self.image = UIImage(named: "city-bg.jpg")
        self.contentMode = .scaleAspectFill
        self.alpha = 1
        self.isOpaque = true
        self.clearsContextBeforeDrawing = true
        self.autoresizesSubviews = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
