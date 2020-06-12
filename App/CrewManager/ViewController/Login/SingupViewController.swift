//
//  SingupViewController.swift
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


class SingupViewController: UIViewController {
    
    //MARK:-IBOutlet
    @IBOutlet fileprivate weak var imageProfile : UIImageView!
    @IBOutlet fileprivate weak var btnProfileImage : UIButton!
    @IBOutlet fileprivate weak var btnUploadImage : UIButton!
    @IBOutlet fileprivate weak var textUserName : JMTextField!
    @IBOutlet fileprivate weak var txtFirstName : JMTextField!
    @IBOutlet fileprivate weak var txtLastName : JMTextField!
    @IBOutlet fileprivate weak var txtEmail : JMTextField!
    @IBOutlet fileprivate weak var txtPhoneNumber : JMTextField!
    @IBOutlet fileprivate weak var txtPassword : JMTextField!
    @IBOutlet fileprivate weak var txtRePassword : JMTextField!
    @IBOutlet fileprivate weak var txtAddress : JMTextField!
    @IBOutlet fileprivate weak var pickerServices : JMStringPicker!
    @IBOutlet fileprivate weak var pickerGender : JMStringPicker!
    @IBOutlet fileprivate weak var btnSignUp : UIButton!
    
    
    //MARK:-Public Variable
    var profileUrl:URL? // profile pic url get from firebase
    var userDic: [String : Any]? // user information in dictory formate
    var imagePicker:UIImagePickerController?
    var isSelectProfileImage = false // save bollen bit if user have upload profile pic the we also need to upload pic
    var loginBySocialMedia = true // save bit if user can login by social media
    // make userObejct
    var userObject : UserProfile? {
        get {
            let user = UserProfile()
            
            user.userType = self.pickerServices.selectedId
            user.sex = self.pickerGender.selectedId
            user.email = self.txtEmail.text
            user.username = self.textUserName.text
            user.fname = self.txtFirstName.text
            user.lname = self.txtLastName.text
            user.phoneNumber = self.txtPhoneNumber.text
            if let url = self.profileUrl {
                user.photoURL = url.absoluteString
            }
            user.address = self.txtAddress.text
            user.createdOn = DateHelper.stringFromDate(Date())
            
            
            return user
        }
    }
    
    
    //MARK:-View Life Cyclic
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnUploadImage.isHidden = true // hide the upload button by default
        self.setupView() // setup view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //use make gradient background
        self.setGradientLayer(colorTop: .purple, colorBottom: .blue)
        super.viewWillAppear(animated)
    }
    
    
    //MARK:- Private
    // Setup all fields
    private func setupView() {
        
        self.pickerServices.data = [JMGeneralModel(title: "Crew", id: K.employeeTree),JMGeneralModel(title: "Manager", id: K.managerTree)]
        self.pickerGender.data = K.GenderOptions.map({(JMGeneralModel(title: $0))})
        
        
        // setup environemnt to get image data from device or camera
        self.imagePicker = UIImagePickerController() // make instance to UIImagePickerController
        self.imagePicker?.allowsEditing = false // disable editing
        self.imagePicker?.sourceType = .photoLibrary // get image from phone library
        self.imagePicker?.delegate = self // delegte make it self
        
        self.loadDataInField() // load all data get from social media such as google and facebook
    }
    
    /*loadDataInField
     this function gets data from social media,set the data fields **/
    private func loadDataInField() {
        
        if let dic = self.userDic {
            
            self.txtPassword.isHidden = true
            self.txtRePassword.isHidden = true
            
            if let user = dic["username"] as? String , user.cleanedString().count > 0 {
                self.textUserName.text = user
                self.textUserName.isEnable = false
            }
            if let fname = dic["fname"] as? String {
                self.txtFirstName.text = fname
            }
            if let lname = dic["lname"] as? String {
                self.txtLastName.text = lname
            }
            if let phoneno = dic["phone_number"] as? String {
                self.txtPhoneNumber.text = phoneno
            }
            if let email = dic["email"] as? String , email.count > 0 {
                self.txtEmail.text = email
                self.txtEmail.isEnable = false
            }
            if let address = dic["address"] as? String {
                self.txtAddress.text = address
            }
            if let address = dic["photoURL"] as? String {
                
                guard let url = URL(string: address) else { return }
                ImageService.getImage(withURL: url) { image in
                    
                    self.isSelectProfileImage = true
                    self.imageProfile.image = image
                    self.uploadProfileImage(image: image!)
                }
            }
            if let sex = dic["sex"] as? String {
                self.pickerGender.selectedData = [JMGeneralModel(title: sex.capitalized, id: sex)]
            } else {
                self.pickerGender.selectedData = [self.pickerGender.data.first!]
            }
            
            self.pickerServices.selectedData = [self.pickerServices.data.first!]
            
        }
    }
    // Pushh dashboard after successfull signup
    private func pushDashboard() {
        // showloading activty
        self.showLoadingActivity()
        
        //DispatchQueue which is block user intervace for 3 second to make UI ready for user
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
    
            
            // push dasboard view controller
            let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.dashboardNav)

            // make dashboard viewcontrooler as a root viewcontroller
            self.setRoot(for: vc)
            
            // hide loading activity
            self.hideLoadingActivity()
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func changeProfileImageBtnClicked(_ sender: UIButton) {
         
        // Open Image Picker Liberary to get image file
        if let picker = self.imagePicker {
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    // signup button click
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
                
        //validates all fields
        if self.isViewDataValid() {
            
            // make check false after it saved in firebase
            self.loginBySocialMedia = false
            // save usertype in firbase
            ServicesManager.userType = UserTypes(rawValue: self.pickerServices.selectedId)!
            //get info related to current user
            if let _ = ServicesManager.currentUser {
                                
                // save the user profile data
                self.saveProfile()
                
            } else {
             // create new user if user does not exist in firebase
                self.createUser()
            }
        }
    }
    
    @IBAction func uploadProfileImageBtnClicked(_ sender: UIButton) {
        
        guard let image = self.imageProfile.image else {
            return
        }
        
        self.uploadProfileImage(image: image)
    }
    
    
    //MARK:- Private API's
    

//  This function is used to create
    private func createUser() {
        //Shows loading activty
        self.showLoadingActivity()
        //methods is used to create user with email address and passowrd
        ServicesManager.createUser(email: self.txtEmail.text, password: self.txtPassword.text, success: { (auth: AuthDataResult) in
            
            self.hideLoadingActivity()
            if let _ = ServicesManager.currentUser { // check user created .
                
                    // user profles picture is uploaded to firebase server creare user
                self.uploadProfileImage(image: self.imageProfile.image!)
            } else {
                    // the user profile gets saved
                self.saveProfile()
            }
            
        }) { (error:Error) in // Error handler
            // show errror
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            self.hideLoadingActivity() //hide loading activity
        }
    }
    
    private func saveUserType() {
        self.showLoadingActivity()
        
    }
    
    // make a custom object of user and save all data to firebase
    private func saveProfile () {
        
        if !self.loginBySocialMedia { // check if user login from facebook and google
            self.showLoadingActivity() // show loading activity
            
            // make user object in which we are saving user type
            let userData:[String:String] = ["user_type": self.pickerServices.selectedId]
            if let type = UserTypes(rawValue: self.pickerServices.selectedId) {
                // set user type local object to make a flow and with respect to user
                CurrentUser.sharedInstance.userType = type // save user type
                ServicesManager.userType = type // save user type to servermanager
            }else {
                // on failure it is calll
                CurrentUser.sharedInstance.userType =  .employee
                ServicesManager.userType = .employee
            }
            
            // save all user data related to user profile
            ServicesManager.updateUserData(userObject: userData, success: { (reference:DatabaseReference) in
                // make firebase call to save user profile data with success and failure call
                ServicesManager.saveProfile(userObject: self.userObject!.toDictionary(), success: { (ref: DatabaseReference) in
                    self.pushDashboard() // push view controller
                    self.hideLoadingActivity() // hide loading activity
                    
                }) { (error:Error) in // error handler
                     // show error message
                    SwiftMessages.showToast(error.localizedDescription, type: .error)
                    self.hideLoadingActivity() // hide loading activity
                }
                
            }) { (error:Error) in // error handler
                // show error message
                SwiftMessages.showToast(error.localizedDescription, type: .error)
                self.hideLoadingActivity() // hide loading activity
            }
        }
    }
    
    // function is used to save profile image to firebase
    private func uploadProfileImage(image:UIImage) {
        
        // show loading
        self.showLoadingActivity()
        // saveProfileImage methods send data to firease and return url to image
        ServicesManager.saveProfileImage(profileImage: image , success: { (url: URL) in
            
            SwiftMessages.showToast("Profile image upload Successfully", type: .success)
            
            // save the url with local object
            self.profileUrl = url
            //hide activty
            self.hideLoadingActivity()
            //saves profile
            self.saveProfile()
            
        }) { (error:Error) in // error message handler
            // show error message
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            self.hideLoadingActivity()
        }
    }
    
    
    //MARK:- Validations
    func isViewDataValid() -> Bool {
        
        if self.textUserName.text.count <= 0  {
            SwiftMessages.showToast("UserName is missing. Please provide and try again.")
            return false
        }
        if self.txtEmail.text.count <= 0 {
            SwiftMessages.showToast("Email is missing. Please provide and try again.")
            return false
        }
        if !self.txtEmail.text.isValidEmail() {
            SwiftMessages.showToast("Please enter valid email address and try again")
            return false
        }
        if self.userDic == nil {
            
            if self.txtPassword.text.count <= 0  {
                SwiftMessages.showToast("Please enter password and try again")
                return false
            }
            if self.txtRePassword.text.count <= 0  {
                SwiftMessages.showToast("Please enter re-password and try again")
                return false
            }
            if self.txtRePassword.text != self.txtPassword.text {
                SwiftMessages.showToast("Password not matach.")
                return false
            }            
        }
        
        if self.txtPhoneNumber.text.count <= 0  {
            SwiftMessages.showToast("Phone numebr is missing. Please provide and try again.")
            return false
        }
        if self.txtFirstName.text.count <= 0  {
            SwiftMessages.showToast("First Name is missing. Please provide and try again.")
            return false
        }
        if self.txtLastName.text.count <= 0  {
            SwiftMessages.showToast("Last Name is missing. Please provide and try again.")
            return false
        }
        
        return true
    }
}



//MARK:- UIImagePickerControllerDelegate
// its a delegate methods
extension SingupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            self.imageProfile.image = image //get image to liberary
            self.isSelectProfileImage = true // set local blloen bit
            
            // after getting image dismiss the library view
            dismiss(animated: true) {
                
                if let _ = ServicesManager.currentUser {
                    
                    // upload the image to firebase server
                    self.uploadProfileImage(image: image)
                }
                // make status chage of local blooen but
                self.isSelectProfileImage = true
            }
        }
    }
}
