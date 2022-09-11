//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/1/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    
    @IBAction func refreshButton(_ sender: Any) {
        refreshButton.isEnabled = false
        getStudentLocations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocations()
    }
    
    func mapAnnotations(_ locations: [StudentData]) {

        var annotations = [MKPointAnnotation]()

        for dictionary in locations {

            // Notice that the float values are being used to create CLLocationDegree values.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)

            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL

            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }

        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            let toOpen = view.annotation?.subtitle! ?? "noURL"
            let url = URL(string: toOpen)
            if let url = url {
                app.open(url)
            } else {
                showFailure(message: "A valid URL was not provided")
            }
        }
    }
    
    // MARK: Get Student data
    
    func getStudentLocations () {
        MapClient.getStudentLocations(completion: handleStudentLocationListResponse(locations:error:))
    }

    func handleStudentLocationListResponse(locations: [StudentData], error: Error?) {
        refreshButton.isEnabled = true
        if error == nil {
//            if mapView.annotations.count > 0 {
//                mapView.removeAnnotation(mapView.annotations as! MKAnnotation)
//            }
            //StudentDataModel.studentList = locations
            mapAnnotations(locations)
        } else {
            print(error as Any)
            showFailure(message: error?.localizedDescription ?? "")
        }
    }

    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Student info error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
