//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/5/22.
//

import UIKit

extension UIViewController {
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        MapClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
