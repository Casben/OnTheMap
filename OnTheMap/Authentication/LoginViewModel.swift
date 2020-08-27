//
//  LoginViewModel.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/19/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
