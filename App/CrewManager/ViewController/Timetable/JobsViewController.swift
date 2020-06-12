//
//  JobsViewController.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import SwiftMessages

//Job view controller
class JobsViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tblEmployee: UITableView! // tableview for listing
    @IBOutlet weak var lblNoDataFound: UILabel! // lbl no data found
    
    
    //MARK:-
    var jobRequests:[JobRequest] = [] // job request array of object
    var userProfile:UserProfile? // user profile instance
    
    
    
    //MARK:- View life Cyclic Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Time Table" // set titile label
        
        self.setupTableView() // setup table view
    }
    
    
    //MARK:- Private methods
    //Setup table view
    fileprivate func setupTableView() {
        //register nib to table view
        self.tblEmployee.register(UINib(nibName: R.Nibs.EmployeeCell, bundle: nil), forCellReuseIdentifier: R.CellIdentifiers.EmployeeCell)
        self.tblEmployee.delegate = self // set delegate
        self.tblEmployee.dataSource = self // set data source
        self.tblEmployee.tableFooterView = UIView() // set footer view
        self.getEmployeeJobsData() // get data from server
    }
        
    // get job data from firebase server
    fileprivate func getEmployeeJobsData() {
        //showloading activity
        self.showLoadingActivity()
        //get current employe jobs froms server
        ServicesManager.getCurrentEmployJobs(uid:self.userProfile!.uid , success: { (snapshot:DataSnapshot) in

            self.jobRequests.removeAll() // remove previous data
            self.tblEmployee.reloadData() // reload table view
            
            for child in snapshot.children.allObjects { // get all objects
                
                if let snap = child as? DataSnapshot { // cast the object
                    
                    if let values = snap.value  as? [String:Any] { // casting the values
                        if let type = values["type"] as? String ,  type == "job_request" { // filter the message only get job request msgz
                            
                            let mesg = JobRequest(fromDictionary: values) // make job request instance
                            self.jobRequests.append(mesg) //append the job request instace
                        }
                    }
                }
            }
            self.lblNoDataFound.isHidden = self.jobRequests.count != 0 // no data found label
            self.tblEmployee.reloadData() // reload table view
            self.hideLoadingActivity() // hide loading activity
        }) { (error:Error) in // error handler
            //show error messages
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            //hide loading activty
            self.hideLoadingActivity()
        }
    }
}


//MARK:- TableViewDataSource
extension JobsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { //number of section
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {// number of rows in section
        
        return self.jobRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//cell in table view
        
        let profile = self.jobRequests[indexPath.row] // get profile instace
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.CellIdentifiers.EmployeeCell,
                                                 for: indexPath) as! EmployeeTableViewCell
        cell.lblTitle1.text = "Job Title" // set title label
        cell.lblDetail1.text = profile.jobTitle // set job title
        
        cell.lblTitle2.text = "Job Location" // set label
        cell.lblDetail2.text = profile.jobLocation // set location
         
        cell.lblTitle3.text = "Hour" // set hour label
        cell.lblDetail3.text = profile.jobHour // set hour value

        cell.stackView4.isHidden = false // hide view
        cell.lblTitle4.text = "Client name" // set client label
        cell.lblDetail4.text = profile.clientName // set client name
        
        cell.removeSeparatorInsets() // remove seprator
        return cell
    }
}
//MARK:- TableViewDelegate
extension JobsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // selected row 
    }
}
