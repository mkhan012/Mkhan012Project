//
//  EmployeeViewController.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import SwiftMessages


class EmployeeViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var tblEmployee: UITableView!// for add employee listing
    @IBOutlet weak var btnAddEmplyee: UIButton! // for add button
    @IBOutlet weak var lblNoDataFound: UILabel! // label for not found data
    
    
    var employeeProfiles:[UserProfile] = [] // profile data
    var jobRequests:[JobRequest] = []       // jobrequests data
    var employeeData:[[String : Any]] = []  // employeedata
    var isTimeSheets:Bool = false
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.btnAddEmplyee.isHidden = true // hide the add employee button
        
        if self.isTimeSheets { // check time sheet flow
            
            self.title = "Time Sheet"
        }else {
            
            self.title = "Crew"
        }
        
        self.getEmployeeList()
        self.setupTableView()
    } // function for check view

    
    //MARK:- Private methods
    fileprivate func setupTableView() {
        
        self.tblEmployee.register(UINib(nibName: R.Nibs.EmployeeCell, bundle: nil), forCellReuseIdentifier: R.CellIdentifiers.EmployeeCell)
        
        self.tblEmployee.delegate = self
        self.tblEmployee.dataSource = self
        
        self.tblEmployee.tableFooterView = UIView()
    }
    // function for getting employee list
    fileprivate func getEmployeeList() {
        
        self.showLoadingActivity() // show loading activities
        self.tblEmployee.reloadData() // load employee data
        
        //get all employee list from firebase server with DataSnapshot
        ServicesManager.getAllEmployeeList(success: { (snapshot:DataSnapshot) in
            
            self.employeeProfiles.removeAll() //remove previous employee list
            self.tblEmployee.reloadData() // reload table view
            
            for child in snapshot.children.allObjects { // get list of children
                
                if let snap = child as? DataSnapshot { // type casting of object
                    
                    if let values = snap.value  as? [String:Any] { // check type casting
                        
                        if let profileDic = values["profile"] as? [String:Any] { // get profile object
                         
                            let profile = UserProfile(fromDictionary: profileDic) // initlize the user profile
                            profile.uid = snap.key // set user id in profile object
                            self.employeeProfiles.append(profile) // append the user profile object on employeeProfiles
                        }
                    }
                    
                }
            }
            
                        
            self.tblEmployee.reloadData() // reload tabele view
            self.hideLoadingActivity() // hide loading activity
            
        }) { (error:Error) in //  error hanlder
//            show error
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            // hide loading activity
            self.hideLoadingActivity()
        }
    }
}


//MARK:- TableViewDataSource
extension EmployeeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { // number of section in table view
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //number of rows in a section
        
        return self.employeeProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // compose tableview cell
        
        let profile = self.employeeProfiles[indexPath.row] //get profile object
        let cell = tableView.dequeueReusableCell(withIdentifier: R.CellIdentifiers.EmployeeCell,
                                                 for: indexPath) as! EmployeeTableViewCell
        cell.lblTitle1.text = "Crew Name" // set employee name label
        cell.lblDetail1.text = profile.fname + " " + profile.lname // set user name
        
        cell.stackView2.isHidden = true // hide extra views
        
        cell.lblTitle3.text = "address" // set address label
        cell.lblDetail3.text = profile.address // set address
        
        cell.removeSeparatorInsets() // remove insects
        return cell
    }
} // table view data of employee
//MARK:- TableViewDelegate
extension EmployeeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get profile object
        let profile = self.employeeProfiles[indexPath.row]
        //  timesheet flow variable
        if self.isTimeSheets {
            // get view controller from storyboard with identifer
            if let jobVC = R.StoryboardRef.Main.instantiateViewController(identifier: R.ViewControllerIds.JobsVC) as?JobsViewController  {
                jobVC.userProfile = profile
                self.push(jobVC)
            }
        } else {
            //get view contrller from story board with identifier
            let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.DetailEmployeeVC) as!DetailEmployeeViewController
            vc.profileData = profile
            self.push(vc)
        }
    }
}

