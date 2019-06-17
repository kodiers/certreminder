//
//  RestorePasswordView.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 07/06/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import UIKit

class RestorePasswordView: CommonScreenView {

    /*
    View for RestorePasswordVC
    */
    
    private(set) lazy var emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.autoresizesSubviews = true
        stackView.clearsContextBeforeDrawing = true
        stackView.preservesSuperviewLayoutMargins = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private(set) lazy var fieldLabel: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 16)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8235294118, green: 0.6745098039, blue: 0.8235294118, alpha: 1)]
        label.attributedText = NSAttributedString(string: "Email", attributes: attributes)
        label.textAlignment = .center
        label.preservesSuperviewLayoutMargins = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "enter your email"
        textField.textContentType = .emailAddress
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private(set) lazy var restoreButton: RoundedBorderButton = {
        let restoreBtn = RoundedBorderButton()
        restoreBtn.cornerRadius = CORNER_RADIUS
        restoreBtn.backgroundColor = YELLOW_COLOR
        restoreBtn.setupTitleLabel(with: "Restore email", color: MAIN_COLOR)
        restoreBtn.preservesSuperviewLayoutMargins = true
        restoreBtn.translatesAutoresizingMaskIntoConstraints = false
        return restoreBtn;
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 16)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8235294118, green: 0.6745098039, blue: 0.8235294118, alpha: 1)]
        label.attributedText = NSAttributedString(string: "Instructions for password recovery will be sent to your email", attributes: attributes)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.preservesSuperviewLayoutMargins = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var backButton: RoundedBorderButton = {
        let backButton = RoundedBorderButton()
        backButton.cornerRadius = CORNER_RADIUS
        backButton.backgroundColor = MAIN_COLOR
        backButton.borderColor = YELLOW_COLOR
        backButton.borderWidth = BORDER_WIDTH
        backButton.setupTitleLabel(with: "Back", color: YELLOW_COLOR)
        backButton.preservesSuperviewLayoutMargins = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    var delegate: RestorePasswordDelegate?
    
    override init(with title: String) {
        super.init(with: title)
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    private func configureView() {
        self.emailStackView.addArrangedSubview(fieldLabel)
        self.emailStackView.addArrangedSubview(emailField)
        self.addSubview(self.emailStackView)
        self.addSubview(self.restoreButton)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.backButton)
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.emailStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.emailStackView.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: DEFAULT_ELEMENT_SPACING),
            self.emailStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: TRAILING_MARGIN),
            self.emailStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: LEADING_MARGIN),
            
            self.restoreButton.heightAnchor.constraint(equalToConstant: 30),
            self.restoreButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: TRAILING_MARGIN),
            self.restoreButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: LEADING_MARGIN),
            self.restoreButton.topAnchor.constraint(equalTo: self.emailStackView.bottomAnchor, constant: 25),
            
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: TRAILING_MARGIN),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: LEADING_MARGIN),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.restoreButton.bottomAnchor, constant: 10),
            
            self.backButton.heightAnchor.constraint(equalToConstant: 30),
            self.backButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: TRAILING_MARGIN),
            self.backButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: LEADING_MARGIN),
            self.backButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: DEFAULT_ELEMENT_SPACING)
        ])
    }
    
    func addActions() {
        // Add actions to buttons
        guard let delegate = self.delegate else {
            return
        }
        self.restoreButton.addTarget(delegate, action: #selector(RestorePasswordVC.restorePasswordBtnPressed), for: .touchUpInside)
        self.backButton.addTarget(delegate, action: #selector(RestorePasswordVC.backBtnPressed), for: .touchUpInside)
    }

}
