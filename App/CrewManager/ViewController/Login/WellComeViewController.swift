//
//  WellComeViewController.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import SwiftMessages
import FirebaseUI
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn


class WellComeViewController: UIViewController {
    
    //MARK:-IBOutlet
    @IBOutlet weak var btnSignIn : UIButton! // sign in button
    @IBOutlet weak var btnSignUp : UIButton! // creates account
    @IBOutlet weak var btnReload : UIButton! //reload button
    
    //MARK:-View Life Cyclic
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnReload.isHidden = true  //hiddes the btn button
        
        
        if let _ = ServicesManager.currentUser {   // checks if the current user is logged in.
            
            self.getUserData() // get user data from firebase
        }
    }
    
    override func viewDidAppear(_ animated: Bool) { //
        super.viewDidAppear(animated)
        
    }
    
    //this methods app lifecycle method
    override func viewWillAppear(_ animated: Bool) {
        
        self.setGradientLayer(colorTop: .purple, colorBottom: .blue) //develops the theme
        super.viewWillAppear(animated)
    }
    
    //    MARK:- Priavte Methods
    fileprivate func getUserData() {
       
        self.showLoadingActivity()  // show loading activity
        ServicesManager.getUserData(success: { (snapshot:DataSnapshot) in // call back method gets the data from server
                        
            if let values = snapshot.value as? [String:Any] , let userType = values["user_type"] as? String , userType.count > 0 {  // gets the user type from fire base to check if its a manager or employee.
                         
                CurrentUser.setLoggedInUserInfo(values)
                
                let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.dashboardNav)
                self.setRoot(for: vc) // dashboard set as rootview controller
                
            } else {
             
                self.addMissingUserInfo() // if ther user is new or if he had a misson information then this is called. save and gets missing information.
            }
            
            self.hideLoadingActivity() // hide activity
            
        }) { (error:Error) in  // this method is called back when error is caught any type of error,
            
            SwiftMessages.showToast(error.localizedDescription, type: .error)  // swift messages liberary is used to show toast error messages
            self.hideLoadingActivity() //hide loading activity
        }
        
    }
    func addMissingUserInfo() {  // pop view appear to get missing information and then it saves it to firbase
        
        let userInfoView = UserTypeInformationPopup(showInView: self.view)
        
        userInfoView.handleSuccessBlock = {(dic) in // successful call method back. this call back is used to get data successfuly from popview.
            
            self.showLoadingActivity() // shows loading
            
            let userData:[String:Any] = ["user_type": dic["user_type"]!] // user information which is get from pop view through DIC
            
          
            // function is used to update user data, update the user data through firebase.
            ServicesManager.updateUserData(userObject: userData, success: { (reference:DatabaseReference) in //
                
                //saves profile information
                ServicesManager.saveProfile(userObject: dic, success: { (ref:DatabaseReference) in
                    
                    //Vc Controller presents dashbaord view controller.
                    let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.dashboardNav)
                    self.setRoot(for: vc) // dashboard viewcnotrooler as root view controller
                    
                    //hide loading activity
                    self.hideLoadingActivity()
                    //show success message
                    SwiftMessages.showToast("User information save successfully.", type: .success)
                    
                }) { (error:Error) in // error handler
                    //hide
                    self.hideLoadingActivity()
                    //show error message
                    SwiftMessages.showToast(error.localizedDescription, type: .error)
                }
                
                // error handler
            }) { (error:Error) in
                self.hideLoadingActivity() // hideloading activity
                // shows error message
                SwiftMessages.showToast(error.localizedDescription, type: .error)
            }
        }
        // show popview on cuurent view
        userInfoView.show()
    }
    
    // MARK: - IBAction
    
    // when there is no internet it is used to reload missing user information
    @IBAction func reloadBtnClicked(_ sender: UIButton) {
        
        self.addMissingUserInfo()
    }
    
    //presents sign view controller
    @IBAction func signInBtnClicked(_ sender: UIButton) {
        
        //gets login view controller from story board.
        //R is a constant class,
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier:  R.ViewControllerIds.LoginVC) as!LoginViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // this button is user to create new user
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        
        // make reference to signupview controller with story board and with viewcontroller identifer and get viewcontroller from storyboard
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.SignupVC) as!SingupViewController
        
        // present the view controller 
        self.present(vc, animated: true, completion: nil)
    }
}
