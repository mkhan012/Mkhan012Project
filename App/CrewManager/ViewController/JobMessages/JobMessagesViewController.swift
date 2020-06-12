//
//  JobMessagesViewController.swift
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
// Message box
public enum MessageBox : Int  {
    case inbox = 0 // inbox message
    case sent = 1 // send messags
}

// message type get from firebase services
public enum MessageType : String  {
    case response = "job_request_response" // job request response message
    case request = "job_request" // job request message
}


//
class JobMessagesViewController: UIViewController {

    //MARK:-IBOutlet
    @IBOutlet weak var lblNoDataFoundMsg: UILabel!
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var btnSentMesage : UIButton!
    @IBOutlet weak var segmentControl : UISegmentedControl!
    
    
    //MARK:-private Model
    var sent:[[String:JobRequest]] = [] // sent box messagex
    var inbox:[[String:JobRequest]] = [] // inbox messages
    
    //MARK:- View life cyclic method
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Messages inbox" // set title
        
        self.btnSentMesage.isHidden = true // by default send messge button hide
        self.setupTableView() //setup table view
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getInboxMessage() // get inbox messages
        self.getSentMessage() // get sent messages
    }
    
    
    //MARK:- Private methods
    // setup table view
    fileprivate func setupTableView() {
        
        //get nib and register to table view cell
        self.tblMessage.register(UINib(nibName: R.Nibs.EmployeeCell, bundle: nil), forCellReuseIdentifier: R.CellIdentifiers.EmployeeCell)
        //get nib and register to table view cell
        self.tblMessage.register(UINib(nibName: R.Nibs.MessageCell, bundle: nil), forCellReuseIdentifier: R.CellIdentifiers.MessageCell)
        
        self.tblMessage.delegate = self // delegate register
        self.tblMessage.dataSource = self // dataSource register
        
        self.tblMessage.tableFooterView = UIView()  // remove footer
    }
    
    
    // MARK: - IBAction
    @IBAction func sentMessageBtnClicked(_ sender: UIButton) {
//        get message view controller and push view
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.AddJobMessagesVC) as!AddJobMessagesViewController
        
        self.push(vc)//push view controlller
    }
    //get message box
    @IBAction func messageTypeSegmentClicked(_ sender: UISegmentedControl) {
        
        if let type = MessageBox(rawValue: sender.selectedSegmentIndex) {
            switch type {
                
            case .inbox: //get inbox box
                self.btnSentMesage.isHidden = true // hide sent button
                self.getInboxMessage() // get all inbox messages
            case .sent: // get send message box
                self.btnSentMesage.isHidden = false // show sent button
                self.getSentMessage() // //get sent messages for firebase
            }
        }
    }
    
    //MARK:- API's Methods
    private func getInboxMessage() { // get all inbox message from firebase server
        
        self.showLoadingActivity() // show loading activity
//        get all inbox messages with sucess and failure call back methods
        ServicesManager.inboxMessage(success: { (snapshot:DataSnapshot) in
            self.inbox.removeAll() // remove all inbox messages
                        
            for child in snapshot.children.allObjects { // get all objects
                
                if let snap = child as? DataSnapshot { // get all child object
                    
                    if let values = snap.value  as? [String:Any] { //casting  the object
                        
                        let mesg = JobRequest(fromDictionary: values) // make job request object
                        let dic = [snap.key:mesg] // make a dictionry instance
                        self.inbox.append(dic) // append dic object
                    }
                }
            }
            self.tblMessage.reloadData() // reaload table view
            self.hideLoadingActivity() // hide loading activity
        }, failure: { (error:Error) in // error handler
//            show error message
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            self.hideLoadingActivity() //hide loading activity
        })
    }
    
    //get all sent message from firebase
    private func getSentMessage() {
        //show loading activity
        self.showLoadingActivity()
        // get all message from firebase
        ServicesManager.sentMessage(success: { (snapshot:DataSnapshot) in
            self.sent.removeAll() // remove all old sent messages
            // get all send messages from server
            for child in snapshot.children.allObjects {
                // get all child
                if let snap = child as? DataSnapshot {
                    // casting the message
                    if let values = snap.value  as? [String:Any] {
                        
                        let mesg = JobRequest(fromDictionary: values) // make job request message
                        let dic = [snap.key:mesg] // make  dic
                        self.sent.append(dic) // append dictioary object to array of send message
                    }
                }
            }
            //reload table view message
            self.tblMessage.reloadData()
            //hide loading activity
            self.hideLoadingActivity()
            
        }, failure: { (error:Error) in // error handler
            //show loading actvity
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            //hide loading activity
            self.hideLoadingActivity()
        })
    }
}


