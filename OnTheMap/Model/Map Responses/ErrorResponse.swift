//
//  LoginErrorResponse.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/4/22.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int?
    let error: String?
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
