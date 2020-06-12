//
//  JobRequestViewController.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import SwiftMessages


// view jobs JobRequests listig
class JobRequestViewController: UIViewController {

    //MARK:-IBOutlet
    @IBOutlet weak var lblNoDataFoundMsg: UILabel! // label for show no data found.
    @IBOutlet weak var tblMessage: UITableView! // for listing
    @IBOutlet weak var btnSentMesage : UIButton! // send job request
    @IBOutlet weak var segmentControl : UISegmentedControl! //get inbox and sent message
    
    
    //MARK:-private Model
    var sent:[[String:JobRequest]] = [] //sent request data array
    var inbox:[[String:JobRequest]] = [] // inbox request data array
    var jobDate = "" // var job date
    var uid = "" // var user id
    
    
    //MARK:- View Life Cyclic
    override func viewDidLoad() {
        super.viewDidLoad()

        // set title
        self.title = "Messages inbox"
        
        //hide sent job request button
        self.btnSentMesage.isHidden = true
        // set tabele view for listing
        self.setupTableView()
    }

    //view life cyclic method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // get all inbox message
        self.getInboxMessage()
        //get all sent message
        self.getSentMessage()
    }
    
    
    //MARK:- Private methods
    fileprivate func setupTableView() {
        
        //register employee cell to table view
        self.tblMessage.register(UINib(nibName: R.Nibs.EmployeeCell, bundle: nil), forCellReuseIdentifier: R.CellIdentifiers.EmployeeCell)
        //register message cell in table view
        self.tblMessage.register(UINib(nibName: R.Nibs.MessageCell, bundle: nil), forCellReuseIdentifier: R.CellIdentifiers.MessageCell)
        //set delegate to table
        self.tblMessage.delegate = self
        //set datasource in table
        self.tblMessage.dataSource = self
        //remove footer in table view
        self.tblMessage.tableFooterView = UIView()
    }
    
    
    // MARK: - IBAction
    //compose  message button  for job request
    @IBAction func sentMessageBtnClicked(_ sender: UIButton) {
        
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.AddJobMessagesVC) as!AddJobMessagesViewController
        
        self.push(vc)
    }
    
    //get required inbox data or sent data for user
    @IBAction func messageTypeSegmentClicked(_ sender: UISegmentedControl) {
        
        // message box type
        if let type = MessageBox(rawValue: sender.selectedSegmentIndex) {
            switch type { // message box type
                
            case .inbox: // inbox message
                self.getInboxMessage()// get inbox messages
            case .sent: // send box
                self.getSentMessage() // get sent messages
            }
        }
    }
    
    
    //MARK:- API's Methods
    private func getUserData() { // get user information data
       
        self.showLoadingActivity() // show loading activity
        // get user data from fire base service
        ServicesManager.getUserData(success: { (snapshot:DataSnapshot) in
            
            // object casting
            if let values = snapshot.value as? [String:Any] {
                
                // filter required data
                if let date = values["accepted_job_request_date"] as? String {
                    self.jobDate = date
                }
            
                if let date = values["accepted_job_request_uid"] as? String {
                    self.uid = date
                }
            }
            
        }) { (error:Error) in // error
            // show error message
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            self.hideLoadingActivity() // hide loading activty
        }
        
    }
    
    // get inbox messages
    private func getInboxMessage() {
        
        self.showLoadingActivity() // show loading activity
        
        //get all inbox message with sucess and error call back
        ServicesManager.inboxMessage(success: { (snapshot:DataSnapshot) in
            self.inbox.removeAll() // remove all previous messsages
                        
            // loop all objects and filter the required data
            for child in snapshot.children.allObjects {
                
                // object casting
                if let snap = child as? DataSnapshot {
                    
                    // casting the valeus in required formate
                    if let values = snap.value  as? [String:Any] {
                        
                        // make job request object
                        let mesg = JobRequest(fromDictionary: values)
                        let dic = [snap.key:mesg] // make ditionaty which have key user message and object is value of dictioary
                        self.inbox.append(dic) //append the dic in the inbox messags
                    }
                }
            }
            // realod table view
            self.tblMessage.reloadData()
            //hide loading activity
            self.hideLoadingActivity()
        }, failure: { (error:Error) in // shows error on failure
            //show error message
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            self.hideLoadingActivity() // hide loading activity
        })
    }
    
    // get all send messages
    private func getSentMessage() {
        
        // show loading activity
        self.showLoadingActivity()
        //get all send message with success and failure cal back
        //DataSnapshot is firebase object which is used to formating carring  data from firebase
        ServicesManager.sentMessage(success: { (snapshot:DataSnapshot) in
            self.sent.removeAll()
            
            for child in snapshot.children.allObjects {
                
                if let snap = child as? DataSnapshot {
                    
                    if let values = snap.value  as? [String:Any] {
                        
                        let mesg = JobRequest(fromDictionary: values) // make new job request job
                        let dic = [snap.key:mesg]
                        self.sent.append(dic) //append dic object in send array of dic
                    }
                }
            }
            self.tblMessage.reloadData() // reload table view
            self.hideLoadingActivity() // hide activity
        }, failure: { (error:Error) in // error handler
            //show error
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            self.hideLoadingActivity() // hide activity
        })
    }
}


