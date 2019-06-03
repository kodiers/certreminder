//
//  RestorePasswordVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 04/06/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import UIKit

class RestorePasswordVC: UIViewController {
    
    /*
     Restore password ViewController
    */
    
    private(set) lazy var cityImageView: CityImageView = {
        let yCoordinate = self.view.frame.height - CityImageView.viewHeight
        let frame = CGRect(x: 0, y: yCoordinate, width: self.view.frame.width, height: CityImageView.viewHeight)
        return CityImageView(frame: frame)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureView()
        self.addSubviews()
        self.setupConstraints()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func configureView() {
        // Appearance customization
        self.view.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1921568627, blue: 0.2156862745, alpha: 1)
    }
    
    private func addSubviews() {
        view.addSubview(self.cityImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.cityImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.cityImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.cityImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.cityImageView.heightAnchor.constraint(equalToConstant: CityImageView.viewHeight)
        ])
    }

}
