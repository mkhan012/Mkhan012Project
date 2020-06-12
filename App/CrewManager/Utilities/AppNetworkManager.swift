//
//  AppNetworkManager.swift
//  CrewManager
//
//  Created by Muhammad Khan
// 
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftMessages

public let ServicesManager = AppNetworkManager.sharedInstance

//App network manager handles all the network actiivity. taking data from firebase and saving data to fire.
open class AppNetworkManager: NSObject {
    
    private override init() { }
    /**
     *
     */
    public static let sharedInstance = AppNetworkManager() // static varibale that makes a single thread
    
    
    /*
     FacebookAuthProvider  for FIREBASE 
     **/
    public var databaseReference: DatabaseReference = Database.database().reference() // base node of data base tree in fire base.
    
    public let fbLoginManager : LoginManager = LoginManager() // used to login manager from facebook.
    
    var storageRef: StorageReference? {  // storages and get images
        return Storage.storage().reference().child("/\(uid!)") //
    }
    
    public var currentUser: User? {  // gets current user information from firebase
        return Auth.auth().currentUser
    }
    public var uid: String? {  // get current user Id from firebase
        return Auth.auth().currentUser?.uid
    }
    
    public var userType:UserTypes = .employee  // gets user type after the user is logged in.
    
    public var userGlobalRef: DatabaseReference? {  // global node
     
        return databaseReference.child("\(String(describing: uid!))")
    }
    
    public var inboxMessage: DatabaseReference? {  // used to get inbox messages
     
        return databaseReference.child("\(userType.rawValue)/\(String(describing: uid!))/\(K.inboxTree)")
    }
    public var sentMessage: DatabaseReference? {  // used to get sent messages
     
        return databaseReference.child("\(userType.rawValue)/\(String(describing: uid!))/\(K.sentTree)") //
    }
    
    public var userRef: DatabaseReference? {  // gets information of the global node.
     
        return databaseReference.child("\(String(describing: uid!))")
    }
    
    public var profileRef: DatabaseReference? { // gets the user profile from firebase
     
        return databaseReference.child("\(userType.rawValue)/\(String(describing: uid!))/\(K.profileTree)")
    }

    public var employeeListRef: DatabaseReference? { // gets employee list
     
        let type:UserTypes = .employee
        return databaseReference.child("\(type.rawValue)")
    }
    
    public var mangersEmployeeRef: DatabaseReference? {
     
        return databaseReference.child("\(uid!)/\(K.acceptedJobRequestTree)")
    }
    
    public var employeeRef: DatabaseReference? {  // ref whatever the employee accepts.
     
        return databaseReference.child("\(uid!)/\(K.acceptedJobRequestTree)")
    }
    
    public var storageProfileImageRef: StorageReference?{ // store profile picture
        
        return Storage.storage().reference().child("\(userType.rawValue)/\(String(describing: uid!))/\(K.profileTree)")
    }
    
    public var metaData: StorageMetadata? {  // compress the user profile images and stores in the firebase.
        let metaData = StorageMetadata()
        metaData.contentType = K.ContentType
        return metaData
    }
    
    public var  fireBaseAuth: Auth? {  // current user information, auth is token to get data from firebase.
        return Auth.auth()
    }
    
    public var inbox: DatabaseReference? { // inbox tree global
     
        return databaseReference.child("\(userType.rawValue)/\(String(describing: uid!))/\(K.inboxTree)")
    }
    
    public var sent: DatabaseReference? { //global tree, it gets the sent messagess globally
     
        return databaseReference.child("\(userType.rawValue)/\(String(describing: uid!))/\(K.sentTree)")
    }
    
    
    //MARK:-Public API's
    
    // Gets all the employees jobs accepted
    public  func getCurrentEmployJobs(uid:String ,success: @escaping (DataSnapshot)->Void, failure: @escaping (Error) -> Void) {
    
        //make referece to get all jobs
        var reference: DatabaseReference? {
         
            return self.databaseReference.child("\(K.employeeTree)/\(uid)/\(K.inboxTree)")
        }
        
        reference?.observe(.value, with: { (snapshot: DataSnapshot) in
            success(snapshot)
            
        }, withCancel: { (error:Error) in // Checks error
            failure(error) //failure handler
        })
    }
    
    
    // gets the employees jobs
    public  func getEmployJobs(success: @escaping (DataSnapshot)->Void, failure: @escaping (Error) -> Void) {
        
        //make reference for get all jobs
        var reference: DatabaseReference? {
         
            return self.databaseReference.child("\(K.employeeTree)/\(self.uid!)/\(K.inboxTree)")
        }
        //get all employee jobs
        reference?.observe(.value, with: { (snapshot: DataSnapshot) in
            success(snapshot) //succeess handler
        }, withCancel: { (error:Error) in //check error
            failure(error) //failure handler
        })
    }
    
