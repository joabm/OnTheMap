//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/6/22.
//

import Foundation
import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentURL: UILabel!
}

class StudentListViewController: UITableViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentDataModel.studentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInfoCell") as! StudentTableViewCell
        cell.studentName?.text = StudentDataModel.studentList[indexPath.row].firstName + " " + StudentDataModel.studentList[indexPath.row].lastName
        cell.studentURL?.text = StudentDataModel.studentList[indexPath.row].mediaURL
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = StudentDataModel.studentList[indexPath.row]
        let url = selectedCell.mediaURL
        
        UIApplication.shared.open(URL(string: url)!, completionHandler: nil)
    }
    
}
