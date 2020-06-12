//
//  SettingViewController.swift
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

//
class SettingViewController: UIViewController {
    
    //MARK:-IBOutlet
    @IBOutlet weak var tblDashboard: UITableView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    
    //MARK:- public Variable
    var menuItems: [MenuItems] {
        //check user type
        if CurrentUser.sharedInstance.userType == .manger {
            // return menu name list
            return ServicesManager.settingMenuItems()
            
        } else  {
            
            return ServicesManager.settingMenuItems()
        }
    }
    
    
    //MARK:- View life Cyclic
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblName.text = CurrentUser.sharedInstance.fullName // show the user name
        if let userProfileData = CurrentUser.sharedInstance.userProfileData  { // get user profile data
             
            if let photoURL = userProfileData["photoURL"] as? String {// get user photoURL
                
                guard let url = URL(string: photoURL) else { return }
                ImageService.getImage(withURL: url) { image in // get image from firebase server
                    self.profileImage.image = image //set profile image
                }
            }
        }
        

        
        self.title = "Setting" // set title
        self.setupTableView() // setup table
    }
    
    
    //MARK:- Private methods
    fileprivate func setupTableView() {
        // register tableview nib
        self.tblDashboard.register(UINib(nibName: R.Nibs.Dashboardell, bundle: nil), forCellReuseIdentifier: R.CellIdentifiers.Dashboardell)
        
        self.tblDashboard.delegate = self // set delegate
        self.tblDashboard.dataSource = self // set data source
        
        self.tblDashboard.tableFooterView = UIView() // remove tableview footer
    }
}

//MARK:- TableViewDataSource
extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count //number of cells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.CellIdentifiers.Dashboardell,
                                                 for: indexPath) as! ListTableViewCell
        
        let item = menuItems[indexPath.row] // get index
        cell.imageMenu.image = UIImage(named:item.imageIconName) //show image
        cell.lblTitle.text = item.title // set title
        
        return cell
    }
}


//MARK:- TableViewDelegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // index informaiton
        let item = menuItems[indexPath.row]
        // get viewcontroller with identifer
        if let identifer = item.viewControllerIdentifier , let vc = item.storyboard?.instantiateViewController(identifier: identifer) {
            // push view controller
            self.push(vc)
        } else {// show confirmation view
            self.showConfirmationAlertView(title: "Confirmation", message: "Are you sure you want to logout?", confirmationHandler: {
                // show loading activity
                self.showLoadingActivity()
                // get user data from firebase
                ServicesManager.getUserData(success: { (snapshot:DataSnapshot) in
                    
                    
                    if let dic = snapshot.value as? [String:Any] , let env = dic["login_from"] as? String {
                        //environment variable google
                        if env == "google" {
                         // logout from google
                            GIDSignIn.sharedInstance().signOut()
                            // environemnt variable facebook 
                        } else if env == "facebook" {
                         //logout from facebook
                            ServicesManager.fbLoginManager.logOut() // this is an instance function
                        }
                    }
                    // hide loading activity
                    self.hideLoadingActivity()
                }) { (error:Error) in//show error message
                    
                    self.hideLoadingActivity()// hide loading activity
                    //shwo error message
                    SwiftMessages.showToast(error.localizedDescription, type: .error)
                }
                // logout from facebok
                ServicesManager.fbLoginManager.logOut() // this is an instance function
                
                do {// logout firebase
                    try Auth.auth().signOut()
                    // fire the logout notification
                    NotificationCenter.default.post(name: Notification.Name("com.user.logout"), object: nil)
                    // catatch error
                } catch let err {
                    //show error
                    SwiftMessages.showToast(err.localizedDescription, type: .error)
                }
                // logout current user and remove all current user info
                CurrentUser.logoutUser()
                let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.WellComeVC)
                self.setRoot(for: vc)
                
                self.hideLoadingActivity()
            })
        }
    }
}
