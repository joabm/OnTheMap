//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/1/22.
//

import Foundation


//udaciy dictionary containing two strings. One for username and the other password
struct LoginRequest: Codable {
    let udacity: [String:String]
}
