//
//  LoginButton.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/1/22.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.primaryDark
    }
    
}
