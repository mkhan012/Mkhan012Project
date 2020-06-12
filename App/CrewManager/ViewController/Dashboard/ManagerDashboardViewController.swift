//
//  ManagerDashboardViewController.swift
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


class ManagerDashboardViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet var collectionView: UICollectionView! // collection view for menu
    @IBOutlet var lblName: UILabel! // title label in the view
    @IBOutlet var profileImage: UIImageView! // app logo view
    
    
    //MARK:- Variable
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet // show alert as action sheet
    var menuItems: [MenuItems] { // menu create
        // user type
        if CurrentUser.sharedInstance.userType == .manger {
            
            // get manager type menu list
            return ServicesManager.dashboardManagerMenuItems()
        }else  {
            
            // get emplyeee menu items list
            return ServicesManager.dashboardEmpoyeeMenuItems()
        }
    }
    
    //MARK:- View life cyclic method
    override func viewDidLoad() {
        super.viewDidLoad()

        //set observer for logout condition
        NotificationCenter.default.addObserver(self, selector: #selector(ManagerDashboardViewController.userLogout), name:.logout, object: nil)
        
        //set title
        self.title = "Dashboard"
        
        //setup collection and feed the data to view
        self.setupCollectionView()
        
        // set view title label
         self.lblName.text = "Wellcome to Crew"
        
        //Background API's call
        self.observeProfile()
    }
    
    // setup collection view
    fileprivate func setupCollectionView() {
                //register cell in collection view (get cell from nib)
        self.collectionView.register(UINib(nibName: R.Nibs.DashMenuCell, bundle: nil), forCellWithReuseIdentifier: R.CellIdentifiers.DashMenuCell)
        
        
        self.collectionView.delegate = self //set delegate
        self.collectionView.dataSource = self //set data source
        
        // set layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // set layout edges insets
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        //set layout item size
        layout.itemSize = CGSize(width: (screenWidth / 2) - 15 , height: screenWidth/3)
        //set minmium spacing between the view
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        //assign the layout to the collection view
        collectionView.collectionViewLayout = layout
        
    }
    
    //MARK:- Private
    //user logout
    @objc func userLogout() {
        do {
            //logout from firebase
            try Auth.auth().signOut()
            //error handler 
        } catch let err {
            //show error
            SwiftMessages.showToast(err.localizedDescription, type: .error)
        }
        //show login view
        let vc = R.StoryboardRef.Main.instantiateViewController(withIdentifier: R.ViewControllerIds.LoginVC)
        self.setRoot(for: vc)
    }
    
    //get user profile data
    func observeProfile() {
        //show loading activity
        self.showLoadingActivity()
        //get user profile from firebase with success and failuer call back
        ServicesManager.getUserProfile(success: { (snapshot:DataSnapshot) in
            
            // get values
            if let values = snapshot.value as? [String:Any] {
             // set user profile data
                CurrentUser.sharedInstance.userProfileData = values
            }
            //hide loading activty
            self.hideLoadingActivity()
        }) { (error:Error) in //error handler
            //show error
            SwiftMessages.showToast(error.localizedDescription, type: .error)
            //hide loading activity
            self.hideLoadingActivity()
        }
    }
}
//layout delegate methods
extension ManagerDashboardViewController: UICollectionViewDelegateFlowLayout {
    
}

//MARK:- UICollectionViewDataSource methdos
extension ManagerDashboardViewController: UICollectionViewDataSource {
    //number of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menuItems.count
    }
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get cell from nib
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: R.CellIdentifiers.DashMenuCell, for: indexPath) as! DashboardCollectionViewCell
        
        //get menu data from menu items
        let item = menuItems[indexPath.row]
        // get menu image
        cell.imageMenu.image = UIImage(named:item.imageIconName)
        // get titiel
        cell.lblTitle.text = item.title
        
        //return cell
        return cell
        
    }
}

// MARK: - UICollectionViewFlowLayout
extension ManagerDashboardViewController: UICollectionViewDelegate {
    
    //selected row
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = menuItems[indexPath.row] // get selected item
        
        // push view controller
        if let identifer = item.viewControllerIdentifier , let vc = item.storyboard?.instantiateViewController(identifier: identifer) {
            
            if indexPath.row == 2 && CurrentUser.sharedInstance.userType == .manger {
                (vc as? EmployeeViewController)?.isTimeSheets = true
            }
            self.push(vc)
        }
    }
}


