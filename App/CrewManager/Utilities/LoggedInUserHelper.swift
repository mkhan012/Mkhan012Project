//
//  LoggedInUserHelper.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit

typealias CurrentUser = LoggedInUserHelper

/*Files are used to store data in files localy*/
let UserInfoFileName = "UserInfo.dat" //Store User information in file
let UserLoginFromFileName = "UserInfo.dat" // Store User Login From Information
let UserProfileName = "UserProfile.dat" // Store User Profile data in file

//This class help the user to store data
class LoggedInUserHelper: NSObject {

    //MARK:- Shared Instance
    static let sharedInstance = LoggedInUserHelper() //static instance of class
    
    
    //MARK:- Init
    // Constructor initlizer of initlize the data
    override init() {
        
        super.init() // super method initlize
        // get data from file and store/initlize local object of class
        self.userData = self.getWrittenFile(UserInfoFileName) as? [String: Any]
        
        // check null pointer in user data object for fobbdien to crash
        if let userDict = self.userData {
            //get user Type and cast in string obj
            if let type = userDict["user_type"] as? String {
                //initlize the UserType object
                if let type = UserTypes(rawValue: type) {
                    self.userType = type // assign the value locall object
                    ServicesManager.userType = type // assign type to servercis manager
                }
            }
        }
    }
    
    
    //MARK:- Public Methods
    //This method is work as constructore/ initlizer
    //
    open class func setLoggedInUserInfo(_ user: [String : Any]) {
        
        let currentUser = CurrentUser.sharedInstance // create instance
         
        currentUser.userData = user // assign user data to locall ojects
        
        if let typeString = user["user_type"] as? String { // cast the user type in string
            
            if let userType = UserTypes(rawValue: typeString) { // make User object
                
                currentUser.userType = userType // assign userType to locall object
                ServicesManager.userType = userType // assign type to servercis manager
            }
        }
        //write file of User information
        currentUser.writeFile(user as AnyObject, fileName: UserInfoFileName)
    }
    
    //MARK:- Internal/Private Variables
    open var userType: UserTypes! //store user type
    open var userData: [String: Any]? // store User data
    open var fullName : String { // get and store full user name
        
        get {
            if let user = self.userProfileData, let fname = user["fname"] as? String, let lname = user["lname"] as? String {
                return fname + " " +  lname
            }
            return ""
        }
    }
    
    // call when user logout and want to reset all User information
    fileprivate static func resetCurrentUser() {
        
        let currentUser = CurrentUser.sharedInstance // instance of current user
        
        currentUser.userData = nil // remove user data locall objects
        currentUser.removeWrittenFile(UserInfoFileName) // remove data from file
        currentUser.removeWrittenFile(UserProfileName) // remove profile data from file
    }
    
    // logoutUSer call on logout
    open class func logoutUser() {
        
        resetCurrentUser() // remove information
        // remove notificaiton bagage
        UIApplication.shared.applicationIconBadgeNumber = 0
        // remove all data store in locally in app
        clearUserDefaults()
        
    }
    
    //MARK:- Internal/Private Methods
//    this veriable used to get and set UserProfile Data
    open var userProfileData: [String: Any]? {
        get{ // get user information from file
            let currentUser = CurrentUser.sharedInstance
            
            if let infoData = currentUser.getWrittenFile(UserProfileName) as? [String: Any] {
                return infoData
                
            }else {
                return nil
            }
        }
        set(newValue){ // Save user information in file
            
            let currentUser = CurrentUser.sharedInstance
            
            if let infoData = newValue {
                currentUser.writeFile(infoData as AnyObject, fileName: UserProfileName)
            } else {
                currentUser.removeWrittenFile(UserInfoFileName)
            }
        }
    }
    //User to get and set User information
    open var userInfo: [String: Any]? {
        get{ // get user infromation
            let currentUser = CurrentUser.sharedInstance
            
            if let infoData = currentUser.getWrittenFile(UserInfoFileName) as? [String: Any] {
                return infoData
                
            }else {
                return nil
            }
        }
        set(newValue){ // set user information
            
            let currentUser = CurrentUser.sharedInstance
            
            if let infoData = newValue {
                currentUser.writeFile(infoData as AnyObject, fileName: UserInfoFileName)
            } else {
                currentUser.removeWrittenFile(UserInfoFileName)
            }
        }
    }
    //loginFrom is used to store and get loginFrom data
    open var loginFrom: String? {
        get{ // get information
            let currentUser = CurrentUser.sharedInstance
            
            if let info = currentUser.getWrittenFile(UserLoginFromFileName) as? String {
                return info
                
            }else {
                return nil
            }
        }
        set(newValue){ // store data
            
            let currentUser = CurrentUser.sharedInstance
            
            if let info = newValue {
                currentUser.writeFile(info as AnyObject, fileName: UserLoginFromFileName)
            } else {
                currentUser.removeWrittenFile(UserInfoFileName)
            }
        }
    }
    // clear and remove all data in app PersistentDomain
    fileprivate class func clearUserDefaults() {
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
    }
    //get temprarypath for  files
    fileprivate func documentDirectoryPathForFileNamed(_ fileName: String) -> String {
    
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.stringByAppendingPathComponent(fileName)
    }
    // store data or files in path
    fileprivate func writeFile(_ file: AnyObject, fileName: String) {
        
        if !NSKeyedArchiver.archiveRootObject(file,
                                              toFile: self.documentDirectoryPathForFileNamed(fileName)) {
            print(" ---- Error ---- \n\nSaving Data List\n\n ---- Error ---- ")
        }
    }
    //get data or filesfrom path
     func getWrittenFile(_ fileName: String) -> AnyObject? {
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: self.documentDirectoryPathForFileNamed(fileName)) as AnyObject?
    }
    //remove files from path
    fileprivate func removeWrittenFile(_ fileName: String) {
        
        do {
            try FileManager.default.removeItem(atPath: self.documentDirectoryPathForFileNamed(fileName))
        } catch {
            print("Unable to delete the file. It does not exist: \(fileName)")
        }
    }
}
