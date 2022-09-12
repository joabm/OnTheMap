//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/5/22.
//

import MapKit
import UIKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properites
    
    var locationText = ""
    var urlText = ""
    var geoLocation: CLLocationCoordinate2D!
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func finishButton(_ sender: Any) {
        setIndicator(true)
        MapClient.getUsersPublicData(completion: handlePublicData(firstName:lastName:error:))
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIndicator(true)
        getCoordinates(addressString: locationText, completion: handleGeoLocationResponse(location:error:))
    }
    
    // MARK: Map Geolocation
    
    func getCoordinates(addressString: String, completion: @ escaping (CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationText) { (placemarks, error) in
            if error == nil {
                if let placemarks = placemarks?[0] {
                    if let location = (placemarks.location) {
                        self.geoLocation = location.coordinate
                        print("Latitude = \(self.geoLocation.latitude)")
                        print("Longitude = \(self.geoLocation.longitude)")
                        completion(location.coordinate, nil)
                    }
                }
            } else {
                completion(kCLLocationCoordinate2DInvalid, error as NSError?)
            }
        }
    }
    
    //handles error if the input location is invalid
    func handleGeoLocationResponse(location: CLLocationCoordinate2D, error: NSError?) {
        if error == nil {
            setIndicator(false)
            mapAnnotation()
        } else {
            setIndicator(false)
            self.showFailure(message: "The location may not exist.  Be sure to enter the City, State/Country format (example: New York, NY or London, England).")
        }
    }
        
    //set annotation for input location
    func mapAnnotation() {
        
        let latitude = CLLocationDegrees(geoLocation.latitude)
        let longitude = CLLocationDegrees(geoLocation.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = self.locationText
        annotation.subtitle = self.urlText

        mapView.addAnnotation(annotation)
        centerMapOnLocation(CLLocation(latitude: latitude, longitude: longitude), mapView: mapView)
        mapView.selectAnnotation(annotation, animated: true)
        
    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
            let regionRadius: CLLocationDistance = 5000
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func handlePublicData(firstName: String?, lastName: String?, error: Error?) {
        if error == nil {
            print(firstName!)
            print(lastName!)
            setIndicator(false)
            MapClient.postUsersLocation(firstName: firstName!, lastName: lastName!, latitude: Float(self.geoLocation.latitude), longitude: Float(geoLocation.longitude), mediaURL: self.urlText, mapString: self.locationText, completion: handlePostUsersResponse(success:error:))
        } else {
            setIndicator(false)
            showFailure(message: "The users public data could not be retrieved.  Try again")
        }
    }
    
    func handlePostUsersResponse(success: Bool, error: Error?) {
        if success {
            setIndicator(false)
            dismiss(animated: true, completion: nil)
        } else {
            setIndicator(false)
            showFailure(message: "It's not possible to save your location at this time")
        }
    }
    
    // MARK: setup and failure
    
    func setIndicator(_ isFinding: Bool) {
        if isFinding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Information Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
