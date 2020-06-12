//
//  ViewJobRequestViewController.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import SwiftMessages

// view job request
class ViewJobRequestViewController: UIViewController {

    //MARK:-IBOutlet
    @IBOutlet weak var lblSenderInfo: UILabel! //to show sender info
    @IBOutlet weak var lblMsg: UILabel! // to show message
    @IBOutlet weak var txtJobNumber : JMTextField! // gets job number or job title
    @IBOutlet weak var txtJobLocation : JMTextField! // gets job location
    @IBOutlet weak var txtHours : JMTextField! // gets job hours
    @IBOutlet weak var txtClientName : JMTextField! // gets client name
    @IBOutlet weak var txtClientContactNumber : JMTextField! //get client contact numebr
    @IBOutlet weak var btnSentMessage : UIButton! // send message button
    @IBOutlet weak var btnReject : UIButton! // reject message button
    @IBOutlet weak var btnAccept : UIButton! // accpeted message button
    @IBOutlet weak var txtPayRate : JMTextField! // get payrate on hours base
    @IBOutlet weak var pickerDateTime : JMDatePicker! // get job time
    
    
    //MARK:- Variable
    var jobDetail :JobRequest! // get job request detail
    var jobDate = "" // get job date
    var uid = "" // get user id
    
    //MARK:- View life cyclic
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set text field is only of number
        self.txtPayRate.textFieldType = .numbersOnly
        // set title to view controller
        self.title = "Job Request"
        self.loadDataInFields() // get and set data in fileds
    }
    
    //MARK:- Private methods
    // load data in field
    private func loadDataInFields() {
     
        // casting job detail object
        if let job = jobDetail {
            
            // get manager name and set to the lable
            if let _ = job.mangerName , CurrentUser.sharedInstance.userType == .employee {
                
                self.lblSenderInfo.text = "From Manager : " + job.mangerName
                
                // get employee name and set to label
            } else if let name = job.employeeName,  CurrentUser.sharedInstance.userType == .manger {
                self.lblSenderInfo.text = "To : " + name // set name to lable
            }
            
            self.txtJobLocation.text = job.jobLocation // set job location to field
            self.txtJobNumber.text = job.jobTitle // set job title to filed
            self.txtHours.text = job.jobHour // set job hours
            self.txtClientName.text = job.clientName // set client name
            self.txtClientContactNumber.text = job.clientContantNumber // set client contact number
            self.txtPayRate.text = job.payRate // set job rate to the field
            self.pickerDateTime.date = DateHelper.dateFromString(job.jobDateTime, dateFormat: K.ServerDateTimeFormat) // set data and time to field
            
            /*
             dsable the views user can only view the fields
             **/
            self.txtPayRate.isEnable = false
            self.pickerDateTime.isEnable = false
            self.txtJobLocation.isEnable = false
            self.txtJobNumber.isEnable = false
            self.txtHours.isEnable = false
            self.txtClientName.isEnable = false
            self.txtClientContactNumber.isEnable = false
            
            /*Disable buttons for manager .
             it only work for employee
             */
            if CurrentUser.sharedInstance.userType == .manger {
                
                self.btnReject.isHidden = true
                self.btnAccept.isHidden = true
                self.lblMsg.isHidden = true
                
                // After accepted and rejected job button should be hide
            } else if job.status == "reject" || job.status == "accepted" {
                
                self.btnReject.isHidden = true // hide rejection button
                self.btnAccept.isHidden = true // hide accept button
            }
        }
    }
    
    // MARK: - IBAction
    // Send message button for send job request
    @IBAction func sendMessageBtnClicked(_ sender: UIButton) {
     
        // View controller instantiate with story board adn viewcontroller identoer
        let vc = R.StoryboardRef.EmployeeStoryboard.instantiateViewController(withIdentifier: R.ViewControllerIds.MessageVC) as!MessageViewController
        vc.isFromManagerViewEmployee = CurrentUser.sharedInstance.userType == .manger
        vc.jobDetail = self.jobDetail // assign job detail to message view controller
        self.push(vc) // push view controller
    }
    
    // Rejection job request
    @IBAction func rejectMessageBtnClicked(_ sender: UIButton) {
     
        if let requestID = self.jobDetail.jobUID { // get job id for rejection
            
            self.showLoadingActivity() // show loading activity
            let statusDate = DateHelper.stringFromDate(Date())! // set date for rejection
            //rejectJobRequest is method with success and failure call back
            ServicesManager.rejectJobRequest(requestId: requestID , senderId: self.jobDetail.managerUID, reciverID: self.jobDetail.employeeUID, statusDate: statusDate, success: { (referece:DatabaseReference) in
                
                self.pop() //pop view controller
                //success message on job request is reject
                SwiftMessages.showToast("Request is rejected.", type: .success)
                self.hideLoadingActivity() // hides loading activity
            }, failure: { (error:Error) in // failure call back
          
                // show error messag
                SwiftMessages.showToast(error.localizedDescription, type: .error)
                self.hideLoadingActivity() // hide loading activity
            })
        }
    }
    
    /*
     this function is used for accepted job request
     */
    @IBAction func acceptRequestBtnClicked(_ sender: UIButton) {
     
        
        if let job = self.jobDetail { // get job request id
         
            /* JobRequestAcceptPopup is popup view used to collect data related to job request
             **/
            
            // user infoview is instance of JobRequestAcceptPopup which is initilise with current and job detail
            let userInfoView = JobRequestAcceptPopup(showInView: self.view, jobDetail: job)
            
            // call back on success, return dictionay
            userInfoView.handleSuccessBlock = {(dic) in
                
                // statusDate is a date which is record on change status
                // Datehelper is used to convert date object in string
                let statusDate = DateHelper.stringFromDate(Date())!
                // get request id and manager id from job detail object
                if let requestID = self.jobDetail.jobUID ,let managerUID = self.jobDetail.managerUID {
                    
                    // show loading activity
                    self.showLoadingActivity()
                    
                    // makes user object which have all information needed to save with job request such as employee id , manager id and employee name
                    let userObject : [String : Any] = ["manager_uid": self.jobDetail.managerUID! ,"employee_uid":self.jobDetail.employeeUID! , K.AcceptedJobRequestDataKey:statusDate , "employee_name":self.jobDetail.employeeName!]
                    
                    // merges job request object with user object to save detail related to employee and manager
                    var newDic = dic.merging(userObject) { (current, _) in current }.merging(self.jobDetail.toDictionary()) { (current, _) in current }
                    
                    // saves the job satus as accepted. The job status is either accepted or rejected.
                    newDic["status"] = "accepted"
                    
                    // makes a call to firebase server with the custom object which have all detail related to job, emplyee and manager
                    ServicesManager.acceptJobRequestStatus(managerUid:managerUID, employeeUid: self.jobDetail.employeeUID!, userObject:newDic, jobRequestUID: requestID, statusDate: statusDate, success: { (referece:DatabaseReference) in
                        
                        self.pop() // pop the view controller on success
                        // shows the success message
                        SwiftMessages.showToast("Request is accept successfully.", type: .success)
                        self.hideLoadingActivity() // stop the loading activity
                    }) { (error:Error) in // error call back
                        // shows error
                        SwiftMessages.showToast(error.localizedDescription, type: .error)
                        self.hideLoadingActivity() // hide loading activity
                    }
                }
            }
            
            
            userInfoView.show() // need to show popview with this method call
        }
    }
}
