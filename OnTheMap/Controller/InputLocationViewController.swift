//
//  InputLocationViewController.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/5/22.
//

import Foundation
import UIKit

class InputLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.text = ""
        urlTextField.text = ""
    }
    
    
    
    
    @IBAction func findLocationTapped(_ sender: Any) {
        setIndicator(true)
        if (locationTextField.text == "" || urlTextField.text == "") {
            setIndicator(false)
            showFailure(message: "Please enter a location and a URL to share")
        }
        setIndicator(false)
    }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setIndicator(_ isFinding: Bool) {
        if isFinding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Hi!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
