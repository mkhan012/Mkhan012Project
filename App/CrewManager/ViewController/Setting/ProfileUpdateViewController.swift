//
//  ProfileUpdateViewController.swift
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

class ProfileUpdateViewController: UIViewController {

    
    //MARK:-IBOutlet
    @IBOutlet weak var lblUserName : JMLabel!
    @IBOutlet weak var txtAddress : JMTextField!
    @IBOutlet weak var imageProfile : UIImageView!
    @IBOutlet weak var btnProfileImage : UIButton!
    @IBOutlet weak var txtFirstName : JMTextField!
    @IBOutlet weak var txtLastName : JMTextField!
    @IBOutlet weak var txtEmail : JMTextField!
    @IBOutlet weak var txtPhoneNumber : JMTextField!

    
    //MARK:-Public Variable
    var profileUrl:URL?
    var imagePicker:UIImagePickerController?
    var isSelectProfileImage = false
    // get and set user profile data
    var  profileData: UserProfile? {
        
        didSet {
            if let model = profileData { // casting profile data object
                lblUserName.text = model.username // set username
                txtFirstName.text = model.fname // set first name
                txtLastName.text = model.lname // set last name
                txtEmail.text = model.email // set email
                txtPhoneNumber.text = model.phoneNumber // set phone numebr
                txtAddress.text = model.address // set address
                // get user profile image from firebase server
                guard let url = URL(string: model.photoURL) else { return }
                ImageService.getImage(withURL: url) { image in
                    self.imageProfile.image = image// set image
                }
            }
        }
    }
    // make user object for save data in firebase
    var userObject : [String:Any]? {
        var dic:[String:Any] = ["fname": self.txtFirstName.text,
                                "lname": self.txtLastName.text,
                                "phone_number": self.txtPhoneNumber.text,
                                "address": self.txtAddress.text]
        
        // get url of profile image
        if profileUrl != nil {
            dic["photoURL"] = profileUrl!.absoluteString
        }
        return dic
    }
    //MARK:- View life cyclic methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // set title of view
        self.title = "Update Profile"
        // get user profile data
        if let profile = CurrentUser.sharedInstance.userProfileData {
            self.profileData = UserProfile(fromDictionary: profile)
        } else {
            // get profile data from firebase server
            self.observeProfile()
        }
        // setup for
        self.setupView()
        self.txtEmail.isEnable = false // make email adress disable for user can not able change
    }
    
    
    //MARK:- Private
    private func setupView() {
     
        self.imageProfile.clipsToBounds = true // make clips of view
        self.imagePicker = UIImagePickerController() // instanct of pickercontroller
        self.imagePicker?.allowsEditing = false // disable editing
        self.imagePicker?.sourceType = .photoLibrary // get pic from photolibrary
        self.imagePicker?.delegate = self // make delegate self
    }
    
    // get profile data from firebase server with sucess and failure handler
    func observeProfile() {
        //showloading activity
        self.showLoadingActivity()
            // get user profile data from server
        ServicesManager.getUserProfile(success: { (snapshot:DataSnapshot) in

            // get all data and then casting the object
            if let values = snapshot.value as? [String:Any] {
             // set data to local object
                CurrentUser.sharedInstance.userProfileData = values
                // set data to profile
                self.profileData = UserProfile(fromDictionary: values)
                
            }
            //hide loading activity
            self.hideLoadingActivity()
        }) { (error:Error) in // error handler
            // show error message 
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            // hide loading activity
            self.hideLoadingActivity()
        }
    }
    
    // update profile methods
    private func updateProfile() {
        
        // show loading activity
        self.showLoadingActivity()
        //updateProfile method with sucess and failure handler
        ServicesManager.updateProfile(userObject: userObject!, success: { (reference: DatabaseReference) in
            // get updated profile data
            self.observeProfile()
            // show success message
            SwiftMessages.showToast("Profile update Successfully", type: .success)
            // hide loading activty
            self.hideLoadingActivity()
        }) { (error:Error) in // error block
            // error message show
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            // hide loading
            self.hideLoadingActivity()
        }
    }
    
    // upload profile image
    private func uploadProfileImage(image:UIImage) {
        
        self.showLoadingActivity() // show loading activity
        //saveProfileImage
        ServicesManager.saveProfileImage(profileImage: image , success: { (url: URL) in
            //show error message
            SwiftMessages.showToast("Profile image upload Successfully", type: .error)
            // get profile data
            self.observeProfile()
                //set url
            self.profileUrl = url
            // hide loading activity
            self.hideLoadingActivity()
            
        }) { (error:Error) in // error handler
            // show error
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            self.hideLoadingActivity() // hide loading activity
        }
    }
    
    // MARK: - IBAction
    @IBAction func changeProfileImageBtnClicked(_ sender: UIButton) {
        
        // Open Image Picker
        if let picker = self.imagePicker {
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func updateProfileBtnClicked(_ sender: UIButton) {
     
        if self.isViewDataValid() { // valiater
            //update profle
            self.updateProfile()
        }
    }
    
    //MARK:- Validations
    func isViewDataValid() -> Bool { return true}
}

//MARK:- UIImagePickerControllerDelegate
extension ProfileUpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil) //dismiss viewcontroller
    }

    //didFinishPickingMediaWithInfo method call when get image successfully
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage { //get image from library
            self.imageProfile.image = image // set image
            self.isSelectProfileImage = true // set boolen bit
            dismiss(animated: true) { // dismiss view after uploading image
                self.uploadProfileImage(image: image)
            }
        }
    }
}