    // the employee reject the job
    public  func rejectJobRequest(requestId:String, senderId:String ,reciverID:String ,statusDate:String, success: @escaping (DatabaseReference)->Void,
    failure: @escaping (Error) -> Void) {
        
        let userObject = [K.StatuKey:K.RejectKey ,K.StatusUpdateOnKey:statusDate] // making an object to update user job status.
        
        //makes a reciver reference for firebase
        var reciverCopy: DatabaseReference? {
         
            return databaseReference.child("\(K.employeeTree)/\(String(describing: reciverID))/\(K.inboxTree)/\(requestId)")
        }
        
        //makes sender referece for firebase
        var senderCopy: DatabaseReference? {
         
            return databaseReference.child("\(K.managerTree)/\(String(describing: senderId))/\(K.sentTree)/\(requestId)")
        }
        
        // update reciver values
        reciverCopy?.updateChildValues(userObject)
        
        //update child values
        senderCopy?.updateChildValues(userObject, withCompletionBlock: { (error:Error?, ref: DatabaseReference) in
            
            if let currentError = error { // check error
                failure(currentError) // failure handler
            } else {
                success(ref) //success handler
            }
        })
        
    }
    
    // update job request status
    public  func acceptJobRequestStatus(managerUid:String,employeeUid:String,userObject: [String:Any] , jobRequestUID:String  , statusDate:String , success: @escaping (DatabaseReference)->Void,
    failure: @escaping (Error) -> Void) {
        
        
        //make referce for job request
        var reference: DatabaseReference? {
         
            return self.databaseReference.child("\(managerUid)/\(K.acceptedJobRequestTree)/\(employeeUid)/\(jobRequestUID)")
        }
        
        //update values with completion block with error and success handler
        reference?.updateChildValues(userObject, withCompletionBlock: { (error: Error?,ref: DatabaseReference) in
            
            if let currentError = error { //check error
                failure(currentError) //check failure
            } else {
                
                //update values
                self.databaseReference.child("\(K.employeeTree)/\(employeeUid)/\(K.inboxTree)/\(jobRequestUID)").updateChildValues(userObject)
                
                success(ref) //success handler
            }
        })
    }
    
    //get all inbox messages with succss and failure block
    public func inboxMessage( success: @escaping (DataSnapshot)->Void,
                             failure: @escaping (Error) -> Void) {
        
//        get all inbox messages
        inbox?.observe(.value, with: { (snapshot: DataSnapshot) in
            success(snapshot) //succss handler
        }, withCancel: { (error:Error) in //error handler
            failure(error) //failure handler
        })
    }
    
    //get all send message from firebase server with compliton block success and failure
    public func sentMessage( success: @escaping (DataSnapshot)->Void,
                             failure: @escaping (Error) -> Void){
        
        //sent message get from server
        sent?.observe(.value, with: { (snapshot: DataSnapshot) in
            success(snapshot)//success handler
        }, withCancel: { (error:Error) in //check error
            failure(error) //failure handler
        })
    }
    //send message to manager with success and failure handler
    public  func sentMessageToManager(senderId:String ,reciverID:String, userObject: [String:Any] , success: @escaping (DatabaseReference)->Void,
    failure: @escaping (Error) -> Void) {
        
        // reciver referce
        var reciverCopy: DatabaseReference? {
         
            return databaseReference.child("\(K.managerTree)/\(String(describing: senderId))/\(K.inboxTree)").childByAutoId()
        }
        

        // set values in reciver with Completion Block sucess and error parameter userobject
        reciverCopy?.setValue(userObject, withCompletionBlock: { (error:Error?, ref: DatabaseReference) in
          
            var newdic = userObject //
            newdic[K.requestUUID] = ref.key! //set new job values
            
            //make sender copy
            var senderCopy: DatabaseReference? {
             
                return self.databaseReference.child("\(K.employeeTree)/\(String(describing: reciverID))/\(K.sentTree)/\(ref.key!)")
            }
            
            // save job id in manager model
            self.databaseReference.child("\(K.managerTree)/\(String(describing: senderId))/\(K.inboxTree)/\(ref.key!)").updateChildValues([K.requestUUID:ref.key!])
            
            // save job request model in sender tree
            senderCopy?.setValue(newdic, withCompletionBlock: { (error:Error?, ref: DatabaseReference) in
                
                if let currentError = error { //check error
                    failure(currentError) // failure hanlder
                } else {
                    success(ref) //success handler
                }
            })
        })
    }
    
