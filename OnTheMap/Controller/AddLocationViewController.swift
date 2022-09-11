//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/5/22.
//

import MapKit
import UIKit

class AddLocationViewController: UIViewController {
    
    // MARK: Properites
    
    var locationText = ""
    var urlText = ""
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(locationText)
        print(urlText)
    }
    
}
