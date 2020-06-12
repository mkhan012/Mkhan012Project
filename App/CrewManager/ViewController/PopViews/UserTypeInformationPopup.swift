//
//  UserTypeInformationPopup.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import SwiftMessages


class UserTypeInformationPopup: JMBasePopupView {
    
    // this is call back handler
    var handleSuccessBlock : (([String:Any]) -> ())?
    // label show title of view
    private lazy var lblTopMessage = JMLabel(text: "Save User Information",edgeInsets: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0))
    // empty view need to add some space at top of the view
    private lazy var viewTop = JMBaseView(withBackgroundColor: .white)
    // textfield for get username info
    private lazy var txtUserName = JMTextField(withTitle: "User Name ",isCompulsory: true,textLimit: 200)
    // text field get use email address
    private lazy var txtEmail = JMTextField(withTitle: "Email ",isCompulsory: true,textLimit: 200)
    // text field get fist name of the user
    private lazy var txtFName = JMTextField(withTitle: "First Name ",isCompulsory: true,textLimit: 200)
    // text field get last name of the user
    private lazy var txtLName = JMTextField(withTitle: "Last Name ",isCompulsory: true,textLimit: 200)
    // text field get phone number of the user
    private lazy var txtPhoneNumber = JMTextField(withTitle: "Phone Number ",
                                                  isCompulsory: true,
                                                  textLimit: 200)
    // text field get address of the use
    private lazy var txtAddress = JMTextField(withTitle: "Address ",
                                              isCompulsory: true,
                                              textLimit: 200)
    // data picker which is used to get gender of the user
    private lazy var pickerGender = JMStringPicker(withTitle: "Gender",
                                                   isCompulsory: true)
    
    // data picker whihc is used to set user role in this app (as emploee and manager)
    private lazy var pickerRole = JMStringPicker(withTitle: "User Role",
                                                 isCompulsory: true)
    // save button
    private lazy var btnSave = JMBaseButton(withTitle: "Save")
    // constructor which is initlize with current view
    convenience init(showInView view: UIView) {
         //
        self.init(withTitle: " Save User Information ",
                  shouldAlignedToCenter: false,
                  showInView: view)
        
        self.actionButtons = [self.btnSave] // button
        // add all field in  popoview
        self.popupViews = [self.viewTop ,self.txtUserName,self.pickerRole,self.txtFName,self.txtLName, self.pickerGender,self.txtPhoneNumber ,  self.txtAddress]
        // button click handler
        self.btnSave.clickHandler = { [unowned self] (button: JMBaseButton) in
            //validation all field .
            if self.isViewDataValid() {
                self.handleSave() // save call handler
            }
        }
        // set font to top label
        self.lblTopMessage.font = .robotoBold(20.0)
        // set picker data
        self.pickerRole.data = [JMGeneralModel(title: "Crew", id: "employee"),JMGeneralModel(title: "Manager", id: "manager")]
        self.pickerGender.data = [JMGeneralModel(title: "Male", id: "male"),JMGeneralModel(title: "Female", id: "female")]
        //set picker rolw
        self.pickerRole.selectedData = [self.pickerRole.data.first!]
        // set gender
        self.pickerGender.selectedData = [self.pickerGender.data.first!]
    }
    
    // handleSave method which is compose all data in dictioary data type
    private func handleSave() {
        
        let userObject : [String:Any] = [
            "sex": self.pickerGender.selectedId,
            "user_type": self.pickerRole.selectedId,
            "phone_number": self.txtPhoneNumber.text,
            "email": self.txtEmail.text,
            "username": self.txtUserName.text,
            "fname": self.txtFName.text,
            "lname": self.txtLName.text,
            "address": self.txtAddress.text,
            "photoURL":"",
            
            ] as [String:Any]
        
        // now all composed data return to call back handler
        self.handleSuccessBlock?(userObject)
        self.hide() // hide the view after work is done
    }
    
    //MARK:- Validations
    func isViewDataValid() -> Bool {
        
        if self.txtPhoneNumber.text.count <= 0 {
            SwiftMessages.showToast("Phone Number is missing. Please provide and try again.")
            return false
        }
        if self.txtAddress.text.count <= 0 {
            SwiftMessages.showToast("Address is missing. Please provide and try again.")
            return false
        }
        
        return true
    }
}
