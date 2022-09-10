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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    

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
        setLoggingIn(true)
        MapClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginRespone(success:error:))
    }
    
    func handleLoginRespone(success: Bool, error: Error?) {
        if success {
            setLoggingIn(false)
            debugPrint(MapClient.Auth.uniqueKey)
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
        setLoggingIn(false)
    }
    
}

