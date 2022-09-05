//
//  ViewController.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/1/22.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupTextView: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = ""
        passwordTextField.text = ""
        
        let signUpString = NSMutableAttributedString(string: "Don't have an account?  Sign Up")
        let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com")!
        signUpString.setAttributes([.link: url], range: NSMakeRange(24, 7))
        
        signupTextView.attributedText = signUpString
        
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
    }
    
    
}

