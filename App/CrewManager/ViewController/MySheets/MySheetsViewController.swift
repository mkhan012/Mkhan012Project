//
//  MySheetsViewController.swift
//  CrewManager
//
//  Created by Muhammad Khan
// 
//

import UIKit
import Firebase
import SwiftMessages


class MySheetsViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tblJobs: UITableView! //table view reference for show listing
    @IBOutlet weak var lblNoFataFound: UILabel! // no data found label referce
    
    var myJobs:[JobRequest] = [] // show and add my jobs listing
    
    //MARK:- view life cyclic methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Show tilte
        self.title = "My Sheets"
        
        //setup tableview
        self.setupTableView()
    }
    
    
    //MARK:- Private methods
    fileprivate func setupTableView() {
        //Register tableview cell nib in tableview
        self.tblJobs.register(UINib(nibName: R.Nibs.EmployeeCell, bundle: nil), forCellReuseIdentifier: R.CellIdentifiers.EmployeeCell)
        
        //set delegte for tableview
        self.tblJobs.delegate = self
        //set datasouece for table view
        self.tblJobs.dataSource = self
        //remvoe footer in table we dont need to show in table view
        self.tblJobs.tableFooterView = UIView()
        //call api method to get my sheets data
        self.getMySheetData()
    }
    
    //MARK:- API Methods
    //function is used for get data of employee sheet from firebase server
    fileprivate func getMySheetData() {
        // show loading activity to stop user interference
        self.showLoadingActivity()
        // get informaiton of employee job with call back methods (success and failure)
        ServicesManager.getEmployJobs(success: { (snapshot:DataSnapshot) in
            
            self.myJobs.removeAll() // remove all previos jobs
            self.tblJobs.reloadData() // reload tabelview get load new data in table view
            
            
            // loop over all the objects to filter required data.
            for child in snapshot.children.allObjects {
                
                if let snap = child as? DataSnapshot {
                    
                    if let values = snap.value  as? [String:Any] { // values casting in required format
                        if let type = values["type"] as? String ,  type == "job_request" { // filter job request data
                            
                            let mesg = JobRequest(fromDictionary: values) // make Jobrequest object
                            self.myJobs.append(mesg) // append new object
                        }
                    }
                }
            }
            
            self.lblNoFataFound.isHidden = self.myJobs.count != 0  // show and hide no data found label
            self.tblJobs.reloadData() // reload table view
            self.hideLoadingActivity() // hide loading activiety
        }) { (error:Error) in // Error call bacl
            SwiftMessages.showToast(error.localizedDescription, type: .error) // show error
            self.hideLoadingActivity() // hide loading activity
        }
    }
}


//MARK:- TableViewDataSource
extension MySheetsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { //table data source methods show number of section in tableview
        return  1
    }
    
    //table view datasouece methd to show number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.myJobs.count //return number of my jobs to number of cell
    }
    
    // setup table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let job = self.myJobs[indexPath.row] // get required job objct
        let cell = tableView.dequeueReusableCell(withIdentifier: R.CellIdentifiers.EmployeeCell,
                                                 for: indexPath) as! EmployeeTableViewCell
        cell.lblTitle1.text = "Job Title" //tile
        cell.lblDetail1.text = job.jobTitle // job tile
        
        cell.lblTitle2.text = "Job Date Time" // job date and time title
        //show job date and time values
        cell.lblDetail2.text = DateHelper.dateStringFromString(job.jobDateTime, inputDateFormat: K.ServerDateTimeFormat, outputDateFormat: K.ClientDateTimeFormat)
        
        cell.lblTitle3.text = "Hour " // show title of number of hours
        cell.lblDetail3.text = job.jobHour + " hours" // set number of hours

        cell.stackView4.isHidden = false // hide extra view
        cell.lblTitle4.text = "Client name " // shows client name
        cell.lblDetail4.text = job.clientName // shows client name values
        
        cell.removeSeparatorInsets() // remove seprator insects to show visible seprtor line
        return cell
    }
}

// current no need these table view delegate methods 
//MARK:- TableViewDelegate
extension MySheetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

