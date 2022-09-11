//
//  UsersPublicDataResponse.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/11/22.
//

import Foundation

struct UsersPublicDataResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
