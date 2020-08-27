//
//  CustomLabel.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/19/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    
    //MARK: - Initalizers
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        configure(fontSize: fontSize)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - Configuration
    func configure(fontSize: CGFloat) {
        textAlignment = .center
        font = .boldSystemFont(ofSize: fontSize)
    }
    
}