//MARK:- TableViewDataSource
extension JobRequestViewController: UITableViewDataSource {
// show number of section in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    // for show number of rows in tabel view secntion
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let type = MessageBox(rawValue: self.segmentControl.selectedSegmentIndex) { // get selected message box data
            switch type { // message box type
            case .inbox:// inbox data
                self.lblNoDataFoundMsg.isHidden = self.inbox.count != 0 // show no data found label
                return self.inbox.count // show number of rows
            case .sent: // send box
                self.lblNoDataFoundMsg.isHidden = self.sent.count != 0 // no data found label hide and show
                return self.sent.count // show number of row
            }
        }
        return 0 // number of rows
    }
    
    // number of rows show in table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // MessageTableViewCell show
        let cell = tableView.dequeueReusableCell(withIdentifier: R.CellIdentifiers.MessageCell,
                                                 for: indexPath) as! MessageTableViewCell
        var mesg :JobRequest! //get required object
        if let type = MessageBox(rawValue: self.segmentControl.selectedSegmentIndex) { // get selected tab
            switch type { // get selected message box
            case .inbox: // get inbox
                mesg = self.inbox[indexPath.row].values.first // get inbox messages
            case .sent: // get sent box
                mesg = self.sent[indexPath.row].values.first // get send box messges
            }
        }
        
        if let typeString = mesg.type , typeString.count > 0 , let type = MessageType(rawValue: typeString) { // job request type
            switch type { // message  type
            case .request: // message type is request
                let attributeString = NSMutableAttributedString () // make attrubuted string
                
                // make and set job request to the label
                cell.lblSubject.attributedText =  NSAttributedString("Job request sent by Manager "  ,font1: UIFont.robotoRegular(14.0),
                                                                           part2: mesg.mangerName + " " ,
                                                                           font2: UIFont.robotoBold(14.0),color2: UIColor.black)
                
                if let cname = mesg.clientName { // set client name
                    attributeString.append(NSAttributedString("Client Name " ,font1: UIFont.robotoRegular(14.0),
                                                                               part2: cname + " " ,
                                                                               font2: UIFont.robotoBold(14.0),color2: UIColor.black))
                }
                if let location = mesg.jobLocation { // set location
                    attributeString.append(NSAttributedString("Location at "  ,font1: UIFont.robotoRegular(14.0),
                                                                               part2: location,
                                                                               font2: UIFont.robotoBold(14.0),color2: UIColor.black))
                }
                
                cell.lblMesg.attributedText = attributeString // set attributedstring to the lables
                
            case .response: // message type is response
                cell.lblSubject.text = mesg.subject // set messge subject
                cell.lblMesg.text = mesg.message // set messsage to lable
            }
        }
        
        cell.removeSeparatorInsets()
        
        return cell
    }
}


//MARK:- TableViewDelegate
extension JobRequestViewController: UITableViewDelegate {
    //tabel view row select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // job request data
        var mesg :JobRequest!
        //get message type from segment
        if let type = MessageBox(rawValue: self.segmentControl.selectedSegmentIndex) {
            switch type { // message type
            case .inbox: // inbox type
                mesg = self.inbox[indexPath.row].values.first
            case .sent: // send type
                mesg = self.sent[indexPath.row].values.first
            }
        }
        // message type string
        if let msgTypeString = mesg.type , msgTypeString.count > 0 , let type = MessageType(rawValue: msgTypeString){
            switch type {
                
            case .request: // message type is request
                print("Message Request")
                //show job request view
                let vc = R.StoryboardRef.EmployeeStoryboard.instantiateViewController(withIdentifier: R.ViewControllerIds.ViewJobRequestVC) as!ViewJobRequestViewController
                vc.jobDetail = mesg // set data to job request view
                self.push(vc)  //push view controller
                
            case .response: // message type is response
                print("Message Response")
                //show messge respnse view
                let vc = R.StoryboardRef.EmployeeStoryboard.instantiateViewController(withIdentifier: R.ViewControllerIds.MessageVC) as!MessageViewController
                
                vc.jobDetail = mesg // set data to messge respnse view
                self.push(vc) //push view controller
            }
        }
    }
}


