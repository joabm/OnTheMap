//
//  DropPinRequest.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/1/22.
//

import Foundation

struct PostUsersLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}