//MARK:- TableViewDataSource
extension JobMessagesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { // section in table view
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //number of rows in section
        
        if let type = MessageBox(rawValue: self.segmentControl.selectedSegmentIndex) { // get message box
            switch type {
            case .inbox: // get inbox messages
                self.lblNoDataFoundMsg.isHidden = self.inbox.count != 0 // show and hide label messages
                return self.inbox.count
            case .sent: // get send messges
                self.lblNoDataFoundMsg.isHidden = self.sent.count != 0 // show and hide label messages
                return self.sent.count // number send messge count
            }
        }
        return 0
    }
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.CellIdentifiers.MessageCell,
                                                 for: indexPath) as! MessageTableViewCell
        var mesg :JobRequest!//get msg request object
        var msgType = ""
        if let type = MessageBox(rawValue: self.segmentControl.selectedSegmentIndex) { // get selected box messages
            switch type { // messge type /sent / inbox
            case .inbox:
                msgType = "Recived" //recived msg type tile
                mesg = self.inbox[indexPath.row].values.first
            case .sent:
                msgType = "Sent" // sent messages type title
                mesg = self.sent[indexPath.row].values.first // send msgz index
            }
        }
        
        if let typeString = mesg.type , typeString.count > 0 , let type = MessageType(rawValue: typeString) { // mesage type string
            switch type {
            case .request:
                let attributeString = NSMutableAttributedString ()//attributed string instance
                
                // set job request label
                cell.lblSubject.attributedText =  NSAttributedString("Job request " + msgType + " to "  ,font1: UIFont.robotoRegular(14.0),
                                                                           part2: mesg.employeeName + " " ,
                                                                           font2: UIFont.robotoBold(14.0),color2: UIColor.black)
                //set client name
                if let cname = mesg.clientName {
                    attributeString.append(NSAttributedString("Client Name " ,font1: UIFont.robotoRegular(14.0),
                                                                               part2: cname + " " ,
                                                                               font2: UIFont.robotoBold(14.0),color2: UIColor.black))
                }
                //set job location
                if let location = mesg.jobLocation {
                    attributeString.append(NSAttributedString("Location at "  ,font1: UIFont.robotoRegular(14.0),
                                                                               part2: location,
                                                                               font2: UIFont.robotoBold(14.0),color2: UIColor.black))
                }
                
                //set attributed string
                cell.lblMesg.attributedText = attributeString
                //set reponse message type
            case .response:
                cell.lblSubject.text = mesg.subject // set subject
                cell.lblMesg.text = mesg.message // set message
            }
        }
        
        cell.removeSeparatorInsets() // remove seprator insects
        return cell
    }
}
//MARK:- TableViewDelegate
extension JobMessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var mesg :JobRequest! // make job request instance
        
        // message box instance
        if let type = MessageBox(rawValue: self.segmentControl.selectedSegmentIndex) {
            switch type { // message type
            case .inbox: // message inbox
                mesg = self.inbox[indexPath.row].values.first
            case .sent: //message send
                mesg = self.sent[indexPath.row].values.first
            }
        }
        //mesage type differentie
        if let msgTypeString = mesg.type , msgTypeString.count > 0 , let type = MessageType(rawValue: msgTypeString){
            switch type {//message type
            case .request: // messsage request type
                print("Message Request")
                                // view controller for view job request
                let vc = R.StoryboardRef.EmployeeStoryboard.instantiateViewController(withIdentifier: R.ViewControllerIds.ViewJobRequestVC) as!ViewJobRequestViewController
                vc.jobDetail = mesg // pass messge referce next view contrller
                self.push(vc)
            case .response:
                print("Message Response")
                //view controller view message
                let vc = R.StoryboardRef.EmployeeStoryboard.instantiateViewController(withIdentifier: R.ViewControllerIds.MessageVC) as!MessageViewController
                vc.isFromManagerViewEmployee = true // flow variable
                vc.jobDetail = mesg // pass messge referce next view contrller
                self.push(vc) // push view controller
            }
        }
    }
}

