//
//  MessageViewController.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import SwiftMessages

// Message ViewController is used to send a message
class MessageViewController: UIViewController {

    //MARK:-IBOutlet
    @IBOutlet weak var btnSendMsg: UIButton! // send button
    @IBOutlet weak var lblSenderInfo: JMLabel! // label which is used to show sender info
    @IBOutlet weak var txtSubject : JMTextField! // get subject of message
    @IBOutlet weak var txtMessage : JMTextView! // textmessage is text view ss used to get message
    
    
    //MARK:- Variable
    var jobDetail :JobRequest! // job detail object which is get from parent view
    var isFromManagerViewEmployee:Bool = false // check user type manager or emplyee
    
    
    //MARK:- View life cyclic
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Message" // show title
        self.loadDataInFields() // loading data in field
    }
    
    //MARK:- Private methods
    private func loadDataInFields() {
     
        if let job = jobDetail { // get data from job detail object
            
            if self.isFromManagerViewEmployee { // check user type
                
                // get name of current user
                if let name = job.employeeName,  CurrentUser.sharedInstance.userType == .manger {
                    self.lblSenderInfo.text = "To : " + name // set current user name to label
                }
                
            } else {
             // get manager name
                if let _ = job.mangerName , CurrentUser.sharedInstance.userType == .employee {
                    
                    self.lblSenderInfo.text = "To Manager : " + job.mangerName // set manager name to label
                    // get current user name with respect to manager flow
                } else if let name = job.employeeName,  CurrentUser.sharedInstance.userType == .manger {
                    self.lblSenderInfo.text = "From : " + name // set current user name to the label
                }else {
                    self.lblSenderInfo.text = "Message Recived" // in all cases message is set to recieved
                }
            }
            
            //get job subject
            if let subject = job.subject ,  subject.count > 0 {
                self.txtSubject.text = subject // set to text field to be edited
                
                // disable subject field
                self.txtSubject.isEnable = false
            }
            
            // get message and set to field
            if let message = job.message ,  message.count > 0 {
                
                self.txtMessage.text = message
                self.txtMessage.isEnable = false //disable the field
                self.btnSendMsg.isHidden = true  //hides send message button
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func sendMessageBtnClicked(_ sender: UIButton) {
        // check all fields are valid
        if self.isViewDataValid() {
            
            // make required object to save data in fire base data base tree
            let userObject = ["message":self.txtMessage.text , "subject":self.txtSubject.text , "type":K.messageTypeResponse , "employee_uid":self.jobDetail.employeeUID!, "employee_name":self.jobDetail.employeeName! ,"manager_uid":self.jobDetail.managerUID!].merging(jobDetail.toDictionary()) { (current, _) in current }
            
            if self.isFromManagerViewEmployee { // check is it employee or manager
                
                self.showLoadingActivity() // show loading activity
                
                //sentMessageToEmployee is a method used with sender information and job detail
                ServicesManager.sentMessageToEmployee(senderId: self.jobDetail.managerUID, reciverID: self.jobDetail.employeeUID, userObject: userObject , success: { (reference :DatabaseReference) in
                    // on success pop the view
                    self.pop()
                    // hide loading activity
                    self.hideLoadingActivity()
                    
                }, failure: { (error:Error) in // error call back
                    // error message show
                    SwiftMessages.showToast(error.localizedDescription, type: .error)
                    self.hideLoadingActivity() // hide loading activity
                })
            } else {
             
                self.showLoadingActivity()
                
                // sentMessageToManager method is used with job details to send message to manager.on sucess we got our result and pop the view
                ServicesManager.sentMessageToManager(senderId:self.jobDetail.managerUID , reciverID: self.jobDetail.employeeUID, userObject: userObject, success: { (reference :DatabaseReference) in
                    
                    self.pop() // pop the view controller
                    self.hideLoadingActivity() // hide loading activity
                }) { (error:Error) in // error call back
                    // show error message
                    SwiftMessages.showToast(error.localizedDescription, type: .error)
                    self.hideLoadingActivity() // hide loading acvity
                }
            }
        }
    }
    
    
    /*
     this is Validations here we are Validate the field data
     **/
    
    //MARK:- Validations
    func isViewDataValid() -> Bool {

        if self.txtSubject.text.count <= 0  {
            SwiftMessages.showToast("Subject is missing. Please provide and try again.")
            return false
        }
        if self.txtMessage.text.count <= 0 {
            SwiftMessages.showToast("Please provide text messsage and try again.")
            return false
        }
        
        return true
    }
}
