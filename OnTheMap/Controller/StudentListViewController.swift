//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/6/22.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentURL: UILabel!
}

class StudentListViewController: UITableViewController {
    
    var studentLocations: [StudentData] { return
        StudentDataModel.studentList
    }

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocationList()
        
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        refreshButton.isEnabled = false
        getStudentLocationList()
    }
    
    func getStudentLocationList () {
        MapClient.getStudentLocations(completion: handleStudentLocationListResponse(locations:error:))
    }
    
    func handleStudentLocationListResponse(locations: [StudentData], error: Error?) {
        refreshButton.isEnabled = true
        if error == nil {
            StudentDataModel.studentList = locations
            print(locations)
            tableView.reloadData()
        } else {
            print(error as Any)
            showFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Hi!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInfoCell", for: indexPath) as! StudentTableViewCell
        let student = studentLocations[indexPath.row]
        cell.studentName.text = student.firstName + " " + student.lastName
        cell.studentURL.text = student.mediaURL
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = studentLocations[indexPath.row]
        let studentName = selectedCell.firstName
        if selectedCell.mediaURL.isEmpty {
            let message = studentName + " did not share a URL"
            showFailure(message: message)
        } else {
            let url = selectedCell.mediaURL
            UIApplication.shared.open(URL(string: url)!, completionHandler: nil)
        }
    }
    
    
}