    //
    public  func sentMessageToEmployee(senderId:String ,reciverID:String, userObject: [String:Any] , success: @escaping (DatabaseReference)->Void,
    failure: @escaping (Error) -> Void) {
        
        //make senderCopy referecne for firebase
        var senderCopy: DatabaseReference? {
         
            return databaseReference.child("\(K.managerTree)/\(String(describing: senderId))/\(K.sentTree)").childByAutoId()
        }
        
        // senderCopy reference with success Completion block and error handler
        senderCopy?.setValue(userObject, withCompletionBlock: { (error:Error?, ref: DatabaseReference) in
            
            if let currentError = error { //check error
                failure(currentError) // failure handler
            } else {
                
                var dic = userObject
                dic[K.requestUUID] = ref.key! // set user id
                // update manager model add new key job request id
                self.databaseReference.child("\(K.managerTree)/\(String(describing: senderId))/\(K.sentTree)/\(ref.key!)").updateChildValues([K.requestUUID:ref.key!])
                
                //make reciver reference
                var reciverCopy: DatabaseReference? {
                 
                    return self.databaseReference.child("\(K.employeeTree)/\(String(describing: reciverID))/\(K.inboxTree)/\(ref.key!)")
                }
                //set value for reciver
                reciverCopy?.setValue(dic, withCompletionBlock: { (error:Error?, ref: DatabaseReference) in
                    
                })
                success(ref) //success handler
            }
        })
        
    }
    
    //get all employee list
    public func getAllEmployeeList(success: @escaping (DataSnapshot)->Void, failure: @escaping (Error) -> Void) {
        //get employelist
        employeeListRef?.observe(.value, with: { (snapshot: DataSnapshot) in
            success(snapshot) //success handler
        }, withCancel: { (error:Error) in //check error
            failure(error) //failure handler
        })
    }
    
    //update user data like fname , lname profile image , address, phone number
    public  func updateUserData(userObject: [String:Any] , success: @escaping (DatabaseReference)->Void,
    failure: @escaping (Error) -> Void) { 
        
        //update user data
        userRef?.updateChildValues(userObject, withCompletionBlock: { (error: Error?,ref: DatabaseReference) in
            
            if let currentError = error {
                failure(currentError)//error handler
            } else {
                success(ref) //success handler
            }
        })
    }
    // gets user data
    public func getUserData(success: @escaping (DataSnapshot)->Void, failure: @escaping (Error) -> Void) {
       
        //observe user data
        userRef?.observeSingleEvent(of: .value , with: { (snapshot:DataSnapshot) in
            
            success(snapshot)//success handler
        }, withCancel: { (error:Error) in  // error check
            failure(error) // failure handler
        })
    }
    
    //get employee profile with succes and failure handler
    public func getEmployeeProfile(employeeUid:String ,success: @escaping (DataSnapshot)->Void, failure: @escaping (Error) -> Void) {
        //make profle referece
        var profileRference: DatabaseReference? {
         
            let type :UserTypes = .employee
            
            return databaseReference.child("\(type.rawValue)/\(employeeUid)/\(K.profileTree)")
        }
        
        //save employee profile
        profileRference?.observeSingleEvent(of: .value , with: { (snapshot:DataSnapshot) in
            
            success(snapshot) //success handler
        }, withCancel: { (error:Error) in //check error
            failure(error) //failure handler
        })
    }
    
    //get user profile at firebase with succss and failure handler
    public func getUserProfile(success: @escaping (DataSnapshot)->Void, failure: @escaping (Error) -> Void) {
        
        profileRef?.observeSingleEvent(of: .value , with: { (snapshot:DataSnapshot) in
            
            success(snapshot)//success handler
        }, withCancel: { (error:Error) in//check error
            failure(error) //failure handler
        })
    }
    
    //save profile image with success and failure
    public func saveProfileImage(profileImage:UIImage, success: @escaping (URL)->Void, failure: @escaping (Error) -> Void){
        storageProfileImageRef?.putData(profileImage.imageData! , metadata: metaData, completion: { (metaData : StorageMetadata?, error:Error?) in
            
            if let err = error{ //check error
                failure(err) // error handler
                
            } else {
                // storage image download
                self.storageProfileImageRef?.downloadURL(completion: { (url :URL?, error: Error?) in
                    //check error
                    if let err = error {
                        failure(err) //failure handler
                    } else {
                        success(url!) //success handler
                    }
                })
            }
        })
    }
    
    // update profile at firebase with success and failure call back
    public  func updateProfile(userObject: [String:Any] , success: @escaping (DatabaseReference)->Void,
    failure: @escaping (Error) -> Void) {
        
        profileRef?.updateChildValues(userObject, withCompletionBlock: { (error: Error?,ref: DatabaseReference) in
            
            if let currentError = error { // check error
                failure(currentError) // error handler
            } else {
                success(ref) //success handler
            }
        })
    }
    
