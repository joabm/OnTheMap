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
        return StudentDataModel.studentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInfoCell", for: indexPath) as! StudentTableViewCell
        let student = StudentDataModel.studentList[indexPath.row]
        cell.studentName.text = student.firstName + " " + student.lastName
        cell.studentURL.text = student.mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = StudentDataModel.studentList[indexPath.row]
        let studentName = selectedCell.firstName
        let url = selectedCell.mediaURL
        if url.isValidURL {
            UIApplication.shared.open(URL(string: url)!, completionHandler: nil)
        } else {
            let message = studentName + " did not share a valid URL"
            showFailure(message: message)
        }
    }
    
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
