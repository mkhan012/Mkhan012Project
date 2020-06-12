//
//  LoginViewController.swift
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

//This view controller is used when user is already created
class LoginViewController: UIViewController {
    
    //MARK:-IBOutlet
    @IBOutlet weak var btnCheck : UIButton!
    @IBOutlet weak var btnRememberMe : UIButton!
    @IBOutlet weak var btnSignIn : UIButton!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var btnfaceBook : UIButton!
    @IBOutlet weak var btnGoogle : UIButton!
    
    
    //MARK:-
    // user dictionary object which have all info about user
    var userDic: [String : Any] = [:]
    var loginFrom = "" // user login from eg. email , facebook , google
    
    //MARK:-View Life Cyclic
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setGradientLayer() // set gradient backgroudn
        super.viewWillAppear(animated)
    }
    
    // sigup button, user can signup by email address
    // MARK: - IBAction
    @IBAction func signInWithEmailBtnClicked(_ sender: UIButton) {
        
        self.loginFrom = "email" // login form email
        
        // check email and password field  validation
        if let email = self.txtEmail.text ,let password = self.txtPassword.text {
            
            // login methods call with 2 parameters email and password
            self.login(email: email, password: password)
        } else {
         // error message show
            SwiftMessages.showToast("Please enter email and pasword.", type: .error)
            return
        }
    }
    
    // if user is signup form google
    @IBAction func signInGoogleBtnClicked(_ sender: UIButton) {
        
        self.loginFrom = "google"
        // Automatically sign in the user by google
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    // if user is sign up from facebook
    @IBAction func signInFaceBookBtnClicked(_ sender: UIButton) {
        
        self.showLoadingActivity()
        self.loginFrom = "facebook"
        
        ServicesManager.fbLoginManager.logIn(permissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
          
            // hide loading activity
            self.hideLoadingActivity()
            
            //error handling
            if let error = error {
                // Show error
                SwiftMessages.showToast(error.localizedDescription, type: .error)
                // return from methods without processding
                return
                // if user cancel the the request durning procceding
            } else if let cancel = result?.isCancelled , cancel == true {
               
                // Logged out? automatically
                SwiftMessages.showToast("Login Cancelled", type: .error)
                
            } else {
                // Logged in firebase after getting faceboook credential
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                // firebase auth call for login with facebook credential
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error { // error handling
                        //show error message
                        SwiftMessages.showToast(error.localizedDescription, type: .error)
                        //return from method
                        return
                    } else {
                        // get data from facebook if user is sucessfully login
                        self.getDataFromfacebook()
                    }
                }
            }
        }
    }
    
    //button for remember me wo save password and email address
    @IBAction func rememberMeBtnClicked(_ sender: UIButton) {
        //check and uncehck matain and set
        sender.isSelected = !sender.isSelected
        
    }
    
    //button used to forgot password
    @IBAction func forgotPasswordBtnClicked(_ sender: UIButton) {
        // show forgot view controller
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.ForgotPasswordVC) as!ForgotPasswordViewController
        //presnt view
        self.present(vc, animated: true, completion: nil)
    }
    
    // signup button clicked
    @IBAction func singUpBtnClicked(_ sender: UIButton) {
        
        //show signup viewcontroller
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.SignupVC) as!SingupViewController
        //presnet view
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //MARK:- API
    func login(email: String, password: String) {
        
        // check again validation
        if self.isViewDataValid() {
            
            // make async call to block user interface until user can succcessfully login
            DispatchQueue.main.async {
                
                //shows loading activity
                self.showLoadingActivity()
                
                // login from firease by email address and password
                Auth.auth().signIn(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { user, error in
                    
                    self.hideLoadingActivity()
                    // get error
                    if let error = error
                    {
                        SwiftMessages.showToast(error.localizedDescription, type: .error)
                    }
                    // check if user information get success from server
                    guard user != nil else { return }
                                        // push the dashboard view controller
                    self.pushDashboard()
                }
                
            }
        }
    }
    
    //MARK:- Private API's
    // this method is used for get specfic data from facebook
    fileprivate func getDataFromfacebook() {
     
        //show loading actvity
        self.showLoadingActivity()
        
        // make a graph request with access token of facebook
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id,name,address,birthday,gender,email,education,age_range,location,picture{url}"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: HTTPMethod.get)
        
        //graphRequest call back handler with conection result and error call backhandler
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
           
            // hide loading activity
            self.hideLoadingActivity()
            // check error
            if let err = error {
                // show error
                SwiftMessages.showToast(err.localizedDescription, type: .error)
            }
            else {
                //user information get from facebook in required data type / casting
                if let userDic = result as? [String :Any] {
                    self.userDic = userDic // save reference in local object
                    // initlize the dictioanry object with facebook data
                    self.userDic["username"]  = userDic["name"]
                    self.userDic["fname"] = ""
                    self.userDic["lname"] = ""
                    self.userDic["phone_number"] = ""
                    self.userDic["email"] = userDic["email"]
                    self.userDic["sex"] = userDic["gender"]
                    // get location
                    if let location = userDic["location"] as? [String : Any]{
                        if let name = location["name"] as? String {
                            self.userDic["address"] = name
                        }
                    }// get profile pictuer
                    if let picture = userDic["picture"] as? [String:Any]{
                        
                        if let data = picture["data"] as? [String:Any]{
                            if let url = data["url"] as? String{
                                
                                self.userDic["photoURL"] = url
                            }
                        }
                    }
                    // get user data
                    self.getUserData()
                }
            }
        })
    }
    
    //getUserData function is used to get and update data in firebase
    fileprivate func getUserData() {
        
       //save login from information in facebook
        let userInfo: [String:String] = ["login_from": self.loginFrom]
        self.showLoadingActivity()//show loadign activity
        //update user data at firebase with success and failure handler
        ServicesManager.updateUserData(userObject:userInfo , success: { (reference:DatabaseReference) in
            // get user data from firebase
            ServicesManager.getUserData(success: { (snapshot:DataSnapshot) in
                // get user type
                if let values = snapshot.value as? [String:Any] , let _ = values["user_type"] as? String {
                    CurrentUser.setLoggedInUserInfo(values) // set user information in local objects
                    self.pushDashboard()// show dashboard view controller
                    
                } else {
                 //push signup view controller for collect remaining information
                    let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.SignupVC) as!SingupViewController
                    vc.userDic = self.userDic //initlize the dic object
                    self.present(vc, animated: true, completion: nil)
                }
                //hide loading activity
                self.hideLoadingActivity()
            }) { (error:Error) in // error handler
                //show error message
                SwiftMessages.showToast(error.localizedDescription, type: .error)
                self.hideLoadingActivity()//hide loading activity
            }
            
        }) { (error:Error) in // error handler
            //shwo error
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            self.hideLoadingActivity() // hide activity
        }
    }
    
    //push dashboar view controller
    //MARK:- Private Methods
    private func pushDashboard() {
        
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.dashboardNav)
        
        self.setRoot(for: vc)
    }
    
    
    //MARK:- Validations
    func isViewDataValid() -> Bool {
        
        if self.txtEmail.text!.count <= 0 {
            SwiftMessages.showToast("Email is missing. Please provide and try again.")
            return false
        } else if self.txtPassword.text!.count <= 0 {
            SwiftMessages.showToast("Password is missing. Please provide and try again.")
            return false
        } else if self.txtPassword.text!.count < 8 {
            SwiftMessages.showToast("Minimum password legnth is 8 characters")
            return false
        }else if !self.txtEmail.text!.isValidEmail() {
            SwiftMessages.showToast("Please enter valid email address and try again")
            return false
        }
        
        return true
    }
}

//MARK:- GIDSignInDelegate
extension LoginViewController:GIDSignInDelegate {
    
    // GIDSignIn is google delegate method with error handler
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        // error hadler
        if let error = error {
            //show error
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            
            return
        }
        // get user data and initlize local object
        userDic["username"]  = user.profile.givenName
        userDic["fname"] = ""
        userDic["lname"] = ""
        userDic["phone_number"] = ""
        //get email
        if user.profile.email.count == 0 {
            
            userDic["email"] = user.profile.givenName
            
        } else {
            userDic["email"] = user.profile.email
            
        }// get address
        userDic["address"] = ""
        // user have profile image
        if user.profile.hasImage {
            let pic = user.profile.imageURL(withDimension: 100)
            
            userDic["photoURL"] = pic?.absoluteString
        }
        //authentication get
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // get auth and sign with google credential
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            //error hadler
            if let error = error {
                //show error
                SwiftMessages.showToast(error.localizedDescription, type: .error)
                //return and get out from the method
                return
            } else {
                self.getUserData() // get user data
                
            }
        }
    }
    // delegate method 
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        
        print("didDisconnectWith")
    }
}
