//
//  ForgotPasswordViewController.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import SwiftMessages


class ForgotPasswordViewController: UIViewController {

    //MARK:-IBOutlet
    @IBOutlet weak var txtEmail : UITextField! // email field
    @IBOutlet weak var btnforgotPassword : UIButton! // forgot button
    
    
    //MARK:-View Life Cyclic
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setGradientLayer()
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - IBAction
    //this function is used to make call for forgot password
    @IBAction func forgotPasswordBtnClicked(_ sender: UIButton) {
     
        // validates all data
        if self.isViewDataValid() {
            // show loading activity
            self.showLoadingActivity()
            // check email address field is not empty
            if let email = self.txtEmail.text {
                // show loading activity
                self.showLoadingActivity()
//                make a change password request for firebase  with email parameter and with sucess boolen value
                ServicesManager.sendPasswordReset(email: email, success: { (success: Bool) in
         // hide loading activity on success
                    self.hideLoadingActivity()
                    // show message
                    SwiftMessages.showToast("We send you an email with instructions on how to reset your password.", type: .success)
                    // error handler
                }) { (error:Error) in
                    // show error message
                    SwiftMessages.showToast(error.localizedDescription, type: .error)
                    self.hideLoadingActivity() // hide loading acoty
                }
            }
        }
    }
    
    
    //MARK:- Validations
    func isViewDataValid() -> Bool {
        
        if self.txtEmail.text!.count <= 0 {
            SwiftMessages.showToast("Email is missing. Please provide and try again.")
            return false
        } else if !self.txtEmail.text!.isValidEmail() {
            SwiftMessages.showToast("Please enter valid email address and try again")
            return false
        }

        return true
    }
}
