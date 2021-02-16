//
//  CustomButton.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/19/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    //MARK: - Initalizers
    
    init(title: String?) {
        super.init(frame: .zero)
        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - Helpers
    
    func configure(title: String?) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        layer.cornerRadius = 5
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
    }
}
