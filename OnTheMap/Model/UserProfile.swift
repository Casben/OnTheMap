//
//  UserProfile.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/22/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import Foundation
struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
 
}
