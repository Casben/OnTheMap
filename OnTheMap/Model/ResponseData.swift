//
//  ResponseManager.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/22/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import Foundation


 
struct ResposneData: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
