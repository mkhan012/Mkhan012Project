//
//  AddJobMessagesViewController.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import SwiftMessages
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseUI


class AddJobMessagesViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var btnSendJobRequest : UIButton!// sent message button
    @IBOutlet weak var pickerEmployee : JMStringPicker! // picker employee
    @IBOutlet weak var txtJobNumber : JMTextField! // txt field for get job title
    @IBOutlet weak var txtJobLocation : JMTextField! // text field get job location
    @IBOutlet weak var txtPayRate : JMTextField! // text field get pay rate
    @IBOutlet weak var pickerDateTime : JMDatePicker!
    @IBOutlet weak var txtHours : JMTextField!
    @IBOutlet weak var txtClientName : JMTextField!
    @IBOutlet weak var txtClientContactNumber : JMTextField!
    
    
    
    //MARK:- Variable
    var employeeList:[[String:UserProfile]] = []
            
    var requestDetail : JobRequest? //job request detail
    //Job request model
    var jobReques : JobRequest? {
        get {
            let job = JobRequest() // job request instance
            job.status = K.PendingKey // job request status key
            job.on = DateHelper.stringFromDate(Date()) // job request sent date and time
            job.type = K.messageTypeJobRequest // job request type
            job.mangerName = CurrentUser.sharedInstance.fullName // manager full name
            job.employeeName = self.pickerEmployee.selectedTitle // employee full name
            job.employeeUID = self.pickerEmployee.selectedId // employee id
            job.managerUID = ServicesManager.uid! // manager id
            job.jobTitle = self.txtJobNumber.text // job number
            job.jobLocation = self.txtJobLocation.text // get job location
            job.jobHour = self.txtHours.text // get number of hours
            job.clientName = self.txtClientName.text // get client name
            job.clientContantNumber = self.txtClientContactNumber.text // get client contact number
            job.payRate = self.txtPayRate.text // get pay rate
            job.jobDateTime = self.pickerDateTime.dateStringForBackend // get job date and time
            return job
        }
    }
    
    
    //MARK: -View life cyclic methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //send job request title
        self.title = "Send Job Request"
        self.getEmployeeList() // get all employee list
        
        // set picker date and time
        self.pickerDateTime.pickerType = .dateAndTime // set date and time picker type
        self.pickerDateTime.date = Date() // set current date and time
    }

    
    //MARK:- Fileprivate methods
    // load request detial for modification
    fileprivate func loadRequestDetail() {
        // check null poniter error
        if let newvalue = self.requestDetail { // request detial
            self.txtJobLocation.text = newvalue.jobLocation // get job location
            self.txtHours.text = newvalue.jobHour // get job hour
            self.txtClientName.text = newvalue.clientName // get client name
            self.txtClientContactNumber.text = newvalue.clientContantNumber // get client contact number
            self.txtJobNumber.text = newvalue.jobNumber // get job number
            self.pickerEmployee.selectedData = self.pickerEmployee.data.filter({($0.id == newvalue.employeeUID)}) //get job date
            
            /*make below views disable not edit able */
            self.txtJobLocation.isEnable = false //disable job location
            self.txtHours.isEnable = false // disable hours field
            self.txtClientName.isEnable = false // disable client name field
            self.txtClientContactNumber.isEnable = false //disable contact number field
            self.txtJobNumber.isEnable = false //disable job number field
            self.pickerEmployee.isEnable = false // disalbe employee picker field
            
            self.btnSendJobRequest.isHidden = true // sent job request button hidden
        }
        
    }
    
    //get all employee list
    fileprivate func getEmployeeList() {
        //show loading activity
        self.showLoadingActivity()
        //get all employee list with sucess handler and failure handler
        ServicesManager.getAllEmployeeList(success: { (snapshot:DataSnapshot) in
            //remove all previous employee list
            self.employeeList.removeAll()
            // get all child data objects
            for child in snapshot.children.allObjects {
                
                if let snap = child as? DataSnapshot {
                    
                    if let values = snap.value  as? [String:Any] { //casting the variables
                        
                        if let profile = values["profile"] as? [String:Any] { // get profile object
                            
                            let profile = UserProfile(fromDictionary: profile) // make user profile object
                            let dic = [snap.key:profile] // make dictionary object
                            self.employeeList.append(dic) // append employee object
                        }
                    }
                }
            }
            // load request dtail in view
            self.loadRequestDetail()
            // load data in picker view
            self.loadDataInPickerView()
            //hide loading activity
            self.hideLoadingActivity()
        }) { (error:Error) in // show error handler
            // show error message
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            // hide loading activity
            self.hideLoadingActivity()
        }
    }
    //load data in picker view
    fileprivate func loadDataInPickerView() {
        var employeeList:[JMGeneralModel] = [] // make  emplyee list
        
        //loop the employee list
        for snap in self.employeeList {
            //filter the object
            if let profile = snap.values.first {
                
                var profileTile = ""
                // set first name
                if let fname = profile.fname {
                    profileTile = fname
                }
                // set last name
                if let lname = profile.lname {
                    
                    if profileTile.count > 0 {
                        profileTile += " "
                    }
                    profileTile += lname
                }
                //make model
                let model = JMGeneralModel(title: profileTile , id: snap.keys.first)
                employeeList.append(model) // append the new objects in the array
            }
        }

        // assign the data to employeer picker
        self.pickerEmployee.data = employeeList
    }
    
    // MARK: - IBAction
    @IBAction func sendJobRequestBtnClicked(_ sender: UIButton) {
        
        // check validation
        if self.isViewDataValid() {
            //show loading activty
            self.showLoadingActivity()
            //sent meesage to emmply with sucess and fallure calll back methods
            ServicesManager.sentMessageToEmployee(senderId:ServicesManager.uid! ,reciverID:self.pickerEmployee.selectedId,userObject: self.jobReques!.toDictionary() , success: { (reference:DatabaseReference) in
                // show error
                SwiftMessages.showToast("Job request sent successfully.", type: .success)
                //hide loading activity
                self.hideLoadingActivity()
                self.pop()// pop the view
            }) { (error:Error) in // error handler
                //shwo error message
                SwiftMessages.showToast(error.localizedDescription, type: .error)
                //hide loading activity
                self.hideLoadingActivity()
            }
        }
    }
    
    
    //MARK:- Validations
    func isViewDataValid() -> Bool {
        
        if self.txtJobNumber.text.count <= 0  {
            SwiftMessages.showToast("Job Number is missing. Please provide and try again.")
            return false
        }
        if self.txtJobLocation.text.count <= 0 {
            SwiftMessages.showToast("Job Location is missing. Please provide and try again.")
            return false
        }
        if self.txtHours.text.count <= 0  {
            SwiftMessages.showToast("Job Hour's is missing. Please provide and try again")
            return false
        }
        if self.txtClientName.text.count <= 0  {
            SwiftMessages.showToast("Client Name is missing. Please provide and try again")
            return false
        }
        if self.txtClientContactNumber.text.count <= 0  {
            SwiftMessages.showToast("Client Contact number is missing. Please provide and try again")
            return false
        }
        if self.txtPayRate.text.count <= 0  {
            SwiftMessages.showToast("Pay Rate is missing. Please provide and try again")
            return false
        }
        return true
    }
}
