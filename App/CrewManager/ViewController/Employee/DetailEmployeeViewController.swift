//
//  DetailEmployeeViewController.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import SwiftMessages
import MessageUI

//Show detail of employee
class DetailEmployeeViewController: UIViewController {

    
    //MARK:- IBOutlet
    @IBOutlet weak var lblUser: UILabel! // user  label
    @IBOutlet weak var imageProfile : UIImageView! // profile image
    @IBOutlet weak var txtFname: JMTextField! // first name text field
    @IBOutlet weak var txtLname: JMTextField! // last name text field
    @IBOutlet weak var btnSendEmail: UIButton! // send email button
    @IBOutlet weak var btnCall: UIButton! // call buttton
    @IBOutlet weak var txtAddress: JMTextField! // address label
    
    
    //MARK:- Variable
    var  profileData: UserProfile? // user profile instance
    var  updateProfileData: UserProfile?{ // for update user profile data
        
        didSet {
            if let model = profileData { // casting profile data object
                lblUser.text = model.username // set username
                txtFname.text = model.fname // set first name
                txtLname.text = model.lname // set last name
                btnCall.setTitle(model.phoneNumber, for: .normal) // set phonenumber
                btnSendEmail.setTitle(model.email, for: .normal) // set email
                txtAddress.text = model.address // set address
                // get user profile image from firebase server
                guard let url = URL(string: model.photoURL) else { return }
                ImageService.getImage(withURL: url) { image in
                    self.imageProfile.image = image // set image
                }
            }
        }
    }
    
    
    //MARK:- View Life Cyclic methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Detail Crew"
        
        self.updateProfileData = self.profileData
//        self.getEmployeeProfile()
    }
    
        
    // MARK: - IBAction
    @IBAction func btnEmailSendClicked(_ sender: UIButton) { //func of button of email sending
        
        if MFMailComposeViewController.canSendMail() {
           let mail = MFMailComposeViewController()
            mail.setToRecipients([self.profileData!.email]) // set email
           mail.setSubject("") // set email subject
           mail.setMessageBody("", isHTML: true) //set email message body
           mail.mailComposeDelegate = self
           present(mail, animated: true) // email sending animation
        }
        else { //show message of not sent email
           print("Email cannot be sent")
        }
    }
    //sent message button
    @IBAction func btnSendMessageClicked(_ sender: UIButton) {
        //view controller get from storyboard with identifer
        let vc = R.StoryboardRef.EmployeeStoryboard.instantiateViewController(withIdentifier: R.ViewControllerIds.MessageVC) as!MessageViewController
        
        vc.isFromManagerViewEmployee = true // flow check
        
        let request = JobRequest() // request object parse to server side
        //full name
        if CurrentUser.sharedInstance.fullName.count > 0 {
            
            request.mangerName = CurrentUser.sharedInstance.fullName
        } else {
            request.mangerName = CurrentUser.sharedInstance.fullName
        }
        
        request.employeeUID = profileData?.uid // user id
        request.employeeName = profileData!.fname + " " + profileData!.fname // user name
        request.managerUID = ServicesManager.uid // manager id
        vc.jobDetail = request // request object is parse to view
        self.push(vc) // push view controller
    }
    //make call on cell phone
    @IBAction func btnMakeCallOnCellPhoneClicked(_ sender: UIButton) {
        
        // make call url for call
        if let url = URL(string: "tel://\(String(describing: self.profileData!.phoneNumber))"),
        UIApplication.shared.canOpenURL(url) { // can device open the url
           if #available(iOS 10, *) {//check IOS version
             UIApplication.shared.open(url, options: [:], completionHandler:nil)//open the URL
            } else {
                UIApplication.shared.openURL(url) // open the otherdevice
            }
        } else {
                 // add error message here
        }
        
    }
}

    //MARK:-MFMailComposeViewControllerDelegate
extension DetailEmployeeViewController: MFMailComposeViewControllerDelegate {
    //compose the email
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result:          MFMailComposeResult, error: Error?) {
       if let _ = error {
          self.dismiss(animated: true, completion: nil)
       }
       switch result {
          case .cancelled: // cancel the email
          print("Cancelled")
          break
          case .sent: // sent the email
          print("Mail sent successfully")
          break
          case .failed: // email failed
          print("Sending mail failed")
          break
          default:
          break
       }
       controller.dismiss(animated: true, completion: nil)
    }
}
    

