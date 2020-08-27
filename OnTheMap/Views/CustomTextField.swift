//
//  CustomTextField.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/18/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    //MARK: - Initalizers
    init(placholder: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        leftView = spacer
        spacer.setDimensions(height: 50, width: 12)
        attributedPlaceholder = NSAttributedString(string: placholder, attributes: [.foregroundColor: UIColor(white: 1.0, alpha: 0.7)])
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Configuration
    func configure() {
        
        leftViewMode = .always
        borderStyle = .none
        textColor = .systemBackground
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        setHeight(height: 50)
    }
}