    //save profile data in fireabas with success and failure handler
    public  func saveProfile(userObject: [String:Any] , success: @escaping (DatabaseReference)->Void,
    failure: @escaping (Error) -> Void) {
        
        //save data in firebase
        profileRef?.setValue(userObject, withCompletionBlock: { (error:Error?, ref: DatabaseReference) in
            
            if let currentError = error { //check error
                failure(currentError) //failure handler
            } else {
                success(ref) // success handler
            }
        })
    }
    
    // send passoword reset link. when user forgot password
    public func sendPasswordReset(email:String ,success: @escaping (Bool)->Void,
    failure: @escaping (Error) -> Void ) {
        
        // send request for reset password
        fireBaseAuth?.sendPasswordReset(withEmail: email, completion: { (error:Error?) in
            if let currentError = error { //check error
                failure(currentError) //failure handler
            } else {
                success(true) //success hadler
            }
        })
    }
    
    //Create user at firebase with email and password with success handler as a autdateResult
    public func createUser (email:String ,password:String, success: @escaping (AuthDataResult)->Void,
    failure: @escaping (Error) -> Void ) {
        fireBaseAuth?.createUser(withEmail: email, password: password, completion: { (authResult : AuthDataResult?, error: Error?) in
            
            if let currentError = error { //check error
                failure(currentError) //error handler
            } else {
                success(authResult!) // success handler
            }
        })
    }
    
    /*
     Employee Menu
     there r 3 option
     1 - my sheets
     2 - Job request
     3 - Setting
     */
    
    // MARK: - Global Menu Items -
    func dashboardEmpoyeeMenuItems() -> [MenuItems] {
        
        var menuItems: [MenuItems] = []
        
        menuItems.append(MenuItems(title: "Accepted Job",
                                           imageIconName: "mysheets_icon",
                                           vcId: R.ViewControllerIds.MySheetsVC,
                                           storyboard: R.StoryboardRef.EmployeeStoryboard,
                                           isViewController: true))
        
        menuItems.append(MenuItems(title: "My jobs",
                                           imageIconName: "job_meesage_icon",
                                           vcId: R.ViewControllerIds.jobRequestVC,
                                           storyboard: R.StoryboardRef.EmployeeStoryboard,
                                           isViewController: true))

        menuItems.append(MenuItems(title: "Setting",
                                           imageIconName: "setting_icon",
                                           vcId: R.ViewControllerIds.SettingVC,
                                           storyboard: R.StoryboardRef.Main,
                                           isViewController: true))
        
        return menuItems
    }
    
    /**
     
     Manager dashboard menu
     there r 4 option
     1 - Employee
     2- Inbox
     3- Time sheet
     4 -Setting
     */
    // MARK: - Global Menu Items -
    func dashboardManagerMenuItems() -> [MenuItems] {
        
        var menuItems: [MenuItems] = []
        
        
        menuItems.append(MenuItems(title: "Crew",
                                           imageIconName: "new_emplyee_icon",
                                           vcId: R.ViewControllerIds.EmployeeVC,
                                           storyboard: R.StoryboardRef.Main,
                                           isViewController: true))

        menuItems.append(MenuItems(title: "Jobs",
                                           imageIconName: "job_meesage_icon",
                                           vcId: R.ViewControllerIds.JobMessagesVC,
                                           storyboard: R.StoryboardRef.Main,
                                           isViewController: true))
        
        menuItems.append(MenuItems(title: "Time Sheets",
                                           imageIconName: "timetable_icon",
                                           vcId: R.ViewControllerIds.EmployeeVC,
                                           storyboard: R.StoryboardRef.Main,
                                           isViewController: true))
        
        menuItems.append(MenuItems(title: "Setting",
                                           imageIconName: "setting_icon",
                                           vcId: R.ViewControllerIds.SettingVC,
                                           storyboard: R.StoryboardRef.Main,
                                           isViewController: true))
        
        return menuItems
    }
    
    //Create app setting menu
    // need 2 option in menu
    //1 user Profile
    //2 logout
    func settingMenuItems() -> [MenuItems] {
        
        var menuItems: [MenuItems] = []
        
        
        menuItems.append(MenuItems(title: "Profile",
                                           imageIconName: "edit_user_icon",
                                           vcId: R.ViewControllerIds.ProfileUpdateVC,
                                           storyboard: R.StoryboardRef.Main,
                                           isViewController: true))

        menuItems.append(MenuItems(title: "Logout",
                                           imageIconName: "logout_icon",
                                           vcId: nil,
                                           storyboard: nil,
                                           isViewController: false))
        
        return menuItems
    }
}
