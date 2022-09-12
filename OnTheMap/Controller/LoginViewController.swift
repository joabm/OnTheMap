//
//  ViewController.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/1/22.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupTextView: UITextView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //creating an attributed string for signing up
        let signUpString = NSMutableAttributedString(string: "Don't have an account?  Sign Up")
        let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com")!
        signUpString.setAttributes([.link: url], range: NSMakeRange(24, 7))
        
        signupTextView.attributedText = signUpString
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Login Actions
    
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
    
    // MARK: Keyboard controls
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        //removes both observers at once
        NotificationCenter.default.removeObserver(self)
    }
    
    //keeps the keyboard from covering the input field by removing the height of the keyboard from the views frame.
    @objc func keyboardWillShow(_ notification:Notification) {
        if emailTextField.isEditing && UIDevice.current.orientation.isLandscape || passwordTextField.isEditing && UIDevice.current.orientation.isLandscape {
            view.frame.origin.y = -100 //getKeyboardHeight(notification)
        }
    }
    
    //resets the frame height
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    //dismisses the keyboard when the return button is selected by the user
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Setup and failure
    
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

