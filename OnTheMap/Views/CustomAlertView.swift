//
//  CustomAlertView.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/19/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit

class CustomAlertView: UIView {
    
    //MARK: - Initalizers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configure() {
        backgroundColor       = .systemBackground
        layer.cornerRadius    = 16
        layer.borderWidth     = 2
        layer.borderColor     = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
