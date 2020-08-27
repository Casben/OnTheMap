//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/18/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import Foundation


struct StudentInformation : Codable {
    let createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    let mapString : String?
    let mediaURL : String?
    let objectId : String?
    let uniqueKey : String?
    let updatedAt : String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        case objectId
        case uniqueKey
        case updatedAt
    }
}

