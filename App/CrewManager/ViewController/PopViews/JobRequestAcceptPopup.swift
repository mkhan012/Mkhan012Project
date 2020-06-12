//
//  JobRequestAcceptPopup.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import Foundation
import UIKit
import SwiftMessages

/*
 JobRequestAcceptPopup
 this pop is used by employee when he accept the manager job request
 **/

class JobRequestAcceptPopup: JMBasePopupView {
    
    // success call back handler
    var handleSuccessBlock : (([String:Any]) -> ())?
    // data picker which shows the job date and time
    private lazy var pickerJoinDate = JMDatePicker(withTitle: "Job Date and Time", isCompulsory:true, pickerType: .date)
    // job notes
    private lazy var txtNote = JMTextView(withTitle: "Note", isCompulsory: true, textLimit: 500)
    // buttons save and cancel
    private lazy var btnSave = JMBaseButton(withTitle: "Save")
    private lazy var btnCancel = JMBaseButton(withTitle: "Cancel")
    
    // constructor which is initlize with current view and job request
    convenience init(showInView view: UIView , jobDetail: JobRequest) {
        // initlize super method
        self.init(withTitle: "Job Request Accept ",
                  shouldAlignedToCenter: false,
                  showInView: view)
        // add buttons in popview
        self.actionButtons = [self.btnCancel, self.btnSave]
    
        self.pickerJoinDate.isEnable = false // disable job date picker
        self.pickerJoinDate.pickerType = .dateAndTime // set date picker with picker type
        self.pickerJoinDate.date = Date() // set current date
        // set job date
        self.pickerJoinDate.date = DateHelper.dateFromString(jobDetail.jobDateTime, dateFormat: K.ServerDateTimeFormat)
        
        // add view in popup views
        self.popupViews = [self.pickerJoinDate , self.txtNote ]
        // save button handler
        self.btnSave.clickHandler = { [unowned self] (button: JMBaseButton) in
            // validate data
            if self.isViewDataValid() {
                self.handleSave() // save fucntion call
            }
        }
        //cancel button handeler
        self.btnCancel.clickHandler = { [unowned self] (button: JMBaseButton) in
            
            self.hide()
        }
    }
    
    // handleSave compose the user object with some job information
    private func handleSave() {
        
        let userObject : [String : Any] = [
            "Joining_note": self.txtNote.text,
            "accepted_date":DateHelper.stringFromDate(Date()) ?? "",
            "accepted":"1",
            ] as [String:Any]
        
        //call back handler
        self.handleSuccessBlock?(userObject)
        self.hide() // hide view
    }
    
    //MARK:- Validations
    func isViewDataValid() -> Bool {
        
        return true
    }
}
